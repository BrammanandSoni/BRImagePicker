//
//  BRAssetsInfo.m
//  AssetsLibraryDemo
//
//  Created by Brammanand Soni on 4/30/15.
//  Copyright (c) 2015 Brammanand Soni. All rights reserved.
//

#import "BR_AssetsInfo.h"

@implementation BR_AssetsInfo

-(BOOL)isEqual:(id)object
{
    return ([[object imageURLString] isEqualToString:[self imageURLString]]);
}


@end
