//
//  WordGameViewController.swift
//  WordGame
//
//  Created by Fateme on 2022-09-23.
//

import UIKit

class WordGameViewController: UIViewController {

    var viewModel: WordGameViewModel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("WordGameViewController - Initialization using coder Not Allowed.")
    }
    
    init(viewModel: WordGameViewModel) {
        super.init(nibName: WordGameViewController.nibName, bundle: nil)
        self.viewModel = viewModel
    }
    
    deinit {}

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
