import 'package:flutter/material.dart';

class ButtonItem extends StatelessWidget {
  final onPress;
  final iconData;
  final String buttonText;
  final buttonColor;
  const ButtonItem({Key? key, required this.onPress, required this.iconData, required this.buttonText, required this.buttonColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: Column(
          children: [
            Icon(iconData, color: buttonColor,),
            const SizedBox(height: 5,),
            Text(buttonText.toUpperCase(), style: TextStyle(color: buttonColor, fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}
