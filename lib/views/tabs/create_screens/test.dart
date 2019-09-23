import 'package:college_events/model/firebass_scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dropdownitems.dart';
import 'new_notice.dart';

class test extends StatefulWidget {
  @override
  _testState createState() => _testState();
}

class _testState extends State<test> {
  var yearChecks = [];
  var departmentsVal = [];
  var depChecks = [];
  var feDivChecks = [];
  var compsDivChecks = [];
  var divs;

  var feList = [];
  var yearList = [];
  var departmentList = [];

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var i = 0; i < year.length; i++) {
      yearChecks.add(false);
    }
    for (var i = 0; i < departments.length; i++) {
      depChecks.add(false);
    }
    for (var i = 0; i < feDivs.length; i++) {
      feDivChecks.add(false);
    }
    for (var i = 0; i < compDivs.length; i++) {
      compsDivChecks.add(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // showDivisions(divList, context, resList, checkList) {
    //   StatefulBuilder();
    // }

    return ScopedModelDescendant<FirebaseHandler>(
      builder: (context, child, model) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Select Audience'),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Select Years:',
                style: TextStyle(fontSize: 25),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: year.length, //year.length,
                  itemBuilder: (_, index) {
                    return year[index] == 'FE'
                        ? ListTile(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Select Divisions'),
                                      content: Center(
                                        child: ListView.builder(
                                          itemCount: feDivs.length,
                                          itemBuilder: (context, index) {
                                            return CheckboxListTile(
                                              title: Text(feDivs[index]),
                                              value: feDivChecks[index],
                                              onChanged: (val) {
                                                setState(() {
                                                  feDivChecks[index] = val;
                                                  val
                                                      ? feList
                                                          .add(feDivs[index])
                                                      : feList.remove(
                                                          feDivs[index]);
                                                });
                                                print(feList);
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Done'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            print(feDivChecks);
                                          },
                                        )
                                      ],
                                    );
                                  });
                            },
                            title: Text('FE'),
                            trailing: Icon(Icons.indeterminate_check_box,
                                color: Colors.red),
                          )
                        : CheckboxListTile(
                            title: Text(year[index]),
                            value: yearChecks[index],
                            onChanged: (val) {
                              //print(val);
                              setState(() {
                                yearChecks[index] = val;

                                val
                                    ? yearList.add(year[index])
                                    : yearList.remove(year[index]);
                              });
                              print(yearList);
                            },
                          );
                  },
                ),
              ),
              Text(
                'Select Departments:',
                style: TextStyle(fontSize: 25),
              ),
              Expanded(
                child: Center(
                  child: yearList.length == 0
                      ? Text('Select Year(s) First')
                      : Column(
                          children: <Widget>[
                            Expanded(
                              child: ListView.builder(
                                itemCount: departments.length,
                                itemBuilder: (_, index) {
                                  return departments[index] == 'COMP'
                                      ? ListTile(
                                          title: Text(
                                            'Computer',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          trailing: Icon(
                                            Icons.indeterminate_check_box,
                                            color: Colors.red,
                                          ),
                                          onTap: () {
                                            //var alert =
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Select Divisions'),
                                                    content: Center(
                                                      child: ListView.builder(
                                                        itemCount:
                                                            compDivs.length,
                                                        itemBuilder: (_, ind) {
                                                          return CheckboxListTile(
                                                            title: Text(
                                                                compDivs[ind]),
                                                            value:
                                                                compsDivChecks[
                                                                    ind],
                                                            onChanged: (val) {
                                                              setState(() {
                                                                compsDivChecks[
                                                                    ind] = val;
                                                                val
                                                                    ? departmentList.add(
                                                                        compDivs[
                                                                            ind])
                                                                    : departmentList
                                                                        .remove(
                                                                            compDivs[ind]);
                                                              });
                                                              print(
                                                                  departmentList);
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        child: Text('Done'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          print(compsDivChecks);
                                                        },
                                                      )
                                                    ],
                                                  );
                                                });
                                          },
                                        )
                                      : CheckboxListTile(
                                          title: Text(departments[index]),
                                          value: depChecks[index],
                                          onChanged: (val) {
                                            if (departments[index] ==
                                                    'Computer' &&
                                                val) {
                                              setState(() {
                                                //showDivisions(compDivs, context,departmentList,compsDivChecks);
                                              });
                                            } else {
                                              setState(() {
                                                depChecks[index] = val;
                                                val == true
                                                    ? departmentList
                                                        .add(departments[index])
                                                    : departmentList.remove(
                                                        departments[index]);
                                              });
                                              print(departmentList);
                                            }
                                          },
                                        );
                                },
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              FlatButton(
                child: Row(
                  //mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Next'),
                    Icon(Icons.arrow_forward_ios)
                  ],
                ),
                onPressed: () {
                  model.uploadToStorage(context, _scaffoldKey, model.fToUp);
                },
              )
            ],
          ),
        );
      },
    );
  }
}
