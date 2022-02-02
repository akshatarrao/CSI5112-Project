import 'package:flutter/material.dart';

class DefaultDivider {
  // Reusable divider
  static getDefaultDivider(context) {
    return Divider(
        thickness: 1,
        indent: 100,
        endIndent: 100,
        color: Theme.of(context).primaryColor);
  }
}
