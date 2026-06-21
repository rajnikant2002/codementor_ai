class ReviewModel {
  final String content;
  final int rating;

  ReviewModel({required this.content, required this.rating});

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    content: json['content'] as String? ?? '',
    rating: json['rating'] as int? ?? 0,
  );

  Map<String, dynamic> toJson() => {'content': content, 'rating': rating};
}
