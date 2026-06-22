--1. Utwórz nowych użytkowników o nazwach user1, user2 i user3.
create user user1;
create user user2;
create user user3;

--2. Nadaj użytkownikom user1, user2 i user3 uprawnienia do wyświetlania departamentów.
grant select on table departments to user1, user2, user3; 

--3. Utwórz nową rolę o nazwie role1 i uczyń użytkownika user1 jej administratorem.
create role role1 with admin user1;

--4. Nadaj użytkownikowi user1 uprawnienia do dodawania departamentów z 
--możliwością dalszego przekazywania uprawnień.
grant insert on table departments to user1 with grant option; 
--grant option umozliwia nadanie przywileju obiektowego innym uzytkownikom (z grant lub bez)
--lub rolom

--5. Nadaj roli role1 uprawnienia do usuwania departamentów.
grant delete on table departments to role1;

--6. Jako user1 nadaj użytkownikowi user2 uprawnienia do dodawania departamentów.
set role user1;
grant insert on table departments to user2;

--7. Jako user1 nadaj użytkownikowi user2 rolę role1.
grant role1 to user2;

--8. Pozbaw użytkownika user1 uprawnień do dodawania departamentów.
reset role;
revoke insert on table departments from user1 CASCADE; --ok?????????????? bez cascade na pewno nie dziala

--9. Pozbaw użytkownika user1 roli role1.
revoke role1 from user1 CASCADE; --ok?????????

--10. Czy jako użytkownik user2 możesz nadać użytkownikowi user3
--uprawnienia do dodawania departamentów?
set role user2;
grant insert on table departments to user3; --chyba nie moze bo nie ma grant option i dlatego to ostrzezenie???

--11. Czy jako użytkownik user2 możesz nadać użytkownikowi user3 rolę role1?
grant role1 to user3; 
--nie, bo chyba nie ma już tej roli bo zabrana też w 9. bo cascade zreszta nie mial admina?????

--12. Czy jako użytkownik user1 możesz nadać użytkownikowi user3 rolę role1?
reset role;
set role user1;
grant role1 to user3; --nie bo zabrane uprawnienia w 9.

-------------------------------TEST------------------------------------------------------
SELECT grantee.rolname AS user_name, granted.rolname AS role_name
FROM pg_auth_members
JOIN pg_roles grantee ON pg_auth_members.member = grantee.oid
JOIN pg_roles granted ON pg_auth_members.roleid = granted.oid
WHERE grantee.rolname = 'user1';

REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM role1;
drop role role1;