// Copyright (c) 2019-2021, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

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
class ITunesSearch extends BaseSearch {
  static String FEED_API_ENDPOINT = 'https://itunes.apple.com';
  static String SEARCH_API_ENDPOINT = 'https://itunes.apple.com/search';

  final Dio _client;

  /// The search term keyword(s)
  String _term;

  /// If this property is not-null search results will be limited to this country
  Country _country;

  /// If this property is not-null search results will be limited to this genre
  Genre _genre;

  /// By default, searches will be performed against keyword(s) in [_term].
  /// Set this property to search against a different attribute.
  Attribute _attribute;

  /// Limit the number of results to [_limit]. If zero no limit will be applied
  int _limit;

  /// If non-null, the results will be limited to the language specified.
  Language _language;

  /// Set to true to disable the explicit filter.
  bool _explicit;

  int _version;

  /// Connection timeout threshold in milliseconds
  int timeout;

  /// If this property is non-null, it will be prepended to the User Agent header.
  String userAgent;

  ITunesSearch({
    this.timeout = 20000,
    this.userAgent,
  }) : _client = Dio(
          BaseOptions(
            responseType: ResponseType.plain,
            connectTimeout: timeout,
            receiveTimeout: timeout,
            headers: {
              'User-Agent': userAgent == null || userAgent.isEmpty
                  ? '$podcastSearchAgent'
                  : '${userAgent}',
            },
          ),
        );

  /// Search iTunes using the term [term]. You can limit the results to
  /// podcasts available in a specific country by supplying a [Country] option.
  /// By default, searches will be based on keywords. Supply an [Attribute]
  /// value to search by a different attribute such as Author, genre etc.
  @override
  Future<SearchResult> search(
      {String term,
      Country country,
      Attribute attribute,
      Language language,
      int limit,
      int version = 0,
      bool explicit = false,
      Map<String, dynamic> queryParams = const {}}) async {
    _term = term;
    _country = country;
    _attribute = attribute;
    _limit = limit;
    _language = language;
    _version = version;
    _explicit = explicit;

    try {
      final response = await _client.get(_buildSearchUrl(queryParams));

      final results = json.decode(response.data);

      return SearchResult.fromJson(json: results);
    } on DioError catch (e) {
      setLastError(e);
    }

    return SearchResult.fromError(lastError, lastErrorType);
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
    _country = country;
    _limit = limit;
    _explicit = explicit;
    _genre = genre;

    try {
      final response = await _client.get(
        _buildChartsUrl(),
      );

      final results = json.decode(response.data);

      return await _chartsToResults(results);
    } on DioError catch (e) {
      setLastError(e);
    }

    return SearchResult.fromError(lastError, lastErrorType);
  }

  Future<SearchResult> _chartsToResults(dynamic jsonInput) async {
    var entries = jsonInput['feed']['entry'];

    var items = <Item>[];

    try {
      if (entries != null) {
        for (var entry in entries) {
          var id = entry['id']['attributes']['im:id'];

          final response =
              await _client.get(FEED_API_ENDPOINT + '/lookup?id=$id');
          final results = json.decode(response.data);

          if (results['results'] != null) {
            var item = Item.fromJson(json: results['results'][0]);

            items.add(item);
          }
        }
      }

      return SearchResult(items.length, items);
    } on DioError catch (e) {
      setLastError(e);
    }

    return SearchResult.fromError(lastError, lastErrorType);
  }

  /// This internal method constructs a correctly encoded URL which is then
  /// used to perform the search.
  String _buildSearchUrl(Map<String, dynamic> queryParams) {
    final buf = StringBuffer(SEARCH_API_ENDPOINT);

    buf.write(_termParam());
    buf.write(_countryParam());
    buf.write(_attributeParam());
    buf.write(_limitParam());
    buf.write(_languageParam());
    buf.write(_versionParam());
    buf.write(_explicitParam());
    buf.write(_standardParam());
    queryParams.forEach((key, value) {
      buf.write('&$key=${Uri.encodeComponent(value)}');
    });

    return buf.toString();
  }

  String _buildChartsUrl() {
    final buf = StringBuffer(FEED_API_ENDPOINT);

    buf.write('/');
    buf.write(_country.countryCode.toLowerCase());

    buf.write('/rss/toppodcasts/limit=');
    buf.write(_limit);

    if (_genre != null && _genre.id != null) {
      buf.write('/genre=${_genre.id}');
    }

    buf.write('/explicit=');
    buf.write(_explicit);
    buf.write('/json');

    return buf.toString();
  }

  String _termParam() {
    return term != null && term.isNotEmpty
        ? '?term=' + Uri.encodeComponent(term)
        : '';
  }

  String _countryParam() {
    return _country != null ? '&country=' + _country.countryCode : '';
  }

  String _attributeParam() {
    return _attribute != null
        ? '&attribute=' + Uri.encodeComponent(_attribute.attribute)
        : '';
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
