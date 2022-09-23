//
//  FileManagerHandler.swift
//  WordGame
//
//  Created by Fateme on 2022-09-23.
//

import Foundation

protocol FileManagerHandlerProtocol {
    func read(withFilename filename: String, completion: @escaping (Result<Data, Error>) -> Void)
    func save(toFilename filename: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

class FileManagerHandler: FileManagerHandlerProtocol {

    private func getStringData(fileName: String, ofType: String = "json") -> String? {
        guard let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: ofType) else {
            return nil
        }
        return try? String(contentsOfFile:path, encoding: .utf8)
    }
    
    func read(withFilename filename: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var fileURL = url.appendingPathComponent(filename)
        fileURL = fileURL.appendingPathExtension("json")
        do {
            let data = try Data(contentsOf: fileURL)
            completion(.success(data))
        } catch {
            completion(.failure(error))
        }
    }
    
    func save(toFilename filename: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let stringData = getStringData(fileName: filename)
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var fileURL = url.appendingPathComponent(filename)
        fileURL = fileURL.appendingPathExtension("json")
        do {
            let data = stringData?.data(using: .utf8)
            try data?.write(to: fileURL, options: [.atomicWrite])
            completion(.success(true))
        } catch {
            completion(.failure(error))
        }
    }
}

// step 1 : write in file system
/// appending path (check before dose not exist)


// step 3: update UI
/// show pairs using animate
/// check the correct answer
/// update counters
/// check the conditions of quit the game every time
/// show quit alert

// step 4: write test
