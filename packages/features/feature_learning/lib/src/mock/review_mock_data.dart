class ReviewCardItem {
  const ReviewCardItem({
    required this.id,
    required this.front,
    required this.back,
    required this.example,
  });

  final String id;
  final String front;
  final String back;
  final String example;
}

const reviewMockCards = <ReviewCardItem>[
  ReviewCardItem(
    id: 'r_1',
    front: '継続',
    back: '持续，坚持',
    example: '継続は力なり。',
  ),
  ReviewCardItem(
    id: 'r_2',
    front: '挑戦',
    back: '挑战',
    example: '新しいことに挑戦する。',
  ),
  ReviewCardItem(
    id: 'r_3',
    front: '理解',
    back: '理解',
    example: '文法の意味を理解する。',
  ),
  ReviewCardItem(
    id: 'r_4',
    front: '目標',
    back: '目标',
    example: '今月の目標を決める。',
  ),
  ReviewCardItem(
    id: 'r_5',
    front: '達成',
    back: '达成',
    example: '目標を達成した。',
  ),
];
