// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.
import 'package:podcast_search/src/model/value_recipient.dart';

/// This class represents a PC2.0 [value](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#value)
/// tag and is used for value-for-value payments via cryptocurrency or another payment layer.
class Value {
  /// The service layer to use. For example, 'lightning' for payments over the Lightning network.
  final String? type;

  /// The transport mechanism used. For example 'keysend'.
  final String? method;

  /// The suggested payment amount.
  final double? suggested;

  /// Each value can have zero or more recipients who will receive a split of the value sent.
  final List<ValueRecipient>? recipients;

  Value({
    this.type,
    this.method,
    this.suggested,
    this.recipients = const <ValueRecipient>[],
  });
}
