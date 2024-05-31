// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth_firebase/provider/auth_provider.dart';
import 'package:phoneauth_firebase/screens/home_screen.dart';
import 'package:phoneauth_firebase/screens/user_information_screen.dart';
import 'package:phoneauth_firebase/utils/utils.dart';
import 'package:phoneauth_firebase/widgets/custom_button.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;

  const OtpScreen({super.key, required this.verificationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String? otpCode;

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthUserProvider>(context, listen: true).isLoading;

    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              )
            : SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 30),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: const Icon(Icons.arrow_back),
                          ),
                        ),

                        // -- Image Container
                        Container(
                          width: 200,
                          height: 200,
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.purple.shade500),
                          child: Image.asset(
                              "assets/images/smartphone-verification-process.png"),
                        ),
                        const SizedBox(height: 20),

                        // -- Title Header
                        const Text("Verification",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        const Text(
                          "Enter the OTP sent to your phone number",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black38),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // -- Pin Input
                        Pinput(
                          length: 6,
                          showCursor: true,
                          obscureText: false,
                          defaultPinTheme: PinTheme(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.purple.shade200,
                                  )),
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              )),
                          onCompleted: (value) {
                            setState(() {
                              otpCode = value;
                            });
                          },
                        ),
                        const SizedBox(height: 25),

                        // -- Custom Button
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: CustomButton(
                            text: "Verify",
                            onPressed: () {
                              if (otpCode != null) {
                                verifyOtp(context, otpCode!);
                              } else {
                                showSnackBar(context,
                                    'Please input the correct sent otp code');
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        // -- Text
                        const Column(
                          children: [
                            Text(
                              "Didn't receive any code?",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black38),
                            ),
                            SizedBox(height: 15),

                            // -- Text Button
                            Text(
                              "Resend New Code",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  // -- Verify OTP
  void verifyOtp(BuildContext context, String userOtp) {
    final authProvider = Provider.of<AuthUserProvider>(context, listen: false);
    authProvider.verifyOtp(
      context: context,
      verificationId: widget.verificationId,
      userOtp: userOtp,
      onSuccess: () {
        // checking if user exists in db
        authProvider.checkExistingUser().then((value) async {
          if (value == true) {
            // user exists in our app
            authProvider.getDataFromFireStore().then(
                  (value) => authProvider.saveUserDataToSP().then(
                        (value) => authProvider.setSignIn().then(
                              (value) => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen()),
                                  (route) => false),
                            ),
                      ),
                );
          } else {
            // new user
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const UserInformationScreen()),
                (route) => false);
          }
        });
      },
    );
  }
}
