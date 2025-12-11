class FeedbackResponseParams {
  final String id;
  final int createTime;
  final String problemDesc;
  final List<String> screenShots;
  final String? contactPhone;

  FeedbackResponseParams({
    required this.id,
    required this.createTime,
    required this.problemDesc,
    required this.screenShots,
    this.contactPhone,
  });
}
