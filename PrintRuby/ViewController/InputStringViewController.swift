//
//  InputStringViewController.swift
//  PrintRuby
//
//  Created by Yuki Hatanaka on 2020/01/12.
//  Copyright © 2020 fieldin0831. All rights reserved.
//

import UIKit

class InputStringViewController: UIViewController {

    @IBOutlet weak var wordTableView: UITableView!
    @IBOutlet weak var inputWordTextView: CustomTextView!
    @IBOutlet weak var wordCountLabel: UILabel!
    @IBOutlet weak var convertWordButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
