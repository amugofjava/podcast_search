// Copyright (c) 2019-2021, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

/// An Enum that provides a list of the languages the iTunes API currently supports.
enum Language{
  none(code: ''),
  enUs(code: 'en_us'),
  jaJp(code: 'en_us');

  const Language({required this.code,});

  final String code;
}