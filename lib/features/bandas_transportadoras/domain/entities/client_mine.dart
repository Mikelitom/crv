class Client {
  final String id;
  final String name;
  final String company;
  Client({required this.id, required this.name, required this.company});
}

class Mine {
  final String id;
  final String clientId;
  final String name;
  final String address;
  Mine({required this.id, required this.clientId, required this.name, required this.address});
}