// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

import 'package:podcast_search/podcast_search.dart';
import 'package:test/test.dart';

void main() {
  group('Podcast load test', () {
    test('Load podcast', () async {
      var podcast = await Podcast.loadFeed(
          url: 'https://podcasts.files.bbci.co.uk/p06tqsg3.rss');

      expect(podcast.title, 'Forest 404');
    });

    test('Load invalid podcast - unknown host', () async {
      await expectLater(
          () =>
              Podcast.loadFeed(url: 'https://pc.files.bbci.co.uk/p06tqsg3.rss'),
          throwsA(const TypeMatcher<PodcastFailedException>()));
    });

    test('Load invalid podcast - invalid RSS call 404', () async {
      await expectLater(
          () => Podcast.loadFeed(url: 'https://bbc.co.uk/abcdp06tqsg3.rss'),
          throwsA(const TypeMatcher<PodcastFailedException>()));
    });
  });

  group('Podcast local file load test', () {
    test('Load podcast', () async {
      var podcast =
          await Podcast.loadFeedFile(file: 'test_resources/podcast1.rss');

      expect(podcast.title, 'Podcast Load Test 1');
      expect(podcast.description, 'Unit test podcast test 1');
      expect(podcast.link, 'https://nowhere.com/podcastsearchtest1');
      expect(podcast.episodes.length, 2);

      var episode1 = podcast.episodes[0];

      expect(episode1.title, 'Episode 001');
      expect(episode1.link, 'https://nowhere.com/podcastsearchtest1/podcast1');
      expect(episode1.description, '<div>Test of episode 001</div>');

      var episode2 = podcast.episodes[1];

      expect(episode2.title, 'Episode 002');
      expect(episode2.link, 'https://nowhere.com/podcastsearchtest1/podcast2');
      expect(episode2.description, '<div>Test of episode 002</div>');
      expect(episode2.publicationDate, null);
    });
  });
}
