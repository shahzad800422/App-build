import 'package:cpod_server/cpod_server.dart';
import 'package:cpodpractice/authService.dart';
import 'package:cpodpractice/contentService.dart';
import 'package:cpodpractice/types.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _password;
  String _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Connect with Info')),
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                onSaved: (value) => _email = value.trim(),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email Address'),
              ),
              TextFormField(
                onSaved: (value) => _password = value.trim(),
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              SizedBox(height: 20.0),
              RaisedButton(
                child: Text('Connect me now'),
                onPressed: () async {
                  print('login');
                  final form = _formKey.currentState;
                  form.save();
                  if (form.validate()) {
                    try {
                      print('helo');
                      Usr result =
                          await Provider.of<AuthService>(context, listen: false)
                              .login(
                                  email: _email,
                                  password: _password,
                                  onPracticeSetOwnerDiff: () {
                                    print('we should delete the practiceset');
                                  
                                    context
                                        .read<ContentService>()
                                        .erasePracticeSet()
                                        .then((value) {
                                      print('practice set erased');
                                      return null;
                                    });
                                  });
                      if (result == null) {
                        throw Exception(
                            "Either email address or password is not correct");
                      } else {
                        print('got in');
                        print(result);
                        
                        Provider.of<CpodServer>(context, listen: false).apiKey =
                            result.apiKey;

                        Navigator.pop(context);
                      }
                    } on SocketException catch (e) {
                      print('no internet');
                      _buildErrorDialog(context, 'No Internet?');
                    } on Exception catch (e) {
                      _buildErrorDialog(context, e.toString());
                    } catch (e) {
                      _buildErrorDialog(context, e.toString());
                    }
                  } else
                    print('not yet');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mybody(BuildContext context) {
    /*
    return Center(
      child: RaisedButton(
        child: Text(
          'Go back to last page',
          style: TextStyle(fontSize: 24),
        ),
        onPressed: () {
          _goBackToFirstScreen(context);
        },
      ),
    );*/
  }

  void _goBackToFirstScreen(BuildContext context) {
    Navigator.pop(context);
  }
}

Future _buildErrorDialog(BuildContext context, _message) {
  return showDialog(
    builder: (context) {
      return AlertDialog(
        title: Text('Error Message'),
        content: Text(_message),
        actions: <Widget>[
          FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      );
    },
    context: context,
  );
}
