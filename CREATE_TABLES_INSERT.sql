use icarros2;

/*ATIVIDADE*/
CREATE TABLE cliente (
    cliente_cod INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    cliente_nome VARCHAR(45) NOT NULL,
    cliente_email VARCHAR(45) NOT NULL,
    cliente_cpf VARCHAR(11) NOT NULL,
    cliente_endereco VARCHAR(45) NOT NULL,
    cliente_numero VARCHAR(45) NOT NULL,
    cliente_complemento VARCHAR(80),
    cliente_cidade VARCHAR(20) NOT NULL,
    cliente_estado char(2) NOT NULL,
    dt_cadastro DATETIME NOT NULL
);

CREATE TABLE cliente_backup (
    cliente_cod INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    cliente_nome VARCHAR(45) NOT NULL,
    cliente_email VARCHAR(45) NOT NULL,
    cliente_cpf VARCHAR(11) NOT NULL,
    cliente_endereco VARCHAR(45) NOT NULL,
    cliente_numero VARCHAR(45) NOT NULL,
    cliente_complemento VARCHAR(80),
    cliente_cidade VARCHAR(20) NOT NULL,
    cliente_estado char(2) NOT NULL,
    dt_cadastro DATETIME NOT NULL
);
CREATE TABLE locacao (
    locacao_cod INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    automovel_cod INT NOT NULL,
    cliente_cod INT NOT NULL,
    locacao_km VARCHAR(20) NOT NULL,
    dt_cadastro DATETIME NOT NULL
);
CREATE TABLE automovel (
    automovel_cod INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    marca_cod INT NOT NULL,
    modelo_cod INT NOT NULL,
    automovel_nome VARCHAR(20) NOT NULL
);
CREATE TABLE marca (
    marca_cod INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    marca_descricao VARCHAR(20) NOT NULL
);
CREATE TABLE modelo (
    modelo_cod INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    modelo_descricao VARCHAR(20)  NOT NULL
);

ALTER TABLE locacao
ADD FOREIGN KEY (automovel_cod) REFERENCES automovel(automovel_cod);
ALTER TABLE locacao
ADD FOREIGN KEY (cliente_cod) REFERENCES cliente(cliente_cod);

ALTER TABLE automovel
ADD FOREIGN KEY (marca_cod) REFERENCES marca(marca_cod);
ALTER TABLE automovel
ADD FOREIGN KEY (modelo_cod) REFERENCES modelo(modelo_cod);

/*INSERINDO CAMPOS NAS TABELAS*/

INSERT cliente values 
(null, "Lucas", "lucas@gmail.com", "05450224444", "Endeço local 1", 22, "Proximo da ali", "Rio de Janeiro", "RJ", now()),
(null, "Thais", "tahis@gmail.com", "05450224577", "Endeço local 2", 22, "Proximo da ali2", "São Paulo", "SP", now()),
(null, "Thales", "thales@gmail.com", "05450224466", "Endeço local 3", 22, "Proximo da ali3", "Brasilia", "DF", now()),
(null, "Noan", "noan@gmail.com", "05450224477", "Endeço local 4", 22, "Proximo da ali4", "Minas Gerais", "MG", now()),
(null, "Mathues", "matheus@gmail.com", "05450224477", "Endeço local 5", 22, "Proximo da ali5", "Paraná", "PR", now()),
(null, "Caio", "caio@gmail.com", "05450224433", "Endeço local 6", 22, "Proximo da ali6", "Pará", "PA", now()),
(null, "Luis", "luis@gmail.com", "05450224411", "Endeço local 7", 22, "Proximo da ali7", "Roraima", "RR", now()),
(null, "Renan", "renan@gmail.com", "05450224321", "Endeço local 8", 22, "Proximo da ali8", "Rio de Janeiro", "RJ", now()),
(null, "Ricardo", "ricardo@gmail.com", "05450224789", "Endeço local 9", 22, "Proximo da ali9", "São Paulo", "SP", now()),
(null, "Karina", "karina@gmail.com", "05450224456", "Endeço local 10", 22, "Proximo da ali10", "Minas Gerais", "MG", now());
/*INSERINDO NA TABLE MARCA*/
INSERT marca values
(null, "Fiat" ),
(null, "Chevrolet" ),
(null, "Renault" ),
(null, "Volkswagem" ),
(null, "Toyota" ),
(null, "Honda" );

