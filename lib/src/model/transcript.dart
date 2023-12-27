// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

/// podcast_search currently supports PC2.0 Json format and standard subrip/srt format.
enum TranscriptFormat {
  json,
  subrip,
  unsupported,
}

/// This class represents a PC2.0 [transcript](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#transcript)
/// URL contained within an RSS feed.
class TranscriptUrl {
  /// The URL for the transcript.
  final String url;

  /// The type of transcript: json or srt
  final TranscriptFormat type;

  /// The language for the transcript
  final String language;

  /// If set to captions, shows that this is a closed-caption file
  final String rel;

  TranscriptUrl({
    this.url = '',
    this.type = TranscriptFormat.unsupported,
    this.language = '',
    this.rel = '',
  });
}

/// This class represents a [transcript](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#transcript).
class Transcript {
  /// The transcript lines
  List<Subtitle> subtitles;

  Transcript({
    this.subtitles = const <Subtitle>[],
  });
}

/// This class represents one line within a transcript.
class Subtitle {
  /// The index (order) of the transcript line.
  final int index;

  /// The start time of this line.
  final Duration start;

  /// Optional end time of this line.
  final Duration end;

  /// The text for this line.
  final String data;

  /// The person speaking (optional).
  final String speaker;

  Subtitle({
    required this.index,
    required this.start,
    required this.end,
    required this.data,
    this.speaker = '',
  });

  @override
  String toString() {
    return 'Subtitle{index: $index, start: $start, end: $end, data: $data, speaker: $speaker}';
  }
}
