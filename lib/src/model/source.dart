// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

/// This class represents a PC2.0 [source](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#source)
/// tag and is used within the <podcast:alternateEnclosure> tag.
class Source {
  /// The Uri for the media file.
  final String uri;

  /// The mime type of the media file.
  final String? contentType;

  Source({required this.uri, this.contentType});
}
