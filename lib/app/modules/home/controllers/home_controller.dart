import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mishainfo_flutter_test/app/resources/app_widgets.dart';
import 'package:mishainfo_flutter_test/app/utils/app_utils.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:flutter_quill/flutter_quill.dart';
import '../../../data/models/add_task_params.dart';

class HomeController extends GetxController {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final list = <AddTaskParams>[].obs;
  final TextEditingController controllerTitle = TextEditingController();
  final loading = false.obs;

  QuillController quillController = QuillController.basic();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final file = File("").obs;

  @override
  void onInit() {
    super.onInit();
    readAllTasks();
  }

  addData() async {
    buildDialogLoadingIndicator();
    String? imagelink;
    if (file.value.path.isNotEmpty) {
      Reference reference = _storage.ref().child("images/");
      UploadTask uploadTask = reference.putFile(file.value);
      final ref = await uploadTask;
      imagelink = (await ref.ref.getDownloadURL());
      log("po $imagelink");
    }
    var json = jsonEncode(quillController.document.toDelta().toJson());
    final AddTaskParams params = AddTaskParams(
      title: controllerTitle.text,
      image: imagelink,
      message: json,
      timestamp: FieldValue.serverTimestamp(),
    );
    db.collection("tasks").add(params.toJson()).then((value) async {
      final document = await value.get();
      final param = AddTaskParams.fromJson(document.data()!);
      list.insert(0, param);
      Get.back(); //to dismiss dialog
      showToastMessage(title: "Success", message: "Task Added Successfully");
    }, onError: (er) {
      Get.back();
    });
  }

  updateTask(AddTaskParams params) async {
    buildDialogLoadingIndicator();
    final QuerySnapshot searcheduserid = await db
        .collection('tasks')
        .where('timestamp', isEqualTo: params.timestamp)
        .limit(1)
        .get();

    final document = searcheduserid.docs.first;
    final userDocId = document.id;
    final upatedCheck = params.check?.toggle().value;
    db.collection("tasks").doc(userDocId).update({'check': upatedCheck}).then(
        (value) {
      Get.back();
      params.check?.value = upatedCheck ?? false;
      showToastMessage(title: "Success", message: "Task Updated Successfully");
    }, onError: (er) {
      Get.back();
    });
  }

  deleteTask(AddTaskParams params) async {
    buildDialogLoadingIndicator();
    final QuerySnapshot searcheduserid = await db
        .collection('tasks')
        .where('timestamp', isEqualTo: params.timestamp)
        .limit(1)
        .get();

    final document = searcheduserid.docs.first;
    final userDocId = document.id;
    await db.collection("tasks").doc(userDocId).delete();
    Get.back();
    list.remove(params);
  }

  readAllTasks() {
    try {
      loading.value = true;
      db
          .collection("tasks")
          .orderBy('timestamp', descending: true)
          .get()
          .then((event) {
        loading.value = false;
        list.clear();
        for (final DocumentSnapshot<Map<String, dynamic>> doc in event.docs) {
          list.add(AddTaskParams.fromFirestore(doc));
        }
      });
    } catch (e) {
      log("e $e");
      loading.value = false;
    }
  }

  validate() {
    if (controllerTitle.text.isNotBlank == true) {
      Get.back(); // to dismiss bottom sheet
      addData();
    } else {
      showToastMessage(
          title: "Fields required", message: "Place enter the title");
    }
  }

  Future<void> uploadPic() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    file.value = File(image!.path);
  }
}
