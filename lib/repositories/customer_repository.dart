part of '../services/customer_services.dart';

/// A repository class for managing customer-related data operations.
class CustomerRepository {
  static final CustomerRepository _customerRepository = CustomerRepository._();

  factory CustomerRepository() => _customerRepository;

  CustomerRepository._();

  Future<Either<void, String>> addCustomer({
    String? id,
    required String name,
    required String phone,
    required String address,
    required String gstNo,
    required String area,
    required String priceList,
    required String type,
    double? latitude,
    double? longitude,
  }) async {
    try {
      DioResponse dioResponse = await CustomerServices().addCustomer(
          id: id,
          name: name,
          phone: phone,
          address: address,
          gstNo: gstNo,
          area: area,
          priceList: priceList,
          type: type,
          latitudeValue: latitude,
          longitudeValue: longitude);
      if (!dioResponse.hasError) {
        bool success = dioResponse.response!.data['status'];
        if (success) {
          return Left(null);
        } else {
          return Right(dioResponse.response!.data['message']);
        }
      } else {
        return Right("Something went wrong");
      }
    } catch (e) {
      if (kDebugMode) {
        log(e.toString());
      }
      return Right('Unknown Error Occurred');
    }
  }
}
