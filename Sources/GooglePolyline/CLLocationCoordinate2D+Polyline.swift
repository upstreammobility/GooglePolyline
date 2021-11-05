
import MapKit

// MARK: Encoding
extension Array where Element == CLLocationCoordinate2D {
    
    public var googlePolyline: String {
        return encodedCoordinates()
    }
    
    func encodedCoordinates() -> String {
        var encoded = ""
        var lastLat = 0.0
        var lastLng = 0.0
        
        for coordinate in self {
            let lat = round(coordinate.latitude * 1E5)
            let lng = round(coordinate.longitude * 1E5)
            
            encoded += encodeNumber(lat - lastLat)
            encoded += encodeNumber(lng - lastLng)
            
            lastLat = lat
            lastLng = lng
        }
        return encoded
    }
    
    func encodeNumber(_ number: CLLocationDegrees) -> String {
        var intNumber = Int(number)
        intNumber = intNumber < 0 ? ~(intNumber << 1) : intNumber << 1
        
        var encoded = ""
        while intNumber >= 0x20 {
            encoded.append(Character(Unicode.Scalar(((intNumber & 0x1f) | 0x20) + 63)!))
            intNumber >>= 5
        }
        encoded.append(Character(Unicode.Scalar(intNumber + 63)!))
        return encoded
    }
}

// MARK: Decoding
extension CLLocationCoordinate2D {
    public static func coordinates(fromPolyline polyline: String) -> [CLLocationCoordinate2D] {
        var coordinates = [CLLocationCoordinate2D]()
        var lastPosition: CLLocationCoordinate2D?
        var index: String.Index = polyline.startIndex
        
        while index < polyline.endIndex {
            let lat = decode(polyline: polyline, index: &index, previousValue: lastPosition?.latitude ?? 0)
            let lng = decode(polyline: polyline, index: &index, previousValue: lastPosition?.longitude ?? 0)
            let position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            coordinates.append(position)
            lastPosition = position
        }

        return coordinates
    }
    
    static func decode(polyline: String, index: inout String.Index, previousValue: CLLocationDegrees = 0) -> CLLocationDegrees {
        var result = 1
        var shift = 0
        var byte = 0
        
        repeat {
            byte = Int(Int(polyline[index].asciiValue ?? 0) - 63 - 1)
            index = polyline.index(after: index)
            result += byte << shift
            shift += 5
        } while byte >= 0x1f
        let number = Double((result & 1) != 0 ? ~(result >> 1) : (result >> 1))
        return (number + (previousValue * 1E5)) * 1E-5 
    }
}

