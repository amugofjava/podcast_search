import 'package:podcast_search/podcast_search.dart';

main() async {
  var search = Search();

  /// Search for the "It's a Widget" podcast.
  SearchResult results = await search.search("widgets",
      country: Country.UNITED_KINGDOM,
      limit: 10);

  /// List the name of each podcast found.
  results.items?.forEach((result) {
    print("Found podcast: ${result.trackName}");
  });

  /// Parse the first podcast.
  Podcast podcast = await Podcast.loadFeed(url: results.items[0].feedUrl);

  /// Display episode titles.
  podcast.episodes?.forEach((episode) {
    print("Episode title: ${episode.title}");
  });
}
