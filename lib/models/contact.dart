import 'dart:io';

class Contact {
  final int? id;
  final String name;
  final String number;
  final String? comment;
  final File? profilePic;

  Contact({
    this.id,
    required this.name,
    required this.number,
    this.comment,
    this.profilePic,
  });

  Contact copyWith({
    int? id,
    String? name,
    String? number,
    String? comment,
    File? profilePic,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      comment: comment ?? this.comment,
      profilePic: profilePic ?? this.profilePic,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'number': number,
      'comment': comment,
      'profilePic': profilePic?.path,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      name: map['name'],
      number: map['number'],
      comment: map['comment'],
      profilePic: map['profilePic'] != null ? File(map['profilePic']) : null,
    );
  }
}
