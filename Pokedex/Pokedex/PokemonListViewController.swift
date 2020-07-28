import UIKit

class PokemonListViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    var pokemon: [PokemonListResult] = []
    var pokemonFilterd: [PokemonListResult] = []

    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let entries = try JSONDecoder().decode(PokemonListResults.self, from: data)
                self.pokemon = entries.results
                self.pokemonFilterd = entries.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonFilterd.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath)
        cell.textLabel?.text = capitalize(text: pokemonFilterd[indexPath.row].name)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPokemonSegue",
                let destination = segue.destination as? PokemonViewController,
                let index = tableView.indexPathForSelectedRow?.row {
            destination.url = pokemonFilterd[index].url
            destination.catchedName = pokemonFilterd[index].name
        }
    }
}

extension PokemonListViewController : UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      // implement your search here!
        guard !searchText.isEmpty else {
            pokemonFilterd = pokemon
            tableView.reloadData()
            return
        }
        pokemonFilterd = pokemon.filter { (PokemonListResult) -> Bool in
            PokemonListResult.name.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
        
    }
}
