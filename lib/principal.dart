import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:dropdownfield/dropdownfield.dart';
import 'package:intl/intl.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chart/pie_chart_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //AÑADIR AQUI LOS TABS
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'EXPENSIVO'),
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
  //WIDGET FECHA
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<Null> _selectDate(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });

    if (picked_s != null && picked_s != selectedTime)
      setState(() {
        selectedTime = picked_s;
      });
  }

  //CONTROLADORES PARA LOS TEXTFIELD Y DROPDOWNLIST///
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
    'Luz',
    'Agua',
    'Otros gastos',
  ];

  void salir() {
    setState(() {
      exit(0);
    });
  }

  //METODO PARA SALIR DE LA APLICACION
  void mostrarMensaje() {
    // set up the buttons
    Widget YesButton = FlatButton(
      child: Text("SI"),
      onPressed: () {
        salir();
      },
    );
    Widget NoButton = FlatButton(
      child: Text("NO"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    //MUESTRA UN CUADRO DE DIALOGO AL PULSAR EN SALIR
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
    //BARRA DE ACCION CON PESTAÑAS
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: MenuLateral(),
        appBar: AppBar(
          backgroundColor: Color(0xff1976d2),
          //backgroundColor: Color(0xff308e1c),
          bottom: TabBar(
            unselectedLabelColor: Colors.white,
            labelColor: Colors.green,
            tabs: [
              Tab(
                icon: Icon(LineAwesomeIcons.home),
              ),
              Tab(icon: Icon(LineAwesomeIcons.list)),
              Tab(icon: Icon(LineAwesomeIcons.pie_chart)),
            ],
          ),
          title: Text('EXPENSIVO'),
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
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(0),
                  ),
                  DropDownField(
                      value: formData,
                      required: false,
                      strict: true,
                      labelText: 'Tipo de gasto',
                      icon: Icon((LineAwesomeIcons.donate)),
                      items: tipos,
                      controller: my_controller,
                      setter: (dynamic newValue) {
                        my_controller.text = newValue;
                      }),
                  Column(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20),
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
                          icon: Icon((LineAwesomeIcons.euro_sign)),
                          hintText: 'Introduzca la cantidad',
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0),
                          )),
                    ),
                    Column(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(20),
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
                            icon: Icon((LineAwesomeIcons.comment)),
                            hintText: 'Concepto o Nota',
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2.0),
                            )),
                      ),
                      Column(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(40),
                        ),
                        SizedBox(
                            width: 350,
                            height: 50,
                            child: RaisedButton.icon(
                              icon: Icon((LineAwesomeIcons.save)),
                              textColor: Colors.white,
                              color: Colors.lightBlue,
                              label: const Text('GUARDAR'),
                              onPressed: () async {
                                ref = await databaseReferencef
                                    .collection("Gastos")
                                    .add(
                                  {
                                    'Concepto': my_controller_concepto.text,
                                    'fecha':
                                        new DateFormat('yyyy-MM-dd – kk:mm')
                                            .format(DateTime.now()),
                                    'Tipo': my_controller.text,
                                    'Cantidad': my_controller_cantidad.text,
                                  },
                                );

                                Widget OKButton = FlatButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                );
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: Text("GUARDAR"),
                                          content:
                                              Text("Se ha guardado con exito"),
                                          actions: <Widget>[OKButton],
                                        ));
                              },
                            )),
                      ]),
                    ]),
                  ]),
                ],
              ),
            ],
          ),
        ),
      ),
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
          Container(
              padding: EdgeInsets.only(top: 40),
              child: DrawerHeader(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/gestion.png"),
                          alignment: Alignment.topCenter)))),
          Ink(
            color: Colors.grey,
            child: new ListTile(
              title: Text("INFORMACION"),
              leading: Icon((LineAwesomeIcons.exclamation_circle)),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => Grafico()));
              },
            ),
          ),
          new ListTile(
            title: Text("LISTADO"),
            leading: Icon((LineAwesomeIcons.exclamation_circle)),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Listado()));
            },
          ),
          new ListTile(
            title: Text("CONTACTO"),
            leading: Icon((LineAwesomeIcons.exclamation_circle)),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Grafico()));
            },
          ),
          new ListTile(
            title: Text("SALIR DE LA APLICACION"),
            leading: Icon((LineAwesomeIcons.arrow_circle_left)),
            onTap: () {
              Widget yesButton = FlatButton(
                child: Text("SI"),
                onPressed: () {
                  exit(0);
                },
              );
              Widget noButton = FlatButton(
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
                  actions: <Widget>[noButton, yesButton],
                ),
              );
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

  }
}

//MENU LATERAL SUBMENU
class Informacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Información"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 1),
            ),
            Text(
              '        DESAROLLADOR          ',
              textAlign: TextAlign.center,
              style: TextStyle(
                  height: 5, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text('David Fuentes Fernandez', textAlign: TextAlign.center),
            Text(
              'VERSION',
              textAlign: TextAlign.center,
              style: TextStyle(
                  height: 5, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text('1.0', textAlign: TextAlign.center),
            Text(
              'LANZAMIENTO',
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
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("GRAFICO"), centerTitle: true),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: PageView(
            children: [
              PieChartPage(),
            ],
          ),
        ),
      );
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
      body: Container(),
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
      body: Container(),
    );
  }
}
