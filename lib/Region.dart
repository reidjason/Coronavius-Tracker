class Region {
  String provinceState;
  String countryRegion;
  int confirmed;
  int recovered;
  int deaths;
  int active;

  Region(
      {this.provinceState,
      this.countryRegion,
      this.confirmed,
      this.recovered,
      this.deaths,
      this.active});

  Region.fromJson(Map<String, dynamic> json) {
    if (json['provinceState'] == null ||
        json['provinceState'] == json['countryRegion'])
      provinceState = '';
    else
      provinceState = json['provinceState'] + ", ";
    countryRegion = json['countryRegion'];
    confirmed = json['confirmed'];
    recovered = json['recovered'];
    deaths = json['deaths'];
    active = json['active'];
  }
}
