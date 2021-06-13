//
//  ViewShowRepoController.swift
//  githubApi
//
//  Created by Ricardo.Junior on 13/06/21.
//

import UIKit

class ViewShowRepoController: UIViewController {
    var user: String = ""
    var repo: String = ""
    var url: String = "www.google.com"

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var IssueLabel: UILabel!
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var forkLabel: UILabel!
    @IBOutlet weak var LanguageLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerLabel.text =  repo
        // Do any additional setup after loading the view.
        getRepository(user: user, repo: repo){ repositoryReponse in
            print(repositoryReponse)
            DispatchQueue.main.async {
                
                if let date = repositoryReponse.created_at {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                    let dateFormatted = dateFormatter.date(from: date)
                    
                    let newDateFormatter = DateFormatter()
                    newDateFormatter.dateFormat = "dd/MM/yyyy"
                    let stringDate = newDateFormatter.string(from: dateFormatted!)
                    
                    self.DateLabel.text = stringDate
                }
                else{
                    self.DateLabel.text = "-"
                }
                
                self.starLabel.text = String(repositoryReponse.stargazers_count ?? 0) + " ★"
                self.DescriptionLabel.text = repositoryReponse.description ?? "-"
                self.LanguageLabel.text = repositoryReponse.language ?? "-"
                self.IssueLabel.text = "Issues abertas: " + String(repositoryReponse.open_issues_count ?? 0)
                self.url = repositoryReponse.html_url ?? "www.google.com"
                self.forkLabel.text = "Forks: " + String(repositoryReponse.forks_count ?? 0)
           }
        }
    }
    
    
    // Parar chamadas e voltar
    @IBAction func backButton(_ sender:Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Chamar repositorio para atribuir dados
    func getRepository(user: String, repo: String, completed: @escaping(RepositoryDetails) -> Void){
        if let url = URL(string: "https://api.github.com/repos/" + user + "/" + repo) {
            print(url)
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                 do {
                    print(data)
                    let response = try JSONDecoder().decode(RepositoryDetails.self, from: data)
                    completed(response)
                 } catch let error {
                    print(error)
                 }
               }
           }.resume()
        }
    }
    
    @IBAction func openLink(sender: AnyObject) {
        if let url = URL(string: self.url) {
            if #available(iOS 10, *){
                UIApplication.shared.open(url)
            }else{
                UIApplication.shared.openURL(url)
            }
        }
    }
}


struct RepositoryDetails: Codable {
    let id: Int?
    let name: String?
    let html_url: String?
    let created_at: String?
    let description: String?
    let forks_count: Int?
    let open_issues_count: Int?
    let language: String?
    let stargazers_count: Int?
}
