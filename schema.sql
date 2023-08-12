--ANDREA DI VIA 4486604*/





-- PARTE 2
-- CREAZIONE SCHEMA E POPOLAMENTO  


/* Oltre ai vincoli CHECK già implementati, avrei introdotto i seguenti vincoli con CREATE ASSERTION ma apparentemente POSTGRE non lo supporta

1)	per ogni casella SERPENTE o SCALA il valore NDESTINAZIONE deve essere noto. 
Io lo esprimerei in questo modo, ma ho trovato su internet che Postgre non supporta il comando “create assertion”

CREATE ASSERTION destinazione
CHECK ( NOT EXISTS ( SELECT * FROM CASELLA
			WHERE tipo=’SERPENTE’ OR tipo=’SCALA’ AND ndestinazione IS NULL)
		);
2)	Per ogni quiz non può esistere un task con lo stesso testo e viceversa.

CREATE ASSERTION 
CHECK( NOT EXISTS( SELECT * FROM quiz, task WHERE quiz.testo=task.testo));


3)	La casella serpente ha una casella destinazione precedente al proprio numero

CREATE ASSERTION serpente
CHECK ( NOT EXISTS( SELECT * FROM CASELLA WHERE tipo=’serpente’ AND ndestinazione> numero);

4)	La casella scala ha una casella destinazione successiva al proprio numero

CREATE ASSERTION scala
CHECK ( NOT EXISTS( SELECT * FROM CASELLA WHERE tipo=’scala’ AND ndestinazione< numero);


*/

CREATE schema online_challenge;
set search_path to online_challenge;


--PLANCIA

CREATE TABLE PLANCIA 
(
	idPlancia NUMERIC(20) PRIMARY KEY,
	sfondo VARCHAR(20) NOT NULL,
	posizione1 VARCHAR(20),
	posizione2 VARCHAR(20),
	posizione3 VARCHAR(20)
);



INSERT INTO PLANCIA VALUES 
	(1, 'sfondo1', '(x1,y1)', '(x2,y2)', '(x3,y3)'),
	(2, 'sfondo2', '(x1,y1)', '(x2,y2)', '(x3,y3)'),
	(3, 'sfondo3', '(z1,w1)', '(z2,w2)', '(z3,w3)'),
	(4, 'sfondo2', '(x1,y1)', '(x2,y2)', '(x3,y3)');



--SET ICONE

CREATE TABLE SET_ICONE
(
	nome VARCHAR(20) PRIMARY KEY
);

INSERT INTO SET_ICONE VALUES
	('savana'),
	('antartide'),
	('emoji');



--GIOCO


CREATE TABLE  GIOCO
	(
		idGioco NUMERIC(20) PRIMARY KEY,
		idPlancia NUMERIC(20) NOT NULL REFERENCES PLANCIA(idPlancia)
								ON DELETE NO ACTION 
								ON UPDATE CASCADE,  
		nome VARCHAR(20) NOT NULL REFERENCES SET_ICONE(nome)
							ON DELETE NO ACTION 
							ON UPDATE CASCADE  
	);


INSERT INTO GIOCO VALUES
	(1, 1, 'savana'),
	(2, 1, 'savana'),
	(3, 3, 'antartide'),
	(4, 4, 'antartide');



--ICONE


CREATE TABLE ICONE 
(
	dimensione VARCHAR(20) NOT NULL,
	nome VARCHAR(20) PRIMARY KEY
);


INSERT INTO ICONE VALUES
	('3X3', 'leone'),
	('3x3', 'zebra'),
	('3x3', 'pinguino'),
	('3x3', 'smile' ),
	('3x3', 'anger'),
	('3x3', 'foca');



-- TEMA ICONE


CREATE TABLE TEMA_ICONE
(
	nome_set VARCHAR(20) REFERENCES SET_ICONE(nome) 
					ON DELETE NO ACTION 
					ON UPDATE CASCADE, 
	nome_icona VARCHAR(20) REFERENCES ICONE(nome) 
					ON DELETE NO ACTION 
					ON UPDATE CASCADE, 

	PRIMARY KEY(nome_set, nome_icona)
);



