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
