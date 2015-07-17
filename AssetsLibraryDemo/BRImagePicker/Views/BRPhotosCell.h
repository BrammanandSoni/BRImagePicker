//
//  BRPhotosCell.h
//  AssetsLibraryDemo
//
//  Created by Brammanand Soni on 4/30/15.
//  Copyright (c) 2015 Brammanand Soni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "BR_AssetsInfo.h"

@interface BRPhotosCell : UICollectionViewCell

- (void)setAssetsInfo:(BR_AssetsInfo *)info;

@end
