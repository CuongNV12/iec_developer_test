import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';
import 'package:iec_developer_test/pages/painting/components/painter_widget.dart';

enum BottomNavigationType {
  paint(0),
  erase(1),
  sticker(2),
  normal(3);

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
        return normal;
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
  int _bottomNavigationBarSelectedIndex = BottomNavigationType.normal.value;

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
      body: Column(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) async {
          setState(() {
            _bottomNavigationBarSelectedIndex = index;
          });

          final type = BottomNavigationType.fromInt(index);

          switch (type) {
            case BottomNavigationType.paint:
              _painterState.setFreeStyleDraw();
              break;
            case BottomNavigationType.erase:
              _painterState.setFreeStyleErase();
              break;
            case BottomNavigationType.sticker:
              await _painterState.addSticker();
              setState(() {
                _bottomNavigationBarSelectedIndex =
                    BottomNavigationType.normal.index;
              });
            case BottomNavigationType.normal:
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
            label: 'Normal',
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
