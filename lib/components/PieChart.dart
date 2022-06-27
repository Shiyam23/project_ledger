/// Donut chart with labels example. This is a simple pie chart with a hole in
/// the middle.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import '../models/CategoryChartInfo.dart';

class PieLabelChart extends StatelessWidget {
  final List<charts.Series<CategoryChartInfo, int>> seriesList;

  PieLabelChart(this.seriesList);

  /// Creates a [PieChart] with sample data and no transition.
  factory PieLabelChart.fromChartInfo(List<CategoryChartInfo> chartInfo) {
    return new PieLabelChart(
      _createSeriesData(chartInfo)
    );
  }


  @override
  Widget build(BuildContext context) {
    return new charts.PieChart<int>(seriesList,
        animate: false,
        defaultRenderer: new charts.ArcRendererConfig(
            arcRendererDecorators: [new charts.ArcLabelDecorator()]));
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<CategoryChartInfo, int>> _createSeriesData(
    List<CategoryChartInfo> chartInfo
  ) {
    final data = chartInfo;

    return [
      new charts.Series<CategoryChartInfo, int>(
        id: 'Sales',
        domainFn: (CategoryChartInfo category, _) => category.categoryName.hashCode,
        measureFn: (CategoryChartInfo category, _) => category.amount,
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (CategoryChartInfo category, item) => category.categoryName,
        colorFn: (_,item) => charts.Color(
          r: ((9/data.length)*(item!+1)).round()+47, 
          g: ((44/data.length)*(item+1)).round()+56, 
          b: ((68/data.length)*(item+1)).round()+64, 
          a: 255
        ),
      )
    ];
  }
}

/// Sample linear data type.
class LinearSales {
  final int year;
  final int sales;

  LinearSales(this.year, this.sales);
}