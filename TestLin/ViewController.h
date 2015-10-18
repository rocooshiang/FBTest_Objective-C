//
//  ViewController.h
//  TestLin
//
//  Created by Geosat-RD01 on 2015/6/1.
//  Copyright (c) 2015年 Geosat-RD01. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface ViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,FBSDKLoginButtonDelegate>
- (IBAction)cameraBtn:(id)sender;
- (IBAction)shareBtn:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet FBSDKLoginButton *loginBtn;
- (IBAction)customLoginBtn:(id)sender;

@end

