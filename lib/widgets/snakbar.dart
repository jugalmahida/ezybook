import 'package:flutter/material.dart';

ScaffoldFeatureController getSnakbar(String error, BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(error),
    ),
  );
}
