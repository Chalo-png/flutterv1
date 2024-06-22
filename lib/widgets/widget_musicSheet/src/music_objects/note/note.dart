import 'dart:math';
import 'package:flutter/material.dart';
import 'package:test2/widgets/widget_musicSheet/src/music_objects/note/note_duration.dart';
import 'package:test2/widgets/widget_musicSheet/src/music_objects/note/note_pitch.dart';

import '../clef/clef_type.dart';
import '../interface/built_object.dart';
import '../interface/music_object_on_canvas.dart';
import '../interface/music_object_on_canvas_helper.dart';
import '../interface/music_object_style.dart';
import 'accidentals/accidental_renderer.dart';
import 'accidentals/accidental.dart';
import 'parts/fingering.dart';
import 'parts/note_stem.dart';
import 'parts/noteflag.dart';
import 'parts/noteflag_type.dart';
import 'parts/notehead.dart';
import 'parts/notehead_type.dart';
import 'positions.dart';

class Note implements MusicObjectStyle {
  @override
  final EdgeInsets? specifiedMargin;
  @override
  final Color color;
  final Fingering? fingering;
  final Pitch pitch;
  final NoteDuration noteDuration;
  final Accidental? accidental;

  const Note({
    required this.pitch,
    required this.noteDuration,
    this.accidental,
    this.fingering,
    this.specifiedMargin,
    this.color = Colors.black,
  });

  @override
  BuiltObject build(ClefType clefType) {
    final noteHeadType = noteDuration.noteHeadType;
    final noteFlagType = noteDuration.noteFlagType;
    final stavePosition = StavePosition(pitch.position, clefType);

    return BuiltNote(
      this,
      noteHeadType,
      stavePosition,
      specifiedMargin,
      noteFlagType: noteFlagType,
      accidentalType: accidental,
      fingering: fingering,
    );
  }

  BuiltNote buildNote(ClefType clefType) {
    final noteHeadType = noteDuration.noteHeadType;
    final noteFlagType = noteDuration.noteFlagType;
    final stavePosition = StavePosition(pitch.position, clefType);

    return BuiltNote(
      this,
      noteHeadType,
      stavePosition,
      specifiedMargin,
      noteFlagType: noteFlagType,
      accidentalType: accidental,
      fingering: fingering,
    );
  }

  @override
  MusicObjectStyle copyWith({
    Pitch? newPitch,
    NoteDuration? newNoteDuration,
    Accidental? newAccidental,
    Fingering? newFingering,
    Color? newColor,
    EdgeInsets? newSpecifiedMargin,
  }) =>
      Note(
        pitch: newPitch ?? pitch,
        noteDuration: newNoteDuration ?? noteDuration,
        accidental: newAccidental ?? accidental,
        fingering: newFingering ?? fingering,
        specifiedMargin: newSpecifiedMargin ?? specifiedMargin,
        color: newColor ?? color,
      );
}


class BuiltNote implements BuiltObject {
  static const minStemLength = 3.5;
  static const halfPositionHeight = 0.5;

  final Accidental? accidentalType;
  final NoteHeadType noteHeadType;
  final NoteFlagType? noteFlagType;
  final Fingering? fingering;
  final StavePosition stavePosition;
  final Note noteStyle;
  final EdgeInsets? specifiedMargin;

  const BuiltNote(this.noteStyle, this.noteHeadType, this.stavePosition,
      this.specifiedMargin,
      {this.noteFlagType, this.accidentalType, this.fingering});

  FingeringRenderer? get _fingeringOnMeasure => fingering != null
      ? FingeringRenderer(fingering!,
          noteUpperHeight: _noteUpperHeight,
          noteHeadCenterX: noteHead.noteHeadCenterX)
      : null;

  EdgeInsets get _defaultMargin =>
      specifiedMargin ?? EdgeInsets.all(objectWidth / 4);
  EdgeInsets get _margin => noteStyle.specifiedMargin ?? _defaultMargin;

  bool get _hasAccidental => accidentalType != null;

  AccidentalRenderer? get _accidental => _hasAccidental
      ? AccidentalRenderer(accidentalType!, localPosition)
      : null;

  double get accidentalWidth => _accidental?.width ?? 0;

  double get accidentalSpacing => accidentalWidth / 5;

  int get localPosition => stavePosition.localPosition;
  bool get _isStemUp => localPosition < 0;

  bool get _hasStem => noteHeadType.hasStem;

  NoteHead get noteHead => NoteHead(
      noteHeadType, localPosition, accidentalWidth + accidentalSpacing);

  NoteStem? get _noteStem => _hasStem
      ? NoteStem(
          _isStemUp,
          stemRootOffset: stemRootOffset,
          stemTipOffset: _stemTipOffset,
        )
      : null;

  double get stemX => _isStemUp ? noteHead.stemUpX : noteHead.stemDownX;
  double get _stemRootY =>
      _isStemUp ? noteHead.stemUpRootY : noteHead.stemDownRootY;

  Offset get stemRootOffset => Offset(stemX, _stemRootY);

  double get _stemTipY {
    if (_hasFlag) return _noteFlag!.stemTipY;
    return _isStemUp ? _stemUpTipY : _stemDownTipY;
  }

  double get _stemUpTipY =>
      _isStemTipOnCenter ? 0.0 : noteHead.stemUpRootY - NoteStem.minStemLength;
  double get _stemDownTipY => _isStemTipOnCenter
      ? 0.0
      : noteHead.stemDownRootY + NoteStem.minStemLength;

