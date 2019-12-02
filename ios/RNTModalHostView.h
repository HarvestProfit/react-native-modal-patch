/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <UIKit/UIKit.h>

#import <React/RCTInvalidating.h>
#import "RNTModalHostViewManager.h"
#import "RNTModalHostViewController.h"
#import <React/RCTView.h>

@class RCTBridge;
@class RNTModalHostViewController;
@class RCTTVRemoteHandler;

@protocol RNTModalHostViewInteractor;

@interface RNTModalHostView : UIView <RCTInvalidating>

@property (nonatomic, copy) NSString *animationType;
@property (nonatomic, assign) UIModalPresentationStyle presentationStyle;
@property (nonatomic, assign, getter=isTransparent) BOOL transparent;

@property (nonatomic, copy) RCTDirectEventBlock onShow;
@property (nonatomic, copy) RCTDirectEventBlock onDismiss;

@property (nonatomic, copy) NSNumber *identifier;

@property (nonatomic, weak) id<RNTModalHostViewInteractor> delegate;

@property (nonatomic, copy) NSArray<NSString *> *supportedOrientations;
@property (nonatomic, copy) RCTDirectEventBlock onOrientationChange;
- (void)dismissModalViewController;

#if TARGET_OS_TV
@property (nonatomic, copy) RCTDirectEventBlock onRequestClose;
@property (nonatomic, strong) RCTTVRemoteHandler *tvRemoteHandler;
#endif

- (instancetype)initWithBridge:(RCTBridge *)bridge NS_DESIGNATED_INITIALIZER;

@end

@protocol RNTModalHostViewInteractor <NSObject>

- (void)presentModalHostView:(RNTModalHostView *)modalHostView withViewController:(RNTModalHostViewController *)viewController animated:(BOOL)animated;
- (void)dismissModalHostView:(RNTModalHostView *)modalHostView withViewController:(RNTModalHostViewController *)viewController animated:(BOOL)animated;

@end
