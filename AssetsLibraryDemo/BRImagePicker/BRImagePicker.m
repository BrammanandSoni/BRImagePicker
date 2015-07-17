//
//  BRImagePicker.m
//  AssetsLibraryDemo
//
//  Created by Brammanand Soni on 5/7/15.
//  Copyright (c) 2015 Brammanand Soni. All rights reserved.
//

#import "BRImagePicker.h"
#import "BRPhotoPickerController.h"

@interface BRImagePicker()

@property (nonatomic, strong) UIViewController *presentingViewController;

@end

@implementation BRImagePicker


-(id)initWithPresentingController:(UIViewController *)controller
{
    self = [super init];
    if (self) {
        self.presentingViewController = controller;
    }
    
    return self;
}

-(void)showPickerWithDataBlock:(void (^)(NSArray *data))block
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"BRPhotoPicker" bundle:nil];
    BRPhotoPickerController *photopicker = (BRPhotoPickerController *)[storyBoard instantiateViewControllerWithIdentifier:@"BRPhotoPickerController"];
    photopicker.singleSelection = YES;
    photopicker.block = block;
    [self.presentingViewController presentViewController:photopicker animated:YES completion:nil];
}

@end
