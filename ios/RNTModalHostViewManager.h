/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <React/RCTInvalidating.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTConvert.h>

@interface RCTConvert (RNTModalHostView)

+ (UIModalPresentationStyle)UIModalPresentationStyle:(id)json;

@end

typedef void (^RNTModalViewInteractionBlock)(UIViewController *reactViewController, UIViewController *viewController, BOOL animated, dispatch_block_t completionBlock);

@interface RNTModalHostViewManager : NSObject <RCTBridgeModule>

/**
 * `presentationBlock` and `dismissalBlock` allow you to control how a Modal interacts with your case,
 * e.g. in case you have a native navigator that has its own way to display a modal.
 * If these are not specified, it falls back to the UIViewController standard way of presenting.
 */
@property (nonatomic, strong) RNTModalViewInteractionBlock presentationBlock;
@property (nonatomic, strong) RNTModalViewInteractionBlock dismissalBlock;

@end
