use basicdb;

select * 
from sessions;
select * 
from login_history;
select * 
from posts;
describe posts;
drop table deleted_posts;



select * 
from users;

select * 
from sessions;
-- 제약조건이 있는 테이블의 변경
select * 
from posts;
describe users;
ALTER TABLE posts DROP PRIMARY KEY;
alter table posts change id post_id  int not null auto_increment primary key;

ALTER TABLE posts ADD COLUMN post_id INT NOT NULL;
ALTER TABLE posts MODIFY COLUMN id INT NOT NULL;
ALTER TABLE posts 
CHANGE COLUMN post_id post_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;
ALTER TABLE posts DROP COLUMN id;

alter table sessions add column username varchar(255) not null;

ALTER TABLE users ADD COLUMN user_id INT NOT NULL;
describe users;
describe posts;
select * 
from posts;
alter table posts add column user_id int not null ; 
alter table sessions drop column username;
SHOW CREATE TABLE posts;


ALTER TABLE problems CHANGE COLUMN created_by created_by_user_id INT NOT NULL;




ALTER TABLE users MODIFY COLUMN id INT NOT NULL;
ALTER TABLE users 
CHANGE COLUMN users_id user_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;
ALTER TABLE users DROP COLUMN id;

SELECT TABLE_NAME, CONSTRAINT_NAME, COLUMN_NAME 
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE REFERENCED_TABLE_NAME = 'users' AND REFERENCED_COLUMN_NAME = 'user_id';

ALTER TABLE code_snippets DROP FOREIGN KEY code_snippets_ibfk_1;
ALTER TABLE learning_progress DROP FOREIGN KEY learning_progress_ibfk_1;
ALTER TABLE notifications DROP FOREIGN KEY notifications_ibfk_1;
ALTER TABLE login_history DROP FOREIGN KEY login_history_ibfk_1;
ALTER TABLE sessions DROP FOREIGN KEY sessions_ibfk_1;
ALTER TABLE problems DROP FOREIGN KEY problems_ibfk_1;
drop table problems;
SHOW CREATE TABLE problems;

-- 외래키 다시 설정
ALTER TABLE code_snippets 
ADD CONSTRAINT code_snippets_ibfk_1 
FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE;

ALTER TABLE learning_progress 
ADD CONSTRAINT learning_progress_ibfk_1 
FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE;

ALTER TABLE notifications 
ADD CONSTRAINT notifications_ibfk_1 
FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE;

ALTER TABLE login_history 
ADD CONSTRAINT login_history_ibfk_1 
FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE;

ALTER TABLE sessions 
ADD CONSTRAINT sessions_ibfk_1 
FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE;

ALTER TABLE problems 
ADD CONSTRAINT problems_ibfk_1 
FOREIGN KEY (created_by_user_id) REFERENCES users (user_id) ON DELETE CASCADE;


ALTER TABLE users MODIFY COLUMN id INT NOT NULL;
ALTER TABLE users DROP PRIMARY KEY;
ALTER TABLE users CHANGE COLUMN id user_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;

-- 세션 변경
describe sessions;
SHOW CREATE TABLE sessions;
ALTER TABLE sessions DROP FOREIGN KEY sessions_ibfk_1; 

SELECT TABLE_NAME, CONSTRAINT_NAME, COLUMN_NAME 
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE REFERENCED_TABLE_NAME = 'sessions' AND REFERENCED_COLUMN_NAME = 'id';
-- login_history가 id를 참조하고 있음
select * from login_history;
SHOW CREATE TABLE login_history;
ALTER TABLE login_history DROP FOREIGN KEY login_history_ibfk_2;
-- -----------------------------------------------------------------
SHOW CREATE TABLE sessions;
ALTER TABLE sessions DROP PRIMARY KEY;
alter table sessions change column id session_id varchar(255) not null primary key;
select * from sessions;

alter table login_history change column id login_id int not null AUTO_INCREMENT;
FLUSH TABLES;
-- 작업 마치고 마지막에 외래키 추가
ALTER TABLE login_history 
ADD CONSTRAINT login_history_ibfk_1 
FOREIGN KEY (ssession_id) REFERENCES sessions (ssession_id) ON DELETE CASCADE;





FLUSH TABLES;
SHOW KEYS FROM sessions;

