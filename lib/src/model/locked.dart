import 'package:meta/meta.dart';

class Locked {
  final bool locked;
  final String owner;

  Locked({
    @required this.locked,
    @required this.owner,
  });
}
