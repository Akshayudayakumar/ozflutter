part of '../services/sync_services.dart';

class SyncRepository {
  static final SyncRepository _syncRepository = SyncRepository._();
  factory SyncRepository() => _syncRepository;
  SyncRepository._();

  Future<Either<List<StockUpdate>, String>> fetchStock() async {
    try {
      DioResponse dioResponse = await SyncServices().fetchStock();
      if (!dioResponse.hasError) {
        bool success = dioResponse.response!.data['status'];
        if (success) {
          List<StockUpdate> stockUpdate = (dioResponse.response!.data['result']
                  ['stockdetails'] as List<dynamic>)
              .map((e) => StockUpdate.fromJson(e))
              .toList();
          return Left(stockUpdate);
        } else {
          return Right(dioResponse.response!.data['message']);
        }
      } else {
        return Right('Something went wrong');
      }
    } catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      return Right('Unknown Error Occurred');
    }
  }

  Future<Either<Map<String, dynamic>, String>> registerDevice() async {
    try {
      DioResponse dioResponse = await SyncServices().registerDevice();
      if (!dioResponse.hasError) {
        bool success = dioResponse.response!.data['status'];
        if (success) {
          return Left(dioResponse.response!.data);
        } else {
          return Right(dioResponse.response!.data['message']);
        }
      } else {
        return Right('Something went wrong');
      }
    } catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      return Right('Unknown Error Occurred');
    }
  }
}
