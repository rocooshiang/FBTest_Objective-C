//
//  ViewController.m
//  TestLin
//
//  Created by Geosat-RD01 on 2015/6/1.
//  Copyright (c) 2015年 Geosat-RD01. All rights reserved.
//

#import "Global.h"
#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <AVFoundation/AVFoundation.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface ViewController ()

@end

@implementation ViewController

NSDictionary *getUserInfoParameter;

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _loginBtn.delegate = self;
  _loginBtn.readPermissions = @[@"public_profile", @"email", @"user_friends"];
  _loginBtn.publishPermissions = @[@"publish_actions"];
  
  //picture.width(100).height(100) 可是取得寬高100的照片
  getUserInfoParameter = @{@"fields": @"id, name , email , picture.width(100).height(100)"};
  
  _describe.returnKeyType = UIReturnKeyDone;
  _describe.delegate = self;
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)useCamera{
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  picker.delegate = self;
  picker.allowsEditing = NO;
  picker.sourceType = UIImagePickerControllerSourceTypeCamera;
  
  [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Image Picker Controller delegate methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
  //照片轉向
  image = [Global rotateImage:image];
  if(image.size.height>1024||image.size.width>1024){
    //照片大小: 1024*768
    if(image.size.height>image.size.width){
      image = [Global resizeImage:image scaledToSize:CGSizeMake(768, 1024)];
    }else{
      image = [Global resizeImage:image scaledToSize:CGSizeMake(1024, 768)];
    }
  }
  [_imageView setHidden:NO];
  [_imageView setImage:image];
  [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)cameraBtn:(id)sender {
  [self useCamera];
}

- (IBAction)shareBtn:(id)sender {
  if([FBSDKAccessToken currentAccessToken]){
    if(!_imageView.isHidden){
      [Global startProgressHUD:self.view andMessage:@"上傳中..."];
      NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
      [params setObject:_describe.text forKey:@"message"];
      [params setObject:UIImagePNGRepresentation(_imageView.image) forKey:@"picture"];
      
      FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                    initWithGraphPath:@"/me/photos"
                                    parameters:params
                                    HTTPMethod:@"POST"];
      [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                            id result,
                                            NSError *error) {
        // Handle the result
        if (error){
          [self showAlert:@"上傳失敗" withMessage:nil];
        }else{
          [self showAlert:@"上傳成功" withMessage:nil];
          [_imageView setHidden:YES];
        }
        [Global stopProgressHUD];
      }];
    }else{
      [self showAlert:@"請先拍照" withMessage:nil];
    }
  }else{
    [self showAlert:@"請先登入Facebook" withMessage:nil];
  }
  
}

-(void)showAlert:(NSString *)title withMessage:(NSString *)message {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
  [alertView show];
}

#pragma mark - FBSDKLoginButtonDelegate
-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
  
  //判斷使用者已經登入
  if ([FBSDKAccessToken currentAccessToken]) {

    //取得使用者資訊
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me"
                                  parameters:getUserInfoParameter
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
      if(!error){
        [self setUserInfo:result];
      }
    }];
  }
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
  _userName.text = @"未登入";
  _userImage.image = [UIImage imageNamed:@"white"];
}

- (IBAction)customLoginBtn:(id)sender {
  
  FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
  
  [login logInWithPublishPermissions:@[@"publish_actions"] handler:^(FBSDKLoginManagerLoginResult *result ,NSError *error){
    
    //取得資訊
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:getUserInfoParameter]startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,id result,NSError *error){
      if(!error){
        [self setUserInfo:result];
      }
    }];
  }];
}

-(void)setUserInfo:(id )result{
  _userName.text = [result objectForKey:@"name"];
  NSString *imgUrl = [[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"];
  NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
  _userImage.image = [UIImage imageWithData:data];
}
@end
