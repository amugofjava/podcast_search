// Copyright (c) 2019-2021, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

/// A class that provides a list of valid attributes for podcasts.
class Attribute {
  final String _attribute;

  static const Attribute NONE = Attribute._('');

  static const Attribute TITLE_TERM = Attribute._('titleTerm');
  static const Attribute LANGUAGE_TERM = Attribute._('languageTerm');
  static const Attribute AUTHOR_TERM = Attribute._('authorTerm');
  static const Attribute GENRE_TERM = Attribute._('genreIndex');
  static const Attribute ARTIST_TERM = Attribute._('artistTerm');
  static const Attribute RATING_TERM = Attribute._('ratingIndex');
  static const Attribute KEYWORDS_TERM = Attribute._('keywordsTerm');
  static const Attribute DESCRIPTION_TERM = Attribute._('descriptionTerm');

  /// Construct a new Attribute for the given attribute.
  const Attribute._(String attribute) : _attribute = attribute;

  /// Returns the string value of the attribute.
  String get attribute => _attribute;
}
