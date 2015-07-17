//
//  BR_ImageInfo.h
//  AssetsLibraryDemo
//
//  Created by Brammanand Soni on 5/1/15.
//  Copyright (c) 2015 Brammanand Soni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BR_ImageInfo : NSObject {
    
    @private
    UIImage *image_;
    NSString *caption_;
}

@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) NSString *caption;

@end
