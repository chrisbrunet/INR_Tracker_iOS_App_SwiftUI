//
//  ChartView.swift
//  INR_Tracker_iOS_App
//
//  Created by Chris Brunet on 2024-01-02.
//

import SwiftUI
import Charts

struct ChartView: View {
    
    @StateObject var viewModel = ChartViewModel()
    
    // variables from user interface
    @State private var trToggle = false
    @State private var avgToggle = false
    @State private var minmaxToggle = false
    @State private var currentTab = "All Time"
    @State var currentActiveItem: ChartPoint?
    
    var body: some View {
        NavigationStack{
            VStack {
                VStack{
                    if viewModel.chartData != nil {
                        
                        var chartData = viewModel.chartData!
                        
                        // variables depeding on date filter
                        let readings = chartData.map { $0.reading }
                        let average = readings.reduce(0, +) / Double(readings.count)
                        let min = chartData.firstIndex { $0.reading == readings.min() } ?? 0
                        let max = chartData.firstIndex { $0.reading == readings.max() } ?? 0
                        
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
                            
                            
                            Chart {
                                ForEach(chartData) { dataPoint in
                                    
                                    // creating line chart with smooth lines
                                    LineMark(x: .value("Date", dataPoint.date),
                                             y: .value("INR", dataPoint.reading)
                                    )
                                    .interpolationMethod(.catmullRom)
                                    .symbol(.circle)
                                    
                                    // adding shaded area under chart with gradient
                                    AreaMark(x: .value("Date", dataPoint.date),
                                             yStart: .value("INR", viewModel.chartMin! - 0.2),
                                             yEnd: .value("INR", dataPoint.reading)
                                    )
                                    .interpolationMethod(.catmullRom)
                                    .foregroundStyle(curGradient)
                                }
                                
                                // overlays minimum and maximum readings from current date filter as points if toggle is selected
                                if minmaxToggle {
                                    PointMark(x: .value("Date", chartData[min].date),
                                              y: .value("INR", chartData[min].reading))
                                    .foregroundStyle(.red)
                                    .annotation(position: .bottom,
                                                alignment: .center) {
                                        Text("" + String(chartData[min].reading))
                                            .fontWeight(.bold)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background{
                                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                    .fill(.white.shadow(.drop(radius: 2)))
                                            }
                                    }
                                    
                                    PointMark(x: .value("Date", chartData[max].date),
                                              y: .value("INR", chartData[max].reading))
                                    .foregroundStyle(.red)
                                    .annotation(position: .top,
                                                alignment: .center) {
                                        Text("" + String(chartData[max].reading))
                                            .fontWeight(.bold)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 4)
                                            .background{
                                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                    .fill(.white.shadow(.drop(radius: 2)))
                                            }
                                    }
                                }
                                
                                // overlays therepeutic range as lines if toggle is selected
                                if trToggle {
                                    RuleMark(y: .value("MinTR", 2))
                                        .foregroundStyle(.red)
                                        .annotation(position: .bottom,
                                                    alignment: .bottomLeading) {
                                            Text("TR Min: 2.0")
                                                .fontWeight(.bold)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 4)
                                                .background{
                                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                        .fill(.white.shadow(.drop(radius: 2)))
                                                }
                                        }
                                    
                                    RuleMark(y: .value("MaxTR", 3.5))
                                        .foregroundStyle(.red)
                                        .annotation(position: .top,
                                                    alignment: .bottomLeading) {
                                            Text("TR Max: 3.5")
                                                .fontWeight(.bold)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 4)
                                                .background{
                                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                        .fill(.white.shadow(.drop(radius: 2)))
                                                }
                                        }
                                }
                                
                                // overlays average readings from current date filter as a line if toggle is selected
                                if avgToggle {
                                    RuleMark(y: .value("Average", average))
                                        .foregroundStyle(.green)
                                        .lineStyle(StrokeStyle(lineWidth: 6, dash: [14,7]))
                                        .annotation(position: .automatic,
                                                    alignment: .bottomLeading) {
                                            Text("Avg: " + String(format: "%.1f", average))
                                                .fontWeight(.bold)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 4)
                                                .background{
                                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                        .fill(.white.shadow(.drop(radius: 2)))
                                                }
                                        }
                                }
                            } // end chart
                        } // end vstack with picker and chart
                        .padding()
                        .chartYScale(domain: viewModel.chartMin! - 0.2 ... viewModel.chartMax! + 0.2)
                        .onChange(of: currentTab) { selection in
                            if selection == "90 Days" {
                                chartData = viewModel.ninetyDaysData!
                            } else if selection == "1 Year" {
                                chartData = viewModel.oneYearData!
                            } else {
                                chartData = viewModel.chartData!
                            }
                        }
                        
                    } else {
                        ProgressView()
                    }
                } // end main vstack
                .frame(maxHeight: UIScreen.main.bounds.height)
                
                VStack {
                    HStack{
                        Spacer()
                        
                        Toggle(isOn: $trToggle) {
                            Text("Therapeutic Range")
                        }
                        
                    }.padding()
                    
                    HStack{
                        Spacer()
                        
                        Toggle(isOn: $avgToggle) {
                            Text("Average")
                        }
                        
                    }.padding()
                    
                    HStack{
                        Spacer()
                        
                        Toggle(isOn: $minmaxToggle) {
                            Text("Min/Max")
                        }
                        
                    }.padding()
                } // end toggle vstack
            } // end main view vstack
        } // end nav view
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("INR Chart")
                    .font(.title)
                    .fontWeight(.semibold)
            }
        }
    }
}


#Preview {
    ChartView()
}
