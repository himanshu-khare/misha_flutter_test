
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';

import 'package:get/get.dart';
import 'package:mishainfo_flutter_test/app/routes/app_pages.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        centerTitle: true,
      ),
      floatingActionButton:
          const CircleAvatar(radius: 25, child: Icon(Icons.add))
              .marginAll(10)
              .onInkTap(() {
        Get.bottomSheet(BuildBottomSheet());
      }),
      body: Obx(() {
        return controller.loading.isTrue
            ? const CupertinoActivityIndicator().centered()
            : controller.list.isEmpty
                ? "No Tasks Found".text.make().centered()
                : ListView.builder(
                    itemCount: controller.list.length,
                    itemBuilder: ((context, index) {
                      final task = controller.list[index];
                      return Obx(() {
                        return SwipeActionCell(
                          key: ObjectKey(controller.list[index]),

                          ///this key is necessary
                          trailingActions: <SwipeAction>[
                            SwipeAction(
                                title: "delete",
                                onTap: (CompletionHandler handler) async {
                                  controller.deleteTask(task);
                                },
                                color: Colors.red),
                          ],
                          child: Row(
                            children: [
                              Checkbox(
                                  value:
                                      controller.list[index].check?.value ?? false,
                                  onChanged: (value) {
                                    controller.updateTask(task);
                                  }),
                                  10.widthBox,
                                   task.check?.isTrue == true
                                      ? task.title!.text.lineThrough.make()
                                      : task.title!.text.make()
                            ],
                          ),
                        ).onInkTap(() {
                          Get.toNamed(Routes.NOTE_DETAIL,arguments: task);
                        });
                      });
                    }));
      }),
    );
  }
}

class BuildBottomSheet extends StatelessWidget {
  BuildBottomSheet({Key? key}) : super(key: key);
  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.heightBox,
          Obx(() {
            return homeController.file.value.path.isNotEmpty
                ? Image.file(
                    homeController.file.value,
                    fit: BoxFit.cover,
                    width: 80.0,
                    height: 80.0,
                  ).centered()
                : const CircleAvatar(
                    radius: 32,
                    child: Icon(
                      Icons.upload_file_outlined,
                      size: 28,
                    ),
                  ).onInkTap(() {
                    homeController.uploadPic();
                  }).centered();
          }),
          20.heightBox,
          VxTextField(
            hint: "Enter title",
            controller: homeController.controllerTitle,
            contentPaddingLeft: 10,
          ),
          20.heightBox,
          "Enter description".text.gray500.make(),
          20.heightBox,
          quill.QuillToolbar.basic(
            controller: homeController.quillController,
            showDividers: true,
            showFontFamily: false,
            showFontSize: false,
            showBoldButton: true,
            showItalicButton: true,
            showSmallButton: false,
            showUnderLineButton: true,
            showStrikeThrough: false,
            showInlineCode: false,
            showColorButton: false,
            showBackgroundColorButton: false,
            showClearFormat: false,
            showAlignmentButtons: false,
            showLeftAlignment: false,
            showCenterAlignment: false,
            showRightAlignment: false,
            showJustifyAlignment: false,
            showHeaderStyle: false,
            showListNumbers: true,
            showListBullets: true,
            showListCheck: false,
            showCodeBlock: false,
            showQuote: false,
            showIndent: false,
            showLink: true,
            showUndo: false,
            showRedo: false,
            multiRowsDisplay: false,
            showImageButton: false,
            showVideoButton: false,
            showFormulaButton: false,
            showCameraButton: false,
            showDirection: false,
            showSearchButton: false,
          ),
          quill.QuillEditor.basic(
            controller: homeController.quillController,
            readOnly: false, // true for view only mode
          ).h(100),
          ElevatedButton(
                  onPressed: () {
                    homeController.validate();
                  },
                  child: "ADD".text.make())
              .w(double.infinity)
        ],
      ).p(10).box.white.topRounded().make(),
    );
  }
}
