//
//  HowdyTalkViewController.m
//  Howdy
//
//  Created by Edan Lichtenstein on 3/3/14.
//  Copyright (c) 2014 Edan Lichtenstein. All rights reserved.
//

#import "HowdyTalkViewController.h"
#import "AudioNoteRecorderViewController.h"


@interface HowdyTalkViewController ()

@end

@implementation HowdyTalkViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)howdyButtonPressed:(UIButton *)sender{
    
    [AudioNoteRecorderViewController showRecorderMasterViewController:self withFinishedBlock:^(BOOL wasRecordingTaken, NSURL *recordingURL) {
        if (wasRecordingTaken) {
            NSLog(@"%@", [recordingURL absoluteString]);
//          self.urlLabel.text = [recordingURL absoluteString];
        }
    }];
    
    
    NSError* error = nil;
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:_recorder.url error:&error];
    _player.volume = 1.0f;
    _player.numberOfLoops = 0;
    _player.delegate = self;
    [_player play];
    NSLog(@"duration: %f", _player.duration);
    
}
@end
