//
//  BRPreviewViewController.m
//  AssetsLibraryDemo
//
//  Created by Brammanand Soni on 5/1/15.
//  Copyright (c) 2015 Brammanand Soni. All rights reserved.
//

#import "BRPreviewViewController.h"
#import "BRPreviewCell.h"
#import "BRPhotoPickerController.h"
#import "BR_ImageInfo+Image.h"
#import "UIImage+ResizeMagick.h"
#import "PECropViewController.h"

#define MAX_LIMIT 10

#define LEFT_MARGIN 30
#define TOP_MARGIN 20
#define SLIDE_COLLECTIONVIEW_TAG 111

#define THUMBNAIL_SIZE CGSizeMake(157.0, 157.0)

static NSString *thumbnailCellIdentifier = @"thumnailCell";
static NSString *addImageCellIdentifier = @"addImagesCell";


@interface BRPreviewViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,BRPhotoPickerControllerDelegate,UITextFieldDelegate,PECropViewControllerDelegate>
{
    CGSize cellSize;
}

@property (weak, nonatomic) IBOutlet UITextField *captionTextField;
@property (weak, nonatomic) IBOutlet UIView *thumbnailView;
@property (weak, nonatomic) IBOutlet UICollectionView *thumbnailCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *slideCollectionView;
@property (weak, nonatomic) IBOutlet UITextField *enterCaptionTextField;
@property (weak, nonatomic) IBOutlet UIView *enterCaptionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbnailViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic, strong) NSMutableArray *selectedAssetsArray;

@property (nonatomic, strong) BR_AssetsInfo *currentSelectedAssets;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *captionViewBottomConstraint;

- (IBAction)cancelPressed:(UIButton *)sender;
- (IBAction)donePressed:(UIButton *)sender;
- (IBAction)deletePressed:(UIButton *)sender;
- (IBAction)cropPressed:(UIButton *)sender;

@end

@implementation BRPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self paddingInTextField];
    
    [self observeKeyboard];
    self.selectedAssetsArray = [[NSMutableArray alloc] initWithArray:self.selectedAssets];
    
    self.currentSelectedAssets = [self.selectedAssetsArray firstObject];
    self.currentSelectedAssets.currectlySelected = YES;
    
    [self setCaptionLabelText:self.currentSelectedAssets.caption];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    cellSize = CGSizeMake((self.view.frame.size.width - 30)/5 , (self.view.frame.size.width - 30)/5);
}

#pragma mark - Private methods

- (void)paddingInTextField
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    self.enterCaptionTextField.leftView = paddingView;
    self.enterCaptionTextField.rightView = paddingView;
    self.enterCaptionTextField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)observeKeyboard
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)reloadData
{
    if (self.selectedAssetsArray.count > 0) {
        [self.slideCollectionView reloadData];
        [self.thumbnailCollectionView reloadData];
    }
    else {
        [self cancelPressed:nil];
    }
}

- (void)drawSelectionRectForAsset:(BR_AssetsInfo *)selectedAsset
{
    for (BR_AssetsInfo *info in self.selectedAssetsArray) {
        info.currectlySelected = NO;
    }
    selectedAsset.currectlySelected = YES;
    [self.thumbnailCollectionView reloadData];
}

- (UIImage *)resizeImage:(UIImage *)image forSize:(CGSize)size
{
    NSString *sizeString = [NSString stringWithFormat:@"%dx%d#", (int)size.width, (int)size.height];
    
    NSLog(@"%@", sizeString);
    
    UIImage *newImage = [image resizedImageByMagick:sizeString];
    
    return newImage;
}

- (void)setCaptionLabelText:(NSString *)text
{
    if (!text || [text isEqualToString:@""]) {
        self.captionTextField.text = @"Tap to add Caption";
    }
    else {
        self.captionTextField.text = text;
    }
}

#pragma mark
#pragma mark Keyboard Methods

- (void)keyboardDidShow:(NSNotification *)notification
{
    [self.enterCaptionTextField becomeFirstResponder];
}

// The callback for frame-changing of keyboard
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.captionViewBottomConstraint.constant = height;
    [self.view setNeedsUpdateConstraints];
    self.enterCaptionView.hidden = NO;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
        self.enterCaptionView.alpha = 1.0;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.captionViewBottomConstraint.constant = 0;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
        self.enterCaptionView.alpha = 0.0;
    }completion:^(BOOL finished) {
        self.enterCaptionView.hidden = YES;
    }];
}

#pragma mark  - IBActions

- (IBAction)cancelPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)donePressed:(UIButton *)sender {
    
    // Convert Assets_info to ImageInfo
    NSMutableArray *imageInfoArray = [NSMutableArray array];
    for (BR_AssetsInfo *assetsInfo in self.selectedAssetsArray) {
        BR_ImageInfo *imageInfo = [[BR_ImageInfo alloc] initWithImage:assetsInfo.originalImage andCaption:assetsInfo.caption];
        [imageInfoArray addObject:imageInfo];
    }
    
    self.block(imageInfoArray);
    
    [self dismissViewControllerAnimated:NO completion:^{
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(previewViewDidCancel:)]) {
            [self.delegate previewViewDidCancel:self];
        }
    }];
}

