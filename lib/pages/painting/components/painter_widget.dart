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

  final List<String> _imagesLinks = [
    'https://cdn-icons-png.flaticon.com/256/5020/5020313.png',
    'https://cdn-icons-png.flaticon.com/256/5020/5020369.png',
    'https://cdn-icons-png.flaticon.com/256/5020/5020545.png',
    'https://cdn-icons-png.flaticon.com/256/5020/5020309.png',
    'https://cdn-icons-png.flaticon.com/256/5020/5020503.png',
    'https://cdn-icons-png.flaticon.com/256/5020/5020319.png',
    'https://cdn-icons-png.flaticon.com/256/5020/5020323.png',
  ];

  bool _isStickerSelecting = false;

  PainterController get controller => _controller;

  @override
  void initState() {
    _initPainter();
    setFreeStyleNone();
    super.initState();
  }

  void _initPainter() {
    _controller.freeStyleStrokeWidth = 5;
    _controller.background = const ColorBackgroundDrawable(color: Colors.white);
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

  void showStickerTab(bool isStickerSelecting) {
    if (_isStickerSelecting != isStickerSelecting) {
      setState(() {
        _isStickerSelecting = isStickerSelecting;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final frameSize = min(width, height) - 16;
    return Column(
      children: [
        DragTarget<String>(
          builder: (context, candidateItems, rejectedItems) {
            return FlutterPainter.builder(
              controller: _controller,
              builder: (context, painter) {
                return SizedBox(
                  width: frameSize,
                  height: frameSize,
                  child: painter,
                );
              },
            );
          },
          onAcceptWithDetails: (details) async {
            final imageUrl = details.data;
            _controller.addImage(
              await NetworkImage(imageUrl).image,
              const Size(100, 100),
            );
            setFreeStyleNone();
          },
        ),
        if (_isStickerSelecting)
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemBuilder: (context, index) {
              return LongPressDraggable<String>(
                data: _imagesLinks[index],
                feedback: Image.network(
                  _imagesLinks[index],
                  width: 100,
                  height: 100,
                ),
                child: Image.network(_imagesLinks[index]),
              );
            },
            itemCount: _imagesLinks.length,
          ),
      ],
    );
  }
}
