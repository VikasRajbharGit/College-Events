import 'package:college_events/model/firebass_scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:college_events/util/text_styles.dart';
import 'package:scoped_model/scoped_model.dart';

class login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<FirebaseHandler>(
      builder: (context, child, model) {
        return Scaffold(
          body: Container(
            // decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   stops: [0.1, 0.5, 0.7, 0.9],
            //   colors: [
            //     Colors.orange[50],
            //     Colors.orange[200],
            //     Colors.pink[200],
            //     Colors.pink[400],
            //   ],
            // )),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Terna',
                    style: title,
                  ),
                  Stack(
                    children: <Widget>[
                      Positioned(
                          left: MediaQuery.of(context).size.width * 0.27,
                          top: MediaQuery.of(context).size.height * 0.17,
                          child: Text('Evento',
                              style:
                                  TextStyle(fontSize: 40, color: Colors.pink))),
                      Image.asset(
                        'assets/images/anim.gif',
                        width: MediaQuery.of(context).size.width*0.9,
                        height: MediaQuery.of(context).size.height*0.4,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      model.gSignIn(context);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                          child: Text(
                        'Login',
                        style: high,
                      )),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
