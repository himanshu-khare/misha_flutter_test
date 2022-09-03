import 'package:get/get.dart';

showToastMessage({required String title, required String message}) {
  Get.snackbar(title, message, duration: const Duration(seconds: 1));
}
