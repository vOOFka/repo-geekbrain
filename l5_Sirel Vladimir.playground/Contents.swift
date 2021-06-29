import UIKit

//1. Создать протокол «Car» и описать свойства, общие для автомобилей, а также метод действия.
//2. Создать расширения для протокола «Car» и реализовать в них методы конкретных действий с автомобилем: открыть/закрыть окно, запустить/заглушить двигатель и т.д. (по одному методу на действие, реализовывать следует только те действия, реализация которых общая для всех автомобилей).
//3. Создать два класса, имплементирующих протокол «Car» - trunkCar и sportСar. Описать в них свойства, отличающиеся для спортивного автомобиля и цистерны.
//4. Для каждого класса написать расширение, имплементирующее протокол CustomStringConvertible.
//5. Создать несколько объектов каждого класса. Применить к ним различные действия.
//6. Вывести сами объекты в консоль.

enum EngineActions: String {
    case on = "работает", off = "выключен"
}

enum WindowsActions: String {
    case open = "открыты", close = "закрыты"
}

enum TrunkActions: String {
    case load = "загрузка", unload = "разгрузка"
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

enum HitchTrailerActions: String {
    case on = "прицеплен", off = "отцеплен"
}

enum NitroActions: String {
    case on = "Пуск!", off = "Стоп!"
}

enum SomeActions {
    //case engine(EngineActions)
    //case windowsActions(WindowsActions)
    case hitchTrailer(HitchTrailerActions)
    case nitro(NitroActions)
}

protocol Car {
    var brand: String { get }
    var yearOfManufacture: Int { get }
    var engineCondition: EngineActions { get set }
    var windowsCondition: WindowsActions { get set }
    var trunkVolume: Int { get set }
    var filledTrunkVolume: Int { get set }

    func doSomething (action: SomeActions)
}

extension Car {
   
    mutating func windowsActions (action: WindowsActions) {
        switch action {
        case .open:
            windowsCondition = .open
        case .close:
            windowsCondition = .close
        }
        print("Окна на автомобиле \(brand) \(windowsCondition.rawValue)")
    }
    
    mutating func engineActions (action: EngineActions) {
        switch action {
        case .on:
            engineCondition = .on
        case .off:
            engineCondition = .off
        }
        print("Двигатель на автомобиле \(brand) \(engineCondition.rawValue)")
    }
    
