import 'dart:convert';

import 'package:podcast_search/src/model/transcript.dart';

//TODO: Add Speaker
class JsonParser {
  Transcript parse(String json) {
    var data = jsonDecode(json) as Map<String, dynamic>;

    var parsed = TranscriptFile.fromMap(data);
    var subtitles = <Subtitle>[];
    var index = 0;

    for (var x in parsed.segments) {
      var startTime = (x.startTime * 1000).toInt();
      var endTime = (x.endTime * 1000).toInt();
      var data = x.body;

      subtitles.add(Subtitle(
        index: index++,
        start: Duration(milliseconds: startTime),
        end: Duration(milliseconds: endTime),
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
      speaker: segment['speaker'] as String,
      startTime: segment['startTime'] as double,
      endTime: segment['endTime'] as double,
      body: segment['body'] as String,
    );
  }
}
