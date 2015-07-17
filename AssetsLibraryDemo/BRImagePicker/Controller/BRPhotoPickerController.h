//
//  BRPhotoPickerController.h
//  AssetsLibraryDemo
//
//  Created by Brammanand Soni on 4/30/15.
//  Copyright (c) 2015 Brammanand Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BRPhotoPickerController;

@protocol BRPhotoPickerControllerDelegate <NSObject>

- (void)photoPicker:(BRPhotoPickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info;
- (void)photoPickerDidCancel:(BRPhotoPickerController *)picker;

@end

@interface BRPhotoPickerController : UIViewController

@property (nonatomic,strong) void(^block)(NSArray * data);
@property (nonatomic) BOOL singleSelection;
@property (nonatomic, strong) NSArray *alreadySelectedAssets;

@property (nonatomic,weak) id<BRPhotoPickerControllerDelegate> delegate;

@end
