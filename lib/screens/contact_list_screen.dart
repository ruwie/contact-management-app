import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../widgets/contact_tile.dart';
import 'contact_form_screen.dart';
import '../helpers/contact_database.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    try {
      final contacts = await ContactDatabase.instance.readAllContacts();
      setState(() {
        _contacts = contacts;
        _filteredContacts = contacts;
      });
    } catch (e) {
      debugPrint('Error loading contacts: $e');
    }
  }

  Future<void> _addOrEditContact({Contact? contact, int? index}) async {
    final result = await Navigator.of(context).push<Contact>(
      MaterialPageRoute(builder: (_) => ContactFormScreen(contact: contact)),
    );

    if (result != null) {
      if (index != null) {
        await ContactDatabase.instance.update(result);
      } else {
        await ContactDatabase.instance.create(result);
      }
      await _loadContacts();
      _filterContacts(_searchQuery);
    }
  }

  Future<void> _deleteContact(int index) async {
    final contact = _filteredContacts[index];
    if (contact.id != null) {
      await ContactDatabase.instance.delete(contact.id!);
      await _loadContacts();
      _filterContacts(_searchQuery);
    }
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
                      style: const TextStyle(fontSize: 40),
                    )
                  : null,
            ),
            const SizedBox(height: 10),
            Text('Number: ${contact.number}'),
            if (contact.comment != null && contact.comment!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('Comment: ${contact.comment}'),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _filterContacts(String query) {
    setState(() {
      _searchQuery = query;
      _filteredContacts = _contacts
          .where(
            (contact) =>
                contact.name.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterContacts,
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _filteredContacts.isEmpty
          ? const Center(child: Text('No contacts. Add some!'))
          : ListView.builder(
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = _filteredContacts[index];
                return ContactTile(
                  contact: contact,
                  onEdit: () => _addOrEditContact(
                    contact: contact,
                    index: _contacts.indexOf(contact),
                  ),
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
