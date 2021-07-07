// Copyright (c) 2019-2021, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:podcast_search/src/utils/utils.dart';
import 'package:test/test.dart';

void main() {
  group('Date parser test', () {
    var d1 = 'Mon, 03 Jun 2019 10:00:00 PDT';
    var d2 = 'Mon, 03 Jun 2019 10:00:00 +02:00';
    var d3 = 'Mon, 03 Jun 2019 10:00:00 -02:00';
    var d4 = 'Mon, 03 Jun 2019 10:00:00 +0000';
    var d5 = 'Mon, 03 Jun 2019 10:00:00 -0000';
    var d6 = 'Mon, 03 June 2019 10:00:00 GMT';
    var d7 = 'Tue, 01 January 2019 10:00:00 GMT';
    var d8 = 'Tue, 1 January 2019 10:00:00 GMT';
    var i1 = '2019-12-01T08:30:45+00:00'; // ISO 8601 format

    test('Date format zone abbr', () async {
      var result = Utils.parseRFC2822Date(d1)!.toIso8601String();

      expect(result, '2019-06-03T17:00:00.000Z');
    });

    test('Date format zone +offset', () async {
      var result = Utils.parseRFC2822Date(d2)!.toIso8601String();

      expect(result, '2019-06-03T08:00:00.000Z');
    });

    test('Date format zone -offset', () async {
      var result = Utils.parseRFC2822Date(d3)!.toIso8601String();

      expect(result, '2019-06-03T12:00:00.000Z');
    });

    test('Date format zone -offset 2a', () async {
      var result = Utils.parseRFC2822Date(d4)!.toIso8601String();

      expect(result, '2019-06-03T10:00:00.000Z');
    });

    test('Date format zone -offset 2b', () async {
      var result = Utils.parseRFC2822Date(d5)!.toIso8601String();

      expect(result, '2019-06-03T10:00:00.000Z');
    });

    test('Date format zone -offset 2c', () async {
      var result = Utils.parseRFC2822Date(d6)!.toIso8601String();

      expect(result, '2019-06-03T10:00:00.000Z');
    });

    test('Date format zone -offset 2d', () async {
      var result = Utils.parseRFC2822Date(d7)!.toIso8601String();

      expect(result, '2019-01-01T10:00:00.000Z');
    });

    test('Date format zone -offset 2e', () async {
      var result = Utils.parseRFC2822Date(d8)!.toIso8601String();

      expect(result, '2019-01-01T10:00:00.000Z');
    });

    test('Date format ISO 8601', () async {
      var result = Utils.parseRFC2822Date(i1)!.toIso8601String();

      expect(result, '2019-12-01T08:30:45.000Z');
    });
  });
}
