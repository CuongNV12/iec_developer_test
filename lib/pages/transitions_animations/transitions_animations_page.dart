import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iec_developer_test/pages/transitions_animations/components/animated_icon_widget.dart';
import 'package:iec_developer_test/pages/transitions_animations/components/coordinates.dart';
import 'package:iec_developer_test/pages/transitions_animations/components/global_key_extension.dart';
import 'package:iec_developer_test/pages/transitions_animations/components/progress_container_widget.dart';
import 'package:lottie/lottie.dart';

class TransitionsAnimationsPage extends StatefulWidget {
  const TransitionsAnimationsPage({super.key});

  @override
  State<TransitionsAnimationsPage> createState() =>
      _TransitionsAnimationsPageState();
}

class _TransitionsAnimationsPageState extends State<TransitionsAnimationsPage>
    with TickerProviderStateMixin {
  final GlobalKey _startKeyHeart1 = GlobalKey();
  final GlobalKey _startKeyHeart2 = GlobalKey();

  // final GlobalKey _startKeyHeart3 = GlobalKey();
  final GlobalKey _destinationKey = GlobalKey();
  Coordinate _coordinatesDistanceHeart1 = Coordinate();
  Coordinate _coordinatesDistanceHeart2 = Coordinate();

  // Coordinate _coordinatesDistanceHeart3 = Coordinate();
  bool _isMoved1 = false;
  bool _isMoved2 = false;
  bool _isAnimationEnd = false;
  int _value = 2;
  final int _total = 10;
  late double _indicatorValue = _value / _total;
  late final AnimationController _animationController;
  final StreamController<Color> _containerColorStream =
      StreamController<Color>();

  Stream<Color> get _containerColorStreamController =>
      _containerColorStream.stream;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _coordinatesDistanceHeart1 =
          _calculateCoordinateDistance(_startKeyHeart1);
      _coordinatesDistanceHeart2 =
          _calculateCoordinateDistance(_startKeyHeart2);
      // _coordinatesDistanceHeart3 =
      //     _calculateCoordinateDistance(_startKeyHeart3);
      _startAnimation();
    });
    super.initState();
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _isMoved1 = !_isMoved1;
      });
    });
  }

  Coordinate _calculateCoordinateDistance(GlobalKey key) {
    final coordinateStart = key.getCoordinates;
    final coordinateDestination = _destinationKey.getCoordinates;
    return Coordinate(
      dx: (coordinateDestination.dx - coordinateStart.dx),
      dy: (coordinateDestination.dy - coordinateStart.dy),
    );
  }

  void _highLightProgressBlock() {
    _containerColorStream.add(Colors.grey);
    Future.delayed(
      const Duration(milliseconds: 200),
      () {
        _containerColorStream.add(Colors.grey[300] ?? Colors.grey);
      },
    );
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _coordinatesDistanceHeart1 =
          _calculateCoordinateDistance(_startKeyHeart1);
      _coordinatesDistanceHeart2 =
          _calculateCoordinateDistance(_startKeyHeart2);
      // _coordinatesDistanceHeart3 =
      //     _calculateCoordinateDistance(_startKeyHeart3);
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        //   title: const Text('Transitions Animations'),
        //   centerTitle: false,
        // ),
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/img_background.webp',
                  height: 300,
                  width: size.width,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: 300,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Theme.of(context).scaffoldBackgroundColor,
                          Colors.white10,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 150),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(width: 32),
                            Text('Intro Page'),
                            Spacer(),
                            Text('Design 4'),
                            SizedBox(width: 32),
                          ],
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Fantastic Progress!',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 200,
                          child: Stack(
                            fit: StackFit.loose,
                            children: [
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: ProgressContainerWidget(
                                  destinationKey: _destinationKey,
                                  stream: _containerColorStreamController,
                                  percent: _indicatorValue,
                                  value: '$_value/$_total',
                                ),
                              ),
                              Container(
                                width: size.width,
                                height: 16 + 50 + 16,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 32),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              ..._iconsWidget(
                                isMoved: _isMoved1,
                                left: 48,
                                iconKey: _startKeyHeart1,
                                coordinatesDistance: _coordinatesDistanceHeart1,
                                onEnd: () {
                                  _highLightProgressBlock();
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    setState(() {
                                      _value = 3;
                                      _indicatorValue = _value / _total;
                                      _isMoved2 = !_isMoved2;
                                    });
                                  });
                                },
                              ),
                              ..._iconsWidget(
                                isMoved: _isMoved2,
                                iconKey: _startKeyHeart2,
                                coordinatesDistance: _coordinatesDistanceHeart2,
                                left: 48 + 50 + 32,
                                onEnd: () {
                                  _animationController.forward();
                                  _highLightProgressBlock();
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    setState(() {
                                      _value = 4;
                                      _indicatorValue = _value / _total;
                                      _isAnimationEnd = !_isAnimationEnd;
                                    });
                                  });
                                },
                              ),
                              Positioned(
                                top: 16,
                                left: 48 + 50 + 32 + 50 + 32,
                                child: Lottie.asset(
                                  fit: BoxFit.cover,
                                  'assets/lottie/ic_heart.json',
                                  width: 50,
                                  height: 50,
                                  controller: AnimationController(
                                    vsync: this,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 64),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                          ),
                          child: const Icon(Icons.share),
                        ),
                      ],
                    ),
                  ),
                ),
                if (_isAnimationEnd)
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 32, right: 32, bottom: 32),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('Redesign'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text('Continue'),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _iconsWidget({
    required bool isMoved,
    required double left,
    required GlobalKey iconKey,
    required Coordinate coordinatesDistance,
    void Function()? onEnd,
  }) {
    return [
      Positioned(
        top: 16,
        left: left,
        child: Lottie.asset(
          'assets/lottie/ic_heart.json',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          controller: _animationController,
        ),
      ),
      AnimatedIconWidget(
        isMoved: isMoved,
        iconKey: iconKey,
        coordinatesDistance: coordinatesDistance,
        left: left,
        onEnd: onEnd,
      ),
    ];
  }
}
