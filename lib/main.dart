import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Calculadora(),
  ));
}

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => CalculadoraState();
}

class CalculadoraState extends State<Calculadora> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController montoController = TextEditingController();
  TextEditingController interesController = TextEditingController();
  TextEditingController plazoController = TextEditingController();

  List<Map<String, dynamic>> tablaAmortizacion = [];
  double? interesTotal;
  double? cuotaMensual;
  double monto = 0;

  void _prestamo() {
    if (!_formKey.currentState!.validate()) return;

    monto = double.parse(montoController.text);
    int plazo = int.parse(plazoController.text);
    double tasaAnual = double.parse(interesController.text);

    double tasaMensual = tasaAnual / 12 / 100;
    double cuota = monto *
        (tasaMensual * pow((1 + tasaMensual), plazo)) /
        (pow((1 + tasaMensual), plazo) - 1);

    tablaAmortizacion.clear();
    double balance = monto;
    double totalInteres = 0;

    for (int i = 1; i <= plazo; i++) {
      double interesMensual = balance * tasaMensual;
      double capital = cuota - interesMensual;
      balance -= capital;
      totalInteres += interesMensual;

      tablaAmortizacion.add({
        'numero': i,
        'cuota': cuota,
        'capital': capital,
        'interes': interesMensual,
        'balance': balance > 0 ? balance : 0,
      });
    }

    setState(() {
      cuotaMensual = cuota;
      interesTotal = totalInteres;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: const Text('Cuota de préstamo'),
        centerTitle: true,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.white,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Container(
                      width: 500,
                      padding: const EdgeInsets.symmetric(
                          vertical: 40, horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: montoController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 220, 219, 219),
                              labelText: 'Monto',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(166, 38, 222, 209),
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(166, 38, 222, 209),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Debe ingrese un monto';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: plazoController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 220, 219, 219),
                              labelText: 'Cuotas',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(166, 38, 222, 209),
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(166, 38, 222, 209),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Debe ingresar la cantidad de cuotas';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: interesController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:
                                  const Color.fromARGB(255, 220, 219, 219),
                              labelText: 'Interés anual',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(166, 38, 222, 209),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(166, 38, 222, 209),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Debe ingresar la tasa de interés';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          Container(
                            width: 620,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _prestamo,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(166, 38, 222, 209),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'Calcular',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (cuotaMensual != null) ...[
                    const SizedBox(height: 24),
                    Card(
                      color: Colors.white,
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Resultado:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text.rich(
                              TextSpan(
                                text: 'La cuota mensual sería de:\n',
                                style: const TextStyle(fontSize: 16.0),
                                children: [
                                  TextSpan(
                                    text:
                                        ' ${cuotaMensual!.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 40),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.left,
                            ),
                            Text.rich(
                              TextSpan(
                                text: 'Considerando un monto de ',
                                style: const TextStyle(fontSize: 16.0),
                                children: [
                                  TextSpan(
                                    text: '\$${monto.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const TextSpan(
                                    text: ' a una tasa de \n interés de ',
                                  ),
                                  TextSpan(
                                    text: '${interesController.text}.00%',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const TextSpan(
                                    text: ' por un plazo de ',
                                  ),
                                  TextSpan(
                                    text: '${plazoController.text} meses',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: 620,
                      child: Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Card(
                            color: Colors.grey[200],
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Container(
                                color: Colors.grey[200],
                                child: Column(
                                  children: [
                                    const Text(
                                      'Tabla de amortización',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    DataTable(
                                      headingTextStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      columns: const [
                                        DataColumn(
                                          label: Text('No.'),
                                        ),
                                        DataColumn(
                                          label: Text('Cuota'),
                                        ),
                                        DataColumn(
                                          label: Text('Capital'),
                                        ),
                                        DataColumn(
                                          label: Text('Interés'),
                                        ),
                                        DataColumn(
                                          label: Text('Balance'),
                                        ),
                                      ],
                                      rows: tablaAmortizacion.map(
                                        (row) {
                                          return DataRow(cells: [
                                            DataCell(
                                              Text(
                                                row['numero'].toString(),
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                '\$${row['cuota'].toStringAsFixed(2)}',
                                              ),
                                            ),
                                            DataCell(
                                              Text(
                                                  '\$${row['capital'].toStringAsFixed(2)}'),
                                            ),
                                            DataCell(Text(
                                              '\$${row['interes'].toStringAsFixed(2)}',
                                            )),
                                            DataCell(
                                              Text(
                                                  '\$${row['balance'].toStringAsFixed(2)}'),
                                            ),
                                          ]);
                                        },
                                      ).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
