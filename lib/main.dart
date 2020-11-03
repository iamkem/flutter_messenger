import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messio_app/blocs/authentication/auth_bloc.dart';
import 'package:messio_app/pages/LoginPage.dart';
import 'Repository/AuthRepository.dart';
import 'pages/ConversationPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final _authRepository = AuthRepository();

  runApp(MultiBlocProvider(providers: [
    BlocProvider<AuthBloc>(create: (context){
      return AuthBloc(_authRepository)..add(AppLaunchAuthEvent());
    })
  ],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     return MaterialApp(
        title: 'Messio',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BlocBuilder<AuthBloc, AuthState >(builder: (context, state){
          if (state is AuthSuccess) {
            return ConversationPage();
          } else if (state is AuthFail) {
            return LoginPage();
          } else if (state is AuthProgress) {
            return const CircularProgressIndicator();
          } else {
            return const Text("data");
          }
        },
        ),

        debugShowCheckedModeBanner: false,
      );
  }
}
