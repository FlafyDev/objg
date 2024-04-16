import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:image/image.dart';
import 'package:objg/gdobject.dart';
import 'package:objg/hsv_to_gdhsv.dart';
import 'package:objg/triggers/custom.dart';

import 'gdprops.dart';

bool _isPixelColorEqual(Pixel a, Pixel b) {
  return a.a == b.a && a.r == b.r && a.g == b.g && a.b == b.b;
}

bool _isPointPositionEqual(Point a, Pixel b) {
  return a.x == b.x && a.y == b.y;
}

Point _getPixelPosition(Pixel pixel) {
  return Point(pixel.x, pixel.y);
}

class _RectangleWithColor {
  final Rectangle rectangle;
  final Color color;

  _RectangleWithColor(this.rectangle, this.color);

  @override
  String toString() {
    return 'RectangleWithColor{rectangle: $rectangle, color: $color}';
  }

  Map<String, dynamic> toJson() {
    return {
      'left': rectangle.left,
      'top': rectangle.top,
      'width': rectangle.width,
      'height': rectangle.height,
      'a': color.a,
      'r': color.r,
      'g': color.g,
      'b': color.b,
    };
  }

  factory _RectangleWithColor.fromJson(Map<String, dynamic> json) {
    return _RectangleWithColor(
      Rectangle(json['left'], json['top'], json['width'], json['height']),
      ColorInt32.rgba(json['r'], json['g'], json['b'], json['a']),
    );
  }
}

List<_RectangleWithColor> _findRectangles(Image image) {
  final List<Rectangle> rectangles = [];
  int firstNumOfRects = 0;

  while (true) {
    final allRectangles = findAllRectangle(image, rectangles);
    if (rectangles.isEmpty) firstNumOfRects = allRectangles.length;
    // print("progress: ${((1 - allRectangles.length / firstNumOfRects) * 100).toStringAsFixed(2)}");

    if (allRectangles.isEmpty) break;
    final largestRectangle = allRectangles.reduce((value, element) {
      if (value.width * value.height > element.width * element.height) {
        return value;
      }
      return element;
    });
    // print("largestRectangle: $largestRectangle");
    rectangles.add(largestRectangle);
  }
  return rectangles.map((e) {
    final color = image.getPixel(e.left.toInt(), e.top.toInt());
    return _RectangleWithColor(Rectangle(e.left, image.height - e.top - e.height, e.width, e.height), color);
  }).toList();
}

List<Rectangle> findAllRectangle(Image image, List<Rectangle> avoidRectangles) {
  final List<Rectangle> allRectangles = [];
  final Set<Point> ogVisited = {};

  for (final rect in avoidRectangles) {
    for (int x = rect.left.toInt(); x < rect.right.toInt(); x++) {
      for (int y = rect.top.toInt(); y < rect.bottom.toInt(); y++) {
        ogVisited.add(Point(x, y));
      }
    }
  }

  for (int x = 0; x < image.width; x++) {
    for (int y = 0; y < image.height; y++) {
      final pixel = image.getPixel(x, y);
      if (pixel.a == 0) continue;
      final visited = {
        ...ogVisited
      };

      if (visited.any((element) => _isPointPositionEqual(element, pixel))) continue;

      int width = 1;

      for (; width < image.width - x; width++) {
        final pixel2 = image.getPixel(x + width, y);
        if (visited.any((element) => _isPointPositionEqual(element, pixel2))) break;
        if (!_isPixelColorEqual(pixel, pixel2)) break;
        // visited.add(getPixelPosition(pixel2));

        // int h = 1;
        //
        // for (; h < image.height - y; h++) {
        //   final pixel3 = image.getPixel(x + w, y + h);
        //   if (visited.any((element) => isPointPositionEqual(element, pixel3))) break;
        //   if (!isPixelColorEqual(pixel, pixel3)) break;
        //   visited.add(getPixelPosition(pixel3));
        // }
        //
        // if (h < height) height = h;
      }
      // if (x == 2 && y == 2) print("width: $width");
      int height = image.height + 1;
      for (int w = 0; w < width; w++) {
        int h = 0;
        for (; h < image.height - y; h++) {
          final pixel3 = image.getPixel(x + w, y + h);
          if (visited.any((element) => _isPointPositionEqual(element, pixel3))) break;
          if (!_isPixelColorEqual(pixel, pixel3)) break;
          // visited.add(getPixelPosition(pixel3));
        }
        if (h < height) height = h;
        allRectangles.add(Rectangle(x, y, w + 1, height));
      }
      // if (height == image.height + 1) {
      // int h = 0;
      // for (; h < image.height - y; h++) {
      //   final pixel3 = image.getPixel(x + w - 1, y + h);
      //   if (visited.any((element) => isPointPositionEqual(element, pixel3))) break;
      //   if (!isPixelColorEqual(pixel, pixel3)) break;
      //   visited.add(getPixelPosition(pixel3));
      // }
      // if (h < height) height = h;
      // }

      // allRectangles.add(Rectangle(x, y, width, height));
    }
  }
  return allRectangles;
}

