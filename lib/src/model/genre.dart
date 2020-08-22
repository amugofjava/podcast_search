// Copyright (c) 2019, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

/// A class that represents the genre(s) the podcast is related to.
class Genre {
  /// Genre ID.
  final int _id;

  /// Genre name.
  final String _name;

  Genre(this._id, this._name);

  static const Genre ARTS = Genre._(1301, 'Arts');
  static const Genre BUSINESS = Genre._(1321, 'Business');
  static const Genre COMEDY = Genre._(1303, 'Comedy');
  static const Genre EDUCATION = Genre._(1304, 'Education');
  static const Genre FICTION = Genre._(1483, 'Fiction');
  static const Genre GOVERNMENT = Genre._(1511, 'Government');
  static const Genre HEALTH_FITNESS = Genre._(1512, 'Health & Fitness');
  static const Genre HISTORY = Genre._(1487, 'History');
  static const Genre KIDS_FAMILY = Genre._(1305, 'Kids & Family');
  static const Genre LEISURE = Genre._(1502, 'Leisure');
  static const Genre MUSIC = Genre._(1301, 'Music');
  static const Genre NEWS = Genre._(1489, 'News');
  static const Genre RELIGION_SPIRITUALITY = Genre._(1314, 'Religion & Spirituality');
  static const Genre SCIENCE = Genre._(1533, 'Science');
  static const Genre SOCIETY_CULTURE = Genre._(1324, 'Society & Culture');
  static const Genre SPORTS = Genre._(1545, 'Sports');
  static const Genre TV_FILM = Genre._(1309, 'TV & Film');
  static const Genre TECHNOLOGY = Genre._(1318, 'Technology');
  static const Genre TRUE_CRIME = Genre._(1488, 'True Crime');

  const Genre._(int id, String name) : _id = id, _name = name;

  @override
  String toString() {
    return '${_id}: ${_name}';
  }

  int get id => _id;

  String get name => _name;
}
