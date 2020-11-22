import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'operaciones.dart';

class GastosItem extends StatefulWidget {
  final String cantidad;
  final String tipo;
  final String concepto;
  final String fecha;
  final String id;

  final DocumentSnapshot documentSnapshot;

  GastosItem({this.cantidad, this.tipo,this.concepto,this.documentSnapshot,this.fecha, this.id

  });

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<GastosItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        child: Row(
          children: <Widget>[
            Container(
              height: 100,
              width: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Text(
                  widget.cantidad,

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          widget.tipo,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 25),
                        ),
                      ),

                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                  Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          editGastos(widget.cantidad,widget.tipo, widget.id,
                              widget.concepto,widget.fecha);
                        },

                      ),
                      IconButton(
                        onPressed: () {
                          deleteGastos(widget.documentSnapshot);
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black,
        ),
      ),
    );
  }
}