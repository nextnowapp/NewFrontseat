class ANAPapers {
  final int? id;
  final int? year;
  final String? grade;
  final String? subject;
  final String? language;
  final String? paperURL;
  final String? memoURL;

  ANAPapers({
    this.id,
    this.year,
    this.grade,
    this.subject,
    this.language,
    this.paperURL,
    this.memoURL,
  });

  ANAPapers.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int?,
      year = json['year'] as int?,
      grade = json['grade'] as String?,
      subject = json['subject'] as String?,
      language = json['language'] as String?,
      paperURL = json['paperURL'] ?? json['memoURL'] as String?,
      memoURL = json['memoURL'] as String?;

  Map<String, dynamic> toJson() => {
    'id' : id,
    'year' : year,
    'grade' : grade,
    'subject' : subject,
    'language' : language,
    'paperURL' : paperURL,
    'memoURL' : memoURL
  };
}
class ANAList {
  final List<ANAPapers> anaList;

  ANAList({required this.anaList});

  factory ANAList.fromJson(List<dynamic> json) {
    List<ANAPapers> anaList;
    anaList = json.map((i) => ANAPapers.fromJson(i)).toList();

    return ANAList(
      anaList: anaList,
    );
  }
}
