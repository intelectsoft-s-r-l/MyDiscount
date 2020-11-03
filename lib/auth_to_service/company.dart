abstract class Company {
  final String logo;
  final String name;
  final int id;
  final String amount;

  Company({
    this.logo,
    this.name,
    this.id,
    this.amount,
  })  : assert(name != null),
        assert(id != null);
}

