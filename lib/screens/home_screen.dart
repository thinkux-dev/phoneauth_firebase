import 'package:flutter/material.dart';
import 'package:phoneauth_firebase/provider/auth_provider.dart';
import 'package:phoneauth_firebase/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthUserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("FlutterPhone Auth", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              authProvider.userSignOut().then((value) =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const WelcomeScreen())));
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.purple,
              backgroundImage: NetworkImage(authProvider.userModel.profilePic),
              radius: 50,
            ),
            const SizedBox(height: 20),
            Text(authProvider.userModel.name),
            Text(authProvider.userModel.phoneNumber),
            Text(authProvider.userModel.email),
            Text(authProvider.userModel.bio),
          ],
        ),
      ),
    );
  }
}
