-- *************************************************************
-- SCRIPT PARA CRIAÇÃO DE BANCO DE DADOS E GERENCIAMENTO DE USUÁRIOS
-- Projeto: Sistema de Carteiras Digitais
-- *************************************************************

-- ** 1. Criação do Banco de Dados **
create database walletdigital_dev;

-- ** 2. Início da Transação para Criação de Tabelas **
begin;

-- ** 3. Criação das TabelAS **

-- Tabela de clientes
create table if not exists clientes (
    cliente_id serial primary key,
    nome varchar(100) not null,
    cpf varchar(14) not null unique,
    senha varchar(255) not null,
    telefone varchar(20) not null,
    email varchar(100) not null unique,
    data_criacao TIMESTAMP default CURRENT_TIMESTAMP,
    status varchar(10) check (status in('ativo', 'desativado'))
);

-- Tabela de carteiras
create table if not exists carteiras (
    carteira_id serial primary key,
    cliente_id integer not null,
    saldo DECIMAL(10,2) default 0.0,
    senha_transacao char(4) CHECK(length(senha_transacao) = 4),
    limite_maximo decimal(10,2) check(limite_maximo <= 20000),
    tipo_conta varchar(10) check(tipo_conta in('poupanca', 'corrente')),
    data_criacao TIMESTAMP default CURRENT_TIMESTAMP,
    foreign key(cliente_id) REFERENCES clientes(cliente_id) ON DELETE CASCADE
);

-- Tabela de transações
create table if not exists transacoes (
    transacao_id serial primary key,
    conta_origem_id integer not null,
    conta_destino_id integer not null,
    valor_transferido decimal(10,2) not null check(valor_transferido > 0.0),
    data_transferencia TIMESTAMP default CURRENT_TIMESTAMP,
    status_transferencia varchar(20) check (status_transferencia in('completo', 'cancelada')) not null,
    metodo_transferencia char(3) check(metodo_transferencia in ('pix', 'doc', 'ted')) not null,
    foreign key(conta_origem_id) REFERENCES carteiras(carteira_id) ON DELETE CASCADE,
    foreign key(conta_destino_id) REFERENCES carteiras(carteira_id) ON DELETE CASCADE 
);

-- Finaliza a transação de criação de tabelas
commit;

-- ** 4. Criação e Gerenciamento de Usuário e Permissões **

-- Passo 1: Criar Usuário
create user victor_oliveira with password '12345';

-- Passo 2: Criar Role (Função)
create role desenvolvedor;

-- Passo 3: Atribuir Role ao Usuário
grant desenvolvedor to victor_oliveira;

-- Passo 4: Permitir Conexão ao Banco 'walletdigital_dev'
grant connect on database walletdigital_dev to victor_oliveira;

-- Passo 5: Permissões no Banco de Dados (SELECT, INSERT, UPDATE, DELETE)
grant select, insert, update, delete on all tables in schema public to desenvolvedor;

-- Passo 6: Permissões Padrão para o Schema Public
alter default privileges in schema public grant select, insert, update, delete on tables to desenvolvedor;

-- Passo 7: Revogar Acesso ao Banco de Produção (Segurança)
revoke connect on database walletdigital_production from victor_oliveira;

-- Passo 8: Permitir Criação de Tabelas no Schema Public
grant create on schema public to desenvolvedor;

-- ** 5. Inserção de Dados nas Tabelas **

-- Início da Transação para Inserção de Dados
begin;

-- Inserir dados na tabela de clientes
insert into clientes(nome, cpf, senha, telefone, email)
values 
    ('Marcos Nilo', '12345678900', 'senhasegura', '85 998603423', 'marcos@gmail.com'),
    ('Ana Silva', '98765432100', 'senha123', '85 997812345', 'ana.silva@gmail.com'),
    ('Carlos Pereira', '11223344556', 'minhasenha', '85 988654321', 'carlos.pereira@gmail.com'),
    ('Juliana Souza', '22334455667', 'segurançasenha', '85 991234567', 'juliana.souza@gmail.com'),
    ('Felipe Costa', '33445566778', 'senhaF123', '85 994563210', 'felipe.costa@gmail.com'),
    ('Patrícia Lima', '44556677889', 'senhaPatricia', '85 999876543', 'patricia.lima@gmail.com'),
    ('Ricardo Santos', '55667788990', 'seguraRicardo', '85 981234567', 'ricardo.santos@gmail.com'),
    ('Luciana Alves', '66778899001', 'luciana123', '85 998734567', 'luciana.alves@gmail.com'),
    ('João Martins', '77889900112', 'joao12345', '85 997654321', 'joao.martins@gmail.com'),
    ('Sandra Rocha', '88990011223', 'senhaSandra', '85 996543210', 'sandra.rocha@gmail.com');

-- Inserir dados na tabela de carteiras
insert into carteiras(cliente_id, senha_transacao, limite_maximo, tipo_conta)
values 
    (1, '0000', 20000.00, 'corrente'),
    (2, '0000', 20000.00, 'poupanca'),
    (3, '0000', 20000.00, 'corrente'),
    (4, '0000', 20000.00, 'poupanca'),
    (5, '0000', 20000.00, 'corrente'),
    (6, '0000', 20000.00, 'poupanca'),
    (7, '0000', 20000.00, 'corrente'),
    (8, '0000', 20000.00, 'poupanca'),
    (9, '0000', 20000.00, 'corrente'),
    (10, '0000', 20000.00, 'poupanca');

-- Finaliza a transação de inserção de dados
commit;

-- ** 6. Revogar Acessos (Quando Necessário) **

-- Exemplo de revogação de privilégios
-- revoke all privileges on database walletdigital_dev from victor_oliveira;
-- revoke all privileges on all tables in schema public from victor_oliveira;
-- revoke connect on database walletdigital_dev from victor_oliveira;
-- revoke usage on schema public from victor_oliveira;
