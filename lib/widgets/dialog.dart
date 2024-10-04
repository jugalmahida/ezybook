import 'package:flutter/material.dart';

BuildContext? loadingDialogContext;
Future<dynamic> showErrorDialog(
    BuildContext context, String title, String content) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("OK"),
        ),
      ],
    ),
  );
}

Future<dynamic> showLoadingDialog(BuildContext context) {
  loadingDialogContext = context;
  return showDialog(
    context: context,
    barrierDismissible: false, // Prevent dialog from being dismissed
    builder: (BuildContext context) => const AlertDialog(
      content: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(width: 20),
          Text("Loading..."),
        ],
      ),
    ),
  );
}

void dismissLoadingDialog() {
  if (loadingDialogContext != null) {
    Navigator.of(loadingDialogContext!).pop();
    loadingDialogContext = null;
  }
}

void checkEmailDialog(BuildContext context, String title, String msg) {
  showDialog(
    barrierDismissible: false, // Prevent dialog from being dismissed
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        icon: Image.asset(
          height: 60,
          'assets/images/CheckEmail.png',
        ),
        title: Text(
          textAlign: TextAlign.center,
          title,
        ),
        content: Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Text(
            textAlign: TextAlign.center,
            msg,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      );
    },
  );
}
