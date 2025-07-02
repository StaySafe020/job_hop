import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? _user;
  bool _isEmployer = false;
  bool _isVerified = false;
  String? _username;
  String? _email;
  String? _companyName;
  String? _role;

  // Getters
  User? get user => _user;
  bool get isEmployer => _isEmployer;
  bool get isVerified => _isVerified;
  String? get username => _username;
  String? get email => _email;
  String? get companyName => _companyName;
  String? get role => _role;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _auth.authStateChanges().listen((User? firebaseUser) {
      _user = firebaseUser;
      if (_user != null) {
        _loadUserData();
      } else {
        _clearUserData();
      }
      notifyListeners();
    });
  }

  // Load user data from Firestore
  Future<void> _loadUserData() async {
    if (_user == null) return;
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(_user!.uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        _username = data?['username'] ?? _user!.email!.split('@')[0];
        _email = data?['email'] ?? _user!.email;
        _isEmployer = data?['isEmployer'] ?? false;
        _isVerified = data?['isVerified'] ?? false;
        _companyName = data?['company'];
        _role = data?['role'] ?? 'user';
      } else {
        _username = _user!.email!.split('@')[0];
        _email = _user!.email;
        _isEmployer = false;
        _isVerified = false;
        _role = 'user';
        _companyName = null;
        await _saveUserData();
      }
      notifyListeners();
    } catch (e) {
      throw AuthException('Failed to load user data: $e');
    }
  }

  // Save user data to Firestore
  Future<void> _saveUserData() async {
    if (_user == null) return;
    try {
      await _firestore.collection('users').doc(_user!.uid).set({
        'username': _username,
        'email': _email,
        'isEmployer': _isEmployer,
        'isVerified': _isVerified,
        'role': _role,
        'company': _companyName,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw AuthException('Failed to save user data: $e');
    }
  }

  // Clear user data on logout
  void _clearUserData() {
    _user = null;
    _username = null;
    _email = null;
    _isEmployer = false;
    _isVerified = false;
    _companyName = null;
    _role = null;
    notifyListeners();
  }

  // Sign up a new user
  Future<void> signUp(String email, String password, String username) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _user = result.user;
      if (_user != null) {
        _username = username.trim();
        _email = email.trim();
        _isEmployer = false;
        _isVerified = false;
        _role = 'user';
        _companyName = null;
        await _saveUserData();
        notifyListeners();
      } else {
        throw AuthException('Signup failed: No user created');
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e));
    } catch (e) {
      throw AuthException('Signup error: $e');
    }
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      _user = result.user;
      if (_user != null) {
        await _loadUserData();
        notifyListeners();
      } else {
        throw AuthException('Signin failed: No user found');
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e));
    } catch (e) {
      throw AuthException('Signin error: $e');
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw AuthException('Google Sign-In canceled by user');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential result = await _auth.signInWithCredential(credential);
      _user = result.user;
      if (_user != null) {
        await _loadUserData();
        if (_username == _user!.email!.split('@')[0]) {
          _username = googleUser.displayName?.trim() ?? _username;
          await _saveUserData();
        }
        notifyListeners();
      } else {
        throw AuthException('Google Sign-In failed: No user found');
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseAuthError(e));
    } catch (e) {
      throw AuthException('Google Sign-In error: $e');
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      _clearUserData();
    } catch (e) {
      throw AuthException('Sign out error: $e');
    }
  }

  // Request to switch to Employer mode
  Future<String> requestEmployerMode({
    required String businessEmail,
    required String companyName,
    required String companyDesc,
  }) async {
    if (_user == null) throw AuthException('Not authenticated');
    try {
      DocumentReference docRef = await _firestore.collection('employer_requests').add({
        'userId': _user!.uid,
        'username': _username,
        'email': businessEmail.trim(),
        'company': companyName.trim(),
        'description': companyDesc.trim(),
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      _isEmployer = true;
      _isVerified = false;
      _companyName = companyName.trim();
      await _firestore.collection('users').doc(_user!.uid).update({
        'isEmployer': _isEmployer,
        'isVerified': _isVerified,
        'company': _companyName,
        'companyDesc': companyDesc.trim(),
        'email': businessEmail.trim(),
      });
      notifyListeners();
      return docRef.id;
    } catch (e) {
      throw AuthException('Error requesting employer mode: $e');
    }
  }

  // Update user profile (e.g., username)
  Future<void> updateProfile({String? username, String? companyName}) async {
    if (_user == null) throw AuthException('Not authenticated');
    try {
      if (username != null) _username = username.trim();
      if (companyName != null) _companyName = companyName.trim();
      await _saveUserData();
      notifyListeners();
    } catch (e) {
      throw AuthException('Error updating profile: $e');
    }
  }

  // Listen to employer request status
  Stream<DocumentSnapshot> listenToEmployerRequest(String requestId) {
    return _firestore.collection('employer_requests').doc(requestId).snapshots();
  }

  // Update employer status after admin approval
  Future<void> updateEmployerStatus(String requestId, bool isApproved) async {
    if (_user == null) throw AuthException('Not authenticated');
    try {
      _isVerified = isApproved;
      _isEmployer = isApproved; // Only employer if verified
      await _firestore.collection('users').doc(_user!.uid).update({
        'isEmployer': _isEmployer,
        'isVerified': _isVerified,
      });
      await _firestore.collection('employer_requests').doc(requestId).update({
        'status': isApproved ? 'approved' : 'rejected',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      notifyListeners();
    } catch (e) {
      throw AuthException('Error updating employer status: $e');
    }
  }

  // Map FirebaseAuth errors to user-friendly messages
  String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'weak-password':
        return 'Password is too weak.';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}