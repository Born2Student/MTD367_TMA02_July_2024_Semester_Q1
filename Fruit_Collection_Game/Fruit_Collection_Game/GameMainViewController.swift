import UIKit

class GameMainViewController: UIViewController {

    // IBOutlets for UI elements
    @IBOutlet weak var startBtn: UIButton!
    
    @IBOutlet weak var fruit_Img: UIImageView!
    
    @IBOutlet weak var container_Img: UIImageView!
    
    @IBOutlet weak var fruits_Collected_Count: UILabel!
    
    @IBOutlet weak var fruits_Lost_Count: UILabel!
    
    @IBOutlet weak var pause_resume_Btn: UIButton!
    
    @IBOutlet weak var restart_btn: UIButton!
    
    @IBOutlet weak var points_Count: UILabel!
    
    @IBOutlet weak var fruit_2: UIImageView!
    
    @IBOutlet weak var fruit_3: UIImageView!
    
    @IBOutlet weak var fruit_4: UIImageView!
    
    // Game variables
    
    // Random X position for the Fruits
    var fruit_random_X = 0
    
    // Y position for the Fruits
    var fruit_position_Y = 0
    
    // X position controlled by touch movement
    var fruit_position_X = 0
    
    // Number of times the player has collected the fruits
    var fruits_Collected_Num = 0
    
    // X position for the Container
    var container_position_X = 0

    // Number of times the player has lost the fruits (i.e., fruits fell off-screen)
    var fruits_Lost_Num = 0
    
    // Default Fruit Drop Speed
    var fruit_drop_Speed: Int = 1
    
    // Default fruit count
    var fruit_Count: Int = 1
    
    var points_Scored = 0
    
    var is_game_Paused = false
    
    // Add the flag
    var is_fruit_Reset = false
    
    var fruit_catching_GameTimer: Timer?
    
    // To store the type of the currently falling fruit
    var current_fruit_Type: UIImage?
    
    let fruits: [UIImage] = [
        UIImage(named: "Apple")!,
        UIImage(named: "Pear")!,
        UIImage(named: "Mango")!,
        UIImage(named: "Strawberry")!
    ]
    
    // Dictionary to map fruit types to point values
    let fruit_Points: [UIImage: Int] = [
        UIImage(named: "Apple")!: 1,
        UIImage(named: "Pear")!: 2,
        UIImage(named: "Mango")!: 3,
        UIImage(named: "Strawberry")!: 4
    ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        /*
         Initial UI setup
         
         Show start button
        */
        startBtn.isHidden = false
            
        // Hide Container
        container_Img.isHidden = true
        
        fruit_Img.isHidden = true
        
        // Hide fruits collected count label
        fruits_Collected_Count.isHidden = true
        
        // Hide fruits lost count label
        fruits_Lost_Count.isHidden = true
        
        // Hide pause and resume button initially
        pause_resume_Btn.isHidden = true
        
        // Hide restart button initially
        restart_btn.isHidden = true
        
        points_Count.isHidden = true
        
        fruit_2.isHidden = true
        
        fruit_3.isHidden = true
        
        fruit_4.isHidden = true
        
        // Initial position for the Fruit
        fruit_Img.frame = CGRect(
            x: 100,
            y: 0,
            width: 100,
            height: 100
        )
        
        // Initialize lost fruit count
        fruits_Lost_Num = 0
        
        // Initialize points and update the label
        points_Scored = 0
        
        points_Count.text = "Points Scored: 0"
        
        // Add double-tap gesture recognizers to the Restart Button
        let restart_button_DoubleTap = UITapGestureRecognizer(
            target: self,
            action: #selector(restart_game_DoubleTap)
        )
        
        restart_button_DoubleTap.numberOfTapsRequired = 2
        
        // We added the recognizer to the restart_btn.
        restart_btn.addGestureRecognizer(restart_button_DoubleTap)
        
        // Add left and right swipe gesture recognizers to pause_resume_Btn
        let pause_button_Swipe = UISwipeGestureRecognizer(
            target: self,
            action: #selector(pause_Game)
        )
            
        pause_button_Swipe.direction = .left
        
        pause_resume_Btn.addGestureRecognizer(pause_button_Swipe)

        let resume_button_Swipe = UISwipeGestureRecognizer(
            target: self,
            action: #selector(resume_Game)
        )
        
        resume_button_Swipe.direction = .right
        
        pause_resume_Btn.addGestureRecognizer(resume_button_Swipe)
    }

