import 'dart:io';

class Contact {
  String name;
  String number;
  String? comment;
  File? profilePic;

  Contact({
    required this.name,
    required this.number,
    this.comment,
    this.profilePic,
  });
}
