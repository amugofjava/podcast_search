// Copyright (c) 2019, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

/// A class that provides a list of valid attributes for podcasts.
class Attribute {
  final String _attribute;

  static const Attribute TITLE_TERM = Attribute('titleTerm');
  static const Attribute LANGUAGE_TERM = Attribute('languageTerm');
  static const Attribute AUTHOR_TERM = Attribute('authorTerm');
  static const Attribute GENRE_TERM = Attribute('genreIndex');
  static const Attribute ARTIST_TERM = Attribute('artistTerm');
  static const Attribute RATING_TERM = Attribute('ratingIndex');
  static const Attribute KEYWORDS_TERM = Attribute('keywordsTerm');
  static const Attribute DESCRIPTION_TERM = Attribute('descriptionTerm');

  const Attribute(String attribute) : this._attribute = attribute;

  get attribute => _attribute;
}
