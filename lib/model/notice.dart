import 'dart:collection';

class NoticeModel {
  final String id;
  final String title;
  final String description;
  final String author;
  final String creationDate;
  final String mails;
  final String send;


  NoticeModel (this.id, this.title, this.description, this.author, this.creationDate,
      this.mails, this.send);

  Map<String, dynamic> toJson() =>{
    'id' : id,
    'title' : title,
    'description' : description,
    'author' : author,
    'creationDate' : creationDate,
    'mails' : mails,
    'send' : send
  };

}
class PojoCreateNotice {

  final List<String> mails;
  final bool sendNotification;
  final String title;
  final String description;
  final PojoData data;

  PojoCreateNotice(
      this.mails, this.sendNotification, this.title, this.description, this.data);
}

class PojoData{
  final Map<String, Object> additionalProperties;

  PojoData(this.additionalProperties);
}

class PojoId{
  final String id;

  PojoId(this.id);

  Map<String, dynamic> toJson() =>{
    'id' : id
  };

}

class PojoModifyNotice{
  final String id;
  final String title;
  final String description;

  PojoModifyNotice(this.id, this.title, this.description);
}