/// Copyright (c) 2019, Ben Hills. Use of this source code is governed by a
/// MIT license that can be found in the LICENSE file.

/// A class that provides a list of the languages the iTunes API currently supports.
class Language {
  final String _language;

  static const ENGLISH = const Language('en_us');
  static const JAPANESE = const Language('ja_jp');

  const Language(String language) : this._language = language;

  get language => _language;
}