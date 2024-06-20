import 'dart:ui';

import '../../../mixins/draw_line_mixin.dart';
import '../../staffline.dart';
import '../barline.dart';
import '../barline_renderer.dart';

/// This class is responsible for rendering a thin barline on the canvas.
/// It implements the [BarlineRenderer] interface and uses the [LineDrawer] mixin.
/// The thin barline is drawn with a specified color and is centered vertically on the staff line.
/// The [barlineRightX] parameter represents the x-coordinate of the right end of the barline.
/// The [staffLineCenterY] parameter represents the y-coordinate of the center of the staff line.
/// The [color] parameter specifies the color of the barline.
class BarlineThinRenderer with LineDrawer implements BarlineRenderer {
  static const thickness = 0.16;
  static const barline = Barline.barlineThin;

  final Color color;
  final double barlineRightX;
  final double staffLineCenterY;

  const BarlineThinRenderer(
      {required this.color,
      required this.barlineRightX,
      required this.staffLineCenterY});
  double get _barlineCenterX => barlineRightX - width / 2;

  @override
  double get width => barline.width;

  @override
  void render(Canvas canvas) {
    final barlineUpperY =
        staffLineCenterY - StaffLineRenderer.upperToCenterHeight;
    final barlineLowerY =
        staffLineCenterY + StaffLineRenderer.lowerToCenterHeight;
    final p1 = Offset(_barlineCenterX, barlineUpperY);
    final p2 = Offset(_barlineCenterX, barlineLowerY);
    drawLine(canvas, p1, p2, thickness, color);
  }
}
