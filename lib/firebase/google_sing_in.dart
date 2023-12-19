import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../storage/usuario.dart' as meu_app;

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
Future<String> signInWithGoogle() async {
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  
  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User? user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        assert(user.uid == currentUser.uid);
      }

      meu_app.usuario.nome = user.displayName!;
      meu_app.usuario.email = user.email!; //Carregando e-mail

      return 'signInWithGoogle succeeded: $user';
    }
  }

  return 'signInWithGoogle failed';
}

void signOutGoogle() async{
  await googleSignIn.signOut();

  print("User Signed Out");
}
