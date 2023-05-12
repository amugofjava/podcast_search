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
