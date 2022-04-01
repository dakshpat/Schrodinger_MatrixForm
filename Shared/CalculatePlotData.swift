//
//  CalculatePlotData.swift
//  SwiftUICorePlotExample
//
//  Created by Jeff Terry on 12/22/20.
//

import Foundation
import SwiftUI
import CorePlot

class CalculatePlotData: NSObject, ObservableObject {
    @Published var xMin = 0.0
    @Published var xMax = 10.0
    var plotData :[plotDataType] =  []
    var oneDPotentialXArray:[Double] = []
    var oneDPotentialYArray:[Double] = []
    var oneDPotentialArray:[Double] = []
    var count = 0
    
    
    var plotDataModel: PlotDataClass? = nil
    
    func matrixPlot(Psi: [Double], xStep: Double){

        plotDataModel!.changingPlotParameters.yMax = 1.5
        plotDataModel!.changingPlotParameters.yMin = -1.5
        plotDataModel!.changingPlotParameters.xMax = 10.5
        plotDataModel!.changingPlotParameters.xMin = -0.5
        plotDataModel!.changingPlotParameters.xLabel = "Energy(eV)"
        plotDataModel!.changingPlotParameters.yLabel = "Psi"
        plotDataModel!.changingPlotParameters.lineColor = .red()
        plotDataModel!.changingPlotParameters.title = "Functional"
        plotDataModel!.zeroData()

        var dataPoint: plotDataType = [.X: 0, .Y: 0]
        var i = 0
        
        
        for xPoint in stride(from: xMin, to: xMax, by: xStep){
            
            dataPoint = [.X: xPoint, .Y: Psi[i]*2.0]
            plotData.append(contentsOf: [dataPoint])
            i += 1
          
        }
        
        dataPoint = [.X: xMax, .Y: 0]
        plotData.append(contentsOf: [dataPoint])

        plotDataModel!.appendData(dataPoint: plotData)

    }
 
    
    func PEx(dataPoints: [(xPoint: Double, yPoint: Double)]){
        

        for item in dataPoints{
            
            let x = item.xPoint
            let y = item.yPoint
            
            let dataPoint: plotDataType = [.X: x, .Y: y]
            plotData.append(contentsOf: [dataPoint])
        }
        
        plotDataModel!.changingPlotParameters.yMax = 30.0
        plotDataModel!.changingPlotParameters.yMin = -5.0
        plotDataModel!.changingPlotParameters.xMax = 10.0
        plotDataModel!.changingPlotParameters.xMin = -5.0
        plotDataModel!.changingPlotParameters.xLabel = "x"
        plotDataModel!.changingPlotParameters.yLabel = "y"
        plotDataModel!.changingPlotParameters.lineColor = .red()
        plotDataModel!.changingPlotParameters.title = " y = x"
        plotDataModel!.zeroData()
        plotDataModel!.appendData(dataPoint: plotData)

        
}
    

}
