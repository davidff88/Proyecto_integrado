import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:intl/intl.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

void main() {

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'EXPENSIVOO'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  //PARA WIDGET FECHA
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime =TimeOfDay.now();

  Future<Null> _selectDate(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime, builder: (BuildContext context, Widget child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
        child: child,
      );});

    if (picked_s != null && picked_s != selectedTime )
      setState(() {
        selectedTime = picked_s;
      });
  }


  //--------------------///
  final my_controller = TextEditingController();
  final my_controller_concepto = TextEditingController();
  final my_controller_cantidad = TextEditingController();
  var tipo;
  DocumentReference ref;
  final databaseReferencef = Firestore.instance;
  Map<String, dynamic> formData;
  List<String> tipos = [
    'Hipoteca/alquiler',
    'Compras',
    'Ocio',
    'Luz',
    'Agua',
    'Otros',
  ];

  void salir() {
    setState(() {
      exit(0);
    });
  }

  void mostrarMensaje() {
    // set up the buttons
    Widget YesButton = FlatButton(
      child: Text("SI"),
      onPressed: () {
        exit(0);
      },
    );
    Widget NoButton = FlatButton(
      child: Text("NO"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("SALIR"),
              content: Text("¿Desea salir de la aplicacion?"),
              actions: <Widget>[NoButton, YesButton],
            ));
  }

  @override
  Widget build(BuildContext context) {
    //BARRA DE ACCION
    return Scaffold(
      drawer: MenuLateral(),
      appBar: AppBar(

        title: Text(widget.title),
        centerTitle: true,
      ),

      body: Container(
        //ESPACIADO DE LOS WIDGETS
        padding: EdgeInsets.only(top: 40, bottom: 10, right: 10, left: 10),

        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(0),
            ),
            Text(
              'BIENVENIDO A SU GESTOR DE GASTOS PERSONAL',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 50),
                ),
                DropDownField(
                    value: formData,
                    required: false,
                    strict: true,
                    labelText: 'Tipo de gasto',
                    icon: Icon(Icons.account_balance),
                    items: tipos,
                    controller: my_controller,
                    setter: (dynamic newValue) {
                      my_controller.text = newValue;
                    }),
                Column(
                  children: <Widget>[
                Padding(
                padding: EdgeInsets.only(bottom: 50),
                ),
                TextField(
                  controller: my_controller_cantidad,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 13.0,
                      height: 1.0,
                      fontWeight: FontWeight.w400),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      hintText: 'Introduzca la cantidad',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1.0),
                      )),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 50),
                    ),
                    TextField(
                      controller: my_controller_concepto,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.0,
                          height: 1.0,
                          fontWeight: FontWeight.w400),
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                          hintText: 'Concepto',
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          )),
                    ),

                    Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 40),
                        ),
                        RaisedButton(
                          color: Colors.blueAccent,
                          shape: new RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          onPressed: () async {
                            ref = await databaseReferencef
                                .collection("Gastos")
                                .add(
                              {
                                'Concepto': my_controller_concepto.text,
                                'fecha': new DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now()),
                                'Tipo': my_controller.text,
                                'Cantidad': my_controller_cantidad.text,
                              },
                            );
                            Widget OKButton = FlatButton(
                              child: Text("OK"),
                              onPressed: ()  {




                              },
                            );

                          },

                          child: SizedBox(
                            width: 280,
                            height: 50,
                            child: Center(
                              child:
                                  Text("GUARDAR", textAlign: TextAlign.center),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: mostrarMensaje,
        tooltip: 'Salir de la aplicacion',
        child: Icon(Icons.subdirectory_arrow_left),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

//MENU LATERAL CON UN APARTADO PARA LAS FUNCIONALIDADES DE LA APLICACION
class MenuLateral extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          new DrawerHeader(
            child: Text(
              "",
              textAlign: TextAlign.right,
            ),
            decoration: new BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/gastos.png"),
                        alignment: Alignment.bottomCenter)),

          ),
          Ink(
            color: Colors.grey,
            child: new ListTile(
              title: Text("INFORMACION"),
              leading: Icon(Icons.info),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => Informacion()));
              },
            ),
          ),
          new ListTile(
            title: Text("REGISTRARSE"),
            leading: Icon(Icons.backup),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Informacion()));
            },
          ),
          new ListTile(
            title: Text("GRAFICO DE MOVIMIENTOS"),
            leading: Icon(Icons.assessment),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Informacion()));

            },
          ),
          new ListTile(
            title: Text("LISTADO DE MOVIMIENTOS"),
            leading: Icon(Icons.assessment),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Informacion()));
            },
          ),
          new ListTile(
            title: Text("DESCARGAR PDF"),
            leading: Icon(Icons.assessment),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Informacion()));
            },
          ),
          new ListTile(
            title: Text("DESCARGAR HOJA DE CALCULO"),
            leading: Icon(Icons.assessment),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Informacion()));
            },
          ),
        ],
      ),
    );
  }
}



class Listado extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Listado de Gastos"),
        backgroundColor: Colors.tealAccent,
      ),
      body: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 1,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(1000, (index) {
          return new Container(
            height: 10.0,
            width: 10.0,
            color: Colors.white,
            margin: new EdgeInsets.all(1.0),
            child: new Center(
              child: Text(
                '',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          );
        }),
      ),
    );
  }
}

////MENU LATERAL--------------------------------------------------------

//MENU LATERAL SUBMENU
class Informacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        title: Text("Informacion de la aplicacion"),
    leading: IconButton(
    icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 1),
            ),
            Text(
              '******DESAROLLADOR*******',
              textAlign: TextAlign.center,
              style: TextStyle(
                  height: 5, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text('David Fuentes Fernandez', textAlign: TextAlign.center),
            Text(
              '**********VERSION***********',
              textAlign: TextAlign.center,
              style: TextStyle(
                  height: 5, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text('1.0', textAlign: TextAlign.center),
            Text(
              '*******LANZAMIENTO********',
              textAlign: TextAlign.center,
              style: TextStyle(
                  height: 5, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text('2020', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}


class Grafico extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Grafico de movimientos"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        child: Column(
          children: <Widget>[

            Padding(
              padding: EdgeInsets.only(bottom: 1),
            ),

          ],
        ),
      ),
    );
  }
}

class Pdf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Descargar PDF"),
        backgroundColor: Colors.tealAccent,
      ),
      body: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 1,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(1000, (index) {
          return new Container(
            height: 10.0,
            width: 10.0,
            color: Colors.white,
            margin: new EdgeInsets.all(1.0),
            child: new Center(
              child: Text(
                '',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class Calculo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Descargar hoja de calculo"),
        backgroundColor: Colors.tealAccent,
      ),
      body: GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 1,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(1000, (index) {
          return new Container(
            height: 10.0,
            width: 10.0,
            color: Colors.white,
            margin: new EdgeInsets.all(1.0),
            child: new Center(
              child: Text(
                '',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          );
        }),
      ),
    );
  }
}


