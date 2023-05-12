// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

import 'package:podcast_search/podcast_search.dart';

void main() async {
  var search = Search();

  var r = await Podcast.loadTranscriptByUrl(
      transcriptUrl: TranscriptUrl(
          url: 'https://feeds.buzzsprout.com/1538779/12816556/transcript.json', type: TranscriptFormat.json));

  /// Search for the "It's a Widget" podcast.
  var results = await search.search('podnews weekly review', country: Country.unitedKingdom, limit: 10);

  print('Podcast persons:');

  // /// List the name of each podcast found.
  // results.items.forEach((result) {
  //   print('Found podcast: ${result.trackName}');
  // });
  //
  /// Parse the first podcast.
  var podcast = await Podcast.loadFeed(url: results.items[0].feedUrl!);

  if (podcast.persons.isNotEmpty) {
    for (var p in podcast.persons) {
      print(' - ${p.image}');
    }
  }

  var episode = podcast.episodes?[0];

  if (episode != null) {
    for (var p in episode.persons) {
      print(' - ${p.name} (${p.role})');
    }
  }

  //
  /// Display episode titles.
  podcast.episodes?.forEach((episode) {
    print('Episode title: ${episode.title}');
    for (var p in episode.persons) {
      print(' - ${p.name} (${p.role})');
    }
  });

  // /// Find the top 10 comedy podcasts in the UK.
  // var charts = await search.charts(
  //     genre: 'Education', limit: 10, country: Country.unitedKingdom);
  //
  // /// List the name of each podcast found.
  // charts.items.forEach((result) {
  //   print('Found podcast: ${result.trackName}');
  // });
}
