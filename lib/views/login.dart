import 'package:flutter/material.dart';
import 'package:college_events/util/text_styles.dart';

class login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text('Terna',style: title,),
            // CircleAvatar(
            //   radius: 100.0,
            //   backgroundColor: Colors.red,
            // ),
            Image.asset('assets/images/anim.gif',),
            GestureDetector(
              onTap: (){},
              child: Container(
                height: MediaQuery.of(context).size.height*0.08,
                width: MediaQuery.of(context).size.width*0.8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20.0),

                ),
                child: Center(child: Text('Login',style:high ,)),
              ),
            )

          ],
        ),
      ),
      
    );
  }
}