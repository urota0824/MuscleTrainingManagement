//
//  RecordModel.swift
//  MuscleTrainingManagement
//
//  Created by yutaro on 2022/11/30.
//

import Foundation
import RealmSwift

class AllRecordModel: Object {
    
    // 実施日
    @objc dynamic var effectiveDate = ""

    let allRecordList = List<RecordModel>()
}

class RecordModel: Object {
    
    // 器具名
    @objc dynamic var apparatus = ""
    // 部位
    @objc dynamic var part = ""
    // 箇所
    @objc dynamic var place = ""
    // 重さ
    @objc dynamic var weight = ""
    // 回数
    @objc dynamic var stretchCount = ""
}
