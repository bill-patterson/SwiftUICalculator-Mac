//
//  ContentView.swift
//  SwiftUICalculator
//
//  Created by CallumHill on 19/9/21.
//
//  TODOs
//    add change-sign button and support
//

import SwiftUI

struct ContentView: View
{
	let grid = [
		["sp", "sp", "±", "/"],
		["7", "8", "9", "x"],
		["4", "5", "6", "-"],
		["1", "2", "3", "+"],
		[".", "0", "C", "="]
	]
	
	let operators = ["/", "+", "x", "-", "="]
	
	@State var visibleWorkings = ""
	@State var visibleResults = ""
	@State var showAlert = false
	
    var body: some View
	{
		VStack
		{
			HStack
			{
				Spacer()
				Text(visibleWorkings)
					.padding()
					.foregroundColor(Color.white)
					.font(.system(size: 30, weight: .heavy))
      }.frame(maxWidth: .infinity, maxHeight: 600)
			HStack
			{
				Spacer()
				Text(visibleResults)
					.padding()
					.foregroundColor(Color.white)
					.font(.system(size: 30, weight: .heavy))
      }.frame(maxWidth: .infinity, maxHeight: 120)
			
			ForEach(grid, id: \.self)
			{
				row in
				HStack
				{
					ForEach(row, id: \.self)
					{
						cell in
						
						Button(action: { buttonPressed(cell: cell)}, label: {
							Text(cell)
								.foregroundColor(buttonColor(cell))
								.font(.system(size: 20, weight: .heavy))
								.frame(maxWidth: .infinity, maxHeight: .infinity)
							
						})
						
					}
				}
			}
			
			
			
		}
		.background(Color.black.ignoresSafeArea())
		.alert(isPresented: $showAlert)
		{
			Alert(
				title: Text("Invalid Input"),
				message: Text(visibleWorkings),
				dismissButton: .default(Text("Okay"))
			)
		}
    }
	
	func buttonColor(_ cell: String) -> Color
	{
		if(cell == "C")
		{
			return .red
		}
		if (cell == "sp")
    {
      return .clear
    }
		if(cell == "-" || cell == "=" || operators.contains(cell))
		{
			return .orange
		}
		
		return .white
	}
	
	func buttonPressed(cell: String)
	{
		
		switch (cell)
		{
		case "C":
			visibleWorkings = ""
			visibleResults = ""
		case "=":
      visibleWorkings += cell // wrp
			visibleResults = calculateResults()
		case "-":
			addMinus()
		case "x", "/", "+":
			addOperator(cell)
    case "sp":  // ignore these buttons
      break
		default:
			visibleWorkings += cell
		}
		
	}
	
	func addOperator(_ cell : String)
	{
		if !visibleWorkings.isEmpty
		{
			let last = String(visibleWorkings.last!)
			if operators.contains(last)
			{
				visibleWorkings.removeLast()
			}
			visibleWorkings += cell
		}
	}
	
	func addMinus()
	{
		if visibleWorkings.isEmpty || visibleWorkings.last! != "-"
		{
			visibleWorkings += "-"
		}
	}
  
  func manualEvaluation() -> String
  {
    let workings = Array(visibleWorkings)
    var accum1 = 0
    var accum2 = 0
    var result = "0"
    var operation = ""
    var char1str = ""
    for char1 in workings {
      if char1 .isNumber {
        char1str = String(char1)
        if accum1 == 0 {
          accum1 = Int(char1str) ?? 0
        } else {
          accum1 = accum1 * 10 + (Int(char1str) ?? 0)
        }
      } else {
        switch (char1)
        {
          case "±":
            if (accum2 != 0)
            {
              accum2 = -accum2
              result = String(accum2)
            } else if (accum1 != 0) {
              accum1 = -accum1
            }
            break

          case "x", "/", "+", "-", "=":
            if (accum2 != 0) {  // already have both terms - resolve
              if (String(char1) != "=") {
                operation = String(char1)
              }
              accum2 = calcIntermitent(val1:accum1, val2:accum2, oper:operation)
              result = String(accum2)
              accum1 = 0
            } else if (accum1 != 0) {
              operation = String(char1)
              accum2 = accum1
              accum1 = 0
            }
          default:
            break
          }
        }
    }
    return result
  }
  
  func calcIntermitent(val1 : Int, val2 : Int, oper : String) -> Int
  {
    var result = 0
    
    switch (oper)
    {
      case "x":
      result = val1 * val2
      case "+":
      result = val1 + val2
      case "/":
      result = val2 / val2
      case "-":
      result = val2 - val2
      default:
      break
    }
    return result
  }
	  
  func calculateResults() -> String
	{
  /*
   if(validInput())
  {
    var workings = visibleWorkings
    workings = workings.replacingOccurrences(of: "x", with: "*")
    let expression = NSExpression(format: workings)
    let result = expression.expressionValue(with: nil, context: nil) as! Double
    return formatResult(val: result)
  }
   showAlert = true
   return ""
*/
  
  let results = manualEvaluation()
  return results

	}
  
	func validInput() -> Bool
	{
		if(visibleWorkings.isEmpty)
		{
			return false
		}
		let last = String(visibleWorkings.last!)
		
		if(operators.contains(last) || last == "-")
		{
			if(last != "x" || visibleWorkings.count == 1)
			{
				return false
			}
		}
		
		return true
	}
	
	func formatResult(val : Double) -> String
	{
		if(val.truncatingRemainder(dividingBy: 1) == 0)
		{
			return String(format: "%.0f", val)
		}
		
		return String(format: "%.2f", val)
	}
	
	
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
