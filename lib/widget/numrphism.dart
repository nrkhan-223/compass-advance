import 'package:flutter/material.dart';

class Neumorphism extends StatelessWidget {
  const Neumorphism({
    super.key,
    required this.child,
    this.distance = 30,
    this.blur = 50,
    this.margin,
    this.padding,
    this.isRevers = false,
    this.innerShadow = false,
  });

  final Widget child;
  final double distance;
  final double blur;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool isRevers;
  final bool innerShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 136, 134, 134),
          shape: BoxShape.circle,
          boxShadow: isRevers
              ? [
                  BoxShadow(
                      color: const Color.fromARGB(255, 92, 92, 92),
                      blurRadius: blur,
                      offset: Offset(-distance, -distance)),
                  BoxShadow(
                      color: const Color.fromARGB(255, 210, 210, 210),
                      blurRadius: blur,
                      offset: Offset(distance, distance)),
                ]
              : [
                  BoxShadow(
                      color: const Color.fromARGB(255, 210, 210, 210),
                      blurRadius: blur,
                      offset: Offset(-distance, -distance)),
                  BoxShadow(
                      color: const Color.fromARGB(255, 92, 92, 92),
                      blurRadius: blur,
                      offset: Offset(distance, distance)),
                ]),
      child: innerShadow
          ? TopGradientContainer(
              child: child,
            )
          : child,
    );
  }
}

class TopGradientContainer extends StatelessWidget {
  final Widget child;

  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const TopGradientContainer(
      {super.key, required this.child, this.margin, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 209, 209, 209),
                Color.fromARGB(255, 160, 160, 160)
              ])),
      child: child,
    );
  }
}
