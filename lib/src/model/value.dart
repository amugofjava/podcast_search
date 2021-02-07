class Value {
  final ValueModel model;
  final List<ValueDestination> destinations;

  Value(this.model, this.destinations);

  static Value fromJson(Map<String, dynamic> json) {
    final model = ValueModel.fromJson(json['model']);
    final destinations = <ValueDestination>[];
    final destinationsJson = json['destinations'];
    if (destinationsJson is List) {
      destinationsJson.forEach((d) {
        if (d is Map<String, dynamic>) {
          destinations.add(ValueDestination.fromJson(d));
        }
      });
    }
    return Value(model, destinations);
  }
}

class ValueModel {
  final String type;
  final String method;
  final String suggested;

  ValueModel({this.type, this.method, this.suggested});

  static ValueModel fromJson(Map<String, dynamic> json) {
    return ValueModel(type: json['type'] as String, method: json['method'] as String, suggested: json['suggested'] as String);
  }
}

class ValueDestination {
  final String name;
  final String address;
  final String type;
  final num split;

  ValueDestination({this.name, this.address, this.type, this.split});

  static ValueDestination fromJson(Map<String, dynamic> json) {
    var split = json['split'];
    if (split is String) {
      split = double.tryParse(split);
    }
    return ValueDestination(
      name: json['name'] as String,
      address: json['address'] as String,
      type: json['type'] as String,
      split: split as num,
    );
  }
}
