//
//  BilliardsViewController.m
//  DynamicAnimationExample
//
//  Created by Xin Hong on 15/8/29.
//  Copyright (c) 2015年 Xin Hong. All rights reserved.
//

#import "BilliardsViewController.h"
#import "BilliardsBall.h"
#import "BilliardsView.h"
#import "BilliardsBehavior.h"

static const CGFloat GOALPATH_OFFSET = 18.0;
static NSString *kLeftTopGoal = @"LeftTopGoal";
static NSString *kLeftBottomGoal = @"LeftBottomGoal";
static NSString *kTopGoal = @"TopGoal";
static NSString *kBottomGoal = @"BottomGoal";
static NSString *kRightTopGoal = @"RightTopGoal";
static NSString *kRightBottomGoal = @"RightBottomGoal";

@interface BilliardsViewController () <UICollisionBehaviorDelegate>

@property (weak, nonatomic) IBOutlet BilliardsView *billiardsView;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) BilliardsBehavior *billiardsBehavior;
@property (strong, nonatomic) UIView *ball;
@property (nonatomic) NSInteger score;

@end

@implementation BilliardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.billiardsView];
    self.score = 0;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleDone target:self action:@selector(clearBalls)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBilliardsView:)];
    [self.billiardsView addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(serveBall:)];
    [self.billiardsView addGestureRecognizer:pan];
}

- (void)tapBilliardsView:(UITapGestureRecognizer *)gesture {
    CGPoint tapPonit = [gesture locationInView:self.billiardsView];
    
    [self addBallWithTapPoint:tapPonit];
}

- (void)serveBall:(UIPanGestureRecognizer *)gesture {
    if (!self.ball) {
        return;
    }
    
    CGPoint ballCenter = self.ball.center;
    CGPoint point = [gesture locationInView:self.billiardsView];
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:ballCenter];
    [path addLineToPoint:point];
    self.billiardsView.path = path;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        self.billiardsView.path = nil;
        
        CGFloat length = sqrt(pow(point.x - ballCenter.x, 2) + pow(point.y - ballCenter.y, 2));
        CGFloat radian = atan((point.y - ballCenter.y) / (point.x - ballCenter.x));
        if (point.x >= ballCenter.x) {
            radian = radian + M_PI;
        }
        //CGFloat angle = radian * 180 / M_PI;
        
        UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.ball] mode:UIPushBehaviorModeInstantaneous];
        pushBehavior.angle = radian;
        pushBehavior.magnitude = 0.0025 * length;
        [self.animator addBehavior:pushBehavior];
        self.ball = nil;
    }
}

- (void)addBallWithTapPoint:(CGPoint)point {
    CGFloat ballMinDistance = 40 + BILLIARD_BORDER_WIDTH;
    
    if (point.x <= ballMinDistance || point.x >= self.billiardsView.bounds.size.width - ballMinDistance || point.y <= ballMinDistance || point.y >= self.billiardsView.bounds.size.height - ballMinDistance) {
        return;
    }
    
    UIView *ball = [BilliardsBall ball];
    CGRect ballFrame = ball.frame;
    ballFrame.origin.x = point.x - BALL_RADIUS / 2;
    ballFrame.origin.y = point.y - BALL_RADIUS / 2;
    ball.frame = ballFrame;
    ball.tag = billiardsBallTag;
    
    self.ball = ball;
    [self.billiardsView addSubview:ball];
    [self.billiardsBehavior addItem:ball];
}

