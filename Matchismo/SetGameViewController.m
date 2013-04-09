//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Viktor Fonic on 24.03.2013..
//  Copyright (c) 2013 Viktor Fonic. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCard.h"
#import "SetCardDeck.h"
#import "CardMatchingGame.h"
#import "GameResult.h"
#import <QuartzCore/QuartzCore.h>

@interface SetGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *flipResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) GameResult *gameResult;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) NSMutableArray *flippedCards;
@end

@implementation SetGameViewController

- (NSMutableArray *)flippedCards {
    if (!_flippedCards) _flippedCards = [[NSMutableArray alloc] initWithCapacity:3];
    return _flippedCards;
}

- (GameResult *)gameResult {
    if (!_gameResult) { _gameResult = [[GameResult alloc] init]; _gameResult.gameTypeName = @"Set"; }
    return _gameResult;
}

- (CardMatchingGame *)game {
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[[SetCardDeck alloc]init]
                                                           withMode:3];
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons {
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI {
    NSLog(@"SetGameViewController updateUI");
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *)card;
//            NSMutableAttributedString *cardAttributedString = [[NSMutableAttributedString alloc] initWithString:[setCard description]];
//            [self addAttributesFromCard:setCard
//                     toAttributedString:cardAttributedString
//                               withFont:[[cardButton.titleLabel font] fontWithSize:20]
//                                  range:NSMakeRange(0, [[setCard description] length])];
//            [cardButton setAttributedTitle:cardAttributedString forState:UIControlStateNormal];
            
//            NSMutableAttributedString *selectedCardAttributedString = [cardAttributedString mutableCopy];
//            [cardButton setAttributedTitle:selectedCardAttributedString forState:UIControlStateSelected];
            
//            NSMutableAttributedString *disabledCardAttributedString = [[NSMutableAttributedString alloc] initWithString:@""];
//            [cardButton setAttributedTitle:disabledCardAttributedString forState:UIControlStateSelected|UIControlStateDisabled];
            cardButton.selected = setCard.isFaceUp;
            cardButton.enabled = !setCard.isUnplayable;
            cardButton.alpha = (cardButton.enabled ? (cardButton.selected ? 0.5 : 1) : 0);
            if (cardButton.selected) {
                [cardButton setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2]];
            }
            else [cardButton setBackgroundColor:[UIColor whiteColor]];
            cardButton.layer.cornerRadius = 10;
        }
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
//    if (self.game.flipResult)
//        [self updateLabel:self.flipResultLabel
//               withString:self.game.flipResult];
    self.flipResultLabel.attributedText = self.game.flipResult;
    
    if ([self.flippedCards count] == 3) [self.flippedCards removeAllObjects];
}

//-(void)updateLabel:(UILabel *)label
//        withString:(NSString *)flipResult {
//    NSMutableArray *mutableCards = [self.flippedCards mutableCopy];
//    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[▲●■]+" options:0 error:nil];
//    NSArray *matches = [regex matchesInString:flipResult options:0 range:NSMakeRange(0, [flipResult length])];
//    
//    NSMutableAttributedString *flipResultAttributedString = [[NSMutableAttributedString alloc] initWithString:flipResult];
//    [flipResultAttributedString addAttribute:NSFontAttributeName value:[[label font] fontWithSize:14] range:NSMakeRange(0, [flipResult length])];
//    
//    for (NSTextCheckingResult *match in matches) {
//        NSRange matchRange = [match range];
//        SetCard *matchedCard = nil;
//        for (SetCard *card in mutableCards) {
//            if ([[card description] isEqualToString:[flipResult substringWithRange:matchRange]]
//                && card.number == matchRange.length) {
//                matchedCard = card; break;
//            }
//        }
//        [mutableCards removeObject:matchedCard];
//        if (matchedCard)
//            [self addAttributesFromCard:matchedCard toAttributedString:flipResultAttributedString withFont:[[label font] fontWithSize:18] range:matchRange];
//    }
//    self.flipResultLabel.attributedText = self.game.flipResult;
//}

- (IBAction)flipCard:(UIButton *)sender {
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    Card *card = [self.game cardAtIndex:cardIndex];
    if ([self.flippedCards containsObject:card]) [self.flippedCards removeObject:card];
    else [self.flippedCards addObject:card];
    [self.game flipCardAtIndex:cardIndex];
    ++self.flipCount;
    [self updateUI];
    self.gameResult.score = self.game.score;
}

@end
