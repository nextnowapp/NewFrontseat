class SchoolGenInfo {
  final String? featuredImage;
  final String? schoolName;
  final String? schoolOfficeStatTime;
  final String? schoolOfficeEndTime;
  final String? schoolEmis;
  final String? schoolAddress;
  final String? phone;
  final String? email;
  final String? districtName;
  final String? schoolId;
  final int? districtId;

//define constructor
  SchoolGenInfo({
    this.featuredImage,
    this.schoolName,
    this.schoolOfficeStatTime,
    this.schoolOfficeEndTime,
    this.schoolEmis,
    this.schoolAddress,
    this.phone,
    this.email,
    this.districtName,
    this.schoolId,
    this.districtId,
  });

//define fromJson method
  factory SchoolGenInfo.fromJson(Map<String, dynamic> json) {
    return SchoolGenInfo(
      featuredImage: json['featured_image'] ?? '',
      schoolName: json['school_name'] ?? '',
      schoolOfficeStatTime: json['school_office_stat_time'] ?? '',
      schoolOfficeEndTime: json['school_office_end_time'] ?? '',
      schoolEmis: json['school_emis'] ?? '',
      schoolAddress: json['school_address'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      districtName: json['district_name'] ?? '',
      schoolId: json['school_id'] ?? '',
      districtId: json['district_id'] ?? 0,
    );
  }
}
