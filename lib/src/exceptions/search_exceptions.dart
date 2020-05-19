// Copyright (c) 2019, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

/// Thrown if the connection times out, or we timeout
/// waiting to receive the data.
class PodcastTimeoutException implements Exception {
  final String _message;

  PodcastTimeoutException(this._message);

  String get message => _message ?? '';
}

/// Thrown if the search is cancelled.
class PodcastCancelledException implements Exception {
  final String _message;

  PodcastCancelledException(this._message);

  String get message => _message ?? '';
}

/// Thrown if we get an invalid response error.
class PodcastFailedException implements Exception {
  final String _message;

  PodcastFailedException(this._message);

  String get message => _message ?? '';
}
