// Copyright (c) 2019, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class Episode {
  final String title;
  final String description;
  String link;
  final DateTime publicationDate;

  // Media fields
  String contentUrl;

  // iTunes specific fields
  String author;
  int duration;

  Episode.of(
      this.title,
      this.description,
      this.link,
      this.publicationDate,
      this.author,
      this.contentUrl
    );
}
