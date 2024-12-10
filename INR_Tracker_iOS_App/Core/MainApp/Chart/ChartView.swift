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
    @State var showNewView = false
    @State private var trToggle = false
    @State private var avgToggle = false 
    @State private var minmaxToggle = false
    @State private var doseToggle = false
    @State private var currentTab = "All Time"
    @State var currentActiveItem: ChartPoint?
    
    @State var chartData: [ChartPoint]?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if viewModel.chartMin == nil {
                        VStack {
                            Text("No Data")
                            Text("Select 'New Test' to add data")
                        }
                    } else {
                        if var data = chartData {
                            // variables depeding on date filter
                            let yMin = viewModel.chartMin! - 0.2
                            let yMax = viewModel.chartMax! + 0.2
                            
                            let inrReadings = data.map { $0.reading }
                            let inrAverage = inrReadings.reduce(0, +) / Double(inrReadings.count)
                            let inrMinIdx = data.firstIndex { $0.reading == inrReadings.min() } ?? 0
                            let inrMaxIdx = data.firstIndex { $0.reading == inrReadings.max() } ?? 0
                            let inrMin = data[inrMinIdx].reading
                            let inrMax = data[inrMaxIdx].reading
                            
                            let doseReadings = data.map { $0.dose }
                            let doseMinIdx = data.firstIndex { $0.dose == doseReadings.min() } ?? 0
                            let doseMaxIdx = data.firstIndex { $0.dose == doseReadings.max() } ?? 0
                            let doseMin = data[doseMinIdx].dose
                            let doseMax = data[doseMaxIdx].dose
//                            let doseMinScaled = inrMin
//                            let doseMaxScaled = ((inrMax/2) - inrMin) + inrMin
                            
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
                            
                            Picker("", selection: $currentTab) {
                                Text("All Time").tag("All Time")
                                Text("1 Year").tag("1 Year")
                                Text("90 Days").tag("90 Days")
                            }
                            .pickerStyle(.segmented)
                            .padding()
                            
                            VStack {
                                VStack(alignment: .leading, spacing: 12){
                                    
                                    Chart {
                                        ForEach(data) { dataPoint in
                                            
                                            let doseScaled = ((dataPoint.dose - doseMin) / (doseMax - doseMin)) * ((inrMax/2) - inrMin) + inrMin
                                                                                        
                                            // creating line chart with smooth lines
                                            LineMark(x: .value("Date", dataPoint.date),
                                                     y: .value("INR", dataPoint.reading)
                                            )
                                            .interpolationMethod(.catmullRom)
                                            .symbol(.circle)
                                            .foregroundStyle(by: .value("Value", "INR"))
                                            
                                            // adding shaded area under chart with gradient
                                            AreaMark(x: .value("Date", dataPoint.date),
                                                     yStart: .value("INR", yMin),
                                                     yEnd: .value("INR", dataPoint.reading)
                                            )
                                            .interpolationMethod(.catmullRom)
                                            .foregroundStyle(curGradient)
                                            
                                            if doseToggle {
                                                LineMark(x: .value("Date", dataPoint.date),
                                                        y: .value("Dose", doseScaled)
                                                )
                                                .lineStyle(StrokeStyle(lineWidth: 4))
                                                .foregroundStyle(by: .value("Value", "Dose"))
                                            }
                                            
                                            // shows viertical line with card showing INR reading when currentActiveItem is not null and is equal to the date of the current point
                                            if let currentActiveItem, currentActiveItem.id == dataPoint.id {
                                                let date = formattedDate(currentActiveItem.date)
                                                
                                                RuleMark(x: .value("Date", currentActiveItem.date))
                                                .lineStyle(.init(lineWidth: 2, dash: [2], dashPhase: 5))
                                                .annotation(position: .top){
                                                    VStack(alignment: .leading, spacing: 6){
                                                        Text(String(date))
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
                                            PointMark(x: .value("Date", data[inrMinIdx].date),
                                                      y: .value("INR", inrMin))
                                            .foregroundStyle(.red)
                                            .annotation(position: .bottom,
                                                        alignment: .center) {
                                                Text("" + String(inrMin))
                                                    .fontWeight(.bold)
                                                    .padding(.horizontal, 10)
                                                    .padding(.vertical, 4)
                                                    .background{
                                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                            .fill(.white.shadow(.drop(radius: 2)))
                                                    }
                                            }
                                            
                                            PointMark(x: .value("Date", data[inrMaxIdx].date),
                                                      y: .value("INR", inrMax))
                                            .foregroundStyle(.red)
                                            .annotation(position: .top,
                                                        alignment: .center) {
                                                Text("" + String(inrMax))
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
                                        if let user = viewModel.currentUser{
                                            let minTR = Double(round(100 * user.minTR) / 100)
                                            let maxTR = Double(round(100 * user.maxTR) / 100)
                                            if trToggle {
                                                RuleMark(y: .value("MinTR", minTR))
                                                    .foregroundStyle(.red)
                                                    .annotation(position: .bottom,
                                                                alignment: .bottomLeading) {
                                                        Text("TR Min: \(String(describing: minTR))")
                                                            .fontWeight(.bold)
                                                            .padding(.horizontal, 10)
                                                            .padding(.vertical, 4)
                                                            .background{
                                                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                                    .fill(.white.shadow(.drop(radius: 2)))
                                                            }
                                                    }
                                                
                                                RuleMark(y: .value("MaxTR", maxTR))
                                                    .foregroundStyle(.red)
                                                    .annotation(position: .top,
                                                                alignment: .bottomLeading) {
                                                        Text("TR Max: \(String(describing: maxTR))")
                                                            .fontWeight(.bold)
                                                            .padding(.horizontal, 10)
                                                            .padding(.vertical, 4)
                                                            .background{
                                                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                                    .fill(.white.shadow(.drop(radius: 2)))
                                                            }
                                                    }
                                            }
                                        }
                                        
                                        // overlays average readings from current date filter as a line if toggle is selected
                                        if avgToggle {
                                            RuleMark(y: .value("Average", inrAverage))
                                                .foregroundStyle(.green)
                                                .lineStyle(StrokeStyle(lineWidth: 6, dash: [14,7]))
                                                .annotation(position: .automatic,
                                                            alignment: .bottomLeading) {
                                                    Text("Avg: " + String(format: "%.1f", inrAverage))
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
                                .chartYScale(domain: yMin ... yMax)
                                .chartForegroundStyleScale([
                                            "INR": .blue,
                                            "Dose": .orange
                                ])
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
                            } // end vstack with chart and picker
                            .background{
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.white.shadow(.drop(radius: 2)))
                            }
                            .padding()
                            
                            VStack(spacing: 10) {
                                HStack{
                                    Spacer()
                                    
                                    Toggle(isOn: $doseToggle) {
                                        Text("Dose")
                                    }
                                    
                                }
                                
                                HStack{
                                    Spacer()
                                    
                                    Toggle(isOn: $trToggle) {
                                        Text("Therapeutic Range")
                                    }
                                    
                                }
                                
                                HStack{
                                    Spacer()
                                    
                                    Toggle(isOn: $avgToggle) {
                                        Text("Average")
                                    }
                                    
                                }
                                
                                HStack{
                                    Spacer()
                                    
                                    Toggle(isOn: $minmaxToggle) {
                                        Text("Min/Max")
                                    }
                                    
                                }
                            } // end toggle vstack
                            .padding(.horizontal, 20)
                        } else {
                            ProgressView()
                        } // end if else to display Loading Wheel
                    } // end if else to display "No Data"
                } // end main vstack
                .frame(height: UIScreen.main.bounds.height - 200)
            } // end scroll view
            .fullScreenCover(isPresented: $showNewView, content: {
                NewTestView()
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("INR Chart")
                        .font(.title)
                        .fontWeight(.semibold)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showNewView.toggle()
                    } label: {
                        HStack{
                            Text("New Test")
                            
                            Image(systemName: "square.and.pencil.circle.fill")
                        }
                    }
                }
            }
            .onChange(of: currentTab) { oldTab, newTab in
                print("Changing tab from \(oldTab) to \(newTab)")
                updateChartData(for: newTab)
                print("Updated chart data: \(chartData?.count ?? 0) items")
            }
            .onAppear {
                chartData = viewModel.chartData
                currentTab = "All Time"
            }
        } // end nav stack
    }
    
    func updateChartData(for tab: String) {
        switch tab {
        case "90 Days":
            chartData = viewModel.ninetyDaysData
        case "1 Year":
            chartData = viewModel.oneYearData
        default:
            chartData = viewModel.chartData
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        return dateFormatter.string(from: date)
    }
}


#Preview {
    ChartView()
}
