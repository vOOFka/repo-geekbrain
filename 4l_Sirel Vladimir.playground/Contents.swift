import UIKit

enum EngineActions: String {
    case on = "работает", off = "выключен"
}

enum WindowsActions: String {
    case open = "открыты", close = "закрыты"
}

enum HitchTrailerActions: String {
    case on = "прицеплен", off = "отцеплен"
}

enum NitroActions: String {
    case on = "Пуск!", off = "Стоп!"
}

enum Actions {
    case engine(EngineActions)
    case windowsActions(WindowsActions)
    case hitchTrailer(HitchTrailerActions)
    case nitro(NitroActions)
}

class Car {
    let brand: String
    let yearOfManufacture: Int
    var engineCondition: EngineActions
    var windowsCondition: WindowsActions
    var trunkVolume:Int
    var filledTrunkVolume: Int
    
    func description () {
        print("Автомобиль '\(brand)', \(yearOfManufacture) года выпуска, двигатель \(engineCondition.rawValue), окна \(windowsCondition.rawValue).")
    
    }
    func doSomething (action: Actions) {
        switch action {
        case .engine(let value):
            self.engineCondition = value
            print("Двигатель на автомобиле \(brand) \(value.rawValue)")
        case .windowsActions(let value):
            self.windowsCondition = value
            print("Окна на автомобиле \(brand) \(value.rawValue)")
        //case .hitchTrailer(_):
        //    print("Do something...")
        //case .nitro(_):
        //    print("Do something...")
        default:
            //print("Nothing to do...")
        print()
        }
    }

    init (brand: String, yearOfManufacture: Int, engineCondition: EngineActions,
            windowsCondition: WindowsActions, trunkVolume: Int, filledTrunkVolume: Int) {
                self.brand = brand
                self.yearOfManufacture = yearOfManufacture
                self.engineCondition = engineCondition
                self.windowsCondition = windowsCondition
                self.trunkVolume = trunkVolume
                self.filledTrunkVolume = filledTrunkVolume
        }
}

class SportСar : Car {
    var spoilerBrand: String
    var nitroCondition: NitroActions
    
    override func description () {
        super.description()
        print("На автомобиле \(brand) уставнолен спойлер фирмы '\(spoilerBrand)'. NOS - \(nitroCondition.rawValue)")
    }
    
    override func doSomething(action: Actions) {
        super.doSomething(action: action)
        
        switch action {
        case .nitro(let value):
            self.nitroCondition = value
            print("На автомобиле \(brand) NOS - \(value.rawValue)")
        default:
            print("Nothing to do...")
        }
    }

    init (brand: String, yearOfManufacture: Int, engineCondition: EngineActions,
          windowsCondition: WindowsActions, trunkVolume: Int, filledTrunkVolume: Int, spoilerBrand: String, nitroCondition: NitroActions) {
        self.spoilerBrand = spoilerBrand
        self.nitroCondition = nitroCondition
        
                super.init (brand: brand, yearOfManufacture: yearOfManufacture, engineCondition: engineCondition,
                 windowsCondition: windowsCondition, trunkVolume: trunkVolume, filledTrunkVolume: filledTrunkVolume)
                 }
}

class TrunkCar : Car {
    var hitch: HitchTrailerActions

    override func description () {
        super.description()
        print("Прицеп у автомобиля \(brand) \(hitch.rawValue)!")
    }
    
    override func doSomething(action: Actions) {
        super.doSomething(action: action)
        
        switch action {
        case .hitchTrailer(let value):
            self.hitch = value
            print("Прицеп у автомобиля \(brand) \(value.rawValue)!")
        default:
            print("Nothing to do...")
        }
    }
    
    init (brand: String, yearOfManufacture: Int, engineCondition: EngineActions,
    windowsCondition: WindowsActions, trunkVolume: Int, filledTrunkVolume: Int, hitch: HitchTrailerActions) {
        
        self.hitch = hitch
        
        super.init (brand: brand, yearOfManufacture: yearOfManufacture, engineCondition: engineCondition,
        windowsCondition: windowsCondition, trunkVolume: trunkVolume, filledTrunkVolume: filledTrunkVolume)
        }
}

var sportCar1 = SportСar(brand: "Ferrary", yearOfManufacture: 2000, engineCondition: .on, windowsCondition: .close, trunkVolume: 8, filledTrunkVolume: 0, spoilerBrand: "Brambo", nitroCondition: .off)

var sportCar2 = SportСar(brand: "Buggati", yearOfManufacture: 2012, engineCondition: .off, windowsCondition: .close, trunkVolume: 4, filledTrunkVolume: 0, spoilerBrand: "Apec", nitroCondition: .on)

var trunkCar1 = TrunkCar(brand: "Tatra", yearOfManufacture: 1995, engineCondition: .on, windowsCondition: .close, trunkVolume: 100, filledTrunkVolume: 80, hitch: .off)

var trunkCar2 = TrunkCar(brand: "BigFoot", yearOfManufacture: 2002, engineCondition: .on, windowsCondition: .open, trunkVolume: 150, filledTrunkVolume: 100, hitch: .on)

var trunkCar3 = trunkCar2

print("------------------------------------------------")
print("Спорткары:")
sportCar1.description()
sportCar2.description()
sportCar1.doSomething(action: .engine(.off))
sportCar1.doSomething(action: .nitro(.off))
sportCar2.doSomething(action: .hitchTrailer(.off))
sportCar1.description()
sportCar2.description()
print("------------------------------------------------")
print("Грузовики:")
trunkCar1.description()
trunkCar2.description()
trunkCar3.description()
trunkCar1.doSomething(action: .nitro(.off))
trunkCar2.doSomething(action: .hitchTrailer(.off))
trunkCar1.description()
trunkCar2.description()
trunkCar3.description()
