// Copyright (c) 2019-2021, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

/// A class that provides a list of the languages the iTunes API currently supports.
class Language {
  final String _language;

  static const NONE = Language('');

  static const ENGLISH = Language('en_us');
  static const JAPANESE = Language('ja_jp');

  const Language(String language) : _language = language;

  String get language => _language;
}
