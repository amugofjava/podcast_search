// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

/// This class represents and individual chapter within a podcast episode.
class Chapter {
  /// The optional title of the chapter.
  final String title;

  /// Optional image artwork for the chapter.
  final String imageUrl;

  /// Optional HTML link for the chapter.
  final String url;

  /// If false, this is considered a silent chapter and should not appear in a chapter selector.
  final bool toc;

  /// The start time of this chapter in seconds.
  final double startTime;

  /// Optional end time of this chapter in seconds.
  final double endTime;

  Chapter({
    this.title = '',
    this.imageUrl = '',
    this.url = '',
    this.toc = false,
    this.startTime = 0.0,
    this.endTime = 0.0,
  });
}
