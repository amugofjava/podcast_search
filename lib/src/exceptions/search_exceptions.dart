// Copyright (c) 2019-2021, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

/// Thrown if the connection times out, or we timeout
/// waiting to receive the data.
class PodcastTimeoutException implements Exception {
  final String message;

  PodcastTimeoutException(this.message);
}

/// Thrown if the search is cancelled.
class PodcastCancelledException implements Exception {
  final String message;

  PodcastCancelledException(this.message);
}

/// Thrown if we get an invalid response error.
class PodcastFailedException implements Exception {
  final String message;

  PodcastFailedException(this.message);
}