    mutating func trunkActions(action: TrunkActions, baggage: Baggage) -> Int {
        if (action == .load) {
            filledTrunkVolume += baggage.volume
            print("Попытка загрузить груз в автомобиль \(brand): \(baggage.rawValue), объемом \(baggage.volume)")
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
            print("Попытка выгрузить груз из автомобиля \(brand): \(baggage.rawValue), объемом \(baggage.volume)")
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
}

class SportСar : Car {
    let brand: String
    let yearOfManufacture: Int
    var engineCondition: EngineActions
    var windowsCondition: WindowsActions
    var trunkVolume:Int
    var filledTrunkVolume: Int
    
    let spoilerBrand: String
    var nitroCondition: NitroActions
    
    func doSomething(action: SomeActions) {
        switch action {
        case .nitro(let value):
            self.nitroCondition = value
            print("На автомобиле \(brand) NOS - \(value.rawValue)")
        default:
            print("Это действие невозможно на автомобиле \(brand).")
            break
        }
    }

    init (brand: String, yearOfManufacture: Int, engineCondition: EngineActions,
          windowsCondition: WindowsActions, trunkVolume: Int, filledTrunkVolume: Int, spoilerBrand: String, nitroCondition: NitroActions) {
        self.spoilerBrand = spoilerBrand
        self.nitroCondition = nitroCondition

        self.brand = brand
        self.yearOfManufacture = yearOfManufacture
        self.engineCondition = engineCondition
        self.windowsCondition = windowsCondition
        self.trunkVolume = trunkVolume
        self.filledTrunkVolume = filledTrunkVolume
    }
}

extension SportСar : CustomStringConvertible	 {
    var description: String {
        return "Автомобиль '\(brand)', \(yearOfManufacture) года выпуска, двигатель \(engineCondition.rawValue), окна \(windowsCondition.rawValue). Загрузка багажника: \(filledTrunkVolume) из \(trunkVolume). \nНа автомобиле \(brand) уставнолен спойлер фирмы '\(spoilerBrand)'. NOS - \(nitroCondition.rawValue)\n"
    }
}

class TrunkCar : Car {
    let brand: String
    let yearOfManufacture: Int
    var engineCondition: EngineActions
    var windowsCondition: WindowsActions
    var trunkVolume:Int
    var filledTrunkVolume: Int

    var hitch: HitchTrailerActions

    func doSomething(action: SomeActions) {
        switch action {
        case .hitchTrailer(let value):
            self.hitch = value
            print("Прицеп у автомобиля \(brand) \(value.rawValue)!")
        default:
            print("Это действие невозможно на автомобиле \(brand).")
            break
        }
    }
    
    init (brand: String, yearOfManufacture: Int, engineCondition: EngineActions,
    windowsCondition: WindowsActions, trunkVolume: Int, filledTrunkVolume: Int, hitch: HitchTrailerActions) {
        
        self.hitch = hitch

        self.brand = brand
        self.yearOfManufacture = yearOfManufacture
        self.engineCondition = engineCondition
        self.windowsCondition = windowsCondition
        self.trunkVolume = trunkVolume
        self.filledTrunkVolume = filledTrunkVolume
    }
}

extension TrunkCar : CustomStringConvertible {
    var description: String {
        return "Автомобиль '\(brand)', \(yearOfManufacture) года выпуска, двигатель \(engineCondition.rawValue), окна \(windowsCondition.rawValue). Загрузка багажника: \(filledTrunkVolume) из \(trunkVolume). \nПрицеп у автомобиля \(brand) \(hitch.rawValue)!\n"
    }
}

extension TrunkCar : Comparable {
    static func < (lhs: TrunkCar, rhs: TrunkCar) -> Bool {
        return lhs.filledTrunkVolume < rhs.filledTrunkVolume
    }
    
    static func == (lhs: TrunkCar, rhs: TrunkCar) -> Bool {
        return lhs.filledTrunkVolume == rhs.filledTrunkVolume
    }
}

var sportCar1 = SportСar(brand: "Ferrary", yearOfManufacture: 2000, engineCondition: .on, windowsCondition: .close, trunkVolume: 8, filledTrunkVolume: 0, spoilerBrand: "Brambo", nitroCondition: .off)

var sportCar2 = SportСar(brand: "Buggati", yearOfManufacture: 2012, engineCondition: .off, windowsCondition: .close, trunkVolume: 4, filledTrunkVolume: 0, spoilerBrand: "Apec", nitroCondition: .on)

var trunkCar1 = TrunkCar(brand: "Tatra", yearOfManufacture: 1995, engineCondition: .on, windowsCondition: .close, trunkVolume: 100, filledTrunkVolume: 80, hitch: .off)

var trunkCar2 = TrunkCar(brand: "BigFoot", yearOfManufacture: 2002, engineCondition: .on, windowsCondition: .open, trunkVolume: 150, filledTrunkVolume: 100, hitch: .on)

var trunkCar3 = trunkCar2
//
print("------------------------------------------------")
print("Спорткары:")
print(sportCar1)
sportCar1.windowsActions(action: .open)
sportCar1.trunkActions(action: .load, baggage: .bag)
sportCar1.doSomething(action: .hitchTrailer(.on))
sportCar1.engineActions(action: .off)
sportCar2.doSomething(action: .nitro(.on))
sportCar2.doSomething(action: .hitchTrailer(.off))
print(sportCar1)
print(sportCar2)
print("------------------------------------------------")
print("Грузовики:")
print(trunkCar1)
print(trunkCar2)
print(trunkCar3)
trunkCar1.windowsActions(action: .open)
trunkCar1.doSomething(action: .nitro(.off))
trunkCar2.doSomething(action: .hitchTrailer(.off))
trunkCar3.trunkActions(action: .load, baggage: .box)

func moreLoaded (car1: TrunkCar, car2: TrunkCar) {
    print("---------------------сравнение загрузки грузовиков---------------------------")
    if car1 > car2 {
        print("Груза в автомобиле \(car1.brand) больше чем в \(car2.brand)\n" )
    } else if car1 == car2 {
        print("Загрузка автомобилей одинаковая\n" )
    } else {
        print("Груза в автомобиле \(car2.brand) больше чем в \(car1.brand)\n" )
    }
}

moreLoaded(car1: trunkCar1, car2: trunkCar3)

print(trunkCar1)
print(trunkCar3)
