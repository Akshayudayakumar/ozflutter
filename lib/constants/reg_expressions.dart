class RegExpressions {
  static RegExp zeroRegex = RegExp(r'^0+(\.0+)?$');
  static RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  static RegExp upiRegex = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+$');
}