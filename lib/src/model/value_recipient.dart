// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

/// This class represents a PC2.0 [valueRecipient](https://github.com/Podcastindex-org/podcast-namespace/blob/main/docs/1.0.md#value-recipient) tag
/// and is used in conjunction with a [Value] instance.
class ValueRecipient {
  /// The name of the recipient.
  final String? name;

  /// The name of a custom record key to send along with the payment.
  final String? customKey;

  /// The type of receiving address that will receive the payment.
  final String? type;

  /// The payee address.
  final String? address;

  /// The number of shares this recipient/share will receive.
  final int? split;

  /// A custom value to pass along with the payment. This is considered the value that belongs to the [customKey].
  final String? customValue;

  /// Whether this split should be treated as a fee, or a normal split.
  final bool? fee;

  ValueRecipient({
    this.name,
    this.customKey,
    this.type,
    this.address,
    this.split,
    this.customValue,
    this.fee,
  });
}
