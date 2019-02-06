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