const pixelScale = 0.05526436781;
const pixelOffset = 30;

GDObject rectToGDObject(Rectangle rect, Color col, List<int> groups, double scaleX, double scaleY, double offsetX, double offsetY, int zLayer) {
  final pixelScaleX = pixelScale * scaleX;
  final pixelScaleY = pixelScale * scaleY;
  final pixelScaledOffsetX = pixelOffset * pixelScaleX;
  final pixelScaledOffsetY = pixelOffset * pixelScaleY;
  final scale = Point(rect.width * pixelScaleX, rect.height * pixelScaleY);
  final position = Point(
    rect.left * pixelScaledOffsetX + (rect.width / 2 * pixelScaledOffsetX),
    rect.top * pixelScaledOffsetY + (rect.height / 2 * pixelScaledOffsetY),
  );
  // final position = Point(center.x * pixelScale + pixelScaledOffset, center.y * pixelScale + pixelScaledOffset);
  final hsl = rgbToHsl(col.r, col.g, col.b);

  // return "1,211,2,${position.x},3,${position.y},128,${scale.x},129,${scale.y},41,1,43,${hsl[0] * 360 - (hsl[0] > 0.5 ? 360 : 0)}a${(hsl[1] - 0.5) * 2}a${(hsl[2] - 0.5) * 2}a1a1";
  position.x += offsetX;
  position.y += offsetY;
  return CustomObj(
    id: 211,
    groups: groups,
    props: {
      GDProps.objectCommonX: position.x.toString(),
      GDProps.objectCommonY: position.y.toString(),
      GDProps.objectCommonScaleX: scale.x.toString(),
      GDProps.objectCommonScaleY: scale.y.toString(),
      GDProps.objectCommonHSVEnabled: 1.toString(),
      GDProps.objectCommonHSV: hsvToGDHSV(hsl[0].toDouble(), hsl[1].toDouble(), hsl[2].toDouble()),
      GDProps.objectCommonZLayer: zLayer.toString(),
    },
  );
}

List<_RectangleWithColor> _getRectanglesCache(String id) {
  final file = File("/home/flafy/.cache/objg/rectangles/$id.json");
  if (!file.existsSync()) return [];
  final jsonStr = file.readAsStringSync();
  final List<dynamic> jsonList = json.decode(jsonStr);
  return jsonList.map((e) => _RectangleWithColor.fromJson(e)).toList();
}

void _cacheRectangles(String id, List<_RectangleWithColor> rectangles) {
  Directory("/home/flafy/.cache/objg").createSync();
  Directory("/home/flafy/.cache/objg/rectangles").createSync();

  final file = File("/home/flafy/.cache/objg/rectangles/$id.json");
  file.createSync(recursive: true);
  file.writeAsStringSync(json.encode(rectangles.map((e) => e.toJson()).toList()));
}

List<GDObject> createPixelSpriteFromFile(
  File file, {
  required List<int> groups,
  required List<int> centerGroups,
  required double x,
  required double y,
  double scaleX = 1,
  double scaleY = 1,
  int zLayer = 3, // B1
}) {
  final hash = sha256.convert(file.readAsBytesSync()).toString();
  final Image image = decodeImage(file.readAsBytesSync())!;

  List<_RectangleWithColor> rectangles = _getRectanglesCache(hash);
  if (rectangles.isEmpty) {
    rectangles = _findRectangles(image);
    // print("rectangles: ${ rectangles.length }");
    // rectangles.insert(0, _RectangleWithColor(Rectangle(0, 0, image.width, image.height), ColorInt32.rgba(0, 0, 0, 255)));
    _cacheRectangles(hash, rectangles);
  }

  x -= (pixelScale * pixelOffset * image.width * scaleX) / 2;
  y -= (pixelScale * pixelOffset * image.height * scaleY) / 2;
  // y -= (image.height * scaleY) / 2;

  List<GDObject> objs = [];
  for (final rect in rectangles) {
    objs.add(
      rectToGDObject(
        rect.rectangle,
        rect.color,
        groups,
        scaleX,
        scaleY,
        x,
        y,
        zLayer,
      ),
    );
  }
  objs.add(rectToGDObject(
    Rectangle(
      image.width / 2 - 5,
      image.height / 2 - 5,
      10,
      10,
    ),
    ColorInt32.rgba(255, 255, 0, 255),
    [
      ...groups,
      ...centerGroups,
    ],
    scaleX,
    scaleY,
    x,
    y,
    zLayer,
  ));
  return objs;
}
