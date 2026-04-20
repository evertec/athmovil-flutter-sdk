import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveAlertDialog extends StatelessWidget {
  final String? title;
  final Widget content;
  final String? okButtonText;
  final String? cancelButtonText;
  final Function? okButtonCallback;

  const AdaptiveAlertDialog({
    required this.title,
    required this.content,
    this.okButtonText,
    this.cancelButtonText,
    this.okButtonCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CustomIOSAlertDialog(
            okButtonText: okButtonText,
            onOkButtonPressed: okButtonCallback,
            cancelButtonText: cancelButtonText,
            title: title,
            content: content,
          )
        : CustomAndroidAlertDialog(
            title: title,
            content: content,
            okButton: TextButton(
              child: Text(
                okButtonText!,
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                okButtonCallback!();
              },
            ),
            cancelButton: TextButton(
              child: Text(
                cancelButtonText!,
                style: TextStyle(color: Colors.black54),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          );
  }
}

class CustomIOSAlertDialog extends StatelessWidget {
  final String? title;
  final Widget? content;
  final String? okButtonText;
  final String? cancelButtonText;
  final Function? onOkButtonPressed;

  const CustomIOSAlertDialog({
    Key? key,
    this.title,
    this.content,
    required this.okButtonText,
    required this.cancelButtonText,
    required this.onOkButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        title!,
      ),
      content: content,
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            cancelButtonText!,
          ),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            if (onOkButtonPressed != null) {
              onOkButtonPressed!();
            }
            Navigator.of(context).pop();
          },
          child: Text(
            okButtonText!,
          ),
        ),
      ],
    );
  }
}

class CustomAndroidAlertDialog extends StatelessWidget {
  final String? title;
  final Widget content;
  final Widget okButton;
  final Widget? cancelButton;

  const CustomAndroidAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.okButton,
    this.cancelButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title!,
        textAlign: TextAlign.center,
      ),
      actions: [cancelButton!, okButton],
      content: content,
    );
  }
}
