import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final Color bgColor;
  final String? title;
  final String? message;
  final String? positiveBtnText;
  final String? negativeBtnText;
  final Function? onPostivePressed;
  final Function? onNegativePressed;
  final double circularBorderRadius;

  CustomAlertDialog({
    this.title,
    this.message,
    this.circularBorderRadius = 15.0,
    this.bgColor = Colors.white,
    this.positiveBtnText,
    this.negativeBtnText,
    this.onPostivePressed,
    this.onNegativePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null ? Text(title!) : null,
      content: message != null ? Text(message!) : null,
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularBorderRadius)),
      actions: <Widget>[
        negativeBtnText != null
            ?
            //  FlatButton(
            //     child: Text(negativeBtnText!),
            //     textColor: Theme.of(context).accentColor,
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //       if (onNegativePressed != null) {
            //         onNegativePressed!();
            //       }
            //     },
            //   )
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onNegativePressed != null) {
                    onNegativePressed!();
                  }
                },
                child: Text(
                  negativeBtnText!,
                  style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  // style: TextStyle(color: Theme.of(context).accentColor),
                ),
                // textColor: Theme.of(context).accentColor,
              )
            : Container(),
        positiveBtnText != null
            ?
            // FlatButton(
            //     child: Text(positiveBtnText!),
            //     textColor: Theme.of(context).accentColor,
            //     onPressed: () {
            //       if (onPostivePressed != null) {
            //         onPostivePressed!();
            //       }
            //     },
            //   )
            TextButton(
                onPressed: () {
                  if (onPostivePressed != null) {
                    onPostivePressed!();
                  }
                },
                child: Text(
                  positiveBtnText!,
                  style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  // style: TextStyle(color: Theme.of(context).accentColor),
                ),
                // textColor: Theme.of(context).accentColor,
              )
            : Container(),
      ],
    );
  }
}
