import 'package:opencv_dart/opencv_dart.dart' as cv;


class DocumentPreprocessResult {

  final cv.Mat gray;
  final cv.Mat blur;
  final cv.Mat threshold;
  final cv.Mat closed;

  const DocumentPreprocessResult({
    required this.gray,
    required this.blur,
    required this.threshold,
    required this.closed,
  });
}


class DocumentPreprocessor {

  const DocumentPreprocessor();


  DocumentPreprocessResult process(cv.Mat image) {

    final gray = cv.cvtColor(
      image,
      cv.COLOR_BGR2GRAY,
    );


    final blur = cv.gaussianBlur(
      gray,
      (5,5),
      0,
    );


    final threshold = cv.adaptiveThreshold(
      blur,
      255,
      cv.ADAPTIVE_THRESH_GAUSSIAN_C,
      cv.THRESH_BINARY_INV,
      51,
      15,
    );


    final kernel = cv.getStructuringElement(
      cv.MORPH_RECT,
      (5,5),
    );


    final closed = cv.morphologyEx(
      threshold,
      cv.MORPH_CLOSE,
      kernel,
    );


    return DocumentPreprocessResult(
      gray: gray,
      blur: blur,
      threshold: threshold,
      closed: closed,
    );
  }
}