import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../auth/controllers/auth_controller.dart';
import '../../../models/account.dart';
import '../../../models/member.dart';
import '../../../providers/account_providers.dart';
import '../../../theme/app_theme.dart';

class MembersTab extends ConsumerWidget {
  const MembersTab({super.key, required this.account});

  final Account account;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current user's role
    final currentUserRole = _getCurrentUserRole(account, ref);
    final canManage = currentUserRole?.canManage ?? false;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Invite Section (only for managers and owners)
          if (canManage) ...[
            Card(
              color: AppTheme.cardDark,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.link, color: AppTheme.primaryGreen),
                        const SizedBox(width: 12),
                        const Text(
                          'Invite Members',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Share this link to invite members to this account',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _generateAndCopyLink(context, ref),
                            icon: const Icon(Icons.copy),
                            label: const Text('Copy Link'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _generateAndShareLink(context, ref),
                            icon: const Icon(Icons.share),
                            label: const Text('Share'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryGreen,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Members List Header
          Row(
            children: [
              Text(
                'Members (${account.members.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (canManage)
                IconButton(
                  onPressed: () => _showAddMemberSheet(context, ref),
                  icon: const Icon(Icons.person_add),
                  tooltip: 'Add Member',
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Members List
          ...account.members.map((member) {
            return _MemberCard(
              member: member,
              account: account,
              currentUserRole: currentUserRole,
            );
          }),
        ],
      ),
    );
  }

  MemberRole? _getCurrentUserRole(Account account, WidgetRef ref) {
    // Get current user ID from auth
    final authState = ref.read(authStateChangesProvider);
    final currentUserId = authState.value?.uid;
    
    if (currentUserId == null) return null;
    
    final member = account.members.firstWhere(
      (m) => m.uid == currentUserId,
      orElse: () => AccountMember(uid: '', role: MemberRole.viewer),
    );
    
    return member.uid.isNotEmpty ? member.role : null;
  }

  Future<void> _generateAndCopyLink(BuildContext context, WidgetRef ref) async {
    try {
      final controller = ref.read(accountControllerProvider.notifier);
      final link = await controller.generateInviteLink(account.id);
      
      await Clipboard.setData(ClipboardData(text: link));
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invite link copied to clipboard')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _generateAndShareLink(BuildContext context, WidgetRef ref) async {
    try {
      final controller = ref.read(accountControllerProvider.notifier);
      final link = await controller.generateInviteLink(account.id);
      
      await Share.share(
        'Join my account "${account.title}" on CashFlowX:\n$link',
        subject: 'CashFlowX Invite',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _showAddMemberSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.backgroundDark,
      builder: (context) => _AddMemberSheet(account: account),
    );
  }
}

class _MemberCard extends ConsumerWidget {
  const _MemberCard({
    required this.member,
    required this.account,
    required this.currentUserRole,
  });

  final AccountMember member;
  final Account account;
  final MemberRole? currentUserRole;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOwner = member.role == MemberRole.owner;
    final canManage = currentUserRole?.canManage ?? false;
    final isSelf = ref.read(authStateChangesProvider).value?.uid == member.uid;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.cardDark,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              backgroundColor: _getRoleColor(member.role).withOpacity(0.2),
              child: Icon(
                Icons.person,
                color: _getRoleColor(member.role),
              ),
            ),
            const SizedBox(width: 16),
            
            // Member Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        member.uid.substring(0, 8), // Show truncated ID
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isSelf) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'You',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getRoleColor(member.role).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getRoleLabel(member.role),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _getRoleColor(member.role),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Actions
            if (canManage && !isOwner && !isSelf)
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'change_role') {
                    _showChangeRoleSheet(context, ref, member);
                  } else if (value == 'remove') {
                    _showRemoveDialog(context, ref, member);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'change_role',
                    child: Row(
                      children: [
                        Icon(Icons.swap_horiz, size: 20),
                        SizedBox(width: 12),
                        Text('Change Role'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'remove',
                    child: Row(
                      children: [
                        Icon(Icons.person_remove, size: 20, color: Colors.red),
                        SizedBox(width: 12),
                        Text('Remove', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(MemberRole role) {
    switch (role) {
      case MemberRole.owner:
        return Colors.purple;
      case MemberRole.manager:
        return Colors.blue;
      case MemberRole.editor:
        return Colors.green;
      case MemberRole.viewer:
        return Colors.orange;
    }
  }

  String _getRoleLabel(MemberRole role) {
    switch (role) {
      case MemberRole.owner:
        return 'Owner';
      case MemberRole.manager:
        return 'Manager';
      case MemberRole.editor:
        return 'Editor';
      case MemberRole.viewer:
        return 'Viewer';
    }
  }

  void _showChangeRoleSheet(BuildContext context, WidgetRef ref, AccountMember member) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.backgroundDark,
      builder: (context) => _ChangeRoleSheet(
        account: account,
        member: member,
      ),
    );
  }

  void _showRemoveDialog(BuildContext context, WidgetRef ref, AccountMember member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Member'),
        content: const Text('Are you sure you want to remove this member from the account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final controller = ref.read(accountControllerProvider.notifier);
      await controller.removeMember(account.id, member.uid);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Member removed')),
        );
      }
    }
  }
}

class _AddMemberSheet extends ConsumerStatefulWidget {
  const _AddMemberSheet({required this.account});

  final Account account;

  @override
  ConsumerState<_AddMemberSheet> createState() => _AddMemberSheetState();
}

class _AddMemberSheetState extends ConsumerState<_AddMemberSheet> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  MemberRole _selectedRole = MemberRole.viewer;

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Member',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _userIdController,
                decoration: InputDecoration(
                  labelText: 'User ID',
                  hintText: 'Enter user ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter user ID';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              const Text(
                'Role',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              
              ...[MemberRole.viewer, MemberRole.editor, MemberRole.manager].map((role) {
                return RadioListTile<MemberRole>(
                  title: Text(_getRoleLabel(role)),
                  subtitle: Text(_getRoleDescription(role)),
                  value: role,
                  groupValue: _selectedRole,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedRole = value);
                    }
                  },
                  contentPadding: EdgeInsets.zero,
                );
              }),
              
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _addMember,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Add Member'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRoleLabel(MemberRole role) {
    switch (role) {
      case MemberRole.owner:
        return 'Owner';
      case MemberRole.manager:
        return 'Manager';
      case MemberRole.editor:
        return 'Editor';
      case MemberRole.viewer:
        return 'Viewer';
    }
  }

  String _getRoleDescription(MemberRole role) {
    switch (role) {
      case MemberRole.owner:
        return 'Full control';
      case MemberRole.manager:
        return 'Add, edit, delete entries and manage members';
      case MemberRole.editor:
        return 'Add and edit entries';
      case MemberRole.viewer:
        return 'Read-only access';
    }
  }

  Future<void> _addMember() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(accountControllerProvider.notifier);
    await controller.addMember(
      widget.account.id,
      _userIdController.text.trim(),
      _selectedRole,
    );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Member added')),
      );
    }
  }
}

