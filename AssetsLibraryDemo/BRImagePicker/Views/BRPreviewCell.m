//
//  BRThumbnailCell.m
//  AssetsLibraryDemo
//
//  Created by Brammanand Soni on 5/1/15.
//  Copyright (c) 2015 Brammanand Soni. All rights reserved.
//

#import "BRPreviewCell.h"

@interface BRPreviewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UIImageView *slideImageView;

@end

@implementation BRPreviewCell

- (void)setThumbnailAssetsInfo:(BR_AssetsInfo *)assetsInfo
{
    self.thumbnailImageView.image = assetsInfo.thumbnail;
    
    if (assetsInfo.currectlySelected) {
        self.layer.borderWidth = 3.0;
        self.layer.borderColor = [UIColor blueColor].CGColor;
    }
    else {
        self.layer.borderWidth = 0.0;
    }
}

- (void)setSlideAssetsInfo:(BR_AssetsInfo *)assetsInfo
{
    self.slideImageView.image = assetsInfo.originalImage;
}

@end
