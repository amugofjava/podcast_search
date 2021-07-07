// Copyright (c) 2019-2021, Ben Hills. Use of this source code is governed by a
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

    test('Load invalid podcast - timeout', () async {
      await expectLater(
          () =>
              Podcast.loadFeed(url: 'https://pc.files.bbci.co.uk/p06tqsg3.rss'),
          throwsA(const TypeMatcher<PodcastTimeoutException>()));
    });
  });

  group('Podcast local file load test', () {
    test('Load podcast', () async {
      var podcast =
          await Podcast.loadFeedFile(file: 'test_resources/podcast1.rss');

      expect(podcast.title, 'Podcast Load Test 1');
      expect(podcast.description, 'Unit test podcast test 1');
      expect(podcast.link, 'https://nowhere.com/podcastsearchtest1');
      expect(podcast.episodes!.length, 1);

      var episode = podcast.episodes![0];

      expect(episode.title, 'Episode 001');
      expect(episode.link, 'https://nowhere.com/podcastsearchtest1/podcast1');
      expect(episode.description, '<div>Test of episode 001</div>');
    });
  });
}
