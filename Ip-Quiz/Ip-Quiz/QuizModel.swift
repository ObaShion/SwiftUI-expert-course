//
//  QuizModel.swift
//  Ip-Quiz
//
//  Created by 大場史温 on 2025/06/28.
//

import Foundation

struct Quiz: Codable, Identifiable {
    let id = UUID()
    let body: String
    let option1: String
    let option2: String
    let option3: String
    let answer: String
    
    var options: [String] {
        [option1, option2, option3]
    }
}

struct QuizResponse: Codable {
    let quizzes: [Quiz]
}

struct QuizModel: Codable {
    var quizzes: [Quiz] = []
    var currentQuizIndex: Int = 0
    var userAnswers: [Int: String] = [:]
    var isCompleted: Bool = false
    
    var currentQuiz: Quiz? {
        guard currentQuizIndex < quizzes.count else { return nil }
        return quizzes[currentQuizIndex]
    }
    
    var score: Int {
        userAnswers.filter { index, answer in
            guard index < quizzes.count else { return false }
            return answer == quizzes[index].answer
        }.count
    }
    
    var totalQuestions: Int {
        quizzes.count
    }
    
    mutating func answerQuestion(_ answer: String) {
        userAnswers[currentQuizIndex] = answer
    }
    
    mutating func nextQuestion() {
        if currentQuizIndex < quizzes.count - 1 {
            currentQuizIndex += 1
        } else {
            isCompleted = true
        }
    }
    
    mutating func reset() {
        currentQuizIndex = 0
        userAnswers.removeAll()
        isCompleted = false
    }
}
