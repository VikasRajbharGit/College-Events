import 'package:college_events/model/firebass_scoped_model.dart';
import 'package:college_events/views/home.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../views/tabs/create_screens/dropdownitems.dart';

class register extends StatefulWidget {
  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var info = {
    'branch':'',
    'college_id': '',
    'div': '',
    'name': '',
    'roll_no': '',
    'year': '',
    'authority': '',
    'subscriptions': []
  };
  var branchVal = departments[0];
  var yearVal = year[0];
  var divVal = feDivs[0];
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<FirebaseHandler>(
      builder: (context, child, model) {
        model.getUser();
        return Scaffold(
          appBar: AppBar(
            title: Text('Register'),
          ),
          body: Center(
            child: Form(
                key: formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.85,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                border: Border.all(
                                  color: Colors.black38,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextFormField(
                                validator: (val) =>
                                    val.length < 1 ? 'Can not be empty' : null,
                                decoration: InputDecoration(
                                    hintText: 'Name', border: InputBorder.none),
                                onChanged: (val) {
                                  info['name'] = val;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Colors.white10,
                                  border: Border.all(
                                    color: Colors.black38,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(20)),
                              child: TextFormField(
                                textCapitalization: TextCapitalization.characters,
                                validator: (val) =>
                                    val.length < 1 ? 'Can not be empty' : null,
                                decoration: InputDecoration(
                                  hintText: 'College ID(eg. TU3F..)',
                                  border: InputBorder.none,
                                ),
                                onChanged: (val) {
                                  info['college_id'] = val;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            Text('Year:'),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: year.length,
                              itemBuilder: (_, index) {
                                return RadioListTile(
                                    title: Text(year[index]),
                                    groupValue: yearVal,
                                    value: year[index],
                                    onChanged: (val) {
                                      setState(() {
                                        yearVal = val;
                                      });
                                    });
                              },
                            ),

                            Padding(
                              padding: EdgeInsets.all(20),
                            ),
                            Text('Branch:'),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemCount: departments.length,
                              itemBuilder: (_, index) {
                                return RadioListTile(
                                    title: Text(departments[index]),
                                    groupValue: branchVal,
                                    value: departments[index],
                                    onChanged: (val) {
                                      setState(() {
                                        branchVal = val;
                                      });
                                    });
                              },
                            ),

                            // RadioListTile(
                            //     title: Text('Computer'),
                            //     groupValue: branchVal,
                            //     value: 'Comps',
                            //     onChanged: (val) {
                            //       setState(() {
                            //         branchVal = val;
                            //       });
                            //     }),
                            // RadioListTile(
                            //     title: Text('Electronics'),
                            //     groupValue: branchVal,
                            //     value: 'ElX',
                            //     onChanged: (val) {
                            //       setState(() {
                            //         branchVal = val;
                            //       });
                            //     }),
                            // RadioListTile(
                            //     title: Text('Technical'),
                            //     groupValue: branchVal,
                            //     value: 'technical',
                            //     onChanged: (val) {
                            //       setState(() {
                            //         branchVal = val;
                            //       });
                            //     }),
                            Padding(
                              padding: EdgeInsets.all(20),
                            ),
                            Text('Division:'),
                            div(),

                            // Container(
                            //   padding: EdgeInsets.all(5),
                            //   decoration: BoxDecoration(
                            //     color: Colors.white10,
                            //     border: Border.all(
                            //       color: Colors.black38,
                            //       width: 1,
                            //     ),
                            //     borderRadius: BorderRadius.circular(20),
                            //   ),
                            //   child: TextFormField(
                            //     validator: (val) =>
                            //         val.length < 1 ? 'Can not be empty' : null,
                            //     decoration: InputDecoration(
                            //         hintText: 'Division',
                            //         border: InputBorder.none),
                            //     onChanged: (val) {
                            //       info['div'] = val;
                            //     },
                            //   ),
                            // ),
                            Padding(
                              padding: EdgeInsets.all(20),
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                border: Border.all(
                                  color: Colors.black38,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                validator: (val) =>
                                    val.length < 1 ? 'Can not be empty' : null,
                                decoration: InputDecoration(
                                    hintText: 'Roll No.',
                                    border: InputBorder.none),
                                onChanged: (val) {
                                  info['roll_no'] = val;
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                            ),

                            Align(
                              alignment: Alignment.centerLeft,
                              child: Material(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).accentColor,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  child: InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      focusColor: Colors.red,
                                      splashColor: Colors.redAccent,
                                      child: Center(
                                          child: Text(
                                        'Submit',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                      onTap: () {
                                        if (yearVal != year[0] &&
                                            branchVal != departments[0]) {
                                          divVal = 'A';
                                        }
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) {
                                              return Center(
                                                child: CircularProgressIndicator()
                                                
                                              );
                                            });
                                        info['branch']=branchVal;
                                        info['year'] = yearVal;
                                        info['div'] = divVal;
                                        info['authority'] = 'student';
                                        var t = generateTopic();

                                        info['subscriptions'] = ['notice', t];
                                        model.db
                                            .collection('users')
                                            .document(model.currentUser.uid)
                                            .collection('info')
                                            .document('info')
                                            .setData(info)
                                            .then((val) {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      home()));
                                          model.saveDeviceToken(
                                              info['subscriptions']);
                                        });
                                      }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        );
      },
    );
  }

  div() {
    if (yearVal == 'FE') {
      return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: feDivs.length,
        itemBuilder: (context, index) {
          return RadioListTile(
              title: Text(feDivs[index]),
              groupValue: divVal,
              value: feDivs[index],
              onChanged: (val) {
                setState(() {
                  divVal = val;
                });
              });
        },
      );
    } else if (branchVal == departments[0]) {
      return ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: compDivs.length,
        itemBuilder: (context, index) {
          return RadioListTile(
              title: Text(compDivs[index]),
              groupValue: divVal,
              value: compDivs[index],
              onChanged: (val) {
                setState(() {
                  divVal = val;
                });
              });
        },
      );
    } else {
      return Text('Only for FE and Computer');
    }
  }

  generateTopic() {
    if (yearVal == year[0]) {
      return 'notice-$divVal';
    } else if (branchVal == departments[0]) {
      return 'notice-$yearVal-$divVal';
    } else {
      return 'notice-$yearVal-$branchVal';
    }
  }
}
