import 'package:flutter/material.dart';

class PaddedInput extends StatefulWidget {
  PaddedInput({
    @required this.label,
    this.validator,
    this.obscureText = false,
    this.onSave,
    this.controller,
    this.onChanged,
    this.initialValue,
    this.isBordered = true,
    this.inputType,
    this.errorText
  });

  final Function validator;
  final Function onSave;
  final Function onChanged;
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final String initialValue;
  final bool isBordered;
  final TextInputType inputType;
  final String errorText;

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
      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      child: TextFormField(
        // initialValue: widget.initialValue,
        validator: widget.validator,
        keyboardType: widget.inputType,
        decoration: InputDecoration(
          labelText: widget.label,
          border:
              widget.isBordered ? OutlineInputBorder() : UnderlineInputBorder(),
          suffixIcon: _getSuffixIcon(widget.obscureText),
          errorText: widget.errorText,
        ),
        controller: widget.controller,
        obscureText: widget.obscureText ? showText : false,
        onSaved: widget.onSave,
//        onChanged: widget.onChanged,
      ),
    );
  }
}

class Option {
  Option({@required this.text, this.val}) {
    if (this.val == null) this.val = this.text;
  }

  String text;
  dynamic val;
}

class SelectField extends StatefulWidget {
  SelectField({
    @required this.label,
    @required this.options,
    this.validator,
    this.onSaved,
    this.onChanged,
    this.isBordered = true,
  });

  final String label;
  final List<Option> options;
  final Function onSaved;
  final Function validator;
  final Function(String) onChanged;
  final bool isBordered;

  @override
  _SelectFieldState createState() => _SelectFieldState();
}

class _SelectFieldState extends State<SelectField> {
  String selected;

  @override
  Widget build(BuildContext context) {
    return FormField(
      onSaved: widget.onSaved,
      validator: widget.validator,
      builder: (FormFieldState state) {
        return InputDecorator(
          decoration: InputDecoration(
            border: widget.isBordered
                ? OutlineInputBorder()
                : UnderlineInputBorder(),
            labelText: widget.label,
          ),
          isEmpty: selected == null || selected == '',
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton(
              value: selected,
              isDense: true,
              onChanged: (option) {
                setState(() => selected = option);
                if (widget.onChanged != null) widget.onChanged(option);
              },
              items: widget.options.map((option) {
                return new DropdownMenuItem(
                  value: option.val,
                  child: new Text(option.text),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
