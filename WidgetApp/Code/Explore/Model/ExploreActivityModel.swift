//
//  ExploreActivityModel.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/18.
//

import Foundation
import HandyJSON

struct ActivityBannerModel: HandyJSON {
    
    var msg : String?
    var total : String?
    var code : String?
    var data : ActivityBannerInfoModel?
}

struct ActivityBannerInfoModel : HandyJSON {
    var actId: String?
    var name: String?
    var rows : [ActivityInfoModel]?
}

struct ActivityInfoModel : HandyJSON {
    
    var actId: String?
    var name: String?
    var url: String?
    var themeUrl: String?
    var action: String?
}


struct ActivityAction : HandyJSON {
    var action : Int?
    var categoryId : String?
    var categoryName : String?
    var tags : String?
}
