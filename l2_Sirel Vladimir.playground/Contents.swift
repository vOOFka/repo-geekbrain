//1.Написать функцию, которая определяет, четное число или нет.

func evenNumber(_ x:Int) -> Bool {
    if (x % 2) != 0 {
        return false
    }
    return true
}

let arrayOne = [-4,-3,-2,-1,0,1,2,3,4]
print("Задание 1")
for num in arrayOne {
    evenNumber(num) ? print ("Число \(num) четное") : print ("Число \(num) не четное")
}

//2.Написать функцию, которая определяет, делится ли число без остатка на 3.

func remainderDivisionByThree(_ x:Int) -> Bool {
    if (x % 3) != 0 {
        return false
    }
    return true
}

let arrayTwo = [4,5,9,11,-210,1257]
print("Задание 2")
for num in arrayTwo {
    if remainderDivisionByThree(num) == true {
        print ("Число \(num), делится на три без остатка.")
    } else {
        print ("Число \(num), не делится на три без остатка, остаток равен \(num % 3)")
    }
}

//3.Создать возрастающий массив из 100 чисел.
let length = 100
var increasingArray = [Int]()
let randomInt = Int.random(in:  1..<length)

while increasingArray.count < length {
    increasingArray.append(randomInt * (increasingArray.count + 1)/3)
}
print("Задание 3")
print("Возрастающий массив из \(length) чисел:")
print(increasingArray)

//4.Удалить из этого массива все четные числа и все числа, которые не делятся на 3.
//var increasingArray = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
print("Задание 4")

var filteredArray = [Int]()
//вариант 1
filteredArray = increasingArray.filter { ($0 % 2 != 0) && ($0 % 3 != 0) }
print("Отфильтрованый массив:")
print(filteredArray)

//вариант 2
filteredArray.removeAll()
for num in increasingArray {
    if (evenNumber(num) == false) && (remainderDivisionByThree(num) == false) {
        filteredArray.append(num)
    }
}
print("Отфильтрованый массив:")
print(filteredArray)

//5.* Написать функцию, которая добавляет в массив новое число Фибоначчи, и добавить при помощи нее 50 элементов.
//Числа Фибоначчи определяются соотношениями Fn=Fn-1 + Fn-2.
print("Задание 5")

var arrayFive = [Int]()
let amountOfNumbers = 50

// Вариант 1 - быстро
func fibAddToArray (_ array: inout [Int], amountOfNumbers n:Int) {
    if n >= 2 {
        array.append(0)
        array.append(1)
        for i in 2..<n {
            let next = array[i-1] + array[i-2]
            array.append(next)
        }
    }
}
fibAddToArray(&arrayFive, amountOfNumbers: amountOfNumbers)
print("Числа Фибоначчи:")
print(arrayFive)

// Вариант 2 - Рекурсия, очень медленно получается ((
/*func fibonachi (_ n:Int) -> Int {
    if (n < 2) {
        return n
    }
    return fibonachi(n - 1) + fibonachi(n - 2)
}
func fibAddToArray (_ array: inout [Int], amountOfNumbers amount:Int) {
     for i in 0..<amount {
         array.append(fibonachi(i))
     }
 }
 fibAddToArray(&arrayFive, amountOfNumbers: amountOfNumbers)
 print(arrayFive)
*/
/*
6.* Заполнить массив элементов различными простыми числами. Натуральное число, большее единицы, называется простым, если оно делится только на себя и на единицу. Для нахождения всех простых чисел не больше заданного числа n (пусть будет 100), следуя методу Эратосфена, нужно выполнить следующие шаги:
a. Выписать подряд все целые числа от двух до n (2, 3, 4, ..., n).
b. Пусть переменная p изначально равна двум — первому простому числу.
c. Зачеркнуть в списке числа от 2p до n, считая шагом p.
d. Найти первое не зачёркнутое число в списке, большее, чем p, и присвоить значению переменной p это число.
e. Повторять шаги c и d, пока возможно.
*/
print("Задание 6")
// вариант 1
var arraySix = [Int]()
let n = 100 // number limit
var p = 2
var crossedOutArray = [Int]()

for i in 2...n {
    arraySix.append(i)
}
//print(arraySix)

for (j,v) in arraySix.enumerated() {
    if (arraySix[j] != 0) {
        p = arraySix[j]
        if ((p * p) < n) {
            for i in stride(from: 2 * p, through: n, by: p) {
                crossedOutArray.append(arraySix[i - 2])
                arraySix[i - 2] = 0
            }
            print("j = \(j), v = \(v), p = \(p)")
            print(crossedOutArray)
            crossedOutArray.removeAll()
        }
    }
}
print("Итоговый массив")
print(arraySix.filter({$0 > 0}))

/*
// вариант 2 - написал на основе блок схемы из Интернет
var arraySix = [Int]()
let n = 100 // number limit
var p = 2

for i in 0...n {
    arraySix.append(i)
}
arraySix[1] = 0
print(arraySix)

while p < n {
    if (arraySix[p] != 0){
        var j = p * 2
        while j <= n {
            arraySix[j] = 0
            j = j + p
        }
    }
    p += 1
}
print("Итоговый массив")
print(arraySix.filter({$0 > 0}))
*/
