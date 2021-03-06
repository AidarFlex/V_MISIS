import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vk_example/bloc/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vk_example/models/theme_model.dart';
import 'package:vk_example/page/auth_page.dart';
import 'package:vk_example/page/home_page.dart';

class RegisterPage extends StatefulWidget {
  static const String id = '/register_page';
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.colorTheme,
      appBar: AppBar(
        backgroundColor: ColorTheme.appBarColor,
        elevation: 0,
        leading: const Icon(
          Icons.arrow_back,
          color: ColorTheme.firstTextColor,
        ),
      ),
      body: _RegisterWidget(),
    );
  }
}

class _RegisterWidget extends StatefulWidget {
  const _RegisterWidget({Key? key}) : super(key: key);

  @override
  State<_RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<_RegisterWidget> {
  final _formKey = GlobalKey<FormState>();
  late String _email;
  late String _username;
  late String _password;

  late final FocusNode _passwordFocusNode;
  late final FocusNode _usernameFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    _usernameFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _usernameFocusNode.dispose();

    super.dispose();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    context
        .read<AuthCubit>()
        .singUp(email: _email, username: _username, password: _password);
  }

  @override
  Widget build(BuildContext context) {
    final circulareShape = MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));
    var headerTextStyle = const TextStyle(
        fontSize: 14,
        color: ColorTheme.thirdColor,
        fontWeight: FontWeight.w300);
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (prevState, currState) {
        if (currState is AuthSingedUp) {
          Navigator.of(context).pushReplacementNamed(HomePage.id);
        }

        if (currState is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(seconds: 2),
              content: Text(currState.message)));
        }
      },
      builder: (context, state) {
        if (State is AuthLoading) {
          return Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  color: ColorTheme.appBarColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '???????????????????? ??????????????',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          child: const Text(
                            '?????????? ?????????????? ?????????? ?????????? ?????? ??????????, ???????? ???? ?????????????? ???????????????????? ?? ????????.',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                              color: ColorTheme.thirdColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Email',
                          ),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_usernameFocusNode);
                          },
                          onSaved: (value) => _email = value!.trim(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '?????? ???? ?? ?????? ????';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          focusNode: _usernameFocusNode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: 'Username',
                          ),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          },
                          onSaved: (value) => _username = value!.trim(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '?????? ???? ?? ?????? ????';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          focusNode: _passwordFocusNode,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            labelText: '????????????',
                          ),
                          onFieldSubmitted: (_) {
                            _submit(context);
                          },
                          onSaved: (value) => _password = value!.trim(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '?????? ???? ?? ?????? ????';
                            }
                            if (value.length < 5) {
                              return '?????? ???? ?? ?????? ????';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        SizedBox(height: 10),
                        // Row(
                        //   children: [
                        //     DropdownButton(items: null),
                        //     DropdownButton(items: null),
                        //     DropdownButton(items: null),
                        //   ],
                        // )
                        SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _submit(context);
                              },
                              child: const Text('????????'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    ColorTheme.buttonColor),
                                foregroundColor: MaterialStateProperty.all(
                                    ColorTheme.appBarColor),
                                shape: circulareShape,
                              ),
                            )),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(AuthPage.id);
                            },
                            child: Text('??????????'),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  ColorTheme.appBarColor),
                              foregroundColor: MaterialStateProperty.all(
                                  ColorTheme.buttonColor),
                              shape: circulareShape,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RichText(
                            text: TextSpan(
                          children: [
                            TextSpan(
                                text: '?????? ?????????????????????????????????????',
                                style: headerTextStyle),
                            TextSpan(
                                text: '??????????',
                                style: TextStyle(
                                  color: ColorTheme.firstTextColor,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                ),
                                recognizer: TapGestureRecognizer()),
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          '????????????????????  English  all languages ??',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: ColorTheme.thirdColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
