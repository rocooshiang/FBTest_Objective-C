//
//  BaseTextField.m
//  TainanDigLoad
//
//  Created by Geosat-RD01 on 2015/5/5.
//  Copyright (c) 2015年 Geosat-RD01. All rights reserved.
//

#import "BaseTextField.h"

@interface BaseTextField ()
{
  int prewTag ;  //UITextField的tag要設定,兩個tag要不同
  float prewMoveY; //编辑的时候移动的高度
}
@end

@implementation BaseTextField

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark textfield delegate
//keboard點擊"完成",隱藏keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
  [textField resignFirstResponder];
  return YES;
}

// 下面是為了防止鍵盤擋住UITextField的兩個方法
-(void) textFieldDidBeginEditing:(UITextField *)textField
{
  CGRect textFrame =  textField.frame;
  float textY = textFrame.origin.y+textFrame.size.height;
  //-44是因為上面的back bar高度佔了44
  float bottomY = self.view.frame.size.height-textY-44;
  if(bottomY>=216)  //判斷當前的高度是否已经有216，如果超過了就不需要再移动主界面的View高度
  {
    prewTag = -1;
    return;
  }
  prewTag = textField.tag;
  float moveY = 216-bottomY;
  prewMoveY = moveY;
  
  NSTimeInterval animationDuration = 0.30f;
  CGRect frame = self.view.frame;
  frame.origin.y -=moveY;//view的Y軸上移
  frame.size.height +=moveY; //View的高度增加
  self.view.frame = frame;
  [UIView beginAnimations:@"ResizeView" context:nil];
  [UIView setAnimationDuration:animationDuration];
  self.view.frame = frame;
  [UIView commitAnimations];//設置调整界面的動畫效果
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
  if(prewTag == -1) //當编辑的View不是需要移动的View
  {
    return;
  }
  float moveY ;
  NSTimeInterval animationDuration = 0.30f;
  CGRect frame = self.view.frame;
  if(prewTag == textField.tag) //當结束编辑的View的TAG是上次的就移动
  {   //還原界面
    moveY =  prewMoveY;
    frame.origin.y +=moveY;
    frame.size. height -=moveY;
    self.view.frame = frame;
  }
  //self.view移回原位置
  [UIView beginAnimations:@"ResizeView" context:nil];
  [UIView setAnimationDuration:animationDuration];
  self.view.frame = frame;
  [UIView commitAnimations];
  [textField resignFirstResponder];
}
@end
