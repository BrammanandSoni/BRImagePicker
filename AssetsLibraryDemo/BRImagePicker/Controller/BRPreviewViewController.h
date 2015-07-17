//
//  BRPreviewViewController.h
//  AssetsLibraryDemo
//
//  Created by Brammanand Soni on 5/1/15.
//  Copyright (c) 2015 Brammanand Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BRPreviewViewController;

@protocol BRPreviewViewControllerDelegate <NSObject>

- (void)previewViewDidCancel:(BRPreviewViewController *)previewViewController;

@end

@interface BRPreviewViewController : UIViewController

@property (nonatomic,strong) void(^block)(NSArray * data);
@property (nonatomic, weak) id <BRPreviewViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *selectedAssets;

@end
