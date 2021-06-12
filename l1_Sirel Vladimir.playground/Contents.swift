import Foundation

//1.Решить квадратное уравнение
//квадратное уравнение ax^2 + bx + c = 0
//дискриминант: d = b^2 − 4ac
//корни: x1 = -b + d^1/2 / 2a, x2 = -b - d^1/2 / 2a

let a:Float = -1
let b:Float = 20
let c:Float = 17
var result = ""

let d = (b * b) - (4 * a * c)

if d < 0 {
    print("Дискриминант отрицательный - действительных корней нет.")
} else if d == 0 {
    let x = -b / (2 * a)
    result = ", корни совпадают и равны \(x)"
} else {
    let x1 = (-b + sqrt(d)) / (2 * a)
    let x2 = (-b - sqrt(d)) / (2 * a)
    result = ", первый корень = \(round(x1)), второй корень = \(round(x2))"
    //result = ", первый корень = \(Int(x1)), второй корень = \(Int(x2))"
}
print ("Дискриминант = \(d)" + result)


//2. Даны катеты прямоугольного треугольника. Найти площадь, периметр и гипотенузу треугольника.
//S=(a*b)/2; P=a+b+c; с=(a^2 + b^2)^1/2

let triangleA:Float = 3
let triangleB:Float = 4
var triangleResult = ""

if (triangleA > 0 && b > 0) {
    let triangleC = sqrt((triangleA * triangleA) + (triangleB * triangleB))
    let triangleS = (triangleA * triangleB) / 2
    let triangleP = triangleA + triangleB + triangleC

    triangleResult = "Ответ: площадь заданного прямоугольного треугольника = \(triangleS), " +
                    "периметр = \(triangleP), " +
                    "гипотенуза = \(triangleC)."
   /* triangleResult = "Ответ: площадь заданного прямоугольного треугольника = \(round(triangleS)), " +
                    "периметр = \(round(triangleP)), " +
                    "гипотенуза = \(round(triangleC))."*/
}
print (triangleResult)

//3. *Пользователь вводит сумму вклада в банк и годовой процент. Найти сумму вклада через 5 лет.

var deposit:Float = 1000
let percent:Float = 3.3
let years = 5

if (deposit > 0) && (percent > 0) {
    for i in 1...years {
        deposit = deposit + (deposit * percent / 100)
        print("Сумма вклада через \(i) лет/год(а) равна \(deposit)")
    }
}

print ("Ответ: cумма вклада через \(years) лет/год(а) равна \(deposit)")

