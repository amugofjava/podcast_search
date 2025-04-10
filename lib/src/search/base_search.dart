// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

import 'package:dio/dio.dart';
import 'package:podcast_search/podcast_search.dart';

const podcastSearchAgent =
    'podcast_search/0.4.0 https://github.com/amugofjava/anytime_podcast_player';

abstract class BaseSearch {
  /// Contains the type of error returning from the search. If no error occurred it
  /// will be set to [ErrorType.none].
  ErrorType lastErrorType = ErrorType.none;

  /// If an error occurs, this will contain a user-readable error message.
  String? lastError;

  Future<SearchResult> search({
    required String term,
    Country country = Country.none,
    Attribute attribute = Attribute.none,
    String language = '',
    int limit = 0,
    int version = 0,
    bool explicit = false,
    Map<String, dynamic>? queryParams,
  });

  Future<SearchResult> charts({String genre});

  List<String> genres();

  /// If an error occurs during an HTTP GET request this method is called to
  /// determine the error and set two variables which can then be included
  /// in the results. The client can then use these variables to determine
  /// if there was an issue or not.
  void setLastError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        lastErrorType = ErrorType.connection;
        lastError = 'Connection timeout';
        break;
      case DioExceptionType.badCertificate:
        lastErrorType = ErrorType.certificate;
        lastError = 'Certificate error';
        break;
      case DioExceptionType.connectionError:
      case DioExceptionType.badResponse:
        lastErrorType = ErrorType.failed;
        lastError = 'Server returned response error ${e.response?.statusCode}';
        break;
      case DioExceptionType.cancel:
        lastErrorType = ErrorType.cancelled;
        lastError = 'Request was cancelled';
        break;
      case DioExceptionType.unknown:
        lastErrorType = ErrorType.unknown;
        lastError = 'Unknown error';
        break;
    }
  }
}
