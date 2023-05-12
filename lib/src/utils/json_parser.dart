// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:podcast_search/src/model/transcript.dart';

/// This class parses PC2.0 transcripts in JSON format. The full spec can be
/// found [here](https://github.com/Podcastindex-org/podcast-namespace/blob/main/transcripts/transcripts.md#json)
class JsonParser {
  Transcript parse(String json) {
    var data = jsonDecode(json) as Map<String, dynamic>;
    var parsed = TranscriptFile.fromMap(data);
    var subtitles = <Subtitle>[];
    var index = 0;

    for (var segment in parsed.segments) {
      var startTime = (segment.startTime * 1000).toInt();
      var endTime = (segment.endTime * 1000).toInt();
      var data = segment.body;
      var speaker = segment.speaker;

      subtitles.add(Subtitle(
        index: index++,
        start: Duration(milliseconds: startTime),
        end: Duration(milliseconds: endTime),
        speaker: speaker,
        data: data,
      ));
    }

    return Transcript(subtitles: subtitles);
  }
}

class TranscriptFile {
  String version;
  List<TranscriptSegment> segments;

  TranscriptFile({
    required this.version,
    required this.segments,
  });

  static TranscriptFile fromMap(Map<String, dynamic> file) {
    var segments = <TranscriptSegment>[];

    if (file['segments'] != null) {
      for (var s in (file['segments'] as List)) {
        if (s is Map<String, dynamic>) {
          segments.add(TranscriptSegment.fromMap(s));
        }
      }
    }

    return TranscriptFile(
      version: file['version'] as String,
      segments: segments,
    );
  }
}

class TranscriptSegment {
  String speaker;
  double startTime;
  double endTime;
  String body;

  TranscriptSegment({
    required this.speaker,
    required this.startTime,
    required this.endTime,
    required this.body,
  });

  static TranscriptSegment fromMap(Map<String, dynamic> segment) {
    return TranscriptSegment(
      speaker: segment['speaker'] ?? '',
      startTime: (segment['startTime'] ?? 0).toDouble(),
      endTime: (segment['endTime'] ?? 0).toDouble(),
      body: segment['body'] as String,
    );
  }
}
