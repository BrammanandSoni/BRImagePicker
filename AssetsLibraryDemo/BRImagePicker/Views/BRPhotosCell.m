//
//  BRPhotosCell.m
//  AssetsLibraryDemo
//
//  Created by Brammanand Soni on 4/30/15.
//  Copyright (c) 2015 Brammanand Soni. All rights reserved.
//

#import "BRPhotosCell.h"

@interface BRPhotosCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImageView;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@end

@implementation BRPhotosCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.checkImageView.hidden = YES;
}

#pragma mark - Public Methods

- (void)setAssetsInfo:(BR_AssetsInfo *)info
{
    self.thumbnailImageView.image = info.thumbnail;
    
    if (info.isSelected) {
        self.checkImageView.hidden = NO;
    }
    else {
        self.checkImageView.hidden = YES;
    }
}

@end
