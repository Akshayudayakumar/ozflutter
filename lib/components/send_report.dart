import 'dart:developer';

import 'package:ozone_erp/models/report_model.dart';
import 'package:ozone_erp/services/location_services.dart';

Future<void> sendAppOpenReport() async {
  final positionResult = await LocationRepository().getLocation();
  Position? position;
  Placemark? place;

  await positionResult.fold((positionData) async {
    final placeResult = await LocationRepository().getPlaceMark(positionData);
    await placeResult.fold((placeData) {
      position = positionData;
      place = placeData;
    }, (error) {
      log(error);
    });
  }, (error) {
    log(error);
  });

  double? latitude = position?.latitude;
  double? longitude = position?.longitude;
  String address = place == null
      ? ''
      : '${place!.street}, ${place!.subLocality}, ${place!.thoroughfare}, ${place!.locality}, ${place!.subAdministrativeArea}, ${place!.administrativeArea}, ${place!.country}';

  //TODO: send app opening report here to the backend
  String content = '';
  ReportModel report = ReportModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      time: DateTime.now().millisecondsSinceEpoch.toString(),
      reportName: 'reportName',
      content: content,
      agentName: 'agentName',
      agentID: 'agentID',
      latitude: latitude?.toString() ?? '',
      longitude: longitude?.toString() ?? '',
      address: address);
  print(report.toJson());
}
