// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

/// This class represents the PC2.0 [podcast:funding](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#funding) tag.
/// Each instance represents a page where a user can help fund the podcast.
class Funding {
  final String? url;
  final String? value;

  Funding({
    required this.url,
    required this.value,
  });
}
