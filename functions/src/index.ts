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

    const payload: admin.messaging.MessagingPayload = {
        notification: {
          title: 'New Puppy!',
          body: `${noti!.title} `,
          //icon: 'your-icon-url',
          click_action: 'FLUTTER_NOTIFICATION_CLICK' // required only for onResume or onLaunch callbacks
        }
      };
  
      return fcm.sendToTopic('notification', payload);
    });
    