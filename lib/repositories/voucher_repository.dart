part of '../services/voucher_services.dart';

class VoucherRepository {
  static final VoucherRepository _voucherRepository = VoucherRepository._();

  factory VoucherRepository() => _voucherRepository;

  VoucherRepository._();

  Future<Either<List<dynamic>, String>> createPaymentVoucher(
      VoucherBody details) async {
    try {
      DioResponse response =
          await VoucherServices().createPaymentVoucher(details);
      if (!response.hasError) {
        bool valid = response.response!.data['valid'];
        if (valid) {
          return Left(response.response!.data['result']);
        } else {
          return Right(response.response!.data['message']);
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
