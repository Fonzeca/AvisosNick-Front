import 'dart:collection';

class NoticeModel {
  final String id;
  final String title;
  final String description;
  final String author;
  final String creationDate;
  final String mails;
  final PojoCreateNotice send;


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

  final List<String> types;
  final List<String> mails;
  final bool sendNotification;
  final String title;
  final String description;
  final PojoData data;

  PojoCreateNotice(this.types,
      this.mails, this.sendNotification, this.title, this.description, this.data);

  Map<String, dynamic> toJson() =>{
    'types' : types,
    'mails' : mails,
    'sendNotification' : sendNotification,
    'title' : title,
    'description' : description,
    'data' : data

  };
}

class PojoData{
  final Map<String, Object> additionalProperties;


  PojoData(this.additionalProperties);


  Map<String, dynamic> toJson() =>{
    'additionalProperties' : additionalProperties
  };
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