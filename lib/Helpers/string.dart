String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
String cropText(String s, int maxLength) {
  if (s.length > maxLength){
    return s.substring(0,maxLength)+"...";
  }
  return s;
}