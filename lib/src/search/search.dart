// Copyright (c) 2019, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:podcast_search/src/model/attribute.dart';
import 'package:podcast_search/src/model/country.dart';
import 'package:podcast_search/src/model/language.dart';
import 'package:podcast_search/src/search/search_result.dart';

/// This class handles the searching. Taking the base URL we build any parameters
/// that have been added before making a call to iTunes. The results are unpacked
/// and stored as Item instances and wrapped in a SearchResult.
class Search {
  static String API_ENDPOINT = "https://itunes.apple.com/search";

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
  Search({client}) : this.client = client ?? http.Client();

  /// Perform the actual iTunes search.
  Future<SearchResult> search(String term,
      {country,
      attribute,
      limit,
      language,
      version = 0,
      explicit = false}) async {
    this._term = term;
    this._country = country;
    this._attribute = attribute;
    this._limit = limit;
    this._language = language;
    this._version = version;
    this._explicit = explicit;

    final response = await client.get(_buildUrl());
    final results = json.decode(response.body);

    return SearchResult.fromJson(results);
  }

  /// This internal method constructs a correctly encoded URL which is then
  /// used to perform the search.
  String _buildUrl() {
    StringBuffer buf = StringBuffer(API_ENDPOINT);

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

  String _termParam() {
    return term != null && term.isNotEmpty
        ? "?term=" + Uri.encodeComponent(term)
        : "";
  }

  String _countryParam() {
    return _country != null ? "&country=" + _country.countryCode : "";
  }

  String _attributeParam() {
    return _attribute != null
        ? "&attribute=" + Uri.encodeComponent(_attribute.attribute)
        : "";
  }

  String _limitParam() {
    return _limit != 0 ? "&limit=" + _limit.toString() : "";
  }

  String _languageParam() {
    return _language != null ? "&language=" + _language.language : "";
  }

  String _versionParam() {
    return _version != 0 ? "@version=" + _version.toString() : "";
  }

  String _explicitParam() {
    return _explicit ? "&explicit=Yes" : "&explicit=No";
  }

  String _standardParam() {
    return '&media=podcast&entity=podcast';
  }

  get term => _term;
}
