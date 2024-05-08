// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

/// This class represents a PC2.0 [remote item](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#remote-item)
class RemoteItem {
  String feedGuid;
  String? itemGuid;
  String? feedUrl;
  String? medium;

  RemoteItem({
    required this.feedGuid,
    this.itemGuid,
    this.feedUrl,
    this.medium,
  });
}
