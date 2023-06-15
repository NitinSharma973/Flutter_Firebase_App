// ignore_for_file: prefer_const_constructors, unused_field, non_constant_identifier_names, prefer_final_fields, avoid_print

import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({super.key});

  @override
  State<SettingsForm> createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  String _currentName = 'User';
  String _CurrentSugars = '0';
  int _currentStrength = 100;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user!.uid!).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;

            return Form(
              key: _formKey,
              child: Column(children: <Widget>[
                Text(
                  'update your brew setttings.',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  initialValue: userData!.name,
                  decoration:
                      textInputDecoration.copyWith(hintText: 'Enter Items'),
                  validator: (val) =>
                      val!.isEmpty ? 'please enter a name' : null,
                  onChanged: (val) => setState(() => {_currentName = val}),
                ),
                SizedBox(
                  height: 20.0,
                ),
                DropdownButtonFormField(
                  value: _CurrentSugars ?? userData.sugars,
                  decoration: textInputDecoration.copyWith(
                      hintText: 'Enter Number of Items'),
                  items: sugars.map((sugar) {
                    return DropdownMenuItem(
                      value: sugar,
                      child: Text('$sugar sugars'),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() {
                    _CurrentSugars = val!;
                  }),
                ),
                Slider(
                  value: (_currentStrength ?? userData.strength).toDouble(),
                  activeColor:
                      Colors.red[_currentStrength ?? userData.strength],
                  inactiveColor:
                      Colors.brown[_currentStrength ?? userData.strength],
                  min: 100.0,
                  max: 900.0,
                  divisions: 8,
                  onChanged: (val) => setState(() {
                    _currentStrength = val.round();
                  }),
                ),
                ElevatedButton(
                  child: Text(
                    'update',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await DatabaseService(uid: user.uid!).updateUserData(
                        _CurrentSugars ?? userData.sugars,
                        _currentName ?? userData.name,
                        _currentStrength ?? userData.strength,
                      );
                      Navigator.pop(context);
                    }
                  },
                )
              ]),
            );
          } else {
            return Loading();
          }
        });
  }
}
