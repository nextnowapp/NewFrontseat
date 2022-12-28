class Notice {
  String? title;
  String? date;
  String? destails;
  String? id;
  String? publish_on;
  String? notice_image;
  String? image_url;

  Notice(
      {this.title,
      this.date,
      this.destails,
      this.id,
      this.publish_on,
      this.image_url,
      this.notice_image});

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
        title: json['notice_title'].toString(),
        date: (json['notice_date'] ?? '').toString(),
        id: json['id'].toString(),
        publish_on: json['publish_on'].toString(),
        notice_image: json['notice_image'].toString(),
        image_url: json['image_url'].toString(),
        destails: json['notice_message'].toString());
  }
}

class NoticeList {
  List<Notice> notices;

  NoticeList(this.notices);

  factory NoticeList.fromJson(List<dynamic> json) {
    List<Notice> notices = [];

    notices = json.map((i) => Notice.fromJson(i)).toList();

    return NoticeList(notices);
  }
}
