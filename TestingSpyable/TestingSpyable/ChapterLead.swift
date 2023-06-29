import Mockable
import Foundation

@Mockable
protocol ChapterLead: AnyObject {
//    var name: String { get }
//    var numberOfChaptees: Int { get }
//
    func handleDiscoveryDialogue()
    func handleDiscoveryDialogue(date: Date)
}


class Max {
    private let chapterLead: ChapterLead
    
    init(chapterLead: ChapterLead) {
        self.chapterLead = chapterLead
    }
    
    func task() {
//       if date < Date()  {
//            return true
//       } else {
//           return false
//       }
        chapterLead.handleDiscoveryDialogue()
    }
    
    func taskWithDate(date: Date) {
        chapterLead.handleDiscoveryDialogue(date: date)
    }
}
