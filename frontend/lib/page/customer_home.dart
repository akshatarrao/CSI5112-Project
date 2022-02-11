import 'package:after_layout/after_layout.dart';
import 'package:csi5112_frontend/dataModel/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../component/side_menu.dart';
import '../component/swipe_animation.dart';
import 'discussion_forum.dart';
import 'item_list.dart';
import 'order_history.dart';

/// This is the main page of the app when a customer is logged in.
//ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  static const routeName = '/home';
  Widget? redirected;

  MyHomePage({Key? key, this.redirected}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

// MyHomePage is a stateful widget
class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin, AfterLayoutMixin<MyHomePage> {
  int currentPage = 0;
  late Animation<double> animation;
  late AnimationController controller;
  bool isNavigationDrawerOpened = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  GlobalKey<SwipeAnimationState> swipeAnimationKey = GlobalKey();

  @override
  void afterFirstLayout(BuildContext context) {
    widget.redirected = null;
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    animation = Tween<double>(begin: 0, end: 1).animate(controller);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            SideMenu(
              onMenuItemSelection: (pageIndex) {
                swipeAnimationKey.currentState?.hideNavigationDrawer();
                setState(() {
                  currentPage = pageIndex;
                });
              },
              menuItems: cutomerMenuItems,
            ),
            SwipeAnimation(
              key: swipeAnimationKey,
              navigationDrawerOpened: (isOpened) {
                isNavigationDrawerOpened = isOpened;
                if (isNavigationDrawerOpened) {
                  controller.reverse();
                } else {
                  controller.forward();
                }
              },
              child: Scaffold(
                key: _scaffoldKey,
                appBar: AppBar(
                  leading: IconButton(
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.arrow_menu,
                      progress: animation,
                    ),
                    onPressed: () {
                      if (isNavigationDrawerOpened) {
                        controller.reverse();
                        swipeAnimationKey.currentState?.hideNavigationDrawer();
                      } else {
                        controller.forward();
                        swipeAnimationKey.currentState?.showNavigationDrawer();
                      }
                    },
                  ),
                  title: Text(cutomerMenuItems[currentPage].menuName),
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                ),
                body: Container(
                  color: Colors.pink.shade900,
                  height: double.infinity,
                  width: double.infinity,
                  child: Center(
                      child: widget.redirected ??
                          _getbody(context, cutomerMenuItems[currentPage])),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // intialize the page based on the menu item selected
  Widget _getbody(BuildContext context, MenuItem menuItem) {
    switch (menuItem.menuName) {
      case 'Items List':
        return ItemList.getDefaultEmptyPage();
      case 'Order History':
        return OrderHistoryPage(
          isCustomer: true,
        );
      case 'Discussion forum':
        return const DiscussionForum();
      default:
        return ItemList.getDefaultEmptyPage();
    }
  }
}
