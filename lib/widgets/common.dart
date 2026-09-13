import 'package:flutter/material.dart';

import '../models/order.dart';
import '../theme/app_theme.dart';

/// Mirrors <Stars rating /> in components/UI.jsx.
class Stars extends StatelessWidget {
  final double rating;
  final double size;
  const Stars({super.key, required this.rating, this.size = 16});

  @override
  Widget build(BuildContext context) {
    final full = rating.floor();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < full ? Icons.star : Icons.star_border,
          size: size,
          color: AppColors.saffron,
        );
      }),
    );
  }
}

class Loader extends StatelessWidget {
  final String label;
  const Loader({super.key, this.label = 'Loading…'});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          const CircularProgressIndicator(color: AppColors.ember500),
          const SizedBox(height: 16),
          Text(label, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;
  const EmptyState({super.key, required this.title, this.subtitle, this.action});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.ink950),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(subtitle!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
          ],
          if (action != null) ...[const SizedBox(height: 16), action!],
        ],
      ),
    );
  }
}

class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  const ErrorState({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Column(
        children: [
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.ember700, fontWeight: FontWeight.w600)),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ],
      ),
    );
  }
}

Color statusColor(String status) {
  switch (status) {
    case OrderStatus.preparing:
      return AppColors.statusPreparing;
    case OrderStatus.ready:
      return AppColors.statusReady;
    case OrderStatus.outForDelivery:
      return AppColors.statusOutForDelivery;
    case OrderStatus.delivered:
      return AppColors.statusDelivered;
    case OrderStatus.cancel:
      return AppColors.statusCancel;
    default:
      return Colors.grey;
  }
}

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(999)),
      child: Text(
        OrderStatus.label(status),
        style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 12),
      ),
    );
  }
}
