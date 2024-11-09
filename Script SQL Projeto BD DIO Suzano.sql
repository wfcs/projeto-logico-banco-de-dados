-- Criação do banco de dados para o cenário de E-commerce
-- Caso o banco já exista, ele não será recriado. Caso contrário, será criado um novo banco de dados.
CREATE DATABASE IF NOT EXISTS Ecommerce;
USE Ecommerce;

-- Criação da tabela de Clientes
-- A tabela armazena informações gerais dos clientes, incluindo um identificador único, nome, endereço e tipo de cliente (Pessoa Física ou Jurídica).
CREATE TABLE Clients (
    IdClient INT AUTO_INCREMENT PRIMARY KEY,  -- Identificador único para cada cliente
    ClientName VARCHAR(45),  -- Nome completo do cliente
    ClientAddress VARCHAR(30),  -- Endereço do cliente
    ClientType ENUM('Pessoa Física', 'Pessoa Jurídica') DEFAULT 'Pessoa Física' NOT NULL  -- Tipo de cliente (Pessoa Física ou Jurídica)
);

-- Criação da tabela de Clientes Pessoa Jurídica (PJ)
-- Esta tabela armazena dados específicos de clientes PJ, incluindo CNPJ, Inscrição Estadual (IE) e o nome fantasia da empresa.
CREATE TABLE ClientsPJ (
    IdClientPJ INT AUTO_INCREMENT PRIMARY KEY,  -- Identificador único para cada cliente PJ
    IdClient INT NOT NULL,  -- Referência ao cliente na tabela 'Clients'
    CNPJ CHAR(15) NOT NULL,  -- CNPJ da empresa (formato fixo de 15 caracteres)
    IE VARCHAR(15),  -- Inscrição Estadual (opcional)
    Fantasia VARCHAR(30) NOT NULL,  -- Nome fantasia da empresa
    CONSTRAINT UniqueClientsPJIdClient UNIQUE (IdClient),  -- Garantia de que o 'IdClient' será único nesta tabela
    CONSTRAINT UniqueClientsPJCNPJ UNIQUE (CNPJ),  -- Garantia de que o 'CNPJ' será único
    CONSTRAINT FK_ClientsPJ_Clients FOREIGN KEY (IdClient) REFERENCES Clients(IdClient) ON DELETE CASCADE  -- Chave estrangeira para associar com a tabela 'Clients'
);

-- Criação da tabela de Clientes Pessoa Física (PF)
-- Esta tabela armazena dados específicos de clientes PF, incluindo o CPF.
CREATE TABLE ClientsPF (
    IdClientPF INT AUTO_INCREMENT PRIMARY KEY,  -- Identificador único para cada cliente PF
    IdClient INT NOT NULL,  -- Referência ao cliente na tabela 'Clients'
    CPF CHAR(11) NOT NULL,  -- CPF do cliente (formato fixo de 11 caracteres)
    CONSTRAINT UniqueClientsPFIdClient UNIQUE (IdClient),  -- Garantia de que o 'IdClient' será único nesta tabela
    CONSTRAINT UniqueClientsPFCPF UNIQUE (CPF),  -- Garantia de que o 'CPF' será único
    CONSTRAINT FK_ClientsPF_Clients FOREIGN KEY (IdClient) REFERENCES Clients(IdClient) ON DELETE CASCADE  -- Chave estrangeira para associar com a tabela 'Clients'
);

-- Criação da tabela de Cartões de Clientes
-- A tabela armazena informações sobre os cartões de crédito dos clientes, incluindo o número do cartão, validade e nome do titular.
CREATE TABLE ClientsCard (
    IdClientCard INT AUTO_INCREMENT PRIMARY KEY,  -- Identificador único para cada cartão de cliente
    IdClient INT,  -- Referência ao cliente na tabela 'Clients'
    NumberCard VARCHAR(20) NOT NULL,  -- Número do cartão de crédito
    Validity CHAR(5) NOT NULL,  -- Data de validade do cartão (formato MM/AA)
    Cname VARCHAR(45) NOT NULL,  -- Nome do titular do cartão
    CPF CHAR(11) NOT NULL,  -- CPF do titular do cartão
    CONSTRAINT UniqueClientsCardNumberCard UNIQUE (NumberCard),  -- Garantia de que o número do cartão será único
    CONSTRAINT FK_ClientsCard_Clients FOREIGN KEY (IdClient) REFERENCES Clients(IdClient) ON DELETE SET NULL  -- Chave estrangeira para associar com a tabela 'Clients'
);

-- Criação da tabela de Fornecedores
-- A tabela armazena dados dos fornecedores, incluindo o nome social da empresa e o CNPJ.
CREATE TABLE Supplier (
    IdSupplier INT AUTO_INCREMENT PRIMARY KEY,  -- Identificador único para cada fornecedor
    SocialName VARCHAR(255) NOT NULL,  -- Nome social da empresa fornecedora
    CNPJ CHAR(15) NOT NULL,  -- CNPJ do fornecedor
    CONSTRAINT UniqueCNPJ_Supplier UNIQUE (CNPJ)  -- Garantia de que o CNPJ será único
);

