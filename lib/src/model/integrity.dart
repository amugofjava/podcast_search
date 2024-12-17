// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

/// This class represents a PC2.0 [source](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#integrity)
/// tag and is used within the <podcast:alternateEnclosure> tag.
class Integrity {
  /// The type of integrity, either "sri" or "pgp-signature".
  final String type;

  /// The value of the sri string or base64 encoded pgp signature.
  final String value;

  Integrity({
    required this.type,
    required this.value,
  });
}
