//
//  TransactionsDetailViewController.m
//  Codeconomy
//
//  Created by Gary on 03/05/17.
//  Copyright © 2017 Stanford. All rights reserved.
//

#import "TransactionsDetailViewController.h"
#import "ListingHeaderView.h"
#import "ListingDetailView.h"
#import "TransactionTimeView.h"
#import "TransactionCodeView.h"
#import "TransactionSubmitReviewView.h"
#import "TransactionReviewView.h"
#import "Util.h"
#import "Coupon.h"

@interface TransactionsDetailViewController () <TransactionSubmitReviewViewDelegate>
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Transaction *transactionData;
@property (nonatomic, strong) Coupon *couponData;
@property (nonatomic, strong) UILabel *creditsLabel;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ListingHeaderView *headerView;
@property (nonatomic, strong) ListingDetailView *detailView;
@property (nonatomic, strong) TransactionTimeView *timeView;
@property (nonatomic, strong) TransactionCodeView *codeView;
@property (nonatomic, strong) TransactionSubmitReviewView *submitReviewView;
@property (nonatomic, strong) TransactionReviewView *transactionReview;
@property BOOL userBought;
@end

@implementation TransactionsDetailViewController

- (instancetype)initWithTransaction:(Transaction *)transactionData user:(User *)user {
    self = [super init];
    if (self) {
        _user = user;
        
        _creditsLabel = [[UILabel alloc] init];
        _creditsLabel.text = [NSString stringWithFormat:@"%d🔑", self.user.credits];
        _transactionData = transactionData;
        _couponData = transactionData.coupon;
        _userBought = _transactionData.buyer.username == self.user.username;
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        
        _headerView = [[ListingHeaderView alloc] initWithStoreName:_couponData.storeName title:_couponData.couponDescription description:_couponData.additionalInfo];
        _detailView = [[ListingDetailView alloc] initWithPrice:_couponData.price expirationDate:_couponData.expirationDate category:_couponData.category];
        //        _createdView = [[ListingTimeCreatedView alloc] initWithCreatedDate:_couponData.createdAt seller:[NSString stringWithFormat:@"%d", _couponData.sellerId]];
        if (_userBought) {
            _timeView = [[TransactionTimeView alloc] initWithTransactionDate:transactionData.transactionDate otherUser:transactionData.seller userBought:_userBought];
        } else {
            _timeView = [[TransactionTimeView alloc] initWithTransactionDate:transactionData.transactionDate otherUser:transactionData.buyer userBought:_userBought];
        }
        if (_userBought) {
            _codeView = [[TransactionCodeView alloc] initWithCode:transactionData.coupon.code];
        }
        _submitReviewView = [[TransactionSubmitReviewView alloc] initWithTransaction:_transactionData];
        _submitReviewView.delegate = self;
        _transactionReview = [[TransactionReviewView alloc] initWithTransaction:_transactionData];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[Util sharedManager] colorWithHexString:[Util getLightGrayColorHex]];
    self.automaticallyAdjustsScrollViewInsets = NO;

    [_creditsLabel sizeToFit];
    [self.view addSubview:_scrollView];
    [self.scrollView addSubview:_headerView];
    [self.scrollView addSubview:_detailView];
    [self.scrollView addSubview:_timeView];
    if (_userBought) {
        [self.scrollView addSubview:_codeView];
        if (_transactionData.stars == 0) {
            [self.scrollView addSubview:_submitReviewView];
        } else {
            [self.scrollView addSubview:_transactionReview];
        }
    } else if (_transactionData.stars != 0) {
        [self.scrollView addSubview:_transactionReview];
    }
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.creditsLabel];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationItem.title = @"Transaction";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    self.scrollView.frame = CGRectMake(0.0, self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height + self.tabBarController.tabBar.frame.size.height));
    self.headerView.frame = CGRectMake(20.0, 15.0, self.view.frame.size.width - 40.0, 147.0);
    self.detailView.frame = CGRectMake(20.0, self.headerView.frame.origin.y + self.headerView.frame.size.height + 8.0, self.view.frame.size.width - 40.0, 127.0);
    self.timeView.frame = CGRectMake(20.0, self.detailView.frame.origin.y + self.detailView.frame.size.height + 8.0, self.view.frame.size.width - 40.0, 72.0);
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.timeView.frame.origin.y + self.timeView.frame.size.height + 12.0);
    if (self.userBought) {
        self.codeView.frame = CGRectMake(20.0, self.timeView.frame.origin.y + self.timeView.frame.size.height + 8.0, self.view.frame.size.width - 40.0, 50.0);
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.codeView.frame.origin.y + self.codeView.frame.size.height + 12.0);
        if (self.transactionData.stars == 0) {
            self.submitReviewView.hidden = NO;
            self.transactionReview.hidden = YES;
            self.submitReviewView.frame = CGRectMake(20.0, self.codeView.frame.origin.y + self.codeView.frame.size.height + 8.0, self.view.frame.size.width - 40.0, 269.0);
            self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.submitReviewView.frame.origin.y + self.submitReviewView.frame.size.height + 12.0);
        } else {
            self.submitReviewView.hidden = YES;
            self.transactionReview.hidden = NO;
            self.transactionReview.frame = CGRectMake(20.0, self.codeView.frame.origin.y + self.codeView.frame.size.height + 8.0, self.view.frame.size.width - 40.0, 140.0);
            self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.transactionReview.frame.origin.y + self.transactionReview.frame.size.height + 12.0);
        }
    } else if (self.transactionData.stars != 0) {
        self.transactionReview.frame = CGRectMake(20.0, self.timeView.frame.origin.y + self.timeView.frame.size.height + 8.0, self.view.frame.size.width - 40.0, 140.0);
        self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.transactionReview.frame.origin.y + self.transactionReview.frame.size.height + 12.0);
    }
}

#pragma mark - TransactionSubmitReviewView Delegate

- (void)updateTransaction {
    [self.transactionData fetch];
    self.transactionReview = [[TransactionReviewView alloc] initWithTransaction:_transactionData];
    [self.scrollView addSubview:self.transactionReview];
    [self.view setNeedsLayout];
}

#pragma mark - Keyboard
- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -keyboardSize.height;
        self.view.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f;
        self.view.frame = f;
    }];
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
