
import Foundation

final class Service {
        func makeServiceCall(to uri: String, completion: @escaping (Result<Equipments, NSError>) -> Void) {
            let format = String(format: Constants.url + uri)
            let url = URL(string: format)!
            let task = URLSession.shared.dataTask(with: url) {data, _, error in
                guard let data = data else { return }
                do {
                    let jsonDecoder = JSONDecoder()
                    let decodedData = try jsonDecoder.decode(Equipments.self, from: data)
                    completion(.success(decodedData))
                    
                } catch(let error) {
                    completion(.failure(error as NSError))
                }
            }
            task.resume()
        }
    }
