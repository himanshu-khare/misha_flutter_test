import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

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
                        return CheckboxListTile(
                            title: task.check?.isTrue == true
                                ? task.title!.text.lineThrough.make()
                                : task.title!.text.make(),
                            value: controller.list[index].check?.value ?? false,
                            onChanged: (value) {
                              controller.updateTask(task);
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
    return Column(
      children: [
        10.heightBox,
        VxTextField(
          hint: "Enter title",
          controller: homeController.controllerTitle,
          contentPaddingLeft: 10,
        ),
        10.heightBox,
        ElevatedButton(
                onPressed: () {
                  homeController.validate();
                },
                child: "ADD".text.make())
            .w(double.infinity)
      ],
    ).p(10).box.white.topRounded().height(150).make();
  }
}
