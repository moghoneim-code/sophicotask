import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sophicotask/Widgets/ProgressDialog.dart';
import 'package:sophicotask/Widgets/card_model.dart';
import 'package:sophicotask/Widgets/tekdibutton.dart';
import 'package:sophicotask/helpers/request_helpers.dart';
import 'package:sophicotask/models/user_model.dart';
import 'package:toast/toast.dart';

class ListingPage extends StatefulWidget {
  const ListingPage({Key key}) : super(key: key);

  @override
  _ListingPageState createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  Future<UserModel> _data;

  @override
  void initState() {
    print(_data);
    super.initState();
  }
  @override
  void dispose() {
    emailcontroller.dispose();
    nameController.dispose();
    super.dispose();
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  String selectedcountry;

  DateTime selectedDate;

  Future<void> _selectDate(
    BuildContext context,
  ) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1990, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('People'),
          backgroundColor: Colors.indigo,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.keyboard_arrow_left),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder<List<UserModel>>(
            future: RequestHelper.getListRequest(),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.done
                  ? snapshot.data.length > 0
                   ///Grid view for displaying incoming data
                      ? StaggeredGridView.countBuilder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.length,
                          crossAxisCount: 1,
                          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          //     crossAxisCount: 1),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              child: CardModel(snapshot.data[index]),
                              onTap: () {
                                setState(() {
                                  selectedDate = snapshot.data[index].dob;
                                  emailcontroller.text =
                                      snapshot.data[index].email;
                                  nameController.text =
                                      snapshot.data[index].name;
                                  selectedcountry =
                                      snapshot.data[index].country;
                                });
                                {
                                  ///show bottom sheet for editing
                                  showModalBottomSheet<void>(
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: MediaQuery.of(context).size.height * 0.75,
                                        color: Colors.white,
                                        child: Center(
                                          child: Column(

                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: TextField(
                                                  controller: nameController,
                                                  keyboardType:
                                                      TextInputType.name,
                                                  decoration: InputDecoration(
                                                      suffixIcon:
                                                          Icon(Icons.person),
                                                      labelText: 'Full Name ',
                                                      labelStyle: TextStyle(
                                                        fontSize: 14.0,
                                                      ),
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 10.0)),
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: TextField(
                                                  controller: emailcontroller,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  decoration: InputDecoration(
                                                      suffixIcon:
                                                          Icon(Icons.email),
                                                      labelText:
                                                          'Email address',
                                                      labelStyle: TextStyle(
                                                        fontSize: 14.0,
                                                      ),
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 10.0)),
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  CountryListPick(
                                                      appBar: AppBar(
                                                        backgroundColor:
                                                            Colors.indigo,
                                                        title: Text(
                                                            'Choose Your Country'),
                                                      ),
                                                      theme: CountryTheme(
                                                        isShowFlag: true,
                                                        isShowTitle: true,
                                                        isShowCode: false,
                                                        isDownIcon: true,
                                                        showEnglishName: true,
                                                      ),
                                                      initialSelection: snapshot
                                                          .data[index].country,
                                                      onChanged:
                                                          (CountryCode code) {
                                                        setState(() {
                                                          selectedcountry =
                                                              code.code;
                                                        });
                                                        print(selectedcountry);
                                                      },
                                                      useUiOverlay: true,
                                                      useSafeArea: false),
                                                  InkWell(
                                                      onTap: () =>
                                                          _selectDate(context),
                                                      child: Text(
                                                        "${snapshot.data[index].dob.toString()}"
                                                            .split(' ')[0],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.indigo,
                                                            fontSize: 16),
                                                      )),
                                                ],
                                              ),
                                              ElevatedButton(
                                                child: const Text('Save'),
                                                onPressed: () async {
                                                  if (nameController
                                                          .text.length <
                                                      3) {
                                                    Toast.show(
                                                        "type a valid name",
                                                        context,
                                                        duration:
                                                            Toast.LENGTH_LONG,
                                                        gravity: Toast.CENTER);
                                                    return;
                                                  }
                                                  if (!emailcontroller.text
                                                      .contains('@')) {
                                                    Toast.show(
                                                        "type a valid mail",
                                                        context,
                                                        duration:
                                                            Toast.LENGTH_LONG,
                                                        gravity: Toast.CENTER);
                                                    return;
                                                  }
                                                  if (selectedDate.day ==
                                                      DateTime.now().day) {
                                                    Toast.show(
                                                        "type a valid date",
                                                        context,
                                                        duration:
                                                            Toast.LENGTH_LONG,
                                                        gravity: Toast.CENTER);
                                                    return;
                                                  }
                                                  showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        ProgressDialog(
                                                      status: 'Please wait',
                                                    ),
                                                  );
                                                  var result = await RequestHelper
                                                      .PatchRequest(
                                                          index + 1,
                                                          nameController.text,
                                                          emailcontroller.text,
                                                          selectedDate
                                                              .toString(),
                                                          selectedcountry,
                                                          Gravatar(
                                                                  emailcontroller
                                                                      .text)
                                                              .imageUrl());
                                                  if (result != null) {
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  } else {
                                                    Toast.show(
                                                        "Failed", context,
                                                        duration:
                                                            Toast.LENGTH_LONG,
                                                        gravity: Toast.CENTER);
                                                    Navigator.pop(context);
                                                  }
                                                },
                                              ),

                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            );
                          },
                          staggeredTileBuilder: (int index) =>
                              StaggeredTile.fit(1),
                          // child: Text(snapshot.data.first.name),
                        )
                      : Center(
                          child: Text('No Available Data'),
                        )
                  : ProgressDialog(
                      status: 'please wait',
                    );
            },
          ),
        ));
  }
}
