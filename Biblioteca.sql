 CREATE DATABASE biblioteca;
 
 USE biblioteca; 
 
 
 -- 1. Tabela Pai (Generalização)
CREATE TABLE Pessoa (
    id_pessoa INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) UNIQUE NOT NULL,
    email VARCHAR(100)
);

-- 2. Tabela Filha (Especialização - Aluno)
CREATE TABLE Aluno (
    id_pessoa INT PRIMARY KEY,
    matricula VARCHAR(20) UNIQUE NOT NULL,
    turma VARCHAR(10),
    FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa)
);

-- 3. Tabela Filha (Especialização - Bibliotecário)
CREATE TABLE Bibliotecario (
    id_pessoa INT PRIMARY KEY,
    registro_funcional VARCHAR(20) UNIQUE NOT NULL,
    turno VARCHAR(10) CHECK (turno IN ('Manhã', 'Tarde', 'Noite')),
    FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa)
);

-- 4. Entidade Fraca (Telefone - Multivalorado)
CREATE TABLE Telefone (
    id_pessoa INT,
    numero VARCHAR(15),
    tipo VARCHAR(10), -- Celular, Fixo
    PRIMARY KEY (id_pessoa, numero),
    FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa) ON DELETE CASCADE
);

-- 5. Entidade Livro 
CREATE TABLE Livro (
    id_livro INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(200) NOT NULL,
    autor VARCHAR(100),
    isbn VARCHAR(13) UNIQUE, -- Corrigida a vírgula
    situacao VARCHAR(20) DEFAULT 'Disponível' CHECK (situacao IN ('Disponível', 'Emprestado', 'Danificado'))
);

-- 6. Tabela de Relacionamento (Empréstimo)
CREATE TABLE Emprestimo (
    id_emprestimo INT PRIMARY KEY AUTO_INCREMENT,
    data_retirada DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_prevista DATE NOT NULL,
    data_devolucao DATETIME,
    id_aluno INT NOT NULL,        -- Quem pegou (FK para Pessoa/Aluno)
    id_bibliotecario INT NOT NULL, -- Quem emprestou (FK para Pessoa/Bibliotecario)
   
    FOREIGN KEY (id_aluno) REFERENCES Aluno(id_pessoa),
    FOREIGN KEY (id_bibliotecario) REFERENCES Bibliotecario(id_pessoa)
);

-- 7. Tabela de Relacionamento emprestimos_Livro 

CREATE TABLE Emprestimo_Livro (
    id_livro INT NOT NULL,
    id_emprestimo INT NOT NULL,
    
    PRIMARY KEY (id_livro, id_emprestimo),

    FOREIGN KEY (id_livro) REFERENCES Livro(id_livro),
    FOREIGN KEY (id_emprestimo) REFERENCES Emprestimo(id_emprestimo)
);


-- 1. Adicionar coluna 'Data de Nascimento' em Pessoa
ALTER TABLE Pessoa ADD data_nascimento DATE;

-- 2. Aumentar o tamanho do campo nome do Autor
ALTER TABLE Livro MODIFY autor VARCHAR(150);


-- Resolver problema que tivemos na tabela de emprestimo
ALTER TABLE Emprestimo 
MODIFY data_prevista DATETIME;

-- 1. Inserindo PESSOAS (Genérico - precisam ser 20 no total para cobrir alunos e bibliotecários)
INSERT INTO Pessoa (nome, cpf, email, data_nascimento) VALUES
('João Silva', '11111111111', 'joao@email.com', '2002-03-15'),
('Maria Souza', '22222222222', 'maria@email.com', '2001-07-22'),
('Carlos Lima', '33333333333', 'carlos@email.com', '2003-01-10'),
('Ana Paula', '44444444444', 'ana@email.com', '2002-11-05'),
('Pedro Santos', '55555555555', 'pedro@email.com', '2001-09-17'),
('Lucia Ferreira', '66666666666', 'lucia@email.com', '2003-06-30'),
('Roberto Alves', '77777777777', 'beto@email.com', '2002-04-14'),
('Fernanda Dias', '88888888888', 'nanda@email.com', '2001-12-03'),
('Lucas Moraes', '99999999999', 'lucas@email.com', '2002-08-21'),
('Beatriz Melo', '10101010101', 'bia@email.com', '2003-05-11'),

('Sergio Adm', '12121212121', 'sergio@biblio.com', '1985-03-20'),
('Amanda Bib', '13131313131', 'amanda@biblio.com', '1990-07-12'),
('Ricardo Staff', '14141414141', 'ricardo@biblio.com', '1988-10-01'),
('Julia Staff', '15151515151', 'julia@biblio.com', '1992-01-17'),
('Marcos Staff', '16161616161', 'marcos@biblio.com', '1984-06-25'),
('Tania Staff', '17171717171', 'tania@biblio.com', '1991-04-09'),
('Bruno Staff', '18181818181', 'bruno@biblio.com', '1987-08-13'),
('Carla Staff', '19191919191', 'carla@biblio.com', '1993-11-30'),
('Daniel Staff', '20202020202', 'daniel@biblio.com', '1986-02-19'),
('Eliana Staff', '21212121212', 'eliana@biblio.com', '1994-09-08');

