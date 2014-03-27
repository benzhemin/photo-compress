//
//  RootViewController.h
//  PhotoCompress
//
//  Created by Bob on 3/19/14.
//  Copyright (c) 2014 chinapnr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    CGSize resize;
    UISegmentedControl *segControl;
    UISlider *slider;
    UILabel *valueLabel;
}

@end
