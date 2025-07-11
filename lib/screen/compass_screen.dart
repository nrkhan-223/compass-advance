import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:intl/intl.dart';
import '../widget/compassPinter.dart';
import '../widget/numrphism.dart';

class CompassScreen extends StatefulWidget {
  const CompassScreen({super.key});

  @override
  State<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> {
  double? direction;
  String formattedDate = DateFormat.yMMMMd('en_US').format(DateTime.now());
  late String _currentTime;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => _updateTime());
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      DateTime now = DateTime.now();
      _currentTime = DateFormat.jm().format(now);
    });
  }

  double readingDegree(double heading) {
    return heading < 0 ? 360 - heading.abs() : heading;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 136, 134, 134),
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.07),
        child: StreamBuilder<CompassEvent>(
            stream: FlutterCompass.events,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text("Error reading heading"),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }
              direction = snapshot.data!.heading;
              if (direction == null) {
                return const Center(
                  child: Text("Error Device DoesNot Have Sensor"),
                );
              } else {
                return Stack(
                  children: [
                    Positioned(
                        top: size.height * 0.02,
                        child: Text(
                          formattedDate,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.white),
                        )),
                    Positioned(
                        top: size.height * 0.05,
                        child: Text(_currentTime,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white))),
                    Neumorphism(
                      padding: const EdgeInsets.all(8),
                      child: Transform.rotate(
                        angle: (direction! * (pi / 180) * -1),
                        child: CustomPaint(
                          size: size,
                          painter: CompassViewPainter(
                            color: const Color.fromARGB(255, 255, 255, 250),
                          ),
                        ),
                      ),
                    ),
                    CenterDisplay(
                      direction: readingDegree(direction!),
                      size: size,
                    ),
                    Positioned.fill(
                        bottom: size.height * .46,
                        child: RotatedBox(
                          quarterTurns: 90,
                          child: Image.asset(
                            "assets/triangle.png",
                            scale: 20,
                          ),
                        )),
                  ],
                );
              }
            }),
      ),
    );
  }
}

class CenterDisplay extends StatelessWidget {
  final Size size;
  final double direction;

  const CenterDisplay({super.key, required this.size, required this.direction});

  @override
  Widget build(BuildContext context) {
    String getDirection(double direction) {
      if (direction >= 337.5 || direction < 22.5) {
        return 'N';
      } else if (direction >= 22.5 && direction < 67.5) {
        return 'NE';
      } else if (direction >= 67.5 && direction < 112.5) {
        return 'E';
      } else if (direction >= 112.5 && direction < 157.5) {
        return 'SE';
      } else if (direction >= 157.5 && direction < 202.5) {
        return 'S';
      } else if (direction >= 202.5 && direction < 247.5) {
        return 'SW';
      } else if (direction >= 247.5 && direction < 297.5) {
        return 'W';
      } else if (direction >= 297.5 && direction < 337.5) {
        return 'NW';
      }
      return 'N';
    }

    return Neumorphism(
      margin: EdgeInsets.all(size.width * 0.20),
      blur: 5,
      distance: 2.5,
      child: Neumorphism(
        margin: EdgeInsets.all(size.width * 0.02),
        blur: 0,
        innerShadow: true,
        isRevers: true,
        distance: 0,
        child: Neumorphism(
          margin: EdgeInsets.all(size.width * 0.03),
          blur: 5,
          distance: 4,
          child: TopGradientContainer(
            padding: EdgeInsets.all(size.width * 0.02),
            child: Container(
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    begin: Alignment(-5, -5),
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromARGB(255, 100, 133, 100),
                      Color.fromARGB(255, 102, 156, 102)
                    ]),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${direction.toInt().toString().padLeft(3, '0')}°",
                    style: TextStyle(
                        height: 0,
                        color: getDirection(direction).toString() == "N"
                            ? Colors.yellowAccent
                            : Colors.black,
                        fontSize: size.width * 0.09,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    getDirection(direction),
                    style: TextStyle(
                        height: 0,
                        color: getDirection(direction).toString() == "N"
                            ? Colors.yellowAccent
                            : Colors.black,
                        fontSize: size.width * 0.06,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
