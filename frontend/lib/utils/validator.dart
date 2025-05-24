String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return "Password cannot be empty";
  }
  return null;
}

String? validateRegisterassword(String? value) {
  if (value == null || value.isEmpty) {
    return "Password cannot be empty";
  }

  if (value.length < 8) {
    return "Password must contain at least 8 characters";
  }
  return null;
}

String? validateNotEmpty(String inputFieldName, String? value) {
  if (value == null || value.isEmpty) {
    return "$inputFieldName cannot be empty";
  }
  return null;
}

String? validatePriceInput(bool enabled, String? value) {
  if (value == null) {
    return "Price cannot be empty";
  }
  if (enabled && (double.tryParse(value!) ?? 0) <= 0) {
    return "Must be greater than 0";
  }

  return null;
}

String? validateSlotInput(bool enabled, String? value) {
  if (enabled && (int.tryParse(value!) ?? 0) <= 0) {
    return "Enter a valid slot number";
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
