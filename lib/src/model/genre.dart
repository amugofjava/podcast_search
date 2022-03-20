// Copyright (c) 2019-2021, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

/// A class that represents the genre(s) the podcast is related to.
class Genre {
  /// Genre ID.
  final int _id;

  /// Genre name.
  final String _name;

  Genre(this._id, this._name);

  const Genre._(int id, String name)
      : _id = id,
        _name = name;

  @override
  String toString() {
    return '$_id: $_name';
  }

  int get id => _id;

  String get name => _name;
}
