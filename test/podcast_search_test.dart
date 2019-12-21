// Copyright (c) 2019, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:podcast_search/podcast_search.dart';
import 'package:test/test.dart';

void main() {
  group('Baseline search test', () {
    Search search;

    setUp(() {
      search = Search();
    });

    test('Max one result test', () async {
      final result = await search.search('Forest 404');

      expect(result.resultCount, 1);
    });
  });
}
