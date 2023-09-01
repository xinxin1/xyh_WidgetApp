//
//  CourseModel.swift
//  WidgetApp
//
//  Created by 吴琼 on 2023/8/24.
//

import UIKit
import RealmSwift

class ScheduleModel: Object {
    @Persisted var userId: String = ""
    @Persisted var courses: List<CourseModel>
    @Persisted var updateTime: String = ""
}


class CourseModel: Object {
    @Persisted var identifier: String = ""
    @Persisted var courseName: String = ""
    @Persisted var updateTime: String = ""
    @Persisted var courseSort: Int = 1
    @Persisted var weekSort: Int = 1

    override init() {
        
    }
    
    convenience init(courseName: String, updateTime: String, courseSort: Int, weekSort: Int) {
        self.init()
        self.identifier = "\(courseSort * weekSort)"
        self.courseName = courseName
        self.updateTime = updateTime
        self.courseSort = courseSort
        self.weekSort = weekSort
    }
}

struct CourseTimeModel: Hashable {
    var week: Int = 1
    var day: Int = 0
    var month: Int = 0
    var isToday: Bool = false
    var weekCN: String {
        switch week {
        case 1:
            return "周日"
        case 2:
            return "周一"
        case 3:
            return "周二"
        case 4:
            return "周三"
        case 5:
            return "周四"
        case 6:
            return "周五"
        case 7:
            return "周六"
        default:
            return ""
        }
    }
}


enum WeekDay: Hashable {
}
