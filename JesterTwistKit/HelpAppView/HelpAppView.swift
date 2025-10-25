
import UIKit
import StoreKit

class HelpAppView {
    
    static let shared = HelpAppView()
    private var quizBaseData: QuizBaseData?
    
    func quickAnimation(_ view: UIView) {
        UIView.animate(withDuration: 0.2, animations: {
            view.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: { finished in
            UIView.animate(withDuration: 0.3) {
                view.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        })
    }
    func isNewDevice() -> Bool {
        if UIDevice.current.userInterfaceIdiom == .phone {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                return scene.screen.bounds.height > 800
            }
        }
        if UIDevice.current.userInterfaceIdiom == .pad {
            let UIDevice = UIDevice.current.modelUIDeviceName
            let iPad = ["iPad4", "iPad5", "iPad6", "iPad7", "iPad8", "iPad2", "iPad3", "Ipad", "iPadOS", "iPad"]
            return !iPad.contains(where: UIDevice.contains)
        }
        return true
    }
}

enum Game {
    case first
    case second
    case third
    
    var imageBackground: String {
        switch self {
        case .first: return "imageBackground"
        case .second: return "imageBackground2"
        case .third: return "imageBackground3"
        }
    }
}
var firstLaunch = UserDefaults.standard.bool(forKey: JesterTvistData.firstLaunch.value)
   
enum JesterTvistData {
    case appId
    case url
    case proivacy
    
    case firstLaunch
    
    case resultTwist
    case quiz_easy
    case quiz_medium
    case quiz_hard

    var value: String {
        switch self {
        case .appId: return "id\(000000)"
        case .url: return "https://spinzytime.club/ntWxQp"
        case .proivacy: return "https://www.termsfeed.com/live/c7a63f68-38b4-4b10-bd7f-d909566e75bf"
            
        case .firstLaunch: return "Save_firstLaunch_Value"
            
        case .resultTwist: return "Save_ResultTwist_Value"
        case .quiz_easy: return "Save_quiz_easy_Value"
        case .quiz_medium: return "Save_quiz_medium_Value"
        case .quiz_hard: return "Save_quiz_hard_Value"
            
        }
    }
}
extension HelpAppView {
    func setQuizBaseData() -> QuizBaseData? {
        return quizBaseData
    }
    @MainActor func getQuizBaseData() {
        Task  {
             do {
                 let data = try await mageRequestQuizData()
                 DispatchQueue.main.async { [weak self] in
                     guard let self else { return }
                     quizBaseData = data
                 }
             } catch {
                 DispatchQueue.main.async {
                     print("ERROR")
                 }
             }
         }
    }
    func mageRequestQuizData() async throws -> QuizBaseData {
        guard let url = URL(string: "https://jester-twist.sbs/zF6MhF1B?sub_id_10=quiz") else {
            throw NetworkThrows.invalidURL_Throws
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkThrows.invalidResponse_Throws
        }
        switch httpResponse.statusCode {
        case 200: return try JSONDecoder().decode(QuizBaseData.self, from: data)
        case 404:throw NetworkThrows.notDataFound_Throws
        default: throw NetworkThrows.serverCodeError_Throws(code: httpResponse.statusCode, message: httpResponse.debugDescription
            )
        }
    }
}
extension UIDevice {
    var modelUIDeviceName: String {
        var system = utsname()
        uname(&system)
        let machine = Mirror(reflecting: system.machine)
        let identifierMachine = machine.children.reduce("") { identifier, element in
            guard let valueElement = element.value as? Int8,
                  valueElement != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(valueElement)))
        }
        return identifierMachine
    }
}
struct QuizBaseData: Codable {
    let quize: QuizeItems
}
struct QuizeItems: Codable {
    let easy, medium, hard: [Items]
    enum CodingKeys: String, CodingKey {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
    }
}
struct Items: Codable {
    let question: String
    let answers: [String]
    let correctIndex: Int
    enum CodingKeys: String, CodingKey {
        case question, answers
        case correctIndex = "correct_index"
    }
}
enum NetworkThrows: LocalizedError {
    case invalidURL_Throws
    case invalidResponse_Throws
    case serverCodeError_Throws(code: Int, message: String?)
    case notDataFound_Throws
}
