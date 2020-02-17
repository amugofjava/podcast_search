// Copyright (c) 2019, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:podcast_search/src/model/attribute.dart';
import 'package:podcast_search/src/model/country.dart';
import 'package:podcast_search/src/model/language.dart';
import 'package:podcast_search/src/search/search_result.dart';

import '../../podcast_search.dart';

/// This class handles the searching. Taking the base URL we build any parameters
/// that have been added before making a call to iTunes. The results are unpacked
/// and stored as Item instances and wrapped in a SearchResult.
class Search {
  static String FEED_API_ENDPOINT = 'https://itunes.apple.com';
  static String SEARCH_API_ENDPOINT = 'https://itunes.apple.com/search';

  final http.Client client;

  String _term;
  Country _country;
  Attribute _attribute;
  int _limit;
  Language _language;
  int _version;
  bool _explicit;

  /// By default we use our own http client instance, but the user can pass
  /// in a difference instance if required.
  Search({
    client,
  }) : client = client ?? http.Client();

  /// Search iTunes using the term [term].
  Future<SearchResult> search(
    String term, {
    country,
    attribute,
    limit,
    language,
    version = 0,
    explicit = false,
  }) async {
    _term = term;
    _country = country;
    _attribute = attribute;
    _limit = limit;
    _language = language;
    _version = version;
    _explicit = explicit;

    final response = await client.get(_buildSearchUrl(),
        headers: {'User-Agent': 'podcast_search Dart/1.0'});

    final results = json.decode(utf8.decode(response.bodyBytes));

    return SearchResult.fromJson(results);
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
  Future<SearchResult> charts(
      {Country country = Country.UNITED_KINGDOM,
      limit = 20,
      explicit = false}) async {
    _country = country;
    _limit = limit;
    _explicit = explicit;

    final response = await client.get(_buildChartsUrl(),
        headers: {'User-Agent': 'podcast_search Dart/1.0'});

    final results = json.decode(utf8.decode(response.bodyBytes));

    return await _chartsToResults(results);
  }

  Future<SearchResult> _chartsToResults(dynamic jsonInput) async {
    var entries = jsonInput['feed']['entry'];

    var items = <Item>[];

    if (entries != null) {
      for (var entry in entries) {
        var id = entry['id']['attributes']['im:id'];

        final response = await client.get(FEED_API_ENDPOINT + '/lookup?id=$id',
            headers: {'User-Agent': 'podcast_search Dart/1.0'});

        final results = json.decode(utf8.decode(response.bodyBytes));

        if (results['results'] != null) {
          var item = Item.fromJson(results['results'][0]);

          items.add(item);
        }
      }
    }

    return SearchResult(items.length, items);
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
