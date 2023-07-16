import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../logic/auth/controller.dart';
import '../../../logic/shared/exceptions.dart';

class AuthScreen extends StatefulWidget {
  final VoidCallback? onExit;

  const AuthScreen({
    this.onExit,
    super.key,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

enum _AuthScreen {
  signIn,
  createAccount,
  forgotPassword,
  verifyEmail,
  resetPassword,
}

class _AuthScreenState extends State<AuthScreen> {
  _AuthScreen _authScreen = _AuthScreen.signIn;
  String? _error;
  String? _email;
  //bool _onExitInvoked = false;
  bool _loading = false;
  FocusNode? _focusNodeCurrent;
  final FocusNode _emailNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (AuthController.instance.state.value == AuthState.wantToSignUp) {
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
      onClose: widget.onExit,
    );
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

  static Widget _mayBeBuildError(BuildContext context, String? error) {
    if (error == null) {
      return Container();
    }
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

  Widget _buildTextBox({
    required TextEditingController controller,
    required bool hideFieldValue,
    required FocusNode currentNode,
    required FocusNode? nextNode,
    required String fieldName,
    required Future<void> Function() submit,
  }) {
    handleKey(RawKeyEvent key) {
      if (key is! RawKeyDownEvent) {
        return;
      }
      setState(() => _error = null);
      if (key.logicalKey == LogicalKeyboardKey.enter) {
        submit();
      }
      if (key.logicalKey == LogicalKeyboardKey.tab && nextNode != null) {
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
      ),
    );
  }

  Widget _buildCreateAccountScreen(BuildContext context) {
    submit() async {
      try {
        setState(() {
          _loading = true;
        });
        await AuthController.instance.signUp(_emailController.text);
        setState(() {
          _loading = false;
        });

        _switchScreen(_AuthScreen.verifyEmail, _emailController.text);
      } catch (e) {
        setState(() {
          _error = exceptionToUiMessage(e);
          _email = _emailController.text;
          _loading = false;
        });
      }
    }

    return Column(
      children: <Widget>[
        _buildTextBox(
          controller: _emailController,
          hideFieldValue: false,
          currentNode: _emailNode,
          nextNode: null,
          fieldName: 'Email',
          submit: submit,
        ),
        _mayBeBuildError(context, _error),
        if (_loading == true) const _AuthProgress('creating account...'),
        if (_loading == false)
          ElevatedButton(
            onPressed: submit,
            child: const Text('Create Account'),
          ),
        if (_loading == false)
          TextButton(
            child: const Text('Have account? Sign in.'),
            onPressed: () {
              _switchScreen(_AuthScreen.signIn, _emailController.text);
            },
          ),
      ],
    );
  }

  Widget _buildSignInScreen(BuildContext context) {
    submit() async {
      try {
        setState(() {
          _loading = true;
        });
        await AuthController.instance.signIn(
          email: _emailController.text,
          password: _passwordcontroller.text,
        );
        setState(() {
          _loading = false;
        });
      } catch (e) {
        setState(() {
          _error = exceptionToUiMessage(e);
          _email = _emailController.text;
          _loading = false;
        });
      }
    }

    return Column(
      children: <Widget>[
        _buildTextBox(
          controller: _emailController,
          hideFieldValue: false,
          currentNode: _emailNode,
          nextNode: _passwordNode,
          fieldName: 'Email',
          submit: submit,
        ),
        _buildTextBox(
          controller: _passwordcontroller,
          hideFieldValue: true,
          currentNode: _passwordNode,
          nextNode: null,
          fieldName: 'Password',
          submit: submit,
        ),
        _mayBeBuildError(context, _error),
        if (_loading == true) const _AuthProgress('signing in...'),
        if (_loading == false)
          ElevatedButton(
            onPressed: submit,
            child: const Text('Sign In'),
          ),
        if (_loading == false)
          TextButton(
            child: const Text('Create Account'),
            onPressed: () {
              _switchScreen(_AuthScreen.createAccount, _emailController.text);
            },
          ),
        if (_loading == false)
          TextButton(
            child: const Text('Forgot Password?'),
            onPressed: () {
              _switchScreen(_AuthScreen.forgotPassword, _emailController.text);
            },
          ),
      ],
    );
  }

  Widget _buildVerifyEmailScreen(BuildContext context, String email) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Verification link was sent to $email',
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
          'Link to reset your password was sent to $email',
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
    submit() async {
      try {
        setState(() {
          _loading = true;
        });
        await AuthController.instance.resetPassword(_emailController.text);
        setState(() {
          _loading = false;
        });
        _switchScreen(_AuthScreen.resetPassword, _emailController.text);
      } catch (e) {
        setState(() {
          _error = exceptionToUiMessage(e);
          _email = _emailController.text;
          _loading = false;
        });
      }
    }

    return Column(
      children: <Widget>[
        _buildTextBox(
          controller: _emailController,
          hideFieldValue: false,
          currentNode: _emailNode,
          nextNode: null,
          fieldName: 'Email',
          submit: submit,
        ),
        _mayBeBuildError(context, _error),
        if (_loading == true)
          const _AuthProgress('sending password reset link...'),
        if (_loading == false)
          ElevatedButton(
            onPressed: submit,
            child: const Text('Send Password Reset Link'),
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
        ],
      ),
    );
  }
}

class _AuthFrame extends StatelessWidget {
  const _AuthFrame({
    required this.title,
    required this.content,
    required this.onClose,
  });

  final String title;
  final Widget content;
  final VoidCallback? onClose;

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
                    onPressed: onClose,
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
      ),
    );
  }
}
