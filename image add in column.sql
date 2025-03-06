create table full_emp
(
id int identity(1,1) primary key,
full_name varchar(max),
IMG VARBINARY(MAX)
);

INSERT INTO full_emp (full_name, IMG)
SELECT 
    'ANUSHKA_SHETTY',
    BulkColumn
FROM 
    OPENROWSET(BULK 'E:\IndiaTv7a29fe_anushka-shetty.jpg', SINGLE_BLOB) AS IMAGE_FILE;


insert into full_emp values
('rushi_bhise', (select * from openrowset(bulk 'E:\IMG_20231105_214051632.jpg', single_blob) as image)),
('anushka', (select * from openrowset(bulk 'E:\IndiaTv7a29fe_anushka-shetty.jpg', single_blob) as imag_e));


truncate table full_emp;

SELECT id,full_name,datalength(full_name) as data_length, LEN(full_name) len_of_name,len(IMG) as emg_lenth, DATALENGTH(IMG) AS ImageSize
FROM full_emp;

SELECT * FROM full_emp
