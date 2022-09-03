import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class BuildLoadingIndicator extends StatelessWidget {
  const BuildLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CupertinoActivityIndicator().centered();
  }
}

Widget buildLoadingIndicator() {
  return const CupertinoActivityIndicator().centered().marginAll(10);
}

void buildDialogLoadingIndicator() {
  Future.delayed(Duration.zero, () {
    Get.dialog(
      buildLoadingIndicator(),
    );
  });
}
