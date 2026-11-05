import Foundation

/// One favorite food in the list.
struct FavoriteItem {
    let title: String
    let subtitle: String
    let imageName: String   // image name in Assets.xcassets
    let rating: Int         // from 0 to 5
}

/// The whole list, kept in one place (not inside the cell).
enum FavoritesLibrary {
    static let items: [FavoriteItem] = [
        FavoriteItem(title: "Pizza Margherita", subtitle: "Italy · Tomato, mozzarella, basil", imageName: "pizza", rating: 5),
        FavoriteItem(title: "Salmon Sushi", subtitle: "Japan · Rice and fresh fish", imageName: "sushi", rating: 5),
        FavoriteItem(title: "Classic Cheeseburger", subtitle: "USA · Beef, cheese, pickles", imageName: "burger", rating: 4),
        FavoriteItem(title: "Tonkotsu Ramen", subtitle: "Japan · Noodles in pork broth", imageName: "ramen", rating: 5),
        FavoriteItem(title: "Tacos al Pastor", subtitle: "Mexico · Pork, pineapple, salsa", imageName: "tacos", rating: 4),
        FavoriteItem(title: "Butter Croissant", subtitle: "France · Flaky breakfast pastry", imageName: "croissant", rating: 4),
        FavoriteItem(title: "Pancakes with Maple Syrup", subtitle: "Canada · Sweet breakfast stack", imageName: "pancakes", rating: 3),
        FavoriteItem(title: "Steamed Dumplings", subtitle: "China · Pork and ginger filling", imageName: "dumplings", rating: 5),
        FavoriteItem(title: "Vanilla Soft Serve", subtitle: "Dessert · Cold and creamy", imageName: "icecream", rating: 3),
        FavoriteItem(title: "Chocolate Donut", subtitle: "Dessert · Glazed and sprinkled", imageName: "donut", rating: 2),
        FavoriteItem(title: "Strawberry Shortcake", subtitle: "Dessert · Sponge, cream, berries", imageName: "cake", rating: 4),
        FavoriteItem(title: "Greek Salad", subtitle: "Greece · Feta, olives, cucumber", imageName: "salad", rating: 3),
        FavoriteItem(title: "Spaghetti Carbonara", subtitle: "Italy · Egg, cheese, pancetta", imageName: "spaghetti", rating: 5),
        FavoriteItem(title: "Chicken Tikka Masala with Garlic Naan and Basmati Rice", subtitle: "India · Spicy tomato cream sauce", imageName: "curry", rating: 4),
        FavoriteItem(title: "Hot Dog", subtitle: "USA · Sausage in a soft bun", imageName: "hotdog", rating: 2),
        FavoriteItem(title: "Bean Burrito", subtitle: "Mexico · Wrapped with rice and beans", imageName: "burrito", rating: 3),
        FavoriteItem(title: "Belgian Waffle", subtitle: "Belgium · Crispy with powdered sugar", imageName: "waffle", rating: 4),
        FavoriteItem(title: "Seafood Paella", subtitle: "Spain · Saffron rice with shrimp", imageName: "paella", rating: 4),
        FavoriteItem(title: "Falafel Plate", subtitle: "Middle East · Chickpea balls and hummus", imageName: "falafel", rating: 3),
        FavoriteItem(title: "Chocolate Chip Cookie", subtitle: "Dessert · Soft and chewy", imageName: "cookie", rating: 1),
        FavoriteItem(title: "Steamed Broccoli", subtitle: "Side · Healthy but boring", imageName: "broccoli", rating: 0)
    ]
}
