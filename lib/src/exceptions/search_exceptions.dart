// Copyright (c) 2019, Ben Hills. Use of this source code is governed by a
// MIT license that can be found in the LICENSE file.

class PodcastTimeoutException implements Exception {
  final String _message;

  PodcastTimeoutException(this._message);

  String get message => _message ?? '';
}

class PodcastCancelledException implements Exception {
  final String _message;

  PodcastCancelledException(this._message);

  String get message => _message ?? '';
}

class PodcastFailedException implements Exception {
  final String _message;

  PodcastFailedException(this._message);

  String get message => _message ?? '';
}
