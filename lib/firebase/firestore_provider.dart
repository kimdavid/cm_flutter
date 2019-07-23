import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cm_flutter/models/team.dart';
import 'package:uuid/uuid.dart';

class FirestoreProvider {
  Firestore firestore = Firestore.instance;
    Uuid uuid = Uuid();

  Stream<QuerySnapshot> getTeams() {
    return firestore.collection('teams').snapshots();
  }

  Stream<DocumentSnapshot> getTeam(String teamId) {
    return firestore.collection('teams').document(teamId).snapshots();
  }

  void updateTeam(String teamId, Map<String, dynamic> data) {
    firestore.collection('teams').document(teamId).updateData(data);
  }

  void deleteTeam(String teamId) {
    firestore.collection('teams').document(teamId).delete();
  }

  String addTeam(String name) {
    CollectionReference teamsRef = firestore.collection('teams');
    String id = uuid.v4();
    teamsRef.document(id).setData({
      'name': name,
      'bio': 'Make your bio special!',
      'id': id,
    });
    return id;
  }


  void addTeams() {
    CollectionReference teamsRef = firestore.collection('teams');
    
    String id = uuid.v4();
    teamsRef.document(id).setData({
      'name': 'Project D',
      'bio': 'The Best team in the world.',
      'id': id,
    });
    id = uuid.v4();
    teamsRef.document(id).setData({
      'name': 'Wannabes',
      'bio': 'We\'re the bees!!',
      'id': id,
    });
    id = uuid.v4();
    teamsRef.document(id).setData({
      'name': 'THEM',
      'bio': 'The worst team in the world.',
      'id': id,
    });
    id = uuid.v4();
    teamsRef.document(id).setData({
      'name': 'ARC', 
      'bio': 'A Rhythm Company',
      'id': id,
    });
    id = uuid.v4();
    teamsRef.document(id).setData({
      'name': 'Stuy Legacy',
      'bio': 'We\'re the youngins',
      'id': id,
    });
  }
}