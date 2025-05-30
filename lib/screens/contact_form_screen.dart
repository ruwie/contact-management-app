import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/contact.dart';

class ContactFormScreen extends StatefulWidget {
  final Contact? contact;

  const ContactFormScreen({super.key, this.contact});

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _number;
  String? _comment;
  File? _profilePic;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _name = widget.contact!.name;
      _number = widget.contact!.number;
      _comment = widget.contact!.comment;
      _profilePic = widget.contact!.profilePic;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profilePic = File(pickedFile.path);
      });
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newContact = Contact(
        name: _name!,
        number: _number!,
        comment: _comment,
        profilePic: _profilePic, // << Include this
      );
      Navigator.of(context).pop(newContact);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.contact != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Contact' : 'Add Contact')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _profilePic != null
                        ? FileImage(_profilePic!)
                        : null,
                    child: _profilePic == null
                        ? Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(
                  labelText: 'Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Name is required'
                    : null,
                onSaved: (val) => _name = val?.trim(),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _number,
                decoration: InputDecoration(
                  labelText: 'Number *',
                  border: OutlineInputBorder(),
                ),
                maxLength: 11,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Number is required';
                  }
                  final trimmed = val.trim();
                  if (trimmed.length > 11) {
                    return 'Max 11 digits allowed';
                  }
                  if (!RegExp(r'^\d+$').hasMatch(trimmed)) {
                    return 'Only digits allowed';
                  }
                  return null;
                },
                onSaved: (val) => _number = val?.trim(),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _comment,
                decoration: InputDecoration(
                  labelText: 'Comment (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onSaved: (val) => _comment = val?.trim(),
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _save,
                child: Text(isEditing ? 'Save Changes' : 'Add Contact'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
