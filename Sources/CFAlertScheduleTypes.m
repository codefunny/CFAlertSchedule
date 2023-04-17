//
//  CFAlertScheduleTypes.m
//  CFAlertSchedule
//
//  Created by Aaron on 2021/11/26.
//

#import "CFAlertScheduleTypes.h"

#import <objc/runtime.h>

#import "CFAlertScheduleManager.h"

@implementation CFAlertHolder

- (instancetype)initWithUUid:(NSString *)uuid
{
    self = [super init];
    if (self) {
        _UUid = uuid;
        _createTime = [NSDate date];
        _priority = 0;
        _waitTimes = 0;
    }
    return self;
}

- (void)alertWillAppear
{
    [CFAlertScheduleManager.sharedObject alertWillAppear:self];
}

- (void)dealloc
{
    CFLog(@"{CFAlertSchedule} dealloc: %@",self);
    self.bindObject = nil;
    [CFAlertScheduleManager.sharedObject alertWillDisappear:self];
}

- (BOOL)checkAlertBusying
{
    return [CFAlertScheduleManager.sharedObject isBusying];
}

- (void)showAlert
{
    [CFAlertScheduleManager.sharedObject addAlertHolder:self];
}

- (void)setBindObject:(NSObject *)bindObject
{
    _bindObject = bindObject;
    if (bindObject) {
        _bindObjectClass = NSStringFromClass(bindObject.class);
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<{CFAlertSchedule} time:%@, UUid:%@,waitTime:%ld,priority:%ld,bindObject:%@>",self.createTime,self.UUid,(long)self.waitTimes,(long)self.priority,_bindObjectClass];
}

@end

static char alertHolderKey;
@implementation NSObject (CFAlertHolder)

- (id<ICFAlertHolder>)alertHoler
{
    return objc_getAssociatedObject(self, &alertHolderKey);
}

- (void)setAlertHolder:(id<ICFAlertHolder>)alertHolder
{
    alertHolder.bindObject = self;
    objc_setAssociatedObject(self, &alertHolderKey, alertHolder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)bindAlertHolder:(id<ICFAlertHolder>)alertHolder
{
    if ([alertHolder checkAlertBusying] ){
        [CFAlertScheduleManager.sharedObject addAlertHolder:alertHolder];
        return NO;
    }
    
    self.alertHolder = alertHolder;
    [alertHolder alertWillAppear];
    return YES;
}

- (void)unbindAlertHolder
{
    if ([self alertHoler]) {
        [self setAlertHolder:nil];
    }
}

@end

