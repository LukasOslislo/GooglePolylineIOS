# GooglePolylineIOS

This class is written in Objective-C for iOS Projects, it decodes a polyline encoded in the Google Polyline Format.

Simply call decodePolyline and pass the string:

```objc
NSArray *geoPositions = [GPAPolylineEncoding decodePolyline:encoded];
```

As a result you will get an NSArray containing geo coordinates as NSNumbers like: lat, long, lat, long, lat...
To create an Array with CLLocations you could use such a code snippet in your App:

```objc
+(NSArray<CLLocation *> *)dataToCoordinates:(NSString *)data {
    
    NSArray *polylineElements = [GPAPolylineEncoding decodePolyline:data];
    
    if (!polylineElements || polylineElements.count < 2 || polylineElements.count % 2) {
        return nil;
    }
    
    NSMutableArray *coordinates = [[NSMutableArray alloc]init];
    
    for (int i = 2; i < polylineElements.count; i+=2) {
        
        NSNumber *lat = polylineElements[i-2];
        NSNumber *lon = polylineElements[i-1];
        
        CLLocation *coordinate = [[CLLocation alloc]initWithLatitude:lat.floatValue longitude:lon.floatValue];
        [coordinates addObject:coordinate];
    }
    
    return coordinates;
}
```
