//
//  NetworkingService.swift
//  ToDo List
//
//  Created by AZM on 2020/11/09.
//

import Foundation

enum NetworkingService {
    
    static func requestUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        let task = URLSession.shared.dataTask(
            with: URL(string: "https://jsonplaceholder.typicode.com/users")!
        ) {
            if let error = $2 {
                completion(.failure(error))
            } else if let data = $0, let users = try? JSONDecoder().decode([User].self, from: data) {
                completion(.success(users))
            }
        }
        task.resume()
    }
}
