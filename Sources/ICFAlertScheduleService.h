//
//  ICFAlertScheduleService.h.h
//  CFAlertSchedule
//
//

#import <Foundation/Foundation.h>

#import <CFAlertSchedule/CFAlertScheduleTypes.h>

@protocol ICFAlertScheduleService <IOAKService>

@property (nonatomic, assign, readonly) BOOL  isBusying;

+ (instancetype)sharedObject;

- (void)addAlertHolder:(id<ICFAlertHolder>)hook;

- (void)alertWillAppear:(id<ICFAlertHolder>)alertHook;

- (void)alertWillDisappear:(id<ICFAlertHolder>)alertHook;

@end

