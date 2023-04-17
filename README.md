# CFAlertSchedule
CFAlertSchedule

### demo

```
CFAlertHolder *testflight = [[CFAlertHolder alloc] initWithUUid:@"testflight"];
testflight.block = ^(id<ICFAlertHolder> holder) {
    [weakSelf showTestFlightUpdateIfNeed:holder];
};
[testflight showAlert];
  
  
- (void)showTestFlightUpdateIfNeed:(id<IPTYAlertHolder>)holder
{
  xxxView *alertView = [xxxView new];
  if ([alertView bindAlertHolder:holder]) {
      [alertView show];
  }
}
```

Installation
==============

### CocoaPods

1. Update cocoapods to the latest version.
2. Add `pod 'CFAlertSchedule'` to your Podfile.
3. Run `pod install` or `pod update`.
4. Import \<CFAlertSchedule/CFAlertSchedule.h\>.
