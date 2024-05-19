import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iec_developer_test/pages/transitions_animations/components/coordinates.dart';
import 'package:iec_developer_test/pages/transitions_animations/components/globalKey_extension.dart';
import 'package:iec_developer_test/pages/transitions_animations/components/linear_progress_bar.dart';

class TransitionsAnimationsPage extends StatefulWidget {
  const TransitionsAnimationsPage({super.key});

  @override
  State<TransitionsAnimationsPage> createState() =>
      _TransitionsAnimationsPageState();
}

class _TransitionsAnimationsPageState extends State<TransitionsAnimationsPage> {
  final GlobalKey _startKeyHeart1 = GlobalKey();
  final GlobalKey _startKeyHeart2 = GlobalKey();

  // final GlobalKey _startKeyHeart3 = GlobalKey();
  final GlobalKey _destinationKey = GlobalKey();
  Coordinate _coordinatesDistanceHeart1 = Coordinate();
  Coordinate _coordinatesDistanceHeart2 = Coordinate();

  // Coordinate _coordinatesDistanceHeart3 = Coordinate();
  bool _isMoved = false;
  bool _isAnimationEnd = false;
  int _value = 2;
  final int _total = 10;
  late double _indicatorValue = _value / _total;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _coordinatesDistanceHeart1 =
          _calculateCoordinateDistance(_startKeyHeart1);
      _coordinatesDistanceHeart2 =
          _calculateCoordinateDistance(_startKeyHeart2);
      // _coordinatesDistanceHeart3 =
      //     _calculateCoordinateDistance(_startKeyHeart3);
    });
    super.initState();
  }

  Coordinate _calculateCoordinateDistance(GlobalKey key) {
    final coordinateStart = key.getCoordinates;
    final coordinateDestination = _destinationKey.getCoordinates;
    return Coordinate(
      dx: (coordinateDestination.dx - coordinateStart.dx),
      dy: (coordinateDestination.dy - coordinateStart.dy),
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
                                child: Container(
                                  width: size.width,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 32),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  // alignment: Alignment.center,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          const Expanded(
                                            child: Text('NEXT MILESTONE'),
                                          ),
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: FittedBox(
                                              key: _destinationKey,
                                              child: const Icon(
                                                Icons.star_border,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text('$_value/$_total'),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      // LinearProgressIndicator(
                                      //   value: _indicatorValue,
                                      //   color: Theme.of(context).primaryColor,
                                      //   backgroundColor: Colors.white,
                                      //   minHeight: 8,
                                      //   borderRadius: BorderRadius.circular(4),
                                      // ),
                                      LinearProgressBar(
                                        percent: _indicatorValue,
                                      ),
                                    ],
                                  ),
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
                              Positioned(
                                top: 16,
                                left: 48,
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: FittedBox(
                                    child: Icon(
                                      _isAnimationEnd
                                          ? Icons.star
                                          : Icons.star_border,
                                    ),
                                  ),
                                ),
                              ),
                              AnimatedPositioned(
                                duration:
                                    Duration(milliseconds: _isMoved ? 500 : 0),
                                top: _isMoved
                                    ? _coordinatesDistanceHeart1.dy + 16
                                    : 16,
                                left: _isMoved
                                    ? _coordinatesDistanceHeart1.dx + 48
                                    : 48,
                                width: _isMoved ? 20 : 50,
                                height: _isMoved ? 20 : 50,
                                onEnd: () {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    setState(() {
                                      _value = 4;
                                      _indicatorValue = _value / _total;
                                      _isAnimationEnd = !_isAnimationEnd;
                                    });
                                  });
                                },
                                child: FittedBox(
                                  key: _startKeyHeart1,
                                  child: const Icon(
                                    Icons.star,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 16,
                                left: 48 + 50 + 32,
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: FittedBox(
                                    child: Icon(
                                      _isAnimationEnd
                                          ? Icons.star
                                          : Icons.star_border,
                                    ),
                                  ),
                                ),
                              ),
                              AnimatedPositioned(
                                duration:
                                    Duration(milliseconds: _isMoved ? 500 : 0),
                                top: _isMoved
                                    ? _coordinatesDistanceHeart2.dy + 16
                                    : 16,
                                left: _isMoved
                                    ? _coordinatesDistanceHeart2.dx +
                                        48 +
                                        50 +
                                        32
                                    : 48 + 50 + 32,
                                width: _isMoved ? 20 : 50,
                                height: _isMoved ? 20 : 50,
                                child: FittedBox(
                                  key: _startKeyHeart2,
                                  child: const Icon(
                                    Icons.star,
                                  ),
                                ),
                              ),
                              const Positioned(
                                top: 16,
                                left: 48 + 50 + 32 + 50 + 32,
                                child: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: FittedBox(
                                    child: Icon(
                                      Icons.star_border,
                                    ),
                                  ),
                                ),
                              ),
                              // AnimatedPositioned(
                              //   duration:
                              //       Duration(milliseconds: _isMoved ? 500 : 0),
                              //   top: _isMoved
                              //       ? _coordinatesDistanceHeart3.dy + 16
                              //       : 16,
                              //   left: _isMoved
                              //       ? _coordinatesDistanceHeart3.dx +
                              //           48 +
                              //           50 +
                              //           32 +
                              //           50 +
                              //           32
                              //       : 48 + 50 + 32 + 50 + 32,
                              //   width: _isMoved ? 20 : 50,
                              //   height: _isMoved ? 20 : 50,
                              //   child: FittedBox(
                              //     key: _startKeyHeart3,
                              //     child: const Icon(
                              //       Icons.star_border,
                              //     ),
                              //   ),
                              // ),
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
                Padding(
                  padding:
                      const EdgeInsets.only(left: 32, right: 32, bottom: 32),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isMoved = !_isMoved;
                            });
                          },
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
}
