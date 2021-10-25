//
//  Service.swift
//  nyc-school
//
//  Created by Sean Zhang on 10/25/21.
//

import Foundation
import Combine

// schools: https://data.cityofnewyork.us/resource/s3k6-pzi2.json
// SAT scores: https://data.cityofnewyork.us/resource/f9bf-2cp4.json

struct School: Decodable {
   var dbn: String
   var school_name: String
}

struct Score: Decodable {
    var dbn: String
    var school_name: String
    var num_of_sat_test_takers: String
    var sat_critical_reading_avg_score: String
    var sat_math_avg_score: String
    var sat_writing_avg_score: String
}

class Service {
    
    static let shared = Service()
    var subscriptions: Set<AnyCancellable> = Set<AnyCancellable>()
    lazy var schoolSubject: CurrentValueSubject<[School], Never> = {
        return CurrentValueSubject<[School], Never>([])
    }()
    
    lazy var soreSubject: CurrentValueSubject<[Score], Never> = {
        return CurrentValueSubject<[Score], Never>([])
    }()
    
    init() {
   
    }
    
    
    func fetchSchools() -> Future<[School], Error> {
        return Future { promise in
            let Url = String(format: "https://data.cityofnewyork.us/resource/s3k6-pzi2.json")
            guard let serviceUrl = URL(string: Url) else { return }
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "GET"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let response = response {
                    print(response)
                }
                if let data = data {
                    do {
                        let json = try JSONDecoder().decode([School].self, from: data)
                        return promise(.success(json))
                    } catch {
                        print(error)
                        return promise(.failure(NSError()))
                    }
                }
            }.resume()
        }
    }
    
    func fetchScores() -> Future<[Score], Error> {
        return Future { promise in
            let Url = String(format: "https://data.cityofnewyork.us/resource/f9bf-2cp4.json")
            guard let serviceUrl = URL(string: Url) else { return }
            var request = URLRequest(url: serviceUrl)
            request.httpMethod = "GET"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let response = response {
                    print(response)
                }
                if let data = data {
                    do {
                        let json = try JSONDecoder().decode([Score].self, from: data)
                        return promise(.success(json))
                    } catch {
                        print(error)
                        return promise(.failure(NSError()))
                    }
                }
            }.resume()
        }
    }

}
