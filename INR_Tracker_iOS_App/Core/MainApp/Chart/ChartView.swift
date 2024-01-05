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
    
    @State var chartData: [ChartPoint]?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if let data = chartData  {
                        
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
                        
                        VStack {
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
                                    ForEach(data) { dataPoint in
                                        
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
                                        
                                        // shows viertical line with card showing INR reading when currentActiveItem is not null and is equal to the date of the current point
                                        if let currentActiveItem, currentActiveItem.id == dataPoint.id {
                                            RuleMark(x: .value("Date", currentActiveItem.date))
                                                .lineStyle(.init(lineWidth: 2, dash: [2], dashPhase: 5))
                                                .annotation(position: .top){
                                                    VStack(alignment: .leading, spacing: 6){
                                                        Text("INR")
                                                            .font(.caption)
                                                            .foregroundColor(.gray)
                                                        Text(String(currentActiveItem.reading))
                                                            .font(.title3.bold())
                                                    }
                                                    .padding(.horizontal, 10)
                                                    .padding(.vertical, 4)
                                                    .background{
                                                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                                                            .fill(.white.shadow(.drop(radius: 2)))
                                                    }
                                                }
                                        }
                                        
                                    }
                                    
                                    // overlays minimum and maximum readings from current date filter as points if toggle is selected
                                    if minmaxToggle {
                                        PointMark(x: .value("Date", data[min].date),
                                                  y: .value("INR", data[min].reading))
                                        .foregroundStyle(.red)
                                        .annotation(position: .bottom,
                                                    alignment: .center) {
                                            Text("" + String(data[min].reading))
                                                .fontWeight(.bold)
                                                .padding(.horizontal, 10)
                                                .padding(.vertical, 4)
                                                .background{
                                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                        .fill(.white.shadow(.drop(radius: 2)))
                                                }
                                        }
                                        
                                        PointMark(x: .value("Date", data[max].date),
                                                  y: .value("INR", data[max].reading))
                                        .foregroundStyle(.red)
                                        .annotation(position: .top,
                                                    alignment: .center) {
                                            Text("" + String(data[max].reading))
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
                            // getting data from drag gesture and setting currentActiveItem
                            .chartOverlay(content: {proxy in
                                GeometryReader{innerProxy in
                                    Rectangle()
                                        .fill(.clear).contentShape(Rectangle())
                                        .gesture(
                                            DragGesture()
                                                .onChanged{ value in
                                                    let location = value.location
                                                    if let touchDate: Date = proxy.value(atX: location.x){
                                                        
                                                        let calendar = Calendar.current
                                                        let day = calendar.component(.day, from: touchDate)
                                                        let month = calendar.component(.month, from: touchDate)
                                                        let year = calendar.component(.year, from: touchDate)
                                                        
                                                        if let currentItem = data.first(where: { item in
                                                            calendar.component(.day, from: item.date) == day &&
                                                            calendar.component(.month, from: item.date) == month &&
                                                            calendar.component(.year, from: item.date) == year
                                                        }){
                                                            self.currentActiveItem = currentItem
                                                        }
                                                    }
                                                }.onEnded{value in
                                                    self.currentActiveItem = nil
                                                }
                                        )
                                }
                            })
                            //                    .onAppear {
                            //                        for (index,_) in chartData.enumerated(){
                            //                            DispatchQueue.main.asyncAfter(deadline: .now()){
                            //                                withAnimation(.interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.8)){
                            //                                    chartData[index].animate = true
                            //                                }
                            //                            }
                            //                        }
                            //                    }
                        } // end main vstack
                        
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
                    } else {
                        ProgressView()
                    }
                }
                .frame(height: UIScreen.main.bounds.height - 175)
            } // end scroll view
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("INR Chart")
                        .font(.title)
                        .fontWeight(.semibold)
                }
            }
            .onChange(of: currentTab, perform: { newTab in
                viewModel.updateChartData(for: newTab)
            })
            .onAppear {
                Task {
                    await DataService.shared.fetchTests()
                    viewModel.prepareChartData()
                    viewModel.updateChartData(for: currentTab)
                    chartData = viewModel.chartData
                }
            }
        } // end nav stack
    }
}


#Preview {
    ChartView()
}