INSERT INTO TEMA_ICONE VALUES
('savana', 'leone'),
('savana', 'smile'),
('savana', 'foca'),
('savana', 'zebra'),
('antartide', 'pinguino'),
('antartide', 'foca');




--CASELLA


CREATE TABLE CASELLA
(
	numero NUMERIC(4)  CHECK(numero>=0),
	idGioco NUMERIC(20)  REFERENCES GIOCO(idGioco)
							ON DELETE NO ACTION 
							ON UPDATE CASCADE ,
	video VARCHAR(20),
	ndestinazione NUMERIC(4) CHECK(ndestinazione>=0),
	coordinata_x NUMERIC(3) NOT NULL, 
	coordinata_y NUMERIC(3) NOT NULL,
	tipologia VARCHAR(20) NOT NULL 
							CHECK(tipologia IN ('scala', 'serpente', 'normale')),
	PRIMARY KEY(numero, idGioco),
	UNIQUE(coordinata_y, coordinata_x, idGioco)
);

INSERT INTO CASELLA VALUES
--(-1, 1, 'gattini', NULL, 2,3, 'normale'),
(0, 1, 'introduzione', NULL, -4, 0, 'normale'),
(5, 1, 'gattini', 2, 10, 10, 'serpente'),
(20, 1, 'congratulazioni', NULL, 20,20, 'normale'),
(20, 2,'congratulazioni', NULL, 20,20, 'normale'),
(25, 4, 'congratulazioni', NULL, 25,25, 'normale'),
(20, 3, 'congratulazioni', NULL, 20,20, 'normale'),
(0,2, 'introduzione', NULL, 0,0, 'normale'),
(5, 2, 'cagnolini', 7, 10, 10, 'scala'),
(6, 2, NULL, 7, 4, 4, 'scala' ),
(0,3, 'introduzione', NULL, 0,0, 'normale'),
(0, 4, 'introduzione', NULL, -5, -5, 'normale'),
(7, 4, NULL, 0, 0,0, 'serpente'),
(7, 3, 'storia', NULL, 2, 6, 'normale'),
(12, 3, NULL, NULL, 2, 2, 'normale'),
(15, 4, NULL, NULL, 5,5,'normale'),
(15, 2, NULL, NULL, 5, 5,'normale'),
(3, 2, NULL, NULL, 4, 3, 'normale'),
(9, 1, 'elettronica', NULL, 9, 9, 'normale'),
--(1, 3, 'pappagalli', NULL, NULL, 2, 'normale' )
--(1, 3, 'pappagalli', NULL, 3, 2, NULL)
(2,1, NULL, NULL, 2,2, 'normale'),
(3,1, NULL, NULL, 3,3, 'normale');





--DADI


CREATE TABLE DADI
(
	idDado NUMERIC(20) PRIMARY KEY,
	valore_min NUMERIC(2) NOT NULL CHECK(valore_min >= 1),
	valore_max NUMERIC(2) NOT NULL CHECK(valore_max <=6),

	CHECK(valore_min < valore_max)

);

INSERT INTO DADI VALUES
(1, 1, 3),
(2, 1, 4),
(3, 1,6),
(4, 2, 6);
--(5,0,1),
--(6,4,4),
--(7,5,7),
--(8, 3,2);




-- ALEATORIA



CREATE TABLE ALEATORIA
(
	idDado NUMERIC(20)  REFERENCES DADI(idDado)
							ON DELETE NO ACTION 
							ON UPDATE CASCADE,
	idGioco NUMERIC(20) REFERENCES GIOCO(idGioco)
							ON DELETE NO ACTION 
							ON UPDATE CASCADE,
	PRIMARY KEY(idDado, idGioco)
);

INSERT INTO ALEATORIA VALUES
(1,2),
(3,2),
(4,2),
(1,3),
(4,1),
(2,4);






--LANCI