/*INSERINDO NA TABLE MODELO*/
insert modelo values
(null, "GL"),
(null, "GLS"),
(null, "CD"),
(null, "LT");

/*INSERINDO NA TABLE AUTOMOVEL*/
insert automovel values(null, 1, 1, "fiat miller");
insert automovel values(null, 2, 3, "Cruze Sedan");
insert automovel values(null, 3, 4, "Logan");
insert automovel values(null, 4, 1, "Polo");
insert automovel values(null, 5, 2, "Corolla");
insert automovel values(null, 6, 3, "Civic");

/*INSERINDO NA TABLE LOCACAO*/
INSERT LOCACAO VALUES (NULL, 1, 1, "200km", now());
INSERT LOCACAO VALUES (NULL, 2, 6, "400km", now());
INSERT LOCACAO VALUES (NULL, 5, 4, "300km", now());
INSERT LOCACAO VALUES (NULL, 2, 5, "500km", now());
INSERT LOCACAO VALUES (NULL, 3, 10, "250km", now());
INSERT LOCACAO VALUES (NULL, 4, 8, "350km", now());
INSERT LOCACAO VALUES (NULL, 6, 7, "450km", now());

DELIMITER $$
CREATE PROCEDURE `LocacaoAuto` ()
BEGIN
	SELECT 
    cli.cliente_nome,
    cli.cliente_email,
    cli.cliente_cpf,
    au.automovel_nome as "auto locado",
    lo.dt_cadastro, 
    ma.marca_descricao as "marca auto", 
    mo.modelo_descricao FROM
    cliente cli, locacao lo 
    inner join automovel au 
    on au.automovel_cod = lo.automovel_cod 
    AND lo.automovel_cod = au.automovel_cod 
    inner join marca ma 
    on ma.marca_cod = au.marca_cod 
    AND au.marca_cod = ma.marca_cod 
    inner join modelo mo 
    on mo.modelo_cod = au.modelo_cod 
    AND au.modelo_cod = mo.modelo_cod
    WHERE cli.cliente_cod = lo.cliente_cod
    and lo.automovel_cod = au.automovel_cod;
END$$
DELIMITER ;

/*CRIANDO A TRIGGER 1*/
DELIMITER $$
CREATE DEFINER=`root`@`localhost` TRIGGER `cliente_BEFORE_INSERT` BEFORE INSERT ON `cliente` FOR EACH ROW BEGIN
	INSERT CLIENTE_BACKUP 
    (
    cliente_cod, 
    cliente_nome, 
    cliente_email,
    cliente_cpf,
    cliente_endereco,
    cliente_numero,
    cliente_complemento,
    cliente_cidade,
    cliente_estado,
    dt_cadastro 
    ) 
    values(
         new.cliente_cod, 
		 new.cliente_nome,
         new.cliente_email,
         new.cliente_cpf,
         new.cliente_endereco,
         new.cliente_numero,
         new.cliente_complemento,
         new.cliente_cidade,
         new.cliente_estado,
         new.dt_cadastro
         );
END$$
DELIMITER ;

/*INSERINDO NA TABLE BACKUP_CLIENTE ATRAVES TRIGGER BEFORE_INSERT */
insert into cliente value (null, "Idelvan", "idelvan@gmail.com", "05450224795", 
"Endeço local 11", 25, "Proximo da ali11", "Caxias", "MA", now());

/*Adicionando campo valor locacao*/
ALTER TABLE locacao ADD valor_locacao float not null;

/*ADICIONANDO VALORES ALEATORIOS NA COLUNA VALOR_LOCACAO*/
UPDATE locacao SET valor_locacao = FLOOR(RAND() * 1000) WHERE locacao_cod = 1 OR 8;

/*PROCEDURE QUE MOSTRA VALOR TOTAL DE TODAS LOCACAO*/
DELIMITER $$
CREATE PROCEDURE `mostra_total` ()
BEGIN
  select sum(valor_locacao) as "TOTAL VALOR LOCACAO" from locacao;
END$$
DELIMITER ;

/*CHAMANDO A PROCEDURE*/
call icarros2.LocacaoAuto;
/*CHAMANDO A PROCEDURE*/
call icarros2.mostra_total;

DROP TABLE cliente, cliente_backup;
