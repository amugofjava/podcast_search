// Copyright (c) 2019-2021, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

import 'package:podcast_search/src/model/transcript.dart';

/// This class parses PC2.0 transcripts in SRT format. The full spec can be
/// found [here](https://github.com/Podcastindex-org/podcast-namespace/blob/main/transcripts/transcripts.md#srt)
class SrtParser {
  final _srtMatcher = RegExp(
    r'(\d+)\s((\d{2}):(\d{2}):(\d{2})[,|.](\d{3})) +--> +((\d{2}):(\d{2}):(\d{2})[,|.](\d{3})).*[\r\n]+\s*((?:(?!\r?\n\r?).)*(\r\n|\r|\n)(?:.*))',
    caseSensitive: false,
    multiLine: true,
  );

  final _newlineMatcher = RegExp(
    r'[\r\n]',
    caseSensitive: false,
    multiLine: true,
  );

  Transcript parse(String srt) {
    final matches = _srtMatcher.allMatches(srt).toList();
    final subtitles = <Subtitle>[];

    for (final regExpMatch in matches) {
      final index = int.parse(regExpMatch.group(1) ?? '0');
      final startTimeHours = int.parse(regExpMatch.group(3) ?? '0');
      final startTimeMinutes = int.parse(regExpMatch.group(4) ?? '0');
      final startTimeSeconds = int.parse(regExpMatch.group(5) ?? '0');
      final startTimeMilliseconds = int.parse(regExpMatch.group(6) ?? '0');

      final endTimeHours = int.parse(regExpMatch.group(8) ?? '0');
      final endTimeMinutes = int.parse(regExpMatch.group(9) ?? '0');
      final endTimeSeconds = int.parse(regExpMatch.group(10) ?? '0');
      final endTimeMilliseconds = int.parse(regExpMatch.group(11) ?? '0');
      final text = regExpMatch.group(12)?.replaceAll(_newlineMatcher, ' ');

      final startTime = Duration(
        hours: startTimeHours,
        minutes: startTimeMinutes,
        seconds: startTimeSeconds,
        milliseconds: startTimeMilliseconds,
      );

      final endTime = Duration(
        hours: endTimeHours,
        minutes: endTimeMinutes,
        seconds: endTimeSeconds,
        milliseconds: endTimeMilliseconds,
      );

      var subtitle = Subtitle(
          index: index, start: startTime, end: endTime, data: text ?? '');

      subtitles.add(subtitle);
    }

    return Transcript(subtitles: subtitles);
  }
}
