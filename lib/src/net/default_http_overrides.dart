// Copyright (c) 2019 Ben Hills and the project contributors. Use of this source
// code is governed by a MIT license that can be found in the LICENSE file.

import 'dart:io';

/// This class allows the user agent to be set for each call. Without it, setting a user agent
/// on a request only sends the user agent on the first call. Any 301 redirect results in the
/// user agent defaulting to 'Dart' which can be an issue with hosts that filter on user agent.
class DefaultHttpOverrides extends HttpOverrides {
  final String userAgent;

  DefaultHttpOverrides(this.userAgent);

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..userAgent = userAgent;
  }
}
