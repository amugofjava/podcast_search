// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

import 'package:podcast_search/podcast_search.dart';
import 'package:podcast_search/src/model/medium.dart';
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

  group('Medium test', () {
    test('No medium', () async {
      var podcast =
          await Podcast.loadFeedFile(file: 'test_resources/podcast1.rss');

      expect(podcast.medium, Medium.podcast);
    });

    test('Audiobook medium', () async {
      var podcast = await Podcast.loadFeedFile(
          file: 'test_resources/podcast-medium-audiobook.rss');

      expect(podcast.medium, Medium.audiobook);
    });

    test('Music list medium', () async {
      var podcast = await Podcast.loadFeedFile(
          file: 'test_resources/podcast-medium-music-list.rss');

      expect(podcast.medium, Medium.musicL);
      expect(podcast.remoteItems.length, 2);
    });
  });

  group('Alternate enclosures', () {
    test('No alternate enclosures', () async {
      var podcast = await Podcast.loadFeedFile(
          file: 'test_resources/podcast-alternate-enclosure.rss');

      expect(podcast.episodes[0].alternateEnclosures.length, 0);
    });

    test('Load episode 2 alternate enclosures', () async {
      var podcast = await Podcast.loadFeedFile(
          file: 'test_resources/podcast-alternate-enclosure.rss');

      var episode2 = podcast.episodes[1];

      expect(episode2.alternateEnclosures.length, 3);

      var enclosure1 = episode2.alternateEnclosures[0];
      var enclosure2 = episode2.alternateEnclosures[1];
      var enclosure3 = episode2.alternateEnclosures[2];

      expect(enclosure1.sources.length, 0);
      expect(enclosure2.sources.length, 2);
      expect(enclosure3.sources.length, 2);

      expect(enclosure1.title, 'Standard');
      expect(enclosure1.mimeType, 'audio/mpeg');
      expect(enclosure1.length, 43200000);
      expect(enclosure1.bitRate, 128000);
      expect(enclosure1.defaultMedia, true);
      expect(enclosure1.integrity, null);

      expect(enclosure2.title, 'High quality');
      expect(enclosure2.mimeType, 'audio/opus');
      expect(enclosure2.length, 32400000);
      expect(enclosure2.bitRate, 96000);
      expect(enclosure2.defaultMedia, false);
      expect(enclosure2.integrity, null);

      var source1 = enclosure2.sources[0];
      var source2 = enclosure2.sources[1];
      var integrity = enclosure3.integrity;

      expect(source1.uri, 'https://example.com/file-high.opus');
      expect(source1.contentType, null);

      expect(source2.uri, 'ipfs://someRandomHighBitrateOpusFile');
      expect(source2.contentType, 'audio/opus');

      expect(integrity?.type, 'sri');
      expect(integrity?.value, 'sha384-ExVqijgYHm15PqQqdXfW95x+Rs6C+d6E/ICxyQOeFevnxNLR/wtJNrNYTjIysUBo');
    });
  });

}
