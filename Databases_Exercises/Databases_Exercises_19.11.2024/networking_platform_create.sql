CREATE DATABASE networking_platform;

USE networking_platform;

CREATE TABLE Users (
	user_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    user_name VARCHAR(100) NOT NULL,
    user_email VARCHAR(50) UNIQUE NOT NULL,
    date_of_birth DATE NOT NULL,
    date_of_creation DATETIME NOT NULL
);

CREATE TABLE Friendships (
	friendship_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    from_user_id INT NOT NULL,
    FOREIGN KEY (from_user_id) REFERENCES Users(user_id),
    to_user_id INT NOT NULL,
    FOREIGN KEY (to_user_id) REFERENCES Users(user_id),
    status VARCHAR(20),
	date_of_creation DATETIME NOT NULL
);

CREATE TABLE Comments (
	comment_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    comment_content VARCHAR(200),
	date_of_creation DATETIME NOT NULL
);

CREATE TABLE Posts (
	post_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    post_content VARCHAR(300),
	date_of_creation DATETIME NOT NULL
);

CREATE TABLE Likes (
	like_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
	comment_id INT NOT NULL,
    FOREIGN KEY (comment_id) REFERENCES Comments(comment_id),
	post_id INT NOT NULL,
    FOREIGN KEY (post_id) REFERENCES Posts(post_id),
	date_of_creation DATETIME NOT NULL
);
