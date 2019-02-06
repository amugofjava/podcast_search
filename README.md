A simple library providing programmatic access to the iTunes search API for podcasts. 

Created from templates made available by Stagehand under a MIT license
[license](https://opensource.org/licenses/MIT).

## Usage

A simple usage example. Search for podcasts with widgets in the title and is available
in the UK. Limit to at most 10 results:

```dart
import 'package:podcast_search/podcast_search.dart';

main() async {
  var search = new Search();

  SearchResult result = await search.search("widgets",
      country: Country.UNITED_KINGDOM,
      limit: 10);

  result.items?.forEach((podcast) {
    print("Found podcast ${podcast.trackName}");
  });
}

```

