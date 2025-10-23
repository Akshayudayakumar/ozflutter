import 'dart:convert';

class VoucherBody {
  VoucherBody({
    String? amount,
    String? narration,
    String? date,
    String? voucherId,
    String? createdBy,
    String? type,
    String? billType,
    String? vid,
    String? toid,
    String? loginUserId,
    String? latitude,
    String? longitude,
    List<dynamic>? aeging,
  }) {
    _amount = amount;
    _narration = narration;
    _date = date;
    _voucherId = voucherId;
    _createdBy = createdBy;
    _type = type;
    _billType = billType;
    _vid = vid;
    _toid = toid;
    _loginUserId = loginUserId;
    _latitude = latitude;
    _longitude = longitude;
    _aeging = aeging;
  }

  VoucherBody.fromJson(dynamic json) {
    _amount = json['amount'];
    _narration = json['narration'];
    _date = json['date'];
    _voucherId = json['voucher_id'];
    _createdBy = json['created_by'];
    _type = json['type'];
    _billType = json['bill_type'];
    _vid = json['vid'];
    _toid = json['toid'];
    _loginUserId = json['login_user_id'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    if (json['aeging'] != null) {
      _aeging = [];
      if (json['aeging'] is String) {
        List<dynamic> aeging = jsonDecode(json['aeging']).toList();
        aeging.forEach((v) {
          _aeging?.add(v);
        });
      } else {
        json['aeging'].forEach((v) {
          _aeging?.add(v);
        });
      }
    }
  }
  String? _amount;
  String? _narration;
  String? _date;
  String? _voucherId;
  String? _createdBy;
  String? _type;
  String? _billType;
  String? _vid;
  String? _toid;
  String? _loginUserId;
  String? _latitude;
  String? _longitude;
  List<dynamic>? _aeging;
  VoucherBody copyWith({
    String? amount,
    String? narration,
    String? date,
    String? voucherId,
    String? createdBy,
    String? type,
    String? billType,
    String? vid,
    String? toid,
    String? loginUserId,
    String? latitude,
    String? longitude,
    List<dynamic>? aeging,
  }) =>
      VoucherBody(
        amount: amount ?? _amount,
        narration: narration ?? _narration,
        date: date ?? _date,
        voucherId: voucherId ?? _voucherId,
        createdBy: createdBy ?? _createdBy,
        type: type ?? _type,
        billType: billType ?? _billType,
        vid: vid ?? _vid,
        toid: toid ?? _toid,
        loginUserId: loginUserId ?? _loginUserId,
        latitude: latitude ?? _latitude,
        longitude: longitude ?? _longitude,
        aeging: aeging ?? _aeging,
      );
  String? get amount => _amount;
  String? get narration => _narration;
  String? get date => _date;
  String? get voucherId => _voucherId;
  String? get createdBy => _createdBy;
  String? get type => _type;
  String? get billType => _billType;
  String? get vid => _vid;
  String? get toid => _toid;
  String? get loginUserId => _loginUserId;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  List<dynamic>? get aeging => _aeging;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['amount'] = _amount;
    map['narration'] = _narration;
    map['date'] = _date;
    map['voucher_id'] = _voucherId;
    map['created_by'] = _createdBy;
    map['type'] = _type;
    map['bill_type'] = _billType;
    map['vid'] = _vid;
    map['toid'] = _toid;
    map['login_user_id'] = _loginUserId;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    if (_aeging != null) {
      map['aeging'] = _aeging?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class VoucherTypes {
  static const String payment = 'Payment';
  static const String receipt = 'Receipt';
}