-- 2. Inserindo ALUNOS (Especialização - IDs 1 a 10)
INSERT INTO Aluno (id_pessoa, matricula, turma) VALUES
(1, '2023001', '1A'), (2, '2023002', '1B'), (3, '2023003', '2A'), (4, '2023004', '2B'),
(5, '2023005', '3A'), (6, '2023006', '3B'), (7, '2023007', '1A'), (8, '2023008', '2A'),
(9, '2023009', '3A'), (10, '2023010', '1B');

-- 3. Inserindo BIBLIOTECÁRIOS (Especialização - IDs 11 a 20)
INSERT INTO Bibliotecario (id_pessoa, registro_funcional, turno) VALUES
(11, 'FUNC01', 'Manhã'), (12, 'FUNC02', 'Tarde'), (13, 'FUNC03', 'Noite'), (14, 'FUNC04', 'Manhã'),
(15, 'FUNC05', 'Tarde'), (16, 'FUNC06', 'Manhã'), (17, 'FUNC07', 'Noite'), (18, 'FUNC08', 'Tarde'),
(19, 'FUNC09', 'Manhã'), (20, 'FUNC10', 'Tarde');

-- 4. Inserindo LIVROS (Mantido sem alteração de colunas)
INSERT INTO Livro (titulo, autor, isbn) VALUES
('Dom Casmurro', 'Machado de Assis', '9781'), ('Harry Potter 1', 'J.K. Rowling', '9782'),
('O Senhor dos Anéis', 'Tolkien', '9783'), ('A Revolução dos Bichos', 'George Orwell', '9784'),
('O Pequeno Príncipe', 'Exupéry', '9785'), ('1984', 'George Orwell', '9786'),
('Iracema', 'José de Alencar', '9787'), ('Capitães da Areia', 'Jorge Amado', '9788'),
('Vidas Secas', 'Graciliano Ramos', '9789'), ('A Hora da Estrela', 'Clarice Lispector', '9780');

-- 5. Inserindo EMPRÉSTIMOS
INSERT INTO Emprestimo (data_retirada, data_prevista, id_aluno, id_bibliotecario) VALUES
(NOW(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), 1, 11),
(NOW(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), 2, 11),
(NOW(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), 3, 12),
(NOW(), DATE_ADD(CURDATE(), INTERVAL 7 DAY), 4, 12),
('2023-10-01', '2023-10-08', 5, 13),
('2023-10-02', '2023-10-09', 6, 13),
('2023-10-03', '2023-10-10', 1, 11),
('2023-10-04', '2023-10-11', 2, 12),
('2023-10-05', '2023-10-12', 3, 14),
('2023-10-06', '2023-10-13', 4, 15);

-- Visualizando as tabelas
SHOW TABLES; 


-- Aqui a parte de views

-- Vê aluno junto com dados pessoais (são duas tabelas diferentes)

CREATE VIEW vw_alunos_comp AS
SELECT 
    Pessoa.id_pessoa,
    Pessoa.nome,
    Pessoa.cpf,
    Pessoa.email,
    Pessoa.data_nascimento,
    Aluno.matricula,
    Aluno.turma
FROM Pessoa
JOIN Aluno ON Pessoa.id_pessoa = Aluno.id_pessoa;

SELECT * FROM vw_alunos_comp;


-- Qual bibliotecario fez o emprestimo do livro 
CREATE VIEW vw_emprestimos_bibliotecarios AS
SELECT
    Emprestimo.id_emprestimo,
    Pessoa.nome AS bibliotecario,
    Emprestimo.data_retirada,
    Emprestimo.data_prevista
FROM Emprestimo
JOIN Bibliotecario ON Emprestimo.id_bibliotecario = Bibliotecario.id_pessoa
JOIN Pessoa ON Bibliotecario.id_pessoa = Pessoa.id_pessoa;

SELECT * FROM vw_emprestimos_bibliotecarios;


-- O empréstimo já com o nome do aluno que pegou o dito livro
CREATE VIEW vw_emprestimos_alunos AS
SELECT
    Emprestimo.id_emprestimo,
    Pessoa.nome AS aluno,
    Emprestimo.data_retirada,
    Emprestimo.data_prevista,
    Emprestimo.data_devolucao
FROM Emprestimo
JOIN Aluno ON Emprestimo.id_aluno = Aluno.id_pessoa
JOIN Pessoa ON Aluno.id_pessoa = Pessoa.id_pessoa;

SELECT * FROM vw_emprestimos_alunos;


DELIMITER //
CREATE PROCEDURE AdicionarAluno(IN nome_pessoa VARCHAR(100), IN email_pessoa varchar(100),IN cpf char(11), IN matricula VARCHAR(20),IN  turma VARCHAR(10))
BEGIN
	INSERT INTO pessoa (nome, email, cpf)
	VALUES (nome_pessoa, email_pessoa, cpf);
	
	INSERT INTO aluno (matricula, turma, id_pessoa)
	VALUES (matricula, turma, LAST_INSERT_ID());
END //

DELIMITER ;

CALL AdicionarAluno ("brunna", "brunna@ifbaiano", "253644448", "1234123412", "1º Ano C");

	