CREATE TABLE LANCI 
(
	idDado 	NUMERIC(20)  REFERENCES DADI(idDado)
							ON DELETE NO ACTION 
							ON UPDATE CASCADE,
	numero NUMERIC(4)  CHECK(numero>=0),
	idGioco NUMERIC(20),
	valore NUMERIC(2) NOT NULL, --valore deve essere compreso tra valore minimo e valore massimo
	PRIMARY KEY(idDado, numero, idGioco),
	FOREIGN KEY(numero, idGioco) REFERENCES CASELLA(numero,idGioco)
											ON DELETE NO ACTION 
											ON UPDATE CASCADE

);

INSERT INTO LANCI VALUES
(1,3,2, 2),
(2, 15,4, 3),
(1, 12,3, 3),
(3,0,2, 4),
(4,0,1, 5),
(4, 0, 2, 1),
(1, 0, 2, 1),
(2, 0, 4, 2),
(1, 7, 3, 3),
(3, 15,2,6 );







--QUIZ


CREATE TABLE QUIZ
(
	testo VARCHAR(100) PRIMARY KEY,
	tempo_risposta NUMERIC(3) NOT NULL CHECK(tempo_risposta>0), 
	immagine VARCHAR(20)
);

INSERT INTO QUIZ VALUES
('quando è morto napoleone?', 300, 'napoleone.jpg'),
('quale è il perimetro di questo rettangolo in cm?', 150, 'rettangolo.jpg'),
('in quale direzione sorge il sole?', 150, NULL),
('chi ha inventato il primo computer?', 400, NULL ),
('a quale funzione è approssimabile sen(x) in un intorno di 0?', 600, NULL);







--INCLUDE QUIZ



CREATE TABLE INCLUDE_QUIZ
(
	numero NUMERIC(4) CHECK(numero>0),
	idGioco NUMERIC(20),
	testo VARCHAR(100) NOT NULL REFERENCES QUIZ(testo) 
							ON DELETE NO ACTION 
							ON UPDATE CASCADE,
	PRIMARY KEY(numero, idGioco),
	FOREIGN KEY(numero, idGioco) REFERENCES CASELLA(numero, idGioco)
										ON DELETE NO ACTION 
										ON UPDATE CASCADE
);


INSERT INTO INCLUDE_QUIZ VALUES
(3,2, 'a quale funzione è approssimabile sen(x) in un intorno di 0?'),
(15,2, 'in quale direzione sorge il sole?'),
(15,4, 'in quale direzione sorge il sole?'),
(7,3, 'quando è morto napoleone?');





--RISPOSTE


CREATE TABLE RISPOSTE 
(
	testo VARCHAR(100) PRIMARY KEY,
	punteggio NUMERIC(4) NOT NULL CHECK(punteggio>0), 
	immagine VARCHAR(20)
);

INSERT INTO RISPOSTE VALUES
('2001', 1, NULL ),
('1769', 5, NULL),
('1789', 4, NULL),
('1815', 3, NULL),
('1650', 2, NULL),
('est', 1, NULL),
('ovest', 2,  NULL),
('sud', 3, NULL),
('nord', 4, NULL),
('log(x)', 5, 'grafico1'),
('e^x', 6, 'grafico2'),
('x', 10, 'grafico3'),
('cos(x)', 7, 'grafico4'),
('x^2', 8, 'grafico5'),
('-x', 9, 'grafico6'),
('2x', 8, 'grafico7'),
('x+1', 5, 'grafico8'),
('tan(x)', 4, 'grafico9'),
('thomas edison', 3, 'edison.jpg'),
('charles babbage', 5, 'babbage.jpg'),
('nikola tesla', 2,'tesla.jpg'),
('alan turing', 4, 'turing.jpg'),
('alessandro volta', 1, 'volta.jpg');






--COMBINAZIONE RISPOSTE

CREATE TABLE COMBINAZIONI_RISPOSTE
(
	testo_quiz VARCHAR(100) REFERENCES QUIZ(testo)
							ON DELETE NO ACTION 
							ON UPDATE CASCADE,
	testo_risposte VARCHAR(100) REFERENCES RISPOSTE(testo)
							ON DELETE NO ACTION 
							ON UPDATE CASCADE,
	correttezza BOOLEAN DEFAULT FALSE NOT NULL,

	PRIMARY KEY(testo_quiz, testo_risposte)
);

INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('in quale direzione sorge il sole?', 'ovest');
INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('in quale direzione sorge il sole?', 'est', TRUE);
INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('in quale direzione sorge il sole?', 'nord');
INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('in quale direzione sorge il sole?', 'sud');
INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('a quale funzione è approssimabile sen(x) in un intorno di 0?','log(x)' );
INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('a quale funzione è approssimabile sen(x) in un intorno di 0?', 'e^x');
INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('a quale funzione è approssimabile sen(x) in un intorno di 0?', 'x', TRUE);
INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('a quale funzione è approssimabile sen(x) in un intorno di 0?', 'cos(x)');
INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('a quale funzione è approssimabile sen(x) in un intorno di 0?', 'x^2');
INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('a quale funzione è approssimabile sen(x) in un intorno di 0?', '-x');
INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('a quale funzione è approssimabile sen(x) in un intorno di 0?', '2x');
INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('a quale funzione è approssimabile sen(x) in un intorno di 0?', 'x+1');
INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('a quale funzione è approssimabile sen(x) in un intorno di 0?', 'tan(x)');
INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('quando è morto napoleone?', '2001');
INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('quando è morto napoleone?', '1769', TRUE);
INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('quando è morto napoleone?', '1789');
INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('quando è morto napoleone?', '1815');
INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('quando è morto napoleone?', '1650');
INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('chi ha inventato il primo computer?', 'alessandro volta');
INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('chi ha inventato il primo computer?', 'charles babbage', TRUE);
INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('chi ha inventato il primo computer?', 'alan turing', TRUE);
INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('chi ha inventato il primo computer?', 'nikola tesla');
INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('chi ha inventato il primo computer?', 'thomas edison');
INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('quale è il perimetro di questo rettangolo in cm?', '2001');
INSERT INTO COMBINAZIONI_RISPOSTE VALUES
('quale è il perimetro di questo rettangolo in cm?', '1789', TRUE);





--TASK


CREATE TABLE TASK
(
	testo VARCHAR(100) PRIMARY KEY,
	tempo_risposta NUMERIC(4) NOT NULL CHECK(tempo_risposta >0),
	punteggio NUMERIC(4) NOT NULL CHECK(punteggio>0)
);


INSERT INTO TASK VALUES
('dimostrare il teorema di Weierstrass', 1800, 10),
('spiegare quale cavo occorre staccare per disinnescare la bomba', 1800, 10),
('costruire una base di dati per i film noleggiati', 900, 5);





--INCLUDE TASK


CREATE TABLE INCLUDE_TASK
(
	numero NUMERIC(4) CHECK(numero>0),

	idGioco NUMERIC(20),
	testo VARCHAR(100) NOT NULL REFERENCES TASK(testo)
							ON DELETE NO ACTION 
							ON UPDATE CASCADE,
	FOREIGN KEY(numero, idGioco) REFERENCES CASELLA(numero, idGioco) 
							ON DELETE NO ACTION 
							ON UPDATE CASCADE
);


INSERT INTO INCLUDE_TASK VALUES
(9,1, 'spiegare quale cavo occorre staccare per disinnescare la bomba'),
(12,3, 'costruire una base di dati per i film noleggiati');






--RISOLUZIONI

CREATE TABLE RISOLUZIONI
(
	testo VARCHAR(100) PRIMARY KEY,
	validato BOOLEAN DEFAULT FALSE NOT NULL,
	testo_task VARCHAR(100) REFERENCES TASK(testo)
							ON DELETE NO ACTION 
							ON UPDATE CASCADE
);


INSERT INTO RISOLUZIONI VALUES
('lo schema del sottoscritto', FALSE, 'costruire una base di dati per i film noleggiati'),
('lo schema delle prof', TRUE, 'costruire una base di dati per i film noleggiati'),
('il cavo rosso è sempre la risposta giusta', FALSE, 'spiegare quale cavo occorre staccare per disinnescare la bomba'),
('bisogna osservare i morsetti', TRUE, 'spiegare quale cavo occorre staccare per disinnescare la bomba');






