// Copyright (c) 2019-2021, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

/// Defines a list of classes that represent the search engines we
/// can use to find Podcasts. Currently, this is iTunes and
/// PodcastIndex.
class SearchProvider {
  const SearchProvider();
}

/// Pass an instance of this class to use iTunes as the podcast search engine.
class ITunesProvider extends SearchProvider {
  const ITunesProvider();
}

/// Pass an instance of this class to use PodcastIndex as the podcast search engine.
class PodcastIndexProvider extends SearchProvider {
  /// The API key.
  final String key;

  /// The API secret.
  final String secret;

  PodcastIndexProvider({
    required this.key,
    required this.secret,
  });
}
