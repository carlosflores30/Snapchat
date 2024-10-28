//
//  ViewController.swift
//  FloresSnapchat
//
//  Created by Roberto Flores on 14/10/24.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import FirebaseDatabase

class iniciarSesionViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var googleSingInButton: UIButton!
    @IBOutlet weak var crearCuentaLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
                GIDSignIn.sharedInstance.configuration = config
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(irACrearCuenta))
                crearCuentaLabel.isUserInteractionEnabled = true
                crearCuentaLabel.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func iniciarSesionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error)  in print("Intentando Iniciar Sesion")
            if let error = error {
                            // Si hay un error, mostrar una alerta con opciones de Crear o Cancelar
                            print("Se presentó el siguiente error: \(error.localizedDescription)")
                            
                            let alerta = UIAlertController(title: "Usuario no encontrado", message: "El usuario no existe, debes crear primero una cuenta", preferredStyle: .alert)
                            
                            // Opción "Crear"
                            let btnCrear = UIAlertAction(title: "Crear", style: .default) { (UIAlertAction) in
                                // Navegar a la pantalla de creación de cuenta
                                self.performSegue(withIdentifier: "irACrearCuenta", sender: nil)
                            }
                            // Opción "Cancelar"
                            let btnCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                                
                            alerta.addAction(btnCrear)
                            alerta.addAction(btnCancelar)
                                
                            // Mostrar la alerta
                            self.present(alerta, animated: true, completion: nil)
                                
                            } else {
                                print("Inicio de sesion exitoso")
                                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
            
        }
    }
    @objc func irACrearCuenta() {
           performSegue(withIdentifier: "irACrearCuenta", sender: self)
       }
    
    @IBAction func iniciarSesionGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            if let error = error {
                print("Error durante el inicio de sesión con Google: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                print("Error: No se pudo obtener el ID token del usuario")
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Error autenticando con Firebase: \(error.localizedDescription)")
                } else {
                    print("Inicio de sesion exitoso")
                    self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                }
            }
            
        }
        
        
    }
    
}
