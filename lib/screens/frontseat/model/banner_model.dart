class BannerModel {
  bool? success;
  String? message;
  List<Banner>? data;

  BannerModel({this.success, this.message, this.data});

  BannerModel.fromJson(json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Banner>[];
      json['data'].forEach((v) {
        data!.add(new Banner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    return data;
  }
}

class Banner {
  String? bannerimageurl;
  String? bannerSiteUrl;

  Banner({this.bannerimageurl, this.bannerSiteUrl});

  Banner.fromJson(Map<String, dynamic> json) {
    bannerimageurl = json['banner_image_url'];
    bannerSiteUrl = json['banner_site_url'];
  }
}
