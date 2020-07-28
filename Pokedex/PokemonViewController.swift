import UIKit

class PokemonViewController: UIViewController {
    var url: String!
    var catched : [String : Bool] = [:]
    var catchedName = ""
    var id : Int?
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet weak var CatchedOutlit: UIButton!
    @IBOutlet weak var pokeImage: UIImageView!
    
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBAction func toggleCatch(_ sender: Any) {
        
        if isCatched(name: catchedName) == false {
            CatchedOutlit.setTitle("Release", for: UIControl.State.normal)
            savingCatch(name: catchedName, value: "true")
        }
        else{
            CatchedOutlit.setTitle("Catch", for: UIControl.State.normal)
            savingCatch(name: catchedName, value: "false")

        }
        
        
    }
    
    
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        DescriptionLabel.text = ""
        if isCatched(name: catchedName) == false {
            CatchedOutlit.setTitle("Catch", for: UIControl.State.normal)
        }
        else{
            
            CatchedOutlit.setTitle("Release", for: UIControl.State.normal)

        }


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        nameLabel.text = ""
        numberLabel.text = ""
        type1Label.text = ""
        type2Label.text = ""

        loadPokemon()
    }

    func loadPokemon() {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data else {
                return
            }

            do {
                let result = try JSONDecoder().decode(PokemonResult.self, from: data)
                DispatchQueue.main.async {
                    self.navigationItem.title = self.capitalize(text: result.name)
                    self.nameLabel.text = self.capitalize(text: result.name)
                    self.numberLabel.text = String(format: "#%03d", result.id)
                    self.id = result.id
                    
                     let urlString = result.sprites.front_default
                        let imageURL = URL(string: urlString)
                        do {
                        let imageData = try Data(contentsOf: imageURL!)
                        self.pokeImage.image = UIImage(data: imageData)
                        }
                        catch let error {
                            print(error)
                        }


                    

                    for typeEntry in result.types {
                        if typeEntry.slot == 1 {
                            self.type1Label.text = typeEntry.type.name
                        }
                        else if typeEntry.slot == 2 {
                            self.type2Label.text = typeEntry.type.name
                        }
                    }
                }
                
                
                let descURL = URL(string: "https://pokeapi.co/api/v2/pokemon-species/\(result.id)")
                print(descURL!)
                URLSession.shared.dataTask(with: descURL!) { (data, response, error) in
                    
                    guard let data = data else{return}
                    do{
                    let result = try JSONDecoder().decode(PokemonDescription.self, from: data)
                        DispatchQueue.main.async {

                        self.DescriptionLabel.text = result.flavor_text_entries[0].flavor_text
                        }
                    }
                    catch let error {
                        
                        print(error)
                        
                    }
                    
                    
                    
                    
                }.resume()
                
                
            }
            catch let error {
                print(error)
            }
            
            
            
            

            
        }.resume()
    }
    
    func savingCatch (name : String , value : String){
        
        UserDefaults.standard.set(value, forKey: name)
        
    }
    
    func isCatched(name : String) -> Bool{
        
        if let course = UserDefaults.standard.string(forKey: name) {
            if course == "true" {
                return true
            }
        }
        return false
    }
    
    
}

