class ReportModel {
  late String id;
  late String time;
  late String reportName;
  late String content;
  late String agentName;
  late String agentID;
  late String latitude;
  late String longitude;
  late String address;

  ReportModel({
    required this.id,
    required this.time,
    required this.reportName,
    required this.content,
    required this.agentName,
    required this.agentID,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  ReportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
    reportName = json['reportName'];
    content = json['content'];
    agentName = json['agentName'];
    agentID = json['agentID'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
  }

  toJson() {
    return {
      'id': id,
      'time': time,
      'reportName': reportName,
      'content': content,
      'agentName': agentName,
      'agentID': agentID,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }
}
