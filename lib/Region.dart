class Region {
  String combinedKey;
  int confirmed;
  int recovered;
  int deaths;
  int active;

  Region({this.combinedKey,
      this.confirmed,
      this.recovered,
      this.deaths,
      this.active});

  Region.fromJson(Map<String, dynamic> json) {
    combinedKey = json['combinedKey'];
    confirmed = json['confirmed'];
    recovered = json['recovered'];
    deaths = json['deaths'];
    active = json['active'];
  }
}
