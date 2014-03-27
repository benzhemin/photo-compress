//
//  RootViewController.m
//  PhotoCompress
//
//  Created by Bob on 3/19/14.
//  Copyright (c) 2014 chinapnr. All rights reserved.
//

#import "RootViewController.h"
#import "UIImage+Resize.h"

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    resize = CGSizeMake(640, 960);
    
    NSArray *segArr = @[@"320*480", @"480*640", @"640*960", @"800*1280", @"960*1280"];
    segControl = [[[UISegmentedControl alloc] initWithItems:segArr] autorelease];
    segControl.frame = CGRectMake(0, 100, 300, 40);
    segControl.selectedSegmentIndex = 2;
    [self.view addSubview:segControl];
    segControl.center = CGPointMake(self.view.center.x, segControl.center.y);
    [segControl addTarget:self action:@selector(segControlChanged:) forControlEvents:UIControlEventValueChanged];
    
    slider = [[[UISlider alloc] initWithFrame:CGRectMake(0, 180, 200, 20)] autorelease];
    slider.enabled = YES;
    slider.value = 1.0;
    [self.view addSubview:slider];
    slider.center = CGPointMake(self.view.center.x, slider.center.y);
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    valueLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 180, 50, 20)] autorelease];
    valueLabel.text = [NSString stringWithFormat:@"%.2f", slider.value];
    valueLabel.center = CGPointMake(segControl.frame.origin.x+30, valueLabel.center.y);
    [self.view addSubview:valueLabel];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(0, 0, 100, 40);
    
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.cornerRadius = 10;
    
    [btn setTitle:@"拍 照" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [btn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    btn.center = self.view.center;
}

-(void)segControlChanged:(id)sender{
    NSLog(@"seg changed");
    
    UISegmentedControl *seg = (UISegmentedControl *)sender;
    switch (seg.selectedSegmentIndex) {
        case 0:
            resize = CGSizeMake(320, 480);
            break;
        case 1:
            resize = CGSizeMake(480, 640);
            break;
        case 2:
            resize = CGSizeMake(640, 960);
            break;
        case 3:
            resize = CGSizeMake(800, 1280);
            break;
        case 4 :
            resize = CGSizeMake(960, 1280);
            break;
        default:
            break;
    }
}

-(void)sliderValueChanged:(id)sender{
    UISlider* control = (UISlider*)sender;
    
    valueLabel.text = [NSString stringWithFormat:@"%.2f", control.value];
    /* 添加自己的处理代码 */

}

-(void)pressBtn:(id)sender{
    
    UIImagePickerControllerSourceType sourceType= UIImagePickerControllerSourceTypeCamera;
    UIImagePickerController *pickerCTRL = [[UIImagePickerController alloc] init];
    pickerCTRL.delegate = self;
//    pickerCTRL.allowsEditing = YES;
    pickerCTRL.sourceType = sourceType;
    
    [self presentViewController:pickerCTRL animated:YES completion:nil];
    
    [pickerCTRL release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    NSLog(@"%@", NSStringFromCGSize(image.size));
    
    
    UIImage *resizedImg = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:resize interpolationQuality:kCGInterpolationHigh];
    NSLog(@"%@", NSStringFromCGSize(resizedImg.size));
    
    NSData *reImgData = UIImageJPEGRepresentation(resizedImg, valueLabel.text.floatValue);
    
    UIImage *compressedImg = [[[UIImage alloc] initWithData:reImgData] autorelease];
    UIImageWriteToSavedPhotosAlbum(compressedImg, nil, nil, nil);
    
    
    
    UIImageView *bgview = [[UIImageView alloc] init];
    bgview.bounds = self.view.bounds;
    bgview.layer.contentsGravity = kCAGravityResizeAspect;
    bgview.layer.contents = (id)resizedImg.CGImage;
    [self.view insertSubview:bgview belowSubview:segControl];
    bgview.center = self.view.center;
    [bgview release];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
