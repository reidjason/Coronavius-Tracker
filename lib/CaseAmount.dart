class CaseAmount {
  final int confirmed;
  final int deaths;
  final int recovered;

  CaseAmount({this.confirmed, this.deaths, this.recovered});

  factory CaseAmount.fromJson(Map<String, dynamic> json) {
    return CaseAmount(
      confirmed: (json['confirmed']['value']) as int,
      deaths: json['deaths']['value'] as int,
      recovered: json['recovered']['value'] as int,
    );
  }
}
