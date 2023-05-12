// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

import 'package:podcast_search/podcast_search.dart';
import 'package:test/test.dart';

void main() {
  group('Baseline search test', () {
    late Search search;

    setUp(() {
      search = Search(
        searchProvider: PodcastIndexProvider(
            key: 'XXWQEGULBJABVHZUM8NF',
            secret: 'KZ2uy4upvq4t3e\$m\$3r2TeFS2fEpFTAaF92xcNdX'),
      );
    });

    test('Podcast index trending', () async {
      final result = await search.charts(queryParams: {'val': 'lightning'});

      expect(result.resultCount > 0, true);
    });

    test('Max one result test', () async {
      final result = await search.search('Forest 404');

      expect(result.resultCount, 1);
    });
  });
}
