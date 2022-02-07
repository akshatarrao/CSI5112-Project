import 'package:csi5112_frontend/dataModal/model.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatefulWidget {
  final Function(int) _onMenuItemSelection;

  const SideMenu({Key? key, required Function(int) onMenuItemSelection})
      : _onMenuItemSelection = onMenuItemSelection,
        super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 32),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              menuItems[index].menuIcon,
                              color: index == _currentPage
                                  ? Colors.pink.shade900
                                  : Colors.black,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              menuItems[index].menuName,
                              style: TextStyle(
                                color: index == _currentPage
                                    ? Colors.pink.shade900
                                    : Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        onTap: _currentPage == index
                            ? () {}
                            : () {
                                widget._onMenuItemSelection(index);
                                setState(() {
                                  _currentPage = index;
                                });
                              },
                      ),
                    );
                  },
                  itemCount: menuItems.length,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
