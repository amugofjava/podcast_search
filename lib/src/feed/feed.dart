// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:podcast_search/src/const/constants.dart';
import 'package:podcast_search/src/model/alternate_enclosure.dart';
import 'package:podcast_search/src/model/block.dart';
import 'package:podcast_search/src/model/chapter.dart';
import 'package:podcast_search/src/model/chapter_headers.dart';
import 'package:podcast_search/src/model/integrity.dart';
import 'package:podcast_search/src/model/locked.dart';
import 'package:podcast_search/src/model/medium.dart';
import 'package:podcast_search/src/model/person.dart';
import 'package:podcast_search/src/model/remote_item.dart';
import 'package:podcast_search/src/model/source.dart';
import 'package:podcast_search/src/model/value_recipient.dart';
import 'package:podcast_search/src/utils/json_parser.dart';
import 'package:podcast_search/src/utils/srt_parser.dart';
import 'package:podcast_search/src/utils/utils.dart';
import 'package:podcast_search/src/utils/vtt_parser.dart';
import 'package:rss_dart/domain/rss_feed.dart';

class Feed {
  /// Fetches the last-modified date from the response header. This
  /// is an option field, so a null will be returned if no value exists.
  static Future<DateTime?> feedLastUpdated({
    required String url,
    final timeout = const Duration(seconds: 20),
    String userAgent = '',
  }) async {
    final podcast = await _loadFeedInternal(
      url: url,
      headOnly: true,
      timeout: timeout,
      userAgent: userAgent,
    );

    return podcast.dateTimeModified;
  }

  /// This method takes a Url pointing to an RSS feed containing the Podcast details and episodes. You
  /// can optionally specify a timeout value in milliseconds and a custom user-agent string that will
  /// be used in HTTP/HTTPS communications with the feed source.
  static Future<Podcast> loadFeed({
    required String url,
    final timeout = const Duration(seconds: 20),
    String userAgent = '',
  }) async {
    return _loadFeedInternal(url: url, timeout: timeout, userAgent: userAgent);
  }

  static Future<Podcast> loadFeedFile({required String file}) async {
    var f = File(file);

    if (f.existsSync()) {
      var input = f.readAsStringSync();
      var rssFeed = RssFeed.parse(input);

      return _loadFeed(rssFeed, file, null);
    }

    return Podcast(url: file);
  }

  /// Load a PC2.0 [Transcript] from a file. Transcripts can be either JSON or
  /// SRT (SubRip) format. The file extension is used to determine if either the
  /// [JsonParser] or [SrtParser] is used.
  static Future<Transcript> loadTranscriptFile({required String file}) async {
    var transcript = Transcript();
    var f = File(file);

    if (f.existsSync()) {
      var input = f.readAsStringSync();

      if (file.endsWith('.json')) {
        final jsonParser = JsonParser();

        transcript = jsonParser.parse(input);
      } else if (file.endsWith('.vtt')) {
        final vttParser = VttParser();

        transcript = vttParser.parse(input);
      } else if (file.endsWith('.srt')) {
        final srtParser = SrtParser();

        transcript = srtParser.parse(input);
      }
    }

    return Future.value(transcript);
  }

