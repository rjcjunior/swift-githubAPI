import UIKit

class ViewRepositoriesController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var user: String = ""
    var repositories: [Repository] = []
    var tappedIndexPath: IndexPath?
    let statusNotFound: String = "Não retornou resultados"
    let statusLoading: String = "Carregando..."
    let statusSearched: String = "Repositórios"

    @IBOutlet weak var imageUse: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelHeader: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelStatus.text = self.statusLoading
        labelHeader.text = user
        tableView.delegate = self
        tableView.dataSource = self
                
        getRepositories(user: user){ repositoriesReponse in
            self.repositories = repositoriesReponse
            DispatchQueue.main.async {

                if(repositoriesReponse.count <= 0){
                    self.labelStatus.text = self.statusNotFound
                }
                else{
                    self.labelStatus.text = self.statusSearched
                    if let url = URL(string: (self.repositories[0].owner?.avatar_url)!){
                        let data = try? Data(contentsOf: url)
                        self.imageUse.image = UIImage(data: data!)
                    }
                }
                
                self.tableView.reloadData()
           }
        }
    }
    
    //definir numeros de linhas
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    //comportamento da celula
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell", for: indexPath) as! RepoTableViewCell
        
        cell.repository = repositories[indexPath.row]
        
        cell.didButtonTapAction = {
            () in
            print("Button was tapped in cell at:", indexPath)

            self.tappedIndexPath = indexPath
            self.performSegue(withIdentifier: "gotShowRepoDetails" , sender: self)
        }

        
        return cell
    }
    
    // Parar chamadas e voltar
    @IBAction func backButton(_ sender:Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // Chamar repositorio para atribuir dados
    func getRepositories(user: String, completed: @escaping([Repository]) -> Void){
        if let url = URL(string: "https://api.github.com/users/" + user + "/repos") {
            print("https://api.github.com/users/" + user + "/repos")
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                 do {
                    let response = try JSONDecoder().decode([Repository].self, from: data)
                    completed(response)
                 } catch let error {
                    self.labelStatus.text = self.statusNotFound
                    print(error)
                 }
               }
           }.resume()
        }
    }
    
    //Enviar dados para proxima tela
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "gotShowRepoDetails" {
            if let vc = segue.destination as? ViewShowRepoController {
                vc.repo = self.repositories[self.tappedIndexPath?.row ?? 0].name ?? ""
                vc.user = user
            }

        }

    }
}

struct Repository: Codable {
    let id: Int?
    let name: String?
    let description: String?
    let owner: Owner?
}

struct Owner: Codable {
    let avatar_url: String?
    let login: String?
}
