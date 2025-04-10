// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

import 'package:podcast_search/podcast_search.dart';
import 'package:test/test.dart';

void main() {
  group('SRT transcript test', () {
    test('Load SRT file', () async {
      var transcript = await Podcast.loadTranscriptFile(
          file: 'test_resources/test_transcript.srt');
      var secondLine = transcript.subtitles[1];

      expect(transcript.subtitles.length, 3);
      expect(secondLine.start.inMilliseconds, 5500);
      expect(secondLine.end.inMilliseconds, 10000);
      expect(secondLine.data, 'Subtitle 2, Line 1 Subtitle 2, Line 2');
    });
  });

  group('VTT transcript test', () {
    test('Load VTT file', () async {
      var transcript = await Podcast.loadTranscriptFile(
          file: 'test_resources/test_transcript.vtt');

      final subtitles = transcript.subtitles;

      expect(subtitles.length, 6);

      expect(subtitles[0].data, 'Text line 1');
      expect(subtitles[0].speaker, '');
      expect(subtitles[0].start, const Duration(hours: 0, minutes: 0, seconds: 0, milliseconds: 0));
      expect(subtitles[0].end, const Duration(hours: 0, minutes: 0, seconds: 1, milliseconds: 0));

      expect(subtitles[1].data, 'Text line 2');
      expect(subtitles[1].speaker, 'Speaker1');
      expect(subtitles[1].start, const Duration(hours: 0, minutes: 0, seconds: 2, milliseconds: 0));
      expect(subtitles[1].end, const Duration(hours: 0, minutes: 0, seconds: 3, milliseconds: 0));

      expect(subtitles[2].data, 'Text line 3');
      expect(subtitles[2].speaker, 'Speaker2');
      expect(subtitles[2].start, const Duration(hours: 0, minutes: 0, seconds: 3, milliseconds: 0));
      expect(subtitles[2].end, const Duration(hours: 0, minutes: 0, seconds: 4, milliseconds: 0));

      expect(subtitles[3].data, 'Text line 4');
      expect(subtitles[3].speaker, 'Speaker3');
      expect(subtitles[3].start, const Duration(hours: 0, minutes: 1, seconds: 5, milliseconds: 0));
      expect(subtitles[3].end, const Duration(hours: 0, minutes: 1, seconds: 6, milliseconds: 0));

      expect(subtitles[4].data, 'Text line 5');
      expect(subtitles[4].speaker, '');
      expect(subtitles[4].start, const Duration(hours: 0, minutes: 1, seconds: 7, milliseconds: 0));
      expect(subtitles[4].end, const Duration(hours: 0, minutes: 1, seconds: 8, milliseconds: 0));

      expect(subtitles[5].data, 'Multi Line 1 Multi Line 2');
      expect(subtitles[5].speaker, '');
      expect(subtitles[5].start, const Duration(hours: 1, minutes: 2, seconds: 9, milliseconds: 1));
      expect(subtitles[5].end, const Duration(hours: 1, minutes: 2, seconds: 10, milliseconds: 1));
    });
  });

  group('JSON transcript test', () {
    test('Load Json file', () async {
      var transcript = await Podcast.loadTranscriptFile(
          file: 'test_resources/test_transcript.json');
      var secondLine = transcript.subtitles[1];

      expect(transcript.subtitles.length, 3);
      expect(secondLine.start.inMilliseconds, 5500);
      expect(secondLine.end.inMilliseconds, 10000);
      expect(secondLine.data, 'Subtitle 2, Line 1');
    });

    test('Load Json file', () async {
      var transcript = await Podcast.loadTranscriptFile(
          file: 'test_resources/test_transcript_speaker_no_end.json');
      var secondLine = transcript.subtitles[1];

      expect(transcript.subtitles.length, 3);
      expect(secondLine.start.inMilliseconds, 5500);
      expect(secondLine.end.inMilliseconds, 0);
      expect(secondLine.data, 'Subtitle 2, Line 1');
    });
  });
}
