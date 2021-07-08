import UIKit

//1. Придумать класс, методы которого могут завершаться неудачей и возвращать либо значение, либо ошибку Error?. Реализовать их вызов и обработать результат метода при помощи конструкции if let, или guard let.

enum CharacterType {
    case paladin
    case archer
    case mage
    case all
}

enum SomeErrors: Error {
    case notInInventory
    case notForThisCharacterType
    case notEnoughMoney(needCoins: Int)
    case notEnoughItems(needItems: Int, inStockItems: Int)
    case notInAssortiment
}

struct Item: CustomStringConvertible, Equatable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.name == rhs.name
    }
    var description: String { return "\(emoji) (\(count)) [for: \(type), price: \(price)]"}
    //var description: String { return "\(name)(\(count))[(for - \(type))(price - \(price))]"}
    //var description: String { return "Item - \(name)(\(count)), for character type - \(type), price - \(price)"}
    
    var name: String
    var emoji: String
    var type: CharacterType
    var price: Int
    var count: Int
}

class Player: CustomStringConvertible {
    var description: String { return "**********************\nPlayer: \(name) \nCharacter type: \(type) \nMoney: \(wallet) \nInventory: \(inventory)\n**********************"}
    
    var name: String
    var type: CharacterType
    var wallet = 100
    var inventory = [Item]()
    
    func use (item:Item) -> (Item?, SomeErrors?) {
        guard let index = inventory.firstIndex(of: item) else {
            return (nil, .notInInventory)
        }
        let useItem = inventory[index]
        
        guard (useItem.type == self.type) || (useItem.type == CharacterType.all) else {
            return (nil, .notForThisCharacterType)
        }
        
        inventory[index].count -= 1
        if inventory[index].count == 0 {
            inventory.remove(at: index)
        }
        print("Use \(useItem.emoji)")
        return (useItem, nil)
    }
    
    func pickUp (item:Item) -> (Item?, SomeErrors?) {
        
        guard let index = inventory.firstIndex(of: item) else {
            inventory.append(item)
            
            print("Pick up \u{0022}\(item.name)\u{0022} \(item.emoji)(\(item.count))")
            return (item, nil)
        }
        print("Pick up \u{0022}\(item.name)\u{0022} \(inventory[index].emoji)(\(item.count))")
        return (inventory[index], nil)
    }
    
    func sell (item:Item) -> (SomeErrors?) {
        guard let index = inventory.firstIndex(of: item) else {
            return .notInInventory
        }
        let sellItem = inventory[index]
        
        guard sellItem.count > 0 else {
            return .notInInventory
        }
        
        guard sellItem.count >= item.count else {
            return .notEnoughItems(needItems: item.count, inStockItems: sellItem.count)
        }
        
        inventory[index].count -= item.count
        if inventory[index].count == 0 {
            inventory.remove(at: index)
        }
        
        wallet += item.price * item.count
        print("You sell \(sellItem.emoji)(\(sellItem.count))")
        return nil
    }
    
    func addBaseInventory () {
        let item1 = Item(name: "Apple", emoji: "🍎", type: .all, price: 1, count: 3)
        let item2 = Item(name: "Cheese", emoji: "🧀", type: .all, price: 2, count: 3)
        var nameBaseWeapon = "Weapon of Novice"
        var emojiBaseWeapon = "👊"
        
        switch type {
        case .paladin: nameBaseWeapon = "Sword of Novice"; emojiBaseWeapon = "🗡"
        case .archer: nameBaseWeapon = "Bow of Novice"; emojiBaseWeapon = "🏹"
        case .mage: nameBaseWeapon = "Staff of Novice"; emojiBaseWeapon = "🦯"
        case .all: break
        }
        
        inventory.append(item1)
        inventory.append(item2)
        inventory.append(Item(name: nameBaseWeapon, emoji: emojiBaseWeapon, type: type, price: 10, count: 1))
    }
    
    init(Name name:String, Type type:CharacterType) {
        self.name = name
        self.type = type
        
        addBaseInventory()
    }
}

let player1 = Player(Name: "Barbarian123", Type: .paladin)
let item1 = Item(name: "Bow", emoji: "🏹", type: .archer, price: 15, count: 1)
let item2 = Item(name: "Cheese", emoji: "🧀",type: .all, price: 2, count: 3)
let item3 = Item(name: "Staff of Haos", emoji: "🦯", type: .mage, price: 1000, count: 1)

