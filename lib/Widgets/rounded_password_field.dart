//@dart=2.9
import 'package:flutter/material.dart';
import 'package:rent_app/Widgets/text_field_container.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String hint_Text;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
    // ignore: non_constant_identifier_names
    this.hint_Text,
  }) : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => new _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _obscureText = true;

  get onChanged => null;

  @override
  Widget build(BuildContext context) {
    return new TextFieldContainer(
      child: TextField(
        obscureText: _obscureText,
        onChanged: widget.onChanged,
        cursorColor: Colors.deepPurple,
        decoration: InputDecoration(
          hintText: widget.hint_Text,
          icon: Icon(
            Icons.lock,
            color: Colors.deepPurple,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText
                  ? Icons.visibility : Icons.visibility_off,
              color: Colors.deepPurple,
            ),
            onPressed: (){
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}


