import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

import 'backend.dart';

class DioConfig {
  static final DioConfig _dioConfig = DioConfig._();

  /// ### factory DioConfig()
  /// This is the factory constructor. It's the public way to get an instance of `DioConfig`.
  /// Instead of creating a new instance every time `DioConfig()` is called, it always
  /// returns the single, pre-existing `_dioConfig` instance.
  /// This is the core of the Singleton pattern.
  factory DioConfig() => _dioConfig;

  // A private, nullable instance of the Dio client.
  // It's nullable (`?`) because it's not initialized immediately when the class is created.
  Dio? _dio;

  /// ### get getDio
  /// A public getter that provides read-only access to the private `_dio` instance.
  /// Other parts of the app can use `DioConfig().getDio` to get the configured Dio client
  /// to make API calls.
  Dio? get getDio => _dio;

  /// ### initDio()
  /// This method is responsible for initializing and configuring the `Dio` instance.
  initDio() {
    // 1. A new `Dio` object is created and assigned to the private `_dio` variable.
    _dio = Dio();
    // 2. The base URL for all API requests is set. `BackEnd.baseUrl` likely holds
    //    a constant string like "https://api.example.com/".
    _dio!.options.baseUrl = BackEnd.baseUrl;
    _dio!.interceptors.add(
      TalkerDioLogger(
        settings: const TalkerDioLoggerSettings(
          printRequestHeaders: !kReleaseMode,
          printResponseHeaders: !kReleaseMode,
          printResponseMessage: !kReleaseMode,
        ),
      ),
    );
  }

  /// ### DioConfig._() (Private Constructor)
  /// This is a private, named constructor. The underscore `_` makes it private to this file.
  /// Because the default constructor is replaced by the factory, this is the only way
  /// a `DioConfig` object can be created internally. It immediately calls `initDio()`
  /// to ensure the Dio client is set up as soon as the singleton instance is created.
  DioConfig._() {
    initDio();
  }

  Future<DioResponse> dioPostCall(String url, formData,
      {Function? sendProgress}) async {
    Response response;
    try {
      response = await getDio!.post(url,
          data: formData,
          onSendProgress: sendProgress as void Function(int, int)?);
    } on DioException catch (dioError) {
      return DioResponse.hasError(dioError);
    }
    return DioResponse.hasResponse(response);
  }

  Future<DioResponse> dioGetCall(String url) async {
    Response response;
    try {
      response = await getDio!.get(url);
    } on DioException catch (dioError) {
      return DioResponse.hasError(dioError);
    }
    return DioResponse.hasResponse(response);
  }

  Future<DioResponse> dioGetCallParams(String url, Map queryParams) async {
    Response response;
    try {
      response = await getDio!
          .get(url, queryParameters: queryParams as Map<String, dynamic>?);
    } on DioException catch (dioError) {
      return DioResponse.hasError(dioError);
    }
    return DioResponse.hasResponse(response);
  }

  Future<DioResponse> dioPostCallParams(String url, Map queryParams) async {
    Response response;
    try {
      response = await getDio!.post(
        url,
        data: queryParams as Map<String, dynamic>?,
      );
    } on DioException catch (dioError) {
      return DioResponse.hasError(dioError);
    }
    return DioResponse.hasResponse(response);
  }
}

/// ### DioResponse Class
///
/// This class acts as a standardized wrapper for responses coming from the Dio HTTP client.
/// Instead of dealing directly with Dio's `Response` object or catching `DioException`
/// everywhere in the app, this class provides a unified structure.
///
/// An instance of `DioResponse` will either contain a successful `Response` or an
/// error state, but not both.
class DioResponse {
  /// The successful response object from a Dio call. It's nullable because it will
  /// be `null` if an error occurred during the HTTP request.
  Response? response;

  /// A boolean flag that makes it easy to check if the request was successful.
  /// `true` if an error occurred, `false` otherwise.
  bool hasError = false;

  /// A user-friendly error message string. If an error occurs, this will be populated
  /// with a readable message corresponding to the type of `DioException`.
  String errorMessage = '';

  /// Stores the original `DioException` if one was caught. This is useful for
  // debugging or for accessing more detailed error information.
  late DioException dioError;

  /// ### DioResponse.hasResponse (Constructor)
  ///
  /// This is a named constructor used when the HTTP request is **successful**.
  ///
  /// - It takes the successful `Response` object from Dio as a parameter.
  /// - It assigns this `response` to the instance's `response` property.
  /// - It explicitly sets `hasError` to `false` to indicate success.
  DioResponse.hasResponse(this.response) {
    hasError = false;
  }

  /// ### DioResponse.hasError (Constructor)
  ///
  /// This is a named constructor used when the HTTP request **fails** and a
  /// `DioException` is caught.
  ///
  /// - It takes the caught `DioException` object as a parameter.
  /// - It assigns this `dioError` to the instance's `dioError` property.
  /// - It sets `hasError` to `true` to indicate failure.
  /// - It uses a `switch` statement on the `dioError.type` to populate the
  ///   `errorMessage` property with a simple, human-readable string that
  ///   explains the general cause of the failure (e.g., timeout, connection error).
  DioResponse.hasError(this.dioError) {
    hasError = true;

    switch (dioError.type) {
      case DioExceptionType.sendTimeout:
        errorMessage = 'Request Timeout';
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Response Timeout';
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request Cancelled';
        break;
      case DioExceptionType.connectionTimeout:
        errorMessage = 'connection Timeout';
        break;
      case DioExceptionType.badCertificate:
        errorMessage = 'badCertificate';
        break;
      case DioExceptionType.badResponse:
        errorMessage = 'bad response';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'connection error';
        break;
      case DioExceptionType.unknown:
        errorMessage = 'Unknown error';
        break;
    }
  }
}
