import * as functions from 'firebase-functions';

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//  response.send("Hello from Firebase!");
// });
//import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

//const db = admin.firestore();
const fcm = admin.messaging();

export const sendToTopic = functions.firestore
  .document('notices/{noticeId}')
  .onCreate(async snapshot => {
    const noti = snapshot.data();
    console.log('------------>>>>>',noti);

    var audience=noti!.audience;

    const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: `${noti!.title}`,
          body: `${noti!.details} `,
          icon: 'your-icon-url',
          click_action: 'FLUTTER_NOTIFICATION_CLICK' // required only for onResume or onLaunch callbacks
        }
      };

      audience.forEach((audi: any) => {
        console.log(audi);
        return fcm.sendToTopic(audi, payload);
      });
  
      //return fcm.sendToTopic('notification', payload);
      //return fcm.sendToTopic('notification', payload);

      
    });

  //   export const sendToDevice = functions.firestore
  // .document('notices/{noticeId}')
  // .onCreate(async snapshot => {


  //   const notice = snapshot.data();

  //   const querySnapshot = await db
  //     .collection('users')
  //     .doc('v1TiVMq6luOsM6RpsLbM7NiIggz1')
  //     .collection('tokens')
  //     .get();

  //   const tokens = querySnapshot.docs.map(snap => snap.id);

  //   const payload: admin.messaging.MessagingPayload = {
  //     notification: {
  //       title: 'New Order!',
  //       body: `you sold a ${notice!.title} for ${notice!.details}`,
  //       icon: 'your-icon-url',
  //       click_action: 'FLUTTER_NOTIFICATION_CLICK'
  //     }
  //   };

  //   return fcm.sendToDevice(tokens, payload);
  // });
    