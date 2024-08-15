// To parse this JSON data, do
//
//     final paymentAccount = paymentAccountFromJson(jsonString);

import 'dart:convert';
import 'package:supercharged/supercharged.dart';

PaymentAccount paymentAccountFromJson(String str) =>
    PaymentAccount.fromJson(json.decode(str));

String paymentAccountToJson(PaymentAccount data) => json.encode(data.toJson());

class PaymentAccount {
  PaymentAccount({
    required this.name,
    required this.number,
    required this.nameOfBeneficiary,
    required this.ifscCode,
    required this.mtnMobileNumber,
    required this.mtnName,
    required this.orangeMoneyName,
    required this.orangeMoneyNumber,
    required this.instructions,
    required this.isActive,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
    required this.formattedDate,
    required this.formattedUpdatedDate,
  });

  String name;
  String number;
  String nameOfBeneficiary;
  String ifscCode;
  String mtnMobileNumber;
  String mtnName;
  String orangeMoneyNumber;
  String orangeMoneyName;
  String instructions;
  bool isActive;
  DateTime updatedAt;
  DateTime createdAt;
  int id;
  String formattedDate;
  String formattedUpdatedDate;

  factory PaymentAccount.fromJson(Map<String, dynamic> json) => PaymentAccount(
        name: json["name"] ?? '',
        number: json["number"] ?? '',
        nameOfBeneficiary: json['beneficiary_name'] ?? '',
        ifscCode: json['IFSC_code_or_bank_code'] ?? '',
        mtnMobileNumber: json['mtn_money_number'] ?? '',
        mtnName: json['mtn_name'] ?? '',
        orangeMoneyName: json['oragne_name'] ?? '',
        orangeMoneyNumber: json['orange_money_number'] ?? '',
        instructions: json["instructions"] == null ? '' : json["instructions"],
        isActive: json["is_active"].toString().toInt() == 1,
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
        formattedDate: json["formatted_date"],
        formattedUpdatedDate: json["formatted_updated_date"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "number": number,
        "beneficiary_name": nameOfBeneficiary,
        "IFSC_code_or_bank_code": ifscCode,
        "mtn_money_number": mtnMobileNumber,
        "mtn_name": mtnName,
        "orange_money_number": orangeMoneyNumber,
        "oragne_name": orangeMoneyName,
        "is_active": isActive ? "1" : "0",
        "instructions": instructions,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
        "formatted_date": formattedDate,
        "formatted_updated_date": formattedUpdatedDate,
      };
}
