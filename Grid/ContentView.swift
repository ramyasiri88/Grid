//
//  ContentView.swift
//  Grid
//
//  Created by Ramya Siripurapu on 2/25/24.

import SwiftUI
struct GridView: View {

    @Binding var gridData: [[Int]]
    @State var path = [[Int]]()
    @State var res = ""
    
            var body: some View {
                VStack {
                    ForEach(0..<gridData.count, id: \.self) { row in
                        HStack {
                            ForEach(0..<gridData[row].count, id: \.self) { col in
                             
                                TextField("", value: $gridData[row][col], formatter: NumberFormatter())
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width: 40)
                            }
                        }
                    }
                }
                
                Button(action: {
                    print("gridData: \(gridData)")
                    let coodinates = findLowestSumPath(gridData: gridData)

                    if coodinates.isEmpty {
                        print("error")
                        return
                    }
                   
                    var sum = 0
                    for coor in coodinates {
                        let cost = gridData[coor.1][coor.0]
                        print("row: \(coor.1), col: \(coor.0) -> cost: \(cost) ")
                        sum += cost
                    }
                    if sum >= 50 {
                        print("Cost exceeded 50 in all scenarios")
                        print("path: \(coodinates.map({$0.1}))")
                        print("No")
                        stringy(str: "No \n Totalcost: \(sum)\n" + "coordinates: \(coodinates)\n " + "path: \(coodinates.map({$0.1}))\n")
                        return
                    } else {
                        print("totalcost: \(sum)")
                        print("coordinates: \(coodinates) " )
                        print("path: \(coodinates.map({$0.1}))")
                        print("Yes")
                        stringy(str: "Yes \n Totalcost: \(sum)\n" + "coordinates: \(coodinates)\n " + "path: \(coodinates.map({$0.1+1}))\n")
                    }
                    
                }, label: {
                    Text("Calculate")
                })
                Text(res)
            }
            
            func stringy(str: String){
            self.res = str
            }
      
}
struct ContentView: View {
    
    // We can add Rows or columns as needed to the below Grid data
    
    @State var gridData: [[Int]] = [
        [3, 4, 1, 2, 8, 6],
        [6, 1, 8, 2, 7, 4],
        [5, 9, 3, 9, 9, 5],
        [8, 4, 1, 3, 2, 6]]
    
    var body: some View {
        VStack {
            GridView(gridData: $gridData)
            Spacer()
        }
        .padding()
    }
}

func findLowestSumPath(gridData: [[Int]]) -> [(Int, Int)] {
    let rows = gridData.count
    let cols = gridData[0].count
    
    // Create a DP array to store the minimum sum
    var dp = gridData
    
    // Calculate the minimum sum path
    for j in 1..<cols {
        for i in 0..<rows {
            var minVal = dp[i][j - 1]
            if i > 0 {
                minVal = min(minVal, dp[i - 1][j - 1])
            }
            if i < rows - 1 {
                minVal = min(minVal, dp[i + 1][j - 1])
            }
            dp[i][j] += minVal
        }
    }
    
    // Find the minimum sum in the last column
    var minSum = dp[0][cols - 1]
    var endRow = 0
    for i in 1..<rows {
        if dp[i][cols - 1] < minSum {
            minSum = dp[i][cols - 1]
            endRow = i
        }
    }
    
    // Trace back to find the path and calculate the final cost
    var path = [(cols - 1, endRow)]
    var currentRow = endRow
    var finalCost = minSum // Initialize final cost with the minimum sum
    for j in stride(from: cols - 2, through: 0, by: -1) {
        var nextRow = currentRow
        var minVal = dp[currentRow][j]
        if currentRow > 0 && dp[currentRow - 1][j] < minVal {
            minVal = dp[currentRow - 1][j]
            nextRow = currentRow - 1
        }
        if currentRow < rows - 1 && dp[currentRow + 1][j] < minVal {
            nextRow = currentRow + 1
        }
        currentRow = nextRow
        path.append((j, currentRow))
        finalCost += dp[currentRow][j] // Add cost of current cell to final cost
    }
    
    // Reverse the path since we traced it backwards
    path.reverse()
    
    return path
}

