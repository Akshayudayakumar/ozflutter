class UserModel{
  String? id;
  String? userName;
  String? userType;
  String? userAddress;
  String? userMobile;
  String? userPhone;
  String? userEmail;
  String? username;
  String? percentage;
  String? userPassword;
  String? company;
  String? isActive;
  String? isHide;
  String? branch;
  String? updatedDate;

  UserModel(
      {this.id,
      this.userName,
      this.userType,
      this.userAddress,
      this.userMobile,
      this.userPhone,
      this.userEmail,
      this.username,
      this.percentage,
      this.userPassword,
      this.company,
      this.isActive,
      this.isHide,
      this.branch,
      this.updatedDate});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'] ?? '';
    userName = json['user_name'] ?? '';
    userType = json['user_type'] ?? '';
    userAddress = json['user_address'] ?? '';
    userMobile = json['user_mobile'] ?? '';
    userPhone = json['user_phone'] ?? '';
    userEmail = json['user_email'] ?? '';
    username = json['username'] ?? '';
    percentage = json['percentage'] ?? '';
    userPassword = json['user_password'] ?? '';
    company = json['company'] ?? '';
    isActive = json['is-active'] ?? json['is_active'] ?? '';
    isHide = json['is_hide'] ?? '';
    branch = json['branch'] ?? '';
    updatedDate = json['updatedate'] ?? '';
  }

  toJson() {
    final data = <String, dynamic>{};
    data['Id'] = id;
    data['user_name'] = userName;
    data['user_type'] = userType;
    data['user_address'] = userAddress;
    data['user_mobile'] = userMobile;
    data['user_phone'] = userPhone;
    data['user_email'] = userEmail;
    data['username'] = username;
    data['percentage'] = percentage;
    data['user_password'] = userPassword;
    data['company'] = company;
    data['is-active'] = isActive;
    data['is_hide'] = isHide;
    data['branch'] = branch;
    data['updatedate'] = updatedDate;
    return data;
  }
}
