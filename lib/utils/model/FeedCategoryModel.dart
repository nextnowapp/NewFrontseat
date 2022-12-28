class SocialFeedCategoryModel {
  final bool? success;
  final List<FeedCategory>? data;
  final dynamic message;

  SocialFeedCategoryModel({
    this.success,
    this.data,
    this.message,
  });

  SocialFeedCategoryModel.fromJson(Map<String, dynamic> json)
    : success = json['success'] as bool?,
      data = (json['data'] as List?)?.map((dynamic e) => FeedCategory.fromJson(e as Map<String,dynamic>)).toList(),
      message = json['message'];

  Map<String, dynamic> toJson() => {
    'success' : success,
    'data' : data?.map((e) => e.toJson()).toList(),
    'message' : message
  };
}

class FeedCategory {
  final int? id;
  final String? feedsCategoryName;
  final String? feedsCategoryImage;
  final String? categoryCreatedBy;
  final String? createdAt;
  final String? updatedAt;

  FeedCategory({
    this.id,
    this.feedsCategoryName,
    this.feedsCategoryImage,
    this.categoryCreatedBy,
    this.createdAt,
    this.updatedAt,
  });

  FeedCategory.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int?,
      feedsCategoryName = json['feeds_category_name'] as String?,
      feedsCategoryImage = json['feeds_category_image'] as String?,
      categoryCreatedBy = json['category_created_by'] as String?,
      createdAt = json['created_at'] as String?,
      updatedAt = json['updated_at'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'feeds_category_name' : feedsCategoryName,
    'feeds_category_image' : feedsCategoryImage,
    'category_created_by' : categoryCreatedBy,
    'created_at' : createdAt,
    'updated_at' : updatedAt
  };
}