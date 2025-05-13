import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_sparkle_effect/sparkle/star.dart';
import 'package:flutter_sparkle_effect/sparkle/star_painter.dart';



class Sparkling extends StatefulWidget {
  const Sparkling({Key? key}) : super(key: key);

  @override
  _SparklingState createState() => _SparklingState();
}

class _SparklingState extends State<Sparkling>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation animation;
  late List<MyStar> myStars;

  @override
  void initState() {
    super.initState();

    myStars = <MyStar>[];
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 250,
        ));
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        for (final star in myStars) {
          star.isEnable = math.Random().nextBool();
        }

        animationController.forward();
      }
    });
    animation = Tween<double>(begin: 0, end: 8).animate(CurvedAnimation(
        parent: animationController, curve: Curves.easeInOutSine));
    animation.addListener(() {
      setState(() {});
    });

    animationController.forward();
  }

  void postFrameCallback(_) {
    if (!mounted) {
      return;
    }
    final size = MediaQuery.of(context).size;
    if (myStars.isEmpty) {
      myStars = List.generate(100, (index) {
        double velocityX = 2 * (math.Random().nextDouble());//max velocity 2
        double velocityY = 2 * (math.Random().nextDouble());

        velocityX = math.Random().nextBool() ? velocityX : -velocityX;
        velocityY = math.Random().nextBool() ? velocityY : -velocityY;

        return MyStar(
            isEnable: math.Random().nextBool(),
            innerCirclePoints: 4,
            beamLength: math.Random().nextDouble() * (8 - 2) + 2,
            innerOuterRadiusRatio: 0.0,
            angleOffsetToCenterStar: 0,
            center: Offset(size.width * (math.Random().nextDouble()),
                size.height * (math.Random().nextDouble())),
            velocity: Offset(velocityX, velocityY),
            color: Colors.white,
           // Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0)
        );
      });
    } else {
      for (final star in myStars) {
        star.center = star.center + star.velocity;
        if (star.isEnable) {
          star.innerOuterRadiusRatio = animation.value;

          if (star.center.dx >= size.width) {
            if (star.velocity.dy > 0) {
              star.velocity = const Offset(-1, 1);
            } else {
              star.velocity = const Offset(-1, -1);
            }

            star.center = Offset(size.width, star.center.dy);
          } else if (star.center.dx <= 0) {
            if (star.velocity.dy > 0) {
              star.velocity = const Offset(1, 1);
            } else {
              star.velocity = const Offset(1, -1);
            }

            star.center = Offset(0, star.center.dy);
          } else if (star.center.dy >= size.height) {
            if (star.velocity.dx > 0) {
              star.velocity = const Offset(1, -1);
            } else {
              star.velocity = const Offset(-1, -1);
            }

            star.center = Offset(star.center.dx, size.height);
          } else if (star.center.dy <= 0) {
            if (star.velocity.dx > 0) {
              star.velocity = const Offset(1, 1);
            } else {
              star.velocity = const Offset(-1, 1);
            }

            star.center = Offset(star.center.dx, 0);
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback(postFrameCallback);

    return CustomPaint(
        size: MediaQuery.of(context).size,
        painter: StarPainter(
          myStars: myStars,
        ));
  }
}