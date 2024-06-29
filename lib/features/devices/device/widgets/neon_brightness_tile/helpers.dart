int convert8BitToPercent(int value) {
  return (value / 255 * 100).toInt();
}

int convertPercentTo8Bit(double percent) {
  return (percent * 255 / 100).toInt();
}
