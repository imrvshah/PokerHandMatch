//
//  ViewController.m
//  poker
//
//  Created by Ravi Shah on 3/18/16.
//  Copyright © 2016 Ravi Shah. All rights reserved.
//

// Critique

// I should normalize the function to get the particular array and get the object, I have did some redudnt ode and need to get rid of it. I would like to do if I get more time


#import "ViewController.h"
#import "Card.h"
//Priority for suits
#define sSuit 1;
#define hSuit 2;
#define dSuit 3;
#define  cSuit 4;
NSInteger const  StraightFlush=80000000;
NSInteger const  FourOFAKind =  70000000;
NSInteger const  FULLHOUSE   =  60000000;
NSInteger const   Flush  =       50000000;
NSInteger const  Straight  =    40000000;
NSInteger const SET    =       30000000;
NSInteger const  TwoPairs    =  20000000;
NSInteger const  OnePair =      10000000;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // I have Started with the static to test my functions
    
    
    // Do any additional setup after loading the view, typically from a nib.
//    self.testCard=[[NSMutableArray alloc]init];
//    NSMutableArray *hand1= [[NSMutableArray alloc]init];
//    Card *card= [[Card alloc]init];
//    card.rank=5;
//    card.suit=hSuit;
//    
//    
//    Card *card1= [[Card alloc]init];
//    card1.rank=6;
//    card1.suit=sSuit;
//    
//    Card *card2= [[Card alloc]init];
//    card2.rank=13;
//    card2.suit=dSuit;
//    
//    Card *card3= [[Card alloc]init];
//    card3.rank=7;
//    card3.suit=sSuit;
//    
//    Card *card4= [[Card alloc]init];
//    card4.rank=5;
//    card4.suit=cSuit;
//    
//    [hand1 addObject:card];
//    [hand1 addObject:card1];
//    [hand1 addObject:card2];
//    [hand1 addObject:card3];
//    [hand1 addObject:card4];
    
    // Read JSON File
    
    NSError *error;
    
    NSString *fileContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"poker" ofType:@"json"] encoding:NSUTF8StringEncoding error:&error];
    NSMutableArray * arrayJSON = [NSJSONSerialization JSONObjectWithData:[fileContent dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    int count=0;
    for (NSMutableArray * arr in arrayJSON) {
        if(arr.count<=2){
            NSMutableArray *player1= [arr objectAtIndex:0];
             NSMutableArray *player2 = [arr objectAtIndex:1];
            NSMutableArray *card1=[[NSMutableArray alloc]init];
              NSMutableArray *card2=[[NSMutableArray alloc]init];
            // Assuming both have same length
            for (int i =0; i<player1.count; i++) {
                NSString *str1=[player1 objectAtIndex:i];
                 NSString *str2=[player2 objectAtIndex:i];
                Card *cardObj= [[Card alloc]init];
                cardObj.rank=[self getRank:str1];
                cardObj.suit= [self getSuit:str1];
                [card1 addObject:cardObj];
                
                Card *cardObj2= [[Card alloc]init];
                cardObj2.rank=[self getRank:str2];
                cardObj2.suit= [self getSuit:str2];
                [card2 addObject:cardObj2];
                
            }
           
            NSInteger player1Value=[self checkHand:card1];
            NSInteger player2Value=[self checkHand:card2];
            // Need to consider tie value if both same
            if(player1Value > player2Value){
                count++;
            }
        
            
        }
    }
    NSLog(@"Player1 won :%d times",count);
    
}
// Method to determine certain poker hand
-(int)checkHand:(NSMutableArray *)arr{
    if([self isFlush:arr] && [self isStright:arr]) return [self valueStraightFlush:arr];
    else if ([self is4s:arr]){
        return [self valueStraightFlush:arr];
    }
    else if ([self isFullHouse:arr]){
        return [self valueFullHouse:arr];
    }
    else if ([self isFlush:arr]){
        return [self valueFlush:arr];
    }
    else if ([self isStright:arr]){
        return [self valueStright:arr];
    }
    else if ([self is3s:arr]){
        return [self set:arr];
    }
    else if ([self is22s:arr]){
        return [self valueTwopairs:arr];
    }
    else if ([self is2s:arr]){
        return [self valueOnepairs:arr];
    }
    else{
        return [self valueHighCard:arr];
    }
    
    return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Sort the array by rank filter
-(NSArray *)sortByRank:(NSMutableArray * )arr{
    
    // Using direct function of sort
    // I can use other algorithm here but due to time constraint I have used inbuilt function
    
    NSSortDescriptor *sortDesc= [[NSSortDescriptor alloc]initWithKey:@"rank" ascending:YES];
    NSArray *discriptors = [NSArray arrayWithObjects:sortDesc, nil];
    NSArray *sortedArray = [arr sortedArrayUsingDescriptors:discriptors];
    
    return sortedArray;
}

// Sort array by suit
-(NSArray *)sortBySuit:(NSMutableArray * )arr{
    
    // Using direct function of sort
    
    NSSortDescriptor *sortDesc= [[NSSortDescriptor alloc]initWithKey:@"suit" ascending:YES];
    NSArray *discriptors = [NSArray arrayWithObjects:sortDesc, nil];
    NSArray *sortedArray = [arr sortedArrayUsingDescriptors:discriptors];
    
    return sortedArray;
}

// True if the all the cards are straight
-(BOOL)isStright:(NSMutableArray *)arrCard{
    
    int i,rank=0;
    if(arrCard.count<5){
        return NO;
    }
    
    NSArray *sortedCards=  [self sortByRank:arrCard];
    // Check if the hand has an ace
    Card *cardObj=[sortedCards objectAtIndex:0];
    Card *cardObj1=[sortedCards objectAtIndex:1];
    Card *cardObj2=[sortedCards objectAtIndex:2];
    Card *cardObj3=[sortedCards objectAtIndex:3];
    Card *cardObj4=[sortedCards objectAtIndex:4];
    if(cardObj4.rank==14){
        
        // check stright using ace
        BOOL a =cardObj.rank==2 && cardObj1.rank==3 && cardObj2.rank==4 && cardObj3.rank==5;
        BOOL b =cardObj.rank==10 && cardObj1.rank==11 && cardObj1.rank==12 && cardObj2.rank==13;
        
        return (a||b);
        
    }
    else
    {
        // General case
        rank=cardObj.rank+1;
        for (i=1; i<5; i++) {
            Card *cardObj= [sortedCards objectAtIndex:i];
            if(cardObj.rank!=rank){
                return NO;
            }
            rank++;
        }
    }
    return YES;
}
// true if card has one pair
-(BOOL)is2s:(NSMutableArray *)arrCard{
    
    BOOL a1,a2,a3,a4;
    if(arrCard.count!=5){
        return NO;
    }
    if([self is4s:arrCard] || [self isFullHouse:arrCard] || [self is3s:arrCard] ||[self is22s:arrCard] ){
        
        return NO;
    }
    NSArray *sortedCards=  [self sortByRank:arrCard];
    // Check if the hand has an ace
    Card *cardObj=[sortedCards objectAtIndex:0];
    Card *cardObj1=[sortedCards objectAtIndex:1];
    Card *cardObj2=[sortedCards objectAtIndex:2];
    Card *cardObj3=[sortedCards objectAtIndex:3];
    Card *cardObj4=[sortedCards objectAtIndex:4];
    
    a1=cardObj.rank==cardObj1.rank;
    a2=cardObj1.rank==cardObj2.rank;
    a3=cardObj2.rank==cardObj3.rank;
    a4=cardObj3.rank==cardObj4.rank;
    
    return (a1|| a2|| a3|| a4);
    
}
// true if card has four of a kind
-(BOOL)is4s:(NSMutableArray *)arrCard{
    BOOL a1,a2;
    
    if(arrCard.count!=5) return  false;
    
    NSArray *sortedCards=  [self sortByRank:arrCard];
    // Check if the hand has an ace
    Card *cardObj=[sortedCards objectAtIndex:0];
    Card *cardObj1=[sortedCards objectAtIndex:1];
    Card *cardObj2=[sortedCards objectAtIndex:2];
    Card *cardObj3=[sortedCards objectAtIndex:3];
    Card *cardObj4=[sortedCards objectAtIndex:4];
    
    a1 =cardObj.rank==cardObj1.rank  && cardObj1.rank==cardObj2.rank && cardObj2.rank==cardObj3.rank;
    a2 =cardObj1.rank==cardObj2.rank  && cardObj2.rank==cardObj3.rank && cardObj3.rank==cardObj4.rank;
    
    return (a1||a2);
}
// true if card has full house
-(BOOL)isFullHouse:(NSMutableArray *)arrCard{
    BOOL a1,a2;
    
    if(arrCard.count!=5) return  false;
    
    NSArray *sortedCards=  [self sortByRank:arrCard];
    // Check if the hand has an ace
    Card *cardObj=[sortedCards objectAtIndex:0];
    Card *cardObj1=[sortedCards objectAtIndex:1];
    Card *cardObj2=[sortedCards objectAtIndex:2];
    Card *cardObj3=[sortedCards objectAtIndex:3];
    Card *cardObj4=[sortedCards objectAtIndex:4];
    
    a1 =cardObj.rank==cardObj1.rank  && cardObj1.rank==cardObj2.rank && cardObj3.rank==cardObj4.rank;
    a2 =cardObj.rank==cardObj1.rank  && cardObj2.rank==cardObj3.rank && cardObj3.rank==cardObj4.rank;
    
    return (a1||a2);
}
// true if card has three of a kind
-(BOOL)is3s:(NSMutableArray *)arrCard{
    
    BOOL a1,a2,a3;
    
    if(arrCard.count!=5) return  false;
    if([self is4s:arrCard] || [self isFullHouse:arrCard] ){
        
        return NO;
    }
    NSArray *sortedCards=  [self sortByRank:arrCard];
    // Check if the hand has an ace
    Card *cardObj=[sortedCards objectAtIndex:0];
    Card *cardObj1=[sortedCards objectAtIndex:1];
    Card *cardObj2=[sortedCards objectAtIndex:2];
    Card *cardObj3=[sortedCards objectAtIndex:3];
    Card *cardObj4=[sortedCards objectAtIndex:4];
    
    a1 =cardObj.rank==cardObj1.rank  && cardObj1.rank==cardObj2.rank;
    a2 =cardObj1.rank==cardObj2.rank  && cardObj2.rank==cardObj3.rank;
    a3 =cardObj2.rank==cardObj3.rank  && cardObj3.rank==cardObj4.rank;
    return (a1||a2||a3);
    
}
// true if card has 2 pairs
-(BOOL)is22s:(NSMutableArray *)arrCard{
    BOOL a1,a2,a3;
    
    if(arrCard.count!=5) return  false;
    if([self is4s:arrCard] || [self isFullHouse:arrCard] || [self is3s:arrCard] ){
        
        return NO;
    }
    NSArray *sortedCards=  [self sortByRank:arrCard];
    // Check if the hand has an ace
    Card *cardObj=[sortedCards objectAtIndex:0];
    Card *cardObj1=[sortedCards objectAtIndex:1];
    Card *cardObj2=[sortedCards objectAtIndex:2];
    Card *cardObj3=[sortedCards objectAtIndex:3];
    Card *cardObj4=[sortedCards objectAtIndex:4];
    
    a1 =cardObj.rank==cardObj1.rank  && cardObj2.rank==cardObj3.rank;
    a2 =cardObj.rank==cardObj1.rank  && cardObj3.rank==cardObj4.rank;
    a3 =cardObj1.rank==cardObj2.rank  && cardObj3.rank==cardObj4.rank;
    return (a1||a2||a3);
    
}
// true if flush
-(BOOL)isFlush:(NSMutableArray *)arrCard{
    if(arrCard.count!=5){
        return NO;
    }
    NSArray *sortedArray= [self sortBySuit:arrCard];
    Card *cardObj=[sortedArray objectAtIndex:0];
    Card *cardObj4=[sortedArray objectAtIndex:4];
    
    return (cardObj.suit==cardObj4.suit);
}
// Get the rank from the array string
-(int)getRank:(NSString *)str{
    int val=0;
    if(str.length>0){
        str=[str substringToIndex:1];
    }
    if ([str isEqualToString:@"2"]) {
        val=2;
    }
    if ([str isEqualToString:@"3"]) {
        val=3;
    }
    else if([str isEqualToString:@"4"]){
        val=4;
    }
    else if([str isEqualToString:@"5"]){
        val=5;
    }
    else if([str isEqualToString:@"6"]){
        val=6;
    }
    else if([str isEqualToString:@"7"]){
        val=7;
    }
    else if ([str isEqualToString:@"8"]) {
        val=8;
    }
    else if ([str isEqualToString:@"9"]) {
        val=9;
    }
    else if ([str isEqualToString:@"T"]) {
        val=10;
    }
    else if([str isEqualToString:@"J"]){
        val=11;
    }
    else if([str isEqualToString:@"Q"]){
        val=12;
    }
    else if([str isEqualToString:@"K"]){
        val=13;
    }
    else if([str isEqualToString:@"A"]){
        val=14;
    }
    return val;
}

// Get the suit from array string
-(int)getSuit:(NSString *)str{
    int val;
    if(str.length>1){
        str=[str substringFromIndex:[str length]-1];
    }
    if ([str isEqualToString:@"S"]) {
        val=1;
    }
    else if([str isEqualToString:@"H"]){
        val=2;
    }
    else if([str isEqualToString:@"D"]){
        val=3;
    }
    else if([str isEqualToString:@"C"]){
        val=4;
    }
    return val;
}
// More general method
//-(Card *)getCard:(int)index {
//
//}

// To determine winner we need Highest value

-(int )valueHighCard:(NSMutableArray *)cards{
    int val;
    NSArray *sortedCards=  [self sortByRank:cards];
    // Check if the hand has an ace
    Card *cardObj=[sortedCards objectAtIndex:0];
    Card *cardObj1=[sortedCards objectAtIndex:1];
    Card *cardObj2=[sortedCards objectAtIndex:2];
    Card *cardObj3=[sortedCards objectAtIndex:3];
    Card *cardObj4=[sortedCards objectAtIndex:4];
    
    val = cardObj.rank+ 14*cardObj1.rank+ 14*14*cardObj2.rank+14*14*14*cardObj3.rank+14*14*14*14*cardObj4.rank;
    return val;
}
// Value two pair
-(int )valueTwopairs:(NSMutableArray *)cards{
    int val;
    NSArray *sortedCards=  [self sortByRank:cards];
    // Check if the hand has an ace
    Card *cardObj=[sortedCards objectAtIndex:0];
    Card *cardObj1=[sortedCards objectAtIndex:1];
    Card *cardObj2=[sortedCards objectAtIndex:2];
    Card *cardObj3=[sortedCards objectAtIndex:3];
    Card *cardObj4=[sortedCards objectAtIndex:4];
    
    if(cardObj.rank==cardObj1.rank && cardObj2.rank==cardObj3.rank){
        val=14*14*cardObj2.rank+14*cardObj.rank+cardObj4.rank;
    }
    else if (cardObj.rank==cardObj1.rank && cardObj3.rank==cardObj4.rank){
        val=14*14*cardObj3.rank+14*cardObj.rank+cardObj2.rank;
    }
    else
    {
        val=14*14*cardObj3.rank+14*cardObj1.rank+cardObj.rank;
    }
    
    val+=TwoPairs;
    return val;
}
// Value two pair
-(int )valueOnepairs:(NSMutableArray *)cards{
    int val;
    NSArray *sortedCards=  [self sortByRank:cards];
    // Check if the hand has an ace
    Card *cardObj=[sortedCards objectAtIndex:0];
    Card *cardObj1=[sortedCards objectAtIndex:1];
    Card *cardObj2=[sortedCards objectAtIndex:2];
    Card *cardObj3=[sortedCards objectAtIndex:3];
    Card *cardObj4=[sortedCards objectAtIndex:4];
    
    if(cardObj.rank==cardObj1.rank ){
        val=14*14*14*cardObj.rank+cardObj2.rank+14*cardObj3.rank + 14*14*cardObj4.rank;
    }
    else if(cardObj1.rank==cardObj2.rank ){
        val=14*14*14*cardObj1.rank+cardObj.rank+14*cardObj3.rank + 14*14*cardObj4.rank;
    }
    else if(cardObj2.rank==cardObj3.rank ){
        val=14*14*14*cardObj2.rank+cardObj.rank+14*cardObj1.rank + 14*14*cardObj4.rank;
    }
    else{
        val=14*14*14*cardObj3.rank+cardObj.rank+14*cardObj1.rank + 14*14*cardObj2.rank;
    }
    
    val+=OnePair;
    return val;
}

// Value of a set
-(int )set:(NSMutableArray *)cards{
    int val=0;
    NSArray *sortedCards=  [self sortByRank:cards];
    Card *cardObj2=[sortedCards objectAtIndex:2];
    val=SET+cardObj2.rank;
    return val;
}
// Value of full House
-(int )valueFullHouse:(NSMutableArray *)cards{
    int val=0;
    NSArray *sortedCards=  [self sortByRank:cards];
    Card *cardObj2=[sortedCards objectAtIndex:2];
    val=FULLHOUSE+cardObj2.rank;
    return val;
}
// value of Four of a kind
-(int )valueFourOfAKind:(NSMutableArray *)cards{
    int val=0;
    NSArray *sortedCards=  [self sortByRank:cards];
    Card *cardObj2=[sortedCards objectAtIndex:2];
    val=FourOFAKind+cardObj2.rank;
    return val;
}
// Value for stright
-(int )valueStright:(NSMutableArray *)cards{
    int val=0;
    val=Straight+[self valueHighCard:cards];
    return val;
}
// Value for a flush
-(int )valueFlush:(NSMutableArray *)cards{
    int val=0;
    val=Flush+[self valueHighCard:cards];
    return val;
}
// Value for stright flush
-(int )valueStraightFlush:(NSMutableArray *)cards{
    int val=0;
    val=StraightFlush+[self valueHighCard:cards];
    return val;
}
@end
