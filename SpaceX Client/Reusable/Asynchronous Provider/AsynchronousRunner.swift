//
//  AsynchronousRunner.swift
//  SpaceX Client
//
//  Created by Idris Sop on 2021/07/08.
//

import UIKit

protocol AsynchronousRunner {
    func runOnConcurrent(_ action: @escaping () -> Void, _ qos: DispatchQoS.QoSClass)
    func runOnMain(_ action: @escaping () -> Void)
}
