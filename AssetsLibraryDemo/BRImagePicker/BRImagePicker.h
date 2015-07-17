//
//  BRImagePicker.h
//  AssetsLibraryDemo
//
//  Created by Brammanand Soni on 5/7/15.
//  Copyright (c) 2015 Brammanand Soni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BRImagePicker : NSObject


-(id)initWithPresentingController:(UIViewController *)controller;

-(void)showPickerWithDataBlock:(void (^)(NSArray *data))block;

@end
