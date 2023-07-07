// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

import 'package:podcast_search/src/model/item.dart';

enum ErrorType {
  none,
  cancelled,
  failed,
  connection,
  certificate,
  timeout,
  unknown,
}

enum ResultType {
  itunes,
  podcastIndex,
}

const startTagMap = {
  ResultType.itunes: 'results',
  ResultType.podcastIndex: 'feeds',
};
const countTagMap = {
  ResultType.itunes: 'resultCount',
  ResultType.podcastIndex: 'count',
};

/// This class is a container for our search results or for any error message
/// received whilst attempting to fetch the podcast data.
class SearchResult {
  /// The number of podcasts found.
  final int resultCount;

  /// True if the search was successful; false otherwise.
  final bool successful;

  /// The list of search results.
  final List<Item> items;

  /// The last error.
  final String lastError;

  /// The type of error.
  final ErrorType lastErrorType;

  /// Date & time of search
  final DateTime processedTime;

  SearchResult({
    this.resultCount = 0,
    this.items = const <Item>[],
  })  : successful = true,
        lastError = '',
        lastErrorType = ErrorType.none,
        processedTime = DateTime.now();

  SearchResult.fromError({
    this.lastError = '',
    this.lastErrorType = ErrorType.none,
  })  : successful = false,
        resultCount = 0,
        processedTime = DateTime.now(),
        items = [];

  factory SearchResult.fromJson(
      {required dynamic json, ResultType type = ResultType.itunes}) {
    /// Did we get an error message?
    if (json['errorMessage'] != null) {
      return SearchResult.fromError(
          lastError: json['errorMessage'] ?? '',
          lastErrorType: ErrorType.failed);
    }

    var dataStart = startTagMap[type];
    var dataCount = countTagMap[type];

    /// Fetch the results from the JSON data.
    final items = json[dataStart] == null
        ? null
        : (json[dataStart] as List)
            .cast<Map<String, dynamic>>()
            .map((Map<String, dynamic> item) {
            return Item.fromJson(json: item, type: type);
          }).toList();

    return SearchResult(
        resultCount: json[dataCount] ?? 0, items: items ?? <Item>[]);
  }
}
