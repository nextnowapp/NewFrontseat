class IEBPapers {
  final int? id;
  final int? year;
  final String? language;
  final String? subject;
  final String? paperURL;
  final String? memoURL;
  final dynamic materialURL;

  IEBPapers({
    this.id,
    this.year,
    this.language,
    this.subject,
    this.paperURL,
    this.memoURL,
    this.materialURL,
  });

  IEBPapers.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int?,
      year = json['year'] as int?,
      language = json['language'] as String?,
      subject = json['subject'] as String?,
      paperURL = json['paperURL'] as String?,
      memoURL = json['memoURL'] as String?,
      materialURL = json['materialURL'] ??json['paperURL'] ?? json['memoURL'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'year' : year,
    'language' : language,
    'subject' : subject,
    'paperURL' : paperURL,
    'memoURL' : memoURL,
    'materialURL' : materialURL
  };
}

class IEBList {
  final List<IEBPapers> iebList;

  IEBList({required this.iebList});

  factory IEBList.fromJson(List<dynamic> json) {
    List<IEBPapers> iebList;
    iebList = json.map((i) => IEBPapers.fromJson(i)).toList();

    return IEBList(
      iebList: iebList,
    );
  }
}
