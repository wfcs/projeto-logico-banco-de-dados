-- crição do banco de dados para o cenário de E-commerce
-- drop database ecommerce; 
create database if not exists ecommerce;
use ecommerce;

-- criar tabela cliente 
create table clients (
	idClient int auto_increment primary key, 
    clientName varchar(45), 
    clientAddress varchar(30),
    clientType enum ('Pessoa Física', 'Pessoa Jurídica') default 'Pessoa Física' not null);

-- criar tabela cliente pj
create table clientsPJ (
	idClientPJ int auto_increment primary key, 
    idClient int not null, 
    CNPJ char(15) not null, 
    IE varchar(15), 
    Fantasia varchar(30) not null,
    constraint unique_clientspj_idclient unique (idClient), 
    constraint unique_clientspj_cnpj unique (CNPJ), 
    constraint fk_clientspj_clients foreign key (idClient) references clients (idClient) 
    on delete cascade); 

-- criar tabela cliente pj
create table clientsPF (
	idClientPF int auto_increment primary key, 
    idClient int not null, 
    CPF char(11) not null, 
    constraint unique_clientspf_idclient unique (idClient), 
    constraint unique_clientspf_cpf unique (CPF), 
    constraint fk_clientspf_clients foreign key (idClient) references clients (idClient) 
    on delete cascade); 

-- criar tabela cliente cartão
create table clientsCard (
	idClientCard int auto_increment primary key, 
    idClient int, 
    numberCard varchar(20) not null, 
    Validity char(5) not null, 
    Cname varchar(45) not null, 
    CPF char(11) not null, 
    constraint unique_clientscard_numbercard unique (numberCard), 
    constraint fk_clientscard_clients foreign key (idClient) references clients (idClient) 
    on delete set null); 

-- criar tabela fornecedor 
create table supplier (
	idSupplier int auto_increment primary key, 
    SocialName varchar(255) not null, 
    CNPJ char(15) not null, 
    constraint unique_cnpj_supplier unique (cnpj)); 
    
-- criar tabela produto 
create table product (
	idProduct int auto_increment primary key, 
    Pname varchar(45) not null, 
    category enum ('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') not null, 
    productValue float default 10, 
    idSupplier int not null, 
    constraint unique_pname_product unique (Pname), 
    constraint fk_product_supplier foreign key (idSupplier) references supplier (idSupplier));

