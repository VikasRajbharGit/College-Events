import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_events/model/firebass_scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'home.dart';

class concession extends StatefulWidget {
  @override
  _concessionState createState() => _concessionState();
}

class _concessionState extends State<concession> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var details = {
    'name': '',
    'id': '',
    'branch': '',
    'year': '',
    'div': '',
    'roll_no': '',
    'renewal': DateTime.now(),
    'vch_no': '',
    'ticket_no': '',
    'class': 'Second Class',
    'from': '',
    'to': '',
    'duration': '1 Month',
    'phone': '',
    'uid': '',
    'date_of_application': DateTime.now()
  };
  var clas = 'Second Class';
  var duration = '1 Month';
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<FirebaseHandler>(
        builder: (context, child, model) {
      //model.getprofile(true);
      details['name'] = model.profile['name'];
      details['id'] = model.profile['college_id'];
      details['div'] = model.profile['div'];
      details['roll_no'] = model.profile['roll_no'];
      details['branch'] = model.profile['branch'];
      details['year'] = model.profile['year'];
      details['uid'] = model.profile['uid'];
      details['renewal'] = DateTime.now()
          .add(Duration(days: duration == '3 Months' ? 85 : 25))
          .toIso8601String();

      return Scaffold(
        appBar: AppBar(title: Text('RailWay Concession')),
        body: Center(
            child: Form(
          key: formKey,
          child: railway(model),
        )),
      );
    });
  }

  railway(model) {
    //print('-------->>>>>>>>>>>${model.profile['renewal']}');
    if (model.profile['branch'] != 'COMP') {
      return Center(
        child: Column(
          children: <Widget>[
            Icon(Icons.info),
            Container(
                child: Text(
                    'Right Now, This Feature is only available for Computer Department!!')),
          ],
        ),
      );
    }
    if (model.profile['banned']) {
      return Center(
        child: Column(
          children: <Widget>[
            Icon(Icons.info),
            Container(
                child: Text(
                    'You have been banned beacuase of malicious Entry, Contact Admin!!')),
          ],
        ),
      );
    } else if (model.profile['renewal'] == null ||
        (DateTime.now().isAfter(DateTime.tryParse(model.profile['renewal'])))) {
      return Center(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.95,
          child: SingleChildScrollView(
              child: Column(
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
                  enabled: false,
                  readOnly: true,
                  initialValue: details['name'],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
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
                  enabled: true,
                  initialValue: details['id'],
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
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
                  enabled: false,
                  readOnly: true,
                  initialValue:
                      '${details['year']}-${details['branch']} / ${details['div']}-${details['roll_no']}',
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
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
                  validator: (val) =>
                      val.length < 1 ? 'Can not be empty' : null,
                  decoration: InputDecoration(
                      hintText: 'Vch No.', border: InputBorder.none),
                  onChanged: (val) {
                    details['vch_no'] = val;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
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
                  validator: (val) =>
                      val.length < 1 ? 'Can not be empty' : null,
                  decoration: InputDecoration(
                      hintText: 'Ticket No.', border: InputBorder.none),
                  onChanged: (val) {
                    details['ticket_no'] = val;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
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
                  validator: (val) =>
                      val.length < 1 ? 'Can not be empty' : null,
                  decoration: InputDecoration(
                      hintText: 'From', border: InputBorder.none),
                  onChanged: (val) {
                    details['from'] = val;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
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
                  validator: (val) =>
                      val.length < 1 ? 'Can not be empty' : null,
                  decoration:
                      InputDecoration(hintText: 'To', border: InputBorder.none),
                  onChanged: (val) {
                    details['to'] = val;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              Text('Class: '),
              RadioListTile(
                  title: Text('First'),
                  groupValue: clas,
                  value: 'First Class',
                  onChanged: (val) {
                    details['class'] = val;
                    setState(() {
                      clas = val;
                    });
                  }),
              RadioListTile(
                  title: Text('Second'),
                  groupValue: clas,
                  value: 'Second Class',
                  onChanged: (val) {
                    details['class'] = val;
                    setState(() {
                      clas = val;
                    });
                  }),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              Text('Duration: '),
              RadioListTile(
                  title: Text('Monthly'),
                  groupValue: duration,
                  value: '1 Month',
                  onChanged: (val) {
                    details['duration'] = val;
                    setState(() {
                      duration = val;
                    });
                  }),
              RadioListTile(
                  title: Text('Quarterly'),
                  groupValue: duration,
                  value: '3 Months',
                  onChanged: (val) {
                    details['duration'] = val;
                    setState(() {
                      duration = val;
                    });
                  }),
              Padding(
                padding: EdgeInsets.all(10),
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
                  validator: (val) =>
                      val.length < 1 ? 'Can not be empty' : null,
                  decoration: InputDecoration(
                      hintText: 'Mobile No.', border: InputBorder.none),
                  onChanged: (val) {
                    details['phone'] = val;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  //type: MaterialType.transparency,
                  color: Theme.of(context).accentColor,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.05,
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
                        if (formKey.currentState.validate()) {
                          details['date_of_application'] = DateTime.now();
                          model.handleSubmit(details, 'concession');

                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => home()));
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          )),
        ),
      );
    } else {
      return Center(
        child: Column(
          children: <Widget>[
            Icon(Icons.info),
            Container(
                child: Text(
                    'You have already applied for concession, please apply after ${DateFormat.yMMMMd("en_US").format(DateTime.tryParse(model.profile['renewal']))}')),
          ],
        ),
      );
    }
  }
}
