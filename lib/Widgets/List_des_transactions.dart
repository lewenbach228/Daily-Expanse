import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '../Models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> trans;
  final Function deleteTx;
  TransactionList(this.trans, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 449,
      child: trans.isEmpty
          // AFFICHER UNE IMAGE SI LA LISTE DES DEPENSES EST VIDE
          ? LayoutBuilder(builder: (ctx, constraints) {
              return Column(
                children: [
                  Text(
                    'Aucune dépense disponible',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.5,
                    child: Image.asset(
                      'assets/images/rien.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            })
          // AFFICHAGE DE LA LISTE DES DEPENSES
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    // CERLCE QUI AFFICHE LA SOMME DEPENSER
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text(trans[index].amount.toString()),
                        ),
                      ),
                    ),
                    // TITRE DE LA SOMME DEPNSER
                    title: Text(
                      trans[index].title,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    // DATE A LAQUELLE LA SOMME A ETE DEPENSER
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy').format(trans[index].date),
                    ),
                    // AFFICHAGE D'UNE BOUTON DE SUPPRESSION
                    trailing: MediaQuery.of(context).size.width > 460
                        ? TextButton.icon(
                            // AFFICHER LE TEXTE SUPPRIMER AVANT BOUTON SUPPPRIMER SI LARGEUR DEPASSE 460 PIXELS
                            onPressed: () => deleteTx(trans[index].id),
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            label: Text(
                              'Supprimer',
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        : IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () => deleteTx(trans[index].id),
                          ),
                  ),
                );
              },
              itemCount: trans.length,
            ),
    );
  }
}
