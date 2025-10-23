import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
export 'package:geocoding/geocoding.dart';
export 'package:geolocator/geolocator.dart';
part '../repositories/location_repository.dart';

class LocationServices {
  static final LocationServices _locationService = LocationServices._();

  factory LocationServices() => _locationService;

  LocationServices._();

  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    } else if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<Placemark> getPlaceMark([Position? fetchedPosition]) async {
    Position position = fetchedPosition ?? await getCurrentPosition();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    return place;
  }
}
