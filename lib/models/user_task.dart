class UserTask {
  final String id;
  final String title;
  String? description;
  DateTime? startingDate;
  DateTime? endingDate;
  final String imagePath;
  bool isDone;

  UserTask(
    this.id,
    this.title,
    this.description,
    this.startingDate,
    this.endingDate, {
    this.imagePath = 'assets/images/self.png',
    this.isDone = false,
  });
}
