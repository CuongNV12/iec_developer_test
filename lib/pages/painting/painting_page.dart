import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';
import 'package:iec_developer_test/pages/painting/components/painter_widget.dart';
import 'package:path_provider/path_provider.dart';

enum BottomNavigationType {
  paint(0),
  erase(1),
  sticker(2),
  idle(3);

  final int value;

  const BottomNavigationType(this.value);

  static BottomNavigationType fromInt(int value) {
    switch (value) {
      case 0:
        return paint;
      case 1:
        return erase;
      case 2:
        return sticker;
      default:
        return idle;
    }
  }
}

class PaintingPage extends StatefulWidget {
  const PaintingPage({super.key});

  @override
  State<PaintingPage> createState() => _HomePageState();
}

class _HomePageState extends State<PaintingPage> {
  final GlobalKey<PainterWidgetState> _painterKey =
      GlobalKey<PainterWidgetState>();
  bool _canScroll = true;
  int _bottomNavigationBarSelectedIndex = BottomNavigationType.idle.value;

  PainterWidgetState get _painterState =>
      _painterKey.currentState ?? PainterWidgetState();

  bool get _shouldShowPaintControl =>
      _bottomNavigationBarSelectedIndex == BottomNavigationType.paint.index ||
      _bottomNavigationBarSelectedIndex == BottomNavigationType.erase.index;

  Future<Color?> _showColorPickerDialog({
    Color? initColor,
  }) {
    return showDialog<Color>(
      context: context,
      builder: (context) {
        Color? pickedColor;
        return AlertDialog(
          title: const Text('Color Picker'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ColorPicker(
                    color: initColor ?? Colors.black,
                    onChanged: (color) {
                      pickedColor = color;
                    },
                    initialPicker: Picker.paletteHue,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Done"),
              onPressed: () => Navigator.pop(context, pickedColor),
            )
          ],
        );
      },
    );
  }

  void _showSnackBar(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  void _saveFileToStorage() async {
    final imageBytes = await _painterState.controller
        .renderImage(const Size(512, 512))
        .then<Uint8List?>((ui.Image image) => image.pngBytes);

    if (imageBytes != null) {
      String path = '';
      try {
        Directory? directory = Directory('/storage/emulated/0/Download');
        if (Platform.isIOS) {
          directory = await getDownloadsDirectory();
        }
        if (directory != null) {
          String directoryPath = '${directory.path}/iec_images';
          // Create the directory if it doesn't exist
          await Directory(directoryPath).create(recursive: true);
          final timestamp = DateTime.now().millisecondsSinceEpoch;
          String filePath = '$directoryPath/$timestamp.png';
          final file = await File(filePath).writeAsBytes(imageBytes);
          path = file.path;
          _showSnackBar('Saved: $path');
        } else {
          throw Exception('Directory does not exist!');
        }
      } catch (e) {
        _showSnackBar('Image saving error: $e');
        debugPrint(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Painter'),
        actions: [
          IconButton(
            onPressed: () {
              _painterState.unDo();
            },
            icon: const Icon(Icons.arrow_circle_left),
          ),
          IconButton(
            onPressed: () {
              _painterState.reDo();
            },
            icon: const Icon(Icons.arrow_circle_right),
          ),
          ValueListenableBuilder<PainterControllerValue>(
            valueListenable: _painterState.controller,
            builder: (context, _, child) => IconButton(
              icon: Icon(
                Icons.delete_forever,
                color: (_painterState.isSelectedDrawable == true)
                    ? null
                    : Colors.grey,
              ),
              onPressed: () {
                _painterState.removeSelectedDrawable();
              },
            ),
          ),
          IconButton(
            onPressed: () {
              _painterState.clear();
            },
            icon: const Icon(Icons.clear),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: _canScroll
                    ? const ClampingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Listener(
                      onPointerDown: (event) {
                        setState(() {
                          _canScroll = false;
                        });
                      },
                      onPointerUp: (event) {
                        setState(() {
                          _canScroll = true;
                        });
                      },
                      child: PainterWidget(key: _painterKey),
                    ),
                  ],
                ),
              ),
            ),
            if (_shouldShowPaintControl) _paintControlWidget(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveFileToStorage();
        },
        tooltip: 'Save Image',
        child: const Icon(Icons.image),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) async {
          setState(() {
            _bottomNavigationBarSelectedIndex = index;
          });

          final type = BottomNavigationType.fromInt(index);
          _painterState.showStickerTab(false);

          switch (type) {
            case BottomNavigationType.paint:
              _painterState.setFreeStyleDraw();
              break;
            case BottomNavigationType.erase:
              _painterState.setFreeStyleErase();
              break;
            case BottomNavigationType.sticker:
              _painterState.showStickerTab(true);
              final List<ConnectivityResult> connectivityResult =
                  await Connectivity().checkConnectivity();
              final hasInternet =
                  connectivityResult.contains(ConnectivityResult.wifi) ||
                      connectivityResult.contains(ConnectivityResult.mobile);
              if (!hasInternet) {
                _showSnackBar('Need internet connection to receive Stickers!');
              }
            case BottomNavigationType.idle:
              _painterState.setFreeStyleNone();
              break;
            default:
              break;
          }
        },
        selectedItemColor: Colors.green,
        showSelectedLabels: true,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        unselectedItemColor: Theme.of(context).colorScheme.inversePrimary,
        showUnselectedLabels: true,
        currentIndex: _bottomNavigationBarSelectedIndex,
        items: const [
          BottomNavigationBarItem(
            label: 'Paint',
            icon: Icon(Icons.edit),
          ),
          BottomNavigationBarItem(
            label: 'Erase',
            icon: Icon(Icons.square_rounded),
          ),
          BottomNavigationBarItem(
            label: 'Sticker',
            icon: Icon(Icons.pinch),
          ),
          BottomNavigationBarItem(
            label: 'Idle',
            icon: Icon(Icons.not_interested_sharp),
          ),
        ],
      ),
    );
  }

  Widget _paintControlWidget() {
    return Container(
      padding: const EdgeInsets.only(
        left: 8,
        right: 100,
        bottom: 8,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: ValueListenableBuilder<PainterControllerValue>(
        valueListenable: _painterState.controller,
        builder: (context, _, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sliderPicker(
                title:
                    'Stroke Width: ${_painterState.controller.freeStyleStrokeWidth.toInt()}',
                label: _painterState.controller.freeStyleStrokeWidth.toString(),
                value: _painterState.controller.freeStyleStrokeWidth,
                onChanged: (value) {
                  _painterState.controller.freeStyleStrokeWidth = value;
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Color: '),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () async {
                      final color = await _showColorPickerDialog();
                      if (color != null) {
                        _painterState.controller.freeStyleColor = color;
                      }
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: _painterState.controller.freeStyleColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _sliderPicker({
    required String title,
    required String label,
    required double value,
    required void Function(double) onChanged,
  }) {
    return Row(
      children: [
        Text(
          title,
        ),
        Expanded(
          child: Slider.adaptive(
            min: 1,
            max: 20,
            label: label,
            divisions: 19,
            value: value,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