    @IBAction func game_start(_ sender: UIButton)
    {
        // Start game actions
        
        // Hide start button
        sender.isHidden = true
        
        // Show container
        container_Img.isHidden = false
        
        fruit_Img.isHidden = false
        
        points_Count.isHidden = false
        
        // Show fruit collected and lost count labels
        fruits_Collected_Count.isHidden = false
        
        fruits_Lost_Count.isHidden = false
        
        pause_resume_Btn.isHidden = false
        
        // Show restart button when the game starts
        restart_btn.isHidden = false
        
        // Random X position for the Fruit
        fruit_random_X = Int.random(in: 10...300)
        
        // Set initial position for the Fruit
        self.fruit_Img.frame = CGRect(
            x: fruit_random_X,
            y: self.fruit_position_Y,
            width: 40,
            height: 40
        )
        
        fruit_Img.image = fruits[Int.random(in: 0...3)]
        
        // Set the initial fruit type
        current_fruit_Type = fruits[Int.random(in: 0..<fruits.count)]
        
        fruit_Img.image = current_fruit_Type
        
        // Random X position for the Container
        container_position_X = Int.random(in: 10...300)
        
        // Set position and size for the Container
        self.container_Img.frame = CGRect(
            x: container_position_X,
            y: 300,
            width: 150,
            height: 80
        )
        
        // Calculate timeInterval based on fruitDropSpeed
        // Adjust the formula as needed
        let fruitDropSpeed_timeInterval = 0.1 / Double(fruit_drop_Speed)
        
        // Start timer to control Fruit dropping
        fruit_catching_GameTimer = Timer.scheduledTimer(
            timeInterval: fruitDropSpeed_timeInterval,
            target: self,
            selector: #selector(fruit_Drop),
            userInfo: nil,
            repeats: true
        )
    }
    
    func fruit_Hit()
    {
        // Check if the Fruit hits the Container
        if abs(self.fruit_position_Y - 250) < 20 && abs(self.fruit_random_X + 20 - self.container_position_X - Int(self.container_Img.frame.width/2.0)) < 50
        {
            // Reset the game if the Fruit hits the Container
            self.reset_Game()
        }
        
    }
    

