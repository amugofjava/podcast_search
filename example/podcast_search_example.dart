import 'package:podcast_search/podcast_search.dart';

void main() async {
  var search = Search();

  /// Search for the "It's a Widget" podcast.
  var results = await search.search('widgets', country: Country.UNITED_KINGDOM, limit: 10);

  /// List the name of each podcast found.
  results.items.forEach((result) {
    print('Found podcast: ${result.trackName}');
  });

  /// Parse the first podcast.
  var podcast = await Podcast.loadFeed(url: results.items[0].feedUrl!);

  /// Display episode titles.
  podcast.episodes?.forEach((episode) {
    print('Episode title: ${episode.title}');
  });

  /// Find the top 10 comedy podcasts in the UK.
  var charts = await search.charts(genre: 'Education', limit: 10, country: Country.UNITED_KINGDOM);

  /// List the name of each podcast found.
  charts.items.forEach((result) {
    print('Found podcast: ${result.trackName}');
  });
}
