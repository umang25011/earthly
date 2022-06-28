import 'package:Earthly/helpers/colors.dart';
import 'package:Earthly/helpers/text_theme.dart';
import 'package:Earthly/screens/reduce/reduce_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class ResultScreen extends StatelessWidget {
  final double userEmission;
  final double averageEmission;
  final String activityName;

  static final routeName = "/result";

  ResultScreen(
      {Key key, this.activityName, this.userEmission, this.averageEmission})
      : super(key: key);

  Text toolTipLabel = Text(
    " tonnes CO2",
    style: TextStyle(
      fontSize: 30,
      color: ColorPallete.color3,
    ),
  );

  double roundOff(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  // returns the percentage change between
  // the emission by user and average emission of that category
  double getChangePercentage() {
    double changePercent =
        ((userEmission - averageEmission) / averageEmission) * 100;

    changePercent = changePercent >= 0 ? changePercent : -changePercent;

    return roundOff(changePercent);
  }

  List<Widget> getDataGrids(String changePrefix, double changePercent) {
    List<Map> emissionDatas = [
      {
        'text': 'Your carbon footprint for $activityName activities',
        'figure': '${roundOff(userEmission)} tonnes CO2',
        'icon': Icons.person_outline,
      },
      {
        'text': 'Average carbon footprint for $activityName',
        'figure': '${roundOff(averageEmission)} tonnes CO2',
        'icon': Icons.nature_people,
      },
      {
        'text': 'You are emitting $changePrefix emission than average',
        'figure': '$changePercent %',
        'icon': Icons.track_changes,
      },
    ];

    List<Widget> widgetList = [];

    for (var emissionData in emissionDatas) {
      Widget listItem = Container(
        child: Card(
          elevation: 2,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: ColorPallete.cardBackground,
          child: ListTile(
            title: CoolText(
              emissionData['figure'].toString(),
              fontSize: 18,
              letterSpacing: 1.1,
            ),
            subtitle: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: Text(
                emissionData['text'].toString(),
                style: TextStyle(
                  color: ColorPallete.color7,
                  fontSize: 13,
                  letterSpacing: 0.7,
                ),
              ),
            ),
            trailing: Icon(
              emissionData['icon'] as IconData,
              color: ColorPallete.color3,
            ),
          ),
        ),
      );

      widgetList.add(listItem);
    }

    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    FlutterSliderHandler _leftHandler, _rightHandler;

    FlutterSliderHandler userHandler = FlutterSliderHandler(
      child: Material(
        type: MaterialType.canvas,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        color: ColorPallete.color4,
        elevation: 3,
        child: Container(
          padding: EdgeInsets.all(5),
          child: Icon(
            Icons.person,
            size: 25,
            color: ColorPallete.color3,
          ),
        ),
      ),
    );

    FlutterSliderHandler avgHandler = FlutterSliderHandler(
      child: Material(
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(7),
        ),
        // type: MaterialType.canvas,
        color: ColorPallete.color3,
        shadowColor: ColorPallete.cardBackground,
        elevation: 3,
        child: Container(
          padding: EdgeInsets.all(5),
          child: Icon(
            Icons.nature_people,
            size: 25,
            color: ColorPallete.color4,
          ),
        ),
      ),
    );

    List<double> _values = [roundOff(userEmission), roundOff(averageEmission)];
    Color _trackBarColor = Colors.greenAccent;
    _leftHandler = userHandler;
    _rightHandler = avgHandler;
    String _changePercentageSuffix = "less";

    double changePercent = getChangePercentage();

    if (userEmission > averageEmission) {
      _values = [roundOff(averageEmission), roundOff(userEmission)];
      _trackBarColor = Colors.red;
      _leftHandler = avgHandler;
      _rightHandler = userHandler;
      _changePercentageSuffix = "more";
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorPallete.cardBackground,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: ColorPallete.color7,
          ),
          title: Text(
            "$activityName carbon footprint",
            style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 16,
                color: ColorPallete.color7),
          ),
        ),
        backgroundColor: ColorPallete.background,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Container(
                  color: ColorPallete.cardBackground,
                  child: SizedBox(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CoolText(
                            "${roundOff(userEmission)} tonnes CO2",
                            fontSize: 22,
                            letterSpacing: 1.1,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Your carbon footprint is $changePercent% $_changePercentageSuffix than an average person",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ColorPallete.color7,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    height: MediaQuery.of(context).size.height / 3,
                    width: double.infinity,
                  ),
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      Card(
                        elevation: 2,
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        color: ColorPallete.cardBackground,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: FlutterSlider(
                            step: FlutterSliderStep(step: 0.01),
                            values: _values,
                            rangeSlider: true,
                            disabled: true,
                            min: 0,
                            // Set a max limit according to the highest value between `userEmission` & `avgEmission`
                            max: _values[1] + _values[1] / 10,
                            trackBar: FlutterSliderTrackBar(
                                activeDisabledTrackBarColor: _trackBarColor,
                                inactiveDisabledTrackBarColor:
                                    ColorPallete.color6),
                            handler: _leftHandler,
                            rightHandler: _rightHandler,
                            tooltip: FlutterSliderTooltip(
                              positionOffset:
                                  FlutterSliderTooltipPositionOffset(top: -5),
                              boxStyle: FlutterSliderTooltipBox(
                                decoration: BoxDecoration(
                                  color: ColorPallete.cardBackground,
                                ),
                              ),
                              alwaysShowTooltip: true,
                              textStyle: TextStyle(
                                fontSize: 60,
                                color: Colors.white,
                              ),
                              leftSuffix: toolTipLabel,
                              rightSuffix: toolTipLabel,
                            ),
                          ),
                        ),
                      ),
                      ...getDataGrids(
                        _changePercentageSuffix,
                        changePercent,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        thickness: 0.7,
                        color: ColorPallete.color6,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Card(
                        color: ColorPallete.cardBackground,
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.pushNamed(
                                context, ReduceEmissionScreen.routeName);
                          },
                          title: CoolText(
                            "Reduce carbon emissions",
                            fontSize: 18,
                            letterSpacing: 1.1,
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Text(
                              "Our earth needs it. Let's move together in this.",
                              style: TextStyle(
                                color: ColorPallete.color7,
                                fontSize: 13,
                                letterSpacing: 0.7,
                              ),
                            ),
                          ),
                          trailing: Icon(
                            Icons.nature,
                            color: ColorPallete.color3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
