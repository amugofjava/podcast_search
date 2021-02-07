// Copyright (c) 2019-2021, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcast_search/src/model/attribute.dart';
import 'package:podcast_search/src/model/country.dart';
import 'package:podcast_search/src/model/language.dart';
import 'package:podcast_search/src/model/search_result.dart';
import 'package:podcast_search/src/search/base_search.dart';

/// This class handles the searching. Taking the base URL we build any parameters
/// that have been added before making a call to iTunes. The results are unpacked
/// and stored as Item instances and wrapped in a SearchResult.
class PodcastIndexSearch extends BaseSearch {
  static String SEARCH_API_ENDPOINT = 'https://api.podcastindex.org/api/1.0/search';

  PodcastIndexProvider podcastIndexProvider;

  Dio _client;

  /// The search term keyword(s)
  String _term;

  /// Limit the number of results to [_limit]. If zero no limit will be applied
  int _limit;

  /// Set to true to disable the explicit filter.
  bool _explicit;

  /// Connection timeout threshold in milliseconds
  int timeout;

  /// If this property is non-null, it will be prepended to the User Agent header.
  String userAgent;

  /// Contains the type of error returning from the search. If no error occurred it
  /// will be set to [ErrorType.none].
  final ErrorType _lastErrorType = ErrorType.none;

  /// If an error occurs, this will contain a user-readable error message.
  String _lastError;

  PodcastIndexSearch({
    this.timeout = 20000,
    this.userAgent,
    this.podcastIndexProvider,
  }) {
    var unixTime = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    var newUnixTime = unixTime.toString();
    var firstChunk = utf8.encode(podcastIndexProvider.key);
    var secondChunk = utf8.encode(podcastIndexProvider.secret);
    var thirdChunk = utf8.encode(newUnixTime);

    var output = AccumulatorSink<Digest>();
    var input = sha1.startChunkedConversion(output);
    input.add(firstChunk);
    input.add(secondChunk);
    input.add(thirdChunk);
    input.close();
    var digest = output.events.single;

    _client = Dio(
      BaseOptions(
        connectTimeout: timeout,
        receiveTimeout: timeout,
        responseType: ResponseType.json,
        headers: {
          'X-Auth-Date': newUnixTime,
          'X-Auth-Key': podcastIndexProvider.key,
          'Authorization': digest.toString(),
          HttpHeaders.userAgentHeader: userAgent == null ? '$podcastSearchAgent' : '${userAgent} ($podcastSearchAgent)',
        },
      ),
    );
  }

  /// Search iTunes using the term [term]. You can limit the results to
  /// podcasts available in a specific country by supplying a [Country] option.
  /// By default, searches will be based on keywords. Supply an [Attribute]
  /// value to search by a different attribute such as Author, genre etc.
  @override
  Future<SearchResult> search({
    String term,
    Country country,
    Attribute attribute,
    Language language,
    int limit,
    int version = 0,
    bool explicit = false,
  }) async {
    _term = term;
    _limit = limit;
    _explicit = explicit;

    try {
      var response = await _client.get(buildSearchUrl());

      return SearchResult.fromJson(json: response.data, type: ResultType.podcastIndex);
    } on DioError catch (e) {
      setLastError(e);
    }

    return SearchResult.fromError(_lastError, _lastErrorType);
  }

  /// Fetches the list of top podcasts
  /// Optionally takes a [limit] and [Country] filter. Defaults to
  /// limit of 20 and the UK.
  ///
  /// The charts is returned as a 'feed'. In order to be compatible with
  /// [SearchResult] we need to parse this feed and fetch the underlying
  /// result for each item resulting in a HTTP call for each result. Given
  /// the infrequent update of the chart feed it is recommended that clients
  /// cache the results.
  @override
  Future<SearchResult> charts({
    Country country = Country.UNITED_KINGDOM,
    int limit = 20,
    bool explicit = false,
    Genre genre,
  }) async {
    /// This should never be thrown as charts is only handled by iTunes for now.
    throw UnimplementedError();
  }

  /// This internal method constructs a correctly encoded URL which is then
  /// used to perform the search.
  String buildSearchUrl() {
    final buf = StringBuffer(SEARCH_API_ENDPOINT);

    buf.write(_termParam());
    buf.write(_limitParam());
    buf.write(_explicitParam());

    return buf.toString();
  }

  String _termParam() {
    return term != null && term.isNotEmpty ? '/byterm?q=' + Uri.encodeComponent(term) : '';
  }

  String _limitParam() {
    return _limit != 0 ? '&max=' + _limit.toString() : '';
  }

  String _explicitParam() {
    return _explicit ? '&clean' : '';
  }

  /// Returns the search term.
  String get term => _term;
}
