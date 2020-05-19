// Copyright (c) 2019, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:dart_rss/dart_rss.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcast_search/src/model/episode.dart';
import 'package:podcast_search/src/utils/utils.dart';

/// This class represents a podcast and its episodes. The Podcast is instantiated with a feed URL which is
/// then parsed and the episode list generated.
class Podcast {
  final String url;
  final String link;
  final String title;
  final String description;
  final String image;
  final String copyright;
  final List<Episode> episodes;

  Podcast._(
    this.url, [
    this.link,
    this.title,
    this.description,
    this.image,
    this.copyright,
    this.episodes,
  ]);

  static Future<Podcast> loadFeed({
    @required String url,
    int timeout = 20000,
  }) async {
    final client = Dio(
      BaseOptions(
        connectTimeout: timeout,
        receiveTimeout: timeout,
        headers: {
          HttpHeaders.userAgentHeader: 'podcast_search Dart/1.0',
        },
      ),
    );

    try {
      final response = await client.get(url);

      var rssFeed = RssFeed.parse(response.data);

      // Parse the episodes
      var episodes = <Episode>[];
      var author = rssFeed.author ?? rssFeed.itunes.author;

      _loadEpisodes(rssFeed, episodes);

      return Podcast._(url, rssFeed.link, rssFeed.title, rssFeed.description,
          rssFeed.image?.url, author, episodes);
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.CONNECT_TIMEOUT:
        case DioErrorType.SEND_TIMEOUT:
        case DioErrorType.RECEIVE_TIMEOUT:
        case DioErrorType.DEFAULT:
          throw PodcastTimeoutException(e.message);
          break;
        case DioErrorType.RESPONSE:
          throw PodcastFailedException(e.message);
          break;
        case DioErrorType.CANCEL:
          throw PodcastCancelledException(e.message);
          break;
      }
    }

    return Podcast._(url);
  }

  static void _loadEpisodes(RssFeed rssFeed, List<Episode> episodes) {
    rssFeed.items.forEach((item) {
      episodes.add(Episode.of(
        item.guid,
        item.title,
        item.description,
        item.link,
        Utils.parseRFC2822Date(item.pubDate),
        item.author ?? item.itunes.author,
        item.itunes?.duration,
        item.enclosure?.url,
      ));
    });
  }
}
