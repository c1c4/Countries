//
//  ViewController.swift
//  countries
//
//  Created by Felipe Arado Pompeu on 06/08/2018.
//  Copyright © 2018 Felipe Arado Pompeu. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    fileprivate let cellId = "cellId"
    //Array of type Article to store articles data after parsing JSON
    var countries:[Country]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let urlString = "https://restcountries.eu/rest/v2/all"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            do {
                //Decode retrived data with JSONDecoder and assing type of Article object
                let countriesData = try JSONDecoder().decode([Country].self, from: data)
                
                //Get back to the main queue
                DispatchQueue.main.async {
                    self.countries = countriesData
                    self.tableView.reloadData()
                }
                
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath)
        
        let country = self.countries![indexPath.row]
        
        let countryName : UILabel = cell.contentView.viewWithTag(10) as! UILabel
        countryName.text = country.name;
        
        let countryCurrency : UILabel = cell.contentView.viewWithTag(20) as! UILabel
        let dicCurrency = country.currencies.first
        countryCurrency.text = dicCurrency?["name"]!
        
        let countryLanguage : UILabel = cell.contentView.viewWithTag(30) as! UILabel
        let dicLanguage = country.languages.first
        countryLanguage.text = dicLanguage?["name"]!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            self.countries!.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print(self.countries as Any)
        }
    
        delete.backgroundColor = .purple
//        delete.backgroundColor = UIColor(patternImage: self.image())
        
        
        return [delete]
        
    }
    
    func image() -> UIImage {
        let backView = UIView(frame: CGRect(x: 0, y: 0, width:1038 , height: 74))
        backView.backgroundColor = .purple
        
        let myImage = UIImageView(frame: CGRect(x: 10, y: 5, width: 70, height: 54))
        myImage.image = UIImage(named: "deleteIcon")
        backView.addSubview(myImage)
        
        
        let imgSize: CGSize = CGSize(width: 1038, height: 74)
        UIGraphicsBeginImageContextWithOptions(imgSize, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        backView.layer.render(in: context!)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