-- criar tabela pedido 
create table orders (
	idOrder int auto_increment primary key, 
    idOrderClient int not null,
	orderStatus enum ('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento', 
    orderDescription  varchar(255), 
    constraint fk_orders_client foreign key (idOrderClient) references clients (idClient)); 

-- criar tabela pedido pagamento 
create table ordersPayment (
	idOrder int not null, 
    idOrderCard int not null,
    orderValuePayment float not null, 
    primary key (idOrder, idOrderCard), 
    constraint fk_orderspayment_orders foreign key (idOrder) references orders (idOrder)
    on delete cascade, 
    constraint fk_orderspayment_clientscard foreign key (idOrderCard) references clientsCard (idClientCard)); 

-- criar tabela pedido entrega 
create table ordersSend (
	idOrderSend int auto_increment primary key, 
    idOrder int not null,
    trackingNo varchar(20) not null, 
    sendValue float not null default 10, 
	trackingStatus enum ('Aguardando entregador', 'Em deslocamento', 'Entregue', 'Devolvido') not null default 'Aguardando entregador', 
    constraint unique_trackingno_ordersSend unique (trackingNo), 
    constraint fk_orderssend_order foreign key (idOrder) references orders (idOrder)
    on delete cascade); 

-- criar tabela estoque local 
create table productStorageLocation (
	idProdStorage int auto_increment primary key, 
    storagelocation  varchar(45));

-- criar tabela estoque 
create table productStorage (
	idProdStorage int not null, 
	idProduct int not null, 
    Quantity float not null default 0, 
    primary key (idProdStorage, idProduct), 
    constraint fk_productstorage_productstoragelocation foreign key (idProdStorage) references productStorageLocation (idProdStorage)
    on delete cascade, 
    constraint fk_productstorage_product foreign key (idProduct) references product (idProduct)
    on delete cascade);

-- criar tabela vendedor 
create table seller (
	idSeller int auto_increment primary key, 
    SocialName varchar(45) not null, 
    CNPJ char(15), 
    CPF char(9), 
    location varchar(45), 
    contact char(11) not null, 
    constraint unique_cnpj_seller unique (cnpj),  
	constraint unique_cpf_seller unique (cpf)); 

-- criar tabela produto / vendedor 
create table productSeller (
	idPseller int, 
	idPproduct int,
    prodQuantity int default 0, 
    primary key (idPseller, idPproduct), 
    constraint fk_product_seller foreign key (idPSeller) references seller (idseller),  
	constraint fk_product_product foreign key (idPproduct) references Product (idProduct)); 

-- criar tabela produto / vendedor 
create table orderProduct (
	idOrder int, 
	idProduct int,
    Quantity int, 
    primary key (idOrder, idProduct), 
    constraint ck_quantity_orderproduct check (Quantity > 0), 
    constraint fk_orderproduct_order foreign key (idOrder) references orders (idOrder),  
	constraint fk_orderproduct_product foreign key (idProduct) references Product (idProduct)); 

show tables;

desc clients;
insert 	into clients (clientName, clientAddress, clientType)
		values 	('Cliente 01', 'Rua 5, nr 1 - PR', 'Pessoa Física'), 
				('Cliente 02', 'Rua 895, nr 1 - PR', 'Pessoa Física'), 
                ('Cliente 03', 'Rua 5, nr 1 - PR', 'Pessoa Física'), 
                ('Cliente 04', 'Rua 5, nr 1 - PR', 'Pessoa Física'), 
                ('Cliente 05', 'Rua 5, nr 1 - PR', 'Pessoa Física'), 
                ('Cliente 06', 'Rua 5, nr 1 - PR', 'Pessoa Juridica'), 
                ('Cliente 07', 'Rua 5, nr 1 - PR', 'Pessoa Juridica'), 
                ('Cliente 08', 'Rua 5, nr 1 - PR', 'Pessoa Juridica'), 
                ('Cliente 09', 'Rua 5, nr 1 - PR', 'Pessoa Juridica'), 
                ('Cliente 10', 'Rua 5, nr 1 - PR', 'Pessoa Juridica'); 

select * from clients; 

desc clientsPF;
insert 	into clientsPF (idClient, CPF)
		values 	(1, '12345678901'), 
                (2, '12345678902'), 
                (3, '12345678903'), 
                (4, '12345678904'), 
                (5, '12345678905');
select * from clientsPF;

desc clientsPJ;
insert 	into clientsPJ (idClient, CNPJ, IE, Fantasia)
		values 	(6, '123456789012341', null, 'Rede desconto especial'), 
                (7, '123456789012342', null, 'Rede desconto especial'), 
                (8, '123456789012343', null, 'Fantasia 3'), 
                (9, '123456789012344', '123456789', 'Cliente classe a'), 
                (10, '123456789012345', null, 'Rede desconto especial');
select * from clientsPJ;

desc clientsCard;
insert 	into clientsCard (idClient, numberCard, Validity, Cname, CPF)
		values 	(1, '5240123456789012301', '07/25', 'Nome 01', '00012565488'), 
                (1, '7240123456789012302', '06/26', 'Nome 01', '00012565488'), 
                (2, '7240123456789012303', '06/26', 'Nome 02', '00022565488'), 
                (3, '7240123456789012304', '06/26', 'Nome 03', '00032565488'), 
                (4, '7240123456789012305', '06/26', 'Nome 04', '00042565488'), 
                (5, '7240123456789012306', '06/26', 'Nome 05', '00052565488'), 
                (6, '7240123456789012307', '06/26', 'Nome 06', '00062565488'), 
                (7, '7240123456789012308', '06/26', 'Nome 07', '00072565488'), 
                (8, '7240123456789012309', '06/26', 'Nome 08', '00082565488'), 
                (9, '7240123456789012221', '06/26', 'Nome 09', '00092565488'), 
                (9, '5240123456789012231', '06/26', 'Nome 09', '00092565488'), 
                (9, '3340123456789012241', '06/26', 'Nome 09', '00092565488');
select * from clientsCard;

desc supplier;
insert 	into supplier (SocialName, CNPJ)
		values 	('Fornecedor A', '000125654881345'), 
                ('Fornecedor B', '000125654881367'), 
                ('Fornecedor C', '000125654881389');
select * from supplier;

desc product;
insert 	into product (Pname, category, productValue, idSupplier)
		values 	('Produto A', 'Eletrônico', 150, 1), 
                ('Produto B', 'Eletrônico', 450, 1), 
                ('Produto C', 'Brinquedos', 150, 1), 
                ('Produto D', 'Brinquedos', 50, 1), 
                ('Produto E', 'Vestimenta', 79.9, 2), 
                ('Produto F', 'Brinquedos', 72.5, 2), 
                ('Produto G', 'Brinquedos', 50, 2), 
                ('Produto H', 'Alimentos', 7.5, 3), 
                ('Produto I', 'Alimentos', 15.66, 3), 
                ('Produto J', 'Alimentos', 45, 3); 
select * from product;

desc productstoragelocation;
insert 	into productstoragelocation (storagelocation)
		values 	('PR'), 
                ('RS'), 
                ('SC');
select * from productstoragelocation;

desc productstorage;
insert 	into productstorage (idProdStorage, idProduct, Quantity)
		values 	(1, 1, 30), 
                (1, 2, 30), 
                (1, 3, 30), 
                (1, 4, 30), 
                (1, 5, 30), 
                (1, 6, 30), 
                (1, 7, 30), 
                (1, 8, 30), 
                (2, 3, 30), 
                (2, 4, 30), 
                (2, 5, 30), 
                (2, 6, 30), 
                (2, 7, 30), 
                (2, 8, 30),
                (3, 2, 30), 
                (3, 3, 30), 
                (3, 4, 30), 
                (3, 5, 30);
select * from productstorage;

desc orders;
insert 	into orders (idOrderClient, orderStatus, orderDescription)
		values 	(1, 'Em processamento', 'Pedido 1'), 
                (1, 'Cancelado', 'Pedido 2'), 
                (1, 'Cancelado', 'Pedido 3'), 
                (1, 'Confirmado', 'Pedido 4'), 
                (3, 'Confirmado', 'Pedido 1'), 
                (4, 'Cancelado', 'Pedido 1'), 
                (5, 'Em processamento', 'Pedido 1'), 
                (8, 'Cancelado', 'Pedido 1'), 
                (8, 'Cancelado', 'Pedido 2'), 
                (8, 'Confirmado', null), 
                (9, 'Confirmado', null), 
                (9, 'Confirmado', 'Pedido 1'), 
                (10, 'Confirmado', 'Pedido 1');
select * from orders;

desc orderproduct;
insert 	into orderproduct (idOrder, idProduct, Quantity)
		values 	(1, 1, 1), 
                (1, 2, 1), 
                (1, 3, 1), 
                (1, 4, 1), 
                (1, 5, 1), 
                (1, 6, 1), 
                (1, 7, 1), 
                (2, 2, 1), 
                (2, 3, 1), 
                (3, 4, 1), 
                (3, 5, 10), 
                (3, 6, 9), 
                (4, 7, 8), 
                (5, 2, 1), 
                (7, 3, 1), 
                (7, 4, 1), 
                (7, 5, 7), 
                (8, 6, 6), 
                (8, 7, 5), 
                (9, 2, 1), 
                (10, 3, 1), 
                (11, 4, 1), 
                (12, 5, 4), 
                (13, 6, 3), 
                (13, 7, 2);
select * from orderproduct;

desc orderspayment;
insert 	into orderspayment (idOrder, idOrderCard, orderValuePayment) 
		select o.idorder, min(cc.idClientCard) as idOrderCard, round(sum(op.quantity*p.productvalue), 2) as orderValuePayment 
          from orders o 
          inner join orderproduct op on o.idOrder = op.idOrder 
          inner join product p on op.idproduct = p.idproduct 
          inner join clients c on o.idorderclient = c.idClient 
          inner join clientscard cc on c.idClient = cc.idClient 
		where o.orderstatus <> 'Cancelado'
		group by o.idorder;
select * from orderspayment;

desc orderssend;
insert 	into orderssend (idOrder, trackingNo, sendValue, trackingStatus)
		select o.idorder, 12345678955 + o.idorder as trackingNo, 
               case when round(sum(op.quantity*p.productvalue)*0.03, 2) < 10 
                    then 10 
                    else round(sum(op.quantity*p.productvalue)*0.03, 2) 
					end as sendValue, 
			   case when o.idorder in (1,2,8)
				    then 'Em deslocamento'
                    when o.idorder in (9, 7)
                    then 'Entregue' 
                    else 'Aguardando entregador' 
                    end as trackingStatus
          from orders o 
          inner join orderproduct op on o.idOrder = op.idOrder 
          inner join product p on op.idproduct = p.idproduct 
		where o.orderstatus <> 'Cancelado'
		group by 1, 2;
select * from orderssend;

show tables;

select c.clientname, c.clienttype, o.idorder, o.orderstatus 
  from orders o, clients c 
where o.idorderclient = c.idclient
order by c.clientname, o.orderstatus;

select o.orderstatus, count(*) as qtdorders 
  from orders o 
group by o.orderstatus
order by o.orderstatus;

select o.idorder, o.orderstatus, os.trackingstatus, os.sendvalue 
  from orders o 
  left join orderssend os on o.idorder = os.idorder 
order by o.orderstatus;

select s.socialname as fornecedor, p.category, c.clienttype, sum(op.quantity) as quantidade, round(sum(op.quantity*p.productvalue),2) as valortotal,
       round(sum(op.quantity*p.productvalue),2) / sum(op.quantity) as valormediounitario 
  from orders o 
  inner join clients c on o.idorderclient = c.idclient
  inner join orderproduct op on o.idorder = op.idorder
  inner join product p on op.idproduct = p.idproduct
  inner join supplier s on p.idsupplier = s.idsupplier
group by s.socialname, p.category, c.clienttype
having round(sum(op.quantity*p.productvalue),2) / sum(op.quantity) > 80
;
