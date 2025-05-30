import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../widgets/contact_tile.dart';
import 'contact_form_screen.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final List<Contact> _contacts = [];

  void _addOrEditContact({Contact? contact, int? index}) async {
    final result = await Navigator.of(context).push<Contact>(
      MaterialPageRoute(builder: (_) => ContactFormScreen(contact: contact)),
    );

    if (result != null) {
      setState(() {
        if (index != null) {
          _contacts[index] = result;
        } else {
          _contacts.add(result);
        }
      });
    }
  }

  void _deleteContact(int index) {
    setState(() {
      _contacts.removeAt(index);
    });
  }

  void _showContactDetails(Contact contact) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(contact.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: contact.profilePic != null
                  ? FileImage(contact.profilePic!)
                  : null,
              child: contact.profilePic == null
                  ? Text(
                      contact.name[0].toUpperCase(),
                      style: TextStyle(fontSize: 40),
                    )
                  : null,
            ),
            SizedBox(height: 10),
            Text('Number: ${contact.number}'),
            if (contact.comment != null && contact.comment!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text('Comment: ${contact.comment}'),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: _contacts.isEmpty
          ? const Center(child: Text('No contacts. Add some!'))
          : ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                final contact = _contacts[index];
                return ContactTile(
                  contact: contact,
                  onEdit: () =>
                      _addOrEditContact(contact: contact, index: index),
                  onDelete: () => _deleteContact(index),
                  onTap: () => _showContactDetails(contact),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _addOrEditContact(),
      ),
    );
  }
}
