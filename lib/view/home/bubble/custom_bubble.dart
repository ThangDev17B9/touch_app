import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class CustomBubble extends StatefulWidget {
  const CustomBubble({Key? key}) : super(key: key);

  @override
  State<CustomBubble> createState() => CustomBubbleState();
}

class CustomBubbleState extends State<CustomBubble> {
  Color color = Color.fromARGB(255, 2, 1, 29);
  final BoxShape _currentShape = BoxShape.circle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0.0,
      child: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 95, 104, 107),
            shape: _currentShape,
          ),
        ),
      ),
    );
  }
}