  /// Podcasts that support the newer podcast namespace can include chapter markers. Typically this
  /// is in the form of a Url in the RSS feed pointing to a JSON file. This method takes the Url
  /// and loads the chapters, storing the results in the [Episode] itself. Repeatedly calling this
  /// method for the same episode will, by default, not reload the chapters data and will simply
  /// return the [Episode] back. If you need to reload the chapters set the [forceReload] parameter
  /// to [true].
  static Future<Episode> loadEpisodeChapters({
    required Episode episode,
    bool forceReload = false,
    final timeout = const Duration(seconds: 20),
  }) async {
    final client = Dio(
      BaseOptions(connectTimeout: timeout, receiveTimeout: timeout),
    );

    if (episode.chapters!.chapters.isNotEmpty &&
        !episode.chapters!.loaded &&
        !forceReload) {
      try {
        final response = await client.get(episode.chapters!.url);

        if (response.statusCode == 200 &&
            response.data is Map<String, dynamic>) {
          _loadChapters(response, episode.chapters!);
        }
      } on DioException catch (e) {
        switch (e.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.receiveTimeout:
            throw PodcastTimeoutException(e.message ?? '');
          case DioExceptionType.connectionError:
          case DioExceptionType.badResponse:
            throw PodcastFailedException(e.message ?? '');
          case DioExceptionType.badCertificate:
            throw PodcastCertificateException(e.message ?? '');
          case DioExceptionType.cancel:
            throw PodcastCancelledException(e.message ?? '');
          case DioExceptionType.unknown:
            throw PodcastUnknownException(e.message ?? '');
        }
      }
    }

    return episode;
  }

  /// Load a PC2.0 [Transcript] from a file. Transcripts can be either JSON or
  /// SRT (SubRip) format. The mime type is used to determine if either the
  /// [JsonParser] or [SrtParser] is used.
  static Future<Transcript> loadTranscriptByUrl({
    required TranscriptUrl transcriptUrl,
    final timeout = const Duration(seconds: 20),
  }) async {
    final client = Dio(
      BaseOptions(connectTimeout: timeout, receiveTimeout: timeout),
    );

    var transcript = Transcript();

    try {
      final response = await client.get(
        transcriptUrl.url,
        options: Options(responseType: ResponseType.plain),
      );

      /// What type of transcript are we loading here?
      if (transcriptUrl.type == TranscriptFormat.subrip) {
        if (response.statusCode == 200 && response.data is String) {
          final srtParser = SrtParser();
          transcript = srtParser.parse(response.data);
        }
      } else if (transcriptUrl.type == TranscriptFormat.vtt) {
        if (response.statusCode == 200 && response.data is String) {
          final vttParser = VttParser();
          transcript = vttParser.parse(response.data.toString());
        }
      } else if (transcriptUrl.type == TranscriptFormat.json) {
        if (response.statusCode == 200 && response.data is String) {
          final jsonParser = JsonParser();
          transcript = jsonParser.parse(response.data.toString());
        }
      } else {
        throw Exception('Sorry, not got around to supporting that format yet');
      }
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw PodcastTimeoutException(e.message ?? '');
        case DioExceptionType.connectionError:
        case DioExceptionType.badResponse:
          throw PodcastFailedException(e.message ?? '');
        case DioExceptionType.badCertificate:
          throw PodcastCertificateException(e.message ?? '');
        case DioExceptionType.cancel:
          throw PodcastCancelledException(e.message ?? '');
        case DioExceptionType.unknown:
          throw PodcastUnknownException(e.message ?? '');
      }
    }

