import 'package:flutter/material.dart';

class ServiceDataTable extends StatelessWidget {
  const ServiceDataTable({super.key});

  @override
  Widget build(BuildContext context) {
    // LISTA VACÍA PARA PRODUCCIÓN
    final List<dynamic> services = []; 

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: services.isEmpty 
        ? const Padding(
            padding: EdgeInsets.all(40),
            child: Center(
              child: Text("No hay servicios activos", style: TextStyle(color: Colors.grey)),
            ),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('UNIDAD')),
                DataColumn(label: Text('ESTATUS')),
                DataColumn(label: Text('ACCIONES')),
              ],
              rows: const [], // Se llenará dinámicamente
            ),
          ),
    );
  }
}