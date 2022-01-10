import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// What is provider?
// A wrapper around InheritedWidget to make them easier to use and more reusable.
// 1. By using provider instead of manually writing InheritedWidget, you get:
// 2. simplified allocation/disposal of resources
// 3. lazy-loading
// 4. a largely reduced boilerplate over making a new class every time
// 5. devtools friendly
// 6. increased scalability for classes with a listening mechanism that grows exponentially in
// complexity (such as ChangeNotifier, which is O(N²) for dispatching notifications).

// dependencies:
//   provider: ^4.3.3

// Page 1 and 2 seems to be same here but both pages are independent of each other.
// In this example we're not passing data to children widgets in the tree but we are
// lifting state so that both parent and child have access to data, which gets easy with provider.

// In this example we'll see a widget updating itself even it is a stateless widget. All because of
// provider. Provider updates a widget by removing the stateless widget from the widget tree and
// inserts a new one at the same location in the widget tree.

// Try changing data on page1 and see changes on page2 and then try changing data on page2 and see
// changes on page1

void main() => runApp(MyApp());

class LocalUser with ChangeNotifier {
  String _name;

  String get name => _name;

  void setName(String name) {
    _name = name;
    notifyListeners();
  }
}

String validateFormField(String text) => (text == null || text.isEmpty) ? 'This is a required field' : null;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocalUser(),
      child: MaterialApp(
        title: 'Provider Example',
        theme: ThemeData.light().copyWith(
          primaryColor: Colors.yellow.shade700,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.yellow.shade800,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              borderSide: BorderSide(
                color: Colors.yellow.shade800,
                width: 2.0,
              ),
            ),
          ),
        ),
        home: Page1(),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void saveForm() {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
  }

  void navigateToOtherPage(BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (context) => Page2()));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 1'),
      ),
      body: Builder(
        builder: (context) => Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter anything you want'
                      ),
                      onSaved: Provider.of<LocalUser>(context, listen: false).setName,
                      validator: validateFormField,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    RaisedButton(
                      child: Text('Save Data'),
                      onPressed: () => saveForm(),
                    ),
                    RaisedButton(
                      child: Text('Navigate to Page 2'),
                      onPressed: () => navigateToOtherPage(context),
                    ),
                  ],
                ),
              ),
              Text(
                Provider.of<LocalUser>(context).name != null ? 'Your Data: ${Provider.of<LocalUser>(context).name}' : '',
              ),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void saveForm() {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
  }

  void navigateToOtherPage(BuildContext context) => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 2'),
        automaticallyImplyLeading: false,
      ),
      body: Builder(
        builder: (context) => Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Enter anything you want'
                      ),
                      onSaved: Provider.of<LocalUser>(context, listen: false).setName,
                      validator: validateFormField,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    RaisedButton(
                      child: Text('Save Data'),
                      onPressed: () => saveForm(),
                    ),
                    RaisedButton(
                      child: Text('Navigate back to Page 1'),
                      onPressed: () => navigateToOtherPage(context),
                    ),
                  ],
                ),
              ),
              Text(
                Provider.of<LocalUser>(context).name != null ? 'Your Data: ${Provider.of<LocalUser>(context).name}' : '',
              ),
              Container(),
            ],
          ),
        ),
      ),
    );
  }
}
