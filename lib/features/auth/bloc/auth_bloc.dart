import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthBloc()
    : _firebaseAuth = FirebaseAuth.instance,
      _googleSignIn = GoogleSignIn(),
      super(const AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        emit(AuthAuthenticated(userId: user.uid, email: user.email ?? ''));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onSignInRequested(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      final user = userCredential.user;
      if (user != null) {
        emit(AuthAuthenticated(userId: user.uid, email: user.email ?? ''));
      } else {
        emit(const AuthError('Login gagal'));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Email tidak ditemukan';
          break;
        case 'wrong-password':
          errorMessage = 'Password salah';
          break;
        case 'invalid-email':
          errorMessage = 'Format email tidak valid';
          break;
        case 'user-disabled':
          errorMessage = 'Akun telah dinonaktifkan';
          break;
        case 'invalid-credential':
          errorMessage = 'Email atau password salah';
          break;
        default:
          errorMessage = 'Terjadi kesalahan: ${e.message}';
      }
      emit(AuthError(errorMessage));
    } catch (e) {
      emit(AuthError('Terjadi kesalahan: ${e.toString()}'));
    }
  }

  Future<void> _onSignUpRequested(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      final user = userCredential.user;
      if (user != null) {
        emit(AuthAuthenticated(userId: user.uid, email: user.email ?? ''));
      } else {
        emit(const AuthError('Registrasi gagal'));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'Password terlalu lemah (minimal 6 karakter)';
          break;
        case 'email-already-in-use':
          errorMessage = 'Email sudah terdaftar';
          break;
        case 'invalid-email':
          errorMessage = 'Format email tidak valid';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Operasi tidak diizinkan';
          break;
        default:
          errorMessage = 'Terjadi kesalahan: ${e.message}';
      }
      emit(AuthError(errorMessage));
    } catch (e) {
      emit(AuthError('Terjadi kesalahan: ${e.toString()}'));
    }
  }

  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        emit(const AuthUnauthenticated());
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      final user = userCredential.user;
      if (user != null) {
        emit(AuthAuthenticated(userId: user.uid, email: user.email ?? ''));
      } else {
        emit(const AuthError('Google Sign In gagal'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError('Firebase error: ${e.message}'));
    } catch (e) {
      emit(AuthError('Terjadi kesalahan: ${e.toString()}'));
    }
  }

  Future<void> _onSignOutRequested(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Gagal sign out: ${e.toString()}'));
    }
  }
}
