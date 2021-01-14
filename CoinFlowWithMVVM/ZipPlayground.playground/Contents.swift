import UIKit

var str = "Hello, playground"

let xAxis = ["mon", "tue", "wed"]
let yAxis = [4, 6, 8]

let zipped = zip(xAxis, yAxis)
let tuples = zipped.map({(key:$0, value:$1)})

print(tuples)


