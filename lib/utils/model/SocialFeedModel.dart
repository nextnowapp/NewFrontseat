class SocialFeedModel {
  final bool? success;
  final Data? data;
  final dynamic message;

  SocialFeedModel({
    this.success,
    this.data,
    this.message,
  });

  SocialFeedModel.fromJson(Map<String, dynamic> json)
    : success = json['success'] as bool?,
      data = (json['data'] as Map<String,dynamic>?) != null ? Data.fromJson(json['data'] as Map<String,dynamic>) : null,
      message = json['message'];

  Map<String, dynamic> toJson() => {
    'success' : success,
    'data' : data?.toJson(),
    'message' : message
  };
}

class Data {
  final List<Allfeeds>? allfeeds;

  Data({
    this.allfeeds,
  });

  Data.fromJson(Map<String, dynamic> json)
    : allfeeds = (json['allfeeds'] as List?)?.map((dynamic e) => Allfeeds.fromJson(e as Map<String,dynamic>)).toList();

  Map<String, dynamic> toJson() => {
    'allfeeds' : allfeeds?.map((e) => e.toJson()).toList()
  };
}

class Allfeeds {
  final int? id;
  final String? feedsHeadline;
  final String? feedsDetails;
  final String? feedsImage;
  final String? feedsDate;
  final String? feedsCategory;
  final String? feedsFor;
  final String? feedsType;
  final String? createdBy;
  final String? fullName;
  final String? staffPhoto;
  final int? daysAgo;
  final String? time;
  bool? liked;
  final int? viewCount;

  Allfeeds({
    this.id,
    this.feedsHeadline,
    this.feedsDetails,
    this.feedsImage,
    this.feedsDate,
    this.feedsCategory,
    this.feedsFor,
    this.feedsType,
    this.createdBy,
    this.fullName,
    this.staffPhoto,
    this.daysAgo,
    this.time,
    this.liked,
    this.viewCount,
  });

  Allfeeds.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int?,
      feedsHeadline = json['feeds_headline'] as String?,
      feedsDetails = json['feeds_details'] as String?,
      feedsImage = json['feeds_image'] as String?,
      feedsDate = json['feeds_date'] as String?,
      feedsCategory = json['feeds_category'] as String?,
      feedsFor = json['feeds_for'] as String?,
      feedsType = json['feeds_type'] as String?,
      createdBy = json['created_by'] as String?,
      fullName = json['full_name'] as String?,
      staffPhoto = json['staff_photo'] as String?,
      daysAgo = json['days_ago'] as int?,
      time = json['Time'] as String?,
      liked = json['liked'] as bool?,
      viewCount = json['view_count'] as int?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'feeds_headline' : feedsHeadline,
    'feeds_details' : feedsDetails,
    'feeds_image' : feedsImage,
    'feeds_date' : feedsDate,
    'feeds_category' : feedsCategory,
    'feeds_for' : feedsFor,
    'feeds_type' : feedsType,
    'created_by' : createdBy,
    'full_name' : fullName,
    'staff_photo' : staffPhoto,
    'days_ago' : daysAgo,
    'Time' : time,
    'liked' : liked,
    'view_count' : viewCount
  };
}