// import '../../../simple_sheet_music.dart';
import '../clef/clef_type.dart';
import 'note_pitch.dart';

/// Represents a position on a musical stave.
///
/// The [StavePosition] class provides methods to calculate the local position
/// of a note on the stave based on the clef type. It also defines the minimum
/// and maximum positions on the stave.
class StavePosition {
  static const minPosition = Pitch.a0;
  static const maxPosition = Pitch.c8;

  final int globalPosition;
  final ClefType clefType;

  /// Creates a [StavePosition] with the given global position.
  const StavePosition(this.globalPosition, this.clefType);

  /// Calculates the local position of the note on the stave based on the clef type.
  ///
  /// The local position is calculated by subtracting the clef type's global position
  /// on the center of the staff lines from the global position of the note.
  ///
  /// Returns the local position of the note.
  int get localPosition => globalPosition - clefType.positionOnCenter;

  @override
  String toString() {
    return 'StavePosition(globalPosition: $globalPosition)';
  }
}
