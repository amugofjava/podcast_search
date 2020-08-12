// Copyright (c) 2019, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcast_search/src/model/attribute.dart';
import 'package:podcast_search/src/model/country.dart';
import 'package:podcast_search/src/model/language.dart';
import 'package:podcast_search/src/search/search_result.dart';

/// This class handles the searching. Taking the base URL we build any parameters
/// that have been added before making a call to iTunes. The results are unpacked
/// and stored as Item instances and wrapped in a SearchResult.
class Search {
  static String FEED_API_ENDPOINT = 'https://itunes.apple.com';
  static String SEARCH_API_ENDPOINT = 'https://itunes.apple.com/search';

  final Dio _client;

  String _term;
  Country _country;
  Attribute _attribute;
  int _limit;
  Language _language;
  int _version;
  bool _explicit;
  int timeout;
  ErrorType _lastErrorType = ErrorType.none;
  String _lastError;

  Search({this.timeout = 20000})
      : _client = Dio(
          BaseOptions(
            connectTimeout: timeout,
            receiveTimeout: timeout,
            headers: {
              HttpHeaders.userAgentHeader: 'podcast_search Dart/1.0',
            },
          ),
        );

  /// Search iTunes using the term [term]. You can limit the results to
  /// podcasts available in a specific country by supplying a [Country] option.
  /// By default, searches will be based on keywords. Supply an [Attribute]
  /// value to search by a different attribute such as Author, genre etc.
  Future<SearchResult> search(
    String term, {
    Country country,
    Attribute attribute,
    int limit,
    Language language,
    int version = 0,
    bool explicit = false,
  }) async {
    _term = term;
    _country = country;
    _attribute = attribute;
    _limit = limit;
    _language = language;
    _version = version;
    _explicit = explicit;

    try {
      final response = await _client.get(_buildSearchUrl());

      final results = json.decode(response.data);

      return SearchResult.fromJson(results);
    } on DioError catch (e) {
      _setLastError(e);
    }

    return SearchResult.fromError(_lastError, _lastErrorType);
  }

  /// Fetches the list of top podcasts
  ///
  /// Optionally takes a [limit] and [Country] filter. Defaults to
  /// limit of 20 and the UK.
  ///
  /// The charts is returned as a 'feed'. In order to be compatible with
  /// [SearchResult] we need to parse this feed and fetch the underlying
  /// result for each item resulting in a HTTP call for each result. Given
  /// the infrequent update of the chart feed it is recommended that clients
  /// cache the results.
  Future<SearchResult> charts({
    Country country = Country.UNITED_KINGDOM,
    int limit = 20,
    bool explicit = false,
  }) async {
    _country = country;
    _limit = limit;
    _explicit = explicit;

    try {
      final response = await _client.get(
        _buildChartsUrl(),
      );

      final results = json.decode(response.data);

      return await _chartsToResults(results);
    } on DioError catch (e) {
      _setLastError(e);
    }

    return SearchResult.fromError(_lastError, _lastErrorType);
  }

  Future<SearchResult> _chartsToResults(dynamic jsonInput) async {
    var entries = jsonInput['feed']['entry'];

    var items = <Item>[];

    try {
      if (entries != null) {
        for (var entry in entries) {
          var id = entry['id']['attributes']['im:id'];

          final response = await _client.get(FEED_API_ENDPOINT + '/lookup?id=$id');

          final results = json.decode(response.data);

          if (results['results'] != null) {
            var item = Item.fromJson(results['results'][0]);

            items.add(item);
          }
        }
      }

      return SearchResult(items.length, items);
    } on DioError catch (e) {
      _setLastError(e);
    }

    return SearchResult.fromError(_lastError, _lastErrorType);
  }

  /// If an error occurs during an HTTP GET request this method is called to
  /// determine the error and set two variables which can then be included
  /// in the results. The client can then use these variables to determine
  /// if there was an issue or not.
  void _setLastError(DioError e) {
    switch (e.type) {
      case DioErrorType.DEFAULT:
      case DioErrorType.CONNECT_TIMEOUT:
      case DioErrorType.SEND_TIMEOUT:
      case DioErrorType.RECEIVE_TIMEOUT:
        _lastErrorType = ErrorType.connection;
        _lastError = 'Connection timeout';
        break;
      case DioErrorType.RESPONSE:
        _lastErrorType = ErrorType.failed;
        _lastError = 'Server returned response error ${e.response?.statusCode}';
        break;
      case DioErrorType.CANCEL:
        _lastErrorType = ErrorType.cancelled;
        _lastError = 'Request was cancelled';
        break;
    }
  }

  /// This internal method constructs a correctly encoded URL which is then
  /// used to perform the search.
  String _buildSearchUrl() {
    final buf = StringBuffer(SEARCH_API_ENDPOINT);

    buf.write(_termParam());
    buf.write(_countryParam());
    buf.write(_attributeParam());
    buf.write(_limitParam());
    buf.write(_languageParam());
    buf.write(_versionParam());
    buf.write(_explicitParam());
    buf.write(_standardParam());

    return buf.toString();
  }

  String _buildChartsUrl() {
    final buf = StringBuffer(FEED_API_ENDPOINT);

    buf.write('/');
    buf.write(_country.countryCode.toLowerCase());
    buf.write('/rss/toppodcasts/limit=');
    buf.write(_limit);
    buf.write('/explicit=');
    buf.write(_explicit);
    buf.write('/json');

    return buf.toString();
  }

  String _termParam() {
    return term != null && term.isNotEmpty ? '?term=' + Uri.encodeComponent(term) : '';
  }

  String _countryParam() {
    return _country != null ? '&country=' + _country.countryCode : '';
  }

  String _attributeParam() {
    return _attribute != null ? '&attribute=' + Uri.encodeComponent(_attribute.attribute) : '';
  }

  String _limitParam() {
    return _limit != 0 ? '&limit=' + _limit.toString() : '';
  }

  String _languageParam() {
    return _language != null ? '&language=' + _language.language : '';
  }

  String _versionParam() {
    return _version != 0 ? '@version=' + _version.toString() : '';
  }

  String _explicitParam() {
    return _explicit ? '&explicit=Yes' : '&explicit=No';
  }

  String _standardParam() {
    return '&media=podcast&entity=podcast';
  }

  /// Returns the search term.
  String get term => _term;
}
