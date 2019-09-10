// Copyright (c) 2019, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:podcast_search/src/model/genre.dart';

/// A class that represents an individual item within the result set.
class Item {
  final int artistId;
  final int collectionId;
  final int trackId;
  final String guid;
  final String artistName;
  final String collectionName;
  final String trackName;
  final String collectionCensoredName;
  final String trackCensoredName;
  final String artistViewUrl;
  final String collectionViewUrl;
  final String feedUrl;
  final String trackViewUrl;
  final String artworkUrl30;
  final String artworkUrl60;
  final String artworkUrl100;
  final String artworkUrl600;
  final DateTime releaseDate;
  final String collectionExplicitness;
  final String trackExplicitness;
  final int trackCount;
  final String country;
  final String primaryGenreName;
  final String contentAdvisoryRating;
  final List<Genre> genre;

  Item({
    this.artistId,
    this.collectionId,
    this.trackId,
    this.guid,
    this.artistName,
    this.collectionName,
    this.trackName,
    this.trackCount,
    this.collectionCensoredName,
    this.trackCensoredName,
    this.artistViewUrl,
    this.collectionViewUrl,
    this.feedUrl,
    this.trackViewUrl,
    this.collectionExplicitness,
    this.trackExplicitness,
    this.artworkUrl30,
    this.artworkUrl60,
    this.artworkUrl100,
    this.artworkUrl600,
    this.releaseDate,
    this.country,
    this.primaryGenreName,
    this.contentAdvisoryRating,
    this.genre,
  });

  /// Takes our json map and builds a Podcast instance from it.
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      artistId: json['artistId'] as int,
      collectionId: json['collectionId'] as int,
      trackId: json['trackId'] as int,
      guid: json['guid'] as String,
      artistName: json['artistName'] as String,
      collectionName: json['collectionName'] as String,
      collectionExplicitness: json['collectionExplicitness'] as String,
      trackExplicitness: json['trackExplicitness'] as String,
      trackName: json['trackName'] as String,
      trackCount: json['trackCount'] as int,
      collectionCensoredName: json['collectionCensoredName'] as String,
      trackCensoredName: json['trackCensoredName'] as String,
      artistViewUrl: json['artistViewUrl'] as String,
      collectionViewUrl: json['collectionViewUrl'] as String,
      feedUrl: json['feedUrl'] as String,
      trackViewUrl: json['trackViewUrl'] as String,
      artworkUrl30: json['artworkUrl30'] as String,
      artworkUrl60: json['artworkUrl60'] as String,
      artworkUrl100: json['artworkUrl100'] as String,
      artworkUrl600: json['artworkUrl600'] as String,
      genre: Item._loadGenres(
          json['genreIds'].cast<String>(), json['genres'].cast<String>()),
      releaseDate: DateTime.parse(json['releaseDate']),
      country: json['country'] as String,
      primaryGenreName: json['primaryGenreName'] as String,
      contentAdvisoryRating: json['contentAdvisoryRating'] as String,
    );
  }

  /// Genres appear within the json as two separate lists. This utility function
  /// creates Genre instances for each id and name pair.
  static List<Genre> _loadGenres(List<String> id, List<String> name) {
    var genres = new List<Genre>();

    if (id != null) {
      for (int x = 0; x < id.length; x++) {
        genres.add(new Genre(int.parse(id[x]), name[x]));
      }
    }

    return genres;
  }
}
