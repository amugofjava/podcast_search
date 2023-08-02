// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcast_search/src/search/base_search.dart';

/// This class handles the searching. Taking the base URL we build any parameters
/// that have been added before making a call to iTunes. The results are unpacked
/// and stored as Item instances and wrapped in a SearchResult.
final class ITunesSearch extends BaseSearch {
  static String feedApiEndpoint = 'https://itunes.apple.com';
  static String searchApiEndpoint = 'https://itunes.apple.com/search';

  static const _genres = <String, int>{
    '': -1,
    'Arts': 1301,
    'Business': 1321,
    'Comedy': 1303,
    'Education': 1304,
    'Fiction': 1483,
    'Government': 1511,
    'Health & Fitness': 1512,
    'History': 1487,
    'Kids & Family': 1305,
    'Leisure': 1502,
    'Music': 1301,
    'News': 1489,
    'Religion & Spirituality': 1314,
    'Science': 1533,
    'Society & Culture': 1324,
    'Sports': 1545,
    'TV & Film': 1309,
    'Technology': 1318,
    'True Crime': 1488,
  };
  final Dio _client;

  /// The search term keyword(s)
  String? _term;

  /// If this property is not-null search results will be limited to this country
  Country _country = Country.none;

  /// If this property is not-null search results will be limited to this genre
  String _genre = '';

  /// By default, searches will be performed against keyword(s) in [_term].
  /// Set this property to search against a different attribute.
  Attribute? _attribute;

  /// Limit the number of results to [_limit]. If zero no limit will be applied
  int? _limit;

  /// If non-null, the results will be limited to the language specified.
  late Language _language;

  /// Set to true to disable the explicit filter.
  bool? _explicit;

  int? _version;

  /// Connection timeout threshold in milliseconds
  int timeout;

  /// If this property is non-null, it will be prepended to the User Agent header.
  String? userAgent;

  ITunesSearch({
    this.timeout = 20000,
    this.userAgent,
  }) : _client = Dio(
          BaseOptions(
            responseType: ResponseType.plain,
            connectTimeout: Duration(milliseconds: timeout),
            receiveTimeout: Duration(milliseconds: timeout),
            headers: {
              'User-Agent': userAgent == null || userAgent.isEmpty
                  ? podcastSearchAgent
                  : userAgent,
            },
          ),
        );

  /// Search iTunes using the term [term]. You can limit the results to
  /// podcasts available in a specific country by supplying a [Country] option.
  /// By default, searches will be based on keywords. Supply an [Attribute]
  /// value to search by a different attribute such as Author, genre etc.
  @override
  Future<SearchResult> search(
      {String? term,
      Country country = Country.none,
      Attribute attribute = Attribute.none,
      Language language = Language.none,
      int limit = 0,
      int version = 0,
      bool explicit = false,
      Map<String, dynamic>? queryParams = const {}}) async {
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
    } on DioException catch (e) {
      setLastError(e);
    }

    return SearchResult.fromError(
        lastError: lastError ?? '', lastErrorType: lastErrorType);
  }

  /// Fetches the list of top podcasts
  /// Optionally takes a [limit] and [Country] filter. Defaults to
  /// limit of 20 and the no specified country.
  ///
  /// The charts is returned as a 'feed'. In order to be compatible with
  /// [SearchResult] we need to parse this feed and fetch the underlying
  /// result for each item resulting in a HTTP call for each result. Given
  /// the infrequent update of the chart feed it is recommended that clients
  /// cache the results.
  @override
  Future<SearchResult> charts({
    Country country = Country.none,
    int limit = 20,
    bool explicit = false,
    String genre = '',
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
    } on DioException catch (e) {
      setLastError(e);
    }

    return SearchResult.fromError(
        lastError: lastError ?? '', lastErrorType: lastErrorType);
  }

  @override
  List<String> genres() => _genres.keys.toList(growable: false);

  /// The charts data returned does not contain everything we need to present
  /// to the client. For each entry, we call the main API to get the full
  /// details for each podcast.
  Future<SearchResult> _chartsToResults(dynamic jsonInput) async {
    var entries = jsonInput['feed']['entry'];

    var items = <Item>[];

    try {
      if (entries != null) {
        for (var entry in entries) {
          var id = entry['id']['attributes']['im:id'];
          var title = entry['title']['label'];

          final response = await _client.get('$feedApiEndpoint/lookup?id=$id');
          final results = json.decode(response.data);
          final count = results['resultCount'] as int;

          if (count == 0) {
            // ignore: avoid_print
            print(
                'Warning: Could not find $title via lookup id: $feedApiEndpoint/lookup?id=$id - skipped');
          }

          if (count > 0 && results['results'] != null) {
            var item = Item.fromJson(json: results['results'][0]);

            items.add(item);
          }
        }
      }

      return SearchResult(resultCount: items.length, items: items);
    } on DioException catch (e) {
      setLastError(e);
    }

    return SearchResult.fromError(
        lastError: lastError ?? '', lastErrorType: lastErrorType);
  }

  /// This internal method constructs a correctly encoded URL which is then
  /// used to perform the search.
  String _buildSearchUrl(Map<String, dynamic>? queryParams) {
    final buf = StringBuffer(searchApiEndpoint);

    buf.write(_termParam());
    buf.write(_countryParam());
    buf.write(_attributeParam());
    buf.write(_limitParam());
    buf.write(_languageParam());
    buf.write(_versionParam());
    buf.write(_explicitParam());
    buf.write(_standardParam());

    if (queryParams != null) {
      queryParams.forEach((key, value) {
        buf.write('&$key=${Uri.encodeComponent(value)}');
      });
    }

    return buf.toString();
  }

  String _buildChartsUrl() {
    final buf = StringBuffer(feedApiEndpoint);

    buf.write('/');
    buf.write(_country.code);

    buf.write('/rss/toppodcasts/limit=');
    buf.write(_limit);

    if (_genre != '') {
      var g = _genres[_genre];

      if (g != null) {
        buf.write('/genre=$g');
      }
    }

    buf.write('/explicit=');
    buf.write(_explicit);
    buf.write('/json');

    return buf.toString();
  }

  String _termParam() {
    return term != null && term!.isNotEmpty
        ? '?term=${Uri.encodeComponent(term!)}'
        : '';
  }

  String _countryParam() {
    return _country != Country.none ? '&country=${_country.code}' : '';
  }

  String _attributeParam() {
    return _attribute != Attribute.none
        ? '&attribute=${Uri.encodeComponent(_attribute!.attribute)}'
        : '';
  }

  String _limitParam() {
    return _limit != 0 ? '&limit=$_limit' : '';
  }

  String _languageParam() {
    return _language != Language.none ? '&language=${_language.code}' : '';
  }

  String _versionParam() {
    return _version != 0 ? '@version=$_version' : '';
  }

  String _explicitParam() {
    return _explicit! ? '&explicit=Yes' : '&explicit=No';
  }

  String _standardParam() {
    return '&media=podcast&entity=podcast';
  }

  /// Returns the search term.
  String? get term => _term;
}
