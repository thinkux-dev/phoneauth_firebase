import 'dart:ui';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:phoneauth_firebase/provider/auth_provider.dart';
import 'package:phoneauth_firebase/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController phoneController = TextEditingController();
  Country selectedCountry = Country(
    phoneCode: "234",
    countryCode: "NG",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "Nigeria",
    example: "Nigeria",
    displayName: "Nigeria",
    displayNameNoCountryCode: "NG",
    e164Key: "",
  );

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
      TextPosition(offset: phoneController.text.length)
    );

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // -- Image Container
                Container(
                  width: 200,
                  height: 200,
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.purple.shade500),
                  // -- Image
                  child: Image.asset("assets/images/verification-technologies.png"),
                ),
                const SizedBox(height: 20),

                // -- Title Header
                const Text("Register",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text(
                  "Add your phone number. We'll send you a verification code",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // -- Phone Number Input field
                TextFormField(
                  cursorColor: Colors.purple,
                  controller: phoneController,
                  onChanged: (value) {
                    setState(() {
                      phoneController.text = value;
                    });
                  },
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      hintText: "Enter phone number",
                      hintStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey.shade600),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black12),
                      ),
                      prefixIcon: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              countryListTheme: CountryListThemeData(
                                bottomSheetHeight: 550
                              ),
                              onSelect: (value) {
                                setState(() {
                                  selectedCountry = value;
                                });
                              }
                            );
                          },
                          child: Text(
                            '${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    suffixIcon: phoneController.text.length > 9
                        ? Container(
                            width: 20,
                            height: 20,
                            margin: const EdgeInsets.all(10.0),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                            child: const Icon(
                              Icons.done,
                              color: Colors.white,
                              size: 20,
                            ),
                          )
                        : null
                  ),
                ),
                const SizedBox(height: 20),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    text: "Login",
                    onPressed: () => sendPhoneNumber(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sendPhoneNumber() {
    //+2341234567890
    final authProvider = Provider.of<AuthUserProvider>(context, listen: false);
    String phoneNumber = phoneController.text.trim();
    authProvider.signInWithPhone(context, "+${selectedCountry.phoneCode}$phoneNumber");
  }
}
