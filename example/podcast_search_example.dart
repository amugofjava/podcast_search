/// Copyright (c) 2019, Ben Hills. Use of this source code is governed by a
/// MIT license that can be found in the LICENSE file.

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
