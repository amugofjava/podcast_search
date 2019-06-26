// Copyright (c) 2019, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:podcast_search/src/model/episode.dart';
import 'package:podcast_search/src/utils/utils.dart';
import 'package:webfeed/webfeed.dart';

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

  Podcast._(this.url, this.link, this.title, this.description, this.image, this.copyright, this.episodes);

  static Future<Podcast> loadFeed({@required String url}) async {
    final client = http.Client();

    final response = await client.get(url, headers: {'User-Agent': 'podcast_search Dart/1.0'});

    var rssFeed = RssFeed.parse(utf8.decode(response.bodyBytes));

    // Parse the episodes
    List<Episode> episodes = [];

    _loadEpisodes(rssFeed, episodes);

    return Podcast._(
        url, rssFeed.link, rssFeed.title, rssFeed.description, rssFeed.image?.url, rssFeed.copyright, episodes);
  }

  static void _loadEpisodes(RssFeed rssFeed, List<Episode> episodes) {
    rssFeed.items.forEach((item) {
      episodes.add(Episode.of(
        item.title,
        item.description,
        item.link,
        Utils.parseRFC2822Date(item.pubDate),
        item.author,
        item.enclosure.url,
      ));
    });
  }
}
