import 'package:flutter/material.dart';

class MenuItem {
  final String menuName;
  final IconData menuIcon;

  const MenuItem({
    required this.menuName,
    required this.menuIcon,
  });
}

List<MenuItem> cutomerMenuItems = [
  const MenuItem(
    menuName: 'Items List',
    menuIcon: Icons.shopping_bag,
  ),
  const MenuItem(
    menuName: 'Order History',
    menuIcon: Icons.book,
  ),
  const MenuItem(
    menuName: 'Discussion forum',
    menuIcon: Icons.message,
  ),
];

List<MenuItem> merchantMenuItems = [
  const MenuItem(
    menuName: "Item Setup",
    menuIcon: Icons.inventory,
  ),
  const MenuItem(
    menuName: 'Order History',
    menuIcon: Icons.book,
  ),
  const MenuItem(
    menuName: 'Discussion forum',
    menuIcon: Icons.message,
  ),
];

Map<int, Color> color = {
  50: const Color.fromRGBO(255, 92, 87, .1),
  100: const Color.fromRGBO(255, 92, 87, .2),
  200: const Color.fromRGBO(255, 92, 87, .3),
  300: const Color.fromRGBO(255, 92, 87, .4),
  400: const Color.fromRGBO(255, 92, 87, .5),
  500: const Color.fromRGBO(255, 92, 87, .6),
  600: const Color.fromRGBO(255, 92, 87, .7),
  700: const Color.fromRGBO(255, 92, 87, .8),
  800: const Color.fromRGBO(255, 92, 87, .9),
  900: const Color.fromRGBO(255, 92, 87, 1),
};
