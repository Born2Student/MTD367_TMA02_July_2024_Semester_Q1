import UIKit

class GameMenuViewController: UIViewController {
    
    @IBOutlet weak var Text_Label: UILabel!
    
    @IBOutlet weak var Fruit_Img: UIImageView!
    
    @IBOutlet weak var StartGame: UIButton!
    
    @IBOutlet weak var fruit_drop_speed_slider: UISlider!
    
    @IBOutlet weak var slider_Label: UILabel!
    
    @IBOutlet weak var fruit_count_Slider: UISlider!
    
    @IBOutlet weak var fruit_count_Label: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        fruit_drop_speed_slider.value = 0
        
        slider_Label.text = String(Int(fruit_drop_speed_slider.value))
        
        fruit_count_Slider.value = 0
        
        fruit_count_Label.text = String(Int(fruit_count_Slider.value))
    }
    
    @IBAction func btnTapped(_ sender: Any)
    {
        // MARK - Using Story board
        let storyboard = self.storyboard?.instantiateViewController(withIdentifier: "GameMainViewController") as! GameMainViewController
        
        // Pass the slider value to GameMainViewController
        storyboard.fruit_drop_Speed = Int(fruit_drop_speed_slider.value)
        
        /*
         Pass the fruit count slider value to GameMainViewController
         Add 1 because slider starts at 0
        */
        storyboard.fruit_Count = Int(fruit_count_Slider.value) + 1

        self.navigationController?.pushViewController(storyboard, animated: true)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider)
    {
        slider_Label.text = String(Int(fruit_drop_speed_slider.value))
    }
    
    @IBAction func fruit_count_SliderValueChanged(_ sender: UISlider)
    {
        fruit_count_Label.text = String(Int(fruit_count_Slider.value))
    }
}
