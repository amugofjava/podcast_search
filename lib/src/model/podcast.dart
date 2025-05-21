// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

import 'package:podcast_search/podcast_search.dart';
import 'package:podcast_search/src/model/block.dart';
import 'package:podcast_search/src/model/locked.dart';
import 'package:podcast_search/src/model/medium.dart';
import 'package:podcast_search/src/model/person.dart';
import 'package:podcast_search/src/model/remote_item.dart';
import 'package:podcast_search/src/model/value_recipient.dart';

/// This class represents a podcast and its episodes. The Podcast is instantiated with a feed URL which is
/// then parsed and the episode list generated.
/// TODO: This model is getting quite complicate. The logic & processing code should be
/// separated from the model.
class Podcast {
  /// The Podcasting 2.0 GUID value (optional).
  /// https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#guid
  final String? guid;

  /// The URL of the podcast. Contained within the enclosure RSS tag.
  final String? url;

  /// Podcast link.
  final String? link;

  /// Name of the podcast.
  final String? title;

  /// Optional description.
  final String? description;

  /// Url of artwork image
  final String? image;

  /// Copyright
  final String? copyright;

  /// Indicates to podcast platforms whether this feed can be imported or not. If [true] the
  /// feed is locked and should not be imported elsewhere.
  final Locked? locked;

  /// If the podcast supports funding this will contain an instance of [Funding] that
  /// contains the Url and optional description.
  final List<Funding> funding;

  /// A list of [Person]. Can be at the podcast and item level.
  final List<Person> persons;

  /// A list of [Value], each can contain 0 or more [ValueRecipient]
  final List<Value> value;

  /// A list of [Block] tags.
  final List<Block> block;

  /// A list of current episodes.
  final List<Episode> episodes;

  /// A list of remote items at the channel level
  final List<RemoteItem> remoteItems;

  final Medium medium;

  Podcast({
    this.guid,
    this.url,
    this.link,
    this.title,
    this.description,
    this.image,
    this.copyright,
    this.locked,
    this.medium = Medium.podcast,
    this.funding = const <Funding>[],
    this.persons = const <Person>[],
    this.value = const <Value>[],
    this.block = const <Block>[],
    this.episodes = const <Episode>[],
    this.remoteItems = const <RemoteItem>[],
  });
}
