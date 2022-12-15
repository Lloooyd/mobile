// To parse this JSON data, do
//
//     final employeesModel = employeesModelFromJson(jsonString);

import 'dart:convert';

List<LookUpModel> lookUpModelFromJson(String str) => List<LookUpModel>.from(
    json.decode(str).map((x) => LookUpModel.fromJson(x)));

String lookUpModelToJson(List<LookUpModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LookUpModel {
  LookUpModel({
    this.id,
    this.description,
  });

  int? id;
  String? description;

  factory LookUpModel.fromJson(Map<String, dynamic> json) => LookUpModel(
        id: json["id"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
      };
}
