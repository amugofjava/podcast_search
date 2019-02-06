// Copyright (c) 2019, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:podcast_search/src/model/podcast.dart';

/// This class is a container for our search results or for any error message
/// received whilst attempting to fetch the podcast data.
class SearchResult {
  final int resultCount;
  final bool successful;
  final List<Podcast> items;
  final String lastError;

  SearchResult(this.resultCount, this.items)
      : this.successful = true,
        this.lastError = "";

  SearchResult.fromError(this.lastError)
      : this.successful = false,
        this.resultCount = 0,
        this.items = [];

  factory SearchResult.fromJson(dynamic json) {
    /// Did we get an error message?
    if (json['errorMessage'] != null) {
      return SearchResult.fromError(json['errorMessage']);
    }

    /// Fetch the results from the JSON data.
    final items = json['results'] == null
        ? null
        : (json['results'] as List)
            .cast<Map<String, Object>>()
            .map((Map<String, Object> item) {
            return Podcast.fromJson(item);
          }).toList();

    return SearchResult(json['resultCount'], items);
  }
}
