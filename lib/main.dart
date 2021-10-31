import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './Models/transaction.dart';
import './Widgets/new_transaction.dart';
import './Widgets/List_des_transactions.dart';
import './Widgets/chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'OpenSans',
      ),
      title: 'Dépense Personnel',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Transaction> _userTransactions = [];

// REGROUPEMENT DES BARRES DE DEPENSES EN JOURS DE LA SEMAINE
  List<Transaction> get _recentTransaction {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  bool _showChart = false;

  // RECUPERER LES DONNEES DEPUIS LE SERVEUR
  Future<void> fetchAndSetData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://expanse-54ecc-default-rtdb.firebaseio.com/expanse.json'),
      );
      final extratedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Transaction> loadedExpanse = [];
      extratedData.forEach((Id, Data) {
        loadedExpanse.add(Transaction(
          id: Id,
          title: Data['title'],
          amount: Data['amount'],
          date: Data['date'],
        ));
      });
      _userTransactions = loadedExpanse;
    } catch (error) {
      throw (error);
    }
  }

// FONCTION POUR AJOUTER UNE NOUVELLE DEPENSE
  Future<void> _addTransaction(
      String txTitle, int txAmount, DateTime chosenDate) {
    return http
        .post(
      Uri.parse(
          'https://expanse-54ecc-default-rtdb.firebaseio.com/expanse.json'),
      body: json.encode({
        'title': txTitle,
        'amount': txAmount,
        'date': chosenDate.toIso8601String(),
      }),
    )
        .then((response) {
      final newTx = Transaction(
        title: txTitle,
        amount: txAmount,
        date: chosenDate,
        id: json.decode(response.body)['name'],
      );
      setState(() {
        _userTransactions.add(newTx);
      });
    });
  }

// FONCTION POUR COMMENCER L'AJOUT D'UNE NOUVELLE DEPENSE GRACE AU BOUTON FLOAT
  void _startAddTrans(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

// SUPPRIMER UNE DEPENSE
  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    // MISE DE APPBAR DANS UNE VARIABLE
    final appBar = AppBar(
      title: Text(
        'Dépense Personnel',
        style: TextStyle(
          fontFamily: 'Roboto',
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddTrans(context),
        )
      ],
    );
    // MISE DE LA LISTE DES TRANSACTION EN MODE PORTRAIT DANS UNE VARIABLE
    final txListWiddget = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape) // EN MODE PAYSAGE ?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Montrer la barre'),
                  Switch(
                      // MONTRER LA BARRE DES TRANSACTIONS RECENTES GRACE AU BOUTON SWITCH
                      value: _showChart,
                      onChanged: (val) {
                        setState(() {
                          _showChart = val;
                        });
                      }),
                ],
              ),
            if (!isLandscape) // EN MODE PORTRAIT ?
              Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.3,
                child: Chart(_recentTransaction),
              ),
            if (!isLandscape) txListWiddget, // EN MODE PORTRAIT ?
            if (isLandscape) // EN MODE PAYSAGE ?
              _showChart
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.7,
                      child: Chart(_recentTransaction),
                    )
                  : txListWiddget
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => _startAddTrans(context),
      ),
    );
  }
}