    @objc func fruit_Drop() {
        // If the game is paused, do nothing
        if is_game_Paused {
            // If isGamePaused is true, the function immediately returns, preventing any further execution and effectively stopping the fruit's movement.
            return
        }

        // Control Fruit dropping and collision detection
        fruit_Hit()

        // Move Fruit downwards
        self.fruit_position_Y = self.fruit_position_Y + 10

        // Update Fruit's X position ONLY based on touch movement if it hasn't been reset yet
        if self.fruit_position_Y > 0 {
            is_fruit_Reset = false
        }

        // Constrain Fruit's X position within screen bounds
        if fruit_random_X > 300
        {
            fruit_random_X = 300
        }
        else if fruit_random_X < 0
        {
            fruit_random_X = 0
        }

        self.fruit_Img.frame = CGRect(
            x: fruit_random_X,
            y: self.fruit_position_Y,
            width: 100,
            height: 100
        )

        // Reset Fruit's Y position if it goes off-screen
        if self.fruit_position_Y >= 500
        {
            self.fruit_position_Y = 0
            
            // Randomize fruit's X position when it's lost
            fruit_random_X = Int.random(in: 10...300)

            self.fruit_Img.frame = CGRect(
                x: fruit_random_X,
                y: self.fruit_position_Y,   // Reset Y position
                width: 100,
                height: 100
            )

            // Increment lost fruit count
            fruits_Lost_Num = fruits_Lost_Num + 1

            // Update fruit lost count label text HERE
            fruits_Lost_Count.text = "Fruits Lost: " + String(fruits_Lost_Num)

            print("Fruits Lost: ", fruits_Lost_Num)

            // Randomize container position when fruit is lost
            container_position_X = Int.random(in: 10...300)

            self.container_Img.frame = CGRect(
                x: container_position_X,
                y: 300,
                width: 150,
                height: 80
            )

            // Reset the isFruitReset flag
            is_fruit_Reset = false
            
            // Decrement points based on the fruit type
            if let pointsForFruit = fruit_Points[current_fruit_Type!]
            {
                // Ensure points don't go below 0
                points_Scored = max(0, points_Scored - pointsForFruit)
            }
            else
            {
                // Handle the case where the fruit type is not found in the dictionary (optional)
                print("Error: Fruit type not found in point dictionary")
            }
            
            points_Count.text = "Points Scored: \(points_Scored)"
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Only move the container if the game is not paused
        if !is_game_Paused
        {
            // Handle touch movement to control Container's X position
            let touch1 = touches.first!
            
            container_position_X = Int(touch1.location(in: self.view).x)

            // Constrain Container's X position within screen bounds (considering its width)
            let maxX = Int(self.view.frame.width - self.container_Img.frame.width)
            
            container_position_X = max(0, min(maxX, container_position_X))

            // Update Container's position
            self.container_Img.frame.origin.x = CGFloat(container_position_X)
        }
    }
    
    func reset_Game()
    {
        // Reset game after a Fruit is lost
        
        // Randomize fruit's X position when it's caught
        fruit_random_X = Int.random(in: 10...300)
        
        self.fruit_Img.frame = CGRect(
            x: fruit_random_X,
            y: 0,
            width: 100,
            height: 100
        )
        
        // Set the flag after randomizing the X position
        is_fruit_Reset = true
        
        // New random X position for the Container
        container_position_X = Int.random(in: 10...300)
        
        // Update Container's position
        self.container_Img.frame = CGRect(
            x: container_position_X,
            y: 300,
            width: 150,
            height: 80
        )
        
        // Increment number of fruits collected
        fruits_Collected_Num = fruits_Collected_Num + 1
        
        // Reset Fruit's Y position
        self.fruit_position_Y = 0
        
        fruit_Img.image = fruits[Int.random(in: 0...3)]
        
        // Update fruit collected count label text
        fruits_Collected_Count.text = "Fruits Collected: " + String(fruits_Collected_Num)
        
        print("Fruits Collected: ", fruits_Collected_Num)
        
        // Increment points based on the fruit type
        if let points_ForEachFruit = fruit_Points[current_fruit_Type!]
        {
            points_Scored = points_Scored + points_ForEachFruit
        }
        else
        {
            // Handle the case where the fruit type is not found in the dictionary (optional)
            print("Error: Fruit type not found in points dictionary")
        }
            
        points_Count.text = "Points Scored: \(points_Scored)"
        
        /*
         Get a random fruit type
         Update currentFruitType FIRST
        */
        current_fruit_Type = fruits[Int.random(in: 0..<fruits.count)]

        // THEN set the image
        fruit_Img.image = current_fruit_Type
    }
    
    // We created pauseGame and resumeGame functions to handle the swipe actions.
    @objc func pause_Game(_ sender: UISwipeGestureRecognizer)
    {
        is_game_Paused = true
        fruit_catching_GameTimer?.invalidate()
        fruit_catching_GameTimer = nil
        pause_resume_Btn.setTitle("Resume Game", for: .normal)
    }

    @objc func resume_Game(_ sender: UISwipeGestureRecognizer)
    {
        is_game_Paused = false
        
        if fruit_catching_GameTimer == nil
        {
            fruit_catching_GameTimer = Timer.scheduledTimer(
                timeInterval: 0.1,
                target: self,
                selector: #selector(fruit_Drop),
                userInfo: nil,
                repeats: true)
        }
        
        pause_resume_Btn.setTitle("Pause Game", for: .normal)
    }

    // We created restart_Game_double_tap function to handle the double-tap actions.
    @objc func restart_game_DoubleTap(_ sender: UITapGestureRecognizer)
    {
        // Reset counters
        fruits_Collected_Num = 0
        
        fruits_Lost_Num = 0
        
        // Reset points and update the label
        points_Scored = 0
        
        // Update labels
        fruits_Collected_Count.text = "Fruits Collected: 0"
        
        fruits_Lost_Count.text = "Fruits Lost: 0"
        
        points_Count.text = "Points Scored: 0"
        
        // Reset fruit position
        fruit_Img.frame = CGRect(
            x: 100,
            y: 0,
            width: 100,
            height: 100
        )
        
        // Reset container position
        container_position_X = Int.random(in: 10...300)
        
        self.container_Img.frame = CGRect(
            x: container_position_X,
            y: 300,
            width: 150,
            height: 80
        )
        
        // If the game was paused, resume it
        if is_game_Paused
        {
            is_game_Paused = false
            
            fruit_catching_GameTimer?.invalidate()
            
            fruit_catching_GameTimer = nil
            
            fruit_catching_GameTimer = Timer.scheduledTimer(
                timeInterval: 0.1,
                target: self,
                selector: #selector(fruit_Drop),
                userInfo: nil,
                repeats: true
            )
            
            pause_resume_Btn.setTitle(
                "Pause Game",
                for: .normal
            )
        }
    }
}

