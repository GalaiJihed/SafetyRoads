
import 'package:flutter/material.dart';
import 'package:roads/components/text_field_container.dart';
import 'package:roads/utils/constants.dart';

class RoundedPasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final  TextEditingController value ;
  final IconButton iconButton;
  final bool secureText;
  final String hintText;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
    this.value,
    this.secureText,
    this.iconButton,
    this.hintText ="Password"
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: secureText,
        onChanged: onChanged,
        controller:value,

        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: iconButton,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
