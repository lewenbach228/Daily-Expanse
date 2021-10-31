import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final int spendingAmount;
  final double spendintPctAmount;

  ChartBar(this.label, this.spendingAmount, this.spendintPctAmount);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            // TOTALITE DE LA SOMME DEPENSE EN HAUT DE LA BARRE
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text(spendingAmount.toString()),
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            // LA BARRE EN ELLE MEME EN TERME DE POURCENTAGE
            Container(
              height: constraints.maxHeight * 0.6,
              width: 12,
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: spendintPctAmount,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            // RACCOURCIS DES JOURS DE LA SEMAINE EN BAS DE LA BARRE
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text(label),
              ),
            ),
          ],
        );
      },
    );
  }
}
