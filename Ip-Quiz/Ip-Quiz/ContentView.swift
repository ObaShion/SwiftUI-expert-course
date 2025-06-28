//
//  ContentView.swift
//  Ip-Quiz
//
//  Created by 大場史温 on 2025/06/28.
//

import SwiftUI
import GoogleGenerativeAI

struct ContentView: View {
    @State private var image: UIImage?
    @State private var isPresented = false
    @State private var quizModel = QuizModel()
    @State private var isGeneratingQuiz = false
    @State private var showingQuiz = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                if image != nil {
                    VStack(spacing: 16) {
                        
                        HStack(spacing: 16) {
                            Button("写真を変更") {
                                isPresented.toggle()
                            }
                            .buttonStyle(.bordered)
                            
                            Button("クイズを生成") {
                                Task {
                                    await generateQuiz()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(isGeneratingQuiz)
                        }
                    }
                } else {
                    Button("写真を撮る") {
                        isPresented.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                
                if isGeneratingQuiz {
                    VStack(spacing: 12) {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("クイズを生成中...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
            }
            .padding()
        }
        .fullScreenCover(isPresented: $isPresented, content: {
            CameraView(image: $image)
                .ignoresSafeArea()
        })
        .fullScreenCover(isPresented: $showingQuiz) {
            QuizView(quizModel: $quizModel)
        }
    }
    
    func generateQuiz() async {
        guard let image = image else { return }
        
        isGeneratingQuiz = true
        
        let model = GenerativeModel(
            name: "gemini-1.5-flash",
            apiKey: APIKey.key
        )
        
        do {
            let response = try await model.generateContent(
                """
                この画像から問題を作成してください。
                
                出力は必ず以下のJSON形式で、マークダウンのコードブロック記号（```）は使用せず、純粋なJSONのみを返してください：
                {
                  "quizzes": [
                    {
                      "body": "xxx",
                      "option1": "xxx",
                      "option2": "xxx",
                      "option3": "xxx",
                      "answer": "xxx"
                    },
                    {
                      "body": "xxx",
                      "option1": "xxx",
                      "option2": "xxx",
                      "option3": "xxx",
                      "answer": "xxx"
                    },
                    {
                      "body": "xxx",
                      "option1": "xxx",
                      "option2": "xxx",
                      "option3": "xxx",
                      "answer": "xxx"
                    }
                  ]
                }
                """,
                image
            )
            
            if let text = response.text {
                print("response: \(text)")
                
                if let data = text.data(using: .utf8) {
                    do {
                        let quizResponse = try JSONDecoder().decode(QuizResponse.self, from: data)
                        quizModel.quizzes = quizResponse.quizzes
                        quizModel.reset()
                        isGeneratingQuiz = false
                        showingQuiz = true
                    } catch {
                        print("JSON parsing error: \(error)")
                        isGeneratingQuiz = false
                    }
                }
            }
        } catch {
            print("API error: \(error)")
            isGeneratingQuiz = false
        }
    }
    

}

#Preview {
    ContentView()
}
