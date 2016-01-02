//
//  GPAPolylineEncoding.h
//  GooglePolylineApp
//
//  Created by Lukas Oslislo on 11/12/15.
//

#import <Foundation/Foundation.h>

@interface GPAPolylineEncoding : NSObject

/**
 *  Decodes a polyline from the google polyline format
 *  https://developers.google.com/maps/documentation/utilities/polylinealgorithm
 *
 *  @param asciiString polyline
 *
 *  @return NSArray of NSNumber objects with float values (lat, long, lat, long, ...)
 */
+ (NSArray<NSNumber *> *)decodePolyline: (NSString *)polylineString;

@end
