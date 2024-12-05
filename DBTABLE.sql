CREATE DATABASE `basicdb`
CHARACTER SET utf8mb4
COLLATE utf8mb4_0900_ai_ci; -- db생성

use basicdb;
drop table posts;

select * 
from users; 

select * 
from chatrooms;

select * 
from chat_users;


CREATE TABLE `posts` (
   `title` varchar(255) NOT NULL,
   `content` text NOT NULL,
   `author` varchar(100) NOT NULL,
   `category` varchar(50) DEFAULT NULL,
   `views` int DEFAULT '0',
   `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
   `post_id` int NOT NULL AUTO_INCREMENT,
   `user_id` int NOT NULL,
   PRIMARY KEY (`post_id`),
   FULLTEXT KEY `title` (`title`),
   FULLTEXT KEY `content` (`content`),
   FULLTEXT KEY `title_2` (`title`)
 ) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `users` (
   `user_id` int NOT NULL AUTO_INCREMENT,
   `username` varchar(255) NOT NULL,
   `password` varchar(255) NOT NULL,
   `forename` varchar(255) DEFAULT NULL,
   `email` varchar(255) NOT NULL,
   `phone` varchar(20) NOT NULL,
   `role_id` int NOT NULL,
   `status` enum('active','inactive','banned') DEFAULT 'active',
   `profile_image` varchar(255) DEFAULT NULL,
   `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
   `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`user_id`),
   UNIQUE KEY `username` (`username`),
   UNIQUE KEY `email` (`email`),
   KEY `role_id` (`role_id`),
   CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`)
 ) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `user_stats` (
   `user_id` int NOT NULL,
   `solved_problems` int DEFAULT '0',
   `total_submissions` int DEFAULT '0',
   `successful_submissions` int DEFAULT '0',
   `last_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`user_id`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `solving_times` (
   `id` int NOT NULL AUTO_INCREMENT,
   `problem_id` int NOT NULL,
   `difficulty_id` int NOT NULL,
   `average_time` int DEFAULT NULL,
   `median_time` int DEFAULT NULL,
   `total_attempts` int DEFAULT '0',
   `last_updated` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`id`),
   KEY `problem_id` (`problem_id`),
   KEY `difficulty_id` (`difficulty_id`),
   CONSTRAINT `solving_times_ibfk_1` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`id`),
   CONSTRAINT `solving_times_ibfk_2` FOREIGN KEY (`difficulty_id`) REFERENCES `difficulties` (`id`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `sessions` (
   `session_id` varchar(255) NOT NULL,
   `user_id` int NOT NULL,
   `token` varchar(255) NOT NULL,
   `ip_address` varchar(45) DEFAULT NULL,
   `user_agent` text,
   `is_valid` tinyint(1) DEFAULT '1',
   `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
   `expires_at` timestamp NOT NULL,
   `last_activity` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
   `forename` varchar(255) DEFAULT NULL,
   PRIMARY KEY (`session_id`),
   KEY `sessions_ibfk_1` (`user_id`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `roles` (
   `id` int NOT NULL AUTO_INCREMENT,
   `name` varchar(50) NOT NULL,
   `description` text,
   `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (`id`),
   UNIQUE KEY `name` (`name`)
 ) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `problems` (
   `id` int NOT NULL AUTO_INCREMENT,
   `title` varchar(255) NOT NULL,
   `description` text NOT NULL,
   `difficulty_id` int NOT NULL,
   `created_by_user_id` int NOT NULL,
   `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
   `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`id`),
   KEY `difficulty_id` (`difficulty_id`),
   KEY `problems_ibfk_2` (`created_by_user_id`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `problem_categories` (
   `problem_id` int NOT NULL,
   `category_id` int NOT NULL,
   PRIMARY KEY (`problem_id`,`category_id`),
   KEY `category_id` (`category_id`),
   CONSTRAINT `problem_categories_ibfk_1` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`id`),
   CONSTRAINT `problem_categories_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `problem_algorithm_types` (
   `problem_id` int NOT NULL,
   `algorithm_type_id` int NOT NULL,
   PRIMARY KEY (`problem_id`,`algorithm_type_id`),
   KEY `algorithm_type_id` (`algorithm_type_id`),
   CONSTRAINT `problem_algorithm_types_ibfk_1` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`id`),
   CONSTRAINT `problem_algorithm_types_ibfk_2` FOREIGN KEY (`algorithm_type_id`) REFERENCES `algorithm_types` (`id`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `notifications` (
   `id` int NOT NULL AUTO_INCREMENT,
   `user_id` int NOT NULL,
   `title` varchar(255) NOT NULL,
   `content` text NOT NULL,
   `type` enum('system','achievement','reminder','feedback') NOT NULL,
   `is_read` tinyint(1) DEFAULT '0',
   `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (`id`),
   KEY `notifications_ibfk_1` (`user_id`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `messages` (
   `message_id` int NOT NULL AUTO_INCREMENT,
   `chatroom_id` int NOT NULL,
   `sender_id` int DEFAULT NULL,
   `content` text NOT NULL,
   `message_type` enum('text','image','file') DEFAULT 'text',
   `sent_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
   `is_read` tinyint(1) DEFAULT '0',
   PRIMARY KEY (`message_id`),
   KEY `chatroom_id` (`chatroom_id`),
   KEY `sender_id` (`sender_id`),
   CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`chatroom_id`) REFERENCES `chatrooms` (`chatroom_id`) ON DELETE CASCADE,
   CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`sender_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
 ) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `login_history` (
   `login_id` int NOT NULL AUTO_INCREMENT,
   `user_id` int NOT NULL,
   `session_id` varchar(255) DEFAULT NULL,
   `login_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
   `logout_time` timestamp NULL DEFAULT NULL,
   `ip_address` varchar(45) DEFAULT NULL,
   `login_status` enum('success','fail') NOT NULL,
   `fail_reason` varchar(255) DEFAULT NULL,
   PRIMARY KEY (`login_id`),
   KEY `session_id` (`session_id`),
   KEY `login_history_ibfk_1` (`user_id`)
 ) ENGINE=InnoDB AUTO_INCREMENT=115 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `learning_progress` (
   `id` int NOT NULL AUTO_INCREMENT,
   `user_id` int NOT NULL,
   `problem_id` int NOT NULL,
   `status` enum('not_started','in_progress','completed','skipped') DEFAULT 'not_started',
   `started_at` timestamp NULL DEFAULT NULL,
   `completed_at` timestamp NULL DEFAULT NULL,
   PRIMARY KEY (`id`),
   UNIQUE KEY `unique_user_problem` (`user_id`,`problem_id`),
   KEY `problem_id` (`problem_id`),
   CONSTRAINT `learning_progress_ibfk_2` FOREIGN KEY (`problem_id`) REFERENCES `problems` (`id`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `difficulties` (
   `id` int NOT NULL AUTO_INCREMENT,
   `name` varchar(50) NOT NULL,
   `level` int NOT NULL,
   `description` text,
   PRIMARY KEY (`id`),
   UNIQUE KEY `name` (`name`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `code_snippets` (
   `id` int NOT NULL AUTO_INCREMENT,
   `user_id` int NOT NULL,
   `title` varchar(255) DEFAULT NULL,
   `code` text NOT NULL,
   `language` varchar(50) NOT NULL,
   `description` text,
   `is_public` tinyint(1) DEFAULT '0',
   `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
   `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   PRIMARY KEY (`id`),
   KEY `code_snippets_ibfk_1` (`user_id`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `chatrooms` (
   `chatroom_id` int NOT NULL AUTO_INCREMENT,
   `chatname` varchar(255) NOT NULL,
   `description` text,
   `is_group` tinyint DEFAULT '0',
   `password` varchar(255) DEFAULT NULL,
   `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
   `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   `forename` varchar(255) DEFAULT NULL,
   PRIMARY KEY (`chatroom_id`)
 ) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `chatroom_users` (
   `chatroom_user_id` int NOT NULL AUTO_INCREMENT,
   `chatroom_id` int NOT NULL,
   `user_id` int DEFAULT NULL,
   `joined_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
   `is_admin` tinyint(1) DEFAULT '0',
   PRIMARY KEY (`chatroom_user_id`),
   UNIQUE KEY `chatroom_id` (`chatroom_id`,`user_id`),
   KEY `user_id` (`user_id`),
   CONSTRAINT `chatroom_users_ibfk_1` FOREIGN KEY (`chatroom_id`) REFERENCES `chatrooms` (`chatroom_id`) ON DELETE CASCADE,
   CONSTRAINT `chatroom_users_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
 ) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `categories` (
   `id` int NOT NULL AUTO_INCREMENT,
   `name` varchar(100) NOT NULL,
   `description` text,
   `parent_id` int DEFAULT NULL,
   PRIMARY KEY (`id`),
   UNIQUE KEY `name` (`name`),
   KEY `parent_id` (`parent_id`),
   CONSTRAINT `categories_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `backup_posts` (
   `post_id` int NOT NULL,
   `title` varchar(255) NOT NULL,
   `content` text NOT NULL,
   `author` varchar(100) NOT NULL,
   `category` varchar(50) DEFAULT NULL,
   `views` int DEFAULT '0',
   `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
   `user_id` int NOT NULL,
   `action_type` enum('UPDATE','DELETE') NOT NULL,
   `action_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (`post_id`,`action_time`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `algorithm_types` (
   `id` int NOT NULL AUTO_INCREMENT,
   `name` varchar(100) NOT NULL,
   `description` text,
   `parent_id` int DEFAULT NULL,
   PRIMARY KEY (`id`),
   UNIQUE KEY `name` (`name`),
   KEY `parent_id` (`parent_id`),
   CONSTRAINT `algorithm_types_ibfk_1` FOREIGN KEY (`parent_id`) REFERENCES `algorithm_types` (`id`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


