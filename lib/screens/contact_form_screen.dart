import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/contact.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

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
    final picker = ImagePicker();

    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      final permission = sdkInt >= 33
          ? await Permission.photos.request()
          : await Permission.storage.request();

      if (!mounted) return;

      if (permission.isGranted) {
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _profilePic = File(pickedFile.path);
          });
        }
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Permission denied')));
      }
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newContact = Contact(
        id: widget.contact?.id,
        name: _name!,
        number: _number!,
        comment: _comment,
        profilePic: _profilePic,
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
        padding: const EdgeInsets.all(16),
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
                        ? const Icon(
                            Icons.add_a_photo,
                            size: 40,
                            color: Colors.grey,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(
                  labelText: 'Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Name is required'
                    : null,
                onSaved: (val) => _name = val?.trim(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _number,
                decoration: const InputDecoration(
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
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _comment,
                decoration: const InputDecoration(
                  labelText: 'Comment (optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onSaved: (val) => _comment = val?.trim(),
              ),
              const SizedBox(height: 32),
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
