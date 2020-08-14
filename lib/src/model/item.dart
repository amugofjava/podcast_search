// Copyright (c) 2019, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:podcast_search/src/model/genre.dart';

/// A class that represents an individual Podcast within the
/// search results.
class Item {
  /// The iTunes ID of the artist.
  final int artistId;

  /// The iTunes ID of the collection.
  final int collectionId;

  /// The iTunes ID of the track.
  final int trackId;

  /// The item unique identifier.
  final String guid;

  /// The name of the artist.
  final String artistName;

  /// The name of the iTunes collection the Podcast is part of.
  final String collectionName;

  /// The track name.
  final String trackName;

  /// The censored version of the collection name.
  final String collectionCensoredName;

  /// The censored version of the track name,
  final String trackCensoredName;

  /// The URL of the iTunes page for the artist.
  final String artistViewUrl;

  /// The URL of the iTunes page for the podcast.
  final String collectionViewUrl;

  /// The URL of the RSS feed for the podcast.
  final String feedUrl;

  /// The URL of the iTunes page for the track.
  final String trackViewUrl;

  /// Podcast artwork URL 30x30.
  final String artworkUrl30;

  /// Podcast artwork URL 60x60.
  final String artworkUrl60;

  /// Podcast artwork URL 100x100.
  final String artworkUrl100;

  /// Podcast artwork URL 600x600.
  final String artworkUrl600;

  /// Podcast release date
  final DateTime releaseDate;

  /// Explicitness of the collection. For example notExplicit.
  final String collectionExplicitness;

  /// Explicitness of the track. For example notExplicit.
  final String trackExplicitness;

  /// Number of tracks in the results.
  final int trackCount;

  /// Country of origin.
  final String country;

  /// Primary genre for the podcast.
  final String primaryGenreName;

  final String contentAdvisoryRating;

  /// Full list of genres for the podcast.
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
    var genres = <Genre>[];

    if (id != null) {
      for (var x = 0; x < id.length; x++) {
        genres.add(Genre(int.parse(id[x]), name[x]));
      }
    }

    return genres;
  }

  @override
  String toString() {
    return 'Item{artistId: $artistId, collectionId: $collectionId, trackId: $trackId, guid: $guid, artistName: $artistName, collectionName: $collectionName, trackName: $trackName, collectionCensoredName: $collectionCensoredName, trackCensoredName: $trackCensoredName, artistViewUrl: $artistViewUrl, collectionViewUrl: $collectionViewUrl, feedUrl: $feedUrl, trackViewUrl: $trackViewUrl, artworkUrl30: $artworkUrl30, artworkUrl60: $artworkUrl60, artworkUrl100: $artworkUrl100, artworkUrl600: $artworkUrl600, releaseDate: $releaseDate, collectionExplicitness: $collectionExplicitness, trackExplicitness: $trackExplicitness, trackCount: $trackCount, country: $country, primaryGenreName: $primaryGenreName, contentAdvisoryRating: $contentAdvisoryRating, genre: $genre}';
  }
}
