//
//  WordGameViewModel.swift
//  WordGame
//
//  Created by Fateme on 2022-09-23.
//

import Foundation

protocol WordGameViewModelProtocol {}

class WordGameViewModel: WordGameViewModelProtocol {
    
    let wordGameRepo: FileManagerHandlerProtocol
    let fileName: String = "words"
    
    init(wordGameRepo: FileManagerHandlerProtocol) {
        self.wordGameRepo = wordGameRepo
        
        wordGameRepo.save(toFilename: fileName) { [weak self] result in
            switch result {
            case .success(_):
                self?.fetchData()
            case .failure(let error):
                self?.handelError(error)
            }
        }
    }

    private func fetchData() {
        wordGameRepo.read(withFilename: fileName) { [weak self] result in
            switch result {
            case .success(let data):
                let _ = self?.parse(data: data)
            case .failure(let error):
                self?.handelError(error)
            }
        }
    }

    private func parse(data: Data) -> [Word]? {
        let decoder = JSONDecoder()
        do {
            let model = try decoder.decode([Word].self, from: data)
            return model
        } catch let error {
            debugPrint(error.localizedDescription)
            return nil
        }
    }
    
    func handelError(_ error: Error) {}
}
