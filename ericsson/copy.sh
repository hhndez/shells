#!/bin/bash

WORKSPACE=/home/ehuhern/Repositories/KPIs/dcomwidgetlib
TEMPDIR=/home/ehuhern/temp/KPIs2/dcomwidgetlib
SRCDIR=src/dcomwidgetlib

cp $WORKSPACE/$SRCDIR/ext/RadarChart.js $TEMPDIR/$SRCDIR/ext
cp $WORKSPACE/$SRCDIR/radarChartWidget/RadarChartWidget.js $TEMPDIR/$SRCDIR/radarChartWidget/
cp $WORKSPACE/$SRCDIR/radarChartWidget/radar-chart.css $TEMPDIR/$SRCDIR/radarChartWidget/
cp $WORKSPACE/$SRCDIR/radarChartWidget/radarChartWidget.html $TEMPDIR/$SRCDIR/radarChartWidget/
