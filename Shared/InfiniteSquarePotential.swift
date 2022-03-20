//
//  InfiniteSquarePotential.swift
//  1D_Shrodinger_RungeKutta
//
//  Created by Daksh Patel on 2/21/22.
//


import Foundation
import SwiftUI

class InfiniteSquarePotentials: NSObject, ObservableObject {
    
    @Published var deltaX = 0.10
    @Published var potentialArray = [(xPoint: Double, yPoint: Double)]()
    @Published var leftX = 0.0
    @Published var rightX = 10.0
    
    func zero() {
        
        potentialArray.removeAll()
        
        let numberOfSteps = ((rightX - leftX) / deltaX)
        
        potentialArray.append((xPoint: 0.0, yPoint: 100000.0))
       
        for i in 1...Int(numberOfSteps) {
            
            let newX = potentialArray[i-1].xPoint + deltaX
            let point = (xPoint: newX, yPoint: 0.0)
            potentialArray.append(point)
            
        }
        
        potentialArray.append((xPoint: rightX, yPoint: 100000.0))
    
    }
    
    func yEqualsX() {
        
        
        potentialArray.removeAll()
        
        let numberOfSteps = ((rightX - leftX) / deltaX)
        
        potentialArray.append((xPoint: 0.0, yPoint: 100000.0))
        
        for i in 1...Int(numberOfSteps) {
            
            let newX = potentialArray[i-1].xPoint + deltaX
            let newY = newX*4.0*1.3
            let point = (xPoint: newX, yPoint: newY)
            potentialArray.append(point)
        }
        
        potentialArray.append((xPoint: rightX, yPoint: 100000.0))
        
        
    }
    
    
    func parabola() {
        
        potentialArray.removeAll()
        
        let numberOfSteps = ((rightX - leftX) / deltaX)
        
        var point = (xPoint: 0.0, yPoint: 0.0)
        var tempData : [(xPoint: Double, yPoint: Double)] = []
        tempData.append(point)
        var xArray = [0.0]
        var yArray = [0.0]
        
        for i in 0...Int(numberOfSteps) {
            xArray.append(xArray[i]+deltaX)
            let newX = Double(pow(xArray[i+1],2))
            yArray.append(newX)
            
            point = (xPoint: xArray[i+1], yPoint: yArray[i+1])
            tempData.append(point)
        }
        
        potentialArray.append(contentsOf: tempData)
    }
    
}
