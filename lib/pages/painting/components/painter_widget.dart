import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';

class PainterWidget extends StatefulWidget {
  const PainterWidget({super.key});

  @override
  State<PainterWidget> createState() => PainterWidgetState();
}

class PainterWidgetState extends State<PainterWidget> {
  final PainterController _controller = PainterController();

  final List<String> imagesLinks = [
    'https://cdn-icons-png.flaticon.com/256/5020/5020313.png',
    'https://cdn-icons-png.flaticon.com/256/5020/5020369.png',
    'https://cdn-icons-png.flaticon.com/256/5020/5020545.png',
    'https://cdn-icons-png.flaticon.com/256/5020/5020309.png',
    'https://cdn-icons-png.flaticon.com/256/5020/5020503.png',
    'https://cdn-icons-png.flaticon.com/256/5020/5020319.png',
    'https://cdn-icons-png.flaticon.com/256/5020/5020323.png',
  ];

  PainterController get controller => _controller;

  @override
  void initState() {
    _initPainter();
    setFreeStyleDraw();
    super.initState();
  }

  void _initPainter() {
    _controller.freeStyleStrokeWidth = 5;
  }

  void setFreeStyleDraw() {
    _controller.freeStyleMode = FreeStyleMode.draw;
  }

  void setFreeStyleErase() {
    _controller.freeStyleMode = FreeStyleMode.erase;
  }

  void setFreeStyleNone() {
    _controller.freeStyleMode = FreeStyleMode.none;
  }

  void unDo() {
    _controller.undo();
  }

  void reDo() {
    _controller.redo();
  }

  void clear() {
    _controller.clearDrawables();
  }

  bool get isSelectedDrawable => _controller.selectedObjectDrawable != null;

  void removeSelectedDrawable() {
    final selectedDrawable = _controller.selectedObjectDrawable;
    if (selectedDrawable != null) {
      _controller.removeDrawable(selectedDrawable);
    }
  }

  Future<void> addSticker() async {
    final imageLink = await _showStickerDialog();
    if (imageLink == null) return;
    _controller.addImage(
        await NetworkImage(imageLink).image, const Size(100, 100));
    setFreeStyleNone();
  }

  Future<String?> _showStickerDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Select sticker"),
          content: imagesLinks.isEmpty
              ? const Text("No images")
              : FractionallySizedBox(
                  heightFactor: 0.5,
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: [
                        for (final imageLink in imagesLinks)
                          InkWell(
                            onTap: () => Navigator.pop(context, imageLink),
                            child: FractionallySizedBox(
                              widthFactor: 1 / 4,
                              child: Image.network(imageLink),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final frameSize = min(width, height) - 16;
    return Column(
      children: [
        FlutterPainter.builder(
          controller: _controller,
          builder: (context, painter) {
            return Container(
              decoration: const BoxDecoration(color: Colors.white),
              width: frameSize,
              height: frameSize,
              child: painter,
            );
          },
        ),
      ],
    );
  }
}