    return Future.value(transcript);
  }

  /// Podcasts that support the newer podcast namespace can include chapter markers. Typically this
  /// is in the form of a Url in the RSS feed pointing to a JSON file. This method takes the Url
  /// and loads the chapters, return a populated Chapters object.
  static Future<Chapters> loadChaptersByUrl({
    required String url,
    final timeout = const Duration(seconds: 20),
  }) async {
    final client = Dio(
      BaseOptions(connectTimeout: timeout, receiveTimeout: timeout),
    );

    var chapters = Chapters();

    try {
      final response = await client.get(url);

      if (response.statusCode == 200) {
        _loadChapters(response, chapters);
      } else {
        throw PodcastFailedException('Failed to download chapters file');
      }
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw PodcastTimeoutException(e.message ?? '');
        case DioExceptionType.connectionError:
        case DioExceptionType.badResponse:
          throw PodcastFailedException(e.message ?? '');
        case DioExceptionType.badCertificate:
          throw PodcastCertificateException(e.message ?? '');
        case DioExceptionType.cancel:
          throw PodcastCancelledException(e.message ?? '');
        case DioExceptionType.unknown:
          throw PodcastUnknownException(e.message ?? '');
      }
    }

    return chapters;
  }

  static Future<Podcast> _loadFeedInternal({
    required String url,
    final timeout = const Duration(seconds: 20),
    String userAgent = '',
    bool headOnly = false,
  }) async {
    final client = Dio(
      BaseOptions(
        connectTimeout: timeout,
        receiveTimeout: timeout,
        headers: {
          'User-Agent': userAgent.isEmpty ? podcastSearchAgent : userAgent,
        },
      ),
    );

    try {
      final response = headOnly
          ? await client.head(url)
          : await client.get(url);

      DateTime? lastUpdated;

      final lastModifiedFormat = DateFormat('E, d MMM y H:m:s ');

      if (response.statusCode == 200) {
        final lastModified = response.headers.value('last-modified');

        if (lastModified != null) {
          lastUpdated = lastModifiedFormat.parse(
            lastModified.replaceAll('GMT', ''),
          );
        }
      }

      if (headOnly) {
        return Podcast(dateTimeModified: lastUpdated);
      } else {
        var rssFeed = RssFeed.parse(response.data);

        // Parse the episodes
        return _loadFeed(rssFeed, url, lastUpdated);
      }
    } on DioException catch (e) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          throw PodcastTimeoutException(e.message ?? '');
        case DioExceptionType.connectionError:
        case DioExceptionType.badResponse:
          throw PodcastFailedException(e.message ?? '');
        case DioExceptionType.badCertificate:
          throw PodcastCertificateException(e.message ?? '');
        case DioExceptionType.cancel:
          throw PodcastCancelledException(e.message ?? '');
        case DioExceptionType.unknown:

          /// We may be able to determine the underlying error
          if (e.error is HandshakeException) {
            throw PodcastCertificateException(e.message ?? '');
          }

          if (e.error is CertificateException) {
            throw PodcastCertificateException(e.message ?? '');
          }

          throw PodcastUnknownException(e.message ?? '');
      }
    }
  }

  static Podcast _loadFeed(RssFeed rssFeed, String url, DateTime? lastUpdtaed) {
    // Parse the episodes
    var episodes = <Episode>[];
    var remoteItems = <RemoteItem>[];
    var author = rssFeed.itunes!.author;
    var locked = Locked(
      locked: rssFeed.podcastIndex!.locked?.locked ?? false,
      owner: rssFeed.podcastIndex!.locked?.owner ?? '',
    );

    var funding = <Funding>[];
    var persons = <Person>[];
    var block = <Block>[];
    var value = <Value>[];
    var medium = Medium.podcast;

    var guid = rssFeed.podcastIndex?.guid;

    if (rssFeed.podcastIndex != null) {
      if (rssFeed.podcastIndex!.funding != null) {
        for (var f in rssFeed.podcastIndex!.funding!) {
          if (f != null && f.url != null && f.value != null) {
            funding.add(Funding(url: f.url, value: f.value));
          }
        }
      }

      if (rssFeed.podcastIndex!.remoteItem != null) {
        for (var r in rssFeed.podcastIndex!.remoteItem!) {
          if (r != null) {
            remoteItems.add(
              RemoteItem(
                feedGuid: r.feedGuid,
                itemGuid: r.itemGuid,
                feedUrl: r.feedUrl,
                medium: r.medium,
              ),
            );
          }
        }
      }

      if (rssFeed.podcastIndex!.persons != null) {
        for (var p in rssFeed.podcastIndex!.persons!) {
          persons.add(
            Person(
              name: p?.name ?? '',
              role: p?.role,
              group: p?.group,
              image: p?.image,
              link: p?.link,
            ),
          );
        }
      }

      if (rssFeed.podcastIndex!.block != null) {
        for (var b in rssFeed.podcastIndex!.block!) {
          block.add(Block(block: b?.block ?? false, id: b?.id));
        }
      }

      if (rssFeed.podcastIndex!.medium != null) {
        medium = switch (rssFeed.podcastIndex!.medium) {
          'podcastL' => Medium.podcastL,
          'music' => Medium.music,
          'musicL' => Medium.musicL,
          'video' => Medium.video,
          'videoL' => Medium.videoL,
          'film' => Medium.film,
          'filmL' => Medium.filmL,
          'audiobook' => Medium.audiobook,
          'audiobookL' => Medium.audiobookL,
          'newsletter' => Medium.newsletter,
          'newsletterL' => Medium.newsletterL,
          'blog' => Medium.blog,
          'blogL' => Medium.blogL,
          _ => Medium.podcast,
        };
      }

      if (rssFeed.podcastIndex!.value != null) {
        for (var v in rssFeed.podcastIndex!.value!) {
          var recipients = <ValueRecipient>[];

          if (v?.recipients != null) {
            for (var r in v!.recipients!) {
              if (r != null) {
                recipients.add(
                  ValueRecipient(
                    name: r.name,
                    customKey: r.customKey,
                    type: r.type,
                    address: r.address,
                    split: r.split,
                    customValue: r.customValue,
                    fee: r.fee,
                  ),
                );
              }
            }
          }

          value.add(
            Value(
              method: v?.method,
              type: v?.type,
              suggested: v?.suggested,
              recipients: recipients,
            ),
          );
        }
      }
    }

    _loadEpisodes(rssFeed, episodes);

    return Podcast(
      guid: guid,
      url: url,
      link: rssFeed.link,
      title: rssFeed.title,
      description: rssFeed.description,
      image: rssFeed.itunes?.image?.href ?? rssFeed.image?.url,
      copyright: author,
      locked: locked,
      funding: funding,
      persons: persons,
      block: block,
      value: value,
      medium: medium,
      episodes: episodes,
      remoteItems: remoteItems,
      dateTimeModified: lastUpdtaed,
    );
  }

  static void _loadChapters(Response response, Chapters c) {
    Map<String, dynamic> data;

    if (response.data is String) {
      data = jsonDecode(response.data);
    } else {
      data = Map.from(response.data);
    }

    final chapters = data['chapters'] ?? [];

    c.headers = ChapterHeaders(
      version: data['version'] ?? '',
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      podcastName: data['podcastName'] ?? '',
      description: data['description'] ?? '',
      fileName: data['fileName'] ?? '',
    );

    c.loaded = true;

    for (var chapter in chapters) {
      double? startTime = 0.0;
      double? endTime = 0.0;

      // The spec says that the start and end times are a float; however,
      // some chapters come in as whole seconds whilst others include the
      // fraction. We test the type here to prevent conversion/casting errors.
      if (chapter['startTime'] != null) {
        if (chapter['startTime'] is double) {
          startTime = chapter['startTime'];
        } else if (chapter['startTime'] is int) {
          startTime = (chapter['startTime'] as int).toDouble();
        }
      }

      if (chapter['endTime'] != null) {
        if (chapter['endTime'] is double) {
          endTime = chapter['endTime'];
        } else if (chapter['endTime'] is int) {
          endTime = (chapter['endTime'] as int).toDouble();
        }
      }

      c.chapters.add(
        Chapter(
          url: chapter['url'] ?? '',
          imageUrl: chapter['img'] ?? '',
          title: chapter['title'] ?? '',
          startTime: startTime ?? 0.0,
          endTime: endTime ?? 0.0,
          toc: (chapter['toc'] != null && (chapter['toc'] as bool?) == false)
              ? false
              : true,
        ),
      );
    }
  }

  static void _loadEpisodes(RssFeed rssFeed, List<Episode> episodes) {
    for (var item in rssFeed.items) {
      var transcripts = <TranscriptUrl>[];
      var persons = <Person>[];
      var value = <Value>[];
      var alternateEnclosures = <AlternateEnclosure>[];

      var chapters = Chapters(
        url: item.podcastIndex!.chapters?.url ?? '',
        type: item.podcastIndex!.chapters?.type ?? '',
      );

      if (item.podcastIndex?.transcripts != null) {
        for (var t in item.podcastIndex!.transcripts) {
          var valid = false;
          var type = TranscriptFormat.unsupported;

          switch (t?.type ?? '') {
            case 'application/json':
              type = TranscriptFormat.json;
              valid = true;
              break;
            case 'application/x-subrip':
            case 'application/srt':
              type = TranscriptFormat.subrip;
              valid = true;
              break;
            case 'text/vtt':
              type = TranscriptFormat.vtt;
              valid = true;
              break;
            default:
              valid = false;
              break;
          }

          if (valid) {
            transcripts.add(
              TranscriptUrl(
                url: t?.url ?? '',
                language: t?.language ?? '',
                rel: t?.rel ?? '',
                type: type,
              ),
            );
          }
        }
      }

      if (item.podcastIndex?.persons != null) {
        for (var p in item.podcastIndex!.persons) {
          persons.add(
            Person(
              name: p?.name ?? '',
              role: p?.role ?? '',
              group: p?.group ?? '',
              image: p?.image ?? '',
              link: p?.link ?? '',
            ),
          );
        }
      }

      if (item.podcastIndex?.value != null) {
        for (var v in item.podcastIndex!.value) {
          var recipients = <ValueRecipient>[];

          if (v?.recipients != null) {
            for (var r in v!.recipients!) {
              if (r != null) {
                recipients.add(
                  ValueRecipient(
                    name: r.name,
                    customKey: r.customKey,
                    type: r.type,
                    address: r.address,
                    split: r.split,
                    customValue: r.customValue,
                    fee: r.fee,
                  ),
                );
              }
            }
          }

          value.add(
            Value(
              method: v?.method,
              type: v?.type,
              suggested: v?.suggested,
              recipients: recipients,
            ),
          );
        }
      }

      if (item.podcastIndex?.alternateEnclosure != null) {
        for (var v in item.podcastIndex!.alternateEnclosure) {
          if (v != null) {
            var sources = <Source>[];
            Integrity? integrity;

            if (v.sources != null) {
              for (var r in v.sources!) {
                if (r != null && r.uri != null) {
                  sources.add(Source(uri: r.uri!, contentType: r.contentType));
                }
              }
            }

            if (v.integrity != null &&
                v.integrity?.type != null &&
                v.integrity?.value != null) {
              integrity = Integrity(
                type: v.integrity!.type!,
                value: v.integrity!.value!,
              );
            }

            alternateEnclosures.add(
              AlternateEnclosure(
                mimeType: v.mimeType,
                defaultMedia: v.defaultMedia,
                codecs: v.codecs,
                rel: v.rel,
                title: v.title,
                lang: v.lang,
                height: v.height,
                bitRate: v.bitRate,
                length: v.length,
                integrity: integrity,
                sources: sources,
              ),
            );
          }
        }
      }

      episodes.add(
        Episode(
          guid: item.guid ?? '',
          title: item.title ?? '',
          description: item.description ?? '',
          link: item.link,
          publicationDate: item.pubDate == null
              ? null
              : Utils.parseRFC2822Date(item.pubDate!),
          author: item.author ?? item.itunes!.author ?? item.dc?.creator,
          duration: item.itunes?.duration,
          contentUrl: item.enclosure?.url,
          imageUrl: item.itunes?.image?.href,
          season: item.itunes?.season,
          episode: item.itunes?.episode,
          content: item.content?.value,
          chapters: chapters,
          transcripts: transcripts,
          persons: persons,
          value: value,
          alternateEnclosures: alternateEnclosures,
        ),
      );
    }
  }
}
