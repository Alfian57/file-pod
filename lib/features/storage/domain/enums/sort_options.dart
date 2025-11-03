enum SortBy {
  name('name'),
  createdAt('createdAt');

  const SortBy(this.value);
  final String value;
}

enum SortOrder {
  asc('asc'),
  desc('desc');

  const SortOrder(this.value);
  final String value;
}
