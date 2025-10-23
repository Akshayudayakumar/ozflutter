// To parse this JSON data, do
//
//     final loginModel = loginModelFromMap(jsonString);

import 'dart:convert';

class LoginModel {
  LoginModel({
    this.code,
    this.message,
    this.data,
  });

  int? code;
  String? message;
  Data? data;

  factory LoginModel.fromJson(String str) =>
      LoginModel.fromMap(json.decode(str));

  factory LoginModel.fromMap(Map<String, dynamic> json) => LoginModel(
    code: json["code"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromMap(json["data"]),
  );
}

class Data {
  Data({
    this.loguser,
    this.famliy,
    this.selectedDistricts,
    this.selectedTaluk,
    this.selectedStates,
    this.token,
  });

  Loguser? loguser;
  List<Famliy>? famliy;
  List<SelectedDistrict>? selectedDistricts;
  List<SelectedDistrict>? selectedTaluk;
  List<SelectedState>? selectedStates;
  String? token;

  factory Data.fromJson(String str) => Data.fromMap(json.decode(str));

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    loguser:
    json["loguser"] == null ? null : Loguser.fromMap(json["loguser"]),
    famliy: json["famliy"] == null
        ? []
        : List<Famliy>.from(json["famliy"]!.map((x) => Famliy.fromMap(x))),
    selectedDistricts: json["selectedDistricts"] == null
        ? []
        : List<SelectedDistrict>.from(json["selectedDistricts"]!
        .map((x) => SelectedDistrict.fromMap(x))),
    selectedTaluk: json["selectedTaluk"] == null
        ? []
        : List<SelectedDistrict>.from(
        json["selectedTaluk"]!.map((x) => SelectedDistrict.fromMap(x))),
    selectedStates: json["selectedStates"] == null
        ? []
        : List<SelectedState>.from(
        json["selectedStates"]!.map((x) => SelectedState.fromMap(x))),
    token: json["token"],
  );
}

class Famliy {
  Famliy({
    this.name,
    this.relation,
    this.id,
    this.missionariyId,
  });

  String? name;
  String? relation;
  int? id;
  int? missionariyId;

  factory Famliy.fromJson(String str) => Famliy.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Famliy.fromMap(Map<String, dynamic> json) => Famliy(
    name: json["name"],
    relation: json["relation"],
    id: json["id"],
    missionariyId: json["missionariy_Id"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "relation": relation,
    "id": id,
    "missionariy_Id": missionariyId,
  };
}

class Loguser {
  Loguser({
    this.name,
    this.emailAddress,
    this.userName,
    this.phoneNumber,
    this.address,
    this.categoryId,
    this.missionariesCategory,
    this.password,
    this.noLoginAttempt,
    this.isLocked,
    this.salt,
    this.photo,
    this.stateId,
    this.districtId,
    this.talukId,
    this.isPartialMenu,
    this.isDeleted,
    this.id,
    this.createdDate,
    this.updatedDate,
  });

  String? name;
  String? emailAddress;
  String? userName;
  String? phoneNumber;
  String? address;
  int? categoryId;
  SelectedState? missionariesCategory;
  String? password;
  int? noLoginAttempt;
  int? isLocked;
  String? salt;
  String? photo;
  String? stateId;
  String? districtId;
  String? talukId;
  bool? isPartialMenu;
  bool? isDeleted;
  int? id;
  DateTime? createdDate;
  DateTime? updatedDate;

  factory Loguser.fromJson(String str) => Loguser.fromMap(json.decode(str));

  factory Loguser.fromMap(Map<String, dynamic> json) => Loguser(
    name: json["name"],
    emailAddress: json["emailAddress"],
    userName: json["userName"],
    phoneNumber: json["phoneNumber"],
    address: json["address"],
    categoryId: json["categoryId"],
    missionariesCategory: json["missionariesCategory"] == null
        ? null
        : SelectedState.fromMap(json["missionariesCategory"]),
    password: json["password"],
    noLoginAttempt: json["noLoginAttempt"],
    isLocked: json["isLocked"],
    salt: json["salt"],
    photo: json["photo"],
    stateId: json["state_Id"],
    districtId: json["districtId"],
    talukId: json["talukId"],
    isPartialMenu: json["isPartialMenu"],
    isDeleted: json["isDeleted"],
    id: json["id"],
    createdDate: json["createdDate"] == null
        ? null
        : DateTime.parse(json["createdDate"]),
    updatedDate: json["updatedDate"] == null
        ? null
        : DateTime.parse(json["updatedDate"]),
  );
}

class SelectedState {
  String? name;
  int? id;
  DateTime? createdDate;
  DateTime? updatedDate;

