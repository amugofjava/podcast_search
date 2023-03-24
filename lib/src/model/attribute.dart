// Copyright (attribute: c) 2019-2021, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

/// An enum that provides a list of valid attributes for podcasts.
enum Attribute {
  none(attribute: ''),
  title(attribute: 'titleTerm'),
  language(attribute: 'languageTerm'),
  author(attribute: 'authorTerm'),
  genre(attribute: 'genreIndex'),
  artist(attribute: 'artistTerm'),
  rating(attribute: 'ratingIndex'),
  keywords(attribute: 'keywordsTerm'),
  description(attribute: 'descriptionTerm');

  const Attribute({
    required this.attribute,
  });
  
  final String attribute;
}

