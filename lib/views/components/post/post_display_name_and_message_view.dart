import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/posts/models/post.dart';
import 'package:instagram_clone/state/user_info/providers/user_info_model_provider.dart';
import 'package:instagram_clone/views/components/animations/small_error_animation_view.dart';
import 'package:instagram_clone/views/components/rich_two_part_text.dart';

class PostDisplayNameAndMessageView extends ConsumerWidget {
  final Post post;
  const PostDisplayNameAndMessageView({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfoModel = ref.watch(userInfoModelProvider(post.userId));
    return userInfoModel.when(
      data: (userInfoModel) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: RichTwoPartText(
            leftPart: userInfoModel.displayName, rightPart: post.message),
      ),
      error: (e, _) => const SmallErrorAnimationView(),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
