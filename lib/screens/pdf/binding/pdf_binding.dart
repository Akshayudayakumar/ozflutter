import 'package:get/get.dart';

import '../controller/pdf_controller.dart';

class PdfBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PdfController>(PdfController());
  }

}