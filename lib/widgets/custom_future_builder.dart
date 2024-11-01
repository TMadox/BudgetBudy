import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';

class CustomFutureBuilder<T> extends StatelessWidget {
  final bool rememberFutureResult;
  final Future<T>? future;
  final Widget Function(T) whenDone;
  final Widget? whenNotDone;
  const CustomFutureBuilder({super.key, this.rememberFutureResult = true, this.future, required this.whenDone, this.whenNotDone});

  @override
  Widget build(BuildContext context) {
    return EnhancedFutureBuilder<T>(
      future: future,
      rememberFutureResult: rememberFutureResult,
      whenDone: whenDone,
      whenNotDone:whenNotDone?? const Center(child: CircularProgressIndicator()),
      whenError: (error) => Center(child: Text(error.toString())),
    );
  }
}
