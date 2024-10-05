import 'package:flutter/material.dart';

class ShopView extends StatefulWidget {
  @override
  _ShopViewState createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> availableProducts = [
    {'codigo': '1011', 'nombre': 'Motul Extra', 'disponibles': 37, 'precio': 60000},
    {'codigo': '2415', 'nombre': 'Michellin 340X', 'disponibles': 84, 'precio': 180000},
    {'codigo': '8520', 'nombre': 'Cadena 125-300 CC', 'disponibles': 0, 'precio': 120000},
    {'codigo': '9810', 'nombre': 'Frenos ABS', 'disponibles': 23, 'precio': 320000},
  ];

  final List<Map<String, dynamic>> soldProducts = [];
  Map<String, int> quantities = {}; 

  void addProduct(String codigo, String nombre, int precio) {
    int cantidad = quantities[codigo] ?? 0;
    if (cantidad > 0) {
      setState(() {
        soldProducts.add({
          'codigo': codigo,
          'nombre': nombre,
          'cantidad': cantidad,
          'precioTotal': cantidad * precio,
        });
        quantities[codigo] = 0; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double total = soldProducts.fold(0, (sum, product) => sum + product['precioTotal']);

    return Scaffold(
      appBar: AppBar(
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {}, 
                    child: Text('Vender'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {}, 
                    child: Text('Imprimir recibo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      
                      showDialog(
                        context: context,
                        builder: (context) {
                          double initialAmount = 0;
                          return AlertDialog(
                            title: Text('Monto Inicial'),
                            content: TextField(
                              onChanged: (value) {
                                initialAmount = double.tryParse(value) ?? 0;
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(hintText: 'Ingresa el monto'),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  
                                },
                                child: Text('Aceptar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text('Monto inicial'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {}, 
                    child: Text('Resetear caja'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar por código...',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              Text('Productos disponibles', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Código')),
                    DataColumn(label: Text('Nombre')),
                    DataColumn(label: Text('Disponibles')),
                    DataColumn(label: Text('Cantidad a vender')),
                    DataColumn(label: Text('Precio unitario')),
                    DataColumn(label: Text('Acciones')),
                  ],
                  rows: availableProducts.map((product) {
                    String codigo = product['codigo'];
                    return DataRow(cells: [
                      DataCell(Text(product['codigo'])),
                      DataCell(Text(product['nombre'])),
                      DataCell(Text(product['disponibles'].toString())),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                if (quantities[codigo] != null && quantities[codigo]! > 0) {
                                  quantities[codigo] = quantities[codigo]! - 1;
                                }
                              });
                            },
                          ),
                          Text(quantities[codigo]?.toString() ?? '0'), 
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                if (quantities[codigo] == null) {
                                  quantities[codigo] = 0;
                                }
                                if (product['disponibles'] > quantities[codigo]!) {
                                  quantities[codigo] = quantities[codigo]! + 1;
                                }
                              });
                            },
                          ),
                        ],
                      )),
                      DataCell(Text(product['precio'].toString())),
                      DataCell(
                        ElevatedButton(
                          onPressed: () => addProduct(codigo, product['nombre'], product['precio']),
                          child: Text('Agregar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              Text('Productos vendidos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Código')),
                    DataColumn(label: Text('Nombre')),
                    DataColumn(label: Text('Cantidad')),
                    DataColumn(label: Text('Precio total')),
                    DataColumn(label: Text('Acciones')),
                  ],
                  rows: soldProducts.map((product) {
                    return DataRow(cells: [
                      DataCell(Text(product['codigo'])),
                      DataCell(Text(product['nombre'])),
                      DataCell(Text(product['cantidad'].toString())),
                      DataCell(Text(product['precioTotal'].toString())),
                      DataCell(TextButton(
                        onPressed: () {
                          setState(() {
                            soldProducts.remove(product);
                          });
                        },
                        child: Text('Eliminar'),
                      )),
                    ]);
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              DataTable(
                columns: [
                  DataColumn(label: Text('Total')),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text(total.toStringAsFixed(2))), 
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
