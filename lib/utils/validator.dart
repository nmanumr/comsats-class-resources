import 'package:flutter/material.dart';

/// Regex to match email address
final emailRegex = new RegExp(
    r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

/// A function that takes list of [FormFieldValidator]s
/// and return a signle [FormFieldValidator] as
/// FormField.validator only takes single [FormFieldValidator]
FormFieldValidator<String> chainedValidator(
    List<FormFieldValidator<String>> validators) {
  return (String val) {
    for (var validator in validators) {
      var returnedVal = validator(val);
      if (returnedVal != null) return returnedVal;
    }
    return null;
  };
}

/// Validates password again field
///
/// Takes [TextEditingController] of passwordFielf
/// and return [FormFieldValidator]
///
/// ```dart
/// TextFormField(
///   controller: _password2Controller,
///   obscureText: true,
///   validator: chainedValidator([
///     notEmptyValidator,
///     repasswordValidator(_passwordController)
///   ]),
/// )
/// ```
FormFieldValidator<String> repasswordValidator(
    TextEditingController passwordFieldController) {
  return chainedValidator([
    notEmptyValidator,
    (String val) {
      if (val != passwordFieldController.text) return "Password not matched";
      return null;
    }
  ]);
}

/// Validates non emptyf field
String notEmptyValidator(String val) {
  return (val ?? "") != '' ? null : 'Field can not be empty';
}

/// Validates password field
FormFieldValidator<String> passwordValidator = chainedValidator([
  notEmptyValidator,
  (String val) {
    if (val.length < 8) return "Password should be atleast 8 characters";
    return null;
  }
]);

/// Validates email field
FormFieldValidator<String> emailValidator = chainedValidator([
  notEmptyValidator,
  (String val) {
    if (emailRegex.hasMatch(val)) return null;
    return "Email not valid";
  }
]);

/// Validates username field
/// unused but left for future reference
FormFieldValidator<String> usernameValidator = chainedValidator([
  notEmptyValidator,
  (String val) {
    if (val.length < 5) return "Username should be atleast 5 characters";
    if (val.contains(" ")) return "Spaces should not be add in username";
    if (val.contains(RegExp(r'^\d')))
      return "Username can not start with a number";
    if (val.contains(RegExp(r'[^A-Za-z0-9]')))
      return "Username can only contain alphaneumeric characters";
    return null;
  }
]);

/// Validates course code field
FormFieldValidator<String> courseCodeValidator = chainedValidator([
  notEmptyValidator,
  (String val) {
    if (val.contains(RegExp(r'[A-Za-z]{3}\d{3}'))) return null;
    return "Not a valid course code";
  }
]);

/// Validates roll number field
FormFieldValidator<String> rollNumValidator = chainedValidator([
  notEmptyValidator,
  (String val) {
    if (val
        .contains(RegExp(r'(FA|SP)\d{2}-[A-Z]{3}-\d{3}', caseSensitive: false)))
      return null;
    return "Not a valid roll number";
  }
]);

/// Validates name field
FormFieldValidator<String> nameValidator = chainedValidator([
  notEmptyValidator,
  (String val) {
    if (val.length < 8 || val.split(" ").length < 2)
      return "Please enter your full name";
    return null;
  }
]);
