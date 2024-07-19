


class Service {

  String iconUrl;
  String name;

  Service({
    required this.iconUrl,
    required this.name,
  });

  Map<String, Object?> toJson() {
    return {
      'iconUrl': iconUrl,
      'name': name,
    };
  }

  factory Service.fromJson(Map<String, Object?> json) {
    return Service(
      iconUrl: json['iconUrl'] as String,
      name: json['name'] as String,
    );
  }

  Service copyWith({
    String? iconUrl,
    String? name,
  }) {
    return Service(
      iconUrl: iconUrl?? this.iconUrl,
      name: name?? this.name,
    );
  }
}