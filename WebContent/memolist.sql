# DBeaver �ѱ� ĳ���� �� UTF-8�� �����ϱ�
# DBeaver�� ��ġ�� �������� dbever.ini ������ �޸����� ���� �������� -Dfile.encoding=UTF-8�� �߰��Ѵ�.



select * from memolist 

select * from memolist order by idx desc;
select * from memolist order by idx desc limit 0,10;

delete from memolist; 
alter table memolist  auto_increment = 1;

select count(*) from memolist;

# ���� ������ �Է�
insert into memolist (name, password, memo, ip) values('ȫ�浿', '1111', '1�� �Դϴ�.', '192.168.219.102');
insert into memolist (name, password, memo, ip) values('�Ӳ���', '2222', '2�� �Դϴ�.', '192.168.219.103');
insert into memolist (name, password, memo, ip) values('����', '3333', '3�� �Դϴ�.', '192.168.219.104');
insert into memolist (name, password, memo, ip) values('������', '4444', '4�� �Դϴ�.', '192.168.219.105');

select * from memolist where idx = 100;



