
#import "Headers.h"
#import <BUAdSDK/BUAdSDK.h>
//#import "PJLive-Swift.h"
#import "SVProgressHUD.h"

#define kWidth self.view.frame.size.width
#define kHeight self.view.frame.size.height
@interface IATViewController ()<IFlySpeechRecognizerDelegate,IFlyRecognizerViewDelegate,UIActionSheetDelegate, BUNativeExpressRewardedVideoAdDelegate>

@property (nonatomic, strong) NSString *pcmFilePath;//音频文件路径
@property (nonatomic,strong)IFlyRecognizerView *iflyRecognizerView;//带界面的识别对象
@property (nonatomic, strong) IFlyDataUploader *uploader;//数据上传对象

@property (nonatomic,strong)UITextView *textView;//显示文字


@property (nonatomic,strong)UIButton *startButton;//开始语音翻译
@property(nonatomic,strong)UIButton *toLanButton;//更改语言按钮
@property (nonatomic,strong)UIButton *startWordButton;//文字翻译按钮

@property (nonatomic,strong)UIButton *calButton;//语音计算器按钮
@property (nonatomic,strong)UIButton *delButton;//删除文字按钮
@property (nonatomic,strong)UIButton *rewardButton;//激励视频按钮
@property (nonatomic,strong)BUNativeExpressRewardedVideoAd *rewardedAd;
@property (nonatomic,strong)BUNativeAdRelatedView *normalAd;

@property(nonatomic,strong)UILabel *toLanguage;//
@property(nonatomic,strong)UILabel *Language;//

@property(nonatomic,strong)UILabel *titleLab;//标题

@property(nonatomic,assign)BOOL cal;//是否进行语音计算识别
@end

@implementation IATViewController
-(NSString*)pcmFilePath{
    if (_pcmFilePath==nil) {
        
        //demo录音文件保存路径
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachePath = [paths objectAtIndex:0];
        _pcmFilePath = [[NSString alloc] initWithFormat:@"%@",[cachePath stringByAppendingPathComponent:@"asr.pcm"]];
        
    }
    return _pcmFilePath;
}
-(IFlyDataUploader*)uploader{
    if (_uploader==nil) {
        _uploader=[[IFlyDataUploader alloc]init];
    }
    return _uploader;
}
#pragma mark viewWillAppear  viewDidLoad
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSInteger n=[MySingleData shareMyData].LanNumber;
    NSString *lan= [MySingleData shareMyData].lanArr[n];
    
    self.Language.text =lan;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAudio];
    [self p_setupViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeLan) name:@"Lan" object:nil];
}

- (void)initAudio {
    //设置sdk的工作路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    [IFlySetting setLogFilePath:cachePath];
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = @"appid=9097437c";
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}

- (void)didChangeLan {
    [self p_setupViews];
}

#pragma mark viewWillDisappear
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_iflyRecognizerView cancel]; //取消识别
    [_iflyRecognizerView setDelegate:nil];
    [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    
}

