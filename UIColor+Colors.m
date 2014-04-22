//
//  UIColor+Colors.m
//  Howdy
//
//  Created by Edan Lichtenstein on 4/21/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import "UIColor+Colors.h"

@implementation UIColor (Colors)




//+ (UIColor *)colorWithHueDegrees:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness {
//    return [UIColor colorWithHue:(hue/360) saturation:saturation brightness:brightness alpha:1.0];
//}

+ (UIColor *)silverCool {
    
    return [UIColor colorWithRed:0.651 green:0.655 blue:0.722 alpha:1.0];
}

+ (UIColor *) purpleMagic {
    
    return [UIColor colorWithRed:0.447 green:0.204 blue:0.78 alpha:1.0];
}

+ (UIColor *) purpleLight{
    return [UIColor colorWithRed:0.608 green:0.42 blue:1 alpha:1.0];
}

+(UIColor *) purpleOcean{
    return [UIColor colorWithRed:0.184 green:0 blue:0.408 alpha:1.0];
}

+(UIColor *) silverSimple{

    return [UIColor colorWithRed:0.847 green:0.847 blue:0.812 alpha:1.0];
}



@end
