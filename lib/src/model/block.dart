// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

/// This class represents a PC2.0 [block](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#block) tag.
class Block {
  final bool block;
  String? id;

  Block({required this.block, this.id});
}
