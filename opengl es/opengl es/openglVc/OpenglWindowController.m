//
//  OpenglWindowController.m
//  opengl es
//
//  Created by lotus on 2021/1/21.
//

#import "OpenglWindowController.h"

@interface OpenglWindowController ()
@property (nonatomic, strong) UIButton *backButton;
@end

@implementation OpenglWindowController

-(void)viewDidLoad{
    
    self.view.backgroundColor = [UIColor colorWithRed:122 green:0 blue:0 alpha:255];
          
    [self createBackButton];
}

- (void)createBackButton {
    self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 30, 45, 45)];
    [self.backButton setImage:[UIImage imageNamed:@"mod_close"] forState:UIControlStateNormal];
    self.backButton.adjustsImageWhenHighlighted = NO;
    [self.backButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
}

#pragma mark - 点击事件
- (void)backClick:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
