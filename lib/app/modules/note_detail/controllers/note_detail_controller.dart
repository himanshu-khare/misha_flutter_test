import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:mishainfo_flutter_test/app/data/models/add_task_params.dart';

class NoteDetailController extends GetxController {

  final count = 0.obs;
  late final AddTaskParams task;
  String message = "";
  late QuillController quillController;

  @override
  void onInit() {
    super.onInit();
    task = Get.arguments;
    var myJSON = jsonDecode(task.message!);
    quillController = QuillController(
        document: Document.fromJson(myJSON),
        selection: TextSelection.fromPosition(const TextPosition(offset: 0)));
  }

  void increment() => count.value++;
}
