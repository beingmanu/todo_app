String buildRoute(String route, Map<String, String> params) {
  String path = route;
  params.forEach((key, value) {
    path = path.replaceFirst(':$key', value);
  });
  return path;
}
