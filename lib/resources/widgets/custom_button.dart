import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final onPressed;
  final String buttonText;
  final Color buttonColor;

  const CustomButton({Key? key, this.onPressed, required this.buttonText, required this.buttonColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(buttonColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                    //side: BorderSide(color: Colors.red)
                )
            )
        ),
        child: Text(buttonText, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
      ),
    );
  }
}
