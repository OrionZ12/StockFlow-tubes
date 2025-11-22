package com.example.tubes

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import androidx.activity.result.ActivityResultLauncher
import com.firebase.ui.auth.AuthUI
import com.firebase.ui.auth.FirebaseAuthUIActivityResultContract
import com.firebase.ui.auth.data.model.FirebaseAuthUIAuthenticationResult
import com.google.firebase.auth.FirebaseAuth

class MainActivity : FlutterActivity() {
    private lateinit var signInLauncher: ActivityResultLauncher<Intent>

    override fun onStart() {
        super.onStart()
        // Initialize the ActivityResultLauncher
        signInLauncher = registerForActivityResult(
            FirebaseAuthUIActivityResultContract(),
        ) { res ->
            this.onSignInResult(res)
        }
    }

    private fun onSignInResult(result: FirebaseAuthUIAuthenticationResult) {
        val response = result.idpResponse
        if (result.resultCode == RESULT_OK) {
            // Successfully signed in
            val user = FirebaseAuth.getInstance().currentUser
            // User is now signed in
            // You can send the user data to Flutter or perform other operations
            android.util.Log.d("MainActivity", "User signed in: ${user?.email}")
        } else {
            // Sign in failed. If response is null the user canceled the
            // sign-in flow using the back button. Otherwise check
            // response.getError().getErrorCode() and handle the error.
            if (response == null) {
                // User pressed back button
                android.util.Log.d("MainActivity", "Sign-in canceled by user")
                return
            }
            if (response.error != null) {
                // Handle specific error codes
                val errorCode = response.error?.errorCode
                val errorMessage = response.error?.message ?: "Unknown error"
                android.util.Log.e("MainActivity", "Sign-in error [$errorCode]: $errorMessage")
                
                // You can handle specific errors here
                when (errorCode) {
                    com.firebase.ui.auth.ErrorCodes.ERROR_NO_NETWORK -> {
                        android.util.Log.e("MainActivity", "No network connection")
                    }
                    com.firebase.ui.auth.ErrorCodes.ERROR_USER_DISABLED -> {
                        android.util.Log.e("MainActivity", "User account disabled")
                    }
                    com.firebase.ui.auth.ErrorCodes.ERROR_INVALID_CREDENTIAL -> {
                        android.util.Log.e("MainActivity", "Invalid credentials")
                    }
                    else -> {
                        android.util.Log.e("MainActivity", "Error: $errorMessage")
                    }
                }
            }
        }
    }

    fun startSignInFlow() {
        // Create and configure providers
        val providers = arrayListOf(
            AuthUI.IdpConfig.EmailBuilder().build(),
            AuthUI.IdpConfig.PhoneBuilder().build(),
            AuthUI.IdpConfig.GoogleBuilder().build(),
        )

        // Create and launch sign-in intent
        val signInIntent = AuthUI.getInstance()
            .createSignInIntentBuilder()
            .setAvailableProviders(providers)
            .build()

        signInLauncher.launch(signInIntent)
    }
}
