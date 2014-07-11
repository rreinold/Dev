//
//  V02ViewController.m
//  VaprVideoV1
//
//  Created by Robert Reinold on 6/23/14.
//  Copyright (c) 2014 Robert Reinold. All rights reserved.
//

#import "V01ViewController.h"
#import "Sensor.h";
#define NSCast(x) [NSNumber numberWithFloat:x]
@interface V01ViewController ()

@end

@implementation V01ViewController

@synthesize vidPlayer;
double frameNum=0;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Sensor *sense = [[Sensor alloc] initWithData:NSCast(60)] ;
    Model* modelInUse = [[Model alloc] init];
    
	NSString *filepath = [[NSBundle mainBundle] pathForResource:@"test6" ofType:@"mov"];
    NSURL *fileURL = [NSURL fileURLWithPath:filepath];
    vidPlayer = [[AVPlayer alloc] initWithURL:fileURL];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.vidPlayer];
    self.vidPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    layer.frame = CGRectMake(0,0,320,568);
    [self.view.layer addSublayer:layer];
    
    //[self.vidPlayer play];
    NSLog(@"Playing video at %@",filepath);
    Vapr* currentVapr = [self createFakeVapr];
    
    
}
//TODO: implement dictionaryWithObjectsAndKeys:
- (Vapr*)createFakeVapr{
    NSMutableArray* fakeSensorSetArray = [[NSMutableArray alloc] init];
    //fakeSensorSetArray
    
    Vapr* fakeVapr = [[Vapr alloc] initWithData:fakeSensorSetArray];
    
    //create NSMutableArray of fake values
    
    return fakeVapr;
}

- (IBAction)displayNextFrame:(id)sender{
    int32_t timeScale = self.vidPlayer.currentItem.asset.duration.timescale;
    frameNum++;
    double frame=.04*frameNum;
    printf("Duration: ");
    CMTimeShow(self.vidPlayer.currentItem.asset.duration);
    printf("\nDictated Time: %f\n\n",frame);
    if(
       CMTimeCompare(CMTimeMakeWithSeconds(frame,timeScale),
        self.vidPlayer.currentItem.asset.duration
                     )){

        NSLog(@"Video Finished. Ignoring Next");
        //return;
    }
    
        CMTime time = CMTimeMakeWithSeconds(frame, timeScale);
    //TODO: CHange to 29Hz for v1
    [self.vidPlayer seekToTime:time toleranceBefore:CMTimeMakeWithSeconds(0.004,NSEC_PER_SEC) toleranceAfter:CMTimeMakeWithSeconds(0.004,NSEC_PER_SEC) ];
    
    //[self.mPlayer seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
    [self printTime:(frame)];
    
}
-(void)printTime:(double)timeToPrint{
        NSLog(@"FrameNum = %f setTime = %f realTime = %f",frameNum,timeToPrint,
              CMTimeGetSeconds([self.vidPlayer currentTime])
              );
    }
//TODO: CHange to 29Hz for v1
- (IBAction)displayPrevFrame:(id)sender{
    int32_t timeScale = self.vidPlayer.currentItem.asset.duration.timescale;
    frameNum--;
    double frame=.04*frameNum;
    printf("Duration: ");
    CMTimeShow(self.vidPlayer.currentItem.asset.duration);
    printf("\nDictated Time: %f\n\n",frame);
    if(
       CMTimeCompare(CMTimeMakeWithSeconds(frame,timeScale),
                     self.vidPlayer.currentItem.asset.duration
                     )){
           
           NSLog(@"Video Finished. Ignoring Next");
           //return;
       }
    
    CMTime time = CMTimeMakeWithSeconds(frame, timeScale);
    //TODO: CHange to 29Hz for v1
    [self.vidPlayer seekToTime:time toleranceBefore:CMTimeMakeWithSeconds(0.004,NSEC_PER_SEC) toleranceAfter:CMTimeMakeWithSeconds(0.004,NSEC_PER_SEC) ];
    
    //[self.mPlayer seekToTime:CMTimeMakeWithSeconds(time, NSEC_PER_SEC)];
    [self printTime:(frame)];
    
}

- (IBAction)backClear:(id)sender{
    
    frameNum=0;
}

- (IBAction)play:(id)sender{
    [self.vidPlayer play];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
