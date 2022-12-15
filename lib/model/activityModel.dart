// To parse this JSON data, do
//
//     final employeesModel = employeesModelFromJson(jsonString);

import 'dart:convert';

List<ActivityModel> activityModelFromJson(String str) =>
    List<ActivityModel>.from(
        json.decode(str).map((x) => ActivityModel.fromJson(x)));

String activityModelToJson(List<ActivityModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ActivityModel {
  ActivityModel({this.id, this.code, this.description, this.txndate});

  int? id;
  String? code;
  String? description;
  String? txndate;

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
        id: json["id"],
        code: json["code"],
        description: json["description"],
        txndate: json["txndate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "description": description,
        "txndate": txndate,
      };
}
