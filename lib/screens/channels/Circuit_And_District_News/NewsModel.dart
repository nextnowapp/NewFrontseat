class NewsModel {
  final bool? success;
  final Data? data;
  final String? message;

  NewsModel({
    this.success,
    this.data,
    this.message,
  });

  NewsModel.fromJson(Map<String, dynamic> json)
      : success = json['success'] as bool?,
        data = (json['data'] as Map<String, dynamic>?) != null
            ? Data.fromJson(json['data'] as Map<String, dynamic>)
            : null,
        message = json['message'] as String?;

  Map<String, dynamic> toJson() =>
      {'success': success, 'data': data?.toJson(), 'message': message};
}

class Data {
  final List<NewsList>? newsList;
  final String? baseUrl;
  final String? emptyNewsMessage;

  Data({this.newsList, this.baseUrl, this.emptyNewsMessage});

  Data.fromJson(Map<String, dynamic> json)
      : newsList = (json['newsList'] as List?)
            ?.map((dynamic e) => NewsList.fromJson(e as Map<String, dynamic>))
            .toList(),
        baseUrl = json['base_url'] as String?,
        emptyNewsMessage = json['emptyNewsMessage'] as String?;

  Map<String, dynamic> toJson() => {
        'newsList': newsList?.map((e) => e.toJson()).toList(),
        'base_url': baseUrl
      };
}

class NewsList {
  final int? id;
  final String? newsTitle;
  final String? image;
  final String? newsBody;
  final String? publishDate;
  final dynamic videoType;
  final dynamic videoUrl;
  final dynamic videoFile;
  final String? createdBy;

  NewsList({
    this.id,
    this.newsTitle,
    this.image,
    this.newsBody,
    this.publishDate,
    this.videoType,
    this.videoUrl,
    this.videoFile,
    this.createdBy,
  });

  NewsList.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        newsTitle = json['news_title'] as String?,
        image = json['image'] as String?,
        newsBody = json['news_body'] as String?,
        publishDate = json['p_date'] as String?,
        videoType = json['video_type'],
        videoUrl = json['video_url'],
        videoFile = json['video_file'],
        createdBy = json['created_by'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'news_title': newsTitle,
        'image': image,
        'news_body': newsBody,
        'p_date': publishDate,
        'video_type': videoType,
        'video_url': videoUrl,
        'video_file': videoFile,
        'created_by': createdBy
      };
}
