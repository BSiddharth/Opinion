import 'package:email_validator/email_validator.dart';

String? loginPageEmailValidator(value) {
  if (value.isEmpty)
    return "Email cannot be empty";
  else if (!EmailValidator.validate(value))
    return "Incorrect Email";
  else
    return null;
}

String? askUserInfoPageFirstNameValidator(value) {
  if (value.isEmpty) {
    return 'Please enter your full name';
  }
  if (value.length < 4) {
    return 'Minimum 4 characters needed';
  }

  return null;
}

String? askUserInfoPageLastNameValidator(value) {
  return null;
}

String? askUserInfoPageUserNameValidator(value) {
  if (value.isEmpty) {
    return 'Please enter your user name';
  }
  if (value.length < 4) {
    return 'Minimum 4 characters needed';
  }
  return null;
}
