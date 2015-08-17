# BRImagePicker
Choose multiple images from gallery. You can perform "Cropping" on image and you  can add "Caption" for each selected image.

![giphy](http://media.giphy.com/media/3oEduUKMD2jjqSUQmY/giphy.gif)


# Initialize BRImagePicker

    BRImagePicker *imagePicker = [[BRImagePicker alloc] initWithPresentingController:self];
    [imagePicker showPickerWithDataBlock:^(NSArray *data) {
        NSLog(@"Selected BR_ImageInfo = %@",data);
    }];
    
    
It will return an Array of "BR_ImageInfo" object, which is having "image" and "caption" property.
BR_ImageInfo object have image property which will give you the image after cropping.
