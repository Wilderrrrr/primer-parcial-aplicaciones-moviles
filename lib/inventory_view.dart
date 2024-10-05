import 'package:flutter/material.dart';

class InventoryTable extends StatefulWidget {
  @override
  _InventoryTableState createState() => _InventoryTableState();
}

class _InventoryTableState extends State<InventoryTable> {
  List<InventoryItem> inventoryItems = [
    InventoryItem(codigo: '001', nombre: 'Aceite Motul 20W-50', cantidad: 10, precioCompra: 25000, precioVenta: 35000),
    InventoryItem(codigo: '002', nombre: 'Refrigerante', cantidad: 5, precioCompra: 30000, precioVenta: 48000),
    InventoryItem(codigo: '003', nombre: 'Bujía', cantidad: 10, precioCompra: 25000, precioVenta: 36000),
    InventoryItem(codigo: '004', nombre: 'Cadena 38', cantidad: 5, precioCompra: 150000, precioVenta: 200000),
  ];

  String searchQuery = '';

  void _addOrEditItem({InventoryItem? item}) {
    final codigoController = TextEditingController(text: item?.codigo);
    final nombreController = TextEditingController(text: item?.nombre);
    final cantidadController = TextEditingController(text: item?.cantidad.toString());
    final precioCompraController = TextEditingController(text: item?.precioCompra.toString());
    final precioVentaController = TextEditingController(text: item?.precioVenta.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item == null ? "Agregar Item" : "Editar Item"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: codigoController,
                  decoration: InputDecoration(labelText: "Código"),
                ),
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(labelText: "Nombre"),
                ),
                TextField(
                  controller: cantidadController,
                  decoration: InputDecoration(labelText: "Cantidad"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: precioCompraController,
                  decoration: InputDecoration(labelText: "Precio Compra"),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: precioVentaController,
                  decoration: InputDecoration(labelText: "Precio Venta"),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  if (item == null) {
                    // Agregar nuevo item
                    inventoryItems.add(InventoryItem(
                      codigo: codigoController.text,
                      nombre: nombreController.text,
                      cantidad: int.parse(cantidadController.text),
                      precioCompra: double.parse(precioCompraController.text),
                      precioVenta: double.parse(precioVentaController.text),
                    ));
                  } else {
                    // Editar item existente
                    item.codigo = codigoController.text;
                    item.nombre = nombreController.text;
                    item.cantidad = int.parse(cantidadController.text);
                    item.precioCompra = double.parse(precioCompraController.text);
                    item.precioVenta = double.parse(precioVentaController.text);
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text(item == null ? "Agregar" : "Actualizar"),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteItem(InventoryItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Eliminar Item"),
          content: Text("¿Desea eliminar el item con código ${item.codigo}?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  inventoryItems.remove(item);
                });
                Navigator.of(context).pop();
              },
              child: Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(25.0), 
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Buscar por código",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.blue, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(color: Colors.blue, width: 1),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value; 
                    });
                  },
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: PaginatedDataTable(
                    header: Text('Tabla de Inventario'),
                    columns: [
                      DataColumn(label: Text('Código')),
                      DataColumn(label: Text('Nombre')),
                      DataColumn(label: Text('Cantidad')),
                      DataColumn(label: Text('Precio Compra')),
                      DataColumn(label: Text('Precio Venta')),
                      DataColumn(label: Text('Acciones')),
                    ],
                    source: InventoryDataSource(
                      inventoryItems.where((item) => item.codigo.contains(searchQuery)).toList(),
                      (item) => _addOrEditItem(item: item),
                      _confirmDeleteItem,
                    ),
                    rowsPerPage: inventoryItems.length < 5 ? inventoryItems.length : 5, 
                    columnSpacing: orientation == Orientation.landscape ? 200 : 100, // Ajustar espacio entre columnas
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _addOrEditItem(),
                      child: Text("Agregar"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class InventoryItem {
  String codigo;
  String nombre;
  int cantidad;
  double precioCompra;
  double precioVenta;

  InventoryItem({required this.codigo, required this.nombre, required this.cantidad, required this.precioCompra, required this.precioVenta});
}

class InventoryDataSource extends DataTableSource {
  final List<InventoryItem> inventoryItems;
  final Function(InventoryItem?) onEdit;
  final Function(InventoryItem) onDelete;

  InventoryDataSource(this.inventoryItems, this.onEdit, this.onDelete);

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);
    if (index >= inventoryItems.length) return null;

    final item = inventoryItems[index];

    return DataRow(cells: [
      DataCell(Text(item.codigo)),
      DataCell(Text(item.nombre)),
      DataCell(Text(item.cantidad.toString())),
      DataCell(Text(item.precioCompra.toString())),
      DataCell(Text(item.precioVenta.toString())),
      DataCell(Row(
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => onEdit(item),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => onDelete(item),
          ),
        ],
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => inventoryItems.length;

  @override
  int get selectedRowCount => 0;
}
