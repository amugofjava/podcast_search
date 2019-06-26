import 'package:podcast_search/podcast_search.dart';
import 'package:podcast_search/src/model/podcast.dart';

main() async {
  var search = new Search();

  SearchResult results = await search.search("it's a widget",
      country: Country.UNITED_KINGDOM,
      limit: 10);

  // List search results
  results.items?.forEach((result) {
    print("Found podcast ${result.trackName}");
  });

  // Load the first podcast
//  Podcast podcast = await Podcast.loadFeed(url: results.items[0].feedUrl);
  Podcast podcast = await Podcast.loadFeed(url: 'https://podcasts.files.bbci.co.uk/p06tqsg3.rss');

  // Display podcast details
  print("Title ${podcast.title}");

  // Display episodes
  podcast.episodes?.forEach((episode) {
    print("Episode title ${episode.title}");
  });

}
