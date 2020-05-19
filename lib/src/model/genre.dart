// Copyright (c) 2019, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

/// A class that represents the genre(s) the podcast is related to.
class Genre {
  /// Genre ID.
  int id;

  /// Genre name.
  String name;

  Genre(this.id, this.name);

  @override
  String toString() {
    return '${id}: ${name}';
  }
}
