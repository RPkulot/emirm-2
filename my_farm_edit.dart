import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'database/myfarm_db.dart';
import 'model/myfarm.dart';
import 'my_farmform.dart';

class AddEditFarmPage extends StatefulWidget {
  final Farm? farm;

  const AddEditFarmPage({
    Key? key,
    this.farm,
  }) : super(key: key);

  @override
  State<AddEditFarmPage> createState() => _AddEditFarmPageState();
}

class _AddEditFarmPageState extends State<AddEditFarmPage> {
  final _formKey = GlobalKey<FormState>();
  late bool isImportant;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();

    isImportant = widget.farm?.isImportant ?? false;
    number = widget.farm?.number ?? 0;
    title = widget.farm?.title ?? '';
    description = widget.farm?.description ?? '';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: Color(0xFF27ae60),
      actions: [buildButton()],
    ),
    body: Form(
      key: _formKey,
      child: FarmForm(
        isImportant: isImportant,
        number: number,
        title: title,
        description: description,
        onChangedImportant: (isImportant) =>
            setState(() => this.isImportant = isImportant),
        onChangedNumber: (number) => setState(() => this.number = number),
        onChangedTitle: (title) => setState(() => this.title = title),
        onChangedDescription: (description) =>
            setState(() => this.description = description),
      ),
    ),
  );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: isFormValid ? null : Colors.grey.shade700,
        ),
        onPressed: addOrUpdateFarm,
        child: const Text('Save'),
      ),
    );
  }

  void addOrUpdateFarm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.farm != null;

      if (isUpdating) {
        await updateFarm();
      } else {
        await addFarm();
      }

      Navigator.of(context).pop();
    }
  }

  Future updateFarm() async {
    final note = widget.farm!.copy(
      isImportant: isImportant,
      number: number,
      title: title,
      description: description,
    );

    await MyFarmDatabase.instance.update(note);
  }

  Future addFarm() async {
    final note = Farm(
      title: title,
      isImportant: true,
      number: number,
      description: description,
      createdTime: DateTime.now(),
    );

    await MyFarmDatabase.instance.create(note);
  }
}