//
//  ViewController.swift
//  githubApi
//
//  Created by Ricardo.Junior on 12/06/21.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var inputText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func showRepos(_ sender: Any){
        // Enviar para prox pag
        performSegue(withIdentifier: "goToShowRepos", sender: self)
    }

    //Enviar dados para prox page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if ( segue.identifier == "goToShowRepos"){
            //verificar se existe e se posso atribuir
            if let destination = segue.destination as? ViewRepositoriesController{
                destination.user = inputText.text ?? ""
            }
        }
    }
}
