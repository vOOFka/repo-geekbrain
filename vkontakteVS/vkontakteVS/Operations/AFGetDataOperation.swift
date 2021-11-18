//
//  AFGetDataOperation.swift
//  vkontakteVS
//
//  Created by Home on 03.11.2021.
//

import Foundation
import Alamofire

class AFGetDataOperation: AsyncOperation {
    private var request: DataRequest
    var data: Data?

    init(request: DataRequest) {
        self.request  = request
    }

    override func main() {
        request.responseData(queue: DispatchQueue.global()) { [weak self] response in
            if response.error == nil {
                print(response.result)
                if let data = response.data {
                    self?.data = data
                    self?.state = .finished
                } else {
                    self?.data = nil
                    self?.state = .executing
                }
            }
            print("data loaded")
        }
        print("AFGetDataOperation finished")
    }

    override func cancel() {
        request.cancel()
        super.cancel()
    }
}
