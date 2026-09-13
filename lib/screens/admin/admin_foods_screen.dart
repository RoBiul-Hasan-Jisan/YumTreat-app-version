import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../../models/food.dart';
import '../../services/category_service.dart';
import '../../services/food_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common.dart';
import '../../widgets/food_image.dart';
import 'admin_guard.dart';

/// Mirrors app/admin/foods/page.jsx — list + add/edit modal + delete.
class AdminFoodsScreen extends StatelessWidget {
  const AdminFoodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminGuard(child: _FoodsManager());
  }
}

class _FoodsManager extends StatefulWidget {
  const _FoodsManager();

  @override
  State<_FoodsManager> createState() => _FoodsManagerState();
}

class _FoodsManagerState extends State<_FoodsManager> {
  final _foodService = FoodService();
  final _categoryService = CategoryService();

  List<Food> _foods = [];
  List<FoodCategory> _categories = [];
  String _status = 'loading';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _status = 'loading');
    try {
      final results = await Future.wait([_foodService.getFoods(), _categoryService.getCategories()]);
      setState(() {
        _foods = results[0] as List<Food>;
        _categories = results[1] as List<FoodCategory>;
        _status = 'ready';
      });
    } catch (_) {
      setState(() => _status = 'error');
    }
  }

  Future<void> _delete(Food food) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this menu item?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true) return;
    await _foodService.deleteFood(food.id);
    setState(() => _foods = _foods.where((f) => f.id != food.id).toList());
  }

  Future<void> _openForm({Food? food}) async {
    final result = await showModalBottomSheet<Food>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _FoodFormSheet(
        food: food,
        categories: _categories,
        foodService: _foodService,
      ),
    );
    if (result != null) {
      setState(() {
        if (food == null) {
          _foods = [result, ..._foods];
        } else {
          _foods = _foods.map((f) => f.id == result.id ? result : f).toList();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu items'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: () => _openForm()),
        ],
      ),
      body: Builder(builder: (context) {
        if (_status == 'loading') return const Loader(label: 'Loading menu items…');
        if (_status == 'error') return ErrorState(message: "Couldn't load menu items.", onRetry: _load);
        if (_foods.isEmpty) {
          return EmptyState(
            title: 'No dishes yet',
            subtitle: 'Add your first menu item to get started.',
            action: ElevatedButton(onPressed: () => _openForm(), child: const Text('Add dish')),
          );
        }
        return RefreshIndicator(
          onRefresh: _load,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _foods.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final food = _foods[i];
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 12)]),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: AppColors.ember50, borderRadius: BorderRadius.circular(12)),
                      child: FoodImage(imageUrl: food.imageUrl),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(food.name, style: const TextStyle(fontWeight: FontWeight.w800), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(food.category, style: const TextStyle(color: Colors.black45, fontSize: 12)),
                          Row(
                            children: [
                              Text('\$${food.currentPrice.toStringAsFixed(2)}', style: const TextStyle(color: AppColors.ember600, fontWeight: FontWeight.w700, fontSize: 12)),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: food.isAvailable ? const Color(0x1A10B981) : const Color(0x0D0B0A08),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  food.isAvailable ? 'Available' : 'Hidden',
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: food.isAvailable ? const Color(0xFF10B981) : Colors.black45),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.edit_outlined, size: 18), onPressed: () => _openForm(food: food)),
                    IconButton(icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.ember700), onPressed: () => _delete(food)),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class _FoodFormSheet extends StatefulWidget {
  final Food? food;
  final List<FoodCategory> categories;
  final FoodService foodService;

  const _FoodFormSheet({required this.food, required this.categories, required this.foodService});

  @override
  State<_FoodFormSheet> createState() => _FoodFormSheetState();
}

class _FoodFormSheetState extends State<_FoodFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.food?.name ?? '');
  late final _description = TextEditingController(text: widget.food?.description ?? '');
  late final _imageUrl = TextEditingController(text: widget.food?.imageUrl ?? '');
  late final _currentPrice = TextEditingController(text: widget.food?.currentPrice.toString() ?? '');
  late final _pastPrice = TextEditingController(text: widget.food?.pastPrice?.toString() ?? '');
  String? _category;
  bool _isPopular = false;
  bool _isSpecial = false;
  bool _isSuperDeals = false;
  bool _isAvailable = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final f = widget.food;
    _category = f?.category ?? (widget.categories.isNotEmpty ? widget.categories.first.name : null);
    _isPopular = f?.isPopular ?? false;
    _isSpecial = f?.isSpecial ?? false;
    _isSuperDeals = f?.isSuperDeals ?? false;
    _isAvailable = f?.isAvailable ?? true;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final payload = {
      'name': _name.text.trim(),
      'description': _description.text.trim(),
      'imageUrl': _imageUrl.text.trim(),
      'category': _category,
      'currentPrice': double.tryParse(_currentPrice.text) ?? 0,
      if (_pastPrice.text.trim().isNotEmpty) 'pastPrice': double.tryParse(_pastPrice.text),
      'isPopular': _isPopular,
      'isSpecial': _isSpecial,
      'isSuperDeals': _isSuperDeals,
      'isAvailable': _isAvailable,
    };
    try {
      final result = widget.food == null
          ? await widget.foodService.addFood(payload)
          : await widget.foodService.updateFood(widget.food!.id, payload);
      if (mounted) Navigator.pop(context, result);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Form(
            key: _formKey,
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              children: [
                Text(widget.food == null ? 'Add dish' : 'Edit ${widget.food!.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 16),
                TextFormField(controller: _name, decoration: const InputDecoration(labelText: 'Dish name'), validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 12),
                TextFormField(controller: _description, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3, validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: widget.categories.map((c) => DropdownMenuItem(value: c.name, child: Text(c.name))).toList(),
                  onChanged: (v) => setState(() => _category = v),
                  validator: (v) => v == null ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(controller: _imageUrl, decoration: const InputDecoration(labelText: 'Image key (e.g. burger-1)'), validator: (v) => v!.isEmpty ? 'Required' : null),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _currentPrice,
                        decoration: const InputDecoration(labelText: 'Current price'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) => (v == null || double.tryParse(v) == null) ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _pastPrice,
                        decoration: const InputDecoration(labelText: 'Past price (optional)'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilterChip(label: const Text('Popular'), selected: _isPopular, onSelected: (v) => setState(() => _isPopular = v)),
                    FilterChip(label: const Text('Special'), selected: _isSpecial, onSelected: (v) => setState(() => _isSpecial = v)),
                    FilterChip(label: const Text('Deal'), selected: _isSuperDeals, onSelected: (v) => setState(() => _isSuperDeals = v)),
                    FilterChip(label: const Text('Available'), selected: _isAvailable, onSelected: (v) => setState(() => _isAvailable = v)),
                  ],
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: const TextStyle(color: AppColors.ember700, fontWeight: FontWeight.w600)),
                ],
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _submit,
                    child: Text(_saving ? 'Saving…' : (widget.food == null ? 'Add dish' : 'Save changes')),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
