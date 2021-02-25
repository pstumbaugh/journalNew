import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // for http request
import './journal.dart';

class Journals with ChangeNotifier {
  List<Journal> _journals = [];

  // getter for journal
  List<Journal> get journals {
    return [..._journals];
  }

  //Comparing ID of each courses with id of the arguments
  Journal findById(String id) {
    return _journals.firstWhere((jn) => jn.id == id);
  }

  Future<void> retrieveJournalData() async {
    const url = 'https://cs492-journal.firebaseio.com/journals.json';

    try {
      final response = await http.get(url); // get for fetching from DB
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData == null) {
        return;
      }
      final List<Journal> loadedJournals = [];

      extractedData.forEach((journalId, journalData) {
        loadedJournals.add(Journal(
          id: journalId,
          title: journalData['title'],
          body: journalData['body'],
          rating: journalData['rating'],
          createdAt: journalData['createdAt'],
        ));
      });
      _journals = loadedJournals;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addJournal(Journal journal) async {
    const url = 'https://cs492-journal.firebaseio.com/journals.json';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': journal.title,
          'body': journal.body,
          'rating': journal.rating,
          'createdAt': journal.createdAt,
        }),
      );

      final newJournal = Journal(
        title: journal.title,
        body: journal.body,
        rating: journal.rating,
        createdAt: journal.createdAt,
        id: json.decode(response.body)['name'],
      );
      _journals.add(newJournal);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
