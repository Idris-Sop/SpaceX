//
//  DummyAsynchronousRunner.swift
//  SpaceX Client
//
//  Created by Idris Sop on 2021/07/08.
//

import UIKit

class DummyAsynchronousRunner: AsynchronousRunner {

    func runOnConcurrent(_ action: @escaping () -> Void, _ qos: DispatchQoS.QoSClass) {
        action()
    }

    func runOnMain(_ action: @escaping () -> Void) {
        action()
    }
}
