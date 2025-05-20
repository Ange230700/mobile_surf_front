// lib\utils\calculate_cross_axis_count.dart

int calculateCrossAxisCount(double width) {
  if (width >= 1200) return 5;
  if (width >= 900) return 4;
  if (width >= 600) return 3;
  if (width >= 400) return 2;
  return 1;
}
