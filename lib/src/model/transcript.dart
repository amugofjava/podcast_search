enum TranscriptFormat {
  JSON,
  SUBRIP,
  UNSUPPORTED,
}

class TranscriptUrl {
  final String url;
  final TranscriptFormat type;
  final String language;
  final String rel;

  TranscriptUrl({
    this.url = '',
    this.type = TranscriptFormat.UNSUPPORTED,
    this.language = '',
    this.rel = '',
  });
}

class Transcript {
  List<Subtitle> subtitles;

  Transcript({
    this.subtitles = const <Subtitle>[],
  });
}

class Subtitle {
  final int index;
  final Duration start;
  final Duration end;
  final String data;

  Subtitle({
    required this.index,
    required this.start,
    required this.end,
    required this.data,
  });
}
