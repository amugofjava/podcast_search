// Copyright (c) 2019, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:podcast_search/src/utils/utils.dart';
import 'package:test_core/test_core.dart';

void main() {
  group('Date parser test', () {
    var d1 = 'Mon, 03 Jun 2019 10:00:00 PDT';
    var d2 = 'Mon, 03 Jun 2019 10:00:00 +02:00';
    var d3 = 'Mon, 03 Jun 2019 10:00:00 -02:00';

    test('Date format zone abbr', () async {
      var result = Utils.parseRFC2822Date(d1).toIso8601String();

      expect(result, '2019-06-03T17:00:00.000Z');
    });

    test('Date format zone +offset', () async {
      var result = Utils.parseRFC2822Date(d2).toIso8601String();

      expect(result, '2019-06-03T08:00:00.000Z');
    });

    test('Date format zone -offset', () async {
      var result = Utils.parseRFC2822Date(d3).toIso8601String();

      expect(result, '2019-06-03T12:00:00.000Z');
    });
  });
}