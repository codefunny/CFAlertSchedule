//
//  CFAlertScheduleManager.h
//  CFAlertSchedule
//
//  Created by Aaron on 2021/11/23.
//

#import <Foundation/Foundation.h>

#import "ICFAlertScheduleService.h"

NS_ASSUME_NONNULL_BEGIN

@interface CFAlertScheduleManager : NSObject <ICFAlertScheduleService>

@property (nonatomic, assign, readonly) BOOL  isBusying;

+ (instancetype)sharedObject;

- (void)addAlertHolder:(id<ICFAlertHolder>)hook;

- (void)alertWillAppear:(id<ICFAlertHolder>)alertHook;

- (void)alertWillDisappear:(id<ICFAlertHolder>)alertHook;

@end

NS_ASSUME_NONNULL_END

