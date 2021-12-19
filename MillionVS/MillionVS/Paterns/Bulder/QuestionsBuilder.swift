//
//  QuestionsBuilder.swift
//  MillionVS
//
//  Created by Home on 12.12.2021.
//

import Foundation

class QuestionsBuilder {
    private(set) var questions: [Question] = []
    
    func build() -> [Question] {
        return questions
    }
    
    func addQuestion(_ question: Question) {
        if !questions.contains(where: { $0.question == question.question }) {
            self.questions.append(question)
        }
    }
}
