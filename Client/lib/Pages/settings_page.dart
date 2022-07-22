import 'package:client/Pages/data_monitor_page.dart';
import 'package:flutter/material.dart';


int valueMeasu = 0;

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _globalFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              margin: const EdgeInsets.symmetric(vertical: 85, horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).hintColor.withOpacity(0.2),
                      offset: const Offset(0, 10),
                      blurRadius: 20,
                    )
                  ]),
              child: Form(
                  key: _globalFormKey,
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Quante misurazioni vuoi visualizzare ?",
                        style: TextStyle(fontSize: 40),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.numbers),
                            onPressed: () => {},
                          ),
                           hintText: "Numero di misurazioni da visualizzare",
                        ),
                        onSaved: (value) =>
                            valueMeasu = int.parse(value.toString()),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        child: const Text(
                          "Salva",
                          style: TextStyle(fontSize: 18),
                        ),
                        onPressed: () {
                          if (validateAndSave()) {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const DataMonitorPage()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Inserire un numero valido!")));
                          }
                        },
                      )
                    ],
                  )),
            )
          ],
        )
      ])),
    );
  }

  bool validateAndSave() {
    final form = _globalFormKey.currentState;
    form?.save();
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
