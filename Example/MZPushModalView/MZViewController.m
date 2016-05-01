//
//  MZViewController.m
//  MZPushModalView
//
//  Created by monzy613 on 04/28/2016.
//  Copyright (c) 2016 monzy613. All rights reserved.
//

#import "MZViewController.h"
#import <MZPushModalView/MZPushModalView.h>

@interface MZViewController ()
@property (nonatomic) UIButton *triggerButton;
@property (nonatomic) MZPushModalView *pushModalView;
@end

@implementation MZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.triggerButton];
}

#pragma mark - actions
- (void)buttonPressed:(id)sender
{
    UIView *modalView = [self modalView];
    self.pushModalView = [MZPushModalView showModalView:modalView rootView:nil];
}

- (void)modalViewButtonPressed:(id)sender
{
    [self.pushModalView dismissModal];
}

- (UIView *)modalView
{
    UIView *modalView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height / 2)];
    modalView.backgroundColor = [UIColor redColor];
    CGFloat width = 50.0;
    CGFloat crossLength = 20.0;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button addTarget:self action:@selector(modalViewButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, width, width);
    button.clipsToBounds = YES;
    button.layer.cornerRadius = width / 2;
    button.backgroundColor = [UIColor blackColor];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path addLineToPoint:CGPointMake(crossLength, crossLength)];
    [path moveToPoint:CGPointMake(0, crossLength)];
    [path addLineToPoint:CGPointMake(crossLength, 0.0)];
    CAShapeLayer *crossLayer = [CAShapeLayer layer];
    crossLayer.path = path.CGPath;
    crossLayer.strokeColor = [UIColor whiteColor].CGColor;
    crossLayer.lineWidth = 5.0;
    crossLayer.lineCap = kCALineCapRound;
    crossLayer.frame = CGRectMake(0, 0, crossLength, crossLength);
    crossLayer.position = button.center;
    [button.layer addSublayer:crossLayer];
    button.center = modalView.center;
    [modalView addSubview:button];
    return modalView;
}

- (UIButton *)triggerButton
{
    if (!_triggerButton) {
        _triggerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        [_triggerButton setTitle:@"press me" forState:UIControlStateNormal];
        _triggerButton.backgroundColor = [UIColor blackColor];
        _triggerButton.center = CGPointMake(self.view.center.x, self.view.center.y);
        [_triggerButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _triggerButton;
}
@end
