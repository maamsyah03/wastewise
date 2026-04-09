String capitalize(String? title) {
  if (title == null || title.isEmpty) return '';
  return title[0].toUpperCase() + title.substring(1);
}