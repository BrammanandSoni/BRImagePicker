//
//  ViewController.m
//  AssetsLibraryDemo
//
//  Created by Brammanand Soni on 4/29/15.
//  Copyright (c) 2015 Brammanand Soni. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "BRImagePicker.h"
#import "BR_ImageInfo.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UITableView *assetsTableView;

@property (nonatomic, strong) NSArray *selectedAssetsArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectPressed:(id)sender {
    BRImagePicker *imagePicker = [[BRImagePicker alloc] initWithPresentingController:self];
    [imagePicker showPickerWithDataBlock:^(NSArray *data) {
        
        // Each object in returned Array will be of type  "BR_ImageInfo"
        
        self.selectedAssetsArray = data;
        
        self.infoLabel.text = [NSString stringWithFormat:@"%lu  %@ selected.",(unsigned long)self.selectedAssetsArray.count, self.selectedAssetsArray.count==1 ? @"Asset" : @"Assets"];
        
        [self.assetsTableView reloadData];
    }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.selectedAssetsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    BR_ImageInfo *imageInfo = [self.selectedAssetsArray objectAtIndex:indexPath.row];
    
    cell.imageView.image = imageInfo.image;
    cell.textLabel.text = imageInfo.caption ? imageInfo.caption : @"No caption for image";
    
    return cell;
    
}

@end
