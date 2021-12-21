import UIKit

protocol ParserHandler {
    var next: ParserHandler? { get set }
    func handle(_ data: Data) -> [Person]
}

struct Person {
    var name: String
    var age: Int
    var isDeveloper: Bool
    
    init(json: [String: Any]) {
        self.name = json["name"] as! String
        self.age = json["age"] as! Int
        self.isDeveloper = json["isDeveloper"] as! Bool
    }
    
    func description() {
        print("Name: \(name), age: \(age), is developer? \(isDeveloper ? "Yes!": "No.")")
    }
}

func data(from file: String) -> Data {
    let path1 = Bundle.main.path(forResource: file, ofType: "json")!
    let url = URL(fileURLWithPath: path1)
    let data = try! Data(contentsOf: url)
    return data
}

let data1 = data(from: "1")
let data2 = data(from: "2")
let data3 = data(from: "3")

class FirstParser: ParserHandler {
    var next: ParserHandler?
    
    func handle(_ data: Data) -> [Person] {
        var persons: [Person] = []
        print("FirstParser try parsing.")
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            if let dataJson = json as? [String: Any],
               let arrayJson = dataJson["data"] as? [Any] {
                arrayJson.forEach({
                    if let personJson = $0 as? [String: Any] {
                        persons.append(Person(json: personJson))
                    }
                })
            } else {
                print("FirstParser failed, try next.")
                guard let personsFromHandle = self.next?.handle(data) else { return persons }
                persons = personsFromHandle
            }
        } catch {
            print("FirstParser failed, try next.")
            guard let personsFromHandle = self.next?.handle(data) else { return persons }
            persons = personsFromHandle
        }
        return persons
    }
}

//let firstParsingPersons = FirstParser().handle(data1)
//print(firstParsingPersons.forEach({ $0.description() }))

class SecondParser: ParserHandler {
    var next: ParserHandler?
    
    func handle(_ data: Data) -> [Person] {
        print("SecondParser try parsing.")
        var persons: [Person] = []
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            if let dataJson = json as? [String: Any],
               let arrayJson = dataJson["result"] as? [Any] {
                arrayJson.forEach({
                    if let personJson = $0 as? [String: Any] {
                        persons.append(Person(json: personJson))
                    }
                })
            } else {
                print("SecondParser failed, try next.")
                guard let personsFromHandle = self.next?.handle(data) else { return persons }
                persons = personsFromHandle
            }
        } catch {
            print("SecondParser failed, try next.")
            guard let personsFromHandle = self.next?.handle(data) else { return persons }
            persons = personsFromHandle
        }
        return persons
    }
}

//let secondParsingPersons = SecondParser().handle(data2)
//print(secondParsingPersons.forEach({ $0.description() }))

class ThirdParser: ParserHandler {
    var next: ParserHandler?
    
    func handle(_ data: Data) -> [Person] {
        print("ThirdParser try parsing.")
        var persons: [Person] = []
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            if let dataJson = json as? [[String: Any]] {
                dataJson.forEach({
                    let personJson = Person(json: $0)
                    persons.append(personJson)
                })
            } else {
                print("ThirdParser failed. Data parsing is not possible.")
            }
        } catch {
            print("ThirdParser failed. Data parsing is not possible.")
        }
        return persons
    }
}

//let thirdParsingPersons = ThirdParser().handle(data2)
//print(thirdParsingPersons.forEach({ $0.description() }))


func GeneralParsing(from file: String) -> [Person] {
    let data = data(from: file)
    
    let firstParsingPersons = FirstParser()
    let secondParsingPersons = SecondParser()
    let thirdParsingPersons = ThirdParser()
    let parsingHandler: ParserHandler = firstParsingPersons
    
    firstParsingPersons.next = secondParsingPersons
    secondParsingPersons.next = thirdParsingPersons
    thirdParsingPersons.next = nil

    return parsingHandler.handle(data)
}

let personsFromFile = GeneralParsing(from: "3")
print(personsFromFile.forEach({ $0.description() }))
