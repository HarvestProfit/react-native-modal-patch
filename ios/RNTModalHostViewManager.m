/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "RNTModalHostViewManager.h"

#import <React/RCTBridge.h>
#import "RNTModalHostView.h"
#import "RNTModalHostViewController.h"
#import <React/RCTShadowView.h>
#import <React/RCTUtils.h>

@implementation RCTConvert (RNTModalHostView)

RCT_ENUM_CONVERTER(UIModalPresentationStyle, (@{
  @"fullScreen": @(UIModalPresentationFullScreen),
#if !TARGET_OS_TV
  @"pageSheet": @(UIModalPresentationPageSheet),
  @"formSheet": @(UIModalPresentationFormSheet),
#endif
  @"overFullScreen": @(UIModalPresentationOverFullScreen),
}), UIModalPresentationFullScreen, integerValue)

@end

@interface RNTModalHostShadowView : RCTShadowView

@end

@implementation RNTModalHostShadowView

- (void)insertReactSubview:(id<RCTComponent>)subview atIndex:(NSInteger)atIndex
{
  [super insertReactSubview:subview atIndex:atIndex];
  if ([subview isKindOfClass:[RCTShadowView class]]) {
    ((RCTShadowView *)subview).size = RCTScreenSize();
  }
}

@end

@interface RNTModalHostViewManager () <RNTModalHostViewInteractor>

@end

@implementation RNTModalHostViewManager
{
  NSPointerArray *_hostViews;
}

RCT_EXPORT_MODULE(RNTModal)

- (UIView *)view
{
  RNTModalHostView *view = [[RNTModalHostView alloc] initWithBridge:self.bridge];
  view.delegate = self;
  if (!_hostViews) {
    _hostViews = [NSPointerArray weakObjectsPointerArray];
  }
  [_hostViews addPointer:(__bridge void *)view];
  return view;
}

- (void)presentModalHostView:(RNTModalHostView *)modalHostView withViewController:(RNTModalHostViewController *)viewController animated:(BOOL)animated
{
  dispatch_block_t completionBlock = ^{
    if (modalHostView.onShow) {
      modalHostView.onShow(nil);
    }
  };
  if (_presentationBlock) {
    _presentationBlock([modalHostView reactViewController], viewController, animated, completionBlock);
  } else {
    UIViewController *topViewController = [modalHostView reactViewController];
    while (topViewController.presentedViewController != nil) {
      if ([topViewController.presentedViewController isKindOfClass:UIAlertController.class]) {
        // Don't present on top of UIAlertController, this will mess it up:
        // https://stackoverflow.com/questions/27028983/uialertcontroller-is-moved-to-buggy-position-at-top-of-screen-when-it-calls-pre
        [topViewController dismissViewControllerAnimated:animated completion:^{
          [topViewController presentViewController:viewController animated:animated completion:completionBlock];
        }];
        return;
      }
      topViewController = topViewController.presentedViewController;
    }
    [topViewController presentViewController:viewController animated:animated completion:completionBlock];
  }
}

- (void)dismissModalHostView:(RNTModalHostView *)modalHostView withViewController:(RNTModalHostViewController *)viewController animated:(BOOL)animated
{

  if (modalHostView.onDismiss) {
    modalHostView.onDismiss(nil);
  }

  if (_dismissalBlock) {
    _dismissalBlock([modalHostView reactViewController], viewController, animated, nil);
  } else {
    [viewController.presentingViewController dismissViewControllerAnimated:animated completion:nil];
  }
}


- (RCTShadowView *)shadowView
{
  return [RNTModalHostShadowView new];
}

- (void)invalidate
{
  for (RNTModalHostView *hostView in _hostViews) {
    [hostView invalidate];
  }
  _hostViews = nil;
}

RCT_EXPORT_VIEW_PROPERTY(animationType, NSString)
RCT_EXPORT_VIEW_PROPERTY(presentationStyle, UIModalPresentationStyle)
RCT_EXPORT_VIEW_PROPERTY(transparent, BOOL)
RCT_EXPORT_VIEW_PROPERTY(onShow, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onDismiss, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(identifier, NSNumber)
RCT_EXPORT_VIEW_PROPERTY(supportedOrientations, NSArray)
RCT_EXPORT_VIEW_PROPERTY(onOrientationChange, RCTDirectEventBlock)

#if TARGET_OS_TV
RCT_EXPORT_VIEW_PROPERTY(onRequestClose, RCTDirectEventBlock)
#endif

@end