#pragma mark  小菊花
-(void)showProgress {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)hideProgress {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

#pragma mark  更改目标语言按钮
-(void)changelan:(UIButton*)sender{
    NSLog(@"更改目标语言");
    ChangeLanViewController *clVC =[[ChangeLanViewController alloc]init];
    [self presentViewController:clVC animated:YES completion:nil];
}

-(void)p_setupViews{
    
    for (UIView *sub in self.view.subviews) {
        [sub removeFromSuperview];
    }
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    self.titleLab = [[UILabel alloc]init];
    CGRect rect11 = CGRectMake(60, 40, kWidth-120, 30);
    self.titleLab . frame = rect11;
    self.titleLab.text = @"语音机器人小Q";
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLab];
    
    self.toLanguage = [[UILabel alloc]init];
    CGRect rect1 = CGRectMake(60, 70, 80, 30);
    self.toLanguage . frame = rect1;
    self.toLanguage.text = @"目标语言:";
    
    NSInteger n=[MySingleData shareMyData].LanNumber;
    NSString *lan= [MySingleData shareMyData].lanArr[n];
    
    self.Language = [[UILabel alloc]init];
    
    CGRect rect2 = CGRectMake(CGRectGetMaxX(rect1)+5, CGRectGetMinY(rect1), 80, 30);
    self.Language . frame = rect2;
    self.Language.text =lan;
   
    
    
    self.toLanButton = [UIButton buttonWithType:UIButtonTypeCustom];
     self.toLanButton.backgroundColor =[UIColor colorWithRed:0.2 green:0.5 blue:0.5 alpha:0.6];
    
    
    [self.toLanButton.layer setMasksToBounds:YES];
    [self.toLanButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [self.toLanButton.layer setBorderWidth:1.0]; //边框宽度
    
    CGRect rect3 = CGRectMake(CGRectGetMaxX(rect2)+5, CGRectGetMinY(rect1), 80, 30);
    self.toLanButton.frame =rect3;
    
   // self.toLanButton.titleLabel.text=lan;
   // self.toLanButton.titleLabel.tintColor=[UIColor greenColor];
    [self.toLanButton setTitle:@"更换语言" forState:UIControlStateNormal];
    [self.view addSubview:self.toLanguage];
    [self.view addSubview:self.toLanButton];
    [self.view addSubview:self.Language];
    [self.toLanButton addTarget:self action:@selector(changelan:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    CGRect rect4 = CGRectMake(30, CGRectGetMaxY(rect1)+10, kWidth-60, 0.4*kHeight);
    self.textView = [[UITextView alloc]initWithFrame:rect4];
 
    
     self.textView.backgroundColor =[UIColor colorWithRed:0.9 green:0.5 blue:0.1 alpha:0.6];
       self.textView.userInteractionEnabled = YES;    self.textView.editable = YES;
    self.textView.layer.cornerRadius =10.0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textView.font = [UIFont systemFontOfSize:21.0f];
    [self.view addSubview:self.textView];
    
    
    //开始翻译按钮
    
    CGRect rect5 = CGRectMake(60, CGRectGetMaxY(rect4)+20, kWidth-120, 30);
    
    self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.startButton.frame=rect5;
    
    self.startButton.backgroundColor =[UIColor colorWithRed:0.2 green:0.5 blue:0.5 alpha:0.6];
    
    [self.startButton.layer setMasksToBounds:YES];
    [self.startButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [self.startButton.layer setBorderWidth:1.0]; //边框宽度
    
    [self.startButton setTitle:@"语音翻译" forState:UIControlStateNormal];
    
    [self.startButton addTarget:self action:@selector(voiceAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.startButton];
    
    
    //开始文字翻译按钮
    
    CGRect rect6 = CGRectMake(60, CGRectGetMaxY(rect5)+10, kWidth-120, 30);
    self.startWordButton = [[UIButton alloc]initWithFrame:rect6];
    
    self.startWordButton.backgroundColor =[UIColor colorWithRed:0.2 green:0.5 blue:0.5 alpha:0.6];
    
    [self.startWordButton.layer setMasksToBounds:YES];
    [self.startWordButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [self.startWordButton.layer setBorderWidth:1.0]; //边框宽度
    
    [self.startWordButton setTitle:@"文字翻译" forState:UIControlStateNormal];
    
    [self.startWordButton addTarget:self action:@selector(wordAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.startWordButton];
    
    //语音计算器按钮
    CGRect rect7 = CGRectMake(60, CGRectGetMaxY(rect6)+10, kWidth-120, 30);
    
    self.calButton =[UIButton buttonWithType:UIButtonTypeCustom];
    
    self.calButton.backgroundColor =[UIColor colorWithRed:0.2 green:0.5 blue:0.5 alpha:0.6];
    
    self.calButton.frame=rect7;
    [self.calButton setTitle:@"语音计算器" forState:UIControlStateNormal];
    
    [self.calButton addTarget:self action:@selector(startcal) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    [self.calButton.layer setMasksToBounds:YES];
    [self.calButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [self.calButton.layer setBorderWidth:1.0]; //边框宽度
    
    
    [self.view addSubview:self.calButton];
    
    
    //清除文字按钮
    
    CGRect rect8 = CGRectMake(60, CGRectGetMaxY(rect7)+10, kWidth-120, 30);
    self.delButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.delButton.frame=rect8;
    self.delButton.backgroundColor =[UIColor colorWithRed:0.2 green:0.5 blue:0.5 alpha:0.6];
    [self.delButton.layer setMasksToBounds:YES];
    [self.delButton.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [self.delButton.layer setBorderWidth:1.0]; //边框宽度
    
    //self.startButton.titleLabel.text = @"点击";
    [self.delButton setTitle:@"清空文字" forState:UIControlStateNormal];
//    self.delButton.backgroundColor = [UIColor blueColor];
    [self.delButton addTarget:self action:@selector(delAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.delButton];
    
    
    //激励视频按钮
    CGRect rect9 = CGRectMake(60, CGRectGetMaxY(rect8)+20, kWidth-120, 44);
    self.rewardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rewardButton.frame=rect9;
    self.rewardButton.backgroundColor =[UIColor colorWithRed:0.2 green:0.5 blue:0.5 alpha:0.6];
    [self.rewardButton.layer setMasksToBounds:YES];
    [self.rewardButton.layer setCornerRadius:22]; //设置矩形四个圆角半径
    [self.rewardButton.layer setBorderWidth:1.0]; //边框宽度
    
    [self.rewardButton setTitle:@"激励视频" forState:UIControlStateNormal];
    [self.rewardButton addTarget:self action:@selector(rewardAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rewardButton];
}

- (void)rewardAction {
    /// 读取钥匙串中的userId
    BURewardedVideoModel *model = [[BURewardedVideoModel alloc] init];
    model.userId = self.userId;
    model.rewardName = @"4小时免广告";
    model.rewardAmount = 2 * 60 * 60;
    
    self.rewardedAd = [[BUNativeExpressRewardedVideoAd alloc] initWithSlotID:@"946575694" rewardedVideoModel:model];
    self.rewardedAd.delegate = self;
    // optional
//    self.rewardedAd.rewardPlayAgainInteractionDelegate = self.expressRewardedVideoAgainDelegateObj;
    [self.rewardedAd loadAdData];
}

#pragma mark - BUNativeExpressRewardedVideoAdDelegate
- (void)nativeExpressRewardedVideoAdDidLoad:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    [self showRewardVideoAd];
}

- (void)nativeExpressRewardedVideoAd:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd didFailWithError:(NSError *)error {
    self.rewardedAd = nil;
}

- (void)nativeExpressRewardedVideoAdViewRenderFail:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd error:(NSError *)error {
    self.rewardedAd = nil;
}

- (void)nativeExpressRewardedVideoAdDidClickSkip:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    self.rewardedAd = nil;
}

- (void)nativeExpressRewardedVideoAdDidDownLoadVideo:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    /// 建议在此回调方法中进行广告的展示操作，可保证播放流畅和展示流畅，用户体验更好。
//    [self showRewardVideoAd];
}

/// 同一次请求的广告最多只能计一次展示，重复的展示会被系统过滤。
/// 因此建议开发者在用户观看完广告后在nativeExpressRewardedVideoAdDidClose回调里将原来的广告对象置为nil 保证广告对象为新的请求对象
- (void)nativeExpressRewardedVideoAdDidClose:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd {
    //在此回调方法中可进行广告的置空操作
    self.rewardedAd = nil;
}

//依据返回的verify（YES/NO）为依据进行激励视频的发放处理
- (void)nativeExpressRewardedVideoAdServerRewardDidSucceed:(BUNativeExpressRewardedVideoAd *)rewardedVideoAd verify:(BOOL)verify {
    NSString *result = [NSString stringWithFormat:@"广告激励结果: verify:%@ rewardName:%@ rewardMount:%ld userId:%@",verify?@"true":@"false",rewardedVideoAd.rewardedVideoModel.rewardName,(long)rewardedVideoAd.rewardedVideoModel.rewardAmount, rewardedVideoAd.rewardedVideoModel.userId];
    NSLog(@"%@", result);
    
    if (verify) {
        [SVProgressHUD showSuccessWithStatus:@"感谢您的支持😄"];
//        [SVProgressHUD showSuccessWithStatus:@"获得激励时长: 20分钟"];
    }
}

//show的时候会进行WKWebview的渲染，建议一次最多展示三个广告，如果超过3个会很大概率导致WKWebview渲染失败。当然一般情况下激励视频一次只会show一个
- (void)showRewardVideoAd {
    if (self.rewardedAd) {
        [self.rewardedAd showAdFromRootViewController:self];
    }
}

#pragma mark  清除文字按钮
-(void)delAction:(UIButton*)sender{
    NSLog(@"清空文字");
    self.textView.text=@"";
}
#pragma mark  百度翻译
-(void)baiduTranslate:(NSString *)str{
    
   // [self showProgress];
     //appid
     NSString *appid=@"20151216000007858";
     //秘钥
     NSString *key=@"zot9SXuJmO7Kh5GL4f0y";
    
    
     //要翻译的字符串
     NSString *q=self.textView.text;
    
    if (q.length == 0) {
        return;
    }
    
    //UTF-8编码
     NSString *dataUTF8 = [q stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
     //随机数
     NSString *salt=@"1435660208";
     //拼接字符串 appid 要翻译的文字 随机数 key
     NSString *str1 = [NSString stringWithFormat:@"%@%@%@%@",appid,q,salt,key];
    //获取签名
     NSString *sign=[self createMD5:str1];
    //设置要翻译的语言
     NSInteger m=[MySingleData shareMyData].LanNumber;
     NSString *language=[MySingleData shareMyData].lanCodeArr[m];
     
      NSString *string1=[NSString stringWithFormat:@"http://api.fanyi.baidu.com/api/trans/vip/translate?q=%@&from=auto&to=%@&appid=20151216000007858&salt=1435660208&sign=%@",q,language,sign];
    
    //UTF-8编码
     NSString* string2 = [string1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
     NSURL *url=[NSURL URLWithString:string2];
     
     NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
     
     NSURLSession * session=[NSURLSession sharedSession];
     
    NSURLSessionDataTask *task= [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
        NSLog(@"翻译返回");
        
        if (data) {
            
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"数据%@",dic);
            NSString *sss=[dic[@"trans_result"][0] valueForKey:@"dst"];
            NSLog(@"ss=%@",sss);
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *sss1=self->_textView.text;
                NSString *sss2=[NSString stringWithFormat:@"%@\n翻译后：%@",sss1,sss];
                self->_textView.text =sss2;
            });
            
            
        }else
        {
            NSLog(@"error=%@",error);
        }
        
        // [self hideProgress];
    }];
     
     [task resume];//恢复
}
#pragma mark 文字翻译
-(void)wordAction:(UIButton*)sender{
    NSLog(@"开始文字翻译");
    [self.view endEditing:TRUE];
    
    [self changeCheckStatus];
    self.cal=NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self baiduTranslate:nil];
    });
}
#pragma mark 解析加减乘除运算符号
-(NSInteger)getplus:(NSString*)str{
//
    //1+1-2×19÷4
    NSString *patter =@"\\+|\\-|\\×|\\÷";
    //加号@"\\+"
    //减号@"\\-"
    //乘号@"\\×"
    //除号@"\\÷"
    NSRegularExpression *reg = [[NSRegularExpression alloc]initWithPattern:patter options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *arr2 =[reg matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    // NSLog(@"arr2=%@",arr2);
    
    NSLog(@"arr2.count=%ld",arr2.count);
    
   
    if (arr2.count>0) {
        
        
        NSMutableArray *arrnew =[NSMutableArray arrayWithCapacity:4];
        for (NSTextCheckingResult *result in arr2) {
            NSString *stt =[str substringWithRange:result.range];
            NSLog(@"符号=%@",stt);
            [arrnew addObject:stt];
        }
        
        if ([arrnew[0] isEqualToString:@"+"]) {
            return 1;
        }
        if ([arrnew[0] isEqualToString:@"-"]) {
            return 2;
        }
        if ([arrnew[0] isEqualToString:@"×"]) {
            return 3;
        }
        if ([arrnew[0] isEqualToString:@"÷"]) {
            return 4;
        }
        
        
        return 0;
    }
    else return 0;
}

- (void)changeCheckStatus {
    if ([_textView.text containsString:@"超影"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasBeenChecked"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark 解析数字
-(NSMutableArray*)getNumbers:(NSString*)str{
    
    
    NSLog(@"str=%@",str);
    
    NSString *patter =@"\\d*\\d";
    
    //^-[1-9]\d*|0$　　 //匹配非正整数（负整数 + 0）
   //^\\d*\\d$　 　 //匹配正整数
    //^[1-9]\d*|0$  //匹配非负整数（正整数 + 0）
   // ^[1-9][0-9]*$
    
    NSRegularExpression *reg = [[NSRegularExpression alloc]initWithPattern:patter options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *arr2 =[reg matchesInString:str options:0 range:NSMakeRange(0, str.length)];
   // NSLog(@"arr2=%@",arr2);

    NSLog(@"arr2.count=%ld",arr2.count);
    NSMutableArray *arrnew =[NSMutableArray arrayWithCapacity:4];
    for (NSTextCheckingResult *result in arr2) {
        NSString *stt =[str substringWithRange:result.range];
        NSLog(@"数字=%@",stt);
        [arrnew addObject:stt];
    }
    return arrnew;
}

#pragma mark  点击开始语音计算器
-(void)startcal{
    self.cal=YES;
    
    NSLog(@"开始语义识别");
    
    if(_iflyRecognizerView == nil)
    {
        [self initRecognizer ];
    }
    
    if(_iflyRecognizerView.delegate==nil) _iflyRecognizerView.delegate=self;
    
    NSLog(@"_iflyRecognizerView=%@",_iflyRecognizerView);
    
    [_textView setText:@""];
    [_textView resignFirstResponder];
    
    //设置音频来源为麦克风
    [_iflyRecognizerView setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iflyRecognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    BOOL start = [_iflyRecognizerView start];
    NSLog(@"开始：%d",start);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:TRUE];
}
#pragma mark  点击开始语音识别
- (void)voiceAction:(UIButton *)sender
{
    [self.view endEditing:TRUE];
    [self changeCheckStatus];
    self.cal=NO;
    NSLog(@"开始语义识别");
    
    if(_iflyRecognizerView == nil)
    {
        [self initRecognizer ];
    }
    
    if(_iflyRecognizerView.delegate==nil) _iflyRecognizerView.delegate=self;
    
    NSLog(@"_iflyRecognizerView=%@",_iflyRecognizerView);
    
    [_textView setText:@""];
    [_textView resignFirstResponder];
    
    //设置音频来源为麦克风
    [_iflyRecognizerView setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iflyRecognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
   BOOL start = [_iflyRecognizerView start];
    NSLog(@"开始：%d",start);
    
}

#pragma mark initRecognizer
- (void)initRecognizer
{
    //单例模式，UI的实例
    if (_iflyRecognizerView == nil) {
        //UI显示剧中
        _iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
        
        [_iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [_iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        
    }
    _iflyRecognizerView.delegate = self;
    
    if (_iflyRecognizerView != nil) {
        IATConfig *instance = [IATConfig sharedInstance];
        //设置最长录音时间
        [_iflyRecognizerView setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iflyRecognizerView setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iflyRecognizerView setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iflyRecognizerView setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_iflyRecognizerView setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
        if ([instance.language isEqualToString:[IATConfig chinese]]) {
            //设置语言
            [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            //设置方言
            [_iflyRecognizerView setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
        }else if ([instance.language isEqualToString:[IATConfig english]]) {
            //设置语言
            [_iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
        }
        //设置是否返回标点符号
        [_iflyRecognizerView setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
        
    }
}


#pragma mark 有界面，听写结果回调resultArray：听写结果 isLast：表示最后一次
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }

    
   //NSLog(@"resultArray=%@,result=%@",resultArray,result);
    _textView.text = [NSString stringWithFormat:@"%@%@",_textView.text,result];

    _textView.text = [NSString stringWithFormat:@"%@",result];
    
    NSLog(@"result=%@",result);
  //  NSLog(@"dic=%@",dic);
    if(self.cal)
    {
    
    NSMutableArray *arr =[self getNumbers:result];
    NSString *nee =@"";
    
        if (arr.count>1) {
            NSInteger n1=[arr[0] intValue];
            
            NSInteger n2=[arr[1] intValue];
            
            
            switch ([self getplus:result]) {
                case 1:
                    //加法
                    nee = [NSString stringWithFormat:@"%ld+%ld=%ld",(long)n1,(long)n2,n1+n2];
                    break;
                case 2:
                    //减法
                    
                    nee = [NSString stringWithFormat:@"%ld-%ld=%ld",(long)n1,(long)n2,n1-n2];
                    break;
                    
                case 3:
                    //乘法
                    
                    nee = [NSString stringWithFormat:@"%ld×%ld=%ld",(long)n1,(long)n2,n1*n2];
                    break;
                case 4:
                    //除法
                    
                    nee = [NSString stringWithFormat:@"%ld÷%ld=%lf",(long)n1,(long)n2,(float)n1/n2];
                    break;
                    
                    
                default:
                    break;
            }
            
            NSLog(@"%@",nee);
            //NSLog(@"%ld+%ld=%ld",(long)n1,(long)n2,n1+n2);
                       
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *sss1=_textView.text;
                NSString *sss2=[NSString stringWithFormat:@"%@\n计算后：%@",sss1,nee];
                _textView.text =sss2;
            });
            
        
    }//      if (arr.count>1)
    
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self baiduTranslate:nil];
        });
    }
    
   // [self getNumbers:nil];
    //[self showProgress];//开始将字符串发送到百度
   
}





- (void) onError:(IFlySpeechError *) errorCode{
    NSLog(@"errorCode=%@",errorCode);
}

- (void) onResults:(NSArray *) results isLast:(BOOL)isLast{
    NSLog(@"isLast=%d",isLast);
    NSLog(@"results=%@",results);
}
//加密成md5
-(NSString *)createMD5:(NSString *)signString
{
    NSLog(@"md5加密");
    const char*cStr =[signString UTF8String];
    unsigned char result[16];
    unsigned int n=strlen(cStr);
    CC_MD5(cStr, n, result);
    
    NSString *s=[NSString stringWithFormat:
                     @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                 result[0], result[1], result[2], result[3],
                 result[4], result[5], result[6], result[7],
                 result[8], result[9], result[10], result[11],
                 result[12], result[13], result[14], result[15]
    ];
    NSLog(@"加密后s=%@",s);
    
    //大写%02X，小写%02x
    return s;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
