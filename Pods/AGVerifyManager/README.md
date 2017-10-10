# AGVerifyManager
### 思路描述
- 参考了 Masonry 的链式语法，使用起来非常优雅并且非常适合验证多个数据。
- 因为用户需要验证的数据是变化且各不相同的，所以把变化隔离开来，独立封装。
- 验证的时候需要集中处理，所以用代码块统一了起来。

### cocoapods 集成
```
platform :ios, '7.0'
target 'AGVerifyManagerDemo' do

pod 'AGVerifyManager'

end
```

### 使用说明
```objective-c
    /** 
      创建遵守<AGVerifyManagerVerifiable>协议的验证器类
      实现<AGVerifyManagerVerifiable>协议方法
      具体可参考 Demo
      下面是使用过程
      */

    // 判断用户输入
    ATTextLimitVerifier *username =
    [ATTextLimitVerifier verifier:self.nameTextField.text];
    username.minLimit = 2;
    username.maxLimit = 7;
    
    username.maxLimitMsg =
    [NSString stringWithFormat:@"用户名不能超过%@个字符！", @(username.maxLimit)];
    
    // 判断是否包含 emoji 😈
    ATEmojiVerifier *emoji =
    [ATEmojiVerifier verifier:self.nameTextField.text];
    emoji.errorMsg = @"请输入非表情字符！";
    
    // 开始验证
    [ag_verifyManager()
     .verify(emoji)
     .verify(username)
     verified:^(AGVerifyError *firstError, NSArray<AGVerifyError *> *errors) {
         
         if ( firstError ) {
             // 验证不通过
             self.resultLabel.text = firstError.msg;
             
         }
         else {
             // TODO
             self.resultLabel.text = @"验证通过！";
         }
     }];
```
