import 'package:kfupm_football/core/models/kfupm_member.dart';

bool validatePassword(String value) {
  if ((value.length < 6) || value.isEmpty) {
    return false;
  }
  return true;
}

bool validateEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = new RegExp(pattern);

  return regExp.hasMatch(value);
}

bool validKfupmId(String id) {
  return id.length == 9;
}

bool validNationalId(String id) {
  return id.length == 10;
}

bool validUser(String? email, String? password, String? nationalId, String? phoneNumber, String? kfupmId,
    String? department, DateTime? dob, MemberType? type, String? name) {
  print(validateEmail(email ?? ""));
  print(name);
  print(validKfupmId(kfupmId ?? ""));
  print(validNationalId(nationalId ?? ""));
  print(dob);
  print(validatePassword(password ?? ""));
  return validateEmail(email ?? "") &&
      name != null &&
      validatePassword(password ?? "") &&
      type != null &&
      validNationalId(nationalId ?? "") &&
      dob != null &&
      department != null &&
      validKfupmId(kfupmId ?? "") &&
      validNationalId(phoneNumber ?? "");
}

bool isNum(String string) {
  return num.tryParse(string) != null;
}
