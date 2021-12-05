//
//  Question+Answer.swift
//  MillionVS
//
//  Created by Home on 30.11.2021.
//

import Foundation

struct Question {
    let question: String
    let answers: [Answer]
    
    static func getQuestions() -> [Question] {
        let simpleQuestions = [
            Question(question: "Какой химический символ для серебра?",
                     answers: [Answer(answer: "Ag", type: .correct),
                               Answer(answer: "Cu", type: .wrong),
                               Answer(answer: "He", type: .wrong),
                               Answer(answer: "Au", type: .wrong)].shuffled()),
            Question(question: "Какая столица Португалии?",
                     answers: [Answer(answer: "Лиссабон", type: .correct),
                               Answer(answer: "Париж", type: .wrong),
                               Answer(answer: "Москва", type: .wrong),
                               Answer(answer: "Берлин", type: .wrong)].shuffled()),
            Question(question: "Сколько игроков в команде по водному поло?",
                     answers: [Answer(answer: "7", type: .correct),
                               Answer(answer: "8", type: .wrong),
                               Answer(answer: "9", type: .wrong),
                               Answer(answer: "6", type: .wrong)].shuffled()),
            Question(question: "Сколько сердец у Осьминога?",
                     answers: [Answer(answer: "3", type: .correct),
                               Answer(answer: "1", type: .wrong),
                               Answer(answer: "2", type: .wrong),
                               Answer(answer: "4", type: .wrong)].shuffled()),
            Question(question: "Какой напиток самый распространённый в мире?",
                     answers: [Answer(answer: "Чай", type: .correct),
                               Answer(answer: "Кофе", type: .wrong),
                               Answer(answer: "Кока-кола", type: .wrong),
                               Answer(answer: "Самогон", type: .wrong)].shuffled()),
            Question(question: "Какая буква 10 в алфавите?",
                     answers: [Answer(answer: "И", type: .correct),
                               Answer(answer: "Ж", type: .wrong),
                               Answer(answer: "З", type: .wrong),
                               Answer(answer: "Й", type: .wrong)].shuffled()),
            Question(question: "Сколько программистов нужно, чтобы закрутить лампочку?",
                     answers: [Answer(answer: "Ни одного. Это аппаратная проблема, программисты их не решают", type: .correct),
                               Answer(answer: "Один", type: .wrong),
                               Answer(answer: "Четыре", type: .wrong),
                               Answer(answer: "Два", type: .wrong)].shuffled()),
            Question(question: "В какой стране находится сфинкс?",
                     answers: [Answer(answer: "Египет", type: .correct),
                               Answer(answer: "Израиль", type: .wrong),
                               Answer(answer: "Аржир", type: .wrong),
                               Answer(answer: "Судан", type: .wrong)].shuffled()),
            Question(question: "Как звали Бетховена?",
                     answers: [Answer(answer: "Людвиг", type: .correct),
                               Answer(answer: "Фридрих", type: .wrong),
                               Answer(answer: "Иоган", type: .wrong),
                               Answer(answer: "Генрих", type: .wrong)].shuffled()),
            Question(question: "Чего не может торнадо?",
                     answers: [Answer(answer: "Стоять на месте", type: .correct),
                               Answer(answer: "Поднять в воздух автомобиль", type: .wrong),
                               Answer(answer: "Вырвать с корнями дерево", type: .wrong),
                               Answer(answer: "Разрушить здание", type: .wrong)].shuffled())
        ]
        return simpleQuestions.shuffled()
    }
}

struct Answer {
    let answer: String
    let type: TypeAnswer
    
    enum TypeAnswer {
        case wrong
        case correct
    }
}
