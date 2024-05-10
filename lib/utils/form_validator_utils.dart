class MyFormValidator {
  static String? textValidator(
      {required String? value, required int minLength}) {
    if (value == null || value.isEmpty) {
      return "Field can't be empty.";
    } else if (value.length < minLength) {
      return "Field should be at least $minLength characters.";
    }
    return null;
  }

  static String? emailValidator({required String? emailId}) {
    if (emailId == null || emailId.isEmpty) {
      return "Email can't be empty.";
    } else {
      bool validEmail =
      RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
          .hasMatch(emailId);
      if (!validEmail) return "Please enter a valid email.";
    }
    return null;
  }

  static String? passwordValidator(
      {required String? password, required int minLength}) {
    if (password == null || password.isEmpty) {
      return "Password can't be empty.";
    } else if (password.length < minLength) {
      return "Password should be more than $minLength characters.";
    }
    return null;
  }

  static String? passwordMatchValidator(
      {required String? password,
        required String? matchTo,
        required int minLength}) {
    if (password == null || password.isEmpty) {
      return "Confirm Password can't be empty.";
    } else if (password.length < minLength) {
      return "Confirm Password should be more than $minLength characters.";
    } else if (password != matchTo) {
      return "Passwords should match.";
    }
    return null;
  }

  static String? ageValidator({required String? age}) {
    if (age == null || age.isEmpty) {
      return "Age can't be empty.";
    } else {
      int? parsedAge = int.tryParse(age);
      if (parsedAge == null || parsedAge <= 0) {
        return "Please enter a valid age.";
      }
    }
    return null;
  }
}
