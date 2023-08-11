-- creating database
CREATE DATABASE ecommerce;

-- creating client table
CREATE TABLE client(
	clientid SERIAL PRIMARY KEY,
	firstname VARCHAR(10),
	middlename CHAR(3),
	lastname VARCHAR(20),
	cpf char(11) NOT NULL,
	address VARCHAR(30),
	CONSTRAINT unique_client_cpf UNIQUE (cpf)
);

-- creating an enum type for the product table
CREATE TYPE product_category AS ENUM('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis');

-- creating product table
CREATE TABLE product(
	productid SERIAL PRIMARY KEY,
	productname VARCHAR(10) NOT NULL,
	kidsclassification BOOLEAN DEFAULT FALSE,
	category product_category NOT NULL,
	rating FLOAT DEFAULT 0,
	dimensions VARCHAR(10),
	address VARCHAR(30)
);
-- creating an enum type for the orders table
CREATE TYPE order_status AS ENUM('Cancelado', 'Confirmado', 'Em processamento');

-- creating orders table
CREATE TABLE orders(
	orderid SERIAL PRIMARY KEY,
	clientorderid INT,
	orderstatus order_status DEFAULT 'Em processamento',
	orderdescription VARCHAR(255),
	freight FLOAT DEFAULT 10,
	CONSTRAINT fk_client_order FOREIGN KEY (clientorderid) REFERENCES client(clientid)
);

-- creating product storage table
CREATE TABLE productstorage (
	productstorageid SERIAL PRIMARY KEY,
	storagelocation VARCHAR(255),
	quantity INT DEFAULT 0
);

-- creating supplier table
CREATE TABLE supplier (
	supplierid SERIAL PRIMARY KEY,
	corporatename VARCHAR(255) NOT NULL,
	cnpj CHAR(15) NOT NULL,
	contact CHAR(11) NOT NULL,
	CONSTRAINT unique_supplier_cnpj UNIQUE (cnpj)
);

-- creating vendor table
CREATE TABLE vendor (
	vendorid SERIAL PRIMARY KEY,
	corporatename VARCHAR(255) NOT NULL,
	location VARCHAR(255),
	tradingname VARCHAR(255),
	contact CHAR(11) NOT NULL,
	cnpj CHAR(15) NOT NULL,
	cpf CHAR(11),
	CONSTRAINT unique_vendor_cnpj UNIQUE(cnpj),
	CONSTRAINT unique_vendor_cpf UNIQUE(cpf)
);

-- creating product vendor table
CREATE TABLE productvendor(
	vendorid INT,
	productid INT,
	productquantity INT DEFAULT 1,
	PRIMARY KEY(vendorid, productid),
	CONSTRAINT fk_product_vendor FOREIGN KEY (vendorid) REFERENCES vendor(vendorid),
	CONSTRAINT fk_product_product FOREIGN KEY (productid) REFERENCES product(productid)
);

-- creating enum type for product order table

CREATE TYPE product_status AS ENUM('Disponível', 'Sem estoque');

-- creating product order table

CREATE TABLE productorder(
	productid INT,
	orderproductid INT,
	productquantity INT DEFAULT 1,
	productstatus product_status DEFAULT 'Disponível',
	PRIMARY KEY(productid, orderproductid),
	CONSTRAINT fk_product_vendor FOREIGN KEY(productid) REFERENCES product(productid),
	CONSTRAINT fk_product_product FOREIGN KEY(orderproductid) REFERENCES orders(orderid)
);