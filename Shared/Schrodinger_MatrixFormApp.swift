//
//  Schrodinger_MatrixFormApp.swift
//  Shared
//
//  Created by Daksh Patel on 3/19/22.
//
import SwiftUI
import CorePlot

@main
struct Schrodinger_MatrixFormApp: App {

    @StateObject var plotDataModel = PlotDataClass(fromLine: true)
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .environmentObject(plotDataModel)
                    .tabItem {
                        Text("Plot")
                    }
                
                TextView()
                    .environmentObject(plotDataModel)
                    .tabItem {
                        Text("Text")
                    }
                            
                            
            }
            
        }
    }
}
