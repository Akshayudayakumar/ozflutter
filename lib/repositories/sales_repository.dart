part of '../services/sales_service.dart';

class SalesRepository {
  static final SalesRepository _salesRepository = SalesRepository._();

  factory SalesRepository() => _salesRepository;

  SalesRepository._();

  Future<Either<SalesResponse, String>> createSales(SalesBody sales) async {
    try {
      DioResponse dioResponse = await SalesServices().createSales(sales);
      if (!dioResponse.hasError) {
        bool success = dioResponse.response!.data['status'];
        if (success) {
          return Left(SalesResponse.fromJson(dioResponse.response!.data));
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
      return Right('Unknown error occurred');
    }
  }
}
