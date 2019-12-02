import Foundation

let input = 325489

struct Coordinate {
	var x: Int
	var y: Int
	
	static let UP = Coordinate(x: 0, y: 1)
	static let RIGHT = Coordinate(x: 1, y: 0)
	static let DOWN = Coordinate(x: 0, y: -1)
	static let LEFT = Coordinate(x: -1, y: 0)
	static let Directions = [UP, RIGHT, DOWN, LEFT]
	
	func manhattanDistance(root: Coordinate) -> Int {
		let difference: Coordinate = self - root
		return difference.manhattanDistance()
	}
	
	func manhattanDistance() -> Int {
		return abs(x) + abs(y)
	}
	
	static func + (left: Coordinate, right: Coordinate) -> Coordinate {
		return Coordinate(x: left.x + right.x, y: left.y + right.y)
	}
	
	static func - (left: Coordinate, right: Coordinate) -> Coordinate {
		return Coordinate(x: left.x - right.x, y: left.y - right.y)
	}
	
	static func += (left: inout Coordinate, right: Coordinate) {
		left = left + right
	}
	
	static func -= (left: inout Coordinate, right: Coordinate) {
		left = left - right
	}
	
	static func from(radius: Int) -> Coordinate {
		return startValLocation(radius: radius)
	}
}


func radius(value: Int) -> Int {
	return Int(ceil((sqrt(Double(value))-1)/2))
}

func startVal(radius: Int) -> Int {
	return radius == 0 ? 1 : Int(pow(Double(((radius) * 2)-1), 2.0)+1)
}

func startValLocation(radius: Int) -> Coordinate {
	return Coordinate(x: radius, y: 1-radius)
}

func sideLength(radius: Int) -> Int {
	return 2*radius+1
}

func walk(from: Coordinate, fromVal: Int, to: Int, steps: Int, direction: Coordinate) 
		-> (val: Int, coord: Coordinate)
	{
		if (fromVal == to) {
			return (val: fromVal, coord: from)
		}
		
		var mutableFrom = from
		var mutableFromVal = fromVal
		var mutableSteps = steps
		while (mutableFromVal != to && mutableSteps > 0) {
			mutableFrom += direction
			mutableFromVal += 1
			mutableSteps -= 1
		}
	return (mutableFromVal, mutableFrom)
}

func walkTo(val: Int, radius: Int) -> Coordinate {
	var walkLocation = (val: startVal(radius: radius), coord: Coordinate.from(radius: radius))
	
	if (walkLocation.val == val) {
			return walkLocation.coord
		}
		walkLocation = walk(
			from: walkLocation.coord, 
			fromVal: walkLocation.val, 
			to: val, 
			steps: sideLength(radius: radius)-2, 
			direction: Coordinate.UP)
	
	for direction in [Coordinate.LEFT, Coordinate.DOWN, Coordinate.RIGHT] {
		if (walkLocation.val == val) {
			return walkLocation.coord
		}
		walkLocation = walk(
			from: walkLocation.coord, 
			fromVal: walkLocation.val, 
			to: val, 
			steps: sideLength(radius: radius)-1, 
			direction: direction)
	}
	
	return walkLocation.coord
}

func coordinatesFor(val: Int) -> Coordinate {
	return walkTo(val: val, radius: radius(value: val))
}

let valCoords = coordinatesFor(val: input)
print(valCoords.manhattanDistance())
