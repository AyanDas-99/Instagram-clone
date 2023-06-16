import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/state/auth/providers/auth_state_provider.dart';
import 'package:instagram_clone/state/auth/providers/is_logged_in_provider.dart';
import 'package:instagram_clone/state/providers/is_loading_provider.dart';
import 'package:instagram_clone/views/components/animations/data_not_found_animation_view.dart';
import 'package:instagram_clone/views/components/animations/empty_content_with_text_animation_view.dart';
import 'package:instagram_clone/views/components/animations/empty_contents_animation_view.dart';
import 'package:instagram_clone/views/components/animations/error_animation_view.dart';
import 'package:instagram_clone/views/components/animations/loading_animation_view.dart';
import 'package:instagram_clone/views/components/animations/lottie_animation_view.dart';
import 'package:instagram_clone/views/components/animations/small_error_animation_view.dart';
import 'package:instagram_clone/views/components/loading/loading_screen.dart';
import 'firebase_options.dart';
import 'views/login/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          primarySwatch: Colors.blueGrey,
          indicatorColor: Colors.blueGrey),
      home: Consumer(
        builder: (context, ref, child) {
          // Taking care of showing loading screen
          ref.listen<bool>(isLoadingProvider, (_, isLoading) {
            if (isLoading) {
              LoadingScreen.instance().show(context: context);
            } else {
              LoadingScreen.instance().hide();
            }
          });

          final isLoggedIn = ref.watch(isLoggedInProvider);
          if (isLoggedIn) {
            return const Home();
          }
          return const LoginView();
        },
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const DataNotFoundAnimationView();
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('This is the title'),
    //   ),
    //   body: Consumer(
    //       builder: (buildcontext, ref, child) => TextButton(
    //           onPressed: () {
    //             ref.read(authStateProvider.notifier).logOut();
    //           },
    //           child: const Text('Log out'))),
    // );
  }
}