print(player1)
player1.use(item: item1)
player1.use(item: item2)
player1.use(item: item2)
player1.use(item: item2)
player1.use(item: item2)
player1.pickUp(item: item3)
player1.use(item: item3)
print(player1)
player1.pickUp(item: item2)

//2. Придумать класс, методы которого могут выбрасывать ошибки. Реализуйте несколько throws-функций. Вызовите их и обработайте результат вызова при помощи конструкции try/catch.

class Store: CustomStringConvertible {
    var description: String { return "Name: \(name)\n\(assortiment)\nDeposit: \(deposit)" }
    
    var name = "Store"
    var assortiment = [Item(name: "Meat", emoji: "🍖", type: .all, price: 3, count: 10),
              Item(name: "Bananas", emoji: "🍌", type: .all, price: 1, count: 20),
              Item(name: "Mega Bow", emoji: "🏹", type: .archer, price: 150, count: 1),
              Item(name: "Cheese", emoji: "🧀",type: .all, price: 2, count: 30),
              Item(name: "Ice Rune", emoji: "🧊" , type: .mage, price: 10, count: 10)]
    
    var deposit = 1000
    
    
    func sell (item:Item, player:Player) throws -> (Item?) {
        guard let index = assortiment.firstIndex(of: item) else {
            throw SomeErrors.notInAssortiment
        }
        let sellItem = assortiment[index]
        
        guard sellItem.count > 0 else {
            throw SomeErrors.notInAssortiment
        }
        
        guard sellItem.count >= item.count else {
            throw SomeErrors.notEnoughItems(needItems: item.count, inStockItems: sellItem.count)
        }
        
        guard (sellItem.price * item.count) <= player.wallet else {
            throw SomeErrors.notEnoughMoney(needCoins: sellItem.price * item.count)
        }
        
        player.wallet -= sellItem.price * item.count
        deposit += sellItem.price * item.count
        assortiment[index].count -= item.count
        print("Thank you! You got \(item.emoji)(\(item.count))")
        return item
    }
    
    func buy (item:Item, player:Player) throws -> (Item?) {
        guard (item.count * item.price) <= deposit else {
            throw SomeErrors.notEnoughMoney(needCoins: item.count * item.price)
        }
        let sellPlayer = player.sell(item: item)
        
        guard sellPlayer == nil else {
            throw sellPlayer!
        }
        
        if let index = assortiment.firstIndex(of: item) {
            assortiment[index].count += item.count
        } else {
            assortiment.append(item)
            
        }
        deposit -= item.count * item.price
        return item
    }
    
    init() {
        
    }
    
    init(Name name:String) {
        self.name = name
    }
    
    init(Name name:String, Deposit deposit:Int) {
        self.name = name
        self.deposit = deposit
    }
    
}
print("----------Player in Stock---------")
print("Player some buy")
let store = Store()
//try store.sell(item: item2, player: player1)
//try? store.sell(item: item2, player: player1)
//try! store.sell(item: item2, player: player1)
let item4 = Item(name: "Mega Bow", emoji: "🏹", type: .archer, price: 150, count: 1)
let item5 = Item(name: "Ice Rune", emoji: "🧊" , type: .mage, price: 10, count: 2)

let itemStoreSomeSell = item5

do {
    try store.sell(item: itemStoreSomeSell, player: player1)
    player1.pickUp(item: itemStoreSomeSell)
} catch SomeErrors.notEnoughItems( _ , let inStock) {
    print("Not enough \(itemStoreSomeSell.emoji)(\(itemStoreSomeSell.count)) in stock assortiment: \(inStock).")
} catch SomeErrors.notEnoughMoney(let needCoin) {
    print("Not enough the money, need: \(needCoin).")
} catch SomeErrors.notInAssortiment {
    print("Item \(itemStoreSomeSell.emoji)(\(itemStoreSomeSell.count)), not in stock assortiment.")
}
print(player1)
print(store)

print("---\nPlayer some sell")
let itemStoreSomeBuy = item4

do {
    try store.buy(item: itemStoreSomeBuy, player: player1)
} catch is SomeErrors {
    print("Somthing wrong, please try later ^_^")
}
print(player1)
print(store)
