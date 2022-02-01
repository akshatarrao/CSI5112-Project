import 'package:flutter/material.dart';

class DefaultDivider {
  // Reusable divider
  static getDefaultDivider(context) {
    return Divider(
        thickness: 1,
        indent: 200,
        endIndent: 200,
        color: Theme.of(context).primaryColor);
  }
}
