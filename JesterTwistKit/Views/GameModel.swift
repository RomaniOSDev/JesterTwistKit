
import Foundation
import CoreData

@objc(GameModel)
public class GameModel: NSManagedObject {}
extension GameModel {
    
    @NSManaged public var id: Int16
    @NSManaged public var image: Data
    @NSManaged public var level: Int16
    
}
extension GameModel : Identifiable {}
