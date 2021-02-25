import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:intl/intl.dart";

import '../screens/welcome_screen.dart';

import '../models/journal.dart';
import '../models/journal_provider.dart';
import '../models/theme_provider.dart';

class CreateJournalScreen extends StatefulWidget {
  static const routeName = '/create-new-journal';

  @override
  _CreateJournalScreen createState() => _CreateJournalScreen();
}

class _CreateJournalScreen extends State<CreateJournalScreen> {
  final _jobNameFocusNode = FocusNode();
  final _bodyFocusNode = FocusNode();
  final _scoreFocusNode = FocusNode();

  final _jobNameController = TextEditingController();
  final _bodyController = TextEditingController();
  final _scoreController = TextEditingController();

  final _score = [1, 2, 3, 4, 5];

  // global key
  final _form = GlobalKey<FormState>();

  // update this edited product when save form
  var _editedJournal = Journal(
    id: null,
    title: '',
    body: '',
    rating: 0,
    createdAt: DateFormat("yyyy/MM/dd").format(DateTime.now()),
  );

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      setState(() {
        _isLoading = true;
      });

      // retrieve major data from FB
      Provider.of<Journals>(context).retrieveJournalData().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    });
    super.initState();
  }

  var currentSelectedValue;
  var _isLoading = false;

  // save form data by using grobal key
  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();

    // error handling for the form value
    if (!isValid) {
      return;
    }

    // only if the form is valid, save the result
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Journals>(context, listen: false)
          .addJournal(_editedJournal);
    } catch (error) {
      await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('An error occured!'),
                content: Text('Some error occured while adding review'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                  ),
                ],
              ));
    }

    setState(() {
      _isLoading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WelcomeScreen(),
      ),
    );

    // pop up message when course successfully added
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('New activity'),
        content: Text('New Journal has been created'),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
            },
          ),
        ],
      ),
    );
    _form.currentState?.reset();
  }

  @override
  void dispose() {
    // avoid momery leaks
    _jobNameFocusNode.dispose();
    _bodyFocusNode.dispose();
    _scoreFocusNode.dispose();

    _jobNameController.dispose();
    _bodyController.dispose();
    _scoreController.dispose();
    super.dispose();
  }

  Widget _displaySubHeader(String subHeader) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10),
          child: Text(
            subHeader,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: themeProvider.getThemeData == lightTheme
                  ? Colors.black
                  : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _createFormField(TextEditingController controller, FocusNode focusNode,
      FocusNode nextFocusNode, String labelText, String formTitle) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.grey,
          ),
          suffixIcon: IconButton(
            icon: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(
                Icons.clear,
                size: 18,
              ),
            ),
            onPressed: () {
              controller.clear();
            },
          ),
          contentPadding: const EdgeInsets.all(8.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: themeProvider.getThemeData == lightTheme
                  ? Colors.black
                  : Colors.white,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        maxLines: 1,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        focusNode: focusNode,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        },
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter a journal name.';
          } else {
            return null; // no error
          }
        },
        onSaved: (value) {
          _editedJournal = Journal(
            id: _editedJournal.id,
            title: formTitle == 'title' ? value : _editedJournal.title,
            body: formTitle == 'body' ? value : _editedJournal.body,
            rating: formTitle == 'rating' ? value : _editedJournal.rating,
            createdAt: _editedJournal.createdAt,
          );
        },
      ),
    );
  }

  Widget _createSaveButton(String title) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: ButtonTheme(
        minWidth: double.infinity,
        child: RaisedButton(
          onPressed: _saveForm,
          child: Text(
            title,
            style: TextStyle(
              color: themeProvider.getThemeData == lightTheme
                  ? Colors.black
                  : Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10.0,
            ),
            side: BorderSide(
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ),
      ),
    );
  }

  Widget _createCancellButton(String title) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: ButtonTheme(
        minWidth: double.infinity,
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');
          },
          child: Text(
            title,
            style: TextStyle(
              color: themeProvider.getThemeData == lightTheme
                  ? Colors.black
                  : Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          color: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10.0,
            ),
            side: BorderSide(
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    const title = 'New Journal Entry';
    const formLabel1 = 'Title';
    const formTitle1 = 'title';
    const formLabel2 = 'Body';
    const formTitle2 = 'body';
    const buttonText = 'Save Journal';
    const buttonText2 = 'Back to home';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            // setting global key in the form
            key: _form,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _createFormField(_jobNameController, _jobNameFocusNode,
                      _bodyFocusNode, formLabel1, formTitle1),
                  _createFormField(_bodyController, _bodyFocusNode,
                      _scoreFocusNode, formLabel2, formTitle2),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: FormField<int>(
                      builder: (FormFieldState<int> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            labelText: 'Journal rating',
                            labelStyle: TextStyle(
                              fontSize: 18,
                            ),
                            errorStyle: TextStyle(
                                color: Colors.redAccent, fontSize: 15.0),
                            hintText: 'Please select rate of journal',
                            contentPadding: const EdgeInsets.all(8.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          isEmpty: currentSelectedValue == '',
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              focusNode: _scoreFocusNode,
                              value: currentSelectedValue,
                              isDense: true,
                              onChanged: (int newValue) {
                                setState(() {
                                  currentSelectedValue = newValue;
                                  state.didChange(newValue);
                                });
                              },
                              items: _score.map((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text(
                                    '$value',
                                    style: TextStyle(
                                      color: themeProvider.getThemeData ==
                                              lightTheme
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                      onSaved: (value) {
                        _editedJournal = Journal(
                          id: _editedJournal.id,
                          title: _editedJournal.title,
                          body: _editedJournal.body,
                          rating: value,
                          createdAt: _editedJournal.createdAt,
                        );
                      },
                    ),
                  ),
                  _createSaveButton(buttonText),
                  _createCancellButton(buttonText2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
