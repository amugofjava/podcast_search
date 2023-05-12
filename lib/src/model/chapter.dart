// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

class Chapter {
  final String title;
  final String imageUrl;
  final String url;
  final bool toc;
  final double startTime;
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
