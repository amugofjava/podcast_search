// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

/// A class that represents the genre(s) the podcast is related to.
class Genre {
  /// Genre ID.
  final int id;

  /// Genre name.
  final String name;

  const Genre(this.id, this.name);

  @override
  String toString() {
    return '$id: $name';
  }
}
