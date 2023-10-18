class ThoughtsModel {
  final bool? success;
  final String? message;
  final List<Thought>? data;

  ThoughtsModel({
    this.success,
    this.message,
    this.data,
  });

  ThoughtsModel.fromJson(Map<String, dynamic> json)
      : success = json['success'] as bool?,
        message = json['message'] as String?,
        data = (json['data'] as List?)
            ?.map((dynamic e) => Thought.fromJson(e as Map<String, dynamic>))
            .toList();

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data?.map((e) => e.toJson()).toList()
      };
}

class Thought {
  final String? thought;
  final String? author;

  Thought({
    this.thought,
    this.author,
  });

  Thought.fromJson(Map<String, dynamic> json)
      : thought = json['thought'] as String?,
        author = json['author'] as String?;

  Map<String, dynamic> toJson() => {'thought': thought, 'author': author};
}
