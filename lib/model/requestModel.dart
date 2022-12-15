// `id` INT(11) NOT NULL AUTO_INCREMENT,
// `sno` VARCHAR(20) NOT NULL COLLATE 'utf8mb4_general_ci',
// `reqdate` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
// `docid` INT(11) NOT NULL,
// `status` INT(11) NULL DEFAULT NULL,

// To parse this JSON data, do
//
//     final employeesModel = employeesModelFromJson(jsonString);

import 'dart:convert';

List<RequestModel> requestModelFromJson(String str) => List<RequestModel>.from(
    json.decode(str).map((x) => RequestModel.fromJson(x)));

String requestModelToJson(List<RequestModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RequestModel {
  RequestModel(
      {this.id,
      this.sno,
      this.reqdate,
      this.expecteddate,
      this.appdate,
      this.docid,
      this.copies,
      this.status});

  int? id;
  String? sno;
  String? reqdate;
  String? expecteddate;
  String? appdate;
  int? docid;
  int? copies;
  int? status;

  factory RequestModel.fromJson(Map<String, dynamic> json) => RequestModel(
        id: json["id"],
        sno: json["sno"],
        reqdate: json["reqdate"],
        expecteddate: json["expecteddate"],
        appdate: json["appdate"],
        docid: json["docid"],
        copies: json["copies"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "sno": sno,
        "reqdate": reqdate,
        "expecteddate": expecteddate,
        "appdate": appdate,
        "docid": docid,
        "copies": copies,
        "status": status,
      };
}
