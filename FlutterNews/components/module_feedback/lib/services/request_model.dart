class SubmitFeedbackParams {
  final String problemDesc;
  final List<String> screenShots;
  final String? contactPhone;

  SubmitFeedbackParams({
    required this.problemDesc,
    required this.screenShots,
    this.contactPhone,
  });
}