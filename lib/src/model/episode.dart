// Copyright (c) 2019-2021, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:podcast_search/src/model/chapters.dart';

/// A class representing an individual episode.
class Episode {
  /// The episode unique identifier.
  final String guid;

  /// The episode title.
  final String title;

  /// The episode description.
  final String description;

  /// The episode URL.
  String? link;

  /// Publication date of the episode.
  final DateTime? publicationDate;

  /// Media fields
  String? contentUrl;

  /// Episode specific image URL if one exists
  String? imageUrl;

  // iTunes specific fields
  /// Episode author.
  String? author;

  /// Season
  int? season;

  /// Episode number
  int? episode;

  /// Length of the episode as a [Duration].
  final Duration? duration;

  /// Episode chapters for feeds that support PodcastIndex
  final Chapters? chapters;

  Episode({
    required this.guid,
    required this.title,
    required this.description,
    this.link = '',
    this.publicationDate,
    this.author = '',
    this.duration,
    this.contentUrl,
    this.imageUrl,
    this.season,
    this.episode,
    this.chapters,
  });
}
