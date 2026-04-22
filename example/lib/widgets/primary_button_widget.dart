import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final Function onPressed;
  final String text;

  PrimaryButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed as void Function()?,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(text),
        ),
      ),
    );
  }
}
