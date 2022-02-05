//
//  ViewController.swift
//  Divisores
//
//  Created by user192546 on 2/4/22.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var numberField: UITextField!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var progressText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.numberField.delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                print("Permiso concedido")
            }else {
                print("Permiso denegado")
                print(error)
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
   
    func calculateFactors(n: Int) -> String {
        var result: String = ""
        DispatchQueue.global().async {
            
            for i in 1...n {
                guard n % i == 0  else {continue}
                result += i == 1 ? "[1" : " , \(i)"
                DispatchQueue.main.async {
                    self.progressView.setProgress(Float(i)/Float(n), animated: true)
                    self.progressText.text = "\((Float(i)/Float(n))*100)%"
                    self.resultLabel.text = "Los divisores de \(i) son \(result) ]"
                    
                }
            }
            DispatchQueue.main.async {
                print(result)
                self.showNotification(text: self.resultLabel.text ?? "")
                self.progressIndicator.stopAnimating()

            }
        }
        
        return result
    }
    
    func showNotification(text: String) {
        //Crear contenido
        let content = UNMutableNotificationContent()
        content.title = "Calculo Realizado"
        content.subtitle = "Los divisores son:"
        content.body = text
        content.sound = .default
        //Definir disparador
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        //Pedir lanzamiento
        let request = UNNotificationRequest(identifier: "idnotificacion", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            print(error)
        }
    }
    
    
    @IBAction func operation(_ sender: UIButton) {
        
        self.progressView.setProgress(0.0, animated: false)
        self.resultLabel.text = ""

        if let text = numberField.text {
             if let num = Int(text) {
                self.progressIndicator.startAnimating()
                 let factor = calculateFactors(n: num)
                 resultLabel.text = factor
                
             } else {
                resultLabel.text = "Introduce solo valores numericos"
             }
        } else {
            resultLabel.text = "Introduce algun valor numerico a calcular"
        }
        
    }
}
