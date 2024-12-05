use basicdb;

select * 
from sessions;
select * 
from login_history;
select * 
from posts;
describe posts;
drop table deleted_posts;
describe posts;
select * 
from backup_posts;


CREATE TABLE backup_posts (
    post_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    author VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    views INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INT NOT NULL,
    action_type ENUM('UPDATE', 'DELETE') NOT NULL,
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (post_id, action_time)
);

drop trigger if exists before_update_posts;
-- 수정 트리거 OLD * 트리거가 실행되면 자동으로 트리거가 작업중이던 데이터를 참조

-- 새로운 트리거 생성
DELIMITER $$

CREATE TRIGGER before_update_posts
BEFORE UPDATE ON posts
FOR EACH ROW
BEGIN
    -- 실제 변경이 있을 때만 백업
    IF OLD.title != NEW.title 
    OR OLD.content != NEW.content 
    OR OLD.category != NEW.category THEN
        INSERT INTO backup_posts 
            (post_id, title, content, author, category, views, created_at, user_id, action_type, action_time)
        VALUES 
            (OLD.post_id, OLD.title, OLD.content, OLD.author, OLD.category, OLD.views, OLD.created_at, OLD.user_id, 'UPDATE', NOW());
    END IF;
END$$

DELIMITER ;


-- 삭제 트리거
DELIMITER $$

CREATE TRIGGER before_delete_posts
BEFORE DELETE ON posts
FOR EACH ROW
BEGIN
    INSERT INTO backup_posts 
        (post_id, title, content, author, category, views, created_at, user_id, action_type, action_time)
    VALUES 
        (OLD.post_id, OLD.title, OLD.content, OLD.author, OLD.category, OLD.views, OLD.created_at, OLD.user_id, 'DELETE', NOW());
END$$

DELIMITER ;

