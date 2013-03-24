//
//  GameResultViewController.m
//  Matchismo
//
//  Created by Viktor Fonic on 06.02.2013..
//  Copyright (c) 2013 Viktor Fonic. All rights reserved.
//

#import "GameResultViewController.h"
#import "GameResult.h"

@interface GameResultViewController ()
@property (weak, nonatomic) IBOutlet UITextView *display;
@property (nonatomic) int sortMode;
@end

#define SORT_BY_DATE 1
#define SORT_BY_SCORE 5
#define SORT_BY_DURATION 2
#define SORT_BY_DATE_DESC 4
#define SORT_BY_SCORE_DESC 0 // sort by score by default
#define SORT_BY_DURATION_DESC 6

@implementation GameResultViewController

- (void)updateUI {
    NSString *displayText = @"";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];

    NSString *key;
    BOOL ascending;
    switch (self.sortMode) {
        case SORT_BY_DATE:
            key = @"start";
            ascending = YES;
            break;
        case SORT_BY_DATE_DESC:
            key = @"start";
            ascending = NO;
            break;
        case SORT_BY_DURATION:
            key = @"duration";
            ascending = YES;
            break;
        case SORT_BY_DURATION_DESC:
            key = @"duration";
            ascending = NO;
            break;
        case SORT_BY_SCORE:
            key = @"score";
            ascending = YES;
            break;
        case SORT_BY_SCORE_DESC:
            key = @"score";
            ascending = NO;
            break;
        default:
            key = @"score";
            ascending = NO;
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key
                                                                   ascending:ascending];
    NSArray *sortedAllGameResults = [[GameResult allGameResults] sortedArrayUsingDescriptors:@[sortDescriptor]];

    for (GameResult *result in sortedAllGameResults) {
        displayText = [displayText stringByAppendingFormat:@"Score %d (%@, %0g)\n", result.score, [dateFormatter stringFromDate:result.end], round(result.duration)];
    }
    self.display.text = displayText;
}
- (IBAction)sortByDateClicked {
    if (self.sortMode == SORT_BY_DATE) self.sortMode = SORT_BY_DATE_DESC;
    else self.sortMode = SORT_BY_DATE;
    [self updateUI];
}

- (IBAction)sortByScoreClicked {
    if (self.sortMode == SORT_BY_SCORE) self.sortMode = SORT_BY_SCORE_DESC;
    else self.sortMode = SORT_BY_SCORE;
    [self updateUI];
}

- (IBAction)sortByDurationClicked {
    if (self.sortMode == SORT_BY_DURATION) self.sortMode = SORT_BY_DURATION_DESC;
    else self.sortMode = SORT_BY_DURATION;
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateUI];
}

- (void)setup {
    // initialization that can't wait until viewDidLoad
}

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidUnload {
    [self setDisplay:nil];
    [super viewDidUnload];
}
@end
