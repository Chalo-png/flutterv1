import 'dart:core';

import 'package:flutter/material.dart';

import '../../simple_sheet_music.dart';

import 'barline/barline.dart';
import 'built_measure.dart';
import 'measure_builder.dart';
import 'staffline.dart';

/// Represents a musical measure.
class Measure {
  static const double measureMinUpperHeight =
      StaffLineRenderer.staffLineSpaceHeight * 2 +
          StaffLineRenderer.staffLineThickness / 2;
  static const double measureMinLowerHeight =
      StaffLineRenderer.staffLineSpaceHeight * 2 +
          StaffLineRenderer.staffLineThickness / 2;

  final MeasureBuilder _measureBuilder;

  final List<MusicObjectStyle> objectStyles;
  final Color? measureLineColor;
  final Barline? barline;
  final KeySignature? keySignature;

  /// Constructs a Measure object.
  ///
  /// The [objectStyles] parameter is a list of [MusicObjectStyle] that represent the musical objects in the measure.
  /// The [measureLineColor] parameter specifies the color of the staff lines.
  /// The [barline] parameter specifies the type of barline to be displayed at the end of the measure.
  const Measure(this.objectStyles,
      {this.keySignature, this.measureLineColor, this.barline})
      : _measureBuilder = const MeasureBuilder(),
        assert(objectStyles.length != 0);

  BuiltMeasure buildMeasure(
    Clef measureInitialClef,
    KeySignature keySignature,
    Color staffLineColor, {
    bool isLeftMostMeasure = false,
    bool isBeginMeasure = false,
    bool isEndMeasure = false,
  }) {
    return _measureBuilder.buildMeasure(
      this,
      measureInitialClef,
      this.keySignature ?? keySignature,
      measureLineColor ?? staffLineColor,
      isLeftMostMeasure: isLeftMostMeasure,
      isBeginMeasure: isBeginMeasure,
      isEndMeasure: isEndMeasure,
    );
  }

  Clef? get lastClef {
    for (final object in objectStyles.reversed) {
      if (object is Clef) {
        return object;
      }
    }
    return null;
  }
}
