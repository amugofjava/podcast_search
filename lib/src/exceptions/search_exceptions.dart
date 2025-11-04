// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

/// Thrown if the connection times out, or we timeout
/// waiting to receive the data.
class PodcastTimeoutException implements Exception {
  final int statusCode;
  final String message;

  PodcastTimeoutException(this.statusCode, this.message);
}

/// Thrown if the search is cancelled.
class PodcastCancelledException implements Exception {
  final int statusCode;
  final String message;

  PodcastCancelledException(this.statusCode, this.message);
}

/// Thrown if we get an invalid response error.
class PodcastFailedException implements Exception {
  final int statusCode;
  final String message;

  PodcastFailedException(this.statusCode, this.message);
}

/// Thrown if we get a certificate error.
class PodcastCertificateException implements Exception {
  final int statusCode;
  final String message;

  PodcastCertificateException(this.statusCode, this.message);
}

/// Thrown if the requested podcast has not updated.
class PodcastNotChangedException implements Exception {
  final int statusCode;
  final String message;

  PodcastNotChangedException(this.statusCode, this.message);
}

/// Thrown if we get an unknown error.
class PodcastUnknownException implements Exception {
  final int statusCode;
  final String message;

  PodcastUnknownException(this.statusCode, this.message);
}
