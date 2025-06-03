import 'package:flutter/material.dart';
import '../models/contact.dart';

class ContactTile extends StatelessWidget {
  final Contact contact;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const ContactTile({
    super.key,
    required this.contact,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: contact.profilePic != null
            ? FileImage(contact.profilePic!)
            : null,
        child: contact.profilePic == null
            ? Text(contact.name[0].toUpperCase())
            : null,
      ),
      title: Text(contact.name),
      subtitle: Text(contact.number),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: Icon(Icons.edit), onPressed: onEdit),
          IconButton(icon: Icon(Icons.delete), onPressed: onDelete),
        ],
      ),
      onTap: onTap,
    );
  }
}