--SFIDA


CREATE TABLE SFIDA
(
	data DATE,
	ora TIME,
	durata_max NUMERIC(4) NOT NULL CHECK(durata_max>0), 
	moderata BOOLEAN DEFAULT FALSE NOT NULL,
	idGioco NUMERIC(20) REFERENCES GIOCO(idGioco)
							ON DELETE NO ACTION 
							ON UPDATE CASCADE,
	PRIMARY KEY( data, ora, idGioco)
);


INSERT INTO SFIDA VALUES
('10/06/21', '15:00', 3600, TRUE, 1),
('10/06/21', '15:00', 3600, FALSE, 2),
('10/06/21', '16:15', 3600, FALSE, 1),
('11/06/21', '15:00', 1800, FALSE, 2),
('12/06/21', '9:00', 1800, TRUE, 3),
('13/06/21', '9:00', 1800, TRUE, 3),
('11/06/21', '9:00', 3600, FALSE,3);








--SQUADRA

CREATE TABLE SQUADRA
(
	nome VARCHAR(20),
	icona VARCHAR(20) NOT NULL,
	ndadi NUMERIC(20) NOT NULL CHECK(ndadi>=0),
	data DATE,
	ora TIME,
	idGioco NUMERIC(20),
	PRIMARY KEY(nome, data, ora, idGioco),
	UNIQUE(icona, data, ora, idGioco),
	FOREIGN KEY(data, ora, idGioco) REFERENCES SFIDA(data, ora, idGioco)
	                    	ON DELETE NO ACTION 
							ON UPDATE CASCADE
);

INSERT INTO SQUADRA VALUES
('grifondoro', 'grifone', 0, '10/06/21', '15:00', 1),
('serpeverde', 'serpe', 0, '10/06/21', '15:00', 1),
('tassorosso', 'tasso', 2, '11/06/21', '15:00', 2),
('corvonero', 'corvo', 5, '11/06/21', '15:00', 2),
('grifondoro', 'grifone', 1, '10/06/21', '16:15', 1),
('genoani', 'grifone', 1, '12/06/21', '9:00', 3),
--('genoani', 'grifone', 1, '10/06/21', '16:15', 1),
--('grifondoro', 'sole', 0, '10/06/21', '16:15', 1 ),
('grifondoro', 'sole', 2, '11/06/21', '15:00', 2 ),
('genoani', 'grifone', 1, '10/06/21', '15:00', 2),
('sampdoriani', 'marinaio', 1, '12/06/21', '9:00', 3),
('grifondoro', 'sole',0, '11/06/21','9:00', 3),
('tassorosso', 'tasso', 0, '10/06/21', '15:00', 2),
('serpeverde', 'serpe', 0, '10/06/21', '16:15', 1),
('corvonero', 'corvo', 0, '11/06/21', '9:00', 3);







--RISPOSTE DATE

CREATE TABLE RISPOSTE_DATE
(
	testo VARCHAR(100) REFERENCES RISPOSTE(testo)
						ON DELETE NO ACTION 
						ON UPDATE CASCADE,
	icona VARCHAR(20) NOT NULL,
	nome VARCHAR(20),
	data DATE,
	ora TIME,
	idGioco NUMERIC(20),
	tempo NUMERIC(3) NOT NULL CHECK(tempo>0), 
	voti NUMERIC(4) CHECK(voti>=0),
	PRIMARY KEY( testo, nome, data, ora, idGioco),
	UNIQUE( testo, icona, data, ora, idGioco),
	FOREIGN KEY(nome, data, ora, idGioco) REFERENCES SQUADRA(nome, data, ora, idGioco)
	                    							ON DELETE NO ACTION 
													ON UPDATE CASCADE,
	FOREIGN KEY(icona, data, ora, idGioco) REFERENCES SQUADRA(icona, data, ora, idGioco)
	                    							ON DELETE NO ACTION 
													ON UPDATE CASCADE

);


