class GetPlayBackData {
  static double getPlaybackSpeedValue(String label) {
    switch (label) {
      case '0.5x':
        return 0.5;
      case '0.8x':
        return 0.8;
      case '1.0x':
        return 1.0;
      case '1.5x':
        return 1.5;
      case '2.0x':
        return 2.0;
      default:
        return 1.0;
    }
  }

  static String getPlaybackSpeedLabel(double speed) {
    switch (speed) {
      case 0.5:
        return '0.5x';
      case 0.8:
        return '0.8x';
      case 1.0:
        return '1.0x';
      case 1.5:
        return '1.5x';
      case 2.0:
        return '2.0x';
      default:
        return 'Normal';
    }
  }
}
