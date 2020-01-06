import 'package:cached_network_image/cached_network_image.dart';
import 'package:college_events/model/firebass_scoped_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:path_provider/path_provider.dart';

class EventsDetails extends StatelessWidget {
  Map event;
  EventsDetails(this.event);
  @override
  Widget build(BuildContext context) {
    var size = (2 + event['details'].length / 22) * 20;
    return ScopedModelDescendant<FirebaseHandler>(
      builder: (context, child, model) {
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  actions: <Widget>[
                    event['author'] == model.currentUser.email
                  ? IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        model.db
                            .collection('events')
                            .document(event['title'])
                            .delete();
                        Navigator.pop(context);
                      },
                    )
                  : SizedBox(
                      width: 5,
                      height: 5,
                    )
                  ],
                  pinned: true,
                  floating: false,
                  expandedHeight: 250,
                  flexibleSpace: FlexibleSpaceBar(
                    //title: Text('Event',style: TextStyle(color: Colors.black),),
                    background: event['files'].length == 0
                        ? Image.asset('assets/images/valley.jpg')
                        : CachedNetworkImage(
                            imageUrl: event['files'][0],
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                    //Image.network(event['files'][0], fit: BoxFit.fill),
                  ),
                )
              ];
            },
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10),
                ),
                Container(
                    child: Column(children: <Widget>[
                  Text(
                    event['title'],
                    style: TextStyle(fontSize: 38),
                  ),
                  Text(
                    'Posted by:${event['author']}',
                    style: TextStyle(fontSize: 12),
                  ),
                ])),
                Padding(
                  padding: EdgeInsets.all(2),
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                            height: size > 500
                                ? size
                                : MediaQuery.of(context).size.height * 0.7,
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              event['details'],
                              style: TextStyle(fontSize: 20),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Download Files',
            child: Icon(Icons.arrow_downward),
            onPressed: () async {
              var i = 1;
              var dio = Dio();
              String t;
              try {
                var f2 = 'event-${event['title']}-$i-${DateTime.now().day}.jpg';
                var dir = getExternalStorageDirectory().then((res)async{
                  t=res.path;
                  t=t+'/../../../../Download';
                  Response response = await dio.download(
                    '${event['files'][0]}', '$t/$f2');
                  print(t);
                });
                //var dir = '/storage/emulated/0/Evento';

                
                showDialog(
                    context: context,
                    builder: (context) {
                      if (event['files'].length == 0) {
                        return AlertDialog(
                          content: Text('No files Attached'),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            )
                          ],
                        );
                      }
                      return AlertDialog(
                        title: Text('File(s) Downloading, Press Ok '),
                        content: Image.asset('assets/images/load.gif'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    });
              } catch (e) {
                print(e);
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text('No files Attached '),
                        actions: <Widget>[
                          FlatButton(
                            child: SelectableText('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    });
              }
            },
          ),
        );
      },
    );
  }
}
