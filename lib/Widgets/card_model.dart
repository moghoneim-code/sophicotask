import 'package:flutter/material.dart';
import 'package:sophicotask/models/user_model.dart';

class CardModel extends StatelessWidget {

  const CardModel(this._userModel);

  @required
  final UserModel _userModel;

  /// made it simple with just year calculation to save time
  int getage(int birth) {
    int now = DateTime.now().year;
    int age = now - birth;
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,

       // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListTile(
              title: Text(
                _userModel.name,
                style: TextStyle(color: Colors.indigo),
              ),
              trailing: Icon(
                Icons.person,
                color: Colors.indigo,
              ),
            ),
          ),
          Image.network(_userModel.avatar,
              width: 125.0,
              height: 125.0,
              alignment: Alignment.center,
              fit: BoxFit.fill),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListTile(
              title: Text(
                _userModel.country,
              ),
              trailing: Icon(
                Icons.flag,
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListTile(
                  title: Text(
                    _userModel.email,
                  ),
                  trailing: Icon(
                    Icons.email,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListTile(
                  title: Text('${getage(_userModel.dob.year).toString()} years'),
                  trailing: Icon(
                    Icons.timelapse_outlined,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
