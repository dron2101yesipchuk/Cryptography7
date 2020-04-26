//
//  Lab8Controller.swift
//  CryptoLab7
//
//  Created by Dron on 18.04.2020.
//  Copyright © 2020 com.dron. All rights reserved.
//

import UIKit

class Lab8Controller: UIViewController {

    //об'єкти полей вводу логіну та паролю, та списку
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    //масив інформації
    var info: [Int] = []

    //функція життєдіяльності екрану, викликається коли екран показується користувачу
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func reloadData() {
        //перевірка і отримання логіну та паролю з відповідних полей
        if let login = self.loginTextField.text, let password = self.passwordTextField.text {
            //отримуємо всю доступну інформацію
            Networking.shared.getIds(username: login, password: password , success: { info in
                self.info = info
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }) { (error) in
                DispatchQueue.main.async {
                    UIAlertController.showAnonError(from: self)
                }
            }
        }
    }

    //Функція для додавання
    @IBAction func createSmthAction(_ sender: UIButton) {
        if let login = self.loginTextField.text, let password = self.passwordTextField.text {
            Networking.shared.createInfo(id: self.info.count, username: login, password: password, success: { info in
                self.info.append(info)
                DispatchQueue.main.async {
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: [IndexPath(row: self.info.count-1, section: 0)], with: .automatic)
                    self.tableView.endUpdates()
//                    self.reloadData()
                }
            }) { (error) in
                DispatchQueue.main.async {
                    UIAlertController.showMessage(from: self, message: (title: "Error", body: error))
                    self.reloadData()
                }
            }
        } else {
            UIAlertController.showAnonError(from: self)
        }
    }
    
    @IBAction func reloadAction(_ sender: UIButton) {
        self.reloadData()
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        LogService.shared.saveLogs()
    }
}

extension Lab8Controller: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.info.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath)
        cell.textLabel?.text = "\(self.info[indexPath.row])"
        return cell
    }
    
    func readInfo(login: String, password: String, id: Int) {
        Networking.shared.readInfo(id: id, username: login, password: password, success: {[unowned self] info in
            DispatchQueue.main.async {
                UIAlertController.showMessage(from: self, message: (title: "Read:", body: info.getInfo()))
            }
        }) { (error) in
            DispatchQueue.main.async {
                UIAlertController.showMessage(from: self, message: (title: "Error:", body: error))
            }
            
        }
    }
    
    //натиснення на елемент списку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = self.info[indexPath.row]
        if let login = self.loginTextField.text, let password = self.passwordTextField.text {
            self.readInfo(login: login, password: password, id: id)
        }
    }
    
    //Функція для бокових кнопок в списку для зміни інформації
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath)
        -> [UITableViewRowAction]? {
            
            let changeAction = UITableViewRowAction(style: .destructive,
              title: "Change") { (action, indexPath) in
                let id = self.info[indexPath.row]
                if let login = self.loginTextField.text, let password = self.passwordTextField.text {
                    Networking.shared.changeInfo(id: id, username: login, password: password, success: { [unowned self] info in
//                        self.readInfo(login: login, password: password, id: id)
                      }) { (error) in
                        DispatchQueue.main.async {
                            UIAlertController.showMessage(from: self, message: (title: "Error", body: error))
                        }
                    }
                }
                  
            }
            
            return [changeAction]
    }
    
}
