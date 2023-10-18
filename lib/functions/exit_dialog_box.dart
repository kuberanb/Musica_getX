
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void showExitDialog(context) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text("Exit"),
      content: const Text("Do You Want to Exit?"),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            "Cancel",
            style: TextStyle(
              //    color: kBlackColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            SystemNavigator.pop();
          },
          child: const Text(
            "Exit",
            style: TextStyle(
              //   color: kBlackColor,
              fontWeight: FontWeight.bold,
              fontSize: 16, 
            ),
          ),
        ),
      ],
    ),
  );
}

// void showDialog({required context, required Function(dynamic ctx) builder}) {}
