import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A widget that blocks navigation pop events and optionally prompts the user
/// with a confirmation dialog before exiting the app.
///
/// This widget uses [PopScope] to control whether the user can navigate back
/// and handles pop events accordingly.
///
/// If [canPop] is `false`, an exit confirmation dialog is shown when the user
/// tries to navigate back.
class PopBlocker extends StatelessWidget {
  /// The child widget that this `PopBlocker` wraps.
  final Widget child;

  /// Determines whether the user can navigate back.
  ///
  /// If `true`, the user can navigate back normally.
  /// If `false`, a confirmation dialog is shown when the user attempts to exit.
  final bool canPop;

  /// Creates a `PopBlocker` widget.
  ///
  /// The [child] parameter is required. The [canPop] parameter defaults to `false`.
  const PopBlocker({super.key, required this.child, this.canPop = false});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _showExitDialog(context);
      },
      child: child,
    );
  }

  /// Displays an exit confirmation dialog.
  ///
  /// If the user confirms, the app exits using [SystemNavigator.pop()].
  /// Otherwise, the dialog is dismissed.
  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
              'Are you sure you want to exit the app? All unsaved progress will be lost!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
