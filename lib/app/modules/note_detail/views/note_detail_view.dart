import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../resources/app_widgets.dart';
import '../controllers/note_detail_controller.dart';

class NoteDetailView extends GetView<NoteDetailController> {
  const NoteDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.heightBox,
          controller.task.image != null
              ? Image.network(
                  controller.task.image!,
                  width: 200,
                  height: 200,
                  loadingBuilder: (ctx, widget, perc) {
                    if (perc?.cumulativeBytesLoaded ==
                        perc?.expectedTotalBytes) {
                      return widget;
                    } else {
                      return buildLoadingIndicator();
                    }
                  },
                ).centered()
              : "No image available".text.make().centered(),
          20.heightBox,
          controller.task.title!.text.make(),
          20.heightBox,
          quill.QuillEditor.basic(
            controller: controller.quillController,
            readOnly: true, // true for view only mode
          ),
          20.heightBox,
          "Posted on ${DateFormat("dd-MM-yyyy HH:mm:a").format((controller.task.timestamp as Timestamp).toDate())}"
              .text
              .gray500
              .make(),
        ],
      ).marginAll(10).w(double.infinity),
    );
  }
}
