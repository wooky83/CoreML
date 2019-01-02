//
//  MainVC.swift
//  MachineLearning
//
//  Created by wooky83 on 21/12/2018.
//  Copyright © 2018 wooky. All rights reserved.
//

import UIKit

class MainVC: BaseVC {

    @IBOutlet weak var mainTable: UITableView!
    
    let items: [(title: String, idf: String, data: Any?)] = [
        (title: "Places205-GoogLeNet", idf: "ViewController", data: GoogLeNetPlaces().model),
        (title: "MobileNet", idf: "ViewController", data: MobileNet().model),
        (title: "Natural Language Framework", idf: "NLPVC", data: nil)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}


extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CS", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }
}

extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: items[indexPath.row].idf) as? BaseVC {
            vc.segueData = items[indexPath.row].data
            vc.title = items[indexPath.row].title
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

class BaseVC: UIViewController {
    var segueData: Any?
}
