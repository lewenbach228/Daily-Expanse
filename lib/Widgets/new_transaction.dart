import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTrans;

  NewTransaction(this.addTrans);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;
  var _isLoading = false;
// FONCTION DE SOUMISSION DU FORMULAIRE D'UNE DEPENSE
  void _submitData() {
    if (_amountController.text.isEmpty) {
      // SI LE CHAMP DE LA SOMME DEPENSER EST VIDE
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = int.parse(_amountController.text);
// SI TITRE, SOMME DEPNSER OU DATE CHOISI EST VIDE
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    widget
        .addTrans(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    )
        .then((_) {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    });
  }

// FONCTION QUI PERMET DE CHOISIR UNE DATE
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            // LISTE INFINI
            child: Card(
              elevation: 5.0,
              child: Container(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom +
                      10, // RECUPERE LA HAUTEUR DE TOUT ELEMENT EN DESSOUS (ICI CLAVIER) ET Y AJOUTER 10 PIXELS
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Titre'),
                      controller: _titleController,
                      onSubmitted: (_) => _submitData(),
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Prix'),
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) => _submitData(),
                    ),
                    Container(
                      height: 70,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedDate == null
                                  ? 'Aucune date choisi!'
                                  : 'Date choisi : ${DateFormat("dd/MM/yyyy").format(_selectedDate)}',
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                            ),
                            child: Text(
                              'Choisir une date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: _presentDatePicker,
                          )
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _submitData,
                      child: Text('Ajouter'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontFamily: 'roboto',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
