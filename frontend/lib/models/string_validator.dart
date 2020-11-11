class Validator {
  static bool hasSpecialChar(String input,
      {bool includeDash = false, bool includeUnderscore = false}) {
    // no dash and underscore

    RegExp regex = new RegExp(r'[!@#$%^&*()+=\:;",/.\' '|]');
    RegExp regexS = new RegExp(r"'"); // S is for single quote
    RegExp regexD = new RegExp(r'-'); // D is for dash
    RegExp regexU = new RegExp(r'_'); // U is for underscore

    bool result = regex.hasMatch(input) | regexS.hasMatch(input);
    bool dResult = regexD.hasMatch(input);
    bool uResult = regexU.hasMatch(input);

    if (includeDash) result = result | dResult;
    if (includeUnderscore) result = result | uResult;

    return result;
  }
}
