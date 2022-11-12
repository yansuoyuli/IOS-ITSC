

import UIKit

class NewsItem: NSObject {
    var title:String
    var date:String
    var website:String
    
    init(title:String,date:String,website:String){
        self.title = title
        self.date = date
        self.website = website
    }
}
