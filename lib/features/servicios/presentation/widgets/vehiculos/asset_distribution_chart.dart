import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AssetDistributionChart extends StatefulWidget {
  final int occupied, available, workshop, total;

  const AssetDistributionChart({
    super.key,
    required this.occupied,
    required this.available,
    required this.workshop,
    required this.total,
  });

  @override
  State<AssetDistributionChart> createState() => _AssetDistributionChartState();
}

class _AssetDistributionChartState extends State<AssetDistributionChart> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    const Color occupiedColor = Color(0xFFC62828);
    const Color availableColor = Color(0xFF424242);
    const Color workshopColor = Color(0xFF757575);

    int getPercent(int value) => widget.total > 0 ? ((value / widget.total) * 100).toInt() : 0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _isHovered ? -5 : 0, 0),
        // Ocupa el 100% del ancho disponible, adaptándose a su contenedor
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(_isHovered ? 0.3 : 0.15),
              blurRadius: _isHovered ? 20 : 10,
              offset: Offset(0, _isHovered ? 10 : 4),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Si el ancho es menor a 350, cambiamos a diseño vertical
            bool isCompact = constraints.maxWidth < 350;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Distribución de Activos", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                Container(height: 4, width: 40, color: occupiedColor),
                const SizedBox(height: 24),
                
                // Diseño flexible basado en el tamaño
                isCompact 
                  ? Column(
                      children: [
                        _buildChart(occupiedColor, availableColor, workshopColor, 120),
                        const SizedBox(height: 24),
                        _buildLegend(getPercent, occupiedColor, availableColor, workshopColor),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(child: _buildChart(occupiedColor, availableColor, workshopColor, 150)),
                        const SizedBox(width: 20),
                        Expanded(child: _buildLegend(getPercent, occupiedColor, availableColor, workshopColor)),
                      ],
                    ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildChart(Color oc, Color av, Color wo, double size) {
    return SizedBox(
      height: size,
      child: Stack(alignment: Alignment.center, children: [
        PieChart(
          PieChartData(
            sectionsSpace: 4,
            centerSpaceRadius: size * 0.4,
            sections: [
              PieChartSectionData(value: widget.occupied.toDouble(), color: oc, showTitle: false, radius: 20),
              PieChartSectionData(value: widget.available.toDouble(), color: av, showTitle: false, radius: 20),
              PieChartSectionData(value: widget.workshop.toDouble(), color: wo, showTitle: false, radius: 20),
            ],
          ),
        ),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.directions_car, size: size * 0.25, color: Colors.grey),
          Text("${widget.total}", style: TextStyle(fontSize: size * 0.3, fontWeight: FontWeight.bold)),
        ])
      ]),
    );
  }

  Widget _buildLegend(Function getP, Color oc, Color av, Color wo) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem("Ocupados", "${widget.occupied}", "${getP(widget.occupied)}%", oc),
        const SizedBox(height: 12),
        _legendItem("Disponibles", "${widget.available}", "${getP(widget.available)}%", av),
        const SizedBox(height: 12),
        _legendItem("Taller", "${widget.workshop}", "${getP(widget.workshop)}%", wo),
      ],
    );
  }

  Widget _legendItem(String label, String count, String percent, Color color) => Row(
    children: [
      Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 10),
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 14)),
            Text("$count ($percent)", style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      )
    ],
  );
}