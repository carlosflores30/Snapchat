//
//  crearCuentaViewController.swift
//  FloresSnapchat
//
//  Created by Roberto Flores on 27/10/24.
//

import UIKit
import FirebaseAuth


class crearCuentaViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func crearCuentaTapped(_ sender: Any) {
        // Validar que los campos no estén vacíos
                guard let email = userNameTextField.text, !email.isEmpty,
                      let password = passwordTextField.text, !password.isEmpty else {
                    mostrarAlerta(mensaje: "Por favor, ingrese un correo y una contraseña válidos.")
                    return
                }
                
                // Crear usuario en Firebase Authentication
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        // Si ocurre un error, mostramos un mensaje de alerta
                        self.mostrarAlerta(mensaje: "Error al crear el usuario: \(error.localizedDescription)")
                        return
                    }
                    
                    // Si la cuenta fue creada exitosamente, mostrar alerta y redirigir al login
                    let alerta = UIAlertController(title: "Cuenta Creada", message: "El usuario \(email) fue creado exitosamente.", preferredStyle: .alert)
                    let btnOK = UIAlertAction(title: "OK", style: .default) { _ in
                        // Redirigir a la vista de login
                        self.performSegue(withIdentifier: "volverAlLogin", sender: nil)
                    }
                    alerta.addAction(btnOK)
                    self.present(alerta, animated: true, completion: nil)
                }

    }
    
    func mostrarAlerta(mensaje: String) {
            let alerta = UIAlertController(title: "Error", message: mensaje, preferredStyle: .alert)
            let btnOK = UIAlertAction(title: "OK", style: .default, handler: nil)
            alerta.addAction(btnOK)
            self.present(alerta, animated: true, completion: nil)
        }
}
