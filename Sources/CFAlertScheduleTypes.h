//
//  CFAlertScheduleTypes.h
//  CFAlertSchedule
//
//  Created by Aaron on 2021/11/26.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define CFLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define CFLog(...)
#endif

NS_ASSUME_NONNULL_BEGIN

@protocol ICFAlertHolder <NSObject>

@property (nonatomic, strong) NSString *UUid;
@property (nonatomic, strong,nullable) NSString *bindObjectClass;
@property (nonatomic, weak,nullable) NSObject *bindObject;
@property (nonatomic, copy) void(^block)(id<ICFAlertHolder> holder);
@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, assign) NSInteger waitTimes;
@property (nonatomic, strong) NSDate    *createTime;

- (BOOL)checkAlertBusying;
- (void)alertWillAppear;

- (void)showAlert;

@end

@interface CFAlertHolder : NSObject<ICFAlertHolder>

- (instancetype)initWithUUid:(NSString *)uuid;

@property (nonatomic, strong) NSString *UUid;
@property (nonatomic, strong,nullable) NSString *bindObjectClass;
@property (nonatomic, weak,nullable) NSObject *bindObject;
@property (nonatomic, copy) void(^block)(id<ICFAlertHolder> holder);

@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, assign) NSInteger waitTimes;
@property (nonatomic, strong) NSDate    *createTime;

- (void)showAlert;

@end

@interface NSObject (CFAlertHolder)

- (id<ICFAlertHolder>)alertHoler;

- (void)setAlertHolder:(id<ICFAlertHolder> _Nullable)alertHolder;

/**
  *  只有返回YES，才说明当前view成功绑定了弹窗，可以显示弹窗，否则不做处理
  *  eg:if ([self.genderSettingVC bindAlertHolder:holder]) {}
  *  如果self是一个临时窗口，在dismiss之后自动release则不用做处理，否则需要手动解绑，调用[xxx setAlertHolder:nil]
   *遵循的原则是谁申请谁释放，没有释放则后面的弹窗将不能显示弹窗。
 */
- (BOOL)bindAlertHolder:(id<ICFAlertHolder>)alertHolder;

/**
  * 解绑，谁申请谁释放，及时释放
 */
- (void)unbindAlertHolder;

@end

NS_ASSUME_NONNULL_END

