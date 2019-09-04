import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farmsmart_flutter/model/entities/EntityCollectionInterface.dart';
import 'package:farmsmart_flutter/model/entities/ProfileEntity.dart';
import 'package:farmsmart_flutter/model/repositories/FirestoreList.dart';
import 'package:farmsmart_flutter/model/repositories/profile/ProfileRepositoryInterface.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'DocumentToProfileEntityTransformer.dart';
import 'ProfileEntityToDocumentTransformer.dart';

class _Fields {
  static const collectionName = "fs_users";
  static const profiles = "profiles";
  static const currentProfile = "currentProfile";
  static const separator = "/";
}

String _identify(ProfileEntity entity) {
  return entity.uri;
}

class FirebaseProfileRepository extends FireStoreList<ProfileEntity>
    implements ProfileRepositoryInterface {
  final FirebaseAuth _auth;
  final _currentProfileController = StreamController<ProfileEntity>.broadcast();

  Future<FirebaseUser> _user;
  FirebaseProfileRepository(
    Firestore firestore,
    FirebaseAuth auth,
  )   : this._auth = auth,
        super(
          firestore,
          ProfileEntityToDocumentTransformer(),
          DocumentToProfileEntityTransformer(),
          null,
          _identify,
        ) {
    super.path = profilesCollectionPath;
    init();
  }

  init() {
    _user = _auth.currentUser().then((user) {
      return user;
    });
    _auth.onAuthStateChanged.listen((user) {
      _user = Future.value(user);
    });
  }

  @override
  Future<List<ProfileEntity>> getCollection(
      EntityCollection<ProfileEntity> collection) {
    return collection.getEntities();
  }

  @override
  Future<ProfileEntity> getCurrent() {
    return _user.then((user) {
      if (user != null) {
        return firestore.document(_userPath(user)).get().then((document) {
          if (document.data != null) {
            final profileURI = document.data[_Fields.currentProfile];
            if (profileURI != null) {
              return firestore.document(profileURI).get().then((document) {
                final profile =
                    fromFirestoreTransformer.transform(from: document);
                _currentProfileController.sink.add(profile);
                return profile;
              });
            }
          }
          return null;
        });
      }
      return null;
    });
  }

  @override
  Future<ProfileEntity> getSingle(String uri) {
    // TODO: implement getSingle
    return null;
  }

  @override
  Stream<ProfileEntity> observeSingle(String uri) {
    // TODO: implement observe
    return null;
  }

  @override
  Stream<ProfileEntity> observeCurrent() {
    return _currentProfileController.stream;
  }

  @override
  Future<bool> switchTo(ProfileEntity profile) {
    return _user.then((user) {
      final id = (profile != null) ? profile.uri : null;
      final data = {_Fields.currentProfile: id};
      return firestore.document(_userPath(user)).setData(data).then((result) {
        _currentProfileController.sink.add(profile);
        return true;
      });
    }, onError: (error) {
      return false;
    });
  }

  String _profilePath(FirebaseUser user, String profileID) {
    return _userPath(user) +
        _Fields.separator +
        _Fields.profiles +
        _Fields.separator +
        profileID;
  }

  String _userPath(FirebaseUser user) {
    return _Fields.collectionName + _Fields.separator + user.uid;
  }

  Future<String> profilesCollectionPath() {
    return _user.then((user) {
      return _userPath(user) + _Fields.separator + _Fields.profiles;
    });
  }

  void deinit() {
    _currentProfileController.sink.close();
    _currentProfileController.close();
  }
}
