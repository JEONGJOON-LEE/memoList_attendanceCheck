# DBeaver 한글 캐릭터 셋 UTF-8로 변경하기
# DBeaver가 설치된 폴더에서 dbever.ini 파일을 메모장을 열고 마지막에 -Dfile.encoding=UTF-8을 추가한다.



select * from memolist 

select * from memolist order by idx desc;
select * from memolist order by idx desc limit 0,10;

delete from memolist; 
alter table memolist  auto_increment = 1;

select count(*) from memolist;

# 더미 데이터 입력
insert into memolist (name, password, memo, ip) values('홍길동', '1111', '1등 입니다.', '192.168.219.102');
insert into memolist (name, password, memo, ip) values('임꺽정', '2222', '2등 입니다.', '192.168.219.103');
insert into memolist (name, password, memo, ip) values('장길산', '3333', '3등 입니다.', '192.168.219.104');
insert into memolist (name, password, memo, ip) values('일지매', '4444', '4등 입니다.', '192.168.219.105');

select * from memolist where idx = 100;