  SelectedState({
    this.name,
    this.id,
    this.createdDate,
    this.updatedDate,
  });

  factory SelectedState.fromMap(Map<String, dynamic> json) => SelectedState(
    name: json["name"],
    id: json["id"],
    createdDate: json["createdDate"] == null
        ? null
        : DateTime.parse(json["createdDate"]),
    updatedDate: json["updatedDate"] == null
        ? null
        : DateTime.parse(json["updatedDate"]),
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "id": id,
    "createdDate": createdDate?.toIso8601String(),
    "updatedDate": updatedDate?.toIso8601String(),
  };
}

class MissionariesCategory {
  String? name;
  int? id;
  DateTime? createdDate;
  DateTime? updatedDate;

  MissionariesCategory({
    this.name,
    this.id,
    this.createdDate,
    this.updatedDate,
  });

  factory MissionariesCategory.fromMap(Map<String, dynamic> json) =>
      MissionariesCategory(
        name: json["name"],
        id: json["id"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        updatedDate: json["updatedDate"] == null
            ? null
            : DateTime.parse(json["updatedDate"]),
      );

  Map<String, dynamic> toMap() => {
    "name": name,
    "id": id,
    "createdDate": createdDate?.toIso8601String(),
    "updatedDate": updatedDate?.toIso8601String(),
  };
}

class Selected {
  String? name;
  int? stateId;
  dynamic state;
  int? id;
  DateTime? createdDate;
  DateTime? updatedDate;
  int? districtId;
  dynamic district;

  Selected({
    this.name,
    this.stateId,
    this.state,
    this.id,
    this.createdDate,
    this.updatedDate,
    this.districtId,
    this.district,
  });

  factory Selected.fromMap(Map<String, dynamic> json) => Selected(
    name: json["name"],
    stateId: json["stateId"],
    state: json["state"],
    id: json["id"],
    createdDate: json["createdDate"] == null
        ? null
        : DateTime.parse(json["createdDate"]),
    updatedDate: json["updatedDate"] == null
        ? null
        : DateTime.parse(json["updatedDate"]),
    districtId: json["districtId"],
    district: json["district"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "stateId": stateId,
    "state": state,
    "id": id,
    "createdDate": createdDate?.toIso8601String(),
    "updatedDate": updatedDate?.toIso8601String(),
  };
}

class SelectedDistrict {
  String? name;
  int? stateId;
  dynamic state;
  int? id;
  DateTime? createdDate;
  DateTime? updatedDate;
  int? districtId;
  SelectedDistrict? district;

  SelectedDistrict({
    this.name,
    this.stateId,
    this.state,
    this.id,
    this.createdDate,
    this.updatedDate,
    this.districtId,
    this.district,
  });

  factory SelectedDistrict.fromMap(Map<String, dynamic> json) =>
      SelectedDistrict(
        name: json["name"],
        stateId: json["stateId"],
        state: json["state"],
        id: json["id"],
        createdDate: json["createdDate"] == null
            ? null
            : DateTime.parse(json["createdDate"]),
        updatedDate: json["updatedDate"] == null
            ? null
            : DateTime.parse(json["updatedDate"]),
        districtId: json["districtId"],
        district: json["district"] == null
            ? null
            : SelectedDistrict.fromMap(json["district"]),
      );

  Map<String, dynamic> toMap() => {
    "name": name,
    "stateId": stateId,
    "state": state,
    "id": id,
    "createdDate": createdDate?.toIso8601String(),
    "updatedDate": updatedDate?.toIso8601String(),
    "districtId": districtId,
    "district": district?.toMap(),
  };
}
