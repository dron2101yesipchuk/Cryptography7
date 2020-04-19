//
//  ViewController.swift
//  CryptoLab7
//
//  Created by Dron on 10.04.2020.
//  Copyright © 2020 com.dron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //об'єкти полей вводу логіну та паролю
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    //функція життєдіяльності екрану, викликається коли екран показується користувачу
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //Функція, яка тригериться при натисканні на кнопку "Without authorization"
    @IBAction func actionWithAuthorization(_ sender: UIButton) {
        //перевірка і отримання логіну та паролю з відповідних полей
        if let login = self.loginTextField.text, let password = self.passwordTextField.text {
            Networking.shared.getDataWithAuthorization(username: login, password: password, success: { info in
                var string = ""
                for infoItem in info {
                    string.append("\(infoItem.getInfo())\n")
                }
                DispatchQueue.main.async {
                    UIAlertController.showMessage(from: self, message: (title: "DATA:", body: "\(string)"))
                }
                
            }) { (error) in
                DispatchQueue.main.async {
                    UIAlertController.showAnonError(from: self)
                }
                
            }
        }
    }
    
    //Функція, яка тригериться при натисканні на кнопку "Without authorization"
    @IBAction func actionWithoutAuthorization(_ sender: UIButton) {
        Networking.shared.getDataWithoutAuthorization(success: { info in
            var string = ""
            for infoItem in info {
                string.append("\(infoItem.getInfo())\n")
            }
            DispatchQueue.main.async {
                UIAlertController.showMessage(from: self, message: (title: "DATA:", body: "\(string)"))
            }
        }) { (error) in
            DispatchQueue.main.async {
                UIAlertController.showAnonError(from: self)
            }
        }
    }

}
//розширення системного класу для створення діалогових вікон з допоміжними методами для відображення даних та помилок
extension UIAlertController {
    
    class func showMessage(from vc: UIViewController, message: (title: String, body: String)) {
        let alert = UIAlertController(title: message.title, message: message.body, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(
            UIAlertAction(title: "👍🏻", style: UIAlertAction.Style.destructive, handler: { _ in
                
            })
        )
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    class func showAnonError(from vc: UIViewController) {
        let alert = UIAlertController(title: "Getting data error", message: "Provide login and password", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(
            UIAlertAction(title: NSLocalizedString("ОК", comment: ""), style: UIAlertAction.Style.destructive, handler: { _ in
                
            })
        )
        
        vc.present(alert, animated: true, completion: nil)
    }
}

