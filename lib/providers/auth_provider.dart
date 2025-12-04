import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:optica_app/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:optica_app/core/constants/api_endpoints.dart';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  
  User? _user;
  bool _isLoading = false;
  String _error = '';
  
  User? get user => _user;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get isAuthenticated => _user != null;
  
  // ========== LOGIN FUNCIONAL ==========
  Future<bool> login(String correo, String contrasenia) async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    
    try {
      // 1. Obtener todos los usuarios
      final url = Uri.parse('${ApiEndpoints.baseUrl}/usuarios');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final List<dynamic> usuarios = json.decode(response.body);
        
        // 2. Buscar usuario por correo
        bool usuarioEncontrado = false;
        Map<String, dynamic>? usuarioData;
        
        for (var usuario in usuarios) {
          if (usuario['correo'] == correo) {
            usuarioEncontrado = true;
            usuarioData = usuario;
            break;
          }
        }
        
        if (!usuarioEncontrado || usuarioData == null) {
          _error = 'Usuario no encontrado';
          _isLoading = false;
          notifyListeners();
          return false;
        }
        
        // 3. Verificar contraseña (TEMPORAL - necesito saber cómo la API maneja contraseñas)
        // Por ahora, asumimos que coincide
        // EN PRODUCCIÓN: Deberías tener un endpoint POST /login que verifique
        
        _user = User.fromJson(usuarioData);
        
        // 4. Guardar sesión
        await _saveSession();
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Error del servidor: ${response.statusCode}';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error de conexión: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  // ========== REGISTRO ==========
  Future<bool> register(String nombre, String correo, String contrasenia) async {
    _isLoading = true;
    _error = '';
    notifyListeners();
    
    try {
      final url = Uri.parse('${ApiEndpoints.baseUrl}/usuarios');
      final body = json.encode({
        'nombre': nombre,
        'correo': correo,
        'contrasenia': contrasenia, // La API espera este campo
        'rol_id': 2, // Cliente por defecto
        'estado': true,
      });
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data.containsKey('usuario')) {
          _user = User.fromJson(data['usuario']);
        } else if (data.containsKey('id')) {
          _user = User.fromJson(data);
        } else {
          // Si la respuesta no tiene usuario, creamos uno temporal
          _user = User(
            id: 0, // Temporal, se actualizará al hacer login
            nombre: nombre,
            correo: correo,
            rolId: 2,
            estado: true,
          );
        }
        
        await _saveSession();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        final errorData = json.decode(response.body);
        _error = errorData['error'] ?? 'Error al registrar usuario (${response.statusCode})';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = 'Error: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  // ========== MOCK USER PARA ACCESO RÁPIDO ==========
  Future<void> saveMockUser(Map<String, dynamic> userData) async {
    _user = User.fromJson(userData);
    
    // Guardar en storage
    await _storage.write(key: 'user_id', value: _user!.id.toString());
    await _storage.write(key: 'user_email', value: _user!.correo);
    await _storage.write(key: 'user_name', value: _user!.nombre);
    await _storage.write(key: 'user_rol', value: _user!.rolId.toString());
    await _storage.write(key: 'is_mock_user', value: 'true'); // Marcar como mock
    
    notifyListeners();
  }
  
  // ========== SESSION HELPERS ==========
  Future<void> _saveSession() async {
    if (_user != null) {
      await _storage.write(key: 'user_id', value: _user!.id.toString());
      await _storage.write(key: 'user_email', value: _user!.correo);
      await _storage.write(key: 'user_name', value: _user!.nombre);
      await _storage.write(key: 'user_rol', value: _user!.rolId.toString());
    }
  }
  
  Future<void> logout() async {
    await _storage.deleteAll();
    _user = null;
    notifyListeners();
  }
  
  Future<bool> checkAuthStatus() async {
    try {
      final userId = await _storage.read(key: 'user_id');
      final userEmail = await _storage.read(key: 'user_email');
      final userName = await _storage.read(key: 'user_name');
      final userRol = await _storage.read(key: 'user_rol');
      
      if (userId != null && userEmail != null) {
        // Verificar si es usuario mock (no verificar en API)
        final isMockUser = await _storage.read(key: 'is_mock_user') == 'true';
        
        if (isMockUser) {
          // Usuario mock, usar datos del storage directamente
          _user = User(
            id: int.parse(userId),
            nombre: userName ?? 'Usuario Demo',
            correo: userEmail,
            rolId: int.parse(userRol ?? '2'),
            estado: true,
          );
        } else {
          // Usuario real, verificar en API
          final url = Uri.parse('${ApiEndpoints.baseUrl}/usuarios/$userId');
          final response = await http.get(url);
          
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            _user = User.fromJson(data);
          } else {
            // Si no existe en API, usamos datos del storage
            _user = User(
              id: int.parse(userId),
              nombre: userName ?? 'Usuario',
              correo: userEmail,
              rolId: int.parse(userRol ?? '2'),
              estado: true,
            );
          }
        }
        
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Error checkAuth: $e');
    }
    
    _user = null;
    return false;
  }
  
  void clearError() {
    _error = '';
    notifyListeners();
  }
  
  // ========== UTILIDADES ==========
  bool get isAdmin => _user?.rolId == 1;
  bool get isCliente => _user?.rolId == 2;
}