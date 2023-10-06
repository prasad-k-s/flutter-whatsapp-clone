import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone/colors.dart';
import 'package:flutter_whatsapp_clone/common/widgets/custom_button.dart';
import 'package:flutter_whatsapp_clone/features/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  String? countryCode;
  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  void pickCountry() {
    showCountryPicker(
      context: context,
      showPhoneCode: true, // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        setState(() {
          countryCode = country.phoneCode;
        });
      },
    );
  }

  final mykey = GlobalKey<FormState>();

  void veriyPhoneNumber() {
    final isValid = mykey.currentState!.validate();
    if (isValid) {
      ref
          .read(authControllerProvider)
          .signinWithPhone(context: context, phoneNumber: '+$countryCode${phoneController.text.trim()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Enter your phone number'),
        backgroundColor: backgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'WhatsApp will need to verify your phone number',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: pickCountry,
                  child: const Text('Pick country'),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(countryCode != null ? '+$countryCode' : ''),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Form(
                        key: mykey,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (countryCode == null) {
                              return 'Please pick a country code';
                            }
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }

                            return null;
                          },
                          controller: phoneController,
                          decoration: const InputDecoration(
                            errorStyle: TextStyle(
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            filled: true,
                            hintText: 'Enter your phone number',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.585,
                ),
                SizedBox(
                  width: 90,
                  child: CustomButton(
                    text: 'Next',
                    onPressed: veriyPhoneNumber,
                    fontsize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
