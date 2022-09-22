/// Package import
import 'package:flutter/material.dart';

/// Chart import
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../constraints/colors.dart';

///Chart sample data
class ChartSampleData {
  /// Holds the datapoint values like x, y, etc.,
  ChartSampleData(
      {this.x,
      this.y,
      this.xValue,
      this.yValue,
      this.secondSeriesYValue,
      this.thirdSeriesYValue,
      this.pointColor,
      this.size,
      this.text,
      this.open,
      this.close,
      this.low,
      this.high,
      this.volume});

  /// Holds x value of the datapoint
  final dynamic x;

  /// Holds y value of the datapoint
  final num? y;

  /// Holds x value of the datapoint
  final dynamic xValue;

  /// Holds y value of the datapoint
  final num? yValue;

  /// Holds y value of the datapoint(for 2nd series)
  final num? secondSeriesYValue;

  /// Holds y value of the datapoint(for 3nd series)
  final num? thirdSeriesYValue;

  /// Holds point color of the datapoint
  final Color? pointColor;

  /// Holds size of the datapoint
  final num? size;

  /// Holds datalabel/text value mapper of the datapoint
  final String? text;

  /// Holds open value of the datapoint
  final num? open;

  /// Holds close value of the datapoint
  final num? close;

  /// Holds low value of the datapoint
  final num? low;

  /// Holds high value of the datapoint
  final num? high;

  /// Holds open value of the datapoint
  final num? volume;
}

/// Chart Sales Data
class SalesData {
  /// Holds the datapoint values like x, y, etc.,
  SalesData(this.x, this.y, [this.date, this.color]);

  /// X value of the data point
  final dynamic x;

  /// y value of the data point
  final dynamic y;

  /// color value of the data point
  final Color? color;

  /// Date time value of the data point
  final DateTime? date;
}

/// Renders the stacked column chart sample.
class StackedColumnChart extends StatefulWidget {
  /// Creates the stacked column chart sample.
  const StackedColumnChart({Key? key}) : super(key: key);

  @override
  _StackedColumnChartState createState() => _StackedColumnChartState();
}

/// State class of the stacked column chart.
class _StackedColumnChartState extends State {
  _StackedColumnChartState();

  List<ChartSampleData>? chartData;

  TooltipBehavior? _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior =
        TooltipBehavior(enable: true, header: '', canShowMarker: false);
    chartData = <ChartSampleData>[
      ChartSampleData(
          x: 'Q1',
          y: 50,
          yValue: 55,
          secondSeriesYValue: 72,
          thirdSeriesYValue: 65),
      ChartSampleData(
          x: 'Q2',
          y: 80,
          yValue: 75,
          secondSeriesYValue: 70,
          thirdSeriesYValue: 60),
      ChartSampleData(
          x: 'Q3',
          y: 35,
          yValue: 45,
          secondSeriesYValue: 55,
          thirdSeriesYValue: 52),
      ChartSampleData(
          x: 'Q4',
          y: 65,
          yValue: 50,
          secondSeriesYValue: 70,
          thirdSeriesYValue: 65),
      ChartSampleData(
          x: 'Q5',
          y: 50,
          yValue: 55,
          secondSeriesYValue: 72,
          thirdSeriesYValue: 65),
      ChartSampleData(
          x: 'Q6',
          y: 80,
          yValue: 75,
          secondSeriesYValue: 70,
          thirdSeriesYValue: 60),
      ChartSampleData(
          x: 'Q7',
          y: 35,
          yValue: 45,
          secondSeriesYValue: 55,
          thirdSeriesYValue: 52),
      ChartSampleData(
          x: 'Q8',
          y: 65,
          yValue: 50,
          secondSeriesYValue: 70,
          thirdSeriesYValue: 65),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildStackedColumnChart();
  }

  /// Returns the cartesian Stacked column chart.
  SfCartesianChart _buildStackedColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      title: ChartTitle(text: ''),
      legend: Legend(
        isVisible: false,
        overflowMode: LegendItemOverflowMode.wrap,
      ),
      primaryXAxis: CategoryAxis(
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
          axisLine: const AxisLine(width: 0),
          labelFormat: '{value}K',
          maximum: 300,
          majorTickLines: const MajorTickLines(size: 0)),
      series: _getStackedColumnSeries(),
      tooltipBehavior: _tooltipBehavior,
      palette: const [
        colorEarningsLine,
        colorGrossSalesLine,
      ],
    );
  }

  /// Returns the list of chart serie which need to render
  /// on the stacked column chart.
  List<StackedColumnSeries<ChartSampleData, String>> _getStackedColumnSeries() {
    return <StackedColumnSeries<ChartSampleData, String>>[
      StackedColumnSeries<ChartSampleData, String>(
        dataSource: chartData!,
        // borderRadius: const BorderRadius.only(
        //   topLeft: Radius.circular(50),
        //   topRight: Radius.circular(50),
        // ),
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        name: 'Earnings',
      ),
      StackedColumnSeries<ChartSampleData, String>(
        dataSource: chartData!,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        xValueMapper: (ChartSampleData sales, _) => sales.x as String,
        yValueMapper: (ChartSampleData sales, _) => sales.yValue,
        name: 'Gross Sales',
      ),
    ];
  }

  @override
  void dispose() {
    chartData!.clear();
    super.dispose();
  }
}
