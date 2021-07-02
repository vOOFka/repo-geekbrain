import UIKit

//1. Реализовать свой тип коллекции «очередь» (queue) c использованием дженериков.

protocol Queue {
    associatedtype `Type`   // по началу думал не получится использовать Протокол для описания Очереди с дженериками
                            //затем наше реализацию в док. Apple
    
    mutating func put(newElement: Type)
    mutating func take() -> Type

    var array: Array<Type> { get set }
    var isEmpty: Bool { get }

}

struct myQueue<Type>: Queue {
    var array = [Type]()
    var isEmpty: Bool {return self.array.isEmpty }

    mutating func put(newElement: Type) {
        array.append(newElement)
    }
    
    mutating func take() -> Type {
        return array.remove(at: 0)
    }

}

//2. Добавить ему несколько методов высшего порядка, полезных для этой коллекции (пример: filter для массивов)

extension myQueue: CustomStringConvertible {
    var description: String { return self.array.description }
    
    func filtering (predicate: (Type) -> Bool) -> ([Type]){
        var filteringArray = [Type]()
        print("Пробуем отфильтровать массив по заданным параметрам.")
            for item in array {
                predicate(item) ? filteringArray.append(item) : print("Элемент \(item) не подходит под условия фильтрации.")
            }
            return filteringArray
    }
    
    func maping (predicate: (Type) -> Type) -> ([Type]) {
       return array.map(predicate)
    }
}

//3. * Добавить свой subscript, который будет возвращать nil в случае обращения к несуществующему индексу.

extension myQueue {
    subscript (index: Int) -> Type? {
        for (i,value) in array.enumerated() {
            if (i == index) {
                return value
            }
        }
        return nil
    }
}

var newQueue = myQueue<String>()
newQueue.isEmpty

newQueue.put(newElement: "10")
newQueue.put(newElement: "20")
newQueue.put(newElement: "15")
newQueue.put(newElement: "20")
let a = newQueue.take()
print(a)
newQueue.isEmpty
print(newQueue)

var newQueue2 = myQueue<Int>()
newQueue2.isEmpty

newQueue2.put(newElement: 1312)
newQueue2.put(newElement: 224)
newQueue2.put(newElement: 52)
let aa = newQueue2.take()
print(aa)
newQueue2.isEmpty
print(newQueue2)

print("Отфильтрованная очередь: \(newQueue.filtering(predicate: { $0 == "20" } ))")
print("Отфильтрованная очередь: \(newQueue2.filtering(predicate: { $0 > 200 } ))")

print("Преобразованная очередь: \(newQueue2.maping(predicate: { $0 + 10 } ))")

print(newQueue[1]!)
print(newQueue[10] as Any)
newQueue[11]
newQueue2[0]
