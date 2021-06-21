import Foundation

enum EngineActions {
    case on, off
}

enum WindowsActions {
    case open, close
}

enum TrunkVolumeActions {
    case load, unload
}

enum Baggage: Int {
    case bag = 1
    case dog = 5
    case box = 10
    
    var volume: Int {
        return rawValue
    }
}

//let a = TrunkVolumeActions.load
//let b = Baggage.bag.rawValue
//let bb = Baggage.bag.volume

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
    }
    
    mutating func openWindows (condition: WindowsActions) {
        self.windowsCondition = condition
    }
    
    mutating func trunkOperations (operation: TrunkVolumeActions, volume: Baggage) -> Int {
        if (operation == .load) {
            filledTrunkVolume += volume.rawValue
            if (filledTrunkVolume > trunkVolume) {
                let remainder = trunkVolume - filledTrunkVolume
                print("Груз не помещается, остаток объема багажника \(remainder)")
                return (filledTrunkVolume - volume.rawValue)
            }
            return filledTrunkVolume
        } else {
            filledTrunkVolume -= volume.rawValue
            if (filledTrunkVolume < 0) {
                filledTrunkVolume = filledTrunkVolume + volume.rawValue
                print("Такого объема груза нет в багажнике, остаток объема багажника \(filledTrunkVolume)")
                return filledTrunkVolume
            } else {
                return filledTrunkVolume
            }
        }
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
 }
 
 mutating func openWindows (condition: WindowsActions) {
     self.windowsCondition = condition
 }
 
 mutating func trunkOperations (operation: TrunkVolumeActions, volume: Baggage) -> Int {
     if (operation == .load) {
         filledTrunkVolume += volume.rawValue
         if (filledTrunkVolume > trunkVolume) {
             let remainder = trunkVolume - filledTrunkVolume
             print("Груз не помещается, остаток объема багажника \(remainder)")
             return (filledTrunkVolume - volume.rawValue)
         }
         return filledTrunkVolume
     } else {
         filledTrunkVolume -= volume.rawValue
         if (filledTrunkVolume < 0) {
             filledTrunkVolume = filledTrunkVolume + volume.rawValue
             print("Такого объема груза нет в багажнике, остаток объема багажника \(filledTrunkVolume)")
             return filledTrunkVolume
         } else {
             return filledTrunkVolume
         }
     }
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

sportCar1.trunkOperations(operation: .load, volume: .bag)
print(sportCar1)
sportCar1.trunkOperations(operation: .unload, volume: .bag)
print(sportCar1)
sportCar1.openWindows(condition: .open)
print(sportCar1)
sportCar2.trunkOperations(operation: .unload, volume: .box)
print(sportCar2)

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
print("Грузовики:")
print(trunkCar1)
trunkCar1.startEngine(engine: .off)
print(trunkCar2)
print("Погрузка...")
trunkCar2.trunkOperations(operation: .load, volume: .dog)
trunkCar2.trunkOperations(operation: .load, volume: .bag)
trunkCar2.trunkOperations(operation: .load, volume: .box)
print(trunkCar2)
