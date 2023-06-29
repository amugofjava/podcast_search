// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

import 'package:podcast_search/podcast_search.dart';

// ignore_for_file: avoid_print
void main() async {
  var search = Search();

  /// Search for podcasts with 'widgets' in the title.
  var results = await search.search('widgets', country: Country.unitedKingdom, limit: 10);

  /// List the name of each podcast found.
  for (var result in results.items) {
    print('Found podcast: ${result.trackName}');
  }

  /// Parse the first podcast.
  var podcast = await Podcast.loadFeed(url: results.items[0].feedUrl!);

  /// Display episode titles.
  ///
  for (var episode in podcast.episodes) {
    print('Episode title: ${episode.title}');
  }

  /// Find the top 10 podcasts in the UK.
  var charts = await search.charts(limit: 10, country: Country.unitedKingdom);

  /// List the name of each podcast found.
  for (var result in charts.items) {
    print('Episode title: ${result.trackName}');
  }
}
