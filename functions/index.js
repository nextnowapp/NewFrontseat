const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { debug } = require("firebase-functions/logger");
const FieldValue = require('firebase-admin').firestore.FieldValue;

admin.initializeApp(functions.config().firebase);

exports.checkUser = functions.https.onCall(async (data, context) => {
    var phone = data.phone;
    var phoneNumber = phone.toString();
    return admin.auth().getUserByPhoneNumber(phoneNumber).then(function (userRecord) {
        // See the UserRecord reference doc for the contents of userRecord.
        return {
            result: 'success'
        };
    }).catch(error => {
        return {
            result: 'fail'
        };
    });
});

exports.checkUserById = functions.https.onCall(async (data, context) => {
    var id = data.nid;
    var nid = id.toString();
    return admin.auth().getUserByEmail(nid).then(function (userRecord) {
        return {
            result: 'success'
        }

    }).catch(error => {
        console.log(error);
        return {
            result: 'fail'
        };
    });
});



//function to verify user on create user
exports.verifyNewUser = functions.auth.user().onCreate(async (user) => {
    // let path2 = "users/" + user.uid;
    // return admin.firestore().doc(path2).set({
    //     "uid": user.uid,
    //     "profile": user.photoURL == undefined ? "http://saskolhmg.com/images/studentprofile.png" : userRecord.photoURL,
    //     "name": user.displayName,
    //     "role": user.customClaims.role,
    //     "school_url": user.customClaims.schoolUrl,
    //     "chatRoomRecords": [],
    //     "status": "Offline",
    //     "device_token": "",
    // });
    admin.auth().updateUser(user.uid, {
        emailVerified: true,
        disabled: false
    }).then(function (userRecord) {
        // See the UserRecord reference doc for the contents of userRecord.
        let path2 = "users/" + userRecord.uid;
        admin.firestore().doc(path2).set({
            "uid": userRecord.uid,
            "profile": userRecord.photoURL == undefined ? "http://saskolhmg.com/images/studentprofile.png" : userRecord.photoURL,
            "name": userRecord.displayName,
            "role": userRecord.customClaims.role,
            "school_url": userRecord.customClaims.schoolUrl,
            "chatRoomRecords": [],
            "status": "Offline",
            "device_token": "",
        });
        console.log('Successfully updated user', userRecord.uid);
    }).catch(function (error) {
        console.log('Error updating user:', error);
        admin.firestore().collection('cloudFunctionError').add({
            "error": error,
            "user": user.uid,
            "userName": user.displayName,
            "userRole": user.customClaims.role,
            "userSchoolUrl": user.customClaims.schoolUrl,
            "time": new Date().toString()
        });
    });
});


exports.setNewMpin = functions.runWith({ minInstances: 1 }).https.onCall((data, context) => {
    if (!context.auth) {
        return function (data, context) {
            return { message: 'auth-required', code: 401 };
        }
    }

    // do your things..
    const uid = context.auth.uid;
    const pin = data.mPin;
    const mPin = pin.toString();

    return admin.auth().updateUser(uid, {
        password: mPin,
        emailVerified: true,
    }).then(function (userRecord) {
        return { message: 'success', code: 500 };

    });

});


exports.newDayForm = functions.firestore.document('healthQuiz/{schoolId}/{collectionId}/{uId}').onCreate(async (snap, context) => {
    const docId = context.params.schoolId;

    await admin.firestore().doc('healthQuiz/' + docId).set({
        locked: false,
        totalSubmissions: 0,
    });
});

exports.incrementSubmission = functions.firestore.document('healthQuiz/{schoolId}/{collectionId}/{uId}').onCreate(async (snap, context) => {
    const docId = context.params.schoolId;
    //use distributed counter to increment total submissions
    await admin.firestore().doc('healthQuiz/' + docId).set({
        totalSubmissions: FieldValue.increment(1)
    }, { merge: true });

});

//decrement submission when a submission is deleted
exports.decrementSubmission = functions.firestore.document('healthQuiz/{schoolId}/{collectionId}/{uId}').onDelete(async (snap, context) => {
    const docId = context.params.schoolId;
    //use distributed counter to increment total submissions
    await admin.firestore().doc('healthQuiz/' + docId).update({
        totalSubmissions: 0
    }, { merge: true });
});
