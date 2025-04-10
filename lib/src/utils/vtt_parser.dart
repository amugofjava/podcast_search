// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

import 'package:podcast_search/src/model/transcript.dart';

/// This class parses PC2.0 transcripts in VTT format. The full spec can be
/// found [here](https://github.com/Podcastindex-org/podcast-namespace/blob/main/transcripts/transcripts.md#srt)
class VttParser {
  final _vttMatcher = RegExp(
    r'((?<shour>\d{2})?(:)?(?<smin>\d{2}):(?<ssec>\d{2})[,|.](?<smili>\d{3})) +--> +((?<ehour>\d{2})?(:)?(?<emin>\d{2}):(?<esec>\d{2})[,|.](?<emili>\d{3})).*[\r\n]+\s*(?<lines>(?:(?!\r?\n\r?).)*(\r\n|\r|\n)(?:.*))',
    caseSensitive: false,
    multiLine: true,
  );

  final _newlineMatcher = RegExp(
    r'[\r\n]+',
    caseSensitive: false,
    multiLine: true,
  );

  final _prefixMatcher = RegExp(
    r'^<(?<prefix>[a-z.]*)\s(?<speaker>.*?)>(?<text>.*)',
    caseSensitive: false,
    multiLine: true,
  );

  final _htmlTagsMatcher = RegExp(
    r'</?[a-z][a-z0-9]*[^<>]*>|<!--.*?-->',
    caseSensitive: false,
    multiLine: true,
  );

  Transcript parse(String srt) {
    final matches = _vttMatcher.allMatches(srt).toList();
    final subtitles = <Subtitle>[];
    var i = 0;

    for (final regExpMatch in matches) {
      i++;

      // The index may, or may not, be specified.
      final startTimeHours = int.parse(regExpMatch.namedGroup('shour') ?? '0');
      final startTimeMinutes = int.parse(regExpMatch.namedGroup('smin') ?? '0');
      final startTimeSeconds = int.parse(regExpMatch.namedGroup('ssec') ?? '0');
      final startTimeMilliseconds = int.parse(regExpMatch.namedGroup('smili') ?? '0');

      final endTimeHours = int.parse(regExpMatch.namedGroup('ehour') ?? '0');
      final endTimeMinutes = int.parse(regExpMatch.namedGroup('emin') ?? '0');
      final endTimeSeconds = int.parse(regExpMatch.namedGroup('esec') ?? '0');
      final endTimeMilliseconds = int.parse(regExpMatch.namedGroup('emili') ?? '0');
      final textLines = regExpMatch.namedGroup('lines')?.split(_newlineMatcher);

      var text = '';
      var speaker = '';

      // Some SRT can contains trailing and leading spaces; some do not!
      if (textLines != null) {
        for (var line in textLines) {
          if (text.isEmpty) {
            text = line;
          } else if (text.endsWith(' ') || line.startsWith(' ')) {
            text += line;
          } else {
            text += ' $line';
          }
        }
      }

      // VTT can contain speaker names at the start of the line.
      final speakerMatcher = _prefixMatcher.firstMatch(text);

      if (speakerMatcher != null) {
        var prefix = speakerMatcher.namedGroup('prefix') ?? '';

        if (prefix.startsWith('v')) {
          speaker = speakerMatcher.namedGroup('speaker') ?? '';
        }

        text = speakerMatcher.namedGroup('text') ?? '';
      }

      // Strip any HTML tags
      text = text.replaceAll(_htmlTagsMatcher, '');

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

      var subtitle =
          Subtitle(index: i, start: startTime, end: endTime, speaker: speaker, data: text.trim(),);

      subtitles.add(subtitle);
    }

    return Transcript(subtitles: subtitles);
  }
}
