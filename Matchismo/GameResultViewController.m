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

@end

@implementation GameResultViewController

- (void)updateUI {
    NSString *displayText = @"";
    for (GameResult *result in [GameResult allGameResults]) {
        displayText = [displayText stringByAppendingFormat:@"Score %d (%@, %0g)\n", result.score, result.end, round(result.duration)];
    }
    self.display.text = displayText;
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
