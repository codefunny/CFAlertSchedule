//
//  CFAlertScheduleManager.m
//  CFAlertSchedule
//
//  Created by Aaron on 2021/11/23.
//

#import "CFAlertScheduleManager.h"

@interface CFAlertScheduleManager()
{
    __weak id<ICFAlertHolder> _alertHolder;
}

@property (nonatomic, assign, readwrite) BOOL  isBusying;
@property (nonatomic, strong) NSMutableArray    *holderList;
@property (nonatomic, strong) NSMutableDictionary    *holderUUidMap;

@end

@implementation CFAlertScheduleManager

+ (instancetype)sharedObject
{
    static CFAlertScheduleManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(void){
        sharedInstance = [[CFAlertScheduleManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _holderUUidMap = [[NSMutableDictionary alloc] init];
        _holderList = [[NSMutableArray alloc] init];
        _isBusying = NO;
    }
    return self;
}

- (void)addAlertHolder:(id<ICFAlertHolder>)hook
{
    if (!self.isBusying) {
        hook.block(hook);
        return;
    }
    if (![self.holderList containsObject:hook.UUid]) {
        hook.waitTimes++;
        [self.holderList addObject:hook.UUid];
        [self.holderUUidMap setObject:hook forKey:hook.UUid];
    }
}

- (void)alertWillAppear:(id<ICFAlertHolder>)alertHook
{
    CFLog(@"{CFAlertSchedule},alertWillAppear:%@,%d",alertHook,_isBusying);
    if (_isBusying) {
        return;
    }
    _isBusying = YES;
    _alertHolder = alertHook;
    CFLog(@"{CFAlertSchedule} hold the alert,%@",_alertHolder);
}

- (void)alertWillDisappear:(id<ICFAlertHolder>)alertHook
{
    CFLog(@"{CFAlertSchedule},alertWillDisappear:%@,state:%d",alertHook,_isBusying);
    if (_alertHolder && _alertHolder != alertHook) {
        CFLog(@"{CFAlertSchedule} not the hold,%@(hold),%@", _alertHolder,alertHook);
        return;
    }
    if (_isBusying) {
        _isBusying = NO;
    }
    _alertHolder = nil;
    
    if (self.holderList.count > 0) {
        id<ICFAlertHolder> block = [self getNextAlertHolderExclude:alertHook.UUid];
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block.block(block);
            });
        }
    }
}

- (id<ICFAlertHolder>)getNextAlertHolderExclude:(NSString *)preAlertUUid
{
    __block NSString *alertUUid = nil;
    if (preAlertUUid.length > 0) {
        [self.holderList enumerateObjectsUsingBlock:^(NSString*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isEqualToString:preAlertUUid]) {
                alertUUid = obj;
                *stop = YES;
            }
        }];
    } else {
        alertUUid = [self.holderList firstObject];
    }
    if (alertUUid.length <= 0) {
        return nil;
    }
    
    NSString *preUUid = preAlertUUid ?: @"";
    __block id<ICFAlertHolder> alertHolder = [self.holderUUidMap objectForKey:alertUUid];
    [self.holderUUidMap enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, id<ICFAlertHolder>  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.priority > alertHolder.priority && ![key isEqualToString:preUUid]) {
            alertHolder = obj;
            alertUUid = key;
        }
    }];
    
    [self.holderList removeObject:alertUUid];
    [self.holderUUidMap removeObjectForKey:alertUUid];
    return alertHolder;
}

@end

