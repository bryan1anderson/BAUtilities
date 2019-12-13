//
//  Errors.swift
//  Canvass
//
//  Created by Bryan on 3/9/18.
//  Copyright © 2018 Bryan Lloyd Anderson. All rights reserved.
//

import Foundation
import Alamofire
////import Crashlytics
import SwiftyJSON
import Marshal
//import Zip
import RealmSwift
import PromiseKit
import Files
import DateToolsSwift

public final class ErrorObject: Object {
    
    @objc var created = Date()
    @objc dynamic var errorDescription: String = ""
    
    convenience init(description: String) {
        self.init()
        self.errorDescription = description
        self.created = Date()
    }
}

public enum ErrorHandlingType: String {
    case printEverything
    case printEverythingButOptionals
//    case printNonDataErrors
    case none
}
var errorHandlingType: ErrorHandlingType = .printEverythingButOptionals

func print(error: Error) {
    print("🔥\(error)")
    
//    do {
//        let realm = try Realm()
//        try realm.write {
//            let errorObject = ErrorObject(description: "🔥\(error)")
//            realm.add(errorObject)
//        }
//    } catch {
//        print(error)
//    }

}

public func handle(_ error: Error?) {
    guard let error = error else { return }
    switch errorHandlingType {
        
    case .printEverything:
        
        switch error {
        case DataError.optional(_):
            print("❔❕\(error)")
        case MarshalError.keyNotFound(_), MarshalError.nullValue(_), MarshalError.typeMismatch(_), MarshalError.typeMismatchWithKey(_):
            print(error: error)
        default:
            print(error: error)
        }
//        Crashlytics.sharedInstance().recordError(error)
    case .printEverythingButOptionals:
        
        switch error {
        case DataError.optional(_):
            break
        case MarshalError.keyNotFound(_), MarshalError.nullValue(_), MarshalError.typeMismatch(_), MarshalError.typeMismatchWithKey(_):
            print(error: error)
//            Crashlytics.sharedInstance().recordError(error)
        default:
//            Crashlytics.sharedInstance().recordError(error)
            print(error: error)
        }
        
//    case .printNonDataErrors:
//
//        switch error {
//        case DataError.jsonNil:
//            break
//        default:
//            Crashlytics.sharedInstance().recordError(error)
//            print(error: error)
//        }
//
    case .none:
        break
    }

}


public class ErrorManager {
    
    let documents: Folder
    let today: Folder
    let logs: Folder
    let zips: Folder
    let currentTextFile: File
    public init() throws {
        
        
        let docsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let documents = try Folder(path: docsDirectory.path)
        let logs = try documents.createSubfolderIfNeeded(withName: "Canvass-Logs")
        let zips = try documents.createSubfolderIfNeeded(withName: "Canvass-Logs-Zips")
        
        self.zips = zips
        self.documents = documents
        self.logs = logs
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: Date())
        let today = try logs.createSubfolderIfNeeded(withName: dateString)
        self.today = today
        let currentTextFile = try today.createFileIfNeeded(withName: "\(dateString)-Errors.txt")
        self.currentTextFile = currentTextFile

//        clearOldRecords()
      
    }
    
    public func clearOldRecords() throws {
//        let realm = try Realm()
//        let objects = realm.objects(ErrorObject.self)
//        let olderObjects = objects.filter({$0.created.days(from: Date()) > 15 })
//        
//        try realm.write {
//            realm.delete(olderObjects)
//        }
    }
    
    /// Think twice before changing this! If you forget what it was, you won't be able to access former logs
    let zipPassword = "Dvlop!"
    
    public func export() -> Promise<URL> {
        return Promise { seal in
            do {
                let realm = try Realm()
                //        let objects = realm.objects(ErrorObject.self)
                guard let url = realm.configuration.fileURL else { throw DataError.failure("RealmExporter.url nil")}
                let zipsDir = URL(fileURLWithPath: zips.path)
                let zipFilePath = zipsDir.appendingPathComponent("\(archiveFileName).zip")
                
//                try Zip.zipFiles(paths: [url], zipFilePath: zipFilePath, password: zipPassword, progress: { (progress) -> () in
//                    print(progress)
//                })
                seal.fulfill(zipFilePath)
                
                
            } catch {
                seal.reject(error)
            }
        }
        
        
        //            let filePath = Bundle.main.url(forResource: "errors", withExtension: "zip")!
        
     
        
        
    }
    
//    var errorFileURL: URL {
//        return getDocumentsDirectory().appendingPathComponent("Errors.txt")
//
//    }
    
    
//    func deviceLogFiles() -> URL {
////        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let documentsDirectory = getDocumentsDirectory()
//        let fileName = "\(Date()).log"
//        let logFilePath = documentsDirectory.appendingPathComponent(fileName)
////        freopen(logFilePath.cString(using: String.Encoding.ascii)!, "a+", stderr)
//        return logFilePath
//    }
    var archiveFileName: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = formatter.string(from: Date())
//        if let user = Global.shared.currentEmployee {
//            return "\(user.firstName)-\(user.lastName)-\(dateString)-realm-archive"
//        } else {
            return "\(dateString)-realm-archive"
//        }
    }
    
//    var zippedErrorFiles: URL? {
//        do {
//            //            let filePath = Bundle.main.url(forResource: "errors", withExtension: "zip")!
//
//            let zipsDir = URL(fileURLWithPath: zips.path)
//            let zipFilePath = zipsDir.appendingPathComponent("\(archiveFileName).zip")
//
//            let logsDir = URL(fileURLWithPath: logs.path)
//
//            try Zip.zipFiles(paths: [logsDir], zipFilePath: zipFilePath, password: zipPassword, progress: { (progress) -> () in
//                print(progress)
//            }) //Zip
//                return zipFilePath
//        }
//        catch {
//            return nil
//        }
//    }

//    var existingErrorFileContents: String? {
//
//        do {
//            return try currentTextFile.readAsString(encoding: .utf8)
//        }
//        catch {
//            return nil
//        }
//    }

    
//    func writeErrorToDisk(_ error: Error) {
//
//        let str: String = {
//            let threadString = Thread.callStackSymbols.joined(separator: "\n")
//            let errorString = "\("🔥\(error)")\n \(threadString)"
//            if let existingText = existingErrorFileContents {
//                return existingText + "\n\n\(errorString)"
//            } else {
//                return errorString
//            }
//        }()
//
//
//        do {
//            try currentTextFile.write(string: str, encoding: .utf8)
//        } catch {
//            print(error: error)
//            // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
//        }
//    }

//    private func getDocumentsDirectory() -> URL {
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return paths[0]
//    }

    public class func getfileCreatedDate(theFile: String) -> Date {
        
        var theCreationDate = Date()
        do{
            let aFileAttributes = try FileManager.default.attributesOfItem(atPath: theFile) as [FileAttributeKey:Any]
            theCreationDate = aFileAttributes[FileAttributeKey.creationDate] as! Date
            
        } catch {
            print("file not found \(error)")
        }
        return theCreationDate
    }
    
}



private func collectAndEncryptLogs() {
    
}


public enum DataError: Error {
    case failure(String)
    case failed(response: AFDataResponse<Any>)
    case failedResponse(Error)
    case jsonNil(String)
    case missingValue(String)
    case failedInit(String)
    case failedInitWithJSON(json: JSON?, description: String)
    case optional(Error)
    case failedEncodeURL
    case realmMissingAddressID


}

public enum AppError: Error {
    case savingAreaNotPolygon
}
