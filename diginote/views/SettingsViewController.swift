//
//  SettingsViewController.swift
//  diginote
//
//  Created by Sayed Jahed Hussini on 12/2/21.
//

import UIKit

struct Section {
    let title: String
    let options: [SettingsOptionType]
}

enum SettingsOptionType {
    case staticCell(model: SettingsOption)
    case switchCell(model: SettingsSwitchOption)
}

struct SettingsSwitchOption{
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
    let isOn: Bool
}

struct SettingsOption{
    
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
}

class SettingsViewController: UITableViewController {
    var models = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SettingsCell.self , forCellReuseIdentifier: "SettingsCell")
        tableView.register(SettingsSwitchViewCell.self, forCellReuseIdentifier: "SettingsSwitchViewCell")
        configure()
    }

    func configure(){
        let myColor = UIColor(red: 1/255.0, green: 4/255.0, blue: 73/255.0, alpha: 1)
        
        self.models.append(Section(title: "Appearance", options: [
            .switchCell(model: SettingsSwitchOption(title: "Dark Theme", icon: UIImage(systemName: "airplane"), iconBackgroundColor: myColor, handler: {
                
            }, isOn: true )),
            .switchCell(model: SettingsSwitchOption(title: "Fingerprint or Facelock", icon: UIImage(systemName: "airplane"), iconBackgroundColor: myColor, handler: {
                
            }, isOn: true )),
            .switchCell(model: SettingsSwitchOption(title: "Mobile data usage", icon: UIImage(systemName: "airplane"), iconBackgroundColor: myColor, handler: {
                
            }, isOn: true )),
            .staticCell(model: SettingsOption(title: "About", icon: UIImage(systemName: "house"), iconBackgroundColor: myColor) {
            
            })
        ]))
        
//        self.models.append(Section(title: "Account", options: [
//            .staticCell(model: SettingsOption(title: "Theme", icon: UIImage(systemName: "house"), iconBackgroundColor: .systemPink) {
//
//            })
//            .staticCell(model: SettingsOption(title: "Theme", icon: UIImage(systemName: "house"), iconBackgroundColor: .systemPink) {
//
//            })
//        ]))
    }
    // MARK: - Table view data source


    override func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return models[section].options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        
        switch model.self {
        case .staticCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as? SettingsCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
            
        case .switchCell(let model):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsSwitchViewCell", for: indexPath) as? SettingsSwitchViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        }
        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as? SettingsCell else {
//            return UITableViewCell()
//        }
//
//        cell.configure(with: model)
//
//        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true )
        let type = models[indexPath.section].options[indexPath.row]
//        model.handler()
        switch type.self {
        case .staticCell(let model):
            model.handler()
        case .switchCell(let model):
            model.handler()
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
}
