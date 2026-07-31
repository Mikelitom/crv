import 'dart:math';

import 'package:crv_reprosisa/features/ocr/data/detectors/report_region_detector.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

class PerspectiveTransformer {
  const PerspectiveTransformer();

  cv.Mat transform(
    cv.Mat image,
    ReportRegion region,
  ) {
  
    print("===== ESQUINAS DETECTADAS =====");
  
    print("Total: ${region.corners.length}");
  
    for (int i = 0; i < region.corners.length; i++) {
      print("Corner $i: ${region.corners[i]}");
    }
  
    final orderedCorners = _orderCorners(
      region.corners,
    );

    print("===== LISTA ORDENADA =====");
    
    for (int i = 0; i < orderedCorners.length; i++) {
      print("Corner $i -> ${orderedCorners[i]}");
    }

    final topLeft = orderedCorners[0];
    final topRight = orderedCorners[1];
    final bottomRight = orderedCorners[2];
    final bottomLeft = orderedCorners[3];

    final widthTop = _distance(
      topLeft,
      topRight,
    );
    
    final widthBottom = _distance(
      bottomLeft,
      bottomRight,
    );
    
    final heightLeft = _distance(
      topLeft,
      bottomLeft,
    );
    
    final heightRight = _distance(
      topRight,
      bottomRight,
    );
    
    final width = max(widthTop, widthBottom).round();
    final height = max(heightLeft, heightRight).round();
    
    print("===== TAMAÑO DESTINO =====");
    print("Width : $width");
    print("Height: $height");

    final srcPoints = cv.VecPoint.fromList([
      orderedCorners[0],
      orderedCorners[1],
      orderedCorners[2],
      orderedCorners[3],
    ]);
    
    final dstPoints = cv.VecPoint.fromList([
      cv.Point(0, 0),
      cv.Point(width - 1, 0),
      cv.Point(width - 1, height - 1),
      cv.Point(0, height - 1),
    ]);
    
    final matrix = cv.getPerspectiveTransform(
      srcPoints,
      dstPoints,
    );

    final warped = cv.warpPerspective(
      image,
      matrix,
      (
        width,
        height,
      ),
    );
  
    return warped;
  }

  List<cv.Point> _orderCorners(
    List<cv.Point> corners,
  ) {
    final points = <cv.Point>[];
  
    for (int i = 0; i < corners.length; i++) {
      points.add(corners[i]);
    }
  
    cv.Point? topLeft;
    cv.Point? topRight;
    cv.Point? bottomRight;
    cv.Point? bottomLeft;
  
    int minSum = 1 << 30;
    int maxSum = -(1 << 30);
  
    for (final point in points) {
      final sum = point.x + point.y;
  
      if (sum < minSum) {
        minSum = sum;
        topLeft = point;
      }
  
      if (sum > maxSum) {
        maxSum = sum;
        bottomRight = point;
      }
    }
  
    int minDiff = 1 << 30;
    int maxDiff = -(1 << 30);
  
    for (final point in points) {
      final diff = point.x - point.y;
  
      if (diff < minDiff) {
        minDiff = diff;
        bottomLeft = point;
      }
  
      if (diff > maxDiff) {
        maxDiff = diff;
        topRight = point;
      }
    }
  
    print("===== ESQUINAS ORDENADAS =====");
    print("Top Left     : $topLeft");
    print("Top Right    : $topRight");
    print("Bottom Right : $bottomRight");
    print("Bottom Left  : $bottomLeft");
  
    return [
      topLeft!,
      topRight!,
      bottomRight!,
      bottomLeft!,
    ];
  }

  double _distance(
    cv.Point p1,
    cv.Point p2,
  ) {
    final dx = (p1.x - p2.x).toDouble();
    final dy = (p1.y - p2.y).toDouble();
  
    return sqrt(dx * dx + dy * dy);
  }
}