INSERT INTO RISPOSTE_DATE VALUES
('2001', 'serpe', 'serpeverde', '10/06/21', '15:00', 1, 60, NULL),
('1789', 'grifone', 'grifondoro', '10/06/21', '15:00', 1, 87, NULL),
('x', 'grifone', 'grifondoro', '10/06/21', '15:00', 1, 300, NULL),
('x', 'serpe', 'serpeverde', '10/06/21', '15:00', 1, 200, NULL),
('nikola tesla', 'serpe', 'serpeverde', '10/06/21', '15:00', 1, 60, NULL),
('est', 'grifone', 'grifondoro', '10/06/21', '15:00', 1, 300, NULL),
('alessandro volta', 'grifone', 'grifondoro', '10/06/21', '16:15', 1, 97, 0),
('nikola tesla', 'grifone', 'grifondoro', '10/06/21', '16:15', 1, 80, 2),
('alan turing', 'grifone', 'grifondoro', '10/06/21', '16:15', 1, 87, 3),
('alan turing', 'sole', 'grifondoro', '11/06/21', '15:00', 2, 67,1 ),
('charles babbage', 'sole', 'grifondoro', '11/06/21', '15:00', 2, 40, 1 ),
('ovest', 'tasso', 'tassorosso', '11/06/21', '15:00', 2, 40, 1 ),
('est', 'tasso', 'tassorosso', '11/06/21', '15:00', 2, 40, 4 ),
('1769', 'corvo', 'corvonero', '11/06/21', '15:00', 2, 450, 5),
('x^2', 'grifone', 'genoani', '10/06/21', '15:00', 2, 450, 5);







--RISOLUZIONI DATE


CREATE TABLE RISOLUZIONI_DATE	
(
	testo VARCHAR(100) REFERENCES RISOLUZIONI(testo)
							ON DELETE NO ACTION 
							ON UPDATE CASCADE,
	tempo NUMERIC(3) NOT NULL CHECK(tempo>0),
	icona VARCHAR(20) NOT NULL,
	nome VARCHAR(20),
	data DATE,
	ora TIME,
	idGioco NUMERIC(20),
	PRIMARY KEY (testo, nome, data, ora, idGioco),
	UNIQUE( testo, icona, data, ora, idGioco),
	FOREIGN KEY(nome, data, ora, idGioco) REFERENCES SQUADRA(nome, data, ora, idGioco)
	                    							ON DELETE NO ACTION 
													ON UPDATE CASCADE,
	FOREIGN KEY(icona, data, ora, idGioco) REFERENCES SQUADRA(icona, data, ora, idGioco)
	                    							ON DELETE NO ACTION 
													ON UPDATE CASCADE


);



INSERT INTO RISOLUZIONI_DATE VALUES	
('lo schema del sottoscritto', 900, 'sole', 'grifondoro', '11/06/21', '15:00', 2 ),
('lo schema del sottoscritto', 900, 'serpe', 'serpeverde', '10/06/21', '15:00', 1 ),
('lo schema delle prof', 300, 'grifone', 'grifondoro', '10/06/21', '16:15', 1 ),
('bisogna osservare i morsetti', 450, 'serpe', 'serpeverde', '10/06/21', '15:00', 1 ),
('il cavo rosso è sempre la risposta giusta', 10, 'marinaio', 'sampdoriani', '12/06/21', '9:00', 3);









--PARTECIPAZIONE


CREATE TABLE PARTECIPAZIONE
(	
	nome VARCHAR(20),
	icona VARCHAR(20) NOT NULL,
	data DATE,
	ora TIME,
	idGioco NUMERIC(20),
	PRIMARY KEY( idGioco, data, ora, nome),
	UNIQUE( idGioco, data, ora, icona),
	FOREIGN KEY(nome, idGioco, data, ora) REFERENCES SQUADRA(nome,idGioco, data, ora)
											ON DELETE NO ACTION 
											ON UPDATE CASCADE,
	FOREIGN KEY(icona, idGioco, data, ora) REFERENCES SQUADRA(icona,idGioco, data, ora)
											ON DELETE NO ACTION 
											ON UPDATE CASCADE


);


INSERT INTO PARTECIPAZIONE VALUES
('grifondoro', 'grifone', '10/06/21', '15:00', 1),
('serpeverde', 'serpe',  '10/06/21', '15:00', 1),
('tassorosso', 'tasso', '11/06/21', '15:00', 2),
('corvonero', 'corvo', '11/06/21', '15:00', 2),
('grifondoro', 'grifone', '10/06/21', '16:15', 1),
('serpeverde', 'serpe', '10/06/21', '16:15', 1),
('genoani', 'grifone', '12/06/21', '9:00', 3),
('grifondoro', 'sole', '11/06/21', '15:00', 2 ),
('sampdoriani', 'marinaio', '12/06/21', '9:00', 3),
('genoani', 'grifone', '10/06/21', '15:00', 2),
('tassorosso', 'tasso', '10/06/21', '15:00', 2),
('grifondoro', 'sole', '11/06/21','9:00', 3),
('corvonero', 'corvo', '11/06/21','9:00', 3);








--UTENTE


CREATE TABLE UTENTE
(
	email VARCHAR(20) PRIMARY KEY,
	nickname VARCHAR(20) NOT NULL UNIQUE,
	nome VARCHAR(20),
	cognome VARCHAR(20),
	data_nascita DATE
);


INSERT INTO UTENTE VALUES
('potter@gmail.com', 'harry', NULL, NULL, NULL ),
('malfoy@gmail.com', 'draco', NULL, NULL, NULL),
('andrea@gmail.com', 'peeta', NULL, 'di via', '15/12/98'),
('roberto@tiscali.it', 'bobi', 'roberto', NULL, '15/12/98'),
('clown@hotmail.com', 'malefretto', 'matteo', NULL, NULL),
('vernaz@gmail.com', 'meruem', 'edoardo', 'trigoso', NULL ),
('rodney@gmail.com', 'harley quinn', NULL, NULL, '25/12/00'),
('andre4ever@gmail.com', 'pierrobby', 'andrea', NULL, NULL),
('cristian@tiscali.it', 'FenixTheLeader', 'cristian', 'holly', '18/07/99'),
('henry@gmail.com', 'xxwaifuxx', 'enrico', NULL, '26/08/00'),
('mine@gmail.com', 'paridede', 'francesco', 'minervini', '6/10/98');







--MEMBRI

CREATE TABLE MEMBRI
(
	nome VARCHAR(20),
	icona VARCHAR(20),
	data DATE,
	ora TIME,
	idGioco NUMERIC(20),
	email VARCHAR(20) REFERENCES UTENTE(email)
						ON DELETE NO ACTION 
						ON UPDATE CASCADE,
	ruolo VARCHAR(20) NOT NULL 
						CHECK(ruolo IN('coach', 'caposquadra', 'standard')),
	UNIQUE(icona, ora, data, idGioco, email), 
	PRIMARY KEY(ora, data, email),
	FOREIGN KEY(nome, ora, data, idGioco) REFERENCES SQUADRA(nome, ora, data, idGioco)
													ON DELETE NO ACTION 
													ON UPDATE CASCADE,
	FOREIGN KEY(icona, ora, data, idGioco) REFERENCES SQUADRA(icona, ora, data, idGioco)
													ON DELETE NO ACTION 
													ON UPDATE CASCADE

);



