class   Content {
  int? id;
  String? title;
  String? type;
  String? availableFor;
  String? uploadDate;
  String? description;
  String? uploadFile;
  var createdBy;
  String? sourceUrl;

  Content({
    this.id,
    this.title,
    this.type,
    this.availableFor,
    this.uploadDate,
    this.description,
    this.uploadFile,
    this.createdBy,
    this.sourceUrl,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    print(json);
    return Content(
      id: json['id'],
      title: json['title'],
      type: json['type'],
      availableFor: json['available_for'],
      uploadDate: json['upload_date'],
      description: json['description'],
      uploadFile: json['upload_file'],
      createdBy:
          json['created_by'] == null ? ' ' : json['created_by'],
      sourceUrl: json['source_url'] == null ? ' ' : json['source_url'],
    );
  }
}

class ContentList {
  List<Content> contents;

  ContentList(this.contents);

  factory ContentList.fromJson(List<dynamic> json) {
    List<Content> contentList = [];

    contentList = json.map((i) => Content.fromJson(i)).toList();

    return ContentList(contentList);
  }
}
