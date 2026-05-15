class EventsModel {
  final int id;
  final String name;

  EventsModel({required this.id, required this.name});

  factory EventsModel.fromJson(Map<String, dynamic> json) {
    return EventsModel(
      id: json['id'],
      name: json['event_name'],
    );
  }
}