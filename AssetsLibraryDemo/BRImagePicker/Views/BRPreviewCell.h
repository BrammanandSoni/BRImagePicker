//
//  BRThumbnailCell.h
//  AssetsLibraryDemo
//
//  Created by Brammanand Soni on 5/1/15.
//  Copyright (c) 2015 Brammanand Soni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BR_AssetsInfo.h"

@interface BRPreviewCell : UICollectionViewCell

- (void)setThumbnailAssetsInfo:(BR_AssetsInfo *)assetsInfo;
- (void)setSlideAssetsInfo:(BR_AssetsInfo *)assetsInfo;

@end
