import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xyapp/Views/Home.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {
        this.labelText,
        this.obsecure = false,
        this.validator,
        this.controller,
        this.onSaved,
        this.maxLines,
        this.minLines,
        this.hint,
        this.parentView,
        this.maxLength,
        this.fontSized

      });
  final FormFieldSetter<String> onSaved;
  final String labelText;
  final bool obsecure;
  final String hint;
  final controller, maxLines, minLines, maxLength, fontSized;
  final FormFieldValidator<String> validator;
  Refreshable parentView;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      controller: controller,
      onSaved: onSaved,
      validator: validator,
      autofocus: true,
      keyboardType: TextInputType.text,
      obscureText: obsecure,
      decoration: InputDecoration(
          hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSized),
          hintText: hint,
        contentPadding: EdgeInsets.all(15),
        counterText: "",
        border: InputBorder.none,
      ),
      cursorColor: Colors.black26,
      style: TextStyle(
          color: Colors.black26,
        fontSize: 20.0,
      ),
      onChanged: (val) {
        this.parentView.updateTextCounter(val.length);
      },
    );
  }
}