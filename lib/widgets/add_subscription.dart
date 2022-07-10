import 'package:flutter/material.dart';

class AddSubscription extends StatefulWidget {
  const AddSubscription({Key? key}) : super(key: key);

  @override
  State<AddSubscription> createState() => _AddSubscriptionState();
}

class _AddSubscriptionState extends State<AddSubscription> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? topic;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("add subscription"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("ich mag penise. wenn du auch penise magst, subscribe!"),
            const SizedBox(height: 30),
            TextFormField(
              onSaved: (topic) => this.topic = topic,
              decoration: const InputDecoration(
                icon: Icon(Icons.accessibility_new_rounded),
                border: OutlineInputBorder(),
                labelText: "penis type",
              ),
              validator: _notEmptyValidator,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            )
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: _cancelAdd,
          child: const Text("NEIN zu Penisen!"),
        ),
        ElevatedButton(
            onPressed: _confirmAdd, child: const Text("JA zu Penisen!")),
      ],
    );
  }

  String? _notEmptyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter the subscription topic";
    }
    return null;
  }

  void _cancelAdd() {
    Navigator.pop(context, null);
  }

  void _confirmAdd() {
    var state = _formKey.currentState;
    if (state == null || !state.validate()) {
      return;
    }
    state.save();
    Navigator.pop(context, topic);
  }
}
