//
//  ChartView.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-02.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    @StateObject var viewModel = TableViewModel()
    @State var data: [ChartPoint]?
    
    // variables from user interface
    @State private var trToggle = false
    @State private var avgToggle = false
    @State private var minmaxToggle = false
    @State private var currentTab = "All Time"
    @State var currentActiveItem: ChartPoint?
    
    var body: some View {
        NavigationStack{
            
            VStack{
                
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    
                    if let data = data {
                        // variables depeding on date filter
                        let readings = data.map { $0.reading }
                        let average = readings.reduce(0, +) / Double(readings.count)
                        let min = data.firstIndex { $0.reading == readings.min() } ?? 0
                        let max = data.firstIndex { $0.reading == readings.max() } ?? 0
                        
                        // colour constants
                        let curColor = Color(hue: 0.6, saturation: 0.81, brightness: 0.76)
                        let curGradient = LinearGradient(
                            gradient: Gradient (
                                colors: [
                                    curColor.opacity(0.5),
                                    curColor.opacity(0.2),
                                    curColor.opacity(0.05),
                                ]
                            ),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        
                        VStack(alignment: .leading, spacing: 12){
                            HStack{
                                Picker("", selection: $currentTab) {
                                    Text("All Time").tag("All Time")
                                    Text("1 Year").tag("1 Year")
                                    Text("90 Days").tag("90 Days")
                                }
                                .pickerStyle(.segmented)
                                .padding()
                            }
                        }
                        
                        Chart {
                            ForEach(data) { dataPoint in
                                
                                // creating line chart with smooth lines
                                LineMark(x: .value("Date", dataPoint.date),
                                         y: .value("INR", dataPoint.reading)
                                )
                                .interpolationMethod(.catmullRom)
                                .symbol(.circle)
                                
                                // adding shaded area under chart with gradient
                                AreaMark(x: .value("Date", dataPoint.date),
                                         yStart: .value("INR", 1.5),
                                         yEnd: .value("INR", dataPoint.reading)
                                )
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(curGradient)
                            }
                        }
                        .padding()
                    } else {
                        Text("No Data")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("INR Chart")
                        .font(.title)
                        .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            data = viewModel.chartData
        }
    }
}


#Preview {
    ChartView()
}
