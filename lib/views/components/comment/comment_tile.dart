import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/providers/user_id_provider.dart';
import 'package:instagram_clone/state/comments/models/comment.dart';
import 'package:instagram_clone/state/comments/providers/delete_comment_provider.dart';
import 'package:instagram_clone/state/user_info/providers/user_info_model_provider.dart';
import 'package:instagram_clone/views/components/animations/small_error_animation_view.dart';
import 'package:instagram_clone/views/components/constants/strings.dart';
import 'package:instagram_clone/views/components/dialogs/alert_dialog_model.dart';
import 'package:instagram_clone/views/components/dialogs/delete_dialog.dart';

class CommentTile extends ConsumerWidget {
  const CommentTile({
    super.key,
    required this.comment,
  });

  final Comment comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfoModel = ref.watch(userInfoModelProvider(comment.fromUserId));
    return userInfoModel.when(
        data: (userInfoModel) {
          final currentUserId = ref.read(userIdProvider);
          return ListTile(
            trailing: currentUserId == comment.fromUserId
                ? IconButton(
                    onPressed: () async {
                      final shouldDelete = await displayDeleteDialog(context);
                      if (shouldDelete) {
                        await ref
                            .read(deleteCommentProvider.notifier)
                            .deleteComment(commendId: comment.id);
                      }
                    },
                    icon: const Icon(Icons.delete),
                  )
                : null,
            title: Text(userInfoModel.displayName),
            subtitle: Text(comment.comment),
          );
        },
        error: (e, _) => const SmallErrorAnimationView(),
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ));
  }

  Future<bool> displayDeleteDialog(BuildContext context) =>
      const DeleteDialog(titleOfObjectToDelete: Strings.comment)
          .present(context)
          .then((value) => value ?? false);
}
