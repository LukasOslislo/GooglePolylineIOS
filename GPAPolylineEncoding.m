//
//  GPAPolylineEncoding.m
//  GooglePolylineApp
//
//  Created by Lukas Oslislo on 11/12/15.
//

#import "GPAPolylineEncoding.h"

@implementation GPAPolylineEncoding

const int BIT_1 = 0b00000001;
const int BIT_2 = 0b00000010;
const int BIT_3 = 0b00000100;
const int BIT_4 = 0b00001000;
const int BIT_5 = 0b00010000;
const int BIT_6 = 0b00100000;
const int BIT_7 = 0b01000000;
const int BIT_8 = 0b10000000;

+ (NSArray *)bitArray {
    static NSArray *bitArray = nil;

    if (!bitArray) {
        bitArray = @[@(BIT_1), @(BIT_2), @(BIT_3), @(BIT_4), @(BIT_5)];
    }
    
    return bitArray;
}

+ (NSArray<NSNumber *> *)decodePolyline: (NSString *)polylineString {
    
    if (polylineString == (id)[NSNull null] || polylineString.length == 0) {
        return nil;
    }
    
    NSMutableArray<NSNumber *> *latLongs = [[NSMutableArray alloc]init];
    NSMutableArray *currentChunk = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < polylineString.length; i++) {
        unichar character = [polylineString characterAtIndex:i];
        int decimal = character - 63;
        
        [currentChunk addObject:@(decimal)];
        
        BOOL isEndOfChunk = !(decimal & BIT_6);
        
        if (isEndOfChunk) {
            float coordinateElement = [self.class coordinateElementFromChunk: currentChunk];
            
            if (latLongs.count >= 2) {
                NSNumber *preceedingElement = latLongs[latLongs.count-2];
                coordinateElement += preceedingElement.floatValue;
            }
            
            [latLongs addObject:@(coordinateElement)];
            [currentChunk removeAllObjects];
            
        }
    }

    return latLongs;
}

+ (float)coordinateElementFromChunk:(NSArray *)chunk {
    float coordinateElement = 0.0f;
    
    int result = 0;
    
    for (int j = 0; j < chunk.count; j++) {
        
        NSNumber *number5Bit = chunk[j];
        int value5Bit = number5Bit.intValue;
        
        // each is 5 bit long
        for (int i = 0; i < 5; i++) {
            NSNumber *bitPosition = [self.class bitArray][i];
            BOOL isBitSet = value5Bit & bitPosition.intValue;
            
            if (isBitSet) {
                int exponent = i+j*5;
                int intPos = powf(2, exponent);
                
                result |= intPos;
            }
        }
    }
    
    result = [self.class invertAndRightShift:result];
    
    coordinateElement = result / 1e5;
    coordinateElement = [[NSString stringWithFormat:@"%.5f",coordinateElement]floatValue];
    return coordinateElement;
}

+ (int)invertAndRightShift:(int)data8bit {

    int result = 0;
    
    BOOL isNegativeValue = data8bit & 1;
    result = data8bit >> 1;
    
    if (isNegativeValue) {
        result = ~result;
    }
    
    return result;
}

@end
