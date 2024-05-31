import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth_firebase/provider/auth_provider.dart';
import 'package:phoneauth_firebase/screens/home_screen.dart';
import 'package:phoneauth_firebase/screens/register_screen.dart';
import 'package:phoneauth_firebase/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthUserProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // -- Image
                const Image(
                    image: AssetImage("assets/images/guide-mobile.png"),
                    height: 300),
                const SizedBox(height: 20),

                // -- Title Header
                const Text("Let's get started",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text(
                  "Never a better time than now to start.",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38),
                ),
                const SizedBox(height: 20),

                // --Custom Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    text: "Get started",
                    onPressed: () async {
                      if(authProvider.isSignedIn == true){
                        // when true, then fetch shared preference data
                        await authProvider.getDataFromSP().whenComplete(() =>
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen())));
                      } else {
                        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => const RegisterScreen()));
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