class _ChangeRoleSheet extends ConsumerStatefulWidget {
  const _ChangeRoleSheet({
    required this.account,
    required this.member,
  });

  final Account account;
  final AccountMember member;

  @override
  ConsumerState<_ChangeRoleSheet> createState() => _ChangeRoleSheetState();
}

class _ChangeRoleSheetState extends ConsumerState<_ChangeRoleSheet> {
  late MemberRole _selectedRole;

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.member.role;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Change Role',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          ...[MemberRole.viewer, MemberRole.editor, MemberRole.manager].map((role) {
            return RadioListTile<MemberRole>(
              title: Text(_getRoleLabel(role)),
              subtitle: Text(_getRoleDescription(role)),
              value: role,
              groupValue: _selectedRole,
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedRole = value);
                }
              },
              contentPadding: EdgeInsets.zero,
            );
          }),
          
          const SizedBox(height: 24),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _changeRole,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Update Role'),
            ),
          ),
        ],
      ),
    );
  }

  String _getRoleLabel(MemberRole role) {
    switch (role) {
      case MemberRole.owner:
        return 'Owner';
      case MemberRole.manager:
        return 'Manager';
      case MemberRole.editor:
        return 'Editor';
      case MemberRole.viewer:
        return 'Viewer';
    }
  }

  String _getRoleDescription(MemberRole role) {
    switch (role) {
      case MemberRole.owner:
        return 'Full control';
      case MemberRole.manager:
        return 'Add, edit, delete entries and manage members';
      case MemberRole.editor:
        return 'Add and edit entries';
      case MemberRole.viewer:
        return 'Read-only access';
    }
  }

  Future<void> _changeRole() async {
    final controller = ref.read(accountControllerProvider.notifier);
    await controller.updateMemberRole(
      widget.account.id,
      widget.member.uid,
      _selectedRole,
    );

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Role updated')),
      );
    }
  }
}
