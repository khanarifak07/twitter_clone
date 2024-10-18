import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter_clone/services/auth/auth_provider.dart';
import 'package:twitter_clone/components/my_textfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late AuthProviders authprovider;
  bool registerPage = false;

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    authprovider = Provider.of<AuthProviders>(context);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              top: 150,
              bottom: MediaQuery.of(context).viewInsets.bottom + 50,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Icon(
                      Icons.lock_open_rounded,
                      size: 80,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 40),
                    Text(
                      "Welcome back you've been missed",
                      style:
                          TextStyle(color: colorScheme.primary, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    if (registerPage)
                      MyTextField(
                        colorScheme: colorScheme,
                        text: 'Enter Name',
                        controller: authprovider.nameCtrl,
                      ),
                    MyTextField(
                      colorScheme: colorScheme,
                      text: 'Enter Email',
                      controller: authprovider.emailCtrl,
                    ),
                    MyTextField(
                      colorScheme: colorScheme,
                      text: 'Enter Password',
                      controller: authprovider.passCtrl,
                      isObsecure: true,
                      isPassField: true,
                    ),
                    if (registerPage)
                      MyTextField(
                        colorScheme: colorScheme,
                        text: 'Confirm Password',
                        controller: authprovider.confirmPassCtrl,
                        isObsecure: true,
                        isPassField: true,
                      ),
                    if (!registerPage)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {},
                              child: Text(
                                "Forget Password?",
                                style: TextStyle(
                                    fontSize: 16, color: colorScheme.primary),
                              )),
                        ],
                      ),
                    // const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          registerPage
                              ? authprovider.registerUser(
                                  authprovider.nameCtrl.text,
                                  authprovider.emailCtrl.text,
                                  authprovider.passCtrl.text,
                                  authprovider.confirmPassCtrl.text,
                                  context,
                                )
                              : authprovider.login(
                                  authprovider.emailCtrl.text,
                                  authprovider.passCtrl.text,
                                  context,
                                );
                        },
                        minWidth: double.maxFinite,
                        height: 60,
                        color: authprovider.isLoading
                            ? colorScheme.secondary
                            : colorScheme.primary,
                        child: authprovider.isLoading
                            ? const CircularProgressIndicator()
                            : Text(
                                registerPage ? "Register" : "Login",
                                style: TextStyle(
                                  color: colorScheme.secondary,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: registerPage
                                ? "Already a member?\t"
                                : "Not a member?\t",
                            style: TextStyle(
                                color: colorScheme.primary, fontSize: 16),
                          ),
                          TextSpan(
                            text: registerPage ? 'Login now' : 'Register now',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                setState(() {
                                  registerPage = !registerPage;
                                });
                              },
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
