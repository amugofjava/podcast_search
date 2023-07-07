// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

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

/// Thrown if we get a certificate error.
class PodcastCertificateException implements Exception {
  final String message;

  PodcastCertificateException(this.message);
}

/// Thrown if we get an unknown error.
class PodcastUnknownException implements Exception {
  final String message;

  PodcastUnknownException(this.message);
}
