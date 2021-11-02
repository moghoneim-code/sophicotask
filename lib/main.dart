import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:sophicotask/Widgets/tekdibutton.dart';
import 'package:sophicotask/pages/listingpage.dart';
import 'package:sophicotask/helpers/request_helpers.dart';
import 'package:toast/toast.dart';

import 'Widgets/ProgressDialog.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sophico Task',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(title: 'Sophico Task Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String selectedcountry = "EG";
  String initialcountry = "+20";
  DateTime selectedDate = DateTime.now();

  String _email;
  Gravatar _gravatar;

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1990, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  /// for showing snack bar
  void showSnackBar(String title) {
    final snackbar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 15),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  @override
  void initState() {
    /// default values to use in displaying
    _email = "Task@gmail.com";
    _gravatar = Gravatar(_email);
    super.initState();
  }
 ///function for reset
  void returndefault() {
    emailController.clear();
    nameController.clear();
    setState(() {
      initialcountry = "+20";
      selectedDate = DateTime.now();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_gravatar != null)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      /// Example only for Displaying
                      child: Column(
                        children: [
                          Text("Email: $_email"),
                          Image.network(_gravatar.imageUrl()),
                          ListTile(
                            title: Text("profileUrl: ${_gravatar.profileUrl()}"),
                            subtitle: Text(
                                "the avatar will be chosen randomly as per this image accordingly to the mail"),
                          )
                        ],
                      ),
                    ),
                  ),
                /// Form for Data Entry
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.person),
                      labelText: 'Full Name ',
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0)),
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.email),
                      labelText: 'Email address',
                      labelStyle: TextStyle(
                        fontSize: 14.0,
                      ),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 10.0)),
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Select Country',
                          style: TextStyle(fontSize: 18.0)),
                    ),
                    CountryListPick(
                        appBar: AppBar(
                          backgroundColor: Colors.indigo,
                          title: Text('Choose Your Country'),
                        ),
                        theme: CountryTheme(
                          isShowFlag: true,
                          isShowTitle: true,
                          isShowCode: false,
                          isDownIcon: true,
                          showEnglishName: true,
                        ),
                        initialSelection: initialcountry,
                        onChanged: (CountryCode code) {
                          setState(() {
                            selectedcountry = code.code;
                          });
                          print(selectedcountry);
                        },
                        useUiOverlay: true,
                        useSafeArea: false),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Select Birth date",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 12.0,
                ),
                InkWell(
                    onTap: () => _selectDate(context),
                    child: Text(
                      "${selectedDate.toLocal()}".split(' ')[0],
                      style: TextStyle(color: Colors.indigo, fontSize: 16),
                    )),
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: TekdiButton(
                    title: 'Save',
                    color: Colors.indigo,
                    onPressed: () async {
                      if (nameController.text.length < 3) {
                        showSnackBar('Please provide a valid fullname');
                        return;
                      }
                      if (!emailController.text.contains('@')) {
                        showSnackBar('Please provide a valid email address');
                        return;
                      }
                      if (selectedDate.day == DateTime.now().day) {
                        showSnackBar('please Choose a valid Birthdate');
                        return;
                      }
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) => ProgressDialog(
                          status: 'Please wait',
                        ),
                      );
                      var result = await RequestHelper.PostRequest(
                          nameController.text,
                          emailController.text,
                          selectedDate.toString(),
                          selectedcountry,
                          Gravatar(emailController.text).imageUrl());
                      if (result != null) {
                        Toast.show("User Created With a Random Avatar", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        returndefault();
                        Navigator.pop(context);
                      } else {
                        Toast.show("Failed", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        Navigator.pop(context);

                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      ///floating button navigating to The Listing page
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => ListingPage()));
        },
        tooltip: ' List',
        child: Icon(
          Icons.list,
          color: Colors.white,
        ),
      ),
    );

  }
}
