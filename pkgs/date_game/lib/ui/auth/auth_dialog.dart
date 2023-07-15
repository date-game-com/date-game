import 'dart:math';

import 'package:date_game/logic/auth/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FauiAuthScreen extends StatefulWidget {
  final VoidCallback onExit;
  final String firebaseApiKey;
  final bool startWithRegistration;

  const FauiAuthScreen(
    this.onExit,
    this.firebaseApiKey,
    this.startWithRegistration, {
    super.key,
  });

  @override
  State<FauiAuthScreen> createState() => _FauiAuthScreenState();
}

enum _AuthScreen {
  signIn,
  createAccount,
  forgotPassword,
  verifyEmail,
  resetPassword,
}

class _FauiAuthScreenState extends State<FauiAuthScreen> {
  _AuthScreen _authScreen = _AuthScreen.signIn;
  String? _error;
  String? _email;
  //bool _onExitInvoked = false;
  bool _loading = false;
  FocusNode? _focusNodeCurrent;
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.startWithRegistration) {
      _authScreen = _AuthScreen.createAccount;
    }
  }

  void _switchScreen(_AuthScreen authScreen, String email) {
    setState(() {
      _authScreen = authScreen;
      _error = null;
      _email = email;
    });
  }

  // void afterAuthorized(BuildContext context, FauiUser user) {
  //   FauiAuthState.user = user;
  //   if (!_onExitInvoked) {
  //     _onExitInvoked = true;
  //     widget.onExit();
  //   }
  // }

  @override
  void dispose() {
    _emailNode.dispose();
    _passwordNode.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    // This check takes care of "setState() called after dispose()" exception.
    // This exception is raised because when Enter key is pressed, it calls submit().
    // This causes the Future to complete after the widget has already been disposed.
    // More details can be found at the link:
    // "https://github.com/Norbert515/flutter_villains/issues/8".
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_focusNodeCurrent != null) {
      FocusScope.of(context).requestFocus(_focusNodeCurrent);
      _focusNodeCurrent = null;
    }
    return _AuthFrame(
        title: _screenTitle(),
        content: _getScreen(context),
        onColse: widget.onExit);
  }

  String _screenTitle() {
    switch (_authScreen) {
      case _AuthScreen.signIn:
        return 'Sign In';
      case _AuthScreen.createAccount:
        return 'Create Account';
      case _AuthScreen.forgotPassword:
        return 'Forgot Password';
      case _AuthScreen.verifyEmail:
        return 'Verify Email';
      case _AuthScreen.resetPassword:
        return 'Reset Password';
    }
  }

  Widget _getScreen(BuildContext context) {
    switch (_authScreen) {
      case _AuthScreen.signIn:
        return _buildSignInScreen(context);
      case _AuthScreen.createAccount:
        return _buildCreateAccountScreen(context);
      case _AuthScreen.forgotPassword:
        return _buildForgotPasswordScreen(context, _email!);
      case _AuthScreen.verifyEmail:
        return _buildVerifyEmailScreen(context, _email!);
      case _AuthScreen.resetPassword:
        return _buildResetPasswordScreen(context, _email!);
    }
  }

  static Widget _buildError(BuildContext context, String error) {
    return Text(
      error,
      style: TextStyle(color: Theme.of(context).colorScheme.error),
    );
  }

  _changeFocus(FocusNode current, FocusNode next) {
    // https://stackoverflow.com/questions/56221653/focusnode-why-is-requestfocus-not-working/57104572#57104572
    current.unfocus();
    setState(() => _focusNodeCurrent = next);
  }

  Widget _buildTextBox(
      TextEditingController controller,
      bool hideFieldValue,
      FocusNode currentNode,
      FocusNode nextNode,
      String fieldName,
      Future<Widget> Function() submit) {
    handleKey(RawKeyEvent key) {
      if (key is! RawKeyDownEvent) {
        return;
      }
      setState(() => _error = "");
      if (key.logicalKey == LogicalKeyboardKey.enter) {
        submit();
      }
      if (key.logicalKey == LogicalKeyboardKey.tab) {
        _changeFocus(currentNode, nextNode);
      }
    }

    return RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (key) => handleKey(key),
        child: TextFormField(
          focusNode: currentNode,
          obscureText: hideFieldValue,
          controller: controller,
          autofocus: true,
          onEditingComplete: () => {},
          // it is important to have this handler to catch 'Enter'
          decoration: InputDecoration(
            labelText: fieldName,
          ),
        ));
  }

  Widget _buildCreateAccountScreen(BuildContext context) {
    submit() async {
      try {
        setState(() {
          _loading = true;
        });
        await AuthController.instance.signUp(_emailcontroller.text);
        setState(() {
          _loading = false;
        });

        _switchScreen(_AuthScreen.verifyEmail, _emailcontroller.text);
      } catch (e) {
        setState(() {
          _error = FauiError.exceptionToUiMessage(e);
          _email = _emailcontroller.text;
          _loading = false;
        });
      }
    }

    return Column(children: <Widget>[
      _buildTextBox(_emailcontroller, false, _emailNode, null, 'Email', submit),
      _buildError(context, _error),
      if (_loading == true) _AuthProgress('creating account...'),
      if (_loading == false)
        ElevatedButton(
          child: const Text('Create Account'),
          onPressed: submit,
        ),
      if (_loading == false)
        TextButton(
            child: const Text('Have account? Sign in.'),
            onPressed: () {
              _switchScreen(_AuthScreen.signIn, _emailcontroller.text);
            }),
    ]);
  }

  Widget _buildSignInScreen(BuildContext context) {
    final submit = () async {
      try {
        setState(() {
          _loading = true;
        });
        FauiUser user = await fauiSignInUser(
          apiKey: widget.firebaseApiKey,
          email: _emailcontroller.text,
          password: _passwordcontroller.text,
        );
        setState(() {
          _loading = false;
        });
        afterAuthorized(context, user);
      } catch (e) {
        setState(() {
          _error = FauiError.exceptionToUiMessage(e);
          _email = _emailcontroller.text;
          _loading = false;
        });
      }
    };

    return Column(children: <Widget>[
      _buildTextBox(
          _emailcontroller, false, _emailNode, _passwordNode, 'Email', submit),
      _buildTextBox(
          _passwordcontroller, true, _passwordNode, null, 'Password', submit),
      _buildError(context, _error),
      if (_loading == true) _AuthProgress('signing in...'),
      if (_loading == false)
        RaisedButton(
          child: const Text('Sign In'),
          onPressed: submit,
        ),
      if (_loading == false)
        TextButton(
          child: const Text('Create Account'),
          onPressed: () {
            _switchScreen(_AuthScreen.createAccount, _emailcontroller.text);
          },
        ),
      if (_loading == false)
        TextButton(
          child: const Text('Forgot Password?'),
          onPressed: () {
            _switchScreen(_AuthScreen.forgotPassword, _emailcontroller.text);
          },
        ),
    ]);
  }

  Widget _buildVerifyEmailScreen(BuildContext context, String email) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "Verification link was sent to $email",
          textAlign: TextAlign.center,
        ),
        ElevatedButton(
          child: const Text('Sign In'),
          onPressed: () {
            _switchScreen(_AuthScreen.signIn, email);
          },
        ),
      ],
    );
  }

  Widget _buildResetPasswordScreen(BuildContext context, String email) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          "Link to reset your password was sent to $email",
          textAlign: TextAlign.center,
        ),
        ElevatedButton(
          child: const Text('Sign In'),
          onPressed: () {
            _switchScreen(_AuthScreen.signIn, email);
          },
        ),
      ],
    );
  }

  Widget _buildForgotPasswordScreen(BuildContext context, String email) {
    final submit = () async {
      try {
        setState(() {
          _loading = true;
        });
        await fauiSendResetLink(
          apiKey: widget.firebaseApiKey,
          email: _emailcontroller.text,
        );
        setState(() {
          _loading = false;
        });
        _switchScreen(_AuthScreen.resetPassword, _emailcontroller.text);
      } catch (e) {
        setState(() {
          _error = FauiError.exceptionToUiMessage(e);
          _email = _emailcontroller.text;
          _loading = false;
        });
      }
    };

    return Column(
      children: <Widget>[
        _buildTextBox(
            _emailcontroller, false, _emailNode, null, 'Email', submit),
        _buildError(context, _error),
        if (_loading == true) _AuthProgress('sending password reset link...'),
        if (_loading == false)
          ElevatedButton(
            child: const Text('Send Password Reset Link'),
            onPressed: submit,
          ),
        if (_loading == false)
          TextButton(
            child: const Text('Sign In'),
            onPressed: () {
              _switchScreen(_AuthScreen.signIn, email);
            },
          ),
        if (_loading == false)
          TextButton(
            child: const Text('Create Account'),
            onPressed: () {
              _switchScreen(_AuthScreen.createAccount, email);
            },
          ),
      ],
    );
  }
}

class _AuthProgress extends StatelessWidget {
  final String displayMessage;

  const _AuthProgress(this.displayMessage);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.20,
        width: MediaQuery.of(context).size.width * 0.15,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                displayMessage,
                textAlign: TextAlign.center,
              ),
            ]));
  }
}

class _AuthFrame extends StatelessWidget {
  const _AuthFrame({
    required this.title,
    required this.content,
    required this.onColse,
  });

  final String title;
  final Widget content;
  final VoidCallback onColse;

  @override
  Widget build(BuildContext context) {
    const double boxWidth = 200;
    const double boxHeight = 400;

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double vInsets = max(5, (screenHeight - boxHeight) / 2);
    double hInsets = max(5, (screenWidth - boxWidth) / 2);

    final style = Theme.of(context).textTheme.titleLarge;
    return Scaffold(
        body: Container(
      padding: EdgeInsets.symmetric(vertical: vInsets, horizontal: hInsets),
      width: screenWidth,
      height: screenHeight,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: style?.fontSize,
                  ),
                  onPressed: onColse,
                ),
              ],
            ),
            Text(
              title,
              style: style,
            ),
            content,
          ],
        ),
      ),
    ));
  }
}
