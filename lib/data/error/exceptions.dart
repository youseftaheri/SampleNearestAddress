class ShowAddressesException implements Exception {
  String message = "er1";
  ShowAddressesException({required this.message});
}

class FindNearestAddressException implements Exception {
  String message = "er2";
  FindNearestAddressException({required this.message});
}

class AddAddressException implements Exception {
  String message = "er3";
  AddAddressException({required this.message});
}

class DeleteAddressException implements Exception {
  String message = "er4";
  DeleteAddressException({required this.message});
}

class EditAddressException implements Exception {
  String message = "er1";
  EditAddressException({required this.message});
}
