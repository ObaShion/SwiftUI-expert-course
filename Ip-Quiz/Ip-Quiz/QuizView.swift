//
//  QuizView.swift
//  Ip-Quiz
//
//  Created by 大場史温 on 2025/06/28.
//

import SwiftUI

struct QuizView: View {
    @Binding var quizModel: QuizModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if quizModel.isCompleted {
                    ResultView(quizModel: quizModel) {
                        dismiss()
                    }
                } else if let currentQuiz = quizModel.currentQuiz {
                    QuizQuestionView(
                        quiz: currentQuiz,
                        currentIndex: quizModel.currentQuizIndex,
                        totalQuestions: quizModel.totalQuestions,
                        onAnswer: { answer in
                            quizModel.answerQuestion(answer)
                            quizModel.nextQuestion()
                        }
                    )
                } else {
                    ProgressView("クイズを準備中...")
                }
            }
            .padding()
            .navigationTitle("クイズ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("終了") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct QuizQuestionView: View {
    let quiz: Quiz
    let currentIndex: Int
    let totalQuestions: Int
    let onAnswer: (String) -> Void
    
    @State private var selectedAnswer: String?
    
    var body: some View {
        VStack(spacing: 24) {
            ProgressView(value: Double(currentIndex + 1), total: Double(totalQuestions))
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
            
            Text("問題 \(currentIndex + 1) / \(totalQuestions)")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(quiz.body)
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            
            VStack(spacing: 12) {
                ForEach(quiz.options, id: \.self) { option in
                    Button(action: {
                        selectedAnswer = option
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            onAnswer(option)
                        }
                    }) {
                        HStack {
                            Text(option)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        .padding()
                        .background(selectedAnswer == option ? Color.blue.opacity(0.2) : Color(.systemGray5))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(selectedAnswer == option ? Color.blue : Color.clear, lineWidth: 2)
                        )
                    }
                    .disabled(selectedAnswer != nil)
                }
            }
            
            Spacer()
        }
    }
}

struct ResultView: View {
    let quizModel: QuizModel
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text("クイズ完了！")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                Text("正解数: \(quizModel.score) / \(quizModel.totalQuestions)")
                    .font(.title2)
                
                Text("正答率: \(Int(Double(quizModel.score) / Double(quizModel.totalQuestions) * 100))%")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(Array(quizModel.quizzes.enumerated()), id: \.element.id) { index, quiz in
                        ResultDetailView(
                            quiz: quiz,
                            userAnswer: quizModel.userAnswers[index],
                            isCorrect: quizModel.userAnswers[index] == quiz.answer
                        )
                    }
                }
            }
            
            Button("ホームに戻る") {
                onDismiss()
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(12)
        }
        .padding()
    }
}

struct ResultDetailView: View {
    let quiz: Quiz
    let userAnswer: String?
    let isCorrect: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(quiz.body)
                .font(.body)
                .fontWeight(.medium)
            
            HStack {
                Text("あなたの回答: \(userAnswer ?? "未回答")")
                    .foregroundColor(isCorrect ? .green : .red)
                Spacer()
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(isCorrect ? .green : .red)
            }
            
            if !isCorrect {
                Text("正解: \(quiz.answer)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    QuizView(quizModel: .constant(QuizModel()))
} 
