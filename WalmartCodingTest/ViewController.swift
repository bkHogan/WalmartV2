//
//  ViewController.swift
//  WalmartCodingTest
//
//  Created by Brian Hogan on 3/28/24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var countries: [Country] = []
    var filteredCountries: [Country] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCountries()
        setupSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchCountries()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // Handle rotation here, for example, reload the table view to update cell layout
        tableView.reloadData()
    }
    
    func fetchCountries() {
        guard let url = URL(string: "https://gist.githubusercontent.com/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json") else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    // Display an error message to the user
                    let alert = UIAlertController(title: "Error", message: "Failed to fetch countries data. Please check your internet connection and try again later.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
                print("Error fetching data:", error ?? "Unknown error")
                return
            }
            
            do {
                let countries = try JSONDecoder().decode([Country].self, from: data)
                DispatchQueue.main.async {
                    self?.countries = countries
                    self?.filteredCountries = countries
                    self?.tableView.reloadData()
                }
            } catch {
                DispatchQueue.main.async {
                    // Display an error message to the user
                    let alert = UIAlertController(title: "Error", message: "Failed to decode countries data. Please try again later.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
                print("Error decoding JSON:", error)
            }
        }.resume()
    }
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Countries"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as? CountryTableViewCell else {
            fatalError("Unable to dequeue CountryTableViewCell")
        }
        let country = filteredCountries[indexPath.row]
        cell.configure(with: country)
        return cell
    }
}


extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Clean the search text before filtering
        let cleanedSearchText = cleanSearchText(searchText)
        
        if cleanedSearchText.isEmpty {
            filteredCountries = countries
        } else {
            let filtered = countries.filter({ $0.name.contains(cleanedSearchText) || $0.capital.contains(cleanedSearchText) })
            filteredCountries = filtered
        }
        tableView.reloadData()
    }
    
    // Helper function to clean search text
    private func cleanSearchText(_ text: String) -> String {
        // Trim leading and trailing whitespaces
        var cleanedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Remove special characters and non-alphanumeric characters
        let allowedCharacterSet = CharacterSet.alphanumerics
        cleanedText = cleanedText.components(separatedBy: allowedCharacterSet.inverted).joined()
        
        return cleanedText
    }
}

extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        if searchText.isEmpty {
            filteredCountries = countries
        } else {
            filteredCountries = countries.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.capital.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
}
