import UIKit

protocol Coffee {
    var cost: Double { get }
}

class SimpleCoffee: Coffee {
    var cost: Double {
        return 50.0
    }
}

protocol CoffeeDecorator: Coffee {
    var base: Coffee { get }
    init(base: Coffee)
}

class Milk: CoffeeDecorator {
    var base: Coffee
    var cost: Double {
        return base.cost + 10.0
    }
    required init(base: Coffee) {
        self.base = base
    }
}

class Whip: CoffeeDecorator {
    var base: Coffee
    var cost: Double {
        return base.cost + 15.0
    }
    required init(base: Coffee) {
        self.base = base
    }
}

class Sugar: CoffeeDecorator {
    var base: Coffee
    var cost: Double {
        return base.cost + 5.0
    }
    required init(base: Coffee) {
        self.base = base
    }
}
print("#############------Decorator------#############")
let coffee = SimpleCoffee()
print("Price of coffee(☕️): \(coffee.cost) $")

let coffeeWithMilk = Milk(base: coffee)
print("Price of coffee(☕️ + 🐮): \(coffeeWithMilk.cost) $")

let coffeeWithWhip = Whip(base: coffee)
print("Price of coffee(☕️ + 🥛): \(coffeeWithWhip.cost) $")

let coffeeWithMilkAndWhip = Whip(base: coffeeWithMilk)
print("Price of coffee(☕️ + 🐮 + 🥛): \(coffeeWithMilkAndWhip.cost) $")

let coffeeWithTwoMilkAndWhip = Milk(base: coffeeWithMilkAndWhip)
print("Price of coffee(☕️ + 🐮🐮 + 🥛): \(coffeeWithTwoMilkAndWhip.cost) $")

let coffeeWithWhipAndSugar = Sugar(base: coffeeWithWhip)
print("Price of coffee(☕️ + 🥛 + 🍰): \(coffeeWithWhipAndSugar.cost) $")

print("#############---------------------#############")
