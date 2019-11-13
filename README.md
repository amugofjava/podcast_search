A package combining both searching for podcasts via iTunes and the processing of podcast feeds providing object access to the feed, podcast and episode details. 


## Usage

A simple usage example. Search for podcasts with widgets in the title and is available
in the UK. Limit to at most 10 results:

```dart
import 'package:podcast_search/podcast_search.dart';

main() async {
  var search = Search();

  /// Search for podcasts with 'widgets' in the title.
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
```

