// Copyright (c) 2019-2021, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:test/test.dart';
import 'package:podcast_search/src/search/podcast_index_search.dart';

void main() {
  group('Custom search test', () {
    test('Podcast index 2.0 value test', () async {
      final jsonMap = jsonDecode(
          '{"model":{"type":"lightning","method":"keysend","suggested":"0.00000050000"},"destinations":[{"name":"podcaster","type":"node","address":"03dfa33ae4230eb83ed55e58bdc6882eea37e651cc08aafa108da1de923e7163f9","split":99.0},{"name":"Podcastindex.org","address":"03ae9f91a0cb8ff43840e3c322c4c61f019d8c1c3cea15a25cfc425ac605e61a4a","type":"node","split":1.0}]}');
      final value = Value.fromJson(jsonMap);
      final serialized = value.toJson();

      expect(DeepCollectionEquality().equals(serialized, jsonMap), true);
    });
    test('Podcast index 2.0 test', () async {
      final result = await CustomPodcastIndexSearch().search(term: 'Podcasting 2.0');
      expect(result.items[0].value != null, true);
    });
  });
}

class CustomPodcastIndexSearch extends PodcastIndexSearch {
  static String SEARCH_API_ENDPOINT = 'https://api.podcastindex.org/api/1.0/podcasts';

  CustomPodcastIndexSearch()
      : super(
            timeout: 10000,
            userAgent: 'test agent',
            podcastIndexProvider:
                PodcastIndexProvider(key: 'XXWQEGULBJABVHZUM8NF', secret: 'KZ2uy4upvq4t3e\$m\$3r2TeFS2fEpFTAaF92xcNdX'));

  @override
  String buildSearchUrl() {
    return 'https://api.podcastindex.org/api/1.0/podcasts/bytag?podcast-value';
  }
}
