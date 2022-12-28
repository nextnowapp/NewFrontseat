class DistrictEventsModel {
  final bool? success;
  final Events? data;
  final dynamic message;

  DistrictEventsModel({
    this.success,
    this.data,
    this.message,
  });

  DistrictEventsModel.fromJson(Map<String, dynamic> json)
      : success = json['success'] as bool?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? Events.fromJson(json['data'] as Map<String, dynamic>)
            : null,
        message = json['message'];

  Map<String, dynamic> toJson() =>
      {'success': success, 'data': data?.toJson(), 'message': message};
}

class Events {
  final String? eventHeadline;
  final String? emptyEventMessage;
  final List<EventList>? eventList;
  final String? baseUrl;

  Events({
    this.eventHeadline,
    this.emptyEventMessage,
    this.eventList,
    this.baseUrl,
  });

  Events.fromJson(Map<String, dynamic> json)
      : eventHeadline = json['eventHeadline'] as String?,
        emptyEventMessage = json['emptyEventMessage'] as String?,
        eventList = (json['eventList'] as List?)
            ?.map((dynamic e) => EventList.fromJson(e as Map<String, dynamic>))
            .toList(),
        baseUrl = json['base_url'] as String?;

  Map<String, dynamic> toJson() => {
        'eventHeadline': eventHeadline,
        'emptyEventMessage': emptyEventMessage,
        'eventList': eventList?.map((e) => e.toJson()).toList(),
        'base_url': baseUrl
      };
}

class EventList {
  final int? id;
  final String? eventDate;
  final String? eventTitle;
  final String? eventDes;
  final String? eventTime;
  final String? eventEndTime;
  final String? eventLocation;
  final bool? activeStatus;

  EventList({
    this.id,
    this.eventDate,
    this.eventTitle,
    this.eventDes,
    this.eventTime,
    this.eventEndTime,
    this.eventLocation,
    this.activeStatus,
  });

  EventList.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        eventDate = json['event_date'] as String?,
        eventTitle = json['event_title'] as String?,
        eventDes = json['event_des'] as String?,
        eventTime = json['event_time'] as String?,
        eventEndTime = json['event_end_time'] as String?,
        eventLocation = json['event_location'] as String?,
        activeStatus = json['active_status'] as bool?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'event_date': eventDate,
        'event_title': eventTitle,
        'event_des': eventDes,
        'event_time': eventTime,
        'event_end_time': eventEndTime,
        'event_location': eventLocation,
        'active_status': activeStatus
      };
}
