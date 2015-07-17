//
//  BR_ImageInfo.m
//  AssetsLibraryDemo
//
//  Created by Brammanand Soni on 5/1/15.
//  Copyright (c) 2015 Brammanand Soni. All rights reserved.
//

#import "BR_ImageInfo.h"

@implementation BR_ImageInfo

@dynamic image;
@dynamic caption;


#pragma mark Property Implementations
- (UIImage *)image
{
    return self->image_;
}

- (NSString *)caption
{
    return self->caption_;
}

@end
