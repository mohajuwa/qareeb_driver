import 'package:flutter/material.dart';
import 'package:qareeb/utils/colors.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int trimLines;
  final TextStyle style;

  const ExpandableText(
    this.text, {
    super.key,
    this.trimLines = 2,
    required this.style,
  });

  @override
  State<ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  // A simple check to see if the text is long enough to need a "Show more" button.
  // You can adjust the character count (e.g., 80) as needed.
  bool get _isLongText => widget.text.length > 80;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min, // Use min space
      children: [
        Text(
          widget.text,
          style: widget.style,
          maxLines: _isExpanded ? null : widget.trimLines,
          overflow: TextOverflow.ellipsis,
        ),
        // Only show the button if the text is long enough
        if (_isLongText)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0), // Add some space
              child: Text(
                _isExpanded ? 'Show less' : 'Show more',
                style: TextStyle(
                  color: appColor, // Use your app's theme color
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
