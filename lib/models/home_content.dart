class HomeContent {
  final String scriptureText;
  final String scriptureReference;
  final List<HomeFeature> features;
  final List<ChurchEvent> events;

  const HomeContent({
    required this.scriptureText,
    required this.scriptureReference,
    required this.features,
    required this.events,
  });

  factory HomeContent.fromJson(Map<String, dynamic> json) {
    final scripture = json['scripture'] as Map<String, dynamic>;

    return HomeContent(
      scriptureText: scripture['text'] as String,
      scriptureReference: scripture['reference'] as String,
      features: (json['features'] as List)
          .map((item) => HomeFeature.fromJson(item as Map<String, dynamic>))
          .toList(),
      events: (json['events'] as List)
          .map((item) => ChurchEvent.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class HomeFeature {
  final String title;
  final String subtitle;
  final String icon;
  final String color;

  const HomeFeature({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  factory HomeFeature.fromJson(Map<String, dynamic> json) {
    return HomeFeature(
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
    );
  }
}

class ChurchEvent {
  final String title;
  final String date;

  const ChurchEvent({
    required this.title,
    required this.date,
  });

  factory ChurchEvent.fromJson(Map<String, dynamic> json) {
    return ChurchEvent(
      title: json['title'] as String,
      date: json['date'] as String,
    );
  }
}