INSERT INTO MEMBRI VALUES
('grifondoro', 'grifone', '10/06/21', '15:00', 1, 'potter@gmail.com', 'caposquadra'),
('grifondoro', 'grifone', '10/06/21', '15:00', 1, 'andrea@gmail.com', 'standard'),
('grifondoro', 'grifone', '10/06/21', '15:00', 1, 'henry@gmail.com', 'standard'),
('serpeverde', 'serpe', '10/06/21', '15:00', 1, 'malfoy@gmail.com', 'caposquadra'),
('genoani', 'grifone', '10/06/21', '15:00', 2, 'roberto@tiscali.it', 'standard'),
('genoani', 'grifone', '10/06/21', '15:00', 2, 'cristian@tiscali.it', 'standard'),
('genoani', 'grifone', '10/06/21', '15:00', 2, 'mine@gmail.com', 'standard'),
('genoani', 'grifone', '10/06/21', '15:00', 2, 'clown@hotmail.com', 'standard'),
('genoani', 'grifone', '10/06/21', '15:00', 2, 'andre4ever@gmail.com', 'standard'),
('grifondoro', 'grifone', '10/06/21', '16:15', 1, 'potter@gmail.com', 'standard'),
('grifondoro', 'grifone', '10/06/21', '16:15', 1, 'rodney@gmail.com', 'standard'),
('grifondoro', 'grifone', '10/06/21', '16:15', 1, 'henry@gmail.com', 'standard'),
('grifondoro', 'grifone', '10/06/21', '16:15', 1, 'malfoy@gmail.com', 'standard'),
('grifondoro', 'grifone', '10/06/21', '16:15', 1, 'andrea@gmail.com', 'standard'),
('corvonero', 'corvo', '11/06/21', '15:00', 2, 'cristian@tiscali.it', 'standard'),
('corvonero', 'corvo', '11/06/21', '15:00', 2, 'malfoy@gmail.com', 'standard'),
('corvonero', 'corvo', '11/06/21', '15:00', 2, 'clown@hotmail.com', 'standard'),
('sampdoriani', 'marinaio', '12/06/21', '9:00', 3, 'vernaz@gmail.com', 'coach'),
('sampdoriani', 'marinaio', '12/06/21','9:00', 3, 'malfoy@gmail.com', 'standard'),
('grifondoro', 'sole', '11/06/21','9:00', 3, 'cristian@tiscali.it', 'standard'),
('tassorosso', 'tasso', '11/06/21', '15:00', 2, 'andrea@gmail.com', 'standard'),
('tassorosso', 'tasso', '11/06/21', '15:00', 2, 'andre4ever@gmail.com', 'standard'),
('tassorosso', 'tasso', '11/06/21', '15:00', 2, 'vernaz@gmail.com', 'standard'),
('genoani', 'grifone', '12/06/21', '9:00', 3, 'andrea@gmail.com', 'caposquadra'),
('genoani', 'grifone', '12/06/21', '9:00', 3, 'andre4ever@gmail.com', 'standard'),
('grifondoro', 'sole', '11/06/21', '15:00', 2, 'rodney@gmail.com', 'standard'),
('grifondoro', 'sole', '11/06/21', '15:00', 2, 'potter@gmail.com', 'standard'),
('corvonero', 'corvo', '11/06/21', '9:00', 3, 'mine@gmail.com', 'caposquadra'),
('tassorosso', 'tasso', '10/06/21', '15:00', 2, 'rodney@gmail.com', 'standard'),
('serpeverde', 'serpe', '10/06/21', '16:15', 1, 'mine@gmail.com', 'standard');








--TURNO


CREATE TABLE TURNO
(
	numero NUMERIC(3) PRIMARY KEY CHECK(numero>=0)
);

INSERT INTO TURNO VALUES 
(0),
(1),
(2),
(5),
(10),
(13),
(19),
(25);







--SPOSTAMENTO

CREATE TABLE SPOSTAMENTO
(
	numero_turno NUMERIC(3) REFERENCES TURNO(numero)
							ON DELETE NO ACTION 
							ON UPDATE CASCADE
							CHECK(numero_turno>=0),
	numero_casella NUMERIC(4) CHECK(numero_casella>=0),
	idGioco NUMERIC(20),
	ora TIME NOT NULL,

	PRIMARY KEY(numero_turno, numero_casella, idGioco),
	FOREIGN KEY(numero_casella, idGioco) REFERENCES CASELLA(numero, idGioco)
													ON DELETE NO ACTION 
													ON UPDATE CASCADE

);


INSERT INTO SPOSTAMENTO VALUES
(0, 0, 1, '16:15'),
(0,0,2, '15:00'),
(0,0,3, '9:00'),
(0,0,4, '15:00'),
(1, 5, 1, '16:18'),
(2, 3, 1, '16:30'),
(5, 9, 1, '16:40'),
(13, 20, 1, '17:16'),
(19, 15, 2, '15:10'),
(10, 12, 3, '9:38');

