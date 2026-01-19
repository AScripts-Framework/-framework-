-- Migration to add appearance column to existing user_characters table
-- Run this if you already have the user_characters table

ALTER TABLE `user_characters` 
ADD COLUMN `appearance` LONGTEXT NULL DEFAULT NULL AFTER `height`;
