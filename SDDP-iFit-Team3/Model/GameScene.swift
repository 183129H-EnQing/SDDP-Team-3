//
//  GameScene.swift
//  SDDP-iFit-Team3
//
//  Created by 182452K  on 7/2/20.
//  Copyright © 2020 SDDP_Team3. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var playerFitness = 10
    var playerPlanets = 10
    var playerTroops = 10
    var playerScore = 10
    
    var score = 0
    let scoreLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    var level = 0
    
    var playerLives = 3
    var playerLivesLabel = SKLabelNode(fontNamed: "The Bold Font")
    
    let player = SKSpriteNode(imageNamed: "survivor_handgun")
    
    let bulletSound = SKAction.playSoundFileNamed("bulletSound_3", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("bomb_07", waitForCompletion: false)
    
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
        
        let closeButton = SKSpriteNode(imageNamed: "yellowbutton")
        closeButton.name = "homeButton"
        closeButton.size = CGSize(width: 80, height: 80)
        closeButton.position = CGPoint(x: self.size.width * 0.25, y: self.size.height * 0.82)
        closeButton.zPosition = 2
        self.addChild(closeButton)
        
        
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
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width * 0.2, y: self.size.height * 0.85)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        playerLivesLabel.text = "Lives: 3"
        playerLivesLabel.fontSize = 70
        playerLivesLabel.fontColor = SKColor.white
        playerLivesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        playerLivesLabel.position = CGPoint(x: self.size.width * 0.8, y: self.size.height * 0.85)
        playerLivesLabel.zPosition = 100
        self.addChild(playerLivesLabel)
        
        startNewLevel()
    }
    
    func addScore() {
        score += 1
        scoreLabel.text = "Score: \(score)"
        
        if score == 10 || score == 25 || score == 50 || score == 100 {
            startNewLevel()
        }
    }
    
    func loseLife() {
        
        if playerLives >= 1 {
            playerLives -= 1
            playerLivesLabel.text = "Lives: \(playerLives)"
            
            
            let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
            let scaleDown = SKAction.scale(to: 1, duration: 0.2)
            let dangerColor = SKAction.colorize(with: UIColor.red, colorBlendFactor: 0.8, duration: 0.2)
            let scaleSequence = SKAction.sequence([scaleUp, dangerColor, scaleDown])
            playerLivesLabel.run(scaleSequence)
        }
        else {
            
            let alertController = UIAlertController(title: "Score: \(score)", message: "You failed to protect the convoy.Abort ship! Head into the escape pod", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Restart", style: .default, handler: { (action: UIAlertAction!) in
                print("Restart")
                
                let sceneChange = GameHome(size: self.size)
                sceneChange.scaleMode = self.scaleMode
                sceneChange.playerFitness = self.playerFitness
                sceneChange.playerPlanets = self.playerPlanets
                sceneChange.playerTroops = self.playerTroops
                sceneChange.playerScore = self.playerScore
                let transition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneChange, transition: transition)
                
                let sceneChange1 = GameScene(size: self.size)
                sceneChange1.scaleMode = self.scaleMode
                sceneChange1.playerFitness = self.playerFitness
                sceneChange1.playerPlanets = self.playerPlanets
                sceneChange1.playerTroops = self.playerTroops
                sceneChange1.playerScore = self.playerScore
                let transition1 = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneChange1, transition: transition1)
            }))
            alertController.addAction(UIAlertAction(title: "Return Home", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Return Home")
                
                let sceneChange = GameHome(size: self.size)
                sceneChange.scaleMode = self.scaleMode
                sceneChange.playerFitness = self.playerFitness
                sceneChange.playerPlanets = self.playerPlanets
                sceneChange.playerTroops = self.playerTroops
                sceneChange.playerScore = self.playerScore
                let transition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneChange, transition: transition)
            }))
            self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
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
        
        if body1.categoryBitMask == BulletCategory && body2.categoryBitMask == EnemyCategory && (body2.node?.position.y)! < self.size.height * 0.9 {
            
            createExplosion(spawnPosition: body2.node!.position)
            addScore()
            
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
        
        let scaleIn = SKAction.scale(to: 2, duration: 0.1)
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
        
        let moveEnemy = SKAction.move(to: endPoint, duration: 2.0)
        let deleteEnemy = SKAction.removeFromParent()
        let minusLife = SKAction.run(loseLife)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, minusLife])
        enemy.run(enemySequence)
        
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx)
        enemy.zRotation = amountToRotate
    }
    
    func startNewLevel(){
        
        level += 1
        
        
        if self.action(forKey: "spawningEnemies") != nil {      //if still spawning enemies
            self.removeAction(forKey: "spawningEnemies")        //stop action: spawn enemies
        }
        
        var spawnTime = NSTimeIntervalSince1970       //SKAction.wait(forDuration: ) requires NSTimeInterval
        
        switch level{
        case 1: spawnTime = 1.5
        case 2: spawnTime = 1.2
        case 3: spawnTime = 1
        case 4: spawnTime = 0.8
        default:
            spawnTime = 0.5
        }
        
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: spawnTime)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        fireBullet()
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
            

            for nodeTapped in nodes(at: pointOfTouch) {
                
                let transition = SKTransition.fade(withDuration: 0.5)
                
                if nodeTapped.name == "homeButton"{
                    let sceneChange = GameHome(size: self.size)
                    sceneChange.scaleMode = self.scaleMode
                    sceneChange.playerFitness = playerFitness
                    sceneChange.playerPlanets = playerPlanets
                    sceneChange.playerTroops = playerTroops
                    sceneChange.playerScore = playerScore
                    self.view!.presentScene(sceneChange, transition: transition)
                }
            }
        }
    }
    
    
}

