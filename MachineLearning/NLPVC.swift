//
//  NLPVC.swift
//  MachineLearning
//
//  Created by wooky83 on 21/12/2018.
//  Copyright © 2018 wooky. All rights reserved.
//

import UIKit
import NaturalLanguage

class NLPVC: BaseVC {

    @IBOutlet weak var inputTxF: UITextField!
    @IBOutlet weak var resultLb: UILabel!
    @IBOutlet weak var tokenTxf: UITextField!
    @IBOutlet weak var tokenResultLb: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        recognizer(str: inputTxF.text)
        tokenzier(str: tokenTxf.text)
    }
    
    @IBAction func langBtnClicked(_ sender: UIButton) {
        recognizer(str: inputTxF.text)
    }
    
    @IBAction func tokenBtnClicked(_ sender: UIButton) {
        tokenzier(str: tokenTxf.text)
    }
    
    private func recognizer(str: String?) {
        guard let str = str else {return}
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(str)
        let lang = recognizer.dominantLanguage
        let hypotheses = recognizer.languageHypotheses(withMaximum: 2)
        
        print(hypotheses)
        resultLb.text = lang?.rawValue
    }
    
    private func tokenzier(str: String?) {
        guard let str = str else {return}
        let tokenizer = NLTokenizer(unit: .word)
        let strRange = str.startIndex ..< str.endIndex
        tokenizer.string = str
        let tokenArray = tokenizer.tokens(for: strRange)
        let tokens = tokenArray.reduce("") {
            $0 + str[$1] + ","
        }
        tokenResultLb.text = String(tokens.dropLast())
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
