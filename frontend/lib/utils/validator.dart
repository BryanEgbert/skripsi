String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return "Password cannot be empty";
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return "Email cannot be empty";
  }
  final bool emailIsValid = RegExp(
          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
      .hasMatch(value);

  if (!emailIsValid) {
    return "Email is not valid";
  }

  return null;
}
