import 'package:todo/utils/exports.dart';

class LoginProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    _setLoading(true);

    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      String userEmail = userCredential.user?.email ?? '';
      String userId = userCredential.user!.uid;
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        String name = userDoc['name'] ?? 'No name';
        String email = userDoc['email'] ?? 'No email';
        UserAuth user = UserAuth(id: userId, name: name, email: email);
        await Provider.of<UserAuthProvider>(
          context,
          listen: false,
        ).saveUserData(user);
        _setLoading(false);
        Utils.flushbarSuccessMessage('Welcome back, ${user.name}!', context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TodosPage()),
        );
      } else {
        _setLoading(false);
        Utils.flushbarErrorMessage('User data not found in Firestore', context);
      }
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      String errorMessage = 'Login failed. Please try again.';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Incorrect password.';
      }
      Utils.flushbarErrorMessage(errorMessage, context);
    } catch (e) {
      _setLoading(false);
      Utils.flushbarErrorMessage('An error occurred: ${e.toString()}', context);
    }
  }

  Future<void> logout(BuildContext context) async {
    _setLoading(true);

    try {
      await _firebaseAuth.signOut();

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('id');
      await prefs.remove('name');
      await prefs.remove('email');

      // await Provider.of<UserAuthProvider>(context, listen: false).logout();

      _setLoading(false);

      Utils.flushbarSuccessMessage(
        'You have been logged out successfully!',
        context,
      );

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.login,
          (route) => false,
        );
      });
    } catch (e) {
      _setLoading(false);
      Utils.flushbarErrorMessage(
        'An error occurred while logging out: ${e.toString()}',
        context,
      );
    }
  }
}