  Offset get _stemTipOffset => Offset(stemX, _stemTipY);

  bool get _hasFlag => noteFlagType != null;

  NoteFlag? get _noteFlag => _hasFlag
      ? NoteFlag(noteHead, noteFlagType!, _isStemUp, _isStemTipOnCenter)
      : null;

  bool get _isStemTipOnCenter => localPosition <= -7 || 7 <= localPosition;

  @override
  ObjectOnCanvas placeOnCanvas({
    required double previousObjectsWidthSum,
    required double staffLineCenterY,
  }) {
    final helper = ObjectOnCanvasHelper(
      bboxWithNoMargin,
      Offset(previousObjectsWidthSum, staffLineCenterY),
      _margin,
    );

    return NoteRenderer(helper, noteStyle,
        noteHead: noteHead,
        noteStem: _noteStem,
        noteFlag: _noteFlag,
        accidental: _accidental,
        position: localPosition,
        fingering: _fingeringOnMeasure);
  }

  double get _fingeringHeight => _fingeringOnMeasure?.upperHeight ?? 0.0;

  double get _noteHeadUpperHeight => noteHead.upperHeight;
  double get _noteHeadLowerHeight => noteHead.lowerHeight;

  double get _noteFlagUpperHeight => _noteFlag?.upperHeight ?? 0.0;
  double get _noteFlagLowerHeight => _noteFlag?.lowerHeight ?? 0.0;

  double get _noteStemUpperHeight => _noteStem?.upperHeight ?? 0.0;
  double get _noteStemLowerHeight => _noteStem?.lowerHeight ?? 0.0;

  double get _accidentalUpperHeight => _accidental?.upperHeight ?? 0.0;
  double get _accidentalLowerHeight => _accidental?.lowerHeight ?? 0.0;

  double get _noteUpperHeight => [
        _noteHeadUpperHeight,
        _noteFlagUpperHeight,
        _noteStemUpperHeight,
        _accidentalUpperHeight,
      ].fold<double>(0.0,
          (previousValue, notePartUpper) => max(previousValue, notePartUpper));

  @override
  double get upperHeight => _upperWithNoMargin + _margin.top;

  double get _upperWithNoMargin => max(_noteUpperHeight, _fingeringHeight);

  @override
  double get lowerHeight => _lowerWithNoMargin + _margin.bottom;

  double get _lowerWithNoMargin => [
        _noteHeadLowerHeight,
        _noteFlagLowerHeight,
        _noteStemLowerHeight,
        _accidentalLowerHeight
      ].fold<double>(0.0,
          (previousValue, notePartLower) => max(previousValue, notePartLower));

  Rect get bboxWithNoMargin =>
      Rect.fromLTRB(0.0, -_upperWithNoMargin, objectWidth, _lowerWithNoMargin);

  double get _noteHeadWidth => noteHeadType.width;

  double get _noteFlagWidth => _noteFlag?.width ?? 0.0;

  double get _downNoteWidth => max(_noteHeadWidth, _noteFlagWidth);

  double get _upNoteWithFlagWidth =>
      _hasFlag ? _noteHeadWidth + _noteFlagWidth - NoteStem.stemThickness : 0.0;

  double get _upNoteWidth => max(_upNoteWithFlagWidth, _noteHeadWidth);

  double get _noteWidth => _isStemUp ? _upNoteWidth : _downNoteWidth;

  @override
  double get width => objectWidth + _margin.horizontal;

  double get objectWidth => accidentalWidth + accidentalSpacing + _noteWidth;
}

class NoteRenderer implements ObjectOnCanvas {
  static const _upperLedgerLineMinPosition = 6;
  static const _lowerLedgerLineMaxPosition = -6;

  final AccidentalRenderer? accidental;
  final NoteStem? noteStem;
  final int position;
  final NoteHead noteHead;
  final NoteFlag? noteFlag;
  final FingeringRenderer? fingering;
  @override
  final ObjectOnCanvasHelper helper;

  @override
  final MusicObjectStyle musicObjectStyle;
  const NoteRenderer(this.helper, this.musicObjectStyle,
      {required this.noteHead,
      required this.position,
      this.accidental,
      this.noteStem,
      this.noteFlag,
      this.fingering});

  double get noteHeadInitialX => noteHead.initialX(helper.renderOffset);
  double get noteHeadWidth => noteHead.width;
  // Rect get renderArea => helper.renderArea;
  bool get requireLedgerLine =>
      position <= _lowerLedgerLineMaxPosition ||
      _upperLedgerLineMinPosition <= position;

  @override
  void render(Canvas canvas, Size size, fontFamily) {
    accidental?.render(
        canvas, size, helper.renderOffset, musicObjectStyle.color, fontFamily);
    noteHead.render(
        canvas, size, helper.renderOffset, musicObjectStyle.color, fontFamily);
    noteStem?.render(canvas, musicObjectStyle.color, helper.renderOffset);
    noteFlag?.render(
        canvas, size, helper.renderOffset, musicObjectStyle.color, fontFamily);
    fingering?.render(
        canvas, size, helper.renderOffset, musicObjectStyle.color, fontFamily);
  }

  @override
  bool isHit(Offset position) => helper.isHit(position);

  @override
  Rect get renderArea => helper.renderArea;
}
