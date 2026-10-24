import Playgrounds

#Playground {
    
    let firstName: String = "Sagynysh"
    print(firstName)
    let lastName: String = "Meshitbek"
    let birthYear: Int = 2005
    let currentYear: Int = 2026
    let age: Int = currentYear - birthYear
    let isStudent: Bool = true
    let height: Double = 1.64
    
    let my_favourite_hobby: String = "Scrolling"
    let numberOfHobbies: Int = 3
    let favNumber = 17
    let isMyHobbyCreative: Bool = false
    
    let lifeStory = """
        My name is \(firstName) \(lastName). I was born in \(birthYear) and I am \(age) this year, which is \(currentYear). 
        
        I am \(isStudent ? "student" : "not a student" ). 
        
        
        My height in is \(height) metres. I have \(numberOfHobbies) and my favourite one is \(my_favourite_hobby). Also my favourite number is \(favNumber). 
        """
    
    let futurePlans = "I plan to be happy, healthy and rich"
    let fullStory = lifeStory + futurePlans
    print(fullStory)
    
    

}

