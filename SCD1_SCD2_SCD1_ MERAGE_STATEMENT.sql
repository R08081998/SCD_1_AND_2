use RUSHI_PRACTICE
-------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROC SCD1_PROCEDURE 
AS
BEGIN
MERGE INTO scd_1 AS t
using scd_1_2 AS s
ON t.Emp_id = s.Emp_id

WHEN MATCHED AND
(T.First_name != S.First_name OR
T.Last_Name != S.Last_Name OR
T.Department_id != S.Department_id OR
T.Email_id != S.Email_id OR
T.Salary != S.Salary OR
T.Gender != S.Gender OR
T.Manager_id != S.Manager_id )

THEN 
   UPDATE SET 
T.First_name = S.First_name,
T.Last_Name = S.Last_Name,
T.Department_id = S.Department_id,
T.Email_id = S.Email_id,
T.Salary = S.Salary,
T.Gender = S.Gender,
T.Manager_id = S.Manager_id,
T.update_date = CURRENT_TIMESTAMP;

INSERT INTO scd_1 (T.Emp_id, T.First_name, T.Last_Name , T.Department_id , T.Email_id ,T.Salary , T.Gender , T.Manager_id)
SELECT  S.Emp_id, S.First_name, S.Last_Name , S.Department_id , S.Email_id ,S.Salary , S.Gender , S.Manager_id
FROM scd_1_2 AS S ;

END;

EXEC  SCD1_PROCEDURE

-------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROC SCD2_PROCEDURE 
AS
BEGIN
MERGE INTO scd_2 AS t
using scd_1_2 AS s
ON t.Emp_id = s.Emp_id and t.flag = 'Y'

WHEN MATCHED AND
(T.First_name != S.First_name OR
T.Last_Name != S.Last_Name OR
T.Department_id != S.Department_id OR
T.Email_id != S.Email_id OR
T.Salary != S.Salary OR
T.Gender != S.Gender OR
T.Manager_id != S.Manager_id )

THEN 
   UPDATE SET 
   
     T.end_date = CURRENT_TIMESTAMP,
         t.flag = 'N';


INSERT INTO scd_2 
(T.Emp_id, T.First_name, T.Last_Name , T.Department_id , T.Email_id ,T.Salary , T.Gender , T.Manager_id,
 T.update_date, t.end_date, t.flag    )
SELECT  S.Emp_id, S.First_name, S.Last_Name , S.Department_id , S.Email_id ,S.Salary , S.Gender , S.Manager_id,
CURRENT_TIMESTAMP,null,'Y'
FROM scd_1_2 AS S
left outer join scd_2 AS T
ON T.Emp_id = S.Emp_id AND T.FLAG = 'Y'
where 
t.Emp_id is null or
T.First_name != S.First_name OR
T.Last_Name != S.Last_Name OR
T.Department_id != S.Department_id OR
T.Email_id != S.Email_id OR
T.Salary != S.Salary OR
T.Gender != S.Gender OR
T.Manager_id != S.Manager_id ;

end;

exec SCD2_PROCEDURE
-------------------------------------------------------------------------------------------------------------------------------------

/* SCD1 With  fully Merge Statement*/

MERGE target_table AS t
USING scd_1_2 AS s
ON t.Emp_id = s.Emp_id
WHEN MATCHED THEN
UPDATE SET

      t.First_name = s.First_name,
      t.Last_Name = s.Last_Name,
      t.Department_id = s.Department_id,
      t.Email_id = s.Email_id,
      t.Salary = s.Salary,
      t.Gender = s.Gender,
      t.Manager_id = s.Manager_id,
      t.update_date = CASE 
                          WHEN     
						            (T.Emp_id != S.Emp_id OR
					                 t.First_name != s.First_name OR
                                     t.Last_Name != s.Last_Name OR
                                     t.Department_id != s.Department_id OR
                                     t.Email_id != s.Email_id OR
                                     t.Salary != s.Salary OR
                                     t.Gender != s.Gender OR
                                     t.Manager_id != s.Manager_id)
					     THEN CURRENT_TIMESTAMP
					     ELSE t.update_date
				     END
WHEN NOT MATCHED THEN
INSERT (Emp_id, First_name, Last_Name, Department_id,Email_id , Salary, Gender, Manager_id, DATA_DATE)
VALUES (S.Emp_id, S.First_name, S.Last_Name, S.Department_id,S.Email_id , S.Salary, S.Gender, S.Manager_id,CURRENT_TIMESTAMP);
