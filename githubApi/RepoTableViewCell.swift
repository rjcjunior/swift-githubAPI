import UIKit

class RepoTableViewCell: UITableViewCell {

    @IBOutlet weak var labelCell: UILabel!
    @IBOutlet weak var descriptionCell: UILabel!
    var didButtonTapAction : (()->())?

    //escrevendo celula
    var repository: Repository? {
        didSet {
            guard let repository = repository else { return }
            
            labelCell.text = repository.name
            descriptionCell.text = repository.description
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //disparar funcao para levar para detalhes
    @IBAction func cellButtonTap(_ sender: UIButton) {
        didButtonTapAction!()
    }
}
