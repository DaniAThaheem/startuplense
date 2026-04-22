import 'package:get/get.dart';
import '../../../core/services/auth_services.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  // ✅ No navigation here anymore — splash owns the timing
  // onReady() removed intentionally

  String get initialRoute {
    final user = _authService.getCurrentUser();
    return user != null ? '/main' : '/login';
  }
}