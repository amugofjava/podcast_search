import 'package:podcast_search/src/model/chapter.dart';
import 'package:podcast_search/src/model/chapter_headers.dart';

class Chapters {
  final String url;
  final String type;
  var loaded = false;
  var headers = ChapterHeaders();
  var chapters = <Chapter>[];

  Chapters({
    this.url,
    this.type,
  });
}
