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

  group('Block tag test', () {
    test('Load podcast with block tags', () async {
      var podcast =
          await Podcast.loadFeedFile(file: 'test_resources/podcast1.rss');

      expect(podcast.block.length, 3);
      expect(podcast.block[0].block, true);
      expect(podcast.block[0].id, null);

      expect(podcast.block[1].block, false);
      expect(podcast.block[1].id, 'google');

      expect(podcast.block[2].block, true);
      expect(podcast.block[2].id, 'amazon');
    });

    test('Load podcast with no block tags', () async {
      var podcast = await Podcast.loadFeedFile(
          file: 'test_resources/podcast-no-block.rss');

      expect(podcast.block.length, 0);
    });
  });

  group('Remote item test', () {
    test('No remote items', () async {
      var podcast = await Podcast.loadFeedFile(
          file: 'test_resources/podcast-no-block.rss');

      expect(podcast.remoteItems.length, 0);
    });

    test('Load podcast 3 remote items', () async {
      var podcast = await Podcast.loadFeedFile(
          file: 'test_resources/podcast-remote-item.rss');

      expect(podcast.remoteItems.length, 3);

      var item1 = podcast.remoteItems[0];
      var item2 = podcast.remoteItems[1];
      var item3 = podcast.remoteItems[2];

      expect(item1.feedGuid, '917393e3-1b1e-5cef-ace4-edaa54e1f810');
      expect(item1.itemGuid, null);
      expect(item1.feedUrl, null);
      expect(item1.medium, null);

      expect(item2.feedGuid, '917393e3-1b1e-5cef-ace4-edaa54e1f811');
      expect(item2.itemGuid, 'asdf089j0-ep240-20230510');
      expect(item2.feedUrl, null);
      expect(item2.medium, null);

      expect(item3.feedGuid, '917393e3-1b1e-5cef-ace4-edaa54e1f812');
      expect(item3.itemGuid, 'asdf089j0-ep240-20230511');
      expect(item3.feedUrl,
          'https://feeds.example.org/917393e3-1b1e-5cef-ace4-edaa54e1f811/rss.xml');
      expect(item3.medium, 'music');
    });
  });
}
