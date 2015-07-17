//
//  BRPhotoPickerController.m
//  AssetsLibraryDemo
//
//  Created by Brammanand Soni on 4/30/15.
//  Copyright (c) 2015 Brammanand Soni. All rights reserved.
//

#import "BRPhotoPickerController.h"
#import "BRPhotosCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "BR_AssetsInfo.h"
#import "BRPreviewViewController.h"

static NSString *cellIdentifier = @"photosCell";

#define MAX_IMAGE_COUNT 10

@interface BRPhotoPickerController ()<UICollectionViewDataSource,UICollectionViewDelegate,BRPreviewViewControllerDelegate>
{
    CGSize cellSize;
}

@property (strong, nonatomic) NSMutableArray *assetsDataArray;
@property (nonatomic, strong) NSMutableArray *selectedAssetsArray;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (weak, nonatomic) IBOutlet UICollectionView *photosCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *toastLabel;

- (IBAction)cancelPressed:(UIButton *)sender;
- (IBAction)donePressed:(UIButton *)sender;

@end

@implementation BRPhotoPickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.singleSelection) {
        self.doneButton.hidden = YES;
    }
    else {
        self.doneButton.hidden = NO;
    }
    
    self.assetsDataArray = [NSMutableArray array];
    self.selectedAssetsArray = [[NSMutableArray alloc] initWithArray:self.alreadySelectedAssets];
    
    self.photosCollectionView.delegate = self;
    self.photosCollectionView.dataSource = self;
    
    [self loadPhotos];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    cellSize = CGSizeMake((self.photosCollectionView.frame.size.width - 30)/5 , (self.photosCollectionView.frame.size.width - 30)/5);
}

#pragma mark - Private Methods

- (void)loadPhotos
{
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    
    if (status == ALAuthorizationStatusDenied ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"Please give this app permission to access your photo library in your settings app!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            NSLog(@"number of assets = %ld",(long)group.numberOfAssets);
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if(result == nil) {
                    return;
                }
                
                ALAssetRepresentation *representation = [result defaultRepresentation];
                
                BR_AssetsInfo *info = [[BR_AssetsInfo alloc] init];
                info.thumbnail = [UIImage imageWithCGImage:[result thumbnail]];
                info.originalImage = [UIImage imageWithCGImage:[representation fullResolutionImage]];
                info.imageURLString = [[representation url] absoluteString];
                info.isSelected = NO;
                
                for (BR_AssetsInfo *asset in self.selectedAssetsArray) {
                    if ([asset isEqual:info]) {
                        info.isSelected = YES;
                    }
                }
                
                [self.assetsDataArray addObject:info];
                
                [self.photosCollectionView reloadData];
                
            }];
        } failureBlock:^(NSError *error) {
            if (error.code == ALAssetsLibraryAccessUserDeniedError) {
                NSLog(@"user denied access, code: %li",(long)error.code);
            }else{
                NSLog(@"Other error code: %li",(long)error.code);
            }
        }];
    }
}

- (void)pushPreviewViewController
{
    
}

- (void)resetToast
{
    [UIView animateWithDuration:0.5 animations:^{
        self.toastLabel.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - IBActions

- (IBAction)cancelPressed:(UIButton *)sender {
    if (self.singleSelection) {
        self.block(nil);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)donePressed:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoPicker:didFinishPickingMediaWithInfo:)]) {
        [self.delegate photoPicker:self didFinishPickingMediaWithInfo:self.selectedAssetsArray];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoPickerDidCancel:)]) {
        [self.delegate photoPickerDidCancel:self];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetsDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BRPhotosCell *cell = [self.photosCollectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    BR_AssetsInfo *assetsInfo = (BR_AssetsInfo *)[self.assetsDataArray objectAtIndex:indexPath.row];
    [cell setAssetsInfo:assetsInfo];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.singleSelection) {
        [self.selectedAssetsArray removeAllObjects];
        [self.selectedAssetsArray addObject:(BR_AssetsInfo *)[self.assetsDataArray objectAtIndex:indexPath.item]];
        [self performSegueWithIdentifier:@"PreviewViewControllerSegue" sender:self];
    }
    else {
        BRPhotosCell *cell = (BRPhotosCell *)[collectionView cellForItemAtIndexPath:indexPath];
        BR_AssetsInfo *assetsInfo = (BR_AssetsInfo *)[self.assetsDataArray objectAtIndex:indexPath.item];
        
        if (!assetsInfo.isSelected) {
            if (self.selectedAssetsArray.count < 10) {
                assetsInfo.isSelected = !assetsInfo.isSelected;
                [self.selectedAssetsArray addObject:assetsInfo];
                [cell setAssetsInfo:assetsInfo];
            }
            else {
                CAKeyframeAnimation * anim = [ CAKeyframeAnimation animationWithKeyPath:@"transform" ] ;
                anim.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f) ],[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f) ] ] ;
                anim.autoreverses = YES ;
                anim.repeatCount = 2.0f ;
                anim.duration = 0.07f ;
                [cell.contentView.layer addAnimation:anim forKey:nil ] ;
                
                [UIView animateWithDuration:0.5 animations:^{
                    self.toastLabel.transform = CGAffineTransformMakeTranslation(0, self.toastLabel.frame.size.height);
                }completion:^(BOOL finished) {
                    [self performSelector:@selector(resetToast) withObject:nil afterDelay:1.5];
                }];
            }
        }
        else {
            assetsInfo.isSelected = !assetsInfo.isSelected;
            [self.selectedAssetsArray removeObject:assetsInfo];
            [cell setAssetsInfo:assetsInfo];
        }
        
        if (self.selectedAssetsArray.count > 0) {
            self.doneButton.enabled = YES;
        }
        else {
            self.doneButton.enabled = NO;
        }
        
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return cellSize;
}

#pragma mark - UIStoryboardSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PreviewViewControllerSegue"]) {
        BRPreviewViewController *previewVC = [segue destinationViewController];
        previewVC.delegate = self;
        previewVC.block = self.block;
        previewVC.selectedAssets = self.selectedAssetsArray;
    }
}

#pragma mark - BRPreviewViewControllerDelegate

- (void)previewViewDidCancel:(BRPreviewViewController *)previewViewController
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
