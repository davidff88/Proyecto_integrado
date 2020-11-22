


import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadingData(String cantidad, String tipo,
    String concepto, String fecha) async {
  await Firestore.instance.collection("Gastos").add({
    'cantidad': cantidad,
    'tipo': tipo,
    'concepto': concepto,
    'fecha': fecha,
  });
}

Future<void> editGastos(String cantidad, String tipo,
    String concepto, String fecha, String id) async {
  await Firestore.instance
      .collection("Gastos")
      .document(id)
      .updateData({"Gastos":cantidad});
}

Future<void> deleteGastos(DocumentSnapshot doc) async {
  await Firestore.instance
      .collection("Gastos")
      .document(doc.documentID)
      .delete();
}
