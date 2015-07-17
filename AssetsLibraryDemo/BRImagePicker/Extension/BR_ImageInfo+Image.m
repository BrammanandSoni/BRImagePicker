//
//  BR_ImageInfo+Image.m
//  AssetsLibraryDemo
//
//  Created by Brammanand Soni on 5/1/15.
//  Copyright (c) 2015 Brammanand Soni. All rights reserved.
//

#import "BR_ImageInfo+Image.h"

@implementation BR_ImageInfo (Image)

- (id)initWithImage:(UIImage *)image andCaption:(NSString *)caption
{
    self = [super init];
    if (self) {
        self->image_ = image;
        self->caption_ = caption;
    }
    return self;
}

@end
