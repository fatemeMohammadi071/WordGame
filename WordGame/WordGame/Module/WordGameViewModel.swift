//
//  WordGameViewModel.swift
//  WordGame
//
//  Created by Fateme on 2022-09-23.
//

import Foundation

struct RandomWordsModel {
    let correctAnswers: [Word]
    let restOfWords: [Word]
}

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
                guard let model = self?.parse(data: data) else { return }
                let data = self?.prepareData(model: model)
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
    
    func prepareData(model: [Word]) -> [Word] {
        // generate 15 correct words
        let words = generateRandomElements(model: model, count: 15)
        
        // removed 4 correct words randomly
        guard let randomWords = generateRandomWordsWithRest(model: words, count: 3) else { return [] }
        let correctAnswers: [Word] = randomWords.correctAnswers
        let restOfWords: [Word] = randomWords.restOfWords
        
        // shuffle rest of data
        let wrongAnswers = shuffleWords(model: restOfWords)

        // append 4 correct words
        var wholeWords: [Word] = []
        wholeWords.append(contentsOf: correctAnswers)
        wholeWords.append(contentsOf: wrongAnswers)
        
        // shuffle whole data
        return wholeWords.shuffled()
    }
    
    func generateReplacement(model: [Word], correctWord: Word) -> Word? {
        guard let random = model.randomElement() else { return nil }
        var wrongWord: Word = correctWord
        if random.spanish == correctWord.spanish {
            generateReplacement(model: model, correctWord: correctWord)
        } else {
            wrongWord.spanish = random.spanish
            return wrongWord
        }
        return nil
    }

    // swap the keys together to generate wrong answer
    func shuffleWords(model: [Word]) -> [Word] {
        var result: [Word] = []
        for item in model {
            guard let word = generateReplacement(model: model, correctWord: item) else { return result }
            result.append(word)
        }
        return result
    }
    
    // return 15 words
    func generateRandomElements(model: [Word], count: Int) -> [Word] {
        var result: Set<Word> = []
        while result.count < count {
            guard let random = model.randomElement() else { return [] }
            result.insert(random)
        }
        return Array(result)
    }
    
    // return correct answer with rest of words
    func generateRandomWordsWithRest(model: [Word], count: Int) -> RandomWordsModel? {
        var result: Set<Word> = []
        var newModel = model
        while result.count < count {
            guard let random = model.randomElement() else { return nil }
            result.insert(random)
            newModel.removeAll { $0 == random }
        }
        return RandomWordsModel(correctAnswers: Array(result), restOfWords: newModel)
    }
}
