import SpriteKit
import GameplayKit
import CoreMotion
import UIKit
class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var stage:Int=1
    var allEnemies: [SKNode] = []
    var boss:SKSpriteNode!
    var bossTimer:Timer?
    var bossHp:Int=0
    var barrierItem:[SKSpriteNode]=[]
    var weaponItem:[SKSpriteNode]=[]
    var barrier:SKSpriteNode!
    var weapon:SKSpriteNode!
    var useBari:Bool=false
    var useWeap:Bool=false
    var update:Timer?
    var addBariTimer:Timer?
    var enemypos:CGPoint!
    var earth:SKSpriteNode!
    var spaceship:SKSpriteNode!
    var timer:Timer?
    var asteroidTimer:Timer?
    var atimer:Timer?
    var turnTimer:Timer?
    let restartButton=UIButton(frame:CGRect(x:UIScreen.main.bounds.width/4,y:UIScreen.main.bounds.height/2+50,width:200,height:50))
    let releaseButton=UIButton(frame:CGRect(x:UIScreen.main.bounds.width/4,y:UIScreen.main.bounds.height/2+100,width:200,height:50))
    let backTitleButton=UIButton(frame:CGRect(x:UIScreen.main.bounds.width/4,y:UIScreen.main.bounds.height/2+150,width:200,height:50))
    var rensya:Timer?
    var bombTimer:Timer?
    var sparkTimer:Timer?
    var enemyHp:[Int]=[]
    let bomb=SKSpriteNode(imageNamed:"bokeh")
    var bombnum:Int = 0
    let bombButton=UIButton(frame:CGRect(x:UIScreen.main.bounds.width-50,y:UIScreen.main.bounds.height-100,width:50,height:50))
    var asteroidDuration:TimeInterval = 6.0{
        didSet{
            if asteroidDuration<2.0{
                asteroidTimer?.invalidate()
            }
        }
    }
    var enemyDuration:TimeInterval=20
    var tmp:[SKNode]=[]
    var score:Int=0{
    didSet{
        scoreLabel.text="Score:\(score)"
        }
    }
    let text=SKLabelNode(text:"PAUSE")
    var pauseButton:UIButton!
    var over:SKLabelNode!
    var hearts:[SKSpriteNode]=[]
    let spaceshipCategory:UInt32=0b0001
    let enemyCategory:UInt32=0b10000
    let enemyBulletCategory:UInt32=0b1101
    let missileCategory:UInt32=0b0010
    let asteroidCategory:UInt32=0b0100
    let earthCategory:UInt32=0b1000
    let sparkCategory:UInt32=0b1010
    let barrierCategory:UInt32=0b1011
 //   let itemCategory:UInt32=0b00101
    let bossCategory:UInt32=0b0111
    let image = UIImage(named:"pouse")
    let motionManager=CMMotionManager()
    var accelaration:CGFloat=0.0
    var scoreLabel:SKLabelNode!
    var bestScoreLabel:SKLabelNode!
    var missile:SKSpriteNode!
    var gameVC:GameViewController!
    var enemyTimer:Timer?
    var enemy:SKSpriteNode!
    var shootTimer:Timer?
    var enemies:Int=0
    var system:Int=0
    let label=SKLabelNode(text:"好きな方を選んでタップしてください")
    let first=SKLabelNode(text:"自動連射モード")
    let second=SKLabelNode(text:"手動射撃モード")
    var isCalled:Bool=true
    override func didMove(to view: SKView) {
        select()
        setbutton()
      /*  let x = view.frame.width-50
        let y = view.frame.height/30*/
        let pauseButton = UIButton(frame: CGRect(x: view.frame.width-50, y: view.frame.height/30, width: 50, height: 50))
        pauseButton.layer.masksToBounds = true
        pauseButton.setImage(image, for: .normal)
        pauseButton.layer.cornerRadius = 20.0
        pauseButton.addTarget(self, action: #selector(self.pausebutton(sender:)), for: .touchUpInside)
        view.addSubview(pauseButton)
        physicsWorld.gravity=CGVector(dx:0,dy:0)
        physicsWorld.contactDelegate=self
        self.earth=SKSpriteNode(imageNamed: "earth")
        self.earth.xScale = 1.5
        self.earth.yScale = 0.3
        self.earth.position = CGPoint(x:0,y:-frame.height/2)
        self.earth.zPosition = -1.0
    self.earth.physicsBody=SKPhysicsBody(rectangleOf:CGSize(width:frame.width,height:100))
        self.earth.physicsBody?.categoryBitMask=earthCategory
        self.earth.physicsBody?.contactTestBitMask=asteroidCategory
        self.earth.physicsBody?.collisionBitMask=0
        addChild(self.earth)
        self.spaceship=SKSpriteNode(imageNamed:"Spaceship")
        self.spaceship.scale(to:CGSize(width:frame.width/5,height:frame.width/5))
        self.spaceship.position=CGPoint(x:0,y:self.earth.frame.maxY+50)
        self.spaceship.physicsBody=SKPhysicsBody(circleOfRadius:self.spaceship.frame.width*0.1)
        self.spaceship.physicsBody?.categoryBitMask=spaceshipCategory
        self.spaceship.physicsBody?.contactTestBitMask=asteroidCategory
        self.spaceship.physicsBody?.collisionBitMask=0
        addChild(self.spaceship)
        motionManager.accelerometerUpdateInterval=0.2
        motionManager.startAccelerometerUpdates(to:OperationQueue.current!){(data,_)in guard let data=data else{return}
            let a=data.acceleration
            self.accelaration=CGFloat(a.x)*0.75+self.accelaration*0.25
        }
        for i in 1...5{
            let heart=SKSpriteNode(imageNamed:"heart")
            heart.position=CGPoint(x:-frame.width/2+50,y:frame.height/2-heart.frame.height-heart.frame.height*CGFloat(i))
            addChild(heart)
            hearts.append(heart)
        }
        scoreLabel=SKLabelNode(text:"Score:0")
        scoreLabel.fontName="PixelMplus12-Bold"
        scoreLabel.fontSize=50
        scoreLabel.position=CGPoint(x:-frame.width/2+scoreLabel.frame.width/2+100,y:-frame.height/2)
        addChild(scoreLabel)
        let bestScore=UserDefaults.standard.integer(forKey:"bestscore")
        bestScoreLabel=SKLabelNode(text:"Bestscore:\(bestScore)")
        bestScoreLabel.fontName="PixelMplus12-Bold"
        bestScoreLabel.fontSize=50
        bestScoreLabel.position=scoreLabel.position.applying(CGAffineTransform(translationX:100,y:bestScoreLabel.frame.height*1.5))
        addChild(bestScoreLabel)
        
      /*  asteroidTimer=Timer.scheduledTimer(withTimeInterval:5.0,repeats:true,block:{
            _ in self.asteroidDuration-=0.5
 })*/
    }
    override func didSimulatePhysics(){
        let nextPosition=self.spaceship.position.x+self.accelaration*50
        if nextPosition>frame.width/2-30{return}
        if nextPosition < -frame.width/2+30{return}
        self.spaceship.position.x=nextPosition
    }
    override func touchesEnded(_ touches:Set<UITouch>,with event:UIEvent?){
        if isPaused && system==0{
            for touch:AnyObject in touches{
                let locate=touch.location(in:self)
                if locate.x<0{
                    system=1
                    isPaused=false
                    rensya=Timer.scheduledTimer(withTimeInterval:0.2,repeats:true,block:{_ in self.shootmissile()})
                    addChild(SKAudioNode.init(fileNamed:"bgm_maoudamashii_8bit08"/*"mashi_game_bgm"*/))
                    timer=Timer.scheduledTimer(withTimeInterval:0.5,repeats:true,block:{_ in self.addAsteroid()})
                    bombTimer=Timer.scheduledTimer(withTimeInterval:10,repeats:true,block:{_ in self.addBomb()})
                    enemyTimer=Timer.scheduledTimer(withTimeInterval:7,repeats:true,block:{_ in self.addEnemy()})
                    shootTimer=Timer.scheduledTimer(withTimeInterval:3,repeats:true,block:{_ in self.shootBullet()})
                    bossTimer=Timer.scheduledTimer(withTimeInterval:15,repeats:true,block:{_ in self.addBoss()})
                    turnTimer=Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in self.bossTurn()})
                    update=Timer.scheduledTimer(withTimeInterval:0.1, repeats: true, block: {_ in self.updates()})
                    label.removeFromParent()
                    first.removeFromParent()
                    second.removeFromParent()
                    return
                }else{
                    system=2
                    isPaused=false
                    addChild(SKAudioNode.init(fileNamed:"bgm_maoudamashii_8bit08"/*"mashi_game_bgm"*/))
                    timer=Timer.scheduledTimer(withTimeInterval:0.5,repeats:true,block:{_ in self.addAsteroid()})
                    bombTimer=Timer.scheduledTimer(withTimeInterval:10,repeats:true,block:{_ in self.addBomb()})
                    enemyTimer=Timer.scheduledTimer(withTimeInterval:7,repeats:true,block:{_ in self.addEnemy()})
                    shootTimer=Timer.scheduledTimer(withTimeInterval:3,repeats:true,block:{_ in self.shootBullet()})
                    bossTimer=Timer.scheduledTimer(withTimeInterval:15,repeats:true,block:{_ in self.addBoss()})
                    turnTimer=Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in self.bossTurn()})
                    update=Timer.scheduledTimer(withTimeInterval:0.1, repeats: true, block: {_ in self.updates()})
                    label.removeFromParent()
                    first.removeFromParent()
                    second.removeFromParent()
                    return
                }
            }
        }
        if isPaused || system==1{return}
        rensya?.invalidate()
        isCalled=true
        let gun=SKAudioNode.init(fileNamed:"gun")
        addChild(gun)
        let missile = SKSpriteNode(imageNamed:"missile")
        missile.position=CGPoint(x:self.spaceship.position.x,y:self.spaceship.position.y+50)
        missile.physicsBody=SKPhysicsBody(circleOfRadius:missile.frame.height/2)
        missile.physicsBody?.categoryBitMask=missileCategory
        missile.physicsBody?.contactTestBitMask=asteroidCategory
        missile.physicsBody?.collisionBitMask=0
        addChild(missile)
        let moveToTop=SKAction.moveTo(y:frame.height+10,duration:0.3)
        let remove = SKAction.removeFromParent()
        missile.run(SKAction.sequence([moveToTop,remove]))
        self.run(SKAction.wait(forDuration:1.0)){
            gun.removeFromParent()
        }
        if useWeap{
            let missile2 = SKSpriteNode(imageNamed:"missile")
            missile2.position=CGPoint(x:self.spaceship.position.x+50,y:self.spaceship.position.y+50)
            missile2.physicsBody=SKPhysicsBody(circleOfRadius:missile.frame.height/2)
            missile2.physicsBody?.categoryBitMask=missileCategory
            missile2.physicsBody?.contactTestBitMask=asteroidCategory
            missile2.physicsBody?.collisionBitMask=0
            addChild(missile2)
            missile2.run(SKAction.sequence([moveToTop,remove]))
            let missile3 = SKSpriteNode(imageNamed:"missile")
            missile3.position=CGPoint(x:self.spaceship.position.x-50,y:self.spaceship.position.y+50)
            missile3.physicsBody=SKPhysicsBody(circleOfRadius:missile.frame.height/2)
            missile3.physicsBody?.categoryBitMask=missileCategory
            missile3.physicsBody?.contactTestBitMask=asteroidCategory
            missile3.physicsBody?.collisionBitMask=0
            addChild(missile3)
            missile3.run(SKAction.sequence([moveToTop,remove]))
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isPaused {return}
       // print(isCalled)
        if system==2 && isCalled
        {
        //    print("a")
            rensya=Timer.scheduledTimer(withTimeInterval:0.2,repeats:true,block:{_ in self.shootmissile()})
            isCalled=false
        }
       /* addChild(self.gun)
        let missile = SKSpriteNode(imageNamed:"missile")
        missile.position=CGPoint(x:self.spaceship.position.x,y:self.spaceship.position.y+50)
        missile.physicsBody=SKPhysicsBody(circleOfRadius:missile.frame.height/2)
        missile.physicsBody?.categoryBitMask=missileCategory
        missile.physicsBody?.contactTestBitMask=asteroidCategory
        missile.physicsBody?.collisionBitMask=0
        addChild(missile)
        let moveToTop=SKAction.moveTo(y:frame.height+10,duration:0.3)
        let remove = SKAction.removeFromParent()
        missile.run(SKAction.sequence([moveToTop,remove]))
        self.run(SKAction.wait(forDuration:1.0)){
            self.gun.removeFromParent()
        }
        
        if useWeap{
            let missile2 = SKSpriteNode(imageNamed:"missile")
            missile2.position=CGPoint(x:self.spaceship.position.x+50,y:self.spaceship.position.y+50)
            missile2.physicsBody=SKPhysicsBody(circleOfRadius:missile.frame.height/2)
            missile2.physicsBody?.categoryBitMask=missileCategory
            missile2.physicsBody?.contactTestBitMask=asteroidCategory
            missile2.physicsBody?.collisionBitMask=0
            addChild(missile2)
            missile2.run(SKAction.sequence([moveToTop,remove]))
            let missile3 = SKSpriteNode(imageNamed:"missile")
            missile3.position=CGPoint(x:self.spaceship.position.x-50,y:self.spaceship.position.y+50)
            missile3.physicsBody=SKPhysicsBody(circleOfRadius:missile.frame.height/2)
            missile3.physicsBody?.categoryBitMask=missileCategory
            missile3.physicsBody?.contactTestBitMask=asteroidCategory
            missile3.physicsBody?.collisionBitMask=0
            addChild(missile3)
            missile3.run(SKAction.sequence([moveToTop,remove]))
        }*/
    }
        func shootmissile(){
            let gun=SKAudioNode.init(fileNamed:"gun")
            addChild(gun)
            let missile = SKSpriteNode(imageNamed:"missile")
            missile.position=CGPoint(x:self.spaceship.position.x,y:self.spaceship.position.y+50)
            missile.physicsBody=SKPhysicsBody(circleOfRadius:missile.frame.height/2)
            missile.physicsBody?.categoryBitMask=missileCategory
            missile.physicsBody?.contactTestBitMask=asteroidCategory
            missile.physicsBody?.collisionBitMask=0
            addChild(missile)
            let moveToTop=SKAction.moveTo(y:frame.height+10,duration:0.3)
            let remove = SKAction.removeFromParent()
            missile.run(SKAction.sequence([moveToTop,remove]))
            self.run(SKAction.wait(forDuration:1.0)){
                gun.removeFromParent()
            }
        
            if useWeap{
                let missile2 = SKSpriteNode(imageNamed:"missile")
                missile2.position=CGPoint(x:self.spaceship.position.x+50,y:self.spaceship.position.y+50)
                missile2.physicsBody=SKPhysicsBody(circleOfRadius:missile.frame.height/2)
                missile2.physicsBody?.categoryBitMask=missileCategory
                missile2.physicsBody?.contactTestBitMask=asteroidCategory
                missile2.physicsBody?.collisionBitMask=0
                addChild(missile2)
                missile2.run(SKAction.sequence([moveToTop,remove]))
                let missile3 = SKSpriteNode(imageNamed:"missile")
                missile3.position=CGPoint(x:self.spaceship.position.x-50,y:self.spaceship.position.y+50)
                missile3.physicsBody=SKPhysicsBody(circleOfRadius:missile.frame.height/2)
                missile3.physicsBody?.categoryBitMask=missileCategory
                missile3.physicsBody?.contactTestBitMask=asteroidCategory
                missile3.physicsBody?.collisionBitMask=0
                addChild(missile3)
                missile3.run(SKAction.sequence([moveToTop,remove]))
            }
        }
    func select(){
        isPaused=true
        label.position=CGPoint(x:0,y:frame.height/3)
        label.fontName="PixelMplus12-Bold"
        label.fontSize=45
        addChild(label)
        first.position=CGPoint(x:-frame.width/3,y:-frame.height/3)
        first.fontName="PixelMplus12-Bold"
        first.fontSize=37
        addChild(first)
        second.position=CGPoint(x:frame.width/3,y:-frame.height/3)
        second.fontName="PixelMplus12-Bold"
        second.fontSize=37
        addChild(second)
    }
    func addBomb(){
        bombnum=1
        bomb.position=CGPoint(x:-frame.width/2+scoreLabel.frame.width/2+50,y:frame.height/2-scoreLabel.frame.height*7)
        addChild(bomb)
        bombButton.isHidden=false
        bombButton.isEnabled=true
        bombTimer?.invalidate()
    }
    @objc func bombButton(sender:UIButton){
        bombnum=0
        bomb.removeFromParent()
        let spark=SKSpriteNode(imageNamed:"mspark")
        spark.position=CGPoint(x:self.spaceship.position.x,y:0)
        spark.xScale=frame.width/200
        spark.yScale=frame.height/370
        spark.physicsBody=SKPhysicsBody(rectangleOf:spark.size)
        spark.physicsBody?.categoryBitMask=sparkCategory
        spark.physicsBody?.contactTestBitMask=asteroidCategory
        spark.physicsBody?.collisionBitMask=0
        addChild(spark)
        let se=SKAudioNode.init(fileNamed:"beamgum")
        addChild(se)
        sparkTimer=Timer.scheduledTimer(withTimeInterval:2.0, repeats: false, block: {_ in
            spark.removeFromParent()
        })
        if bombnum==0{
            bombButton.isHidden=true
            bombButton.isEnabled=false
        }
        self.run(SKAction.wait(forDuration:3)){
            se.removeFromParent()
        }
        bombTimer=Timer.scheduledTimer(withTimeInterval:10,repeats:true,block:{_ in self.addBomb()})
    }
    func addAsteroid(){
        let names=["asteroid1","asteroid2","asteroid3"]
        let index=Int(arc4random_uniform(UInt32(names.count)))
        let name=names[index]
        let asteroid=SKSpriteNode(imageNamed:name)
        let random=CGFloat(arc4random_uniform(UINT32_MAX))/CGFloat(UINT32_MAX)
        let positionX=frame.width*(random-0.5)
        asteroid.position=CGPoint(x:positionX,y:frame.height/2+asteroid.frame.height)
        asteroid.scale(to:CGSize(width:70,height:70))
        asteroid.physicsBody=SKPhysicsBody(circleOfRadius:asteroid.frame.width)
        asteroid.physicsBody?.categoryBitMask=asteroidCategory
        asteroid.physicsBody?.contactTestBitMask=missileCategory+spaceshipCategory+earthCategory
        asteroid.physicsBody?.collisionBitMask=0
        addChild(asteroid)
        
        let move=SKAction.moveTo(y : -frame.height/2-asteroid.frame.height,duration:asteroidDuration)
        let remove=SKAction.removeFromParent()
        asteroid.run(SKAction.sequence([move,remove]))
    }
    func addEnemy(){
        enemies+=1
        self.enemy=SKSpriteNode(imageNamed:"ufo")
        let random=CGFloat(arc4random_uniform(UINT32_MAX))/CGFloat(UINT32_MAX)
        let positionX=frame.width*(random-0.5)
        self.enemy.position=CGPoint(x:positionX,y:frame.height/2)
        self.enemy.scale(to:CGSize(width:90,height:75))
        self.enemy.physicsBody=SKPhysicsBody(circleOfRadius:enemy.frame.width)
        self.enemy.physicsBody?.categoryBitMask=enemyCategory
        self.enemy.physicsBody?.contactTestBitMask=missileCategory+spaceshipCategory+earthCategory
        self.enemy.physicsBody?.collisionBitMask=0
        self.allEnemies.append(enemy)
        self.enemyHp.append(3)
        addChild(self.enemy)
       // print("Added")
        let shoot=SKAction.run({
            self.shootBullet()
        })
        let move=SKAction.moveTo(y :-frame.height/2,duration:enemyDuration)
        let remove=SKAction.removeFromParent()
        self.enemy.run(SKAction.sequence([shoot,move,remove]))
    }
    func didBegin(_ contact:SKPhysicsContact){
        var asteroid:SKPhysicsBody
        var target:SKPhysicsBody
        var enemy:SKPhysicsBody
        if contact.bodyA.categoryBitMask == asteroidCategory||contact.bodyB.categoryBitMask == asteroidCategory{
        if contact.bodyA.categoryBitMask == asteroidCategory{
            asteroid=contact.bodyA
            target=contact.bodyB
        }else{
            asteroid=contact.bodyB
            target=contact.bodyA
        }
            if target.categoryBitMask==enemyCategory||target.categoryBitMask==bossCategory{
                return
            }
        guard let asteroidNode=asteroid.node else{return}
        guard let targetNode=target.node else{return}
        guard let explosion=SKEmitterNode(fileNamed:"Explosion") else{return}
        let se=SKAudioNode.init(fileNamed:"explosion")
        addChild(se)
        explosion.position=asteroidNode.position
        addChild(explosion)
        asteroidNode.removeFromParent()
        if target.categoryBitMask==barrierCategory{
                barrier.removeFromParent()
                useBari=false
        }
            if target.categoryBitMask==enemyCategory{
                return
            }
        if target.categoryBitMask==missileCategory{
            targetNode.removeFromParent()
            score+=1000
        }
        if target.categoryBitMask==sparkCategory{
            score+=1000
        }
        self.run(SKAction.wait(forDuration:1.0)){
            explosion.removeFromParent()
            se.removeFromParent()
        }
    
        if target.categoryBitMask==spaceshipCategory||target.categoryBitMask==earthCategory{
            guard let heart=hearts.last else{return}
            heart.removeFromParent()
            hearts.removeLast()
            if hearts.isEmpty{
                gameOver()
            }
            if useWeap{
                useWeap=false
            }
        }
        }
        else if contact.bodyA.categoryBitMask==barrierCategory||contact.bodyA.categoryBitMask==barrierCategory{
            if contact.bodyA.categoryBitMask == barrierCategory{
                enemy=contact.bodyA
                target=contact.bodyB
            }else{
                enemy=contact.bodyB
                target=contact.bodyA
            }
            if target.categoryBitMask==missileCategory||target.categoryBitMask==spaceshipCategory||target.categoryBitMask==earthCategory{
                return
            }
            guard let enemyNode=enemy.node else{return}
            guard let targetNode=target.node else{return}
            if target.categoryBitMask==enemyBulletCategory{
                targetNode.removeFromParent()
            }
            if target.categoryBitMask==enemyCategory{
                targetNode.removeFromParent()
            }
            enemyNode.removeFromParent()
            useBari=false
        }
        else if contact.bodyA.categoryBitMask == enemyCategory||contact.bodyB.categoryBitMask == enemyCategory{
            if contact.bodyA.categoryBitMask == enemyCategory{
            enemy=contact.bodyA
            target=contact.bodyB
        }else{
            enemy=contact.bodyB
            target=contact.bodyA
        }
        if target.categoryBitMask==enemyBulletCategory||target.categoryBitMask==bossCategory{return}
        
        guard let enemyNode=enemy.node else{return}
        guard let targetNode=target.node else{return}
        guard let explosion=SKEmitterNode(fileNamed:"Explosion") else{return}
        explosion.position=enemyNode.position
        enemypos=enemyNode.position
        let se=SKAudioNode.init(fileNamed:"explosion")
        addChild(se)
        addChild(explosion)
            tmp.removeAll()
            for i in 0..<enemies{
               tmp.append(allEnemies[i])
            }
            allEnemies.removeAll()
            for i in 0..<enemies{
                if enemyNode.position==tmp[i].position && target.categoryBitMask==missileCategory{
                 //   print(i,enemyHp[i])
                    enemyHp[i]-=1
                    if enemyHp[i]<=0{
                        enemyNode.removeFromParent()
                        enemies-=1
                        enemyHp.remove(at:0)
                        addBarrier()
                    continue
                    }
                }
                if enemyNode.position==tmp[i].position && target.categoryBitMask==sparkCategory{
                    enemyHp[i]=0
                    enemyNode.removeFromParent()
                    enemies-=1
                    enemyHp.remove(at:0)
                    continue
                }
                allEnemies.append(tmp[i])
            }
       // print("die")
        if target.categoryBitMask==barrierCategory{
                barrier.removeFromParent()
                useBari=false
        }
        if target.categoryBitMask==missileCategory{
            targetNode.removeFromParent()
            score+=1000
        }
        if target.categoryBitMask==sparkCategory{
            score+=1000
        }
        self.run(SKAction.wait(forDuration:1.0)){
            explosion.removeFromParent()
            se.removeFromParent()
        }
        
        if target.categoryBitMask==spaceshipCategory||target.categoryBitMask==earthCategory{
            guard let heart=hearts.last else{return}
            heart.removeFromParent()
            hearts.removeLast()
            if hearts.isEmpty{
                gameOver()
            }
            if useWeap{
                useWeap=false
            }
        }
    }
        else if contact.bodyA.categoryBitMask == enemyBulletCategory||contact.bodyA.categoryBitMask == enemyBulletCategory{
            if contact.bodyA.categoryBitMask == enemyBulletCategory{
                enemy=contact.bodyA
                target=contact.bodyB
            }else{
                enemy=contact.bodyB
                target=contact.bodyA
            }
            if target.categoryBitMask==missileCategory||target.categoryBitMask==bossCategory||target.categoryBitMask==asteroidCategory{
                return
            }
            guard let enemyNode=enemy.node else{return}
            guard let targetNode=target.node else{return}
            guard let explosion=SKEmitterNode(fileNamed:"Explosion") else{return}
            explosion.position=targetNode.position
            addChild(explosion)
            enemyNode.removeFromParent()
            let se=SKAudioNode.init(fileNamed:"explosion")
            addChild(se)
            if target.categoryBitMask==barrierCategory{
                barrier.removeFromParent()
                useBari=false
            }
            if target.categoryBitMask==spaceshipCategory{
                guard let heart=hearts.last else{return}
                heart.removeFromParent()
                hearts.removeLast()
                if hearts.isEmpty{
                    gameOver()
                }
                if useWeap{
                    useWeap=false
                }
            }
            self.run(SKAction.wait(forDuration:1.0)){
                explosion.removeFromParent()
                se.removeFromParent()
            }
        }
        else if contact.bodyA.categoryBitMask == bossCategory||contact.bodyA.categoryBitMask == bossCategory{
            if contact.bodyA.categoryBitMask == bossCategory{
                enemy=contact.bodyA
                target=contact.bodyB
            }else{
                enemy=contact.bodyB
                target=contact.bodyA
            }
           // if target.categoryBitMask==enemyCategory||target.categoryBitMask==asteroidCategory{return }
            guard let enemyNode=enemy.node else{return}
            guard let targetNode=target.node else{return}
            guard let explosion=SKEmitterNode(fileNamed:"Explosion") else{return}
            explosion.position=targetNode.position
            addChild(explosion)
            let se=SKAudioNode.init(fileNamed:"explosion")
            addChild(se)
            if target.categoryBitMask==missileCategory{
                bossHp-=1
                print(bossHp)
                score+=1000
                targetNode.removeFromParent()
            }
            if target.categoryBitMask==sparkCategory{
                bossHp-=10
                print(bossHp)
                score+=1000
            }
            if bossHp<1 && enemies != 0{
                enemyNode.removeFromParent()
                bossRemoved()
            }
            if target.categoryBitMask==spaceshipCategory{
                guard let heart=hearts.last else{return}
                heart.removeFromParent()
                hearts.removeLast()
                if hearts.isEmpty{
                    gameOver()
                }
                if useWeap{
                    useWeap=false
                }
            }
            self.run(SKAction.wait(forDuration:1.0)){
                explosion.removeFromParent()
                se.removeFromParent()
            }
        }
     /*       else if contact.bodyA.categoryBitMask == itemCategory||contact.bodyA.categoryBitMask == itemCategory{
            print("come")
            if contact.bodyA.categoryBitMask == itemCategory{
                enemy=contact.bodyA
                target=contact.bodyB
            }else{
                enemy=contact.bodyB
                target=contact.bodyA
            }
            guard let enemyNode=enemy.node else{return}
            guard let targetNode=target.node else{return}
            if target.categoryBitMask != spaceshipCategory{
                return
            }
            if target.categoryBitMask == spaceshipCategory{
                print("true")
                
            }
         
             setBarrier()
             enemyNode.removeFromParent()
            
        }*/
    }
    func gameOver(){
        timer?.invalidate()
        enemyTimer?.invalidate()
        bombTimer?.invalidate()
        shootTimer?.invalidate()
        bossTimer?.invalidate()
        turnTimer?.invalidate()
        isCalled=true
        rensya?.invalidate()
        restartButton.isHidden=false
        restartButton.isEnabled=true
        backTitleButton.isHidden=false
        backTitleButton.isEnabled=true
        asteroidDuration=6.0
        enemyDuration=20
        isPaused=true
        timer?.invalidate()
        textPrint()
        let bestScore=UserDefaults.standard.integer(forKey:"bestscore")
        if bestScore<score{
            UserDefaults.standard.set(score,forKey:"bestscore")
        }
        
    }
    func textPrint(){
        over=SKLabelNode(text:"GAME OVER")
        over.fontName="PixelMplus12-Bold"
        over.fontSize=100
        over.position=CGPoint(x:self.frame.midX,y:self.frame.midY)
        addChild(over)
    }
    @objc func pausebutton(sender:UIButton){
        if(isPaused && hearts.isEmpty==false){
            text.removeFromParent()
            isPaused=false
            timer=Timer.scheduledTimer(withTimeInterval:0.5,repeats:true,block:{_ in self.addAsteroid()})
            bombTimer=Timer.scheduledTimer(withTimeInterval:10,repeats:true,block:{_ in self.addBomb()})
            enemyTimer=Timer.scheduledTimer(withTimeInterval:7,repeats:true,block:{_ in self.addEnemy()})
            shootTimer=Timer.scheduledTimer(withTimeInterval:3,repeats:true,block:{_ in self.shootBullet()})
            bossTimer=Timer.scheduledTimer(withTimeInterval:15,repeats:true,block:{_ in self.addBoss()})
            turnTimer=Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in self.bossTurn()})
            rensya=Timer.scheduledTimer(withTimeInterval:0.2,repeats:true,block:{_ in self.shootmissile()})
            restartButton.isHidden=true
            releaseButton.isHidden=true
            restartButton.isEnabled=false
            releaseButton.isEnabled=false
            backTitleButton.isHidden=true
            backTitleButton.isEnabled=false
            if bombnum==1{
                bombButton.isEnabled=true
         }
            addChild(SKAudioNode.init(fileNamed:"bgm_maoudamashii_8bit08.mp3"))
        }
        else if hearts.isEmpty==false{
            isPaused=true
            timer?.invalidate()
            enemyTimer?.invalidate()
            bombTimer?.invalidate()
            shootTimer?.invalidate()
            bossTimer?.invalidate()
            turnTimer?.invalidate()
            rensya?.invalidate()
            text.fontName="PixelMplus12-Bold"
            text.fontSize=200
            text.position=CGPoint(x:self.frame.midX,y:self.frame.midY)
            addChild(text)
            restartButton.isHidden=false
            releaseButton.isHidden=false
            restartButton.isEnabled=true
            releaseButton.isEnabled=true
            backTitleButton.isHidden=false
            backTitleButton.isEnabled=true
            if bombnum==1{
                bombButton.isEnabled=false
            }
        }
    }
    @objc func restartButton(sender:UIButton){
       // addChild(SKAudioNode.init(fileNamed:"bgm_maoudamashii_8bit08.mp3"))
        if bossHp>0{boss.removeFromParent()}
        bossHp=0
        stage=1
        text.removeFromParent()
        restartButton.isHidden=true
        releaseButton.isHidden=true
        restartButton.isEnabled=false
        releaseButton.isEnabled=false
        backTitleButton.isHidden=true
        backTitleButton.isEnabled=false
        if system==1{
            rensya?.invalidate()
        }
        enemies=0
        removeAllChildren()
        allEnemies.removeAll()
        useWeap=false
        useBari=false
        barrierItem.removeAll()
        weaponItem.removeAll()
        hearts=[]
        bombButton.isEnabled=false
        bombButton.isHidden=true
        for i in 1...5{
            let heart=SKSpriteNode(imageNamed:"heart")
            heart.position=CGPoint(x:-frame.width/2+50,y:frame.height/2-heart.frame.height-heart.frame.height*CGFloat(i))
            addChild(heart)
            hearts.append(heart)
        }
         addChild(self.earth)
        addChild(self.spaceship)
        addChild(scoreLabel)
        addChild(bestScoreLabel)
        asteroidDuration=6.0
        isPaused=false
        system=0
        select()
        score=0
        
    }
    @objc func releaseButton(sender:UIButton){
   //     addChild(SKAudioNode.init(fileNamed:"bgm_maoudamashii_8bit08.mp3"))
        text.removeFromParent()
        isPaused=false
        setTimer()
        restartButton.isHidden=true
        releaseButton.isHidden=true
        restartButton.isEnabled=false
        releaseButton.isEnabled=false
        backTitleButton.isHidden=true
        backTitleButton.isEnabled=false
        if bombnum==1{
            bombButton.isEnabled=true
        }
        if isCalled==false{
            isCalled=true
        }
       // addChild(SKAudioNode.init(fileNamed:"bgm_maoudamashii_8bit08.mp3"))
    }
    @objc func backTitleButton(sender:UIButton){
         self.gameVC.dismiss(animated:true,completion:nil)
    }
    func shootBullet(){
        let index = arc4random_uniform(UInt32(enemies))
        if enemies != 0{
            let attackEnemy=allEnemies[Int(index)]
          //  print("true")
            let bullet = SKSpriteNode(imageNamed:"missile")
            bullet.position=attackEnemy.position
            bullet.physicsBody=SKPhysicsBody(rectangleOf:CGSize(width:bullet.frame.width, height:bullet.frame.height ))
            bullet.physicsBody?.categoryBitMask=enemyBulletCategory
            bullet.physicsBody?.contactTestBitMask=spaceshipCategory
            bullet.physicsBody?.collisionBitMask=0
            addChild(bullet)
            let moveToButtom=SKAction.moveTo(y:-frame.height,duration:2.0)
            let remove = SKAction.removeFromParent()
            bullet.run(SKAction.sequence([moveToButtom,remove]))
        }
    }
    func addBarrier(){
        let expect:Int=Int(arc4random_uniform(10))
        if expect<6{
            return
        }
     //   print(expect)
        if expect == 6 || expect == 7 {
        let bItem=SKSpriteNode(imageNamed:"Bitem")
        bItem.xScale=3
        bItem.yScale=3
        bItem.position=enemypos
        bItem.physicsBody=SKPhysicsBody(circleOfRadius:bItem.frame.height)
        //bItem.physicsBody?.categoryBitMask=itemCategory
        bItem.physicsBody?.contactTestBitMask=spaceshipCategory
        bItem.physicsBody?.collisionBitMask=0
        barrierItem.append(bItem)
        //print(barrierItem[0].position.x)
       // print(barrierItem.count)
        addChild(bItem)
        let moveToButtom=SKAction.moveTo(y:-frame.height,duration:4.0)
       // let remove = SKAction.removeFromParent()
        bItem.run(SKAction.sequence([moveToButtom]))
    }
        if expect == 8 || expect == 9 {
            let bItem=SKSpriteNode(imageNamed:"Witem")
            bItem.xScale=2
            bItem.yScale=2
            bItem.position=enemypos
            bItem.physicsBody=SKPhysicsBody(circleOfRadius:bItem.frame.height)
            //bItem.physicsBody?.categoryBitMask=itemCategory
            bItem.physicsBody?.contactTestBitMask=spaceshipCategory
            bItem.physicsBody?.collisionBitMask=0
            weaponItem.append(bItem)
            //print(barrierItem[0].position.x)
            // print(barrierItem.count)
            addChild(bItem)
            let moveToButtom=SKAction.moveTo(y:-frame.height,duration:4.0)
            // let remove = SKAction.removeFromParent()
            bItem.run(SKAction.sequence([moveToButtom]))
        }
}
    func setBarrier(){
      //  print("set")
         barrier=SKSpriteNode(imageNamed:"barrier")
         barrier.xScale=0.5
         barrier.yScale=0.5
         barrier.position=CGPoint(x:spaceship.position.x,y:-frame.height/3)
         barrier.physicsBody=SKPhysicsBody(rectangleOf: CGSize(width:barrier.frame.width,height:barrier.frame.height))
         barrier.physicsBody?.categoryBitMask=barrierCategory
         barrier.physicsBody?.contactTestBitMask=asteroidCategory+enemyCategory+enemyBulletCategory
         barrier.physicsBody?.collisionBitMask=0
       //  print(barrier.position)
         addChild(barrier)
        /* let moveWithShip=SKAction.moveTo(x:spaceship.position.x,duration: 1)
         barrier.run(SKAction.sequence([moveWithShip]))*/
         useBari=true
    }
   func updates(){
    print(bossHp)
    if barrierItem.count>0{
        for i in 0...barrierItem.count-1{
            if abs(barrierItem[i].position.x-spaceship.position.x)<48 && abs(barrierItem[i].position.y-spaceship.position.y)<48{
                let se=SKAudioNode.init(fileNamed:"power-up")
                setBarrier()
                barrierItem[i].removeFromParent()
                barrierItem.remove(at: i)
                self.run(SKAction.wait(forDuration:1.0)){
                    se.removeFromParent()
                }
              //  print(barrierItem.count)
                break
            }
            if barrierItem[i].position.y < -frame.height{
                barrierItem[i].removeFromParent()
                barrierItem.remove(at: i)
                continue
            }
        }
    }
    if weaponItem.count>0{
        for i in 0...weaponItem.count-1{
            if abs(weaponItem[i].position.x-spaceship.position.x)<48 && abs(weaponItem[i].position.y-spaceship.position.y)<48{
                let se=SKAudioNode.init(fileNamed:"power-up")
                weaponItem[i].removeFromParent()
                weaponItem.remove(at: i)
                useWeap=true
                self.run(SKAction.wait(forDuration:1.0)){
                    se.removeFromParent()
                }
                break
                //  print(barrierItem.count)
            }
            if weaponItem[i].position.y < -frame.height{
                weaponItem[i].removeFromParent()
                weaponItem.remove(at: i)
                continue
            }
        }
    }
        if useBari{
             //   print("remove")
                self.barrier.removeFromParent()
                self.barrier=SKSpriteNode(imageNamed:"barrier")
                self.barrier.xScale=0.5
                self.barrier.yScale=0.5
                self.barrier.position=CGPoint(x:self.spaceship.position.x,y:-self.frame.height/3)
                self.barrier.physicsBody=SKPhysicsBody(rectangleOf: CGSize(width:self.barrier.frame.width,height:self.barrier.frame.height))
                self.barrier.physicsBody?.categoryBitMask=self.barrierCategory
                self.barrier.physicsBody?.contactTestBitMask=self.asteroidCategory+self.enemyCategory+self.enemyBulletCategory
                self.barrier.physicsBody?.collisionBitMask=0
                //print(barrier.position)
                self.addChild(self.barrier)
                self.useBari=true
        }
}
    func setbutton(){
        bombButton.layer.cornerRadius=bombButton.frame.size.height/2
        bombButton.setTitle("SPARK!",for:.normal)
        bombButton.setTitleColor(UIColor.darkText,for:.normal)
        bombButton.backgroundColor=UIColor.red
        bombButton.titleLabel?.font=UIFont.systemFont(ofSize:10)
        bombButton.addTarget(self,action:#selector(self.bombButton(sender:)),for:.touchUpInside)
        self.view?.addSubview(bombButton)
        bombButton.isHidden=true
        bombButton.isEnabled=false
        restartButton.layer.masksToBounds=true
        restartButton.setTitle("はじめから",for:.normal)
        restartButton.setTitleColor(UIColor.darkText,for:.normal)
        restartButton.backgroundColor=UIColor.red
        restartButton.layer.borderWidth=0.5
        restartButton.addTarget(self,action:#selector(self.restartButton(sender:)),for:.touchUpInside)
        releaseButton.layer.masksToBounds=true
        releaseButton.setTitle("続ける",for:.normal)
        releaseButton.setTitleColor(UIColor.darkText,for:.normal)
        releaseButton.backgroundColor=UIColor.red
        releaseButton.layer.borderWidth=0.5
        releaseButton.addTarget(self,action:#selector(self.releaseButton(sender:)),for:.touchUpInside)
        backTitleButton.layer.masksToBounds=true
        backTitleButton.setTitle("タイトルに戻る",for:.normal)
        backTitleButton.setTitleColor(UIColor.darkText,for:.normal)
        backTitleButton.backgroundColor=UIColor.red
        backTitleButton.layer.borderWidth=0.5
        backTitleButton.addTarget(self,action:#selector(self.backTitleButton(sender:)),for:.touchUpInside)
        self.view?.addSubview(restartButton)
        self.view?.addSubview(releaseButton)
        self.view?.addSubview(backTitleButton)
        restartButton.isHidden=true
        releaseButton.isHidden=true
        restartButton.isEnabled=false
        releaseButton.isEnabled=false
        backTitleButton.isHidden=true
        backTitleButton.isEnabled=false
    }
    func addBoss(){
        if bossHp <= 0{
        bossTimer?.invalidate()
        self.boss=SKSpriteNode(imageNamed:"boss")
    //    let random=CGFloat(arc4random_uniform(UINT32_MAX))/CGFloat(UINT32_MAX)
    //   let positionX=frame.width*(random-0.5)
        self.boss.position=CGPoint(x:0,y:frame.height)
        //self.enemy.scale(to:CGSize(width:90,height:75))
        self.boss.physicsBody=SKPhysicsBody(circleOfRadius:boss.frame.height/2)
        self.boss.physicsBody?.categoryBitMask=bossCategory
        self.boss.physicsBody?.contactTestBitMask=missileCategory+sparkCategory
        self.boss.physicsBody?.collisionBitMask=0
        bossHp=30
        addChild(self.boss)
      //  print("Added")
        let shoot=SKAction.run({
            self.bossTurn()
        })
        let move=SKAction.moveTo(y: frame.height/2, duration: 2)
        self.boss.run(SKAction.sequence([move,shoot]))
        }
    }
    func bossTurn(){
        if bossHp > 0{
            addAsteroid()
            addEnemy()
            let bBullet = SKSpriteNode(imageNamed:"missile")
            bBullet.position=boss.position
            bBullet.xScale=2
            bBullet.yScale=2
            bBullet.physicsBody=SKPhysicsBody(rectangleOf:CGSize(width:bBullet.frame.width, height:bBullet.frame.height ))
            bBullet.physicsBody?.categoryBitMask=enemyBulletCategory
            bBullet.physicsBody?.contactTestBitMask=spaceshipCategory
            bBullet.physicsBody?.collisionBitMask=0
            addChild(bBullet)
            let moveToButtom=SKAction.moveTo(y:-frame.height,duration:2.0)
            let remove = SKAction.removeFromParent()
            bBullet.run(SKAction.sequence([moveToButtom,remove]))
        }
    }
    func setTimer(){
        timer=Timer.scheduledTimer(withTimeInterval:0.5,repeats:true,block:{_ in self.addAsteroid()})
        bombTimer=Timer.scheduledTimer(withTimeInterval:10,repeats:true,block:{_ in self.addBomb()})
        enemyTimer=Timer.scheduledTimer(withTimeInterval:7,repeats:true,block:{_ in self.addEnemy()})
        shootTimer=Timer.scheduledTimer(withTimeInterval:3,repeats:true,block:{_ in self.shootBullet()})
        bossTimer=Timer.scheduledTimer(withTimeInterval:15,repeats:true,block:{_ in self.addBoss()})
        turnTimer=Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in self.bossTurn()})
        if system==1{
            rensya=Timer.scheduledTimer(withTimeInterval:0.2,repeats:true,block:{_ in self.shootmissile()})
        }
    }
    func removeTimer(){
        
    }
    func bossRemoved(){
       // print(1)
        bossHp=0
        let trump=SKAudioNode.init(fileNamed:"trumpet")
        stage+=1
        asteroidDuration-=0.5
        enemyDuration-=2
        enemies=0
        let label=SKLabelNode(text:"STAGE\(stage)")
        removeAllChildren()
        allEnemies.removeAll()
        let count:Int=hearts.count+1
        hearts=[]
        addChild(trump)
        for i in 1...count{
            let heart=SKSpriteNode(imageNamed:"heart")
            heart.position=CGPoint(x:-frame.width/2+50,y:frame.height/2-heart.frame.height-heart.frame.height*CGFloat(i))
            addChild(heart)
            hearts.append(heart)
        }
        bombButton.isHidden=true
        bombButton.isEnabled=false
        useWeap=false
        useBari=false
        isCalled=true
        barrierItem.removeAll()
        weaponItem.removeAll()
        addChild(self.earth)
        addChild(self.spaceship)
        addChild(scoreLabel)
        addChild(bestScoreLabel)
        label.fontName="PixelMplus12-Bold"
        label.fontSize=50
        label.position=CGPoint(x:0,y:0)
        addChild(label)
        timer?.invalidate()
        enemyTimer?.invalidate()
        bombTimer?.invalidate()
        shootTimer?.invalidate()
        bossTimer?.invalidate()
        turnTimer?.invalidate()
        isCalled=true
        rensya?.invalidate()
        self.run(SKAction.wait(forDuration:4.0)){
            trump.removeFromParent()
            label.removeFromParent()
            self.timer=Timer.scheduledTimer(withTimeInterval:0.5,repeats:true,block:{_ in self.addAsteroid()})
            self.bombTimer=Timer.scheduledTimer(withTimeInterval:10,repeats:true,block:{_ in self.addBomb()})
            self.enemyTimer=Timer.scheduledTimer(withTimeInterval:7,repeats:true,block:{_ in self.addEnemy()})
            self.shootTimer=Timer.scheduledTimer(withTimeInterval:3,repeats:true,block:{_ in self.shootBullet()})
            self.bossTimer=Timer.scheduledTimer(withTimeInterval:15,repeats:true,block:{_ in self.addBoss()})
            self.turnTimer=Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { _ in self.bossTurn()})
            self.addChild(SKAudioNode.init(fileNamed:"bgm_maoudamashii_8bit08.mp3"))
            if self.system==1{
                self.rensya=Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block:{_ in self.shootmissile()})
            }
        }
    }
}

