import 'package:flutter/material.dart';

/// A widget that displays an animated card with an icon and text.
class AnimatedCard extends StatelessWidget {
  /// Whether the card is visible or not.
  final bool isVisible;

  /// The text to display on the card.
  final String text;

  /// The icon to display on the card.
  final IconData icon;

  /// The callback function to be called when the card is tapped.
  final VoidCallback onTap;

  /// Creates an [AnimatedCard] widget.
  const AnimatedCard({
    Key? key,
    required this.isVisible,
    required this.text,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: isVisible ? 1.0 : 0.0,
      child: GestureDetector(
        onTap: isVisible ? onTap : null,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: Colors.grey[300]!,
              width: 1,
            ), // optional border
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  icon,
                ),
                const SizedBox(width: 8.0), // Adjust space between icon and text
                Text(
                  text,
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.015,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