- (IBAction)deletePressed:(UIButton *)sender {
    NSInteger deletedIndex = [self.selectedAssetsArray indexOfObject:self.currentSelectedAssets];
    
    [self.selectedAssetsArray removeObject:self.currentSelectedAssets];
    
    if (deletedIndex == self.selectedAssetsArray.count) {
        self.currentSelectedAssets = [self.selectedAssetsArray lastObject];
        self.currentSelectedAssets.currectlySelected = YES;
    }
    else {
        self.currentSelectedAssets = [self.selectedAssetsArray objectAtIndex:deletedIndex];
        self.currentSelectedAssets.currectlySelected = YES;
    }
    
    [self reloadData];
}

- (IBAction)cropPressed:(UIButton *)sender {
    
    PECropViewController *cropper = [[PECropViewController alloc] init];
    cropper.delegate = self;
    cropper.rotationEnabled = NO;
    cropper.image = self.currentSelectedAssets.originalImage;
    cropper.keepingCropAspectRatio = YES;
    cropper.toolbarHidden = YES;
    
    UIImage *image = self.currentSelectedAssets.originalImage;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    cropper.imageCropRect = CGRectMake((width - length) / 2,
                                       (height - length) / 2,
                                       length,
                                       length);
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cropper];
    [self presentViewController:navigationController animated:YES completion:nil];
}


#pragma mark
#pragma mark ScrollView Delegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static NSInteger previousPage = 0;
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    
    if (previousPage != page) {
        previousPage = page;
        NSLog(@" page = %ld",(long)page);
        self.currentSelectedAssets = [self.selectedAssetsArray objectAtIndex:page];
        
        [self setCaptionLabelText:self.currentSelectedAssets.caption];
        
        [self drawSelectionRectForAsset:self.currentSelectedAssets];
    }
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == SLIDE_COLLECTIONVIEW_TAG) {
        return self.selectedAssetsArray.count;
    }
    else {
        if (self.selectedAssetsArray.count >= 5) {
            self.thumbnailViewHeightConstraint.constant = cellSize.height * 2 + 60;
        }
        else {
            self.thumbnailViewHeightConstraint.constant = cellSize.height + 60;
        }
        
        if (self.selectedAssetsArray.count < MAX_LIMIT) {
            return self.selectedAssetsArray.count + 1;
        }
        else {
            return self.selectedAssetsArray.count;
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == SLIDE_COLLECTIONVIEW_TAG) {
        BRPreviewCell *cell = [self.slideCollectionView dequeueReusableCellWithReuseIdentifier:thumbnailCellIdentifier forIndexPath:indexPath];
        [cell setSlideAssetsInfo:(BR_AssetsInfo *)[self.selectedAssetsArray objectAtIndex:indexPath.item]];
        return cell;
    }
    else {
        if ((self.selectedAssetsArray.count > 0) && (indexPath.item == self.selectedAssetsArray.count)) {
            UICollectionViewCell *cell = [self.thumbnailCollectionView dequeueReusableCellWithReuseIdentifier:addImageCellIdentifier forIndexPath:indexPath];
            return cell;
        }
        else {
            BRPreviewCell *cell = [self.thumbnailCollectionView dequeueReusableCellWithReuseIdentifier:thumbnailCellIdentifier forIndexPath:indexPath];
            [cell setThumbnailAssetsInfo:(BR_AssetsInfo *)[self.selectedAssetsArray objectAtIndex:indexPath.item]];
            return cell;
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == SLIDE_COLLECTIONVIEW_TAG) {
        return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
    }
    else {
        return CGSizeMake((collectionView.frame.size.width - 30)/5, (collectionView.frame.size.width - 30)/5);
    }
}

#pragma mark - UICollectionViewDelegate methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == SLIDE_COLLECTIONVIEW_TAG) {
        return;
    }
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if ([cell.reuseIdentifier isEqualToString:addImageCellIdentifier]) {
        NSLog(@"add cell pressed");
        [self performSegueWithIdentifier:@"photoPicker" sender:self];
    }
    else {
        [self.slideCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        
        [self drawSelectionRectForAsset:(BR_AssetsInfo *)[self.selectedAssetsArray objectAtIndex:indexPath.item]];
    }
}

#pragma mark - UIStoryboardSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"photoPicker"]) {
        BRPhotoPickerController *picker = [segue destinationViewController];
        picker.alreadySelectedAssets = self.selectedAssetsArray;
        picker.delegate = self;
        picker.block = self.block;
        picker.singleSelection = NO;
    }
}

#pragma mark - BRPhotoPickerControllerDelegate

- (void)photoPicker:(BRPhotoPickerController *)picker didFinishPickingMediaWithInfo:(NSMutableArray *)info
{
    self.selectedAssetsArray = info;
    [self reloadData];
}

- (void)photoPickerDidCancel:(BRPhotoPickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - PECropViewControllerDelegate

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    self.currentSelectedAssets.originalImage = croppedImage;
    self.currentSelectedAssets.thumbnail = [self resizeImage:croppedImage forSize:THUMBNAIL_SIZE];
    [self reloadData];
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}
 
#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.enterCaptionTextField.text = self.currentSelectedAssets.caption;
    
    self.doneButton.enabled = NO;
    self.doneButton.alpha = 0.7;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.doneButton.enabled = YES;
    self.doneButton.alpha = 1.0;
    
    [self setCaptionLabelText:textField.text];
    self.currentSelectedAssets.caption = textField.text;
    
    [self.view endEditing:YES];
    return YES;
}

@end
