//
//  TopicsEntry.swift
//  DWidgetsExtension
//
//  Created by Mak Ho-Cheung on 2022/11/18.
//

import Foundation
import V2EXClient
import WidgetKit

struct TopicsEntry: TimelineEntry {
    let date: Date
    let topics:[Topic]
}
