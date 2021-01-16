// Copyright (c) 2019, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:podcast_search/src/model/item.dart';

enum ErrorType { none, cancelled, failed, connection, timeout }

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

  SearchResult(this.resultCount, this.items)
      : successful = true,
        lastError = '',
        lastErrorType = ErrorType.none;

  SearchResult.fromError(this.lastError, this.lastErrorType)
      : successful = false,
        resultCount = 0,
        items = [];

  factory SearchResult.fromJson(dynamic json) {
    /// Did we get an error message?
    if (json['errorMessage'] != null) {
      return SearchResult.fromError(json['errorMessage'], ErrorType.failed);
    }

    /// Fetch the results from the JSON data.
    final items = json['results'] == null
        ? null
        : (json['results'] as List).cast<Map<String, Object>>().map((Map<String, Object> item) {
            return Item.fromJson(item);
          }).toList();

    return SearchResult(json['resultCount'], items);
  }
}
