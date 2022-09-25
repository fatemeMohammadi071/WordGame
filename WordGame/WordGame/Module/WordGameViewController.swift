//
//  WordGameViewController.swift
//  WordGame
//
//  Created by Fateme on 2022-09-23.
//

import UIKit
import Combine

class WordGameViewController: UIViewController {

    @IBOutlet weak var englishWordLabel: UILabel!
    @IBOutlet weak var spanishWordLabel: UILabel!
    @IBOutlet weak var wrongAttemptsLabel: UILabel!
    @IBOutlet weak var correctAttemptsLabel: UILabel!
    @IBOutlet weak var correctBtn: UIButton!
    @IBOutlet weak var wrongBtn: UIButton!

    @IBAction func correct(_ sender: Any) {
        viewModel.checkAnswerWith(true)
    }

    @IBAction func wrong(_ sender: Any) {
        viewModel.checkAnswerWith(false)
    }

    var viewModel: WordGameViewModel!
    private var store = Set<AnyCancellable>()
    
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
        bindViewModelToView()
        viewModel.startGame()
        
    }

    private func bindViewModelToView() {
        viewModel.nextWord$
            .sink { [unowned self] word in
                updateWords(word: word)
            }.store(in: &store)
        
        viewModel.correctAttemptsCounter$
            .sink { [unowned self] counter in
                updateCorrectAttempts(counter)
            }.store(in: &store)
        
        viewModel.wrongAttemptsCounter$
            .sink { [unowned self] counter in
                updateWrongAttempts(counter)
            }.store(in: &store)

        viewModel.gameOver$
            .sink { [unowned self] in
                self.showAlert(title: "Game Over", message: "do you want to play again?") {
                    self.viewModel.reset()
                }
            }.store(in: &store)
    }
    
    private func updateWords(word: Word) {
        englishWordLabel.text = word.english
        spanishWordLabel.text = word.spanish
    }

    private func updateCorrectAttempts(_ counter: Int) {
        correctAttemptsLabel.text = "Correct Attepmts: \(counter)"
    }
    
    private func updateWrongAttempts(_ counter: Int) {
        wrongAttemptsLabel.text = "Wrong Attepmts: \(counter)"
    }
}


extension WordGameViewController {
    func showAlert(title: String, message: String, completion: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            completion?()
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            exit(0)
        }))
        present(alertController, animated: true, completion: nil)
    }
}
