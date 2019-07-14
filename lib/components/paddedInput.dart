import 'package:flutter/material.dart';

class PaddedInput extends StatefulWidget {
  PaddedInput({
    @required this.label,
    this.validator,
    this.obscureText = false,
    this.onSave,
    this.controller,
    this.onChanged,
  });

  final Function validator;
  final Function onSave;
  final Function onChanged;
  final TextEditingController controller;
  final String label;
  final bool obscureText;

  @override
  _PaddedInputState createState() => _PaddedInputState();
}

class _PaddedInputState extends State<PaddedInput> {
  bool showText = true;

  IconButton _getSuffixIcon(obscureText) {
    if (!obscureText) return null;
    return IconButton(
      onPressed: () {
        setState(() {
          showText = !showText;
        });
      },
      icon: Icon(Icons.visibility),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: TextFormField(
        validator: widget.validator,
        decoration: InputDecoration(
          labelText: widget.label,
          border: OutlineInputBorder(),
          suffixIcon: _getSuffixIcon(widget.obscureText),
        ),
        controller: widget.controller,
        obscureText: widget.obscureText ? showText : false,
        onSaved: widget.onSave,
        onChanged: widget.onChanged,
      ),
    );
  }
}
