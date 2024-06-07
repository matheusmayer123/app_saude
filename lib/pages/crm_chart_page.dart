import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CrmChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfico de Linha'),
      ),
      body: Center(
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(0, 3),
                  FlSpot(1, 4),
                  FlSpot(2, 3.5),
                  FlSpot(3, 5),
                  FlSpot(4, 4),
                  FlSpot(5, 5),
                  FlSpot(5.5, 5),
                  FlSpot(6, 5),
                ],
                isCurved: true,
                color: Colors.blue,
                barWidth: 5,
                belowBarData: BarAreaData(show: false),
              ),
            ],
            minX: 0,
            maxX: 6,
            minY: 0,
            maxY: 8,
            titlesData: const FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),

                // Defina os títulos do eixo x aqui
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
                // Defina os títulos do eixo y aqui
              ),
            ),
          ),
        ),
      ),
    );
  }
}
