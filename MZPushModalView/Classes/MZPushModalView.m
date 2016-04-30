//
//  MZPushModalView.m
//  Pods
//
//  Created by 张逸 on 16/4/28.
//
//

static NSTimeInterval durationBack = 0.25;
static NSTimeInterval durationForward = 0.25;

#import "MZPushModalView.h"
@interface MZPushModalView ()
@property (nonatomic) BOOL animating;
@property (nonatomic) UIView *rootView;
@property (nonatomic) UIImageView *snapShotView;
@property (nonatomic) UIView *modalView;
@property (nonatomic) UIView *blackView;
@property (nonatomic, readonly) CGFloat angle;
@property (nonatomic, readonly) CGPoint modalViewShowCenter;
@property (nonatomic, readonly) CGPoint modalViewDismissCenter;
@end

@implementation MZPushModalView

+ (instancetype)showModalView:(UIView *)modalView rootView:(UIView *)rootView
{
    MZPushModalView *pushModalView = [[MZPushModalView alloc] initWithModalView:modalView rootView:rootView];
    [pushModalView.rootView addSubview:pushModalView];
    [pushModalView showModal];
    return pushModalView;
}

+ (instancetype)showModalView:(UIView *)modalView rootView:(UIView *)rootView direction:(MZPushModalViewShowDirection)direction
{
    MZPushModalView *pushModalView = [[MZPushModalView alloc] initWithModalView:modalView rootView:rootView];
    pushModalView.direction = direction;
    [pushModalView.rootView addSubview:pushModalView];
    [pushModalView showModal];
    return pushModalView;
}

- (instancetype)initWithModalView:(UIView *)modalView rootView:(UIView *)rootView
{
    UIView *root = rootView == nil? [MZPushModalView mainWindow]: rootView;
    self = [super initWithFrame:root.bounds];
    if (self) {
        self.rootView = root;
        self.modalView = modalView;
        self.snapShotView = [self snapShot:self.rootView];
        self.height = self.modalView.bounds.size.height;
        [self addSubview:self.blackView];
        [self addSubview:self.snapShotView];
        [self addSubview:self.modalView];
        self.modalView.layer.transform = CATransform3DMakeTranslation(0, 0, sin(self.angle) * CGRectGetHeight(self.bounds) / 2);
        self.direction = MZPushModalViewShowFromBottom;
    }
    return self;
}

- (void)showModal
{
    if (self.animating) {
        return;
    } else {
        self.animating = YES;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissModal)];
    [self.snapShotView addGestureRecognizer:tap];
    [self.blackView addGestureRecognizer:tap];

    [UIView animateWithDuration:[self totalDuration] animations:^{
        self.modalView.center = self.modalViewShowCenter;
    } completion:^(BOOL finished) {
        if (finished) {
            self.animating = NO;
        }
    }];

    CGFloat zMove = -fabs(sin(self.angle) * CGRectGetHeight(self.bounds) / 2);
    for (UIView *subview in [self subviews]) {
        if (![subview isEqual:self.snapShotView] && ![subview isEqual:self.modalView]) {
            subview.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, zMove * 2);
        }
    }

    [UIView animateWithDuration:durationBack animations:^{
        //dismissOldView
        CATransform3D transform = CATransform3DIdentity;
        transform.m34 = -1.0 / 500.0;
        transform = CATransform3DRotate(transform, self.angle, 1, 0, 0);
        transform = CATransform3DTranslate(transform, 0, 0, zMove);
        self.snapShotView.layer.transform = transform;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:durationForward animations:^{
                CATransform3D transform = self.snapShotView.layer.transform;
                transform.m34 = -1.0 / 500.0;
                transform = CATransform3DRotate(transform, -self.angle, 1, 0, 0);
                self.snapShotView.layer.transform = transform;
            }];
        }
    }];
}

- (void)dismissModal
{
    if (self.animating) {
        return;
    } else {
        self.animating = YES;
    }
    [UIView animateWithDuration:[self totalDuration] animations:^{
        self.modalView.center = self.modalViewDismissCenter;
    } completion:^(BOOL finished) {
        if (finished) {
            self.animating = NO;
            [self.modalView removeFromSuperview];
            self.modalView = nil;
        }
    }];

    [UIView animateWithDuration:durationBack animations:^{
        CATransform3D transform = self.snapShotView.layer.transform;
        transform = CATransform3DRotate(transform, self.angle, 1, 0, 0);
        transform.m34 = -1.0 / 500.0;
        self.snapShotView.layer.transform = transform;
    } completion:^(BOOL finished) {
        if (finished) {
            [UIView animateWithDuration:durationForward animations:^{
                self.snapShotView.layer.transform = CATransform3DIdentity;
            } completion:^(BOOL finished) {
                if (finished) {
                    for (UIView *subview in [self subviews]) {
                        if (![subview isEqual:self.snapShotView] && ![subview isEqual:self.modalView]) {
                            subview.layer.transform = CATransform3DIdentity;
                        }
                    }
                    [self.blackView removeFromSuperview];
                    self.blackView = nil;
                    [self.snapShotView removeFromSuperview];
                    self.snapShotView = nil;
                    [self removeFromSuperview];
                }
            }];
        }
    }];
}

#pragma mark - privates
+ (UIView *)mainWindow
{
    NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];

    for (UIWindow *window in frontToBackWindows)
        if (window.windowLevel == UIWindowLevelNormal) {
            return window;
        }
    return nil;
}


- (UIImageView *)snapShot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapShotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIImageView *imageView = [[UIImageView alloc] initWithImage:snapShotImage];
    imageView.frame = view.bounds;
    return imageView;
}

#pragma mark - getters setters
- (void)setDirection:(MZPushModalViewShowDirection)direction
{
    _direction = direction;
    switch (_direction) {
        case MZPushModalViewShowFromBottom:
            self.modalView.center = CGPointMake(self.center.x, self.bounds.size.height + self.height / 2);
            break;
        case MZPushModalViewShowFromTop:
            self.modalView.center = CGPointMake(self.center.x, -self.height / 2);
            break;
    }
}

- (CGPoint)modalViewShowCenter
{
    switch (_direction) {
        case MZPushModalViewShowFromBottom:
            return CGPointMake(self.center.x, self.bounds.size.height - self.height / 2);
            break;
        case MZPushModalViewShowFromTop:
            return CGPointMake(self.center.x, self.height / 2);
            break;
    }

}

- (CGPoint)modalViewDismissCenter
{
    switch (_direction) {
        case MZPushModalViewShowFromBottom:
            return CGPointMake(self.center.x, self.bounds.size.height + self.height / 2);
            break;
        case MZPushModalViewShowFromTop:
            return CGPointMake(self.center.x, -self.height / 2);
            break;
    }
}

- (UIView *)blackView
{
    if (!_blackView) {
        _blackView = [[UIView alloc] initWithFrame:self.bounds];
        _blackView.backgroundColor = [UIColor blackColor];
    }
    return _blackView;
}

- (NSTimeInterval)totalDuration
{
    return durationForward + durationBack;
}

- (CGFloat)angle
{
    return M_PI_4 / 3 * self.direction;
}
@end
