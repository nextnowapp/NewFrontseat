class Ebooks {
  final String title;
  final String language;
  final int id;
  final int grade;
  final String url;
  final int size;

  Ebooks(
      {required this.title,
      required this.language,
      required this.id,
      required this.grade,
      required this.url,
      required this.size});

  factory Ebooks.fromJson(Map<String, dynamic> json) {
    return Ebooks(
      title: json['title'] ?? json['subject'],
      language: json['language'] ?? '',
      id: json['id'] as int,
      grade: json['grade'] ?? int.parse('0'),
      url: json['url'],
      size: json['size'] as int,
    );
  }
}

class EbookList {
  final List<Ebooks> ebookList;

  EbookList({required this.ebookList});

  factory EbookList.fromJson(List<dynamic> json) {
    List<Ebooks> ebookList;
    ebookList = json.map((i) => Ebooks.fromJson(i)).toList();

    return EbookList(
      ebookList: ebookList,
    );
  }
}
