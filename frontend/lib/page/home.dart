import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csi5112_frontend/dataModal/model.dart';
import '../component/side_menu.dart';
import '../component/swipe_animation.dart';
import 'discussion_forum.dart';
import 'item_list.dart';
import 'order_history.dart';

class MyHomePage extends StatefulWidget {
  static const routeName = '/home';
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int currentPage = 0;
  late Animation<double> animation;
  late AnimationController controller;
  bool isNavigationDrawerOpened = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  GlobalKey<SwipeAnimationState> swipeAnimationKey = GlobalKey();

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
                  title: Text(menuItems[currentPage].menuName),
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                ),
                body: Container(
                  color: Colors.pink.shade900,
                  height: double.infinity,
                  width: double.infinity,
                  child:
                      Center(child: _getbody(context, menuItems[currentPage])),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _getbody(BuildContext context, MenuItem menuItem) {
    switch (menuItem.menuName) {
      case 'Item List':
        return const ItemList();
      case 'Order History':
        return const OrderHistory();
      case 'Discussion forum':
        return const DiscussionForum();
      default:
        return const ItemList();
    }
  }
}
