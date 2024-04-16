// Each param is a double from 0 to 1
String hsvToGDHSV(double h, double s, double v) {
  return "${h * 360 - (h > 0.5 ? 360 : 0)}a${(s - 0.5) * 2}a${(v - 0.5) * 2}a1a1";
}
