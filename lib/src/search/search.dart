// Copyright (c) 2019-2021, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:podcast_search/podcast_search.dart';
import 'package:podcast_search/src/model/attribute.dart';
import 'package:podcast_search/src/model/country.dart';
import 'package:podcast_search/src/model/language.dart';
import 'package:podcast_search/src/model/search_result.dart';
import 'package:podcast_search/src/search/itunes_search.dart';
import 'package:podcast_search/src/search/podcast_index_search.dart';
import 'package:podcast_search/src/search/providers/providers.dart';

/// This class handles the searching. Taking the base URL we build any parameters
/// that have been added before making a call to iTunes. The results are unpacked
/// and stored as Item instances and wrapped in a SearchResult.
class Search {
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

  Search({this.userAgent});

  /// Search iTunes using the term [term]. You can limit the results to
  /// podcasts available in a specific country by supplying a [Country] option.
  /// By default, searches will be based on keywords. Supply an [Attribute]
  /// value to search by a different attribute such as Author, genre etc.
  Future<SearchResult> search(String term,
      {SearchProvider searchProvider = const ITunesProvider(),
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

    var s = (searchProvider is ITunesProvider)
        ? ITunesSearch(
            userAgent: userAgent,
            timeout: timeout,
          )
        : PodcastIndexSearch(
            userAgent: userAgent,
            timeout: timeout,
            podcastIndexProvider: searchProvider);

    return s.search(
        term: term,
        country: _country,
        attribute: _attribute,
        language: _language,
        limit: _limit,
        version: _version,
        explicit: _explicit,
        queryParams: queryParams);
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
  Future<SearchResult> charts(
      {SearchProvider searchProvider = const ITunesProvider(),
      Country country = Country.UNITED_KINGDOM,
      int limit = 20,
      bool explicit = false,
      Genre genre,
      Map<String, dynamic> queryParams}) async {
    _country = country;
    _limit = limit;
    _explicit = explicit;
    _genre = genre;

    if (searchProvider is PodcastIndexProvider) {
      return PodcastIndexSearch(
        userAgent: userAgent,
        timeout: timeout,
        podcastIndexProvider: searchProvider,
      ).charts(
          country: _country,
          limit: _limit,
          explicit: _explicit,
          genre: _genre,
          queryParams: queryParams);
    }
    return ITunesSearch(
      userAgent: userAgent,
      timeout: timeout,
    ).charts(
        country: _country, limit: _limit, explicit: _explicit, genre: _genre);
  }

  /// Returns the search term.
  String get term => _term;
}
