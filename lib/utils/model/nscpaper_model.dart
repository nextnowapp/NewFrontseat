class NscPapers {
  final int id;
  final String subject;
  final String title;
  final String? paperUrl;
  final String? memoUrl;
  final String? markingGuideUrl;

  NscPapers({
    this.paperUrl,
    this.memoUrl,
    this.markingGuideUrl,
    required this.title,
    required this.id,
    required this.subject,
  });

  factory NscPapers.fromJson(Map<String, dynamic> json) {
    return NscPapers(
      title: json['title'],
      id: json['id'] as int,
      subject: json['subject'],
      paperUrl: json['paperURL'],
      memoUrl: json['memoURL'],
      markingGuideUrl: json['markingGuide'],
    );
  }
}

//List
class NscPapersList {
  final List<NscPapers> nscPapersList;

  NscPapersList({required this.nscPapersList});

  factory NscPapersList.fromJson(List<dynamic> json) {
    List<NscPapers> nscPapersList;
    nscPapersList = json.map((i) => NscPapers.fromJson(i)).toList();

    return NscPapersList(
      nscPapersList: nscPapersList,
    );
  }
}
