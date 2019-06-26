A simple library providing programmatic access to the iTunes search API for podcasts. 

Created from templates made available by Stagehand under a MIT license
[license](https://opensource.org/licenses/MIT).

## Usage

A simple usage example. Search for podcasts with widgets in the title and is available
in the UK. Limit to at most 10 results:

```dart
import 'package:podcast_search/podcast_search.dart';

main() async {
  var search = Search();

  /// Search for the "It's a Widget" podcast.
  SearchResult results = await search.search("it's a widget",
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

