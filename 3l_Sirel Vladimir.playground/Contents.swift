import Foundation

enum EngineActions: String {
    case on = "работает", off = "выключен"
}

enum WindowsActions: String {
    case open = "открыты", close = "закрыты"
}

enum TrunkVolumeActions {
    case load, unload
}

enum Baggage: String {
    case bag = "сумка"
    case dog = "собака"
    case box = "коробка"

    var volume: Int {
     switch self {
        case .bag: return 1
        case .dog: return 5
        case .box: return 10
        }
    }
}

struct SportCar {
    let brand: String
    let yearOfManufacture: Int
    var engineCondition: EngineActions
    var windowsCondition: WindowsActions
    var trunkVolume:Int
    var filledTrunkVolume: Int /*{
        willSet {
            if (newValue > filledTrunkVolume) {
                let remainder = trunkVolume - filledTrunkVolume - newValue
                print("Груз загружен, остаток объема багажника \(remainder)")
            } else {
                let remainder = trunkVolume - newValue
                print("Груз выгружен, остаток объема багажника \(remainder)")
            }
        }
    }*/
    
    mutating func startEngine (engine: EngineActions) {
        self.engineCondition = engine
        print("Двигатель \(engine.rawValue)")
    }
    
    mutating func openWindows (condition: WindowsActions) {
        self.windowsCondition = condition
        print("Окна \(condition.rawValue)")
    }
    
    mutating func trunkOperations (operation: TrunkVolumeActions, baggage: Baggage) -> Int {
        if (operation == .load) {
            filledTrunkVolume += baggage.volume
            print("Попытка загрузить груз: \(baggage.rawValue), объемом \(baggage.volume)")
            if (filledTrunkVolume > trunkVolume) {
                let remainder = trunkVolume - filledTrunkVolume
                print("Груз не помещается, остаток объема багажника \(remainder)")
                return (filledTrunkVolume - baggage.volume)
            } else {
                print("Груз успешно загружен.")
            }
            return filledTrunkVolume
        } else {
            filledTrunkVolume -= baggage.volume
            print("Попытка выгрузить груз: \(baggage.rawValue), объемом \(baggage.volume)")
            if (filledTrunkVolume < 0) {
                filledTrunkVolume = filledTrunkVolume + baggage.volume
                print("Такого объема груза нет в багажнике, остаток объема багажника \(filledTrunkVolume)")
                return filledTrunkVolume
            } else {
                print("Груз успешно выгружен.")
                return filledTrunkVolume
            }
        }
    }

    func description () {
        print("Автомобиль '\(brand)', \(yearOfManufacture) года выпуска, двигатель \(engineCondition.rawValue), окна \(windowsCondition.rawValue). Загрузка багажника: \(filledTrunkVolume) из \(trunkVolume).")
    
    }
}

struct TrunkCar {
    let brand: String
    let yearOfManufacture: Int
    var engineCondition: EngineActions
    var windowsCondition: WindowsActions
    var trunkVolume:Int
    var filledTrunkVolume: Int
    
    mutating func startEngine (engine: EngineActions) {
        self.engineCondition = engine
        print("Двигатель \(engine.rawValue)")
    }
    
    mutating func openWindows (condition: WindowsActions) {
        self.windowsCondition = condition
        print("Окна \(condition.rawValue)")
    }
    
    mutating func trunkOperations (operation: TrunkVolumeActions, baggage: Baggage) -> Int {
        if (operation == .load) {
            filledTrunkVolume += baggage.volume
            print("Попытка загрузить груз: \(baggage.rawValue), объемом \(baggage.volume)")
            if (filledTrunkVolume > trunkVolume) {
                let remainder = trunkVolume - filledTrunkVolume
                print("Груз не помещается, остаток объема багажника \(remainder)")
                return (filledTrunkVolume - baggage.volume)
            } else {
                print("Груз успешно загружен.")
            }
            return filledTrunkVolume
        } else {
            filledTrunkVolume -= baggage.volume
            print("Попытка выгрузить груз: \(baggage.rawValue), объемом \(baggage.volume)")
            if (filledTrunkVolume < 0) {
                filledTrunkVolume = filledTrunkVolume + baggage.volume
                print("Такого объема груза нет в багажнике, остаток объема багажника \(filledTrunkVolume)")
                return filledTrunkVolume
            } else {
                print("Груз успешно выгружен.")
                return filledTrunkVolume
            }
        }
    }

    func description () {
        print("Автомобиль '\(brand)', \(yearOfManufacture) года выпуска, двигатель \(engineCondition.rawValue), окна \(windowsCondition.rawValue). Загрузка багажника: \(filledTrunkVolume) из \(trunkVolume).")
    
    }
}

var sportCar1 = SportCar(brand: "Ferrary",
                    yearOfManufacture: 2000,
                    engineCondition: .on,
                    windowsCondition: .close,
                    trunkVolume: 9,
                    filledTrunkVolume: 0)

var sportCar2 = SportCar(brand: "Bugatti",
                    yearOfManufacture: 2012,
                    engineCondition: .off,
                    windowsCondition: .close,
                    trunkVolume: 5,
                    filledTrunkVolume: 0)

sportCar1.trunkOperations(operation: .load, baggage: .bag)
sportCar1.description()
sportCar1.trunkOperations(operation: .unload, baggage: .bag)
sportCar1.description()
sportCar1.openWindows(condition: .open)
sportCar1.description()
sportCar2.trunkOperations(operation: .unload, baggage: .box)
sportCar2.description()


var trunkCar1 = TrunkCar(brand: "Tatra",
                         yearOfManufacture: 1995,
                         engineCondition: .on,
                         windowsCondition: .close,
                         trunkVolume: 100,
                         filledTrunkVolume: 80)

var trunkCar2 = TrunkCar(brand: "BigFoot",
                         yearOfManufacture: 2002,
                         engineCondition: .off,
                         windowsCondition: .open,
                         trunkVolume: 150,
                         filledTrunkVolume: 100)

print("------------------------------------------------")
print("Грузовики:")
trunkCar1.description()
trunkCar1.startEngine(engine: .off)
trunkCar2.description()
print("Погрузка...")
trunkCar2.trunkOperations(operation: .load, baggage: .dog)
trunkCar2.trunkOperations(operation: .load, baggage: .bag)
trunkCar2.trunkOperations(operation: .load, baggage: .box)
trunkCar2.description()
