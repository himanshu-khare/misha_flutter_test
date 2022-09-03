import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AddTaskParams {
  String? title;
  String? message;
  String? time;
  String? image;
  RxBool? check;
  dynamic timestamp;

  AddTaskParams({this.title, this.message, this.time, this.image, this.check,this.timestamp});

  factory AddTaskParams.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    return AddTaskParams(
      title: data!['title'] as String?,
      message: data['message'] as String?,
      time: data['time'] as String?,
      image: data['image'] as String?,
      check: RxBool(data['check'] as bool? ?? false),
      timestamp: (data['timestamp'] as Timestamp?),
    );
  }

  factory AddTaskParams.fromJson(Map<String, dynamic> json) => AddTaskParams(
        title: json['title'] as String?,
        message: json['message'] as String?,
        time: json['time'] as String?,
        image: json['image'] as String?,
        check: RxBool(json['check'] as bool? ?? false),
        timestamp: json['timestamp'] as Timestamp?,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'message': message,
        'time': time,
        'image': image,
        'check': check?.value,
        'timestamp':timestamp
      };
}
