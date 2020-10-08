class NoticeModel {
  final String title;
  final String description;
  final String author;
  final String creationDate;
  final String mails;
  final String send;


  NoticeModel (this.title, this.description, this.author, this.creationDate,
      this.mails, this.send);

}
class PojoCreateNotice {

  final List<String> mails;
  final bool sendNotification;
  final String title;
  final String description;

  PojoCreateNotice(
      this.mails, this.sendNotification, this.title, this.description);
}

class PojoId{
  final String id;

  PojoId(this.id);
}

class PojoModifyNotice{
  final String id;
  final String title;
  final String description;

  PojoModifyNotice(this.id, this.title, this.description);
}