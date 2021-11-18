//
//  DataParsingOperation.swift
//  vkontakteVS
//
//  Created by Home on 03.11.2021.
//

import Foundation

class DataParsingOperation<T:Decodable> : Operation {
    private(set) var outputData:T?

    override func main() {
        guard
            let getDataOperation = dependencies.first(where: {$0 is AFGetDataOperation }) as? AFGetDataOperation,
            let data = getDataOperation.data
        else {
            print("Data not loaded")
            return
        }
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            outputData = decoded
        } catch (let error){
            print(error)
           // print("Data decode to \(T.self) failed")
        }
    }
}
