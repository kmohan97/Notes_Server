//
//  DataBaseFetcher.swift
//  DataBaseFetcher
//
//  Created by Mohan on 14/11/21.
//

import UIKit

class DataBaseFetcher: NSObject {
	

	func fetchData(url: String, body: [String: String]?, completion: @escaping (Result<[NotesModel],NotesError>) -> Void ) {
		guard let url = URL(string: url) else {
			print("Invalid URL")
			return
		}
		var req = URLRequest(url: url)
		let headerDict = [
			"content-type": "application/json"
		]
		
		req.allHTTPHeaderFields = headerDict
		
		req.httpMethod = "get"
		
//		if body != nil {
//			do {
//				var httpBody = try JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
//				req.httpBody = httpBody
//				req.httpMethod = "post"
//			} catch {
//				print("Exception for converting the body")
//			}
//		}
		
		URLSession.shared.dataTask(with: url) { data, res, err in
			if err == nil {
				do {
					var responseArray =  try JSONDecoder().decode([NotesModel].self, from: data!)
					completion(.success(responseArray))
				} catch {
					completion(.failure(NotesError.connectionError))
					print("Exception while decoding data")
				}
			} else {
				completion(.failure(NotesError.connectionError))
			}
 		}.resume()
		
	}
	
	func deleteUpdateAddData(url: String, body: [String: String]?) {
		// everything will based on the url and body
		guard let url = URL(string: url) else {
			print("Invalid URL")
			return
		}
		var req = URLRequest(url: url)

		req.addValue("application/json", forHTTPHeaderField: "content-type")
		
		if body != nil {
			do {
				var httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
				
				req.httpMethod = "POST"
				req.httpBody = httpBody
				print("entering here")
			} catch {
				print("Exception for converting the body")
			}
		}
		
		URLSession.shared.dataTask(with: req) { data, res, err in
			if err == nil {
				do {
					print((res as? HTTPURLResponse)!.statusCode)
					print(data)
				} catch {
					print("Exception while decoding data")
				}
			} else {
				print("Error while performing Task")
			}
		}.resume()
	}
	
}


enum NotesError: String,Error {
	case connectionError = "Seems to be network Error"
}

