import 'package:firebase_core/firebase_core.dart';

const String userDataProjectName = "user_data";
const String votingProjectName = "voting";
const String miscDataProjectName = "misc_data";
const String placeDataProjectName = "place_data";
const String individualPlaceDataProjectName = "individual_place_data";

class FirebaseProjectConfig {
  final String name;
  final String apiKey;
  final String appId;
  final String messagingSenderId;
  final String projectId;
  final String storageBucket;
  final String? authDomain;
  final String? databaseURL;
  final String? measurementId;

  const FirebaseProjectConfig({
    required this.name,
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
    required this.projectId,
    required this.storageBucket,
    this.authDomain,
    this.databaseURL,
    this.measurementId,
  });

  FirebaseOptions toFirebaseOptions() {
    return FirebaseOptions(
      apiKey: apiKey,
      appId: appId,
      messagingSenderId: messagingSenderId,
      projectId: projectId,
      storageBucket: storageBucket,
      authDomain: authDomain,
      databaseURL: databaseURL,
      measurementId: measurementId,
    );
  }
}

class MultiFirebaseConfig {
  static const FirebaseProjectConfig userDataProject = FirebaseProjectConfig(
    name: userDataProjectName,
    apiKey: "AIzaSyCGvkL-kLslL8vEigoPZh0MpXVYy69-ZiY",
    authDomain: "chhoti-jagah-main.firebaseapp.com",
    projectId: "chhoti-jagah-main",
    storageBucket: "chhoti-jagah-main.firebasestorage.app",
    messagingSenderId: "5283873903",
    appId: "1:5283873903:android:40351662b84b3ddee4b99a",
    measurementId: "G-EQY25E7VR9",
  );

  static const FirebaseProjectConfig votingProject = FirebaseProjectConfig(
    name: votingProjectName,
    apiKey: "AIzaSyCjkeZRQNQsZ9UBIxjEbViSMrqx-gzHydk",
    authDomain: "chhoti-jagah-upvote-downvote.firebaseapp.com",
    projectId: "chhoti-jagah-upvote-downvote",
    storageBucket: "chhoti-jagah-upvote-downvote.firebasestorage.app",
    messagingSenderId: "481460134993",
    appId: "1:481460134993:web:a308b7eeededcfa5f78470",
  );

  static const FirebaseProjectConfig miscDataProject = FirebaseProjectConfig(
    name: miscDataProjectName,
    apiKey: "AIzaSyDdtzahI5K_H8pumocJb6waUZXgsHFLWPk",
    authDomain: "chhoti-jagah-misc.firebaseapp.com",
    projectId: "chhoti-jagah-misc",
    storageBucket: "chhoti-jagah-misc.firebasestorage.app",
    messagingSenderId: "495990580783",
    appId: "1:495990580783:web:da5252d6e53097cc2e88da",
  );

  static const FirebaseProjectConfig placeDataProject = FirebaseProjectConfig(
    name: placeDataProjectName,
    apiKey: "AIzaSyAso3-kkAC6WO70FF04c7g-YWmpsmffJHc",
    authDomain: "chhoti-jagah-data.firebaseapp.com",
    projectId: "chhoti-jagah-data",
    storageBucket: "chhoti-jagah-data.firebasestorage.app",
    messagingSenderId: "716484167434",
    appId: "1:716484167434:web:a1404be0032ac6dbbfdcf3",
  );

  static const FirebaseProjectConfig individualPlaceDataProject =
      FirebaseProjectConfig(
        name: individualPlaceDataProjectName,
        apiKey: "AIzaSyBOUF3u4GDP8y06XdMTpKLUg-zjRe8KZRs",
        authDomain: "chhoti-jagah-individual-data.firebaseapp.com",
        projectId: "chhoti-jagah-individual-data",
        storageBucket: "chhoti-jagah-individual-data.firebasestorage.app",
        messagingSenderId: "716115242668",
        appId: "1:716115242668:web:50a8e38ab5f24e9e9a3909",
      );

  static List<FirebaseProjectConfig> getAllProjects() {
    return [
      userDataProject,
      votingProject,
      miscDataProject,
      placeDataProject,
      individualPlaceDataProject,
    ];
  }

  static FirebaseProjectConfig? getProjectByName(String name) {
    return getAllProjects().firstWhere(
      (project) => project.name == name,
      orElse: () => throw ArgumentError('Project with name "$name" not found'),
    );
  }
}
