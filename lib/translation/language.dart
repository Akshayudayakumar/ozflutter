import 'package:get/get.dart';

class Language extends Translations {


  @override
  Map<String, Map<String, String>> get keys => const <String, Map<String, String>> {

    'en_US': <String, String> {
      // In your UI code, you would use `Get.tr('field_cant_be_empty')` or `'field_cant_be_empty'.tr`
      // to display "Field cannot be empty" when the current locale is 'en_US'.
      'field_cant_be_empty': 'Field cannot be empty',
      'Please_check_your_details': 'Please check your details',
      'something_error': 'Something went wrong, please try again later.',
    }
  };
}
