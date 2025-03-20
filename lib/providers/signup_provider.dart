import 'package:todo/utils/exports.dart';

class SignupProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signup(
    String email,
    String password,
    String name,
    BuildContext context,
  ) async {
    _setLoading(true);

    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'createdAt': Timestamp.now(),
      });

      UserAuth newUser = UserAuth(
        id: userCredential.user!.uid,
        name: name,
        email: email,
      );
      Provider.of<UserAuthProvider>(
        context,
        listen: false,
      ).saveUserData(newUser);

      _setLoading(false);
      Utils.flushbarSuccessMessage('Welcome, $name!', context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TodosPage()),
      );
    } on FirebaseAuthException catch (e) {
      _setLoading(false);
      String errorMessage = 'Signup failed. Please try again.';
      if (e.code == 'email-already-in-use') {
        errorMessage =
            'The email is already in use. Please use a different email.';
      } else if (e.code == 'weak-password') {
        errorMessage =
            'The password is too weak. Please use a stronger password.';
      }
      Utils.flushbarErrorMessage(errorMessage, context);
    } catch (e) {
      _setLoading(false);
      Utils.flushbarErrorMessage('An error occurred: ${e.toString()}', context);
    }
  }
}
