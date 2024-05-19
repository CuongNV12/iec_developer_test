import 'package:flutter/cupertino.dart';
import 'package:iec_developer_test/pages/transitions_animations/components/coordinates.dart';

extension GlobalkeyExtension on GlobalKey {
  Coordinate get getCoordinates {
    RenderBox? box = currentContext?.findRenderObject() as RenderBox?;
    Offset? position =
        box?.localToGlobal(Offset.zero); //this is global position
    final double dx = position?.dx ?? 0;
    final double dy = position?.dy ?? 0;
    return Coordinate(dx: dx, dy: dy);
  }
}