-- Criação da tabela de Produtos
-- A tabela armazena informações sobre os produtos vendidos, incluindo o nome do produto, categoria, preço e fornecedor.
CREATE TABLE Product (
    IdProduct INT AUTO_INCREMENT PRIMARY KEY,  -- Identificador único para cada produto
    Pname VARCHAR(45) NOT NULL,  -- Nome do produto
    Category ENUM('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') NOT NULL,  -- Categoria do produto
    ProductValue FLOAT DEFAULT 10,  -- Valor do produto
    IdSupplier INT NOT NULL,  -- Referência ao fornecedor na tabela 'Supplier'
    CONSTRAINT UniquePName_Product UNIQUE (Pname),  -- Garantia de que o nome do produto será único
    CONSTRAINT FK_Product_Supplier FOREIGN KEY (IdSupplier) REFERENCES Supplier(IdSupplier)  -- Chave estrangeira para associar com a tabela 'Supplier'
);

-- Criação da tabela de Pedidos
-- A tabela armazena informações sobre os pedidos realizados pelos clientes, incluindo status e descrição do pedido.
CREATE TABLE Orders (
    IdOrder INT AUTO_INCREMENT PRIMARY KEY,  -- Identificador único para cada pedido
    IdOrderClient INT NOT NULL,  -- Referência ao cliente que fez o pedido
    OrderStatus ENUM('Cancelado', 'Confirmado', 'Em processamento') DEFAULT 'Em processamento',  -- Status do pedido
    OrderDescription VARCHAR(255),  -- Descrição do pedido
    CONSTRAINT FK_Orders_Client FOREIGN KEY (IdOrderClient) REFERENCES Clients(IdClient)  -- Chave estrangeira para associar com a tabela 'Clients'
);

-- Criação da tabela de Pagamento de Pedidos
-- A tabela armazena informações sobre o pagamento de um pedido, incluindo o valor pago e o cartão de crédito utilizado.
CREATE TABLE OrdersPayment (
    IdOrder INT NOT NULL,  -- Referência ao pedido na tabela 'Orders'
    IdOrderCard INT NOT NULL,  -- Referência ao cartão de crédito utilizado para o pagamento
    OrderValuePayment FLOAT NOT NULL,  -- Valor total do pagamento
    PRIMARY KEY (IdOrder, IdOrderCard),  -- Chave primária composta pelos campos 'IdOrder' e 'IdOrderCard'
    CONSTRAINT FK_OrdersPayment_Orders FOREIGN KEY (IdOrder) REFERENCES Orders(IdOrder) ON DELETE CASCADE,  -- Chave estrangeira para associar com a tabela 'Orders'
    CONSTRAINT FK_OrdersPayment_ClientsCard FOREIGN KEY (IdOrderCard) REFERENCES ClientsCard(IdClientCard)  -- Chave estrangeira para associar com a tabela 'ClientsCard'
);

-- Criação da tabela de Envio de Pedidos
-- A tabela armazena informações sobre o envio dos pedidos, incluindo número de rastreamento, status e valor do envio.
CREATE TABLE OrdersSend (
    IdOrderSend INT AUTO_INCREMENT PRIMARY KEY,  -- Identificador único para cada envio
    IdOrder INT NOT NULL,  -- Referência ao pedido na tabela 'Orders'
    TrackingNo VARCHAR(20) NOT NULL,  -- Número de rastreamento do envio
    SendValue FLOAT NOT NULL DEFAULT 10,  -- Valor do envio
    TrackingStatus ENUM('Aguardando entregador', 'Em deslocamento', 'Entregue', 'Devolvido') NOT NULL DEFAULT 'Aguardando entregador',  -- Status do envio
    CONSTRAINT UniqueTrackingNo_OrdersSend UNIQUE (TrackingNo),  -- Garantia de que o número de rastreamento será único
    CONSTRAINT FK_OrdersSend_Order FOREIGN KEY (IdOrder) REFERENCES Orders(IdOrder) ON DELETE CASCADE  -- Chave estrangeira para associar com a tabela 'Orders'
);

-- Criação da tabela de Localização de Estoque
-- A tabela armazena as localizações de estoque dos produtos, como o estado onde o produto está armazenado.
CREATE TABLE ProductStorageLocation (
    IdProdStorage INT AUTO_INCREMENT PRIMARY KEY,  -- Identificador único para cada localização de estoque
    StorageLocation VARCHAR(45)  -- Localização do estoque (ex: estado)
);

-- Criação da tabela de Estoque de Produtos
-- A tabela armazena a quantidade de produtos disponíveis em cada localização de estoque.
CREATE TABLE ProductStorage (
    IdProdStorage INT NOT NULL,  -- Referência à localização de estoque na tabela 'ProductStorageLocation'
    IdProduct INT NOT NULL,  -- Referência ao produto na tabela 'Product'
    Quantity FLOAT NOT NULL DEFAULT 0,  -- Quantidade disponível no estoque
    PRIMARY KEY (IdProdStorage, IdProduct),  -- Chave primária composta pelos campos 'IdProdStorage' e 'IdProduct'
    CONSTRAINT FK_ProductStorage_ProductStorageLocation FOREIGN KEY (IdProdStorage) REFERENCES ProductStorageLocation(IdProdStorage) ON DELETE CASCADE,  -- Chave estrangeira para associar com a tabela 'ProductStorageLocation'
    CONSTRAINT FK_ProductStorage_Product FOREIGN KEY (IdProduct) REFERENCES Product(IdProduct) ON DELETE CASCADE  -- Chave estrangeira para associar com a tabela 'Product'
);

-- Criação da tabela de Vendedores
-- A tabela armazena informações sobre os
