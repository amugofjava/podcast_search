// Copyright (c) 2019-2021, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcast_search/src/model/genre.dart';

/// A class that represents an individual Podcast within the search results. Not all
/// properties may contain values for all search providers.
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

  /// Original artwork at intended resolution.
  final String artworkUrl;

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
    this.artworkUrl,
    this.releaseDate,
    this.country,
    this.primaryGenreName,
    this.contentAdvisoryRating,
    this.genre,
  });

  /// Takes our json map and builds a Podcast instance from it.
  factory Item.fromJson(
      {@required Map<String, dynamic> json,
      ResultType type = ResultType.itunes}) {
    return type == ResultType.itunes
        ? _fromItunes(json)
        : _fromPodcastIndex(json);
  }

  static Item _fromItunes(Map<String, dynamic> json) {
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

  static Item _fromPodcastIndex(Map<String, dynamic> json) {
    int pubDateSeconds =
        json['lastUpdateTime'] ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;

    var pubDate = Duration(seconds: pubDateSeconds);
    var categories = json['categories'];
    var genres = <Genre>[];

    if (categories != null) {
      categories
          .forEach((key, value) => genres.add(Genre(int.parse(key), value)));
    }

    return Item(
      artistName: json['author'] as String,
      trackName: json['title'] as String,
      feedUrl: json['url'] as String,
      trackViewUrl: json['link'] as String,
      artworkUrl: json['image'] as String,
      genre: genres,
      releaseDate: DateTime.fromMillisecondsSinceEpoch(pubDate.inMilliseconds),
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

  /// Contains a URL for the highest resolution artwork available. If no artwork is available
  /// this will return an empty [String].
  String get bestArtworkUrl {
    if (artworkUrl != null) {
      return artworkUrl;
    } else if (artworkUrl600 != null) {
      return artworkUrl600;
    } else if (artworkUrl100 != null) {
      return artworkUrl100;
    } else if (artworkUrl60 != null) {
      return artworkUrl60;
    } else if (artworkUrl30 != null) {
      return artworkUrl30;
    }

    return '';
  }

  /// Contains a URL for the thumbnail resolution artwork. If no thumbnail size artwork
  /// is available this could return a URL for the full size image. If no artwork is available
  /// this will return an empty [String].
  String get thumbnailArtworkUrl {
    if (artworkUrl60 != null) {
      return artworkUrl60;
    } else if (artworkUrl100 != null) {
      return artworkUrl100;
    } else if (artworkUrl600 != null) {
      return artworkUrl600;
    } else if (artworkUrl != null) {
      return artworkUrl;
    }

    return '';
  }
}
