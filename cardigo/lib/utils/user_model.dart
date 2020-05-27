// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String id;
  String employeeId;
  String password;
  String email;
  String designation;
  String firstName;
  String lastName;
  String avatar;
  int pulseData;
  String hofData;
  bool blueStatus;
  Map feedbackReport;
  String error;

  UserModel({
    this.id,
    this.employeeId,
    this.password,
    this.email,
    this.designation,
    this.firstName,
    this.lastName,
    this.avatar,
    this.pulseData,
    this.hofData,
    this.blueStatus,
    this.feedbackReport,
    this.error,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["_id"],
    employeeId: json["employee_id"],
    password: json["password"],
    email: json["email"],
    designation: json["designation"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    avatar: json["avatar"],
    pulseData: json["pulse_data"],
    hofData: json["hof_data"],
    blueStatus: json["blue_status"],
    error: json["error"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "employee_id": employeeId,
    "password": password,
    "email": email,
    "designation": designation,
    "first_name": firstName,
    "last_name": lastName,
    "avatar": avatar,
    "pulse_data": pulseData,
    "hof_data": hofData,
    "blue_status": blueStatus,
    "error": error,
  };
}
