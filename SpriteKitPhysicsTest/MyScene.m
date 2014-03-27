//
//  MyScene.m
//  SpriteKitPhysicsTest
//
//  Created by Jasmine Wright on 3/25/14.
//  Copyright (c) 2014 Jasmine Wright. All rights reserved.
//

#import "MyScene.h"
@implementation MyScene

{
    SKSpriteNode *_octagon;
    SKSpriteNode *_circle;
    SKSpriteNode *_triangle;
}

-(instancetype)initWithSize:(CGSize)size
{
    if(self = [super initWithSize:size])
    {
        // Your code goes here
        _octagon = [SKSpriteNode spriteNodeWithImageNamed:@"octagon"];
        _octagon.position = CGPointMake(self.size.width * 0.25,
                                       self.size.height * 0.50);
        _octagon.physicsBody =
        [SKPhysicsBody bodyWithRectangleOfSize:_octagon.size];
        
        _circle = [SKSpriteNode spriteNodeWithImageNamed:@"circle"];
        _circle.position = CGPointMake(self.size.width * 0.50,
                                       self.size.height * 0.50);
        _circle.physicsBody =
        [SKPhysicsBody bodyWithCircleOfRadius:_circle.size.width/2];
        
        _triangle = [SKSpriteNode spriteNodeWithImageNamed:@"triangle"];
        _triangle.position = CGPointMake(self.size.width * 0.75,
                                         self.size.height * 0.5);
        [self addChild:_octagon];
        [self addChild:_circle];
        [self addChild:_triangle];
        self.physicsBody =
        [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        
        //1
        CGMutablePathRef octagonPath = CGPathCreateMutable();
        //2
        CGPathMoveToPoint(
                          octagonPath, nil, -_octagon.size.width/2, -_octagon.size.height/4);
        //3
        CGPathAddLineToPoint(octagonPath, nil, -_octagon.size.width/4, -_octagon.size.height/2);
        CGPathAddLineToPoint(octagonPath, nil, _octagon.size.width/4, -_octagon.size.height/2);
        CGPathAddLineToPoint(octagonPath, nil, _octagon.size.width/2, -_octagon.size.height/4);
        CGPathAddLineToPoint(octagonPath, nil, _octagon.size.width/2, _octagon.size.height/4);
        CGPathAddLineToPoint(octagonPath, nil, _octagon.size.width/4, _octagon.size.height/2);
        CGPathAddLineToPoint(octagonPath, nil, -_octagon.size.width/4, _octagon.size.height/2);
        CGPathAddLineToPoint(octagonPath, nil, -_octagon.size.width/2, _octagon.size.height/4);
        
        //4
        _octagon.physicsBody =
        [SKPhysicsBody bodyWithPolygonFromPath:octagonPath];
        //5
        CGPathRelease(octagonPath);
        
        [self runAction:
         [SKAction repeatAction:
          [SKAction sequence:
  @[[SKAction performSelector:@selector(spawnSand)
                     onTarget:self],
    [SKAction waitForDuration:0.02]
    ]]
                          count:100]
         ];
        

    }
    return self;
}

- (void)spawnSand
{
    //create a small ball body
    SKSpriteNode *sand =
    [SKSpriteNode spriteNodeWithImageNamed:@"sand"];
    sand.position = CGPointMake(
                                (float)(arc4random()%(int)self.size.width),
                                self.size.height - sand.size.height);
    sand.physicsBody =
    [SKPhysicsBody bodyWithCircleOfRadius:sand.size.width/2];
    sand.name = @"sand";
    [self addChild:sand];
    
    sand.physicsBody.restitution = 1.0;
    sand.physicsBody.density = 20.0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (SKSpriteNode *node in self.children) {
        if ([node.name isEqualToString:@"sand"])
            [node.physicsBody applyImpulse:
             CGVectorMake(0, arc4random()%50)];
    }
    SKAction *shake = [SKAction moveByX:0 y:10 duration:0.05];
    [self runAction:
     [SKAction repeatAction:
      [SKAction sequence:@[shake, [shake reversedAction]]]
                      count:5]];
}



@end
