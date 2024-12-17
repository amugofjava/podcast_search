// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

import 'package:podcast_search/src/model/integrity.dart';
import 'package:podcast_search/src/model/source.dart';

/// This class represents a PC2.0 [alternateEnclosure](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#alternate-enclosure)
/// tag and is used within the <podcast:alternateEnclosure> tag.
class AlternateEnclosure {
  final String mimeType;
  final int? length;
  final int? bitRate;
  final int? height;
  final String? lang;
  final String? title;
  final String? rel;
  final String? codecs;
  final bool defaultMedia;

  final Integrity? integrity;
  final List<Source> sources;

  AlternateEnclosure({
    required this.mimeType,
    this.length,
    this.bitRate,
    this.height,
    this.lang,
    this.title,
    this.rel,
    this.codecs,
    this.defaultMedia = false,
    this.integrity,
    this.sources = const <Source>[],
  });
}
