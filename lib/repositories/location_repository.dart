part of '../services/location_services.dart';

class LocationRepository {

  static final LocationRepository _locationRepository = LocationRepository._();

  factory LocationRepository() => _locationRepository;

  LocationRepository._();

  Future<Either<Position, String>> getLocation() async {
    try {
      return Left(await LocationServices().getCurrentPosition());
    } catch (e) {
      return Right(e.toString());
    }
  }

    Future<Either<Placemark, String>> getPlaceMark([Position? position]) async {
     try {
       return Left(await LocationServices().getPlaceMark(position));
     } catch (e) {
       if (kDebugMode) {
         log(e.toString());
       }
       return Right('Unknown Error Occurred');
     }
   }
}
