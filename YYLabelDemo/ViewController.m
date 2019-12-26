//
//  ViewController.m
//  YYLabelDemo
//
//  Created by wdgeeker on 2019/12/26.
//  Copyright © 2019 100uu. All rights reserved.
//

#import "ViewController.h"
#import <YYKit.h>
#import <Masonry.h>

@interface ViewController ()
@property (nonatomic, strong) YYLabel *contentLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.contentLabel];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-40);
        make.top.mas_equalTo(200);
    }];
    
}

- (YYLabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [YYLabel new];
        _contentLabel.numberOfLines = 2;
        _contentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 80;
        _contentLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.75];
        [self addSeeMoreButtonInLabel:_contentLabel];
        
    }
    
    return _contentLabel;
}

- (void)addSeeMoreButtonInLabel:(YYLabel *)label {
    UIFont *font16 = [UIFont systemFontOfSize:16];
    label.attributedText = [[NSAttributedString alloc] initWithString:@"日食，又叫做日蚀。当月球运动到太阳和地球中间如果三者正好处在一条直线，月球就会挡住太阳射向地球的光，月球身后的黑影正好落到地球上，这时发生日食现象。而日环食发生时，太阳的中心部分黑暗，边缘仍然明亮，形成光环。这是因为月球在太阳和地球之间，但是距离地球较远，不能完全遮住太阳而形成的。" attributes:@{NSFontAttributeName : font16}];

    NSString *moreString = @"展开";
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"... %@", moreString]];
    NSRange expandRange = [text.string rangeOfString:moreString];
    
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:expandRange];
    [text addAttribute:NSForegroundColorAttributeName value:[UIColor darkTextColor] range:NSMakeRange(0, expandRange.location)];
    
    //添加点击事件
    YYTextHighlight *hi = [YYTextHighlight new];
    [text setTextHighlight:hi range:[text.string rangeOfString:moreString]];
    
    __weak typeof(self) weakSelf = self;
    hi.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        //点击展开
        [weakSelf setFrame:YES];
    };
    
    text.font = font16;
    
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    [seeMore sizeToFit];
    
    NSAttributedString *truncationToken = [NSAttributedString attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.frame.size alignToFont:text.font alignment:YYTextVerticalAlignmentTop];
    
    label.truncationToken = truncationToken;
}

- (NSAttributedString *)appendAttriStringWithFont:(UIFont *)font {
    if (!font) {
        font = [UIFont systemFontOfSize:16];
    }
    
    NSString *appendText = @" 收起 ";
    NSMutableAttributedString *append = [[NSMutableAttributedString alloc] initWithString:appendText attributes:@{NSFontAttributeName : font, NSForegroundColorAttributeName : [UIColor blueColor]}];
    
    YYTextHighlight *hi = [YYTextHighlight new];
    [append setTextHighlight:hi range:[append.string rangeOfString:appendText]];
    
    __weak typeof(self) weakSelf = self;
    hi.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        //点击收起
        [weakSelf setFrame:NO];
    };
    
    return append;
}

- (void)expandString {
    NSMutableAttributedString *attri = [_contentLabel.attributedText mutableCopy];
    [attri appendAttributedString:[self appendAttriStringWithFont:attri.font]];
    _contentLabel.attributedText = attri;
}

- (void)packUpString {
    NSString *appendText = @" 收起 ";
    NSMutableAttributedString *attri = [_contentLabel.attributedText mutableCopy];
    NSRange range = [attri.string rangeOfString:appendText options:NSBackwardsSearch];

    if (range.location != NSNotFound) {
        [attri deleteCharactersInRange:range];
    }

    _contentLabel.attributedText = attri;
}


- (void)setFrame:(BOOL)isExpand {
    if (isExpand) {
        [self expandString];
        self.contentLabel.numberOfLines = 0;
    } else {
        [self packUpString];
        self.contentLabel.numberOfLines = 2;
    }
}


@end
