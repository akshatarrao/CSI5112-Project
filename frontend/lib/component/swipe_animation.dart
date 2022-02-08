import 'package:flutter/material.dart';


const sideMenuWidth = 240.0;
const minScale = 0.5;
const maxScale = 1.0;

class SwipeAnimation extends StatefulWidget {
  final Widget child;
  final Function(bool) navigationDrawerOpened;

  const SwipeAnimation(
      {Key? key, required this.child, required this.navigationDrawerOpened})
      : super(key: key);

  @override
  SwipeAnimationState createState() => SwipeAnimationState();
}

class SwipeAnimationState extends State<SwipeAnimation>
    with SingleTickerProviderStateMixin {
  double initialX = 0;
  double lastX = 0;
  bool swipingLeft = false;

  late Animation<int> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation =
        IntTween(begin: 0, end: sideMenuWidth.toInt()).animate(controller)
          ..addListener(() {
            _translateX(animation.value.toDouble());
          });
  }

  @override
  Widget build(BuildContext context) {
    double scaleFactor = 0;
    double scale = 0;
    if (swipingLeft) {
      // To hide the menu, when user swipes back/left
      scaleFactor = ((sideMenuWidth - lastX) / sideMenuWidth) + 0.3;
      scale = scaleFactor < minScale ? minScale : scaleFactor;
      scale = scale > maxScale ? maxScale : scale;
    } else {
      // To show the menu, when user swipes right/forward
      scaleFactor = (sideMenuWidth - lastX) / sideMenuWidth;
      scale = scaleFactor < minScale ? minScale : scaleFactor;
    }

    return GestureDetector(
      onHorizontalDragStart: (details) {
        initialX = details.globalPosition.dx;
        lastX = 0;
      },
      onHorizontalDragUpdate: (details) {
        lastX = (details.globalPosition.dx);
        if (lastX <= sideMenuWidth) {
          swipingLeft = lastX < initialX;
          if (!swipingLeft) {
            lastX = lastX / 2;
            _translateX(lastX);
          } else {
            if (scale < 1.0) {
              _translateX(lastX);
            }
          }
        }
      },
      onHorizontalDragEnd: (details) {
        if (swipingLeft) {
          if (lastX > sideMenuWidth) {
            // Do nothing
          } else if (initialX - lastX < sideMenuWidth / 4) {
            _translateX(sideMenuWidth);
          } else {
            _resetPosition(200);
          }
        } else {
          if (lastX > sideMenuWidth) {
            // Do nothing
          } else if (lastX - initialX > (sideMenuWidth / 4)) {
            _translateX(sideMenuWidth);
          } else {
            _resetPosition(200);
          }
        }
      },
      child: Transform.scale(
        scale: scale,
        alignment: AlignmentDirectional.centerEnd,
        child: scale == 1
            ? widget.child
            : _getContainerWithShadow(
                scale,
                widget.child,
              ),
      ),
    );
  }

  void _resetPosition(int milliseconds) {
    Future.delayed(Duration(milliseconds: milliseconds), () {
      _translateX(0);
    });
  }

  void hideNavigationDrawer([double dx = sideMenuWidth]) {
    controller.reverse(from: dx);
  }

  void showNavigationDrawer() {
    controller.forward(from: 0);
  }

  void _translateX(double dx) {
    setState(() {
      lastX = dx;
    });

    if (lastX == 0.0) {
      widget.navigationDrawerOpened(false);
    } else if (lastX >= sideMenuWidth) {
      widget.navigationDrawerOpened(true);
    }
  }

  Container _getContainerWithShadow(double scale, Widget child) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 8,
            spreadRadius: (1 - scale) * 8,
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
