import 'package:csi5112_frontend/dataModel/model.dart';
import 'package:csi5112_frontend/page/login_screen.dart';
import 'package:flutter/material.dart';

/// Side menu widget
// ignore: must_be_immutable
class SideMenu extends StatefulWidget {
  final Function(int) _onMenuItemSelection;
  final List<MenuItem> _menuItems;
  int currentPage; // Added so when refressing Page it gets the correct navigation (in particular the Discussion Forum)

  SideMenu(
      {Key? key,
      required Function(int) onMenuItemSelection,
      required List<MenuItem> menuItems,
      this.currentPage = 0})
      : _onMenuItemSelection = onMenuItemSelection,
        _menuItems = menuItems,
        super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

/// Side menu state
class _SideMenuState extends State<SideMenu> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    // Added so when refressing Page it gets the correct navigation (in particular the Discussion Forum)
    _currentPage = widget.currentPage;

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
                              widget._menuItems[index].menuIcon,
                              color: index == _currentPage
                                  ? Colors.pink.shade900
                                  : Colors.black,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              widget._menuItems[index].menuName,
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
                  itemCount: widget._menuItems.length,
                ),
                const SizedBox(height: 16),
              ]+ [
                Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        child: Row(
                          children: const <Widget>[
                            Icon(
                              Icons.logout,
                              color: Colors.black,
                            ),
                            SizedBox(width: 16),
                            Text(
                              "Log out",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        onTap: (){
                          Navigator.of(context).pop();
                          Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LoginScreen()),
  );
                        },
                      ),
                    )

              ],
            ),
          ),
        );
      },
    );
  }
}
