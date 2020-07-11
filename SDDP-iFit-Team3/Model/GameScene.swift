//
//  GameScene.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 7/2/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "survivor_handgun")
    
    let bulletSound = SKAction.playSoundFileNamed("bulletSound_3", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed(<#T##soundFile: String##String#>, waitForCompletion: false)
    
    var gameArea: CGRect
    
    //UInt32 required by .physicsBody!.categoryBitMask
    let NoneCategory: UInt32 = 0
    let PlayerCategory: UInt32 = UInt32(1)   //1 0b1
    let BulletCategory: UInt32 = UInt32(2) //2 0b10
    let EnemyCategory: UInt32 = UInt32(4) // 4 0b100
    
    
    override init(size: CGSize) {
        
        let maxAspectRatio: CGFloat = 16.0 / 9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed: "road")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        
        player.setScale(1)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)    //set physics to player - gravity, contacts
        player.physicsBody!.affectedByGravity = false   //remove gravity from player
        player.physicsBody!.categoryBitMask = PlayerCategory
        player.physicsBody!.collisionBitMask = NoneCategory //Collision will occur when Players hits Nones
        player.physicsBody!.contactTestBitMask = EnemyCategory  //Contact will be detected when Player make a contact with Enemy
        self.addChild(player)
        
        startNewLevel()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        //logic to assign lower value to A, higher to B
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body1 = contact.bodyB
        }
        else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PlayerCategory && body2.categoryBitMask == EnemyCategory {
            
            createExplosion(spawnPosition: body1.node!.position)
            createExplosion(spawnPosition: body2.node!.position)
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
        
        if body1.categoryBitMask == BulletCategory && body2.categoryBitMask == EnemyCategory && (body2.node?.position.y)! < self.size.height {
            
            createExplosion(spawnPosition: body2.node!.position)
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
        }
        
//        let playerMask = contact.bodyA.categoryBitMask == PlayerCategory || contact.bodyB.categoryBitMask == PlayerCategory
//        let enemyMask = contact.bodyA.categoryBitMask == EnemyCategory || contact.bodyB.categoryBitMask == EnemyCategory
//        let bulletMask = contact.bodyA.categoryBitMask == BulletCategory || contact.bodyB.categoryBitMask == BulletCategory
//
//        if playerMask && enemyMask {
//            print("score")
//        }
    }
    
    func createExplosion(spawnPosition: CGPoint){
        
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([explosionSound, scaleIn, fadeOut, delete])
        
        explosion.run(explosionSequence)
    }
    
    func fireBullet(){
        
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.setScale(1)
        bullet.position = player.position 
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = BulletCategory
        bullet.physicsBody!.collisionBitMask = NoneCategory
        bullet.physicsBody!.contactTestBitMask = EnemyCategory
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        bullet.run(bulletSequence)
    }
    
    //part 2
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF) // -1 in UInt32
    }
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func spawnEnemy() {
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2) //spawn above screen
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2) //dies below screen
        
        let enemy = SKSpriteNode(imageNamed: "survivor_handgun")
        enemy.setScale(1)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = EnemyCategory
        enemy.physicsBody!.collisionBitMask = NoneCategory
        enemy.physicsBody!.contactTestBitMask = PlayerCategory | BulletCategory
        
        self.addChild(enemy)
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy])
        enemy.run(enemySequence)
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx)
        enemy.zRotation = amountToRotate
    }
    
    func startNewLevel(){
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: 1)
        let spawnSequence = SKAction.sequence([spawn, waitToSpawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        fireBullet()
        spawnEnemy()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?){
        for touch: AnyObject in touches {
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            player.position.x += amountDragged
            
            if player.position.x > gameArea.maxX - player.size.width / 2 {
                player.position.x = gameArea.maxX - player.size.width / 2
            }
            if player.position.x < gameArea.minX + player.size.width / 2 {
                player.position.x = gameArea.minX + player.size.width / 2
            }
        }
    }
    
    
}

