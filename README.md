# GooglePolyline

Swift implementation of [Google's Polyline algorithm](https://developers.google.com/maps/documentation/utilities/polylinealgorithm)

## Usage

### Encoding
```
let coordinates: [CLLocationCoordinate2D] = [...]
let polylineString: String = coordinates.googlePolyline
```

### Decoding
```
let polylineString: String = "..."
let coordinates: [CLLocationCoordinate2D] = CLLocationCoordinate2D.coordinates(fromPolyline: polylineString)
```
