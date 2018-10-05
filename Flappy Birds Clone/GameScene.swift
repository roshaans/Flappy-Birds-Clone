import SpriteKit

class GameScene: SKScene {
     var hero: SKSpriteNode!
    var scrollLayer: SKNode!
    var sinceTouch : TimeInterval = 0
    let fixedDelta: TimeInterval = 1.0/60.0
    let scrollSpeed: CGFloat = 160
    override func didMove(to view: SKView) {
        /* Set up your scene here */
         hero = self.childNode(withName: "//hero") as! SKSpriteNode
        scrollLayer = self.childNode(withName: "scrollLayer")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        let flapSFX = SKAction.playSoundFileNamed("sfx_flap", waitForCompletion: false)
        self.run(flapSFX)
         hero.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 250))
        hero.physicsBody?.applyAngularImpulse(1)
        
        /* Reset touch timer */
        sinceTouch = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    
        let velocityY = hero.physicsBody?.velocity.dy ?? 0
        
        /* Check and cap vertical velocity */
        if velocityY > 400 {
            hero.physicsBody?.velocity.dy = 400
        }
        
        if sinceTouch > 0.1 {
            let impulse = -20000 * fixedDelta
            hero.physicsBody?.applyAngularImpulse(CGFloat(impulse))
        }
        
        /* Clamp rotation */
        hero.zRotation = hero.zRotation.clamped(CGFloat(-20).degreesToRadians(), CGFloat(30).degreesToRadians())
        hero.physicsBody!.angularVelocity = hero.physicsBody!.angularVelocity.clamped(-2, 2)
        
        /* Update last touch timer */
        sinceTouch+=fixedDelta
        scrollWorld()

    }
    
    
    func scrollWorld() {
        /* Scroll World */
        scrollLayer.position.x -= scrollSpeed * CGFloat(fixedDelta)
        
        for ground in scrollLayer.children as! [SKSpriteNode] {
            
            /* Get ground node position, convert node position to scene space */
            let groundPosition = scrollLayer.convert(ground.position, to: self)
            
            /* Check if ground sprite has left the scene */
            if groundPosition.x <= -ground.size.width / 2 {
                
                /* Reposition ground sprite to the second starting position */
                let newPosition = CGPoint( x: (self.size.width / 2) + ground.size.width, y: groundPosition.y)
                
                /* Convert new node position back to scroll layer space */
                ground.position = self.convert(newPosition, to: scrollLayer)
            }
        }
    }
    
    
    
}
