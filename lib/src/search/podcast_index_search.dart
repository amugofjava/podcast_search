// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcast_search/src/search/base_search.dart';

/// This class handles the searching. Taking the base URL we build any parameters
/// that have been added before making a call to iTunes. The results are unpacked
/// and stored as Item instances and wrapped in a SearchResult.
class PodcastIndexSearch extends BaseSearch {
  static String searchApiEndpoint =
      'https://api.podcastindex.org/api/1.0/search';
  static String trendingApiEndpoint =
      'https://api.podcastindex.org/api/1.0/podcasts/trending';
  static String genreApiEndpoint =
      'https://api.podcastindex.org/api/1.0/categories/list';

  static const _genres = <String>[
    'After-Shows',
    'Alternative',
    'Animals',
    'Animation',
    'Arts',
    'Astronomy',
    'Automotive',
    'Aviation',
    'Baseball',
    'Basketball',
    'Beauty',
    'Books',
    'Buddhism',
    'Business',
    'Careers',
    'Chemistry',
    'Christianity',
    'Climate',
    'Comedy',
    'Commentary',
    'Courses',
    'Crafts',
    'Cricket',
    'Cryptocurrency',
    'Culture',
    'Daily',
    'Design',
    'Documentary',
    'Drama',
    'Earth',
    'Education',
    'Entertainment',
    'Entrepreneurship',
    'Family',
    'Fantasy',
    'Fashion',
    'Fiction',
    'Film',
    'Fitness',
    'Food',
    'Football',
    'Games',
    'Garden',
    'Golf',
    'Government',
    'Health',
    'Hinduism',
    'History',
    'Hobbies',
    'Hockey',
    'Home',
    'How-To',
    'Improv',
    'Interviews',
    'Investing',
    'Islam',
    'Journals',
    'Judaism',
    'Kids',
    'Language',
    'Learning',
    'Leisure',
    'Life',
    'Management',
    'Manga',
    'Marketing',
    'Mathematics',
    'Medicine',
    'Mental',
    'Music',
    'Natural',
    'Nature',
    'News',
    'Non-Profit',
    'Nutrition',
    'Parenting',
    'Performing',
    'Personal',
    'Pets',
    'Philosophy',
    'Physics',
    'Places',
    'Politics',
    'Relationships',
    'Religion',
    'Reviews',
    'Role-Playing',
    'Rugby',
    'Running',
    'Science',
    'Self-Improvement',
    'Sexuality',
    'Soccer',
    'Social',
    'Society',
    'Spirituality',
    'Sports',
    'Stand-Up',
    'Stories',
    'Swimming',
    'TV',
    'Tabletop',
    'Technology',
    'Tennis',
    'Travel',
    'True Crime',
    'Video-Games',
    'Visual',
    'Volleyball',
    'Weather',
    'Wilderness',
    'Wrestling',
  ];

  PodcastIndexProvider podcastIndexProvider;

  late Dio _client;

  /// The search term keyword(s)
  String? _term = '';

  /// Limit the number of results to [_limit]. If zero no limit will be applied
  int _limit = 0;

  /// Set to true to disable the explicit filter.
  bool _explicit = false;

  /// Connection timeout threshold in milliseconds
  int timeout = 20000;

  /// If this property is non-null, it will be prepended to the User Agent header.
  String? userAgent = '';

  final ErrorType _lastErrorType = ErrorType.none;

  String? _lastError;

  /// Contains the type of error returning from the search. If no error occurred it
  /// will be set to [ErrorType.none].
  /// If an error occurs, this will contain a user-readable error message.
  PodcastIndexSearch({
    required this.podcastIndexProvider,
    this.timeout = 20000,
    this.userAgent,
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
          'User-Agent': userAgent == null || userAgent!.isEmpty
              ? '$podcastSearchAgent'
              : '$userAgent',
        },
      ),
    );
  }

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
    _limit = limit;
    _explicit = explicit;

    try {
      var response = await _client.get(_buildSearchUrl(queryParams!));

      return SearchResult.fromJson(
          json: response.data, type: ResultType.podcastIndex);
    } on DioError catch (e) {
      setLastError(e);
    }

    return SearchResult.fromError(
        lastError: _lastError ?? '', lastErrorType: _lastErrorType);
  }

  /// Fetches the list of top podcasts
  /// Optionally takes a [limit] and [Country] filter. Defaults to
  /// limit of 20 and no specified country.
  ///
  /// The charts is returned as a 'feed'. In order to be compatible with
  /// [SearchResult] we need to parse this feed and fetch the underlying
  /// result for each item resulting in a HTTP call for each result. Given
  /// the infrequent update of the chart feed it is recommended that clients
  /// cache the results.
  @override
  Future<SearchResult> charts(
      {Country country = Country.none,
      int limit = 20,
      bool explicit = false,
      String genre = '',
      Map<String, dynamic> queryParams = const {}}) async {
    try {
      var response = await _client.get(trendingApiEndpoint,
          queryParameters: {
            'since': -1 * 3600 * 24 * 7,
            'cat': genre,
            'max': limit,
          }..addAll(queryParams));

      return SearchResult.fromJson(
          json: response.data, type: ResultType.podcastIndex);
    } on DioError catch (e) {
      setLastError(e);
    }

    return SearchResult.fromError(
        lastError: _lastError ?? '', lastErrorType: _lastErrorType);
  }

  @override
  List<String> genres() => _genres;

  /// This internal method constructs a correctly encoded URL which is then
  /// used to perform the search.
  String _buildSearchUrl(Map<String, dynamic> queryParams) {
    final buf = StringBuffer(searchApiEndpoint);

    buf.write(_termParam());
    buf.write(_limitParam());
    buf.write(_explicitParam());
    queryParams.forEach((key, value) {
      buf.write('&$key=${Uri.encodeComponent(value)}');
    });

    return buf.toString();
  }

  String _termParam() {
    return term!.isNotEmpty ? '/byterm?q=' + Uri.encodeComponent(term!) : '';
  }

  String _limitParam() {
    return _limit != 0 ? '&max=' + _limit.toString() : '';
  }

  String _explicitParam() {
    return _explicit ? '&clean' : '';
  }

  /// Returns the search term.
  String? get term => _term;
}
