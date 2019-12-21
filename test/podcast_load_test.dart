// Copyright (c) 2019, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:podcast_search/podcast_search.dart';
import 'package:test/test.dart';

void main() {
  group('Podcast load test', () {
    test('Load podcast', () async {
      var podcast = await Podcast.loadFeed(
          url: 'https://podcasts.files.bbci.co.uk/p06tqsg3.rss');

      expect(podcast.title, 'Forest 404');
    });
  });
}
