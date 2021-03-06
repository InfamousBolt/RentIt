//@dart=2.9
import 'package:flutter/material.dart';
import 'package:rent_app/Welcome/welcome_screen.dart';

class ErrorAlertDialog extends StatelessWidget {
  final String message;
  const ErrorAlertDialog({Key key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message),
      actions: <Widget>[
        ElevatedButton(
            onPressed: (){
              Route newRoute = MaterialPageRoute(builder: (context) => WelcomeScreen());
              Navigator.pushReplacement(context, newRoute);

            },
          child: Center(
            child: Text("OK"),
          ),
        )
      ],
    );
  }
}
