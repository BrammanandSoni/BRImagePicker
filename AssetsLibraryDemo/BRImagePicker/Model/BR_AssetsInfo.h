//
//  BRAssetsInfo.h
//  AssetsLibraryDemo
//
//  Created by Brammanand Soni on 4/30/15.
//  Copyright (c) 2015 Brammanand Soni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BR_ImageInfo.h"


@interface BR_AssetsInfo : NSObject

@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) UIImage *originalImage;
@property (nonatomic, strong) NSString *imageURLString;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic) BOOL isSelected;

@property (nonatomic) BOOL currectlySelected;

@end
