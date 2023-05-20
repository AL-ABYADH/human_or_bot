import './chat_partner.dart';

class User extends ChatPartner {
  @override
  final String name;
  @override
  final String id;

  User({required this.name, required this.id})
      : super(name: name, kind: 'Human', id: id);
}
