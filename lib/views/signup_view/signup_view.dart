import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mediapp/consts/consts.dart';
import 'package:mediapp/controlers/auth_controller.dart';
import 'package:mediapp/views/home_view/home.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key, String? verificationid});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  var isDoctor = false;
  final _formKey = GlobalKey<FormState>();

  // EmailAuthController emailAuthController = Get.put(EmailAuthController());
  bool isEmailSent = false;

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Please fill in the details to sign up.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: AppStrings.fullname,
                        labelText: "Name",
                        border: const OutlineInputBorder(),
                      ),
                      controller: controller.fullnameController,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        if (RegExp(r'[0-9]').hasMatch(value)) {
                          return 'Name cannot contain numbers';
                        }
                        if (RegExp(r'[^a-zA-Z\s]').hasMatch(value)) {
                          return 'Name cannot contain special characters';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: AppStrings.email,
                        labelText: "Email",
                        border: const OutlineInputBorder(),
                      ),
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        hintText: AppStrings.password,
                        labelText: "Password",
                        border: const OutlineInputBorder(),
                      ),
                      controller: controller.passwordController,
                      obscureText: true,
                      validator: (password) => password!.length < 6
                          ? 'Password should be at least 6 characters'
                          : null,
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: controller.genderController.text.isEmpty
                          ? null
                          : controller.genderController.text,
                      onChanged: (newValue) {
                        setState(() {
                          controller.genderController.text = newValue!;
                        });
                      },
                      items: <String>['Male', 'Female', 'Other']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        hintText: 'Select your gender',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select your gender';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        hintText: 'Enter your age',
                        border: OutlineInputBorder(),
                      ),
                      controller: controller.ageController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your age';
                        }
                        if (value.length > 2) {
                          return 'Please enter a valid age';
                        }
                        int age = int.tryParse(value)!;
                        if (age <= 0) {
                          return 'Age must be greater than zero';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        hintText: "Enter your mobile number",
                        labelText: "Mobile Number",
                        border: OutlineInputBorder(),
                      ),
                      controller: controller.signinmobileController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter Phone number';
                        }
                        RegExp indianPhoneNumberRegExp =
                            RegExp(r'^[7-9]\d{9}$');
                        if (!indianPhoneNumberRegExp.hasMatch(value)) {
                          return 'Please enter a valid 10 digit Indian phone number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "Sign up as a doctor",
                          style: TextStyle(fontSize: 16),
                        ),
                        Switch(
                          value: isDoctor,
                          onChanged: (newValue) {
                            setState(() {
                              isDoctor = newValue;
                            });
                          },
                        ),
                      ],
                    ),
                    Visibility(
                      visible: isDoctor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 20),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                              hintText: "About",
                              labelText: "About",
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.text,
                            controller: controller.aboutController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter about';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                              hintText: "Category",
                              labelText: "Category",
                              border: OutlineInputBorder(),
                            ),
                            controller: controller.categoryController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Category';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                              hintText: "Address",
                              labelText: "Address",
                              border: OutlineInputBorder(),
                            ),
                            controller: controller.addressController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter address';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: const InputDecoration(
                              hintText: "Timing",
                              labelText: "Timing",
                              border: OutlineInputBorder(),
                            ),
                            controller: controller.timingController,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await controller.signupUser(isDoctor);
                          if (controller.userCredential != null) {
                            Get.offAll(() => const Home());
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Please enter email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter valid email';
    }
    return null;
  }
}
