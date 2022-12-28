class WallOfFame {
  final int id;
  final String name;
  final String years;
  final String imageUrl;
  final String desc;
  final String designation;
  final int school_id;
  final String award_type;

  //define constructor
  WallOfFame({
    required this.id,
    required this.name,
    required this.years,
    required this.imageUrl,
    required this.desc,
    required this.designation,
    required this.school_id,
    required this.award_type,
  });

  //define fromJson method
  factory WallOfFame.fromJson(Map<String, dynamic> json) {
    return WallOfFame(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      years: json['years'] ?? '',
      imageUrl: json['image'] ?? '',
      desc: json['description'] ?? '',
      designation: json['designation'] ?? '',
      school_id: json['school_id'] ?? 0,
      award_type: json['award_type'] ?? '',
    );
  }
}

//list of wallOfFame
class WallOfFameList {
  final List<WallOfFame> wallOfFame;

  //define constructor
  WallOfFameList({
    required this.wallOfFame,
  });

  //define fromJson method
  factory WallOfFameList.fromJson(List<dynamic> parsedJson) {
    List<WallOfFame> wallOfFame = <WallOfFame>[];
    wallOfFame = parsedJson.map((i) => WallOfFame.fromJson(i)).toList();

    return WallOfFameList(wallOfFame: wallOfFame);
  }
}
