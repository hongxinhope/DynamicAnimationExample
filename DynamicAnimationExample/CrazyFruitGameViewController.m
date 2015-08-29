//
//  CrazyFruitGameViewController.m
//  DynamicAnimationExample
//
//  Created by Xin Hong on 15/8/30.
//  Copyright (c) 2015年 Xin Hong. All rights reserved.
//

#import "CrazyFruitGameViewController.h"
#import "BezierPathView.h"
#import "CrazyFruitGameBehavior.h"
#import "Fruit.h"

#define birdTag 600

static NSString *kFruitLeftPath = @"FruitLeftPath";

@interface CrazyFruitGameViewController () <UICollisionBehaviorDelegate>

@property (weak, nonatomic) IBOutlet BezierPathView *gameView;
@property (weak, nonatomic) IBOutlet UIView *birdView;
@property (weak, nonatomic) IBOutlet UIView *birdAttach;
@property (weak, nonatomic) IBOutlet UIView *attach;

@property (nonatomic) BOOL isGaming;
@property (nonatomic) NSInteger score;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) NSTimer *fruitTimer;
@property (strong, nonatomic) CrazyFruitGameBehavior *birdFruitBehavior;
@property (strong, nonatomic) UIAttachmentBehavior *attachmentBehavior;

@end

@implementation CrazyFruitGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(game:)];
    self.isGaming = NO;
    self.score = 0;
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.gameView];
    
    self.attach.layer.masksToBounds = YES;
    self.attach.layer.cornerRadius = self.attach.bounds.size.width / 2;
    self.birdAttach.layer.masksToBounds = YES;
    self.birdAttach.layer.cornerRadius = self.birdAttach.bounds.size.width / 2;
    self.birdView.tag = birdTag;
    
    [self.birdFruitBehavior addItem:self.birdView];
    CGPoint anchorPoint = CGPointMake(self.birdView.center.x, self.birdView.center.y - 35);
    self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.birdView attachedToAnchor:anchorPoint];
    self.attachmentBehavior.length = 120.0;
    [self.attachmentBehavior setFrequency:1.0];
    [self.attachmentBehavior setDamping:0.1];
    self.attach.center = self.attachmentBehavior.anchorPoint;
    
    __weak typeof(self) weakSelf = self;
    self.attachmentBehavior.action = ^{
        weakSelf.attach.center = weakSelf.attachmentBehavior.anchorPoint;
        
        UIBezierPath *path = [[UIBezierPath alloc] init];
        [path moveToPoint:weakSelf.attachmentBehavior.anchorPoint];
        CGPoint birdAnchorPoint = CGPointMake(weakSelf.birdView.center.x, weakSelf.birdView.center.y - 35);
        [path addLineToPoint:birdAnchorPoint];
        weakSelf.gameView.path = path;
    };
    
    [self.animator addBehavior:self.attachmentBehavior];
    [self.animator addBehavior:self.birdFruitBehavior];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moveBird:)];
    [self.gameView addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveBird:)];
    [self.gameView addGestureRecognizer:pan];
}

- (void)moveBird:(UIGestureRecognizer*)gesture {
    [self.attachmentBehavior setAnchorPoint:[gesture locationInView:self.gameView]];
    self.attach.center = self.attachmentBehavior.anchorPoint;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
//        UIBezierPath *path = [[UIBezierPath alloc] init];
//        [path moveToPoint:self.attachmentBehavior.anchorPoint];
//        CGPoint birdAnchorPoint = CGPointMake(self.birdView.center.x, self.birdView.center.y - 35);
//        [path addLineToPoint:birdAnchorPoint];
//        self.gameView.path = path;
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        //self.gameView.path = nil;
    }
}

- (void)game:(id)sender {
    if (self.isGaming) {
        [self stopGame];
    } else {
        [self startGame];
    }
}

- (void)startGame {
    self.isGaming = YES;
    [self.animator addBehavior:self.birdFruitBehavior];
    self.fruitTimer = [NSTimer scheduledTimerWithTimeInterval:0.4 target:self selector:@selector(addFruit) userInfo:nil repeats:YES];
}

- (void)addFruit {
    UILabel *fruitLabel = [Fruit fruit];
    fruitLabel.tag = fruitTag;
    
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[fruitLabel]];
    gravity.gravityDirection = CGVectorMake(-1.0, 0);
    gravity.magnitude = 1.0;
    
    [self.gameView addSubview:fruitLabel];
    [self.birdFruitBehavior addItem:fruitLabel];
    [self.animator addBehavior:gravity];
}

- (void)stopGame {
    [self.fruitTimer invalidate];
    self.fruitTimer = nil;
    self.score = 0;
    [self.animator removeBehavior:self.birdFruitBehavior];
    for (UIView *subview in self.gameView.subviews) {
        if ([subview isKindOfClass:[UILabel class]] && subview.tag == fruitTag) {
            [subview removeFromSuperview];
        }
    }
    
    self.isGaming = NO;
}

- (CrazyFruitGameBehavior *)birdFruitBehavior {
    if (!_birdFruitBehavior) {
        _birdFruitBehavior = [[CrazyFruitGameBehavior alloc] init];
        [_birdFruitBehavior.collider addBoundaryWithIdentifier:kFruitLeftPath fromPoint:CGPointMake(0, 0) toPoint:CGPointMake(0, kScreenHeight)];
        _birdFruitBehavior.collider.collisionDelegate = self;
    }
    return _birdFruitBehavior;
}

- (void)setIsGaming:(BOOL)isGaming {
    _isGaming = isGaming;
    if (isGaming) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(game:)];
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(game:)];
    }
}

- (void)setScore:(NSInteger)score {
    _score = score;
    self.navigationItem.title = [NSString stringWithFormat:@"Score: %ld", (long)score];
}

- (void)dealloc {
    if (self.fruitTimer) {
        [self.fruitTimer invalidate];
        self.fruitTimer = nil;
    }
}

#pragma mark - UICollisionBehavior delegate
- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    if ([(NSString*)identifier isEqualToString:kFruitLeftPath]) {
        UIView *view = (UIView *)item;
        if (view.tag == birdTag) {
            return;
        }
        
        [self.birdFruitBehavior removeItem:item];
        [view removeFromSuperview];
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p {
    UIView *view1 = (UIView *)item1;
    UIView *view2 = (UIView *)item2;
    
    if ((view1.tag == fruitTag && view2.tag == birdTag) || (view1.tag == birdTag && view2.tag == fruitTag)) {
        UIView *fruitView;
        if (view1.tag == fruitTag) {
            fruitView = view1;
        } else if (view2.tag == fruitTag) {
            fruitView = view2;
        }
        
        [self.birdFruitBehavior removeItem:fruitView];
        [fruitView removeFromSuperview];
        self.score++;
    }
}

@end
