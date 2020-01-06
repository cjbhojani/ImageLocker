//
//  UIPopoverController+BlocksKit.m
//  BlocksKit
//

#import "UIPopoverController+BlocksKit.h"
#import "A2DynamicDelegate.h"
#import "NSObject+A2DynamicDelegate.h"
#import "NSObject+A2BlockDelegate.h"

#pragma mark - Delegate

@interface A2DynamicUIPopoverControllerDelegate : A2DynamicDelegate <UIPopoverControllerDelegate>

@end

@implementation A2DynamicUIPopoverControllerDelegate

@end

#pragma mark - Category



//@dynamic bk_didDismissBlock, bk_shouldDismissBlock;
//
//+ (void)load
//{
//    @autoreleasepool {
//        [self bk_registerDynamicDelegate];
//        [self bk_linkDelegateMethods:@{ @"bk_didDismissBlock": @"popoverControllerDidDismissPopover:", @"bk_shouldDismissBlock": @"popoverControllerShouldDismissPopover:" }];
//    }
//}
