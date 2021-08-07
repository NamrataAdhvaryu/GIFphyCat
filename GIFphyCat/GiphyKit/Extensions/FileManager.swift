//
//  FileManager.swift
//  GIFphyCat
//
//  Created by Namrata Akash on 04/08/21.
//

import Foundation
struct FileHandler {
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

    func getPathForImage(id: String) -> URL {
        let pathComponent = "\(id).jpg"
        return documentsDirectory.appendingPathComponent(pathComponent)
    }
    
    func checkIfFileExists(id: String) -> Bool {
        let pathComponent = "\(id).jpg"
        return FileManager.default.fileExists(atPath: documentsDirectory.appendingPathComponent(pathComponent).path)
    }
    
    func flushDocumentsDirectory() -> Bool {
        guard let paths = try? FileManager.default.contentsOfDirectory(at: self.documentsDirectory, includingPropertiesForKeys: nil) else { return false }
        for path in paths {
            try? FileManager.default.removeItem(at: path)
        }
        return true
    }
}
