# Lab 9 · Favorites List

A UIKit app that shows 21 of my favorite things (food, sport, gadgets, beauty and hobbies) in a `UITableView` with a custom cell: image, title, subtitle and a 5-star rating drawn with SF Symbols (`star.fill` / `star`).

## Structure

- `FavoriteItem` — struct with `title`, `subtitle`, `imageName`, `rating` (0–5)
- `FavoritesLibrary` — the array of items, kept in one place
- `FavoriteCell` — `UITableViewCell` subclass with outlets and `configure(with:)`; no layout code
- `ViewController` — `UITableViewDataSource`, one row per item, cells created with `dequeueReusableCell(withIdentifier:for:)`

## Layout (Main.storyboard only)

- The table view fills the Safe Area
- Prototype cell, class `FavoriteCell`, reuse identifier `FavoriteCell`
- Outer horizontal stack: image (64 × 64) + vertical text stack (title, subtitle, rating row)
- Constraints only on the image size and on the outer stack (pinned to the content view margins), so the row height follows the content
- Long title test: "Паста с соусом песто и тигровыми креветками" wraps to two lines without overlapping the image
- Colors are system colors (`labelColor`, `systemBackgroundColor`), so the list works in Dark Mode

## Screenshots

| iPhone SE (3rd generation) |
|---|
| <img src="screenshots/iphonese.png" width="300"> |

