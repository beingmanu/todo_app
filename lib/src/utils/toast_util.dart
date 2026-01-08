import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import 'constants/colors.dart';

/// A singleton service for displaying toast messages throughout the app.
class ToastService {
  // Singleton instance
  static final ToastService _instance = ToastService._internal();

  // Factory constructor to return the singleton instance
  factory ToastService() => _instance;

  // Private constructor
  ToastService._internal();

  /// Flag to track if a toast is currently being shown
  bool _isShowing = false;

  /// Default duration for toasts
  final Duration defaultDuration = const Duration(seconds: 3);

  /// Default alignment for toasts (bottom center)
  final Alignment defaultAlignment = Alignment.bottomCenter;

  /// Default background color for error toasts
  final Color errorBackground = Colors.red;

  /// Default text color for toasts
  final Color textColor = BlackAndWhiteColors.kBlack;

  /// Default background color for success toasts
  final Color successBackground = Colors.green;

  /// Default background color for info toasts
  final Color infoBackground = Colors.blue;

  /// Default background color for warning toasts
  final Color warningBackground = Colors.orange;

  /// Shared callback to reset _isShowing when a toast completes or is dismissed
  final ToastificationCallbacks _callbacks = ToastificationCallbacks(
    onAutoCompleteCompleted: (_) {
      _instance._isShowing = false;
      toastification.dismissAll();
    },
    onDismissed: (_) {
      _instance._isShowing = false;
      toastification.dismissAll();
    },
    onCloseButtonTap: (_) {
      _instance._isShowing = false;
      toastification.dismissAll();
    },
    onTap: (_) {
      _instance._isShowing = false;
      toastification.dismissAll();
    },
  );

  /// Shows a toast with the provided message and optional parameters.
  void show(
    String message, {
    Duration? duration,
    Alignment? alignment,
    Color? backgroundColor,
    TextStyle? textStyle,
    double? radius,
    double? padding,
  }) {
    // Only show the toast if no other toast is currently being shown
    if (_isShowing) return;

    _isShowing = true;
    toastification.dismissAll(); // Clear any lingering toasts

    toastification.show(
      title: Text(message, style: textStyle ?? TextStyle(color: textColor)),
      autoCloseDuration: duration ?? defaultDuration,
      alignment: alignment ?? defaultAlignment,
      borderRadius: radius != null ? BorderRadius.circular(radius) : null,
      padding: padding != null
          ? EdgeInsets.all(padding)
          : const EdgeInsets.all(8.0),
      type: ToastificationType.info,
      style: ToastificationStyle.minimal,
      callbacks: _callbacks,
    );
  }

  /// Shows an error toast.
  void error(
    String? message, {
    Duration? duration,
    Alignment? alignment,
    TextStyle? textStyle,
    double? radius,
    double? padding,
  }) {
    // Only show the toast if no other toast is currently being shown
    if (_isShowing) return;

    _isShowing = true;
    toastification.dismissAll(); // Clear any lingering toasts

    toastification.show(
      title: Text(
        message ?? 'Something went wrong',
        style: textStyle ?? TextStyle(color: textColor),
      ),
      autoCloseDuration: duration ?? defaultDuration,
      alignment: alignment ?? defaultAlignment,
      type: ToastificationType.error,
      style: ToastificationStyle.minimal,
      borderRadius: radius != null ? BorderRadius.circular(radius) : null,
      padding: padding != null
          ? EdgeInsets.all(padding)
          : const EdgeInsets.all(8.0),
      callbacks: _callbacks,
    );
  }

  /// Shows a success toast.
  void success(
    String message, {
    Duration? duration,
    Alignment? alignment,
    TextStyle? textStyle,
    double? radius,
    double? padding,
  }) {
    // Only show the toast if no other toast is currently being shown
    if (_isShowing) return;

    _isShowing = true;
    toastification.dismissAll(); // Clear any lingering toasts

    toastification.show(
      title: Text(message, style: textStyle ?? TextStyle(color: textColor)),
      autoCloseDuration: duration ?? defaultDuration,
      alignment: alignment ?? defaultAlignment,
      type: ToastificationType.success,
      style: ToastificationStyle.minimal,
      borderRadius: radius != null ? BorderRadius.circular(radius) : null,
      padding: padding != null
          ? EdgeInsets.all(padding)
          : const EdgeInsets.all(8.0),
      callbacks: _callbacks,
    );
  }

  /// Shows an info toast.
  void info(
    String message, {
    Duration? duration,
    Alignment? alignment,
    TextStyle? textStyle,
    double? radius,
    double? padding,
  }) {
    // Only show the toast if no other toast is currently being shown
    if (_isShowing) return;

    _isShowing = true;
    toastification.dismissAll(); // Clear any lingering toasts

    toastification.show(
      title: Text(message, style: textStyle ?? TextStyle(color: textColor)),
      autoCloseDuration: duration ?? defaultDuration,
      alignment: alignment ?? defaultAlignment,
      type: ToastificationType.info,
      style: ToastificationStyle.minimal,
      borderRadius: radius != null ? BorderRadius.circular(radius) : null,
      padding: padding != null
          ? EdgeInsets.all(padding)
          : const EdgeInsets.all(8.0),
      callbacks: _callbacks,
    );
  }

  /// Shows a warning toast.
  void warning(
    String message, {
    Duration? duration,
    Alignment? alignment,
    TextStyle? textStyle,
    double? radius,
    double? padding,
  }) {
    // Only show the toast if no other toast is currently being shown
    if (_isShowing) return;

    _isShowing = true;
    toastification.dismissAll(); // Clear any lingering toasts

    toastification.show(
      title: Text(message, style: textStyle ?? TextStyle(color: textColor)),
      autoCloseDuration: duration ?? defaultDuration,
      alignment: alignment ?? defaultAlignment,
      type: ToastificationType.warning,
      style: ToastificationStyle.minimal,
      borderRadius: radius != null ? BorderRadius.circular(radius) : null,
      padding: padding != null
          ? EdgeInsets.all(padding)
          : const EdgeInsets.all(8.0),
      callbacks: _callbacks,
    );
  }

  /// Dismisses any currently showing toasts.
  void dismiss() {
    toastification.dismissAll();
    _isShowing = false; // Reset flag when manually dismissed
  }
}
