// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

import 'package:podcast_search/src/model/chapter.dart';
import 'package:podcast_search/src/model/chapter_headers.dart';

/// This class represents a set of PC2.0 [chapters](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#chapters).
/// A chapter is a way to split a podcast episode into a series of chapters with a start and (optional) end time, and optional additions
/// such as separate artwork and HTML links.
class Chapters {
  /// The url of a chapter file.
  final String url;

  /// The mime type of the chapter file (JSON preferred).
  final String type;

  /// Have we loaded a set of chapters?
  var loaded = false;

  /// Chapter headers.
  var headers = ChapterHeaders();

  /// A list of individual chapters.
  var chapters = <Chapter>[];

  Chapters({
    this.url = '',
    this.type = '',
  });
}
