// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int id;
  String employeeId;
  String email;
  String firstName;
  String lastName;
  String avatar;
  String pulseData;
  String hofData;
  String blueStatus;
  String feedbackReport;

  UserModel({
    this.id,
    this.employeeId,
    this.email,
    this.firstName,
    this.lastName,
    this.avatar,
    this.pulseData,
    this.hofData,
    this.blueStatus,
    this.feedbackReport,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    employeeId: json["employee_id"],
    email: json["email"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    avatar: json["avatar"],
    pulseData: json["pulse_data"],
    hofData: json["hof_data"],
    blueStatus: json["blue_status"],
    feedbackReport: json["feedback_report"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "employee_id": employeeId,
    "email": email,
    "first_name": firstName,
    "last_name": lastName,
    "avatar": avatar,
    "pulse_data": pulseData,
    "hof_data": hofData,
    "blue_status": blueStatus,
    "feedback_report": feedbackReport,
  };
}
