// Copyright (c) 2019-2021, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:meta/meta.dart';

/// Defines a list of classes that represent the search engines we
/// can use to find Podcasts. Currently, this is iTunes and
/// PodcastIndex.
class SearchProvider {
  const SearchProvider();
}

class ITunesProvider extends SearchProvider {
  const ITunesProvider();
}

class PodcastIndexProvider extends SearchProvider {
  final String key;
  final String secret;

  PodcastIndexProvider({
    @required this.key,
    @required this.secret,
  });
}
