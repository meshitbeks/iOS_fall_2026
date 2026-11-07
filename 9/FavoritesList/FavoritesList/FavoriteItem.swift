import Foundation

/// One favorite thing in the list.
struct FavoriteItem {
    let title: String
    let subtitle: String
    let imageName: String   // image name in Assets.xcassets
    let rating: Int         // from 0 to 5
}

/// The whole list, kept in one place (not inside the cell).
enum FavoritesLibrary {
    static let items: [FavoriteItem] = [
        FavoriteItem(title: "Паста с соусом песто и тигровыми креветками", subtitle: "Еда · Моё любимое блюдо", imageName: "spaghetti", rating: 5),
        FavoriteItem(title: "Тренировки в зале", subtitle: "Спорт · 4 раза в неделю", imageName: "gym", rating: 5),
        FavoriteItem(title: "Прогулки в парке", subtitle: "Отдых · Лучше всего осенью", imageName: "park", rating: 5),
        FavoriteItem(title: "Беспроводные наушники", subtitle: "Гаджеты · Всегда с собой", imageName: "headphones", rating: 4),
        FavoriteItem(title: "MacBook Air", subtitle: "Гаджеты · Учёба и Xcode", imageName: "macbook", rating: 5),
        FavoriteItem(title: "Givenchy Irresistible", subtitle: "Парфюм · Цветочный и нежный", imageName: "perfume", rating: 5),
        FavoriteItem(title: "Красная помада MAC Ruby Woo", subtitle: "Косметика · Классический красный", imageName: "lipstick", rating: 4),
        FavoriteItem(title: "True crime на YouTube", subtitle: "Видео · Смотрю по вечерам", imageName: "truecrime", rating: 5),
        FavoriteItem(title: "Музыка в плейлисте", subtitle: "Музыка · Поп и инди", imageName: "music", rating: 5),
        FavoriteItem(title: "Айс латте", subtitle: "Напитки · Каждое утро", imageName: "coffee", rating: 4),
        FavoriteItem(title: "Суши с лососем", subtitle: "Еда · Япония", imageName: "sushi", rating: 4),
        FavoriteItem(title: "Ванильное мороженое", subtitle: "Десерт · Летом и зимой", imageName: "icecream", rating: 3),
        FavoriteItem(title: "Клубничный торт", subtitle: "Десерт · На праздники", imageName: "cake", rating: 4),
        FavoriteItem(title: "Масляный круассан", subtitle: "Выпечка · К кофе", imageName: "croissant", rating: 4),
        FavoriteItem(title: "Рамен", subtitle: "Еда · Острый бульон", imageName: "ramen", rating: 4),
        FavoriteItem(title: "Пицца Маргарита", subtitle: "Еда · Италия", imageName: "pizza", rating: 3),
        FavoriteItem(title: "Дата-аналитика и SQL", subtitle: "Учёба · Хочу развиваться", imageName: "analytics", rating: 5),
        FavoriteItem(title: "iOS-разработка", subtitle: "Учёба · Swift и UIKit", imageName: "ios", rating: 4),
        FavoriteItem(title: "Путешествия", subtitle: "Отдых · Новые города", imageName: "travel", rating: 5),
        FavoriteItem(title: "Сериалы по выходным", subtitle: "Отдых · С пледом и чаем", imageName: "series", rating: 3),
        FavoriteItem(title: "Ранние подъёмы", subtitle: "Привычки · Пока даётся тяжело", imageName: "alarm", rating: 1)
    ]
}
