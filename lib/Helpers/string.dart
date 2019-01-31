String capitalize(String s) {
  if (s == null || s.length == 0) {
    return s;
  }
  return s[0].toUpperCase() + s.substring(1);
}

String cropText(String s, int maxLength) {
  if (s == null) {
    return s;
  }
  if (s.length > maxLength) {
    return s.substring(0, maxLength) + "...";
  }
  return s;
}

String formatDuration(Duration duration) {
  RegExp regex = RegExp(r".([0-9]*$)");
  if (duration != null) {
    return duration.toString().replaceAll(regex, '');
  }
  return "0:00:00";
}
