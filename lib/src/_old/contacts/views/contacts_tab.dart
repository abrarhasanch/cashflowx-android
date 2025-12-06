import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/contact.dart';
import '../../providers/contact_providers.dart';
import '../../theme/app_theme.dart';

class ContactsTab extends ConsumerStatefulWidget {
  const ContactsTab({super.key, required this.shelfId, required this.bookId});

  final String shelfId;
  final String bookId;

  @override
  ConsumerState<ContactsTab> createState() => _ContactsTabState();
}

class _ContactsTabState extends ConsumerState<ContactsTab> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final contacts = ref.watch(contactsProvider((widget.shelfId, widget.bookId)));
    return Container(
      color: AppTheme.backgroundDark,
      child: Stack(
        children: [
          contacts.when(
            loading: () => Center(child: CircularProgressIndicator(color: AppTheme.primaryGreen)),
            error: (error, _) => Center(
              child: Text(
                'Error: $error',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            data: (data) {
              final filtered = data.where((contact) => contact.name.toLowerCase().contains(query.toLowerCase())).toList();
              if (filtered.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline_rounded,
                        size: 64,
                        color: AppTheme.textMutedDark,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No contacts yet',
                        style: TextStyle(
                          color: AppTheme.textMutedDark,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => _showContactSheet(),
                        icon: const Icon(Icons.person_add_alt_rounded),
                        label: const Text('Add Contact'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Search bar
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cardDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.borderDark),
                    ),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search_rounded, color: AppTheme.textMutedDark),
                        hintText: 'Search contacts',
                        hintStyle: TextStyle(color: AppTheme.textMutedDark),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      onChanged: (value) => setState(() => query = value),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...filtered.map((contact) => _ContactTile(
                        contact: contact,
                        onEdit: () => _showContactSheet(contact: contact),
                        onDelete: () => _delete(contact),
                      )),
                  const SizedBox(height: 80),
                ],
              );
            },
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton.extended(
              onPressed: _showContactSheet,
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.person_add_alt_rounded),
              label: const Text('Contact'),
            ),
          ),
        ],
      ),
    );
  }

  void _delete(Contact contact) {
    ref.read(contactControllerProvider.notifier).delete(contact.shelfId, contact.bookId, contact.id);
  }

  void _showContactSheet({Contact? contact}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => ContactSheet(
        shelfId: widget.shelfId,
        bookId: widget.bookId,
        contact: contact,
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.contact, required this.onEdit, required this.onDelete});

  final Contact contact;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                contact.name.characters.first.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                if ((contact.phone ?? '').isNotEmpty)
                  Text(
                    contact.phone!,
                    style: TextStyle(
                      color: AppTheme.textMutedDark,
                      fontSize: 13,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit_outlined, color: AppTheme.textMutedDark),
            onPressed: onEdit,
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: AppTheme.errorRed),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

class ContactSheet extends ConsumerStatefulWidget {
  const ContactSheet({super.key, required this.shelfId, required this.bookId, this.contact});

  final String shelfId;
  final String bookId;
  final Contact? contact;

  @override
  ConsumerState<ContactSheet> createState() => _ContactSheetState();
}

class _ContactSheetState extends ConsumerState<ContactSheet> {
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;
  late final TextEditingController notesController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.contact?.name ?? '');
    phoneController = TextEditingController(text: widget.contact?.phone ?? '');
    emailController = TextEditingController(text: widget.contact?.email ?? '');
    notesController = TextEditingController(text: widget.contact?.notes ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    notesController.dispose();
    super.dispose();
  }

  InputDecoration _darkInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: AppTheme.textMutedDark),
      filled: true,
      fillColor: AppTheme.cardDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.primaryGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppTheme.errorRed),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(contactControllerProvider);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.contact == null ? 'Add Contact' : 'Edit Contact',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: _darkInputDecoration('Name *'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                style: const TextStyle(color: Colors.white),
                decoration: _darkInputDecoration('Phone'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                style: const TextStyle(color: Colors.white),
                decoration: _darkInputDecoration('Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: notesController,
                style: const TextStyle(color: Colors.white),
                decoration: _darkInputDecoration('Notes'),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            final contact = Contact(
                              id: widget.contact?.id ?? '',
                              shelfId: widget.shelfId,
                              bookId: widget.bookId,
                              name: nameController.text.trim(),
                              phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
                              email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
                              notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
                              createdAt: widget.contact?.createdAt ?? DateTime.now(),
                              createdByUid: widget.contact?.createdByUid,
                            );
                            ref.read(contactControllerProvider.notifier).upsert(contact);
                            Navigator.of(context).pop();
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: controller.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Save',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
