--1. Utwórz nowe loginy o nazwach login1, login2 i login3 z domyślną bazą danych HR.
create login login1 with password = 'login1', DEFAULT_DATABASE = HR; 
create login login2 with password = 'login2', DEFAULT_DATABASE = HR;
create login login3 with password = 'login3', DEFAULT_DATABASE = HR;

--2. Utwórz nowych użytkowników w bazie danych HR o nazwach user1, user2 i user3 przypisanych do loginów login1, login2 i login3.
create user user1 for login login1;
create user user2 for login login2;
create user user3 for login login3;

--3.  Nadaj użytkownikom user1, user2 i user3 uprawnienia do wyświetlania departamentów.
grant select on departments to user1, user2, user3;

--4. Utwórz nową rolę o nazwie role1 i uczyń użytkownika user1 jej właścicielem.
create role role1 authorization user1;

--5. Nadaj użytkownikowi user1 uprawnienia do dodawania departamentów z możliwością dalszego przekazywania uprawnień.
grant insert on departments to user1 with grant option;

--6. Nadaj roli role1 uprawnienia do usuwania departamentów.
grant delete on departments to role1;

--7. Jako user1 nadaj użytkownikowi user2 uprawnienia do dodawania departamentów.
execute as user = 'user1';
grant insert on departments to user2;

--8. Jako user1 nadaj użytkownikowi user2 rolę role1.
alter role role1 add member user2;

--9. Pozbaw użytkownika user1 uprawnień do dodawania departamentów.
revert;
revoke insert on departments to user1 cascade;

--10. Pozbaw użytkownika user1 roli role1.
exec sp_droprolemember 'role1', 'user1';

--11. Czy jako użytkownik user2 możesz nadać użytkownikowi user3 uprawnienia do dodawania departamentów?
execute as user = 'user2';
grant insert on departments to user3;
--nie mozna

--12. Czy jako użytkownik user2 możesz nadać użytkownikowi user3 rolę role1?
alter role role1 add member user3;
--nie mozna

--13. Czy jako użytkownik user1 możesz nadać użytkownikowi user3 rolę role1?
revert;
execute as user = 'user1';
alter role role1 add member user3;
--mozna?????????????????????????????

---------------test-----------------
SELECT 
    dp.name AS UserName, 
    dr.name AS RoleName
FROM 
    sys.database_principals dp
INNER JOIN 
    sys.database_role_members drm
    ON dp.principal_id = drm.member_principal_id
INNER JOIN 
    sys.database_principals dr
    ON drm.role_principal_id = dr.principal_id
WHERE 
    dr.name = 'role1';  

