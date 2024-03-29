//
//  DifficultyStrategy.swift
//  MillionVS
//
//  Created by Home on 07.12.2021.
//

import UIKit

enum Difficulty: Int {
    case easy = 0, medium = 1
}

protocol ShowQuestionsStrategy {
    func getQuestions(_ question: [Question]) -> [Question]
}

final class SequentialShowQuestionsStrategy: ShowQuestionsStrategy {
    func getQuestions(_ questions: [Question]) -> [Question] {
        return questions
    }
}

final class RandomShowQuestionsStrategy: ShowQuestionsStrategy {
    func getQuestions(_ questions: [Question]) -> [Question] {
        return questions.shuffled()
    }
}
