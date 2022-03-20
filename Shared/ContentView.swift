//
//  ContentView.swift
//  Shared
//
//  Created by daksh patel on 3/12/21.
//

import SwiftUI
import CorePlot

typealias plotDataType = [CPTScatterPlotField : Double]

struct ContentView: View {
    @EnvironmentObject var plotDataModel :PlotDataClass
    @ObservedObject var calculator = CalculatePlotData()
    @ObservedObject var potentials = InfiniteSquarePotentials()
    @ObservedObject var matrix = matrixCalculate()

    var Potential = ["Square Well", "Linear Well", "Parabola"]
    @State var selectedPotential = "Square Well"
    
    @State var energyPlacement = 0
    @State var energyArray: [String] = []
    @State var energies = ""
    
    @State var psiArray: [[Double]] = []
    @State var nodes = 10
    
    @State var isChecked:Bool = false
    @State var tempInput = ""
  

    var body: some View {
        
        HStack{
            VStack{
                
                VStack{
                    Picker("Potential", selection: $selectedPotential){
                        ForEach(Potential, id: \.self){
                            Text($0)
                        }
                    }
                    .onChange(of: selectedPotential, perform: { value in selectPotential(potentialType: selectedPotential)})
                  }
                .padding()
                .frame(width: 200)
             
                VStack{
                    Picker("Psi", selection: $energies){
                        ForEach(energyArray, id: \.self){
                            Text($0)
                        }
                    }
                    .onChange(of: energies, perform: { value in getArrayPlacement(energy: energies)})
                }
                .padding()
                .frame(width: 200)
                
                Button("Plot Psi"){
            
                    matrix.performMatrixOperations()
                    
                    var i = 0
                    for item in matrix.energies{
                        if(i < nodes){
                            energyArray.append(String(format: "%.3f", item))
                            i += 1
                        }
                        else {
                            break
                        }
                    }
                    print("energy", energyArray)
                    psiArray = matrix.psi

                }
            
                
            }
            
            
            Divider()
            
            CorePlot(dataForPlot: $plotDataModel.plotData, changingPlotParameters: $plotDataModel.changingPlotParameters)
                .setPlotPadding(left: 10)
                .setPlotPadding(right: 10)
                .setPlotPadding(top: 10)
                .setPlotPadding(bottom: 10)
                .padding()
                .aspectRatio(1, contentMode: .fit)
            

            
        }
        
    }

    
    func plotPsi(){
        
        let psiArray = self.psiArray[self.energyPlacement]
        let stepSize = matrix.wellLength/(matrix.Nvalues)
        
        calculator.plotDataModel = self.plotDataModel
        calculator.matrixPlot(Psi: psiArray, xStep: stepSize)
        
        }
    
    
    func getArrayPlacement(energy: String) {
        var i = 0
        
        for item in energyArray{
            
            if(energy == item){
                self.energyPlacement = i
            }
            
            i += 1
        }
        plotPsi()
    }
    
    func selectPotential(potentialType: String) {
        switch potentialType {
        
            case "Square Well":
                potentials.zero()
                
            case "Linear Well":
                potentials.yEqualsX()
            
            case "Parabola":
                potentials.parabola()
            
            default:
                potentials.zero()
        }
        
            //$calculator.energyStep_ = Double(tempInput)
            //pass the plotDataModel to the cosCalculator
            calculator.plotDataModel = self.plotDataModel
            
            //Calculate the new plotting data and place in the plotDataModel
            calculator.PEx(dataPoints: potentials.potentialArray)

        
    }
    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
}
