import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/food.dart';
import '../services/category_service.dart';
import '../services/food_service.dart';
import '../widgets/category_strip.dart';
import '../widgets/common.dart';
import '../widgets/food_card.dart';

enum _SortOption { popular, rating, priceAsc, priceDesc }

/// Mirrors app/menu/page.jsx — search box, sort dropdown, category strip,
/// responsive results grid, all filtered client-side same as the website.
class MenuScreen extends StatefulWidget {
  final String? initialCategory;
  const MenuScreen({super.key, this.initialCategory});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  final _foodService = FoodService();
  final _categoryService = CategoryService();
  final _searchController = TextEditingController();

  List<Food> _foods = [];
  List<FoodCategory> _categories = [];
  String _status = 'loading';
  String? _activeCategory;
  String _query = '';
  _SortOption _sort = _SortOption.popular;

  @override
  void initState() {
    super.initState();
    _activeCategory = widget.initialCategory;
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

  List<Food> get _filtered {
    var list = [..._foods];
    if (_activeCategory != null) {
      list = list.where((f) => f.category == _activeCategory).toList();
    }
    if (_query.trim().isNotEmpty) {
      final q = _query.toLowerCase();
      list = list.where((f) => f.name.toLowerCase().contains(q) || f.description.toLowerCase().contains(q)).toList();
    }
    switch (_sort) {
      case _SortOption.priceAsc:
        list.sort((a, b) => a.currentPrice.compareTo(b.currentPrice));
        break;
      case _SortOption.priceDesc:
        list.sort((a, b) => b.currentPrice.compareTo(a.currentPrice));
        break;
      case _SortOption.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case _SortOption.popular:
        list.sort((a, b) => (b.isPopular ? 1 : 0) - (a.isPopular ? 1 : 0));
        break;
    }
    return list;
  }

  bool get _hasFilters => _activeCategory != null || _query.trim().isNotEmpty;

  void _clearAll() {
    setState(() {
      _activeCategory = null;
      _query = '';
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      appBar: AppBar(title: const Text('Our menu')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _query = v),
                    decoration: InputDecoration(
                      hintText: 'Search dishes…',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _query.isNotEmpty
                          ? IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() { _query = ''; _searchController.clear(); }))
                          : null,
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<_SortOption>(
                  initialValue: _sort,
                  onSelected: (v) => setState(() => _sort = v),
                  icon: const Icon(Icons.sort),
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: _SortOption.popular, child: Text('Popular')),
                    PopupMenuItem(value: _SortOption.rating, child: Text('Top rated')),
                    PopupMenuItem(value: _SortOption.priceAsc, child: Text('Price ↑')),
                    PopupMenuItem(value: _SortOption.priceDesc, child: Text('Price ↓')),
                  ],
                ),
              ],
            ),
          ),
          if (_status == 'ready')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CategoryStrip(
                categories: _categories,
                active: _activeCategory,
                onSelect: (c) => setState(() => _activeCategory = c),
              ),
            ),
          if (_status == 'ready')
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${filtered.length} ${filtered.length == 1 ? 'dish' : 'dishes'}', style: const TextStyle(color: Colors.black54, fontSize: 13)),
                  if (_hasFilters) TextButton(onPressed: _clearAll, child: const Text('Clear all')),
                ],
              ),
            ),
          Expanded(
            child: Builder(builder: (context) {
              if (_status == 'loading') return const Loader(label: 'Loading the menu…');
              if (_status == 'error') {
                return ErrorState(
                  message: "Couldn't load the menu — check that the backend API is running.",
                  onRetry: _load,
                );
              }
              if (filtered.isEmpty) {
                return EmptyState(
                  title: 'No dishes match your search',
                  subtitle: 'Try a different category or clear your search.',
                  action: _hasFilters ? ElevatedButton(onPressed: _clearAll, child: const Text('Clear filters')) : null,
                );
              }
              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                itemCount: filtered.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.58,
                ),
                itemBuilder: (context, i) => FoodCard(food: filtered[i]),
              );
            }),
          ),
        ],
      ),
    );
  }
}