- (BilliardsBehavior *)billiardsBehavior {
    if (!_billiardsBehavior) {
        _billiardsBehavior = [[BilliardsBehavior alloc] init];
        
        CGFloat distance = BILLIARD_BORDER_WIDTH + GOALHOLE_OFFSET + GOALHOLE_RADIUS;
        
        UIBezierPath *leftPath = [[UIBezierPath alloc] init];
        [leftPath moveToPoint:CGPointMake(BILLIARD_BORDER_WIDTH, distance)];
        [leftPath addLineToPoint:CGPointMake(BILLIARD_BORDER_WIDTH, self.billiardsView.bounds.size.height - distance)];
        [_billiardsBehavior.collider addBoundaryWithIdentifier:@"leftPath" fromPoint:CGPointMake(BILLIARD_BORDER_WIDTH, distance) toPoint:CGPointMake(BILLIARD_BORDER_WIDTH, self.billiardsView.bounds.size.height - distance)];
        
        
        UIBezierPath *rightPath = [[UIBezierPath alloc] init];
        [rightPath moveToPoint:CGPointMake(self.billiardsView.bounds.size.width - BILLIARD_BORDER_WIDTH, distance)];
        [rightPath addLineToPoint:CGPointMake(self.billiardsView.bounds.size.width - BILLIARD_BORDER_WIDTH, self.billiardsView.bounds.size.height - distance)];
        [_billiardsBehavior.collider addBoundaryWithIdentifier:@"rightPath" fromPoint:CGPointMake(self.billiardsView.bounds.size.width - BILLIARD_BORDER_WIDTH, distance) toPoint:CGPointMake(self.billiardsView.bounds.size.width - BILLIARD_BORDER_WIDTH, self.billiardsView.bounds.size.height - distance)];
        
        
        UIBezierPath *leftTopPath = [[UIBezierPath alloc] init];
        [leftTopPath moveToPoint:CGPointMake(distance, BILLIARD_BORDER_WIDTH)];
        [leftTopPath addLineToPoint:CGPointMake(self.billiardsView.bounds.size.width / 2 - GOALHOLE_RADIUS, BILLIARD_BORDER_WIDTH)];
        [_billiardsBehavior.collider addBoundaryWithIdentifier:@"leftTopPath" fromPoint:CGPointMake(distance, BILLIARD_BORDER_WIDTH) toPoint:CGPointMake(self.billiardsView.bounds.size.width / 2 - GOALHOLE_RADIUS, BILLIARD_BORDER_WIDTH)];
        
        
        UIBezierPath *rightTopPath = [[UIBezierPath alloc] init];
        [rightTopPath moveToPoint:CGPointMake(self.billiardsView.bounds.size.width / 2 + GOALHOLE_RADIUS, BILLIARD_BORDER_WIDTH)];
        [rightTopPath addLineToPoint:CGPointMake(self.billiardsView.bounds.size.width - distance, BILLIARD_BORDER_WIDTH)];
        [_billiardsBehavior.collider addBoundaryWithIdentifier:@"rightTopPath" fromPoint:CGPointMake(self.billiardsView.bounds.size.width / 2 + GOALHOLE_RADIUS, BILLIARD_BORDER_WIDTH) toPoint:CGPointMake(self.billiardsView.bounds.size.width - distance, BILLIARD_BORDER_WIDTH)];
        
        
        UIBezierPath *leftBottomPath = [[UIBezierPath alloc] init];
        [leftBottomPath moveToPoint:CGPointMake(distance, self.billiardsView.bounds.size.height - BILLIARD_BORDER_WIDTH)];
        [leftBottomPath addLineToPoint:CGPointMake(self.billiardsView.bounds.size.width / 2 - GOALHOLE_RADIUS, self.billiardsView.bounds.size.height - BILLIARD_BORDER_WIDTH)];
        [_billiardsBehavior.collider addBoundaryWithIdentifier:@"leftBottomPath" fromPoint:CGPointMake(distance, self.billiardsView.bounds.size.height - BILLIARD_BORDER_WIDTH) toPoint:CGPointMake(self.billiardsView.bounds.size.width / 2 - GOALHOLE_RADIUS, self.billiardsView.bounds.size.height - BILLIARD_BORDER_WIDTH)];
        
        
        UIBezierPath *rightBottomPath = [[UIBezierPath alloc] init];
        [rightBottomPath moveToPoint:CGPointMake(self.billiardsView.bounds.size.width / 2 + GOALHOLE_RADIUS, self.billiardsView.bounds.size.height - BILLIARD_BORDER_WIDTH)];
        [rightBottomPath addLineToPoint:CGPointMake(self.billiardsView.bounds.size.width - distance, self.billiardsView.bounds.size.height - BILLIARD_BORDER_WIDTH)];
        [_billiardsBehavior.collider addBoundaryWithIdentifier:@"rightBottomPath" fromPoint:CGPointMake(self.billiardsView.bounds.size.width / 2 + GOALHOLE_RADIUS, self.billiardsView.bounds.size.height - BILLIARD_BORDER_WIDTH) toPoint:CGPointMake(self.billiardsView.bounds.size.width - distance, self.billiardsView.bounds.size.height - BILLIARD_BORDER_WIDTH)];
        
        
        // Goal Path
        UIBezierPath *leftTopGoalPath = [[UIBezierPath alloc] init];
        [leftTopGoalPath moveToPoint:CGPointMake(BILLIARD_BORDER_WIDTH - GOALPATH_OFFSET, distance)];
        [leftTopGoalPath addLineToPoint:CGPointMake(distance, BILLIARD_BORDER_WIDTH - GOALPATH_OFFSET)];
        [_billiardsBehavior.collider addBoundaryWithIdentifier:kLeftTopGoal fromPoint:CGPointMake(BILLIARD_BORDER_WIDTH - GOALPATH_OFFSET, distance) toPoint:CGPointMake(distance, BILLIARD_BORDER_WIDTH - GOALPATH_OFFSET)];
        
        UIBezierPath *leftBottomGoalPath = [[UIBezierPath alloc] init];
        [leftBottomGoalPath moveToPoint:CGPointMake(BILLIARD_BORDER_WIDTH - GOALPATH_OFFSET, self.billiardsView.bounds.size.height - distance)];
        [leftBottomGoalPath addLineToPoint:CGPointMake(distance, self.billiardsView.bounds.size.height - BILLIARD_BORDER_WIDTH +GOALPATH_OFFSET)];
        [_billiardsBehavior.collider addBoundaryWithIdentifier:kLeftBottomGoal fromPoint:CGPointMake(BILLIARD_BORDER_WIDTH - GOALPATH_OFFSET, self.billiardsView.bounds.size.height - distance) toPoint:CGPointMake(distance, self.billiardsView.bounds.size.height - BILLIARD_BORDER_WIDTH +GOALPATH_OFFSET)];
        
        UIBezierPath *rightTopGoalPath = [[UIBezierPath alloc] init];
        [rightTopGoalPath moveToPoint:CGPointMake(self.billiardsView.bounds.size.width - distance, BILLIARD_BORDER_WIDTH - GOALPATH_OFFSET)];
        [rightTopGoalPath addLineToPoint:CGPointMake(self.billiardsView.bounds.size.width - BILLIARD_BORDER_WIDTH + GOALPATH_OFFSET, distance)];
        [_billiardsBehavior.collider addBoundaryWithIdentifier:kRightTopGoal fromPoint:CGPointMake(self.billiardsView.bounds.size.width - distance, BILLIARD_BORDER_WIDTH - GOALPATH_OFFSET) toPoint:CGPointMake(self.billiardsView.bounds.size.width - BILLIARD_BORDER_WIDTH + GOALPATH_OFFSET, distance)];
        
        UIBezierPath *rightBottomGoalPath = [[UIBezierPath alloc] init];
        [rightBottomGoalPath moveToPoint:CGPointMake(self.billiardsView.bounds.size.width - distance, self.billiardsView.bounds.size.height - BILLIARD_BORDER_WIDTH + GOALPATH_OFFSET)];
        [rightBottomGoalPath addLineToPoint:CGPointMake(self.billiardsView.bounds.size.width - BILLIARD_BORDER_WIDTH + GOALPATH_OFFSET, self.billiardsView.bounds.size.height - distance)];
        [_billiardsBehavior.collider addBoundaryWithIdentifier:kRightBottomGoal fromPoint:CGPointMake(self.billiardsView.bounds.size.width - distance, self.billiardsView.bounds.size.height - BILLIARD_BORDER_WIDTH + GOALPATH_OFFSET) toPoint:CGPointMake(self.billiardsView.bounds.size.width - BILLIARD_BORDER_WIDTH + GOALPATH_OFFSET, self.billiardsView.bounds.size.height - distance)];
        
        UIBezierPath *topGoalPath = [[UIBezierPath alloc] init];
        [topGoalPath moveToPoint:CGPointMake(self.billiardsView.bounds.size.width / 2 - GOALHOLE_RADIUS, BILLIARD_BORDER_WIDTH - GOALPATH_OFFSET)];
        [topGoalPath addLineToPoint:CGPointMake(self.billiardsView.bounds.size.width / 2 + GOALHOLE_RADIUS, BILLIARD_BORDER_WIDTH - GOALPATH_OFFSET)];
        [_billiardsBehavior.collider addBoundaryWithIdentifier:kTopGoal fromPoint:CGPointMake(self.billiardsView.bounds.size.width / 2 - GOALHOLE_RADIUS, BILLIARD_BORDER_WIDTH - GOALPATH_OFFSET) toPoint:CGPointMake(self.billiardsView.bounds.size.width / 2 + GOALHOLE_RADIUS, BILLIARD_BORDER_WIDTH - GOALPATH_OFFSET)];
        
        UIBezierPath *bottomGoalPath = [[UIBezierPath alloc] init];
        [bottomGoalPath moveToPoint:CGPointMake(self.billiardsView.bounds.size.width / 2 - GOALHOLE_RADIUS, self.billiardsView.bounds.size.height - BILLIARD_BORDER_WIDTH + GOALPATH_OFFSET)];
        [bottomGoalPath addLineToPoint:CGPointMake(self.billiardsView.bounds.size.width / 2 + GOALHOLE_RADIUS, self.billiardsView.bounds.size.height - BILLIARD_BORDER_WIDTH + GOALPATH_OFFSET)];
        [_billiardsBehavior.collider addBoundaryWithIdentifier:kBottomGoal fromPoint:CGPointMake(self.billiardsView.bounds.size.width / 2 - GOALHOLE_RADIUS, self.billiardsView.bounds.size.height - BILLIARD_BORDER_WIDTH + GOALPATH_OFFSET) toPoint:CGPointMake(self.billiardsView.bounds.size.width / 2 + GOALHOLE_RADIUS, self.billiardsView.bounds.size.height - BILLIARD_BORDER_WIDTH + GOALPATH_OFFSET)];
        
        _billiardsBehavior.collider.collisionDelegate = self;
        
        [self.animator addBehavior:_billiardsBehavior];
    }
    return _billiardsBehavior;
}

- (void)clearBalls {
    self.ball = nil;
    self.score = 0;
    for (UIView *ball in self.billiardsView.subviews) {
        if (ball.tag == billiardsBallTag) {
            [self.billiardsBehavior removeItem:ball];
            [ball removeFromSuperview];
        }
    }
}

- (void)setScore:(NSInteger)score {
    _score = score;
    self.navigationItem.title = [NSString stringWithFormat:@"Score: %ld", (long)score];
}

#pragma mark - UICollisionBehavior delegate
- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    // collision between ball and boundary
    BOOL goal = [(NSString *)identifier isEqualToString:kLeftTopGoal] ||
                [(NSString *)identifier isEqualToString:kLeftBottomGoal] ||
                [(NSString *)identifier isEqualToString:kRightTopGoal] ||
                [(NSString *)identifier isEqualToString:kRightBottomGoal] ||
                [(NSString *)identifier isEqualToString:kTopGoal] ||
                [(NSString *)identifier isEqualToString:kBottomGoal];
    if (goal) {
        [self.billiardsBehavior removeItem:item];
        [(UIView *)item removeFromSuperview];
        self.score++;
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p {
    // collision between two balls
}

@end
