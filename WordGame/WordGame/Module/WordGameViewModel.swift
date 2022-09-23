//
//  WordGameViewModel.swift
//  WordGame
//
//  Created by Fateme on 2022-09-23.
//

import Foundation
import Combine

struct RandomWordsModel {
    let correctAnswers: [Word]
    let restOfWords: [Word]
}

protocol WordGameViewModelDelegate {
    
}

protocol WordGameViewModelProtocol {
    // input
    func startGame()
    func reset()
    func checkAnswerWith(_ isCorrect: Bool)
    
    // output
    var nextWord$: AnyPublisher<Word, Never> { get }
    var gameOver$: AnyPublisher<Void, Never> { get }
    var wrongAttemptsCounter$: AnyPublisher<Int, Never> { get }
    var correctAttemptsCounter$: AnyPublisher<Int, Never> { get }
}

class WordGameViewModel: WordGameViewModelProtocol {
    
    let wordGameRepo: FileManagerHandlerProtocol
    let fileName: String = "words"

    var allWords: [Word] = []
    var words: [Word] = []
    var currentWord: Word?
    var wordIndex: Int = 0
    var wrongAnswers: Int = 0
    var correctAnswers: Int = 0
    
    var nextWord$: AnyPublisher<Word, Never> { nextWordSubject.guaranteeMainThread() }
    var gameOver$: AnyPublisher<Void, Never> { gameOverSubject.guaranteeMainThread() }
    var wrongAttemptsCounter$: AnyPublisher<Int, Never> { $wrongAttemptsCounter.guaranteeMainThread() }
    var correctAttemptsCounter$: AnyPublisher<Int, Never> { $correctAttemptsCounter.guaranteeMainThread() }

    let nextWordSubject = PassthroughSubject<Word, Never>()
    let gameOverSubject = PassthroughSubject<Void, Never>()
    @Published var wrongAttemptsCounter: Int = 0
    @Published var correctAttemptsCounter: Int = 0
    
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
                guard let words = self?.prepareData(model: model) else { return }
                self?.words = words
                self?.allWords = words
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
        let wrongAnswers = shuffleKeysOfWords(model: restOfWords)

        // append 4 correct words
        var wholeWords: [Word] = []
        wholeWords.append(contentsOf: correctAnswers)
        wholeWords.append(contentsOf: wrongAnswers)
        
        // shuffle whole data
        return wholeWords.shuffled()
    }
    
    // swap the words together to generate wrong answer
    func shuffleKeysOfWords(model: [Word]) -> [Word] {
        var newDic = model
        var result: [Word] = []
        var index: Int = 0
        
        while index < model.count {
            var nextIndex = index + 1
            if nextIndex > model.count + 1 {
                nextIndex = 0
            }
            let newValue = newDic[index].spanish
            newDic[index].spanish = newDic[nextIndex].spanish
            newDic[nextIndex].spanish = newValue
            result.append(newDic[index])
            result.append(newDic[nextIndex])
            index += 2
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

    func checkGameOver() -> Bool {
        if wrongAnswers >= 3 || words.count == 0 {
            return true
        } else {
            return false
        }
    }
}

extension WordGameViewModel {
    func startGame() {
        currentWord = words[wordIndex]
        guard let currentWord = currentWord else { return }
        nextWordSubject.send(currentWord)
        wordIndex += 1
    }

    func showNextWord() {
        if checkGameOver() {
            gameOverSubject.send()
        } else {
            currentWord = words[wordIndex]
            guard let currentWord = currentWord else { return }
            nextWordSubject.send(currentWord)
            wordIndex += 1
        }
    }

    func checkAnswerWith(_ isCorrect: Bool) {
        let correctoWord = allWords.filter { $0.english == currentWord?.english }.first
        if (isCorrect && correctoWord?.spanish != currentWord?.spanish) || (!isCorrect && correctoWord?.spanish == currentWord?.spanish) {
            wrongAnswers += 1
            wrongAttemptsCounter = wrongAnswers
        } else {
            correctAnswers += 1
            correctAttemptsCounter = correctAnswers
        }
        words.removeAll { $0 == currentWord }
        showNextWord()
    }

    func reset() {
        wrongAnswers = 0
        words = allWords
        wordIndex = 0
        wrongAnswers = 0
    }
}
