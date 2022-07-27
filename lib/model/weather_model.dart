class CurrentCity {
  Map? request;
  Map? location;
  Map? current;

  CurrentCity(
      { this.request, this.location, this.current});

  CurrentCity.fromSnapshot(Map data) {
    request = data['request'];
    location = data['location'];
    current = data['current'];
 }
}
