-- =============================================
-- Script Template
-- =============================================

/*
SET NOCOUNT ON 
  
SELECT 'INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (' + CAST([Id] AS NVARCHAR(10)) + ', ' + CAST([Code] AS NVARCHAR(10)) + ', ''' + REPLACE([Name], '''', '''''') + ''', NULL, ' + CAST([Location.State.Id] AS NVARCHAR(10)) + ')' + CHAR(13) + 'GO' + CHAR(13)
FROM Location.City
ORDER BY Id

  SELECT c.name from gestao.location.City c where not exists (select * from gestaoapp.Location.City x where x.Name = c.Name)
  
  select c.name, s.Acronym
  from gestaoapp.Location.City c inner join gestaoapp.location.State s on c.[Location.State.Id] = s.Id
  where c.Name like '%pinto%'
  
  select c.id, c.code, c.name from gestaoapp.Location.City c 
  where not exists (select * from Gestao.Location.City d where d.Name = c.Name)
  
  select c.id, c.name, s.Acronym 
  from gestao.Location.City c inner join gestao.location.State s
  on c.StateID = s.Id
  where not exists (select * from GestaoApp.Location.City d where d.Name = c.Name)
  
  update gestaoapp.Location.City set Name = 'Belém de São Francisco' where Id = 1482
  update gestaoapp.Location.City set Name = 'Couto de Magalhães' where Id = 352
  update gestaoapp.Location.City set Name = 'Santarém' where Id = 1416
  update gestaoapp.Location.City set Name = 'Lagoa do Itaenga' where Id = 1562
  delete from gestaoapp.Location.City where LTRIM(RTRIM(Name)) = 'Nazária' and Code = '2206720'
  update gestaoapp.Location.City set Name = 'Parati' where Id = 4823
  update gestaoapp.Location.City set Name = 'São Valério da Natividade' where Id = 437	
  update gestaoapp.Location.City set Name = 'Campo de Santana' where Id = 1292	
  update gestaoapp.Location.City set Name = 'Trajano de Morais' where Id = 4857
  
  
  select c.name 
  from gestao.sales.Bid b inner join gestao.location.City c on b.CityID = c.Id 
  where not exists(select * from gestaoapp.location.City where Name = c.Name)
*/

PRINT 'Inserting [Location].[City]...'

SET NOCOUNT ON
SET IDENTITY_INSERT [$(DatabaseName)].[Location].[City] ON



INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1, 1100015, 'Alta Floresta d''Oeste', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2, 1100379, 'Alto Alegre dos Parecis', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3, 1100403, 'Alto Paraíso', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4, 1100346, 'Alvorada d''Oeste', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5, 1100023, 'Ariquemes', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (6, 1100452, 'Buritis', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (7, 1100031, 'Cabixi', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (8, 1100601, 'Cacaulândia', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (9, 1100049, 'Cacoal', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (10, 1100700, 'Campo Novo de Rondônia', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (11, 1100809, 'Candeias do Jamari', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (12, 1100908, 'Castanheiras', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (13, 1100056, 'Cerejeiras', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (14, 1100924, 'Chupinguaia', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (15, 1100064, 'Colorado do Oeste', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (16, 1100072, 'Corumbiara', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (17, 1100080, 'Costa Marques', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (18, 1100940, 'Cujubim', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (19, 1100098, 'Espigão d''Oeste', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (20, 1101005, 'Governador Jorge Teixeira', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (21, 1100106, 'Guajará-Mirim', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (22, 1101104, 'Itapuã do Oeste', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (23, 1100114, 'Jaru', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (24, 1100122, 'Ji-Paraná', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (25, 1100130, 'Machadinho d''Oeste', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (26, 1101203, 'Ministro Andreazza', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (27, 1101302, 'Mirante da Serra', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (28, 1101401, 'Monte Negro', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (29, 1100148, 'Nova Brasilândia d''Oeste', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (30, 1100338, 'Nova Mamoré', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (31, 1101435, 'Nova União', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (32, 1100502, 'Novo Horizonte do Oeste', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (33, 1100155, 'Ouro Preto do Oeste', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (34, 1101450, 'Parecis', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (35, 1100189, 'Pimenta Bueno', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (36, 1101468, 'Pimenteiras do Oeste', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (37, 1100205, 'Porto Velho', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (38, 1100254, 'Presidente Médici', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (39, 1101476, 'Primavera de Rondônia', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (40, 1100262, 'Rio Crespo', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (41, 1100288, 'Rolim de Moura', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (42, 1100296, 'Santa Luzia d''Oeste', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (43, 1101484, 'São Felipe d''Oeste', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (44, 1101492, 'São Francisco do Guaporé', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (45, 1100320, 'São Miguel do Guaporé', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (46, 1101500, 'Seringueiras', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (47, 1101559, 'Teixeirópolis', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (48, 1101609, 'Theobroma', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (49, 1101708, 'Urupá', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (50, 1101757, 'Vale do Anari', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (51, 1101807, 'Vale do Paraíso', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (52, 1100304, 'Vilhena', NULL, 23)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (53, 1200013, 'Acrelândia', NULL, 1)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (54, 1200054, 'Assis Brasil', NULL, 1)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (55, 1200104, 'Brasiléia', NULL, 1)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (56, 1200138, 'Bujari', NULL, 1)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (57, 1200179, 'Capixaba', NULL, 1)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (58, 1200203, 'Cruzeiro do Sul', NULL, 1)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (59, 1200252, 'Epitaciolândia', NULL, 1)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (60, 1200302, 'Feijó', NULL, 1)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (61, 1200328, 'Jordão', NULL, 1)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (62, 1200336, 'Mâncio Lima', NULL, 1)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (63, 1200344, 'Manoel Urbano', NULL, 1)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (64, 1200351, 'Marechal Thaumaturgo', NULL, 1)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (65, 1200385, 'Plácido de Castro', NULL, 1)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (66, 1200807, 'Porto Acre', NULL, 1)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (67, 1200393, 'Porto Walter', NULL, 1)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (68, 1200401, 'Rio Branco', NULL, 1)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (69, 1200427, 'Rodrigues Alves', NULL, 1)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (70, 1200435, 'Santa Rosa do Purus', NULL, 1)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (71, 1200500, 'Sena Madureira', NULL, 1)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (72, 1200450, 'Senador Guiomard', NULL, 1)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (73, 1200609, 'Tarauacá', NULL, 1)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (74, 1200708, 'Xapuri', NULL, 1)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (75, 1300029, 'Alvarães', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (76, 1300060, 'Amaturá', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (77, 1300086, 'Anamã', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (78, 1300102, 'Anori', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (79, 1300144, 'Apuí', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (80, 1300201, 'Atalaia do Norte', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (81, 1300300, 'Autazes', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (82, 1300409, 'Barcelos', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (83, 1300508, 'Barreirinha', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (84, 1300607, 'Benjamin Constant', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (85, 1300631, 'Beruri', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (86, 1300680, 'Boa Vista do Ramos', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (87, 1300706, 'Boca do Acre', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (88, 1300805, 'Borba', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (89, 1300839, 'Caapiranga', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (90, 1300904, 'Canutama', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (91, 1301001, 'Carauari', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (92, 1301100, 'Careiro', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (93, 1301159, 'Careiro da Várzea', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (94, 1301209, 'Coari', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (95, 1301308, 'Codajás', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (96, 1301407, 'Eirunepé', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (97, 1301506, 'Envira', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (98, 1301605, 'Fonte Boa', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (99, 1301654, 'Guajará', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (100, 1301704, 'Humaitá', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (101, 1301803, 'Ipixuna', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (102, 1301852, 'Iranduba', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (103, 1301902, 'Itacoatiara', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (104, 1301951, 'Itamarati', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (105, 1302009, 'Itapiranga', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (106, 1302108, 'Japurá', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (107, 1302207, 'Juruá', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (108, 1302306, 'Jutaí', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (109, 1302405, 'Lábrea', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (110, 1302504, 'Manacapuru', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (111, 1302553, 'Manaquiri', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (112, 1302603, 'Manaus', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (113, 1302702, 'Manicoré', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (114, 1302801, 'Maraã', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (115, 1302900, 'Maués', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (116, 1303007, 'Nhamundá', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (117, 1303106, 'Nova Olinda do Norte', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (118, 1303205, 'Novo Airão', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (119, 1303304, 'Novo Aripuanã', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (120, 1303403, 'Parintins', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (121, 1303502, 'Pauini', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (122, 1303536, 'Presidente Figueiredo', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (123, 1303569, 'Rio Preto da Eva', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (124, 1303601, 'Santa Isabel do Rio Negro', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (125, 1303700, 'Santo Antônio do Içá', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (126, 1303809, 'São Gabriel da Cachoeira', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (127, 1303908, 'São Paulo de Olivença', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (128, 1303957, 'São Sebastião do Uatumã', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (129, 1304005, 'Silves', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (130, 1304062, 'Tabatinga', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (131, 1304104, 'Tapauá', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (132, 1304203, 'Tefé', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (133, 1304237, 'Tonantins', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (134, 1304260, 'Uarini', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (135, 1304302, 'Urucará', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (136, 1304401, 'Urucurituba', NULL, 3)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (137, 1400050, 'Alto Alegre', NULL, 24)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (138, 1400027, 'Amajari', NULL, 24)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (139, 1400100, 'Boa Vista', NULL, 24)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (140, 1400159, 'Bonfim', NULL, 24)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (141, 1400175, 'Cantá', NULL, 24)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (142, 1400209, 'Caracaraí', NULL, 24)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (143, 1400233, 'Caroebe', NULL, 24)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (144, 1400282, 'Iracema', NULL, 24)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (145, 1400308, 'Mucajaí', NULL, 24)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (146, 1400407, 'Normandia', NULL, 24)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (147, 1400456, 'Pacaraima', NULL, 24)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (148, 1400472, 'Rorainópolis', NULL, 24)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (149, 1400506, 'São João da Baliza', NULL, 24)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (150, 1400605, 'São Luiz', NULL, 24)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (151, 1400704, 'Uiramutã', NULL, 24)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (152, 1500107, 'Abaetetuba', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (153, 1500131, 'Abel Figueiredo', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (154, 1500206, 'Acará', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (155, 1500305, 'Afuá', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (156, 1500347, 'Água Azul do Norte', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (157, 1500404, 'Alenquer', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (158, 1500503, 'Almeirim', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (159, 1500602, 'Altamira', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (160, 1500701, 'Anajás', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (161, 1500800, 'Ananindeua', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (162, 1500859, 'Anapu', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (163, 1500909, 'Augusto Corrêa', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (164, 1500958, 'Aurora do Pará', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (165, 1501006, 'Aveiro', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (166, 1501105, 'Bagre', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (167, 1501204, 'Baião', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (168, 1501253, 'Bannach', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (169, 1501303, 'Barcarena', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (170, 1501402, 'Belém', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (171, 1501451, 'Belterra', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (172, 1501501, 'Benevides', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (173, 1501576, 'Bom Jesus do Tocantins', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (174, 1501600, 'Bonito', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (175, 1501709, 'Bragança', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (176, 1501725, 'Brasil Novo', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (177, 1501758, 'Brejo Grande do Araguaia', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (178, 1501782, 'Breu Branco', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (179, 1501808, 'Breves', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (180, 1501907, 'Bujaru', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (181, 1502004, 'Cachoeira do Arari', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (182, 1501956, 'Cachoeira do Piriá', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (183, 1502103, 'Cametá', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (184, 1502152, 'Canaã dos Carajás', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (185, 1502202, 'Capanema', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (186, 1502301, 'Capitão Poço', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (187, 1502400, 'Castanhal', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (188, 1502509, 'Chaves', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (189, 1502608, 'Colares', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (190, 1502707, 'Conceição do Araguaia', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (191, 1502756, 'Concórdia do Pará', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (192, 1502764, 'Cumaru do Norte', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (193, 1502772, 'Curionópolis', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (194, 1502806, 'Curralinho', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (195, 1502855, 'Curuá', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (196, 1502905, 'Curuçá', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (197, 1502939, 'Dom Eliseu', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (198, 1502954, 'Eldorado dos Carajás', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (199, 1503002, 'Faro', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (200, 1503044, 'Floresta do Araguaia', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (201, 1503077, 'Garrafão do Norte', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (202, 1503093, 'Goianésia do Pará', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (203, 1503101, 'Gurupá', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (204, 1503200, 'Igarapé-Açu', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (205, 1503309, 'Igarapé-Miri', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (206, 1503408, 'Inhangapi', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (207, 1503457, 'Ipixuna do Pará', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (208, 1503507, 'Irituia', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (209, 1503606, 'Itaituba', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (210, 1503705, 'Itupiranga', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (211, 1503754, 'Jacareacanga', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (212, 1503804, 'Jacundá', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (213, 1503903, 'Juruti', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (214, 1504000, 'Limoeiro do Ajuru', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (215, 1504059, 'Mãe do Rio', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (216, 1504109, 'Magalhães Barata', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (217, 1504208, 'Marabá', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (218, 1504307, 'Maracanã', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (219, 1504406, 'Marapanim', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (220, 1504422, 'Marituba', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (221, 1504455, 'Medicilândia', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (222, 1504505, 'Melgaço', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (223, 1504604, 'Mocajuba', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (224, 1504703, 'Moju', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (225, 1504802, 'Monte Alegre', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (226, 1504901, 'Muaná', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (227, 1504950, 'Nova Esperança do Piriá', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (228, 1504976, 'Nova Ipixuna', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (229, 1505007, 'Nova Timboteua', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (230, 1505031, 'Novo Progresso', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (231, 1505064, 'Novo Repartimento', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (232, 1505106, 'Óbidos', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (233, 1505205, 'Oeiras do Pará', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (234, 1505304, 'Oriximiná', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (235, 1505403, 'Ourém', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (236, 1505437, 'Ourilândia do Norte', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (237, 1505486, 'Pacajá', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (238, 1505494, 'Palestina do Pará', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (239, 1505502, 'Paragominas', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (240, 1505536, 'Parauapebas', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (241, 1505551, 'Pau D''Arco', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (242, 1505601, 'Peixe-Boi', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (243, 1505635, 'Piçarra', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (244, 1505650, 'Placas', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (245, 1505700, 'Ponta de Pedras', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (246, 1505809, 'Portel', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (247, 1505908, 'Porto de Moz', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (248, 1506005, 'Prainha', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (249, 1506104, 'Primavera', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (250, 1506112, 'Quatipuru', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (251, 1506138, 'Redenção', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (252, 1506161, 'Rio Maria', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (253, 1506187, 'Rondon do Pará', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (254, 1506195, 'Rurópolis', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (255, 1506203, 'Salinópolis', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (256, 1506302, 'Salvaterra', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (257, 1506351, 'Santa Bárbara do Pará', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (258, 1506401, 'Santa Cruz do Arari', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (259, 1506500, 'Santa Isabel do Pará', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (260, 1506559, 'Santa Luzia do Pará', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (261, 1506583, 'Santa Maria das Barreiras', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (262, 1506609, 'Santa Maria do Pará', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (263, 1506708, 'Santana do Araguaia', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (264, 1506807, 'Santarém', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (265, 1506906, 'Santarém Novo', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (266, 1507003, 'Santo Antônio do Tauá', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (267, 1507102, 'São Caetano de Odivelas', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (268, 1507151, 'São Domingos do Araguaia', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (269, 1507201, 'São Domingos do Capim', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (270, 1507300, 'São Félix do Xingu', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (271, 1507409, 'São Francisco do Pará', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (272, 1507458, 'São Geraldo do Araguaia', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (273, 1507466, 'São João da Ponta', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (274, 1507474, 'São João de Pirabas', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (275, 1507508, 'São João do Araguaia', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (276, 1507607, 'São Miguel do Guamá', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (277, 1507706, 'São Sebastião da Boa Vista', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (278, 1507755, 'Sapucaia', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (279, 1507805, 'Senador José Porfírio', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (280, 1507904, 'Soure', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (281, 1507953, 'Tailândia', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (282, 1507961, 'Terra Alta', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (283, 1507979, 'Terra Santa', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (284, 1508001, 'Tomé-Açu', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (285, 1508035, 'Tracuateua', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (286, 1508050, 'Trairão', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (287, 1508084, 'Tucumã', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (288, 1508100, 'Tucuruí', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (289, 1508126, 'Ulianópolis', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (290, 1508159, 'Uruará', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (291, 1508209, 'Vigia', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (292, 1508308, 'Viseu', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (293, 1508357, 'Vitória do Xingu', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (294, 1508407, 'Xinguara', NULL, 15)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (295, 1600105, 'Amapá', NULL, 4)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (296, 1600204, 'Calçoene', NULL, 4)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (297, 1600212, 'Cutias', NULL, 4)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (298, 1600238, 'Ferreira Gomes', NULL, 4)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (299, 1600253, 'Itaubal', NULL, 4)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (300, 1600279, 'Laranjal do Jari', NULL, 4)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (301, 1600303, 'Macapá', NULL, 4)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (302, 1600402, 'Mazagão', NULL, 4)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (303, 1600501, 'Oiapoque', NULL, 4)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (304, 1600154, 'Pedra Branca do Amapari', NULL, 4)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (305, 1600535, 'Porto Grande', NULL, 4)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (306, 1600550, 'Pracuúba', NULL, 4)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (307, 1600600, 'Santana', NULL, 4)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (308, 1600055, 'Serra do Navio', NULL, 4)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (309, 1600709, 'Tartarugalzinho', NULL, 4)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (310, 1600808, 'Vitória do Jari', NULL, 4)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (311, 1700251, 'Abreulândia', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (312, 1700301, 'Aguiarnópolis', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (313, 1700350, 'Aliança do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (314, 1700400, 'Almas', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (315, 1700707, 'Alvorada', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (316, 1701002, 'Ananás', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (317, 1701051, 'Angico', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (318, 1701101, 'Aparecida do Rio Negro', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (319, 1701309, 'Aragominas', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (320, 1701903, 'Araguacema', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (321, 1702000, 'Araguaçu', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (322, 1702109, 'Araguaína', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (323, 1702158, 'Araguanã', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (324, 1702208, 'Araguatins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (325, 1702307, 'Arapoema', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (326, 1702406, 'Arraias', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (327, 1702554, 'Augustinópolis', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (328, 1702703, 'Aurora do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (329, 1702901, 'Axixá do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (330, 1703008, 'Babaçulândia', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (331, 1703057, 'Bandeirantes do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (332, 1703073, 'Barra do Ouro', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (333, 1703107, 'Barrolândia', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (334, 1703206, 'Bernardo Sayão', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (335, 1703305, 'Bom Jesus do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (336, 1703602, 'Brasilândia do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (337, 1703701, 'Brejinho de Nazaré', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (338, 1703800, 'Buriti do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (339, 1703826, 'Cachoeirinha', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (340, 1703842, 'Campos Lindos', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (341, 1703867, 'Cariri do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (342, 1703883, 'Carmolândia', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (343, 1703891, 'Carrasco Bonito', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (344, 1703909, 'Caseara', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (345, 1704105, 'Centenário', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (346, 1705102, 'Chapada da Natividade', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (347, 1704600, 'Chapada de Areia', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (348, 1705508, 'Colinas do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (349, 1716703, 'Colméia', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (350, 1705557, 'Combinado', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (351, 1705607, 'Conceição do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (352, 1706001, 'Couto de Magalhães', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (353, 1706100, 'Cristalândia', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (354, 1706258, 'Crixás do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (355, 1706506, 'Darcinópolis', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (356, 1707009, 'Dianópolis', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (357, 1707108, 'Divinópolis do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (358, 1707207, 'Dois Irmãos do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (359, 1707306, 'Dueré', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (360, 1707405, 'Esperantina', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (361, 1707553, 'Fátima', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (362, 1707652, 'Figueirópolis', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (363, 1707702, 'Filadélfia', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (364, 1708205, 'Formoso do Araguaia', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (365, 1708254, 'Fortaleza do Tabocão', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (366, 1708304, 'Goianorte', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (367, 1709005, 'Goiatins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (368, 1709302, 'Guaraí', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (369, 1709500, 'Gurupi', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (370, 1709807, 'Ipueiras', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (371, 1710508, 'Itacajá', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (372, 1710706, 'Itaguatins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (373, 1710904, 'Itapiratins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (374, 1711100, 'Itaporã do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (375, 1711506, 'Jaú do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (376, 1711803, 'Juarina', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (377, 1711902, 'Lagoa da Confusão', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (378, 1711951, 'Lagoa do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (379, 1712009, 'Lajeado', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (380, 1712157, 'Lavandeira', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (381, 1712405, 'Lizarda', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (382, 1712454, 'Luzinópolis', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (383, 1712504, 'Marianópolis do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (384, 1712702, 'Mateiros', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (385, 1712801, 'Maurilândia do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (386, 1713205, 'Miracema do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (387, 1713304, 'Miranorte', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (388, 1713601, 'Monte do Carmo', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (389, 1713700, 'Monte Santo do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (390, 1713957, 'Muricilândia', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (391, 1714203, 'Natividade', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (392, 1714302, 'Nazaré', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (393, 1714880, 'Nova Olinda', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (394, 1715002, 'Nova Rosalândia', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (395, 1715101, 'Novo Acordo', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (396, 1715150, 'Novo Alegre', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (397, 1715259, 'Novo Jardim', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (398, 1715507, 'Oliveira de Fátima', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (399, 1721000, 'Palmas', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (400, 1715705, 'Palmeirante', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (401, 1713809, 'Palmeiras do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (402, 1715754, 'Palmeirópolis', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (403, 1716109, 'Paraíso do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (404, 1716208, 'Paranã', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (405, 1716307, 'Pau D''Arco', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (406, 1716505, 'Pedro Afonso', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (407, 1716604, 'Peixe', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (408, 1716653, 'Pequizeiro', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (409, 1717008, 'Pindorama do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (410, 1717206, 'Piraquê', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (411, 1717503, 'Pium', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (412, 1717800, 'Ponte Alta do Bom Jesus', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (413, 1717909, 'Ponte Alta do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (414, 1718006, 'Porto Alegre do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (415, 1718204, 'Porto Nacional', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (416, 1718303, 'Praia Norte', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (417, 1718402, 'Presidente Kennedy', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (418, 1718451, 'Pugmil', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (419, 1718501, 'Recursolândia', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (420, 1718550, 'Riachinho', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (421, 1718659, 'Rio da Conceição', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (422, 1718709, 'Rio dos Bois', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (423, 1718758, 'Rio Sono', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (424, 1718808, 'Sampaio', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (425, 1718840, 'Sandolândia', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (426, 1718865, 'Santa Fé do Araguaia', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (427, 1718881, 'Santa Maria do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (428, 1718899, 'Santa Rita do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (429, 1718907, 'Santa Rosa do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (430, 1719004, 'Santa Tereza do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (431, 1720002, 'Santa Terezinha do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (432, 1720101, 'São Bento do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (433, 1720150, 'São Félix do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (434, 1720200, 'São Miguel do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (435, 1720259, 'São Salvador do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (436, 1720309, 'São Sebastião do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (437, 1720499, 'São Valério da Natividade', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (438, 1720655, 'Silvanópolis', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (439, 1720804, 'Sítio Novo do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (440, 1720853, 'Sucupira', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (441, 1720903, 'Taguatinga', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (442, 1720937, 'Taipas do Tocantins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (443, 1720978, 'Talismã', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (444, 1721109, 'Tocantínia', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (445, 1721208, 'Tocantinópolis', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (446, 1721257, 'Tupirama', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (447, 1721307, 'Tupiratins', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (448, 1722081, 'Wanderlândia', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (449, 1722107, 'Xambioá', NULL, 27)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (450, 2100055, 'Açailândia', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (451, 2100105, 'Afonso Cunha', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (452, 2100154, 'Água Doce do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (453, 2100204, 'Alcântara', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (454, 2100303, 'Aldeias Altas', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (455, 2100402, 'Altamira do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (456, 2100436, 'Alto Alegre do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (457, 2100477, 'Alto Alegre do Pindaré', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (458, 2100501, 'Alto Parnaíba', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (459, 2100550, 'Amapá do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (460, 2100600, 'Amarante do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (461, 2100709, 'Anajatuba', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (462, 2100808, 'Anapurus', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (463, 2100832, 'Apicum-Açu', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (464, 2100873, 'Araguanã', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (465, 2100907, 'Araioses', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (466, 2100956, 'Arame', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (467, 2101004, 'Arari', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (468, 2101103, 'Axixá', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (469, 2101202, 'Bacabal', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (470, 2101251, 'Bacabeira', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (471, 2101301, 'Bacuri', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (472, 2101350, 'Bacurituba', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (473, 2101400, 'Balsas', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (474, 2101509, 'Barão de Grajaú', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (475, 2101608, 'Barra do Corda', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (476, 2101707, 'Barreirinhas', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (477, 2101772, 'Bela Vista do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (478, 2101731, 'Belágua', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (479, 2101806, 'Benedito Leite', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (480, 2101905, 'Bequimão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (481, 2101939, 'Bernardo do Mearim', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (482, 2101970, 'Boa Vista do Gurupi', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (483, 2102002, 'Bom Jardim', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (484, 2102036, 'Bom Jesus das Selvas', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (485, 2102077, 'Bom Lugar', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (486, 2102101, 'Brejo', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (487, 2102150, 'Brejo de Areia', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (488, 2102200, 'Buriti', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (489, 2102309, 'Buriti Bravo', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (490, 2102325, 'Buriticupu', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (491, 2102358, 'Buritirana', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (492, 2102374, 'Cachoeira Grande', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (493, 2102408, 'Cajapió', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (494, 2102507, 'Cajari', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (495, 2102556, 'Campestre do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (496, 2102606, 'Cândido Mendes', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (497, 2102705, 'Cantanhede', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (498, 2102754, 'Capinzal do Norte', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (499, 2102804, 'Carolina', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (500, 2102903, 'Carutapera', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (501, 2103000, 'Caxias', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (502, 2103109, 'Cedral', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (503, 2103125, 'Central do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (504, 2103158, 'Centro do Guilherme', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (505, 2103174, 'Centro Novo do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (506, 2103208, 'Chapadinha', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (507, 2103257, 'Cidelândia', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (508, 2103307, 'Codó', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (509, 2103406, 'Coelho Neto', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (510, 2103505, 'Colinas', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (511, 2103554, 'Conceição do Lago-Açu', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (512, 2103604, 'Coroatá', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (513, 2103703, 'Cururupu', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (514, 2103752, 'Davinópolis', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (515, 2103802, 'Dom Pedro', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (516, 2103901, 'Duque Bacelar', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (517, 2104008, 'Esperantinópolis', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (518, 2104057, 'Estreito', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (519, 2104073, 'Feira Nova do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (520, 2104081, 'Fernando Falcão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (521, 2104099, 'Formosa da Serra Negra', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (522, 2104107, 'Fortaleza dos Nogueiras', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (523, 2104206, 'Fortuna', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (524, 2104305, 'Godofredo Viana', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (525, 2104404, 'Gonçalves Dias', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (526, 2104503, 'Governador Archer', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (527, 2104552, 'Governador Edison Lobão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (528, 2104602, 'Governador Eugênio Barros', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (529, 2104628, 'Governador Luiz Rocha', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (530, 2104651, 'Governador Newton Bello', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (531, 2104677, 'Governador Nunes Freire', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (532, 2104701, 'Graça Aranha', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (533, 2104800, 'Grajaú', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (534, 2104909, 'Guimarães', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (535, 2105005, 'Humberto de Campos', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (536, 2105104, 'Icatu', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (537, 2105153, 'Igarapé do Meio', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (538, 2105203, 'Igarapé Grande', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (539, 2105302, 'Imperatriz', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (540, 2105351, 'Itaipava do Grajaú', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (541, 2105401, 'Itapecuru Mirim', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (542, 2105427, 'Itinga do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (543, 2105450, 'Jatobá', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (544, 2105476, 'Jenipapo dos Vieiras', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (545, 2105500, 'João Lisboa', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (546, 2105609, 'Joselândia', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (547, 2105658, 'Junco do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (548, 2105708, 'Lago da Pedra', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (549, 2105807, 'Lago do Junco', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (550, 2105948, 'Lago dos Rodrigues', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (551, 2105906, 'Lago Verde', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (552, 2105922, 'Lagoa do Mato', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (553, 2105963, 'Lagoa Grande do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (554, 2105989, 'Lajeado Novo', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (555, 2106003, 'Lima Campos', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (556, 2106102, 'Loreto', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (557, 2106201, 'Luís Domingues', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (558, 2106300, 'Magalhães de Almeida', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (559, 2106326, 'Maracaçumé', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (560, 2106359, 'Marajá do Sena', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (561, 2106375, 'Maranhãozinho', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (562, 2106409, 'Mata Roma', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (563, 2106508, 'Matinha', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (564, 2106607, 'Matões', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (565, 2106631, 'Matões do Norte', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (566, 2106672, 'Milagres do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (567, 2106706, 'Mirador', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (568, 2106755, 'Miranda do Norte', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (569, 2106805, 'Mirinzal', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (570, 2106904, 'Monção', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (571, 2107001, 'Montes Altos', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (572, 2107100, 'Morros', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (573, 2107209, 'Nina Rodrigues', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (574, 2107258, 'Nova Colinas', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (575, 2107308, 'Nova Iorque', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (576, 2107357, 'Nova Olinda do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (577, 2107407, 'Olho d''Água das Cunhãs', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (578, 2107456, 'Olinda Nova do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (579, 2107506, 'Paço do Lumiar', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (580, 2107605, 'Palmeirândia', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (581, 2107704, 'Paraibano', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (582, 2107803, 'Parnarama', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (583, 2107902, 'Passagem Franca', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (584, 2108009, 'Pastos Bons', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (585, 2108058, 'Paulino Neves', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (586, 2108108, 'Paulo Ramos', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (587, 2108207, 'Pedreiras', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (588, 2108256, 'Pedro do Rosário', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (589, 2108306, 'Penalva', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (590, 2108405, 'Peri Mirim', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (591, 2108454, 'Peritoró', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (592, 2108504, 'Pindaré-Mirim', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (593, 2108603, 'Pinheiro', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (594, 2108702, 'Pio XII', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (595, 2108801, 'Pirapemas', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (596, 2108900, 'Poção de Pedras', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (597, 2109007, 'Porto Franco', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (598, 2109056, 'Porto Rico do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (599, 2109106, 'Presidente Dutra', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (600, 2109205, 'Presidente Juscelino', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (601, 2109239, 'Presidente Médici', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (602, 2109270, 'Presidente Sarney', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (603, 2109304, 'Presidente Vargas', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (604, 2109403, 'Primeira Cruz', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (605, 2109452, 'Raposa', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (606, 2109502, 'Riachão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (607, 2109551, 'Ribamar Fiquene', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (608, 2109601, 'Rosário', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (609, 2109700, 'Sambaíba', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (610, 2109759, 'Santa Filomena do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (611, 2109809, 'Santa Helena', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (612, 2109908, 'Santa Inês', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (613, 2110005, 'Santa Luzia', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (614, 2110039, 'Santa Luzia do Paruá', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (615, 2110104, 'Santa Quitéria do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (616, 2110203, 'Santa Rita', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (617, 2110237, 'Santana do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (618, 2110278, 'Santo Amaro do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (619, 2110302, 'Santo Antônio dos Lopes', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (620, 2110401, 'São Benedito do Rio Preto', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (621, 2110500, 'São Bento', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (622, 2110609, 'São Bernardo', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (623, 2110658, 'São Domingos do Azeitão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (624, 2110708, 'São Domingos do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (625, 2110807, 'São Félix de Balsas', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (626, 2110856, 'São Francisco do Brejão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (627, 2110906, 'São Francisco do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (628, 2111003, 'São João Batista', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (629, 2111029, 'São João do Carú', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (630, 2111052, 'São João do Paraíso', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (631, 2111078, 'São João do Soter', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (632, 2111102, 'São João dos Patos', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (633, 2111201, 'São José de Ribamar', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (634, 2111250, 'São José dos Basílios', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (635, 2111300, 'São Luís', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (636, 2111409, 'São Luís Gonzaga do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (637, 2111508, 'São Mateus do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (638, 2111532, 'São Pedro da Água Branca', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (639, 2111573, 'São Pedro dos Crentes', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (640, 2111607, 'São Raimundo das Mangabeiras', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (641, 2111631, 'São Raimundo do Doca Bezerra', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (642, 2111672, 'São Roberto', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (643, 2111706, 'São Vicente Ferrer', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (644, 2111722, 'Satubinha', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (645, 2111748, 'Senador Alexandre Costa', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (646, 2111763, 'Senador La Rocque', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (647, 2111789, 'Serrano do Maranhão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (648, 2111805, 'Sítio Novo', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (649, 2111904, 'Sucupira do Norte', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (650, 2111953, 'Sucupira do Riachão', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (651, 2112001, 'Tasso Fragoso', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (652, 2112100, 'Timbiras', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (653, 2112209, 'Timon', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (654, 2112233, 'Trizidela do Vale', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (655, 2112274, 'Tufilândia', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (656, 2112308, 'Tuntum', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (657, 2112407, 'Turiaçu', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (658, 2112456, 'Turilândia', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (659, 2112506, 'Tutóia', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (660, 2112605, 'Urbano Santos', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (661, 2112704, 'Vargem Grande', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (662, 2112803, 'Viana', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (663, 2112852, 'Vila Nova dos Martírios', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (664, 2112902, 'Vitória do Mearim', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (665, 2113009, 'Vitorino Freire', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (666, 2114007, 'Zé Doca', NULL, 10)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (667, 2200053, 'Acauã', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (668, 2200103, 'Agricolândia', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (669, 2200202, 'Água Branca', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (670, 2200251, 'Alagoinha do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (671, 2200277, 'Alegrete do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (672, 2200301, 'Alto Longá', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (673, 2200400, 'Altos', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (674, 2200459, 'Alvorada do Gurguéia', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (675, 2200509, 'Amarante', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (676, 2200608, 'Angical do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (677, 2200707, 'Anísio de Abreu', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (678, 2200806, 'Antônio Almeida', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (679, 2200905, 'Aroazes', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (680, 2200954, 'Aroeiras do Itaim', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (681, 2201002, 'Arraial', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (682, 2201051, 'Assunção do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (683, 2201101, 'Avelino Lopes', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (684, 2201150, 'Baixa Grande do Ribeiro', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (685, 2201176, 'Barra D''Alcântara', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (686, 2201200, 'Barras', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (687, 2201309, 'Barreiras do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (688, 2201408, 'Barro Duro', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (689, 2201507, 'Batalha', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (690, 2201556, 'Bela Vista do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (691, 2201572, 'Belém do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (692, 2201606, 'Beneditinos', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (693, 2201705, 'Bertolínia', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (694, 2201739, 'Betânia do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (695, 2201770, 'Boa Hora', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (696, 2201804, 'Bocaina', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (697, 2201903, 'Bom Jesus', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (698, 2201919, 'Bom Princípio do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (699, 2201929, 'Bonfim do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (700, 2201945, 'Boqueirão do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (701, 2201960, 'Brasileira', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (702, 2201988, 'Brejo do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (703, 2202000, 'Buriti dos Lopes', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (704, 2202026, 'Buriti dos Montes', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (705, 2202059, 'Cabeceiras do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (706, 2202075, 'Cajazeiras do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (707, 2202083, 'Cajueiro da Praia', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (708, 2202091, 'Caldeirão Grande do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (709, 2202109, 'Campinas do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (710, 2202117, 'Campo Alegre do Fidalgo', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (711, 2202133, 'Campo Grande do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (712, 2202174, 'Campo Largo do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (713, 2202208, 'Campo Maior', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (714, 2202251, 'Canavieira', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (715, 2202307, 'Canto do Buriti', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (716, 2202406, 'Capitão de Campos', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (717, 2202455, 'Capitão Gervásio Oliveira', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (718, 2202505, 'Caracol', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (719, 2202539, 'Caraúbas do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (720, 2202554, 'Caridade do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (721, 2202604, 'Castelo do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (722, 2202653, 'Caxingó', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (723, 2202703, 'Cocal', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (724, 2202711, 'Cocal de Telha', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (725, 2202729, 'Cocal dos Alves', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (726, 2202737, 'Coivaras', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (727, 2202752, 'Colônia do Gurguéia', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (728, 2202778, 'Colônia do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (729, 2202802, 'Conceição do Canindé', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (730, 2202851, 'Coronel José Dias', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (731, 2202901, 'Corrente', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (732, 2203008, 'Cristalândia do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (733, 2203107, 'Cristino Castro', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (734, 2203206, 'Curimatá', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (735, 2203230, 'Currais', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (736, 2203271, 'Curral Novo do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (737, 2203255, 'Curralinhos', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (738, 2203305, 'Demerval Lobão', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (739, 2203354, 'Dirceu Arcoverde', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (740, 2203404, 'Dom Expedito Lopes', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (741, 2203453, 'Dom Inocêncio', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (742, 2203420, 'Domingos Mourão', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (743, 2203503, 'Elesbão Veloso', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (744, 2203602, 'Eliseu Martins', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (745, 2203701, 'Esperantina', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (746, 2203750, 'Fartura do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (747, 2203800, 'Flores do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (748, 2203859, 'Floresta do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (749, 2203909, 'Floriano', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (750, 2204006, 'Francinópolis', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (751, 2204105, 'Francisco Ayres', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (752, 2204154, 'Francisco Macedo', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (753, 2204204, 'Francisco Santos', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (754, 2204303, 'Fronteiras', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (755, 2204352, 'Geminiano', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (756, 2204402, 'Gilbués', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (757, 2204501, 'Guadalupe', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (758, 2204550, 'Guaribas', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (759, 2204600, 'Hugo Napoleão', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (760, 2204659, 'Ilha Grande', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (761, 2204709, 'Inhuma', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (762, 2204808, 'Ipiranga do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (763, 2204907, 'Isaías Coelho', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (764, 2205003, 'Itainópolis', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (765, 2205102, 'Itaueira', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (766, 2205151, 'Jacobina do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (767, 2205201, 'Jaicós', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (768, 2205250, 'Jardim do Mulato', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (769, 2205276, 'Jatobá do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (770, 2205300, 'Jerumenha', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (771, 2205359, 'João Costa', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (772, 2205409, 'Joaquim Pires', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (773, 2205458, 'Joca Marques', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (774, 2205508, 'José de Freitas', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (775, 2205516, 'Juazeiro do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (776, 2205524, 'Júlio Borges', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (777, 2205532, 'Jurema', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (778, 2205557, 'Lagoa Alegre', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (779, 2205573, 'Lagoa de São Francisco', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (780, 2205565, 'Lagoa do Barro do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (781, 2205581, 'Lagoa do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (782, 2205599, 'Lagoa do Sítio', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (783, 2205540, 'Lagoinha do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (784, 2205607, 'Landri Sales', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (785, 2205706, 'Luís Correia', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (786, 2205805, 'Luzilândia', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (787, 2205854, 'Madeiro', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (788, 2205904, 'Manoel Emídio', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (789, 2205953, 'Marcolândia', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (790, 2206001, 'Marcos Parente', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (791, 2206050, 'Massapê do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (792, 2206100, 'Matias Olímpio', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (793, 2206209, 'Miguel Alves', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (794, 2206308, 'Miguel Leão', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (795, 2206357, 'Milton Brandão', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (796, 2206407, 'Monsenhor Gil', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (797, 2206506, 'Monsenhor Hipólito', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (798, 2206605, 'Monte Alegre do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (799, 2206654, 'Morro Cabeça no Tempo', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (800, 2206670, 'Morro do Chapéu do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (801, 2206696, 'Murici dos Portelas', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (802, 2206704, 'Nazaré do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (804, 2206753, 'Nossa Senhora de Nazaré', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (805, 2206803, 'Nossa Senhora dos Remédios', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (806, 2207959, 'Nova Santa Rita', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (807, 2206902, 'Novo Oriente do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (808, 2206951, 'Novo Santo Antônio', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (809, 2207009, 'Oeiras', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (810, 2207108, 'Olho d''Água do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (811, 2207207, 'Padre Marcos', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (812, 2207306, 'Paes Landim', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (813, 2207355, 'Pajeú do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (814, 2207405, 'Palmeira do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (815, 2207504, 'Palmeirais', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (816, 2207553, 'Paquetá', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (817, 2207603, 'Parnaguá', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (818, 2207702, 'Parnaíba', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (819, 2207751, 'Passagem Franca do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (820, 2207777, 'Patos do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (821, 2207793, 'Pau D''Arco do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (822, 2207801, 'Paulistana', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (823, 2207850, 'Pavussu', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (824, 2207900, 'Pedro II', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (825, 2207934, 'Pedro Laurentino', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (826, 2208007, 'Picos', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (827, 2208106, 'Pimenteiras', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (828, 2208205, 'Pio IX', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (829, 2208304, 'Piracuruca', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (830, 2208403, 'Piripiri', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (831, 2208502, 'Porto', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (832, 2208551, 'Porto Alegre do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (833, 2208601, 'Prata do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (834, 2208650, 'Queimada Nova', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (835, 2208700, 'Redenção do Gurguéia', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (836, 2208809, 'Regeneração', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (837, 2208858, 'Riacho Frio', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (838, 2208874, 'Ribeira do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (839, 2208908, 'Ribeiro Gonçalves', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (840, 2209005, 'Rio Grande do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (841, 2209104, 'Santa Cruz do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (842, 2209153, 'Santa Cruz dos Milagres', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (843, 2209203, 'Santa Filomena', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (844, 2209302, 'Santa Luz', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (845, 2209377, 'Santa Rosa do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (846, 2209351, 'Santana do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (847, 2209401, 'Santo Antônio de Lisboa', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (848, 2209450, 'Santo Antônio dos Milagres', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (849, 2209500, 'Santo Inácio do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (850, 2209559, 'São Braz do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (851, 2209609, 'São Félix do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (852, 2209658, 'São Francisco de Assis do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (853, 2209708, 'São Francisco do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (854, 2209757, 'São Gonçalo do Gurguéia', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (855, 2209807, 'São Gonçalo do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (856, 2209856, 'São João da Canabrava', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (857, 2209872, 'São João da Fronteira', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (858, 2209906, 'São João da Serra', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (859, 2209955, 'São João da Varjota', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (860, 2209971, 'São João do Arraial', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (861, 2210003, 'São João do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (862, 2210052, 'São José do Divino', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (863, 2210102, 'São José do Peixe', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (864, 2210201, 'São José do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (865, 2210300, 'São Julião', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (866, 2210359, 'São Lourenço do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (867, 2210375, 'São Luis do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (868, 2210383, 'São Miguel da Baixa Grande', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (869, 2210391, 'São Miguel do Fidalgo', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (870, 2210409, 'São Miguel do Tapuio', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (871, 2210508, 'São Pedro do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (872, 2210607, 'São Raimundo Nonato', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (873, 2210623, 'Sebastião Barros', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (874, 2210631, 'Sebastião Leal', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (875, 2210656, 'Sigefredo Pacheco', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (876, 2210706, 'Simões', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (877, 2210805, 'Simplício Mendes', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (878, 2210904, 'Socorro do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (879, 2210938, 'Sussuapara', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (880, 2210953, 'Tamboril do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (881, 2210979, 'Tanque do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (882, 2211001, 'Teresina', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (883, 2211100, 'União', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (884, 2211209, 'Uruçuí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (885, 2211308, 'Valença do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (886, 2211357, 'Várzea Branca', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (887, 2211407, 'Várzea Grande', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (888, 2211506, 'Vera Mendes', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (889, 2211605, 'Vila Nova do Piauí', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (890, 2211704, 'Wall Ferraz', NULL, 19)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (891, 2300101, 'Abaiara', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (892, 2300150, 'Acarape', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (893, 2300200, 'Acaraú', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (894, 2300309, 'Acopiara', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (895, 2300408, 'Aiuaba', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (896, 2300507, 'Alcântaras', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (897, 2300606, 'Altaneira', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (898, 2300705, 'Alto Santo', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (899, 2300754, 'Amontada', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (900, 2300804, 'Antonina do Norte', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (901, 2300903, 'Apuiarés', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (902, 2301000, 'Aquiraz', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (903, 2301109, 'Aracati', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (904, 2301208, 'Aracoiaba', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (905, 2301257, 'Ararendá', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (906, 2301307, 'Araripe', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (907, 2301406, 'Aratuba', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (908, 2301505, 'Arneiroz', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (909, 2301604, 'Assaré', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (910, 2301703, 'Aurora', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (911, 2301802, 'Baixio', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (912, 2301851, 'Banabuiú', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (913, 2301901, 'Barbalha', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (914, 2301950, 'Barreira', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (915, 2302008, 'Barro', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (916, 2302057, 'Barroquinha', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (917, 2302107, 'Baturité', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (918, 2302206, 'Beberibe', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (919, 2302305, 'Bela Cruz', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (920, 2302404, 'Boa Viagem', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (921, 2302503, 'Brejo Santo', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (922, 2302602, 'Camocim', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (923, 2302701, 'Campos Sales', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (924, 2302800, 'Canindé', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (925, 2302909, 'Capistrano', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (926, 2303006, 'Caridade', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (927, 2303105, 'Cariré', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (928, 2303204, 'Caririaçu', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (929, 2303303, 'Cariús', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (930, 2303402, 'Carnaubal', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (931, 2303501, 'Cascavel', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (932, 2303600, 'Catarina', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (933, 2303659, 'Catunda', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (934, 2303709, 'Caucaia', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (935, 2303808, 'Cedro', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (936, 2303907, 'Chaval', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (937, 2303931, 'Choró', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (938, 2303956, 'Chorozinho', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (939, 2304004, 'Coreaú', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (940, 2304103, 'Crateús', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (941, 2304202, 'Crato', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (942, 2304236, 'Croatá', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (943, 2304251, 'Cruz', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (944, 2304269, 'Deputado Irapuan Pinheiro', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (945, 2304277, 'Ererê', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (946, 2304285, 'Eusébio', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (947, 2304301, 'Farias Brito', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (948, 2304350, 'Forquilha', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (949, 2304400, 'Fortaleza', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (950, 2304459, 'Fortim', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (951, 2304509, 'Frecheirinha', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (952, 2304608, 'General Sampaio', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (953, 2304657, 'Graça', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (954, 2304707, 'Granja', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (955, 2304806, 'Granjeiro', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (956, 2304905, 'Groaíras', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (957, 2304954, 'Guaiúba', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (958, 2305001, 'Guaraciaba do Norte', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (959, 2305100, 'Guaramiranga', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (960, 2305209, 'Hidrolândia', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (961, 2305233, 'Horizonte', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (962, 2305266, 'Ibaretama', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (963, 2305308, 'Ibiapina', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (964, 2305332, 'Ibicuitinga', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (965, 2305357, 'Icapuí', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (966, 2305407, 'Icó', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (967, 2305506, 'Iguatu', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (968, 2305605, 'Independência', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (969, 2305654, 'Ipaporanga', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (970, 2305704, 'Ipaumirim', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (971, 2305803, 'Ipu', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (972, 2305902, 'Ipueiras', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (973, 2306009, 'Iracema', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (974, 2306108, 'Irauçuba', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (975, 2306207, 'Itaiçaba', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (976, 2306256, 'Itaitinga', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (977, 2306306, 'Itapagé', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (978, 2306405, 'Itapipoca', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (979, 2306504, 'Itapiúna', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (980, 2306553, 'Itarema', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (981, 2306603, 'Itatira', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (982, 2306702, 'Jaguaretama', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (983, 2306801, 'Jaguaribara', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (984, 2306900, 'Jaguaribe', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (985, 2307007, 'Jaguaruana', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (986, 2307106, 'Jardim', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (987, 2307205, 'Jati', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (988, 2307254, 'Jijoca de Jericoacoara', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (989, 2307304, 'Juazeiro do Norte', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (990, 2307403, 'Jucás', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (991, 2307502, 'Lavras da Mangabeira', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (992, 2307601, 'Limoeiro do Norte', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (993, 2307635, 'Madalena', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (994, 2307650, 'Maracanaú', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (995, 2307700, 'Maranguape', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (996, 2307809, 'Marco', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (997, 2307908, 'Martinópole', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (998, 2308005, 'Massapê', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (999, 2308104, 'Mauriti', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1000, 2308203, 'Meruoca', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1001, 2308302, 'Milagres', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1002, 2308351, 'Milhã', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1003, 2308377, 'Miraíma', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1004, 2308401, 'Missão Velha', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1005, 2308500, 'Mombaça', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1006, 2308609, 'Monsenhor Tabosa', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1007, 2308708, 'Morada Nova', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1008, 2308807, 'Moraújo', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1009, 2308906, 'Morrinhos', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1010, 2309003, 'Mucambo', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1011, 2309102, 'Mulungu', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1012, 2309201, 'Nova Olinda', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1013, 2309300, 'Nova Russas', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1014, 2309409, 'Novo Oriente', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1015, 2309458, 'Ocara', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1016, 2309508, 'Orós', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1017, 2309607, 'Pacajus', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1018, 2309706, 'Pacatuba', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1019, 2309805, 'Pacoti', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1020, 2309904, 'Pacujá', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1021, 2310001, 'Palhano', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1022, 2310100, 'Palmácia', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1023, 2310209, 'Paracuru', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1024, 2310258, 'Paraipaba', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1025, 2310308, 'Parambu', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1026, 2310407, 'Paramoti', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1027, 2310506, 'Pedra Branca', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1028, 2310605, 'Penaforte', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1029, 2310704, 'Pentecoste', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1030, 2310803, 'Pereiro', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1031, 2310852, 'Pindoretama', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1032, 2310902, 'Piquet Carneiro', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1033, 2310951, 'Pires Ferreira', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1034, 2311009, 'Poranga', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1035, 2311108, 'Porteiras', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1036, 2311207, 'Potengi', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1037, 2311231, 'Potiretama', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1038, 2311264, 'Quiterianópolis', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1039, 2311306, 'Quixadá', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1040, 2311355, 'Quixelô', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1041, 2311405, 'Quixeramobim', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1042, 2311504, 'Quixeré', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1043, 2311603, 'Redenção', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1044, 2311702, 'Reriutaba', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1045, 2311801, 'Russas', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1046, 2311900, 'Saboeiro', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1047, 2311959, 'Salitre', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1048, 2312205, 'Santa Quitéria', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1049, 2312007, 'Santana do Acaraú', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1050, 2312106, 'Santana do Cariri', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1051, 2312304, 'São Benedito', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1052, 2312403, 'São Gonçalo do Amarante', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1053, 2312502, 'São João do Jaguaribe', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1054, 2312601, 'São Luís do Curu', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1055, 2312700, 'Senador Pompeu', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1056, 2312809, 'Senador Sá', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1057, 2312908, 'Sobral', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1058, 2313005, 'Solonópole', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1059, 2313104, 'Tabuleiro do Norte', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1060, 2313203, 'Tamboril', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1061, 2313252, 'Tarrafas', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1062, 2313302, 'Tauá', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1063, 2313351, 'Tejuçuoca', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1064, 2313401, 'Tianguá', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1065, 2313500, 'Trairi', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1066, 2313559, 'Tururu', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1067, 2313609, 'Ubajara', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1068, 2313708, 'Umari', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1069, 2313757, 'Umirim', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1070, 2313807, 'Uruburetama', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1071, 2313906, 'Uruoca', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1072, 2313955, 'Varjota', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1073, 2314003, 'Várzea Alegre', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1074, 2314102, 'Viçosa do Ceará', NULL, 6)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1075, 2400109, 'Acari', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1076, 2400208, 'Açu', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1077, 2400307, 'Afonso Bezerra', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1078, 2400406, 'Água Nova', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1079, 2400505, 'Alexandria', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1080, 2400604, 'Almino Afonso', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1081, 2400703, 'Alto do Rodrigues', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1082, 2400802, 'Angicos', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1083, 2400901, 'Antônio Martins', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1084, 2401008, 'Apodi', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1085, 2401107, 'Areia Branca', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1086, 2401206, 'Arês', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1087, 2401305, 'Augusto Severo', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1088, 2401404, 'Baía Formosa', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1089, 2401453, 'Baraúna', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1090, 2401503, 'Barcelona', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1091, 2401602, 'Bento Fernandes', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1092, 2401651, 'Bodó', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1093, 2401701, 'Bom Jesus', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1094, 2401800, 'Brejinho', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1095, 2401859, 'Caiçara do Norte', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1096, 2401909, 'Caiçara do Rio do Vento', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1097, 2402006, 'Caicó', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1098, 2402105, 'Campo Redondo', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1099, 2402204, 'Canguaretama', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1100, 2402303, 'Caraúbas', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1101, 2402402, 'Carnaúba dos Dantas', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1102, 2402501, 'Carnaubais', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1103, 2402600, 'Ceará-Mirim', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1104, 2402709, 'Cerro Corá', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1105, 2402808, 'Coronel Ezequiel', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1106, 2402907, 'Coronel João Pessoa', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1107, 2403004, 'Cruzeta', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1108, 2403103, 'Currais Novos', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1109, 2403202, 'Doutor Severiano', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1110, 2403301, 'Encanto', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1111, 2403400, 'Equador', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1112, 2403509, 'Espírito Santo', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1113, 2403608, 'Extremoz', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1114, 2403707, 'Felipe Guerra', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1115, 2403756, 'Fernando Pedroza', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1116, 2403806, 'Florânia', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1117, 2403905, 'Francisco Dantas', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1118, 2404002, 'Frutuoso Gomes', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1119, 2404101, 'Galinhos', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1120, 2404200, 'Goianinha', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1121, 2404309, 'Governador Dix-Sept Rosado', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1122, 2404408, 'Grossos', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1123, 2404507, 'Guamaré', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1124, 2404606, 'Ielmo Marinho', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1125, 2404705, 'Ipanguaçu', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1126, 2404804, 'Ipueira', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1127, 2404853, 'Itajá', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1128, 2404903, 'Itaú', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1129, 2405009, 'Jaçanã', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1130, 2405108, 'Jandaíra', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1131, 2405207, 'Janduís', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1132, 2405306, 'Januário Cicco', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1133, 2405405, 'Japi', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1134, 2405504, 'Jardim de Angicos', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1135, 2405603, 'Jardim de Piranhas', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1136, 2405702, 'Jardim do Seridó', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1137, 2405801, 'João Câmara', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1138, 2405900, 'João Dias', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1139, 2406007, 'José da Penha', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1140, 2406106, 'Jucurutu', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1141, 2406155, 'Jundiá', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1142, 2406205, 'Lagoa d''Anta', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1143, 2406304, 'Lagoa de Pedras', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1144, 2406403, 'Lagoa de Velhos', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1145, 2406502, 'Lagoa Nova', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1146, 2406601, 'Lagoa Salgada', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1147, 2406700, 'Lajes', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1148, 2406809, 'Lajes Pintadas', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1149, 2406908, 'Lucrécia', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1150, 2407005, 'Luís Gomes', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1151, 2407104, 'Macaíba', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1152, 2407203, 'Macau', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1153, 2407252, 'Major Sales', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1154, 2407302, 'Marcelino Vieira', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1155, 2407401, 'Martins', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1156, 2407500, 'Maxaranguape', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1157, 2407609, 'Messias Targino', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1158, 2407708, 'Montanhas', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1159, 2407807, 'Monte Alegre', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1160, 2407906, 'Monte das Gameleiras', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1161, 2408003, 'Mossoró', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1162, 2408102, 'Natal', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1163, 2408201, 'Nísia Floresta', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1164, 2408300, 'Nova Cruz', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1165, 2408409, 'Olho-d''Água do Borges', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1166, 2408508, 'Ouro Branco', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1167, 2408607, 'Paraná', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1168, 2408706, 'Paraú', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1169, 2408805, 'Parazinho', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1170, 2408904, 'Parelhas', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1171, 2403251, 'Parnamirim', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1172, 2409100, 'Passa e Fica', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1173, 2409209, 'Passagem', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1174, 2409308, 'Patu', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1175, 2409407, 'Pau dos Ferros', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1176, 2409506, 'Pedra Grande', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1177, 2409605, 'Pedra Preta', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1178, 2409704, 'Pedro Avelino', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1179, 2409803, 'Pedro Velho', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1180, 2409902, 'Pendências', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1181, 2410009, 'Pilões', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1182, 2410108, 'Poço Branco', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1183, 2410207, 'Portalegre', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1184, 2410256, 'Porto do Mangue', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1185, 2410306, 'Presidente Juscelino', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1186, 2410405, 'Pureza', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1187, 2410504, 'Rafael Fernandes', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1188, 2410603, 'Rafael Godeiro', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1189, 2410702, 'Riacho da Cruz', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1190, 2410801, 'Riacho de Santana', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1191, 2410900, 'Riachuelo', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1192, 2408953, 'Rio do Fogo', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1193, 2411007, 'Rodolfo Fernandes', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1194, 2411106, 'Ruy Barbosa', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1195, 2411205, 'Santa Cruz', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1196, 2409332, 'Santa Maria', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1197, 2411403, 'Santana do Matos', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1198, 2411429, 'Santana do Seridó', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1199, 2411502, 'Santo Antônio', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1200, 2411601, 'São Bento do Norte', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1201, 2411700, 'São Bento do Trairí', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1202, 2411809, 'São Fernando', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1203, 2411908, 'São Francisco do Oeste', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1204, 2412005, 'São Gonçalo do Amarante', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1205, 2412104, 'São João do Sabugi', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1206, 2412203, 'São José de Mipibu', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1207, 2412302, 'São José do Campestre', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1208, 2412401, 'São José do Seridó', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1209, 2412500, 'São Miguel', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1210, 2412559, 'São Miguel do Gostoso', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1211, 2412609, 'São Paulo do Potengi', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1212, 2412708, 'São Pedro', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1213, 2412807, 'São Rafael', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1214, 2412906, 'São Tomé', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1215, 2413003, 'São Vicente', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1216, 2413102, 'Senador Elói de Souza', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1217, 2413201, 'Senador Georgino Avelino', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1218, 2413300, 'Serra de São Bento', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1219, 2413359, 'Serra do Mel', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1220, 2413409, 'Serra Negra do Norte', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1221, 2413508, 'Serrinha', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1222, 2413557, 'Serrinha dos Pintos', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1223, 2413607, 'Severiano Melo', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1224, 2413706, 'Sítio Novo', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1225, 2413805, 'Taboleiro Grande', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1226, 2413904, 'Taipu', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1227, 2414001, 'Tangará', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1228, 2414100, 'Tenente Ananias', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1229, 2414159, 'Tenente Laurentino Cruz', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1230, 2411056, 'Tibau', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1231, 2414209, 'Tibau do Sul', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1232, 2414308, 'Timbaúba dos Batistas', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1233, 2414407, 'Touros', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1234, 2414456, 'Triunfo Potiguar', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1235, 2414506, 'Umarizal', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1236, 2414605, 'Upanema', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1237, 2414704, 'Várzea', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1238, 2414753, 'Venha-Ver', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1239, 2414803, 'Vera Cruz', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1240, 2414902, 'Viçosa', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1241, 2415008, 'Vila Flor', NULL, 21)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1242, 2500106, 'Água Branca', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1243, 2500205, 'Aguiar', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1244, 2500304, 'Alagoa Grande', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1245, 2500403, 'Alagoa Nova', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1246, 2500502, 'Alagoinha', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1247, 2500536, 'Alcantil', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1248, 2500577, 'Algodão de Jandaíra', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1249, 2500601, 'Alhandra', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1250, 2500734, 'Amparo', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1251, 2500775, 'Aparecida', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1252, 2500809, 'Araçagi', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1253, 2500908, 'Arara', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1254, 2501005, 'Araruna', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1255, 2501104, 'Areia', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1256, 2501153, 'Areia de Baraúnas', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1257, 2501203, 'Areial', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1258, 2501302, 'Aroeiras', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1259, 2501351, 'Assunção', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1260, 2501401, 'Baía da Traição', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1261, 2501500, 'Bananeiras', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1262, 2501534, 'Baraúna', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1263, 2501609, 'Barra de Santa Rosa', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1264, 2501575, 'Barra de Santana', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1265, 2501708, 'Barra de São Miguel', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1266, 2501807, 'Bayeux', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1267, 2501906, 'Belém', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1268, 2502003, 'Belém do Brejo do Cruz', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1269, 2502052, 'Bernardino Batista', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1270, 2502102, 'Boa Ventura', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1271, 2502151, 'Boa Vista', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1272, 2502201, 'Bom Jesus', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1273, 2502300, 'Bom Sucesso', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1274, 2502409, 'Bonito de Santa Fé', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1275, 2502508, 'Boqueirão', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1276, 2502706, 'Borborema', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1277, 2502805, 'Brejo do Cruz', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1278, 2502904, 'Brejo dos Santos', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1279, 2503001, 'Caaporã', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1280, 2503100, 'Cabaceiras', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1281, 2503209, 'Cabedelo', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1282, 2503308, 'Cachoeira dos Índios', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1283, 2503407, 'Cacimba de Areia', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1284, 2503506, 'Cacimba de Dentro', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1285, 2503555, 'Cacimbas', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1286, 2503605, 'Caiçara', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1287, 2503704, 'Cajazeiras', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1288, 2503753, 'Cajazeirinhas', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1289, 2503803, 'Caldas Brandão', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1290, 2503902, 'Camalaú', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1291, 2504009, 'Campina Grande', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1292, 2516409, 'Campo de Santana', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1293, 2504033, 'Capim', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1294, 2504074, 'Caraúbas', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1295, 2504108, 'Carrapateira', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1296, 2504157, 'Casserengue', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1297, 2504207, 'Catingueira', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1298, 2504306, 'Catolé do Rocha', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1299, 2504355, 'Caturité', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1300, 2504405, 'Conceição', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1301, 2504504, 'Condado', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1302, 2504603, 'Conde', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1303, 2504702, 'Congo', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1304, 2504801, 'Coremas', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1305, 2504850, 'Coxixola', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1306, 2504900, 'Cruz do Espírito Santo', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1307, 2505006, 'Cubati', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1308, 2505105, 'Cuité', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1309, 2505238, 'Cuité de Mamanguape', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1310, 2505204, 'Cuitegi', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1311, 2505279, 'Curral de Cima', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1312, 2505303, 'Curral Velho', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1313, 2505352, 'Damião', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1314, 2505402, 'Desterro', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1315, 2505600, 'Diamante', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1316, 2505709, 'Dona Inês', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1317, 2505808, 'Duas Estradas', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1318, 2505907, 'Emas', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1319, 2506004, 'Esperança', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1320, 2506103, 'Fagundes', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1321, 2506202, 'Frei Martinho', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1322, 2506251, 'Gado Bravo', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1323, 2506301, 'Guarabira', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1324, 2506400, 'Gurinhém', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1325, 2506509, 'Gurjão', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1326, 2506608, 'Ibiara', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1327, 2502607, 'Igaracy', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1328, 2506707, 'Imaculada', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1329, 2506806, 'Ingá', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1330, 2506905, 'Itabaiana', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1331, 2507002, 'Itaporanga', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1332, 2507101, 'Itapororoca', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1333, 2507200, 'Itatuba', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1334, 2507309, 'Jacaraú', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1335, 2507408, 'Jericó', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1336, 2507507, 'João Pessoa', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1337, 2507606, 'Juarez Távora', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1338, 2507705, 'Juazeirinho', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1339, 2507804, 'Junco do Seridó', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1340, 2507903, 'Juripiranga', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1341, 2508000, 'Juru', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1342, 2508109, 'Lagoa', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1343, 2508208, 'Lagoa de Dentro', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1344, 2508307, 'Lagoa Seca', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1345, 2508406, 'Lastro', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1346, 2508505, 'Livramento', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1347, 2508554, 'Logradouro', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1348, 2508604, 'Lucena', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1349, 2508703, 'Mãe d''Água', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1350, 2508802, 'Malta', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1351, 2508901, 'Mamanguape', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1352, 2509008, 'Manaíra', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1353, 2509057, 'Marcação', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1354, 2509107, 'Mari', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1355, 2509156, 'Marizópolis', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1356, 2509206, 'Massaranduba', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1357, 2509305, 'Mataraca', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1358, 2509339, 'Matinhas', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1359, 2509370, 'Mato Grosso', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1360, 2509396, 'Maturéia', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1361, 2509404, 'Mogeiro', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1362, 2509503, 'Montadas', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1363, 2509602, 'Monte Horebe', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1364, 2509701, 'Monteiro', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1365, 2509800, 'Mulungu', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1366, 2509909, 'Natuba', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1367, 2510006, 'Nazarezinho', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1368, 2510105, 'Nova Floresta', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1369, 2510204, 'Nova Olinda', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1370, 2510303, 'Nova Palmeira', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1371, 2510402, 'Olho d''Água', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1372, 2510501, 'Olivedos', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1373, 2510600, 'Ouro Velho', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1374, 2510659, 'Parari', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1375, 2510709, 'Passagem', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1376, 2510808, 'Patos', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1377, 2510907, 'Paulista', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1378, 2511004, 'Pedra Branca', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1379, 2511103, 'Pedra Lavrada', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1380, 2511202, 'Pedras de Fogo', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1381, 2512721, 'Pedro Régis', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1382, 2511301, 'Piancó', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1383, 2511400, 'Picuí', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1384, 2511509, 'Pilar', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1385, 2511608, 'Pilões', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1386, 2511707, 'Pilõezinhos', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1387, 2511806, 'Pirpirituba', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1388, 2511905, 'Pitimbu', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1389, 2512002, 'Pocinhos', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1390, 2512036, 'Poço Dantas', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1391, 2512077, 'Poço de José de Moura', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1392, 2512101, 'Pombal', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1393, 2512200, 'Prata', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1394, 2512309, 'Princesa Isabel', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1395, 2512408, 'Puxinanã', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1396, 2512507, 'Queimadas', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1397, 2512606, 'Quixabá', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1398, 2512705, 'Remígio', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1399, 2512747, 'Riachão', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1400, 2512754, 'Riachão do Bacamarte', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1401, 2512762, 'Riachão do Poço', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1402, 2512788, 'Riacho de Santo Antônio', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1403, 2512804, 'Riacho dos Cavalos', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1404, 2512903, 'Rio Tinto', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1405, 2513000, 'Salgadinho', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1406, 2513109, 'Salgado de São Félix', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1407, 2513158, 'Santa Cecília', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1408, 2513208, 'Santa Cruz', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1409, 2513307, 'Santa Helena', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1410, 2513356, 'Santa Inês', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1411, 2513406, 'Santa Luzia', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1412, 2513703, 'Santa Rita', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1413, 2513802, 'Santa Teresinha', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1414, 2513505, 'Santana de Mangueira', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1415, 2513604, 'Santana dos Garrotes', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1416, 2513653, 'Santarém', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1417, 2513851, 'Santo André', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1418, 2513927, 'São Bentinho', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1419, 2513901, 'São Bento', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1420, 2513968, 'São Domingos', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1421, 2513943, 'São Domingos do Cariri', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1422, 2513984, 'São Francisco', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1423, 2514008, 'São João do Cariri', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1424, 2500700, 'São João do Rio do Peixe', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1425, 2514107, 'São João do Tigre', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1426, 2514206, 'São José da Lagoa Tapada', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1427, 2514305, 'São José de Caiana', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1428, 2514404, 'São José de Espinharas', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1429, 2514503, 'São José de Piranhas', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1430, 2514552, 'São José de Princesa', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1431, 2514602, 'São José do Bonfim', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1432, 2514651, 'São José do Brejo do Cruz', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1433, 2514701, 'São José do Sabugi', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1434, 2514800, 'São José dos Cordeiros', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1435, 2514453, 'São José dos Ramos', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1436, 2514909, 'São Mamede', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1437, 2515005, 'São Miguel de Taipu', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1438, 2515104, 'São Sebastião de Lagoa de Roça', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1439, 2515203, 'São Sebastião do Umbuzeiro', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1440, 2515302, 'Sapé', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1441, 2515401, 'Seridó', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1442, 2515500, 'Serra Branca', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1443, 2515609, 'Serra da Raiz', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1444, 2515708, 'Serra Grande', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1445, 2515807, 'Serra Redonda', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1446, 2515906, 'Serraria', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1447, 2515930, 'Sertãozinho', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1448, 2515971, 'Sobrado', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1449, 2516003, 'Solânea', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1450, 2516102, 'Soledade', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1451, 2516151, 'Sossêgo', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1452, 2516201, 'Sousa', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1453, 2516300, 'Sumé', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1454, 2516508, 'Taperoá', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1455, 2516607, 'Tavares', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1456, 2516706, 'Teixeira', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1457, 2516755, 'Tenório', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1458, 2516805, 'Triunfo', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1459, 2516904, 'Uiraúna', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1460, 2517001, 'Umbuzeiro', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1461, 2517100, 'Várzea', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1462, 2517209, 'Vieirópolis', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1463, 2505501, 'Vista Serrana', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1464, 2517407, 'Zabelê', NULL, 16)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1465, 2600054, 'Abreu e Lima', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1466, 2600104, 'Afogados da Ingazeira', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1467, 2600203, 'Afrânio', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1468, 2600302, 'Agrestina', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1469, 2600401, 'Água Preta', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1470, 2600500, 'Águas Belas', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1471, 2600609, 'Alagoinha', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1472, 2600708, 'Aliança', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1473, 2600807, 'Altinho', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1474, 2600906, 'Amaraji', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1475, 2601003, 'Angelim', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1476, 2601052, 'Araçoiaba', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1477, 2601102, 'Araripina', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1478, 2601201, 'Arcoverde', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1479, 2601300, 'Barra de Guabiraba', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1480, 2601409, 'Barreiros', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1481, 2601508, 'Belém de Maria', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1482, 2601607, 'Belém de São Francisco', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1483, 2601706, 'Belo Jardim', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1484, 2601805, 'Betânia', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1485, 2601904, 'Bezerros', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1486, 2602001, 'Bodocó', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1487, 2602100, 'Bom Conselho', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1488, 2602209, 'Bom Jardim', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1489, 2602308, 'Bonito', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1490, 2602407, 'Brejão', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1491, 2602506, 'Brejinho', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1492, 2602605, 'Brejo da Madre de Deus', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1493, 2602704, 'Buenos Aires', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1494, 2602803, 'Buíque', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1495, 2602902, 'Cabo de Santo Agostinho', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1496, 2603009, 'Cabrobó', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1497, 2603108, 'Cachoeirinha', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1498, 2603207, 'Caetés', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1499, 2603306, 'Calçado', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1500, 2603405, 'Calumbi', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1501, 2603454, 'Camaragibe', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1502, 2603504, 'Camocim de São Félix', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1503, 2603603, 'Camutanga', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1504, 2603702, 'Canhotinho', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1505, 2603801, 'Capoeiras', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1506, 2603900, 'Carnaíba', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1507, 2603926, 'Carnaubeira da Penha', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1508, 2604007, 'Carpina', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1509, 2604106, 'Caruaru', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1510, 2604155, 'Casinhas', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1511, 2604205, 'Catende', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1512, 2604304, 'Cedro', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1513, 2604403, 'Chã de Alegria', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1514, 2604502, 'Chã Grande', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1515, 2604601, 'Condado', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1516, 2604700, 'Correntes', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1517, 2604809, 'Cortês', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1518, 2604908, 'Cumaru', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1519, 2605004, 'Cupira', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1520, 2605103, 'Custódia', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1521, 2605152, 'Dormentes', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1522, 2605202, 'Escada', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1523, 2605301, 'Exu', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1524, 2605400, 'Feira Nova', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1525, 2605459, 'Fernando de Noronha', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1526, 2605509, 'Ferreiros', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1527, 2605608, 'Flores', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1528, 2605707, 'Floresta', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1529, 2605806, 'Frei Miguelinho', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1530, 2605905, 'Gameleira', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1531, 2606002, 'Garanhuns', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1532, 2606101, 'Glória do Goitá', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1533, 2606200, 'Goiana', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1534, 2606309, 'Granito', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1535, 2606408, 'Gravatá', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1536, 2606507, 'Iati', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1537, 2606606, 'Ibimirim', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1538, 2606705, 'Ibirajuba', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1539, 2606804, 'Igarassu', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1540, 2606903, 'Iguaraci', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1541, 2607604, 'Ilha de Itamaracá', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1542, 2607000, 'Inajá', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1543, 2607109, 'Ingazeira', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1544, 2607208, 'Ipojuca', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1545, 2607307, 'Ipubi', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1546, 2607406, 'Itacuruba', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1547, 2607505, 'Itaíba', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1548, 2607653, 'Itambé', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1549, 2607703, 'Itapetim', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1550, 2607752, 'Itapissuma', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1551, 2607802, 'Itaquitinga', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1552, 2607901, 'Jaboatão dos Guararapes', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1553, 2607950, 'Jaqueira', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1554, 2608008, 'Jataúba', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1555, 2608057, 'Jatobá', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1556, 2608107, 'João Alfredo', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1557, 2608206, 'Joaquim Nabuco', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1558, 2608255, 'Jucati', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1559, 2608305, 'Jupi', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1560, 2608404, 'Jurema', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1561, 2608453, 'Lagoa do Carro', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1562, 2608503, 'Lagoa do Itaenga', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1563, 2608602, 'Lagoa do Ouro', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1564, 2608701, 'Lagoa dos Gatos', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1565, 2608750, 'Lagoa Grande', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1566, 2608800, 'Lajedo', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1567, 2608909, 'Limoeiro', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1568, 2609006, 'Macaparana', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1569, 2609105, 'Machados', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1570, 2609154, 'Manari', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1571, 2609204, 'Maraial', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1572, 2609303, 'Mirandiba', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1573, 2614303, 'Moreilândia', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1574, 2609402, 'Moreno', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1575, 2609501, 'Nazaré da Mata', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1576, 2609600, 'Olinda', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1577, 2609709, 'Orobó', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1578, 2609808, 'Orocó', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1579, 2609907, 'Ouricuri', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1580, 2610004, 'Palmares', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1581, 2610103, 'Palmeirina', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1582, 2610202, 'Panelas', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1583, 2610301, 'Paranatama', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1584, 2610400, 'Parnamirim', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1585, 2610509, 'Passira', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1586, 2610608, 'Paudalho', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1587, 2610707, 'Paulista', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1588, 2610806, 'Pedra', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1589, 2610905, 'Pesqueira', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1590, 2611002, 'Petrolândia', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1591, 2611101, 'Petrolina', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1592, 2611200, 'Poção', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1593, 2611309, 'Pombos', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1594, 2611408, 'Primavera', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1595, 2611507, 'Quipapá', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1596, 2611533, 'Quixaba', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1597, 2611606, 'Recife', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1598, 2611705, 'Riacho das Almas', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1599, 2611804, 'Ribeirão', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1600, 2611903, 'Rio Formoso', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1601, 2612000, 'Sairé', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1602, 2612109, 'Salgadinho', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1603, 2612208, 'Salgueiro', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1604, 2612307, 'Saloá', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1605, 2612406, 'Sanharó', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1606, 2612455, 'Santa Cruz', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1607, 2612471, 'Santa Cruz da Baixa Verde', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1608, 2612505, 'Santa Cruz do Capibaribe', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1609, 2612554, 'Santa Filomena', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1610, 2612604, 'Santa Maria da Boa Vista', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1611, 2612703, 'Santa Maria do Cambucá', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1612, 2612802, 'Santa Terezinha', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1613, 2612901, 'São Benedito do Sul', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1614, 2613008, 'São Bento do Una', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1615, 2613107, 'São Caitano', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1616, 2613206, 'São João', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1617, 2613305, 'São Joaquim do Monte', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1618, 2613404, 'São José da Coroa Grande', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1619, 2613503, 'São José do Belmonte', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1620, 2613602, 'São José do Egito', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1621, 2613701, 'São Lourenço da Mata', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1622, 2613800, 'São Vicente Ferrer', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1623, 2613909, 'Serra Talhada', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1624, 2614006, 'Serrita', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1625, 2614105, 'Sertânia', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1626, 2614204, 'Sirinhaém', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1627, 2614402, 'Solidão', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1628, 2614501, 'Surubim', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1629, 2614600, 'Tabira', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1630, 2614709, 'Tacaimbó', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1631, 2614808, 'Tacaratu', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1632, 2614857, 'Tamandaré', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1633, 2615003, 'Taquaritinga do Norte', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1634, 2615102, 'Terezinha', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1635, 2615201, 'Terra Nova', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1636, 2615300, 'Timbaúba', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1637, 2615409, 'Toritama', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1638, 2615508, 'Tracunhaém', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1639, 2615607, 'Trindade', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1640, 2615706, 'Triunfo', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1641, 2615805, 'Tupanatinga', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1642, 2615904, 'Tuparetama', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1643, 2616001, 'Venturosa', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1644, 2616100, 'Verdejante', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1645, 2616183, 'Vertente do Lério', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1646, 2616209, 'Vertentes', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1647, 2616308, 'Vicência', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1648, 2616407, 'Vitória de Santo Antão', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1649, 2616506, 'Xexéu', NULL, 18)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1650, 2700102, 'Água Branca', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1651, 2700201, 'Anadia', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1652, 2700300, 'Arapiraca', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1653, 2700409, 'Atalaia', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1654, 2700508, 'Barra de Santo Antônio', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1655, 2700607, 'Barra de São Miguel', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1656, 2700706, 'Batalha', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1657, 2700805, 'Belém', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1658, 2700904, 'Belo Monte', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1659, 2701001, 'Boca da Mata', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1660, 2701100, 'Branquinha', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1661, 2701209, 'Cacimbinhas', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1662, 2701308, 'Cajueiro', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1663, 2701357, 'Campestre', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1664, 2701407, 'Campo Alegre', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1665, 2701506, 'Campo Grande', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1666, 2701605, 'Canapi', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1667, 2701704, 'Capela', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1668, 2701803, 'Carneiros', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1669, 2701902, 'Chã Preta', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1670, 2702009, 'Coité do Nóia', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1671, 2702108, 'Colônia Leopoldina', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1672, 2702207, 'Coqueiro Seco', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1673, 2702306, 'Coruripe', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1674, 2702355, 'Craíbas', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1675, 2702405, 'Delmiro Gouveia', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1676, 2702504, 'Dois Riachos', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1677, 2702553, 'Estrela de Alagoas', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1678, 2702603, 'Feira Grande', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1679, 2702702, 'Feliz Deserto', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1680, 2702801, 'Flexeiras', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1681, 2702900, 'Girau do Ponciano', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1682, 2703007, 'Ibateguara', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1683, 2703106, 'Igaci', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1684, 2703205, 'Igreja Nova', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1685, 2703304, 'Inhapi', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1686, 2703403, 'Jacaré dos Homens', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1687, 2703502, 'Jacuípe', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1688, 2703601, 'Japaratinga', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1689, 2703700, 'Jaramataia', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1690, 2703759, 'Jequiá da Praia', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1691, 2703809, 'Joaquim Gomes', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1692, 2703908, 'Jundiá', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1693, 2704005, 'Junqueiro', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1694, 2704104, 'Lagoa da Canoa', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1695, 2704203, 'Limoeiro de Anadia', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1696, 2704302, 'Maceió', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1697, 2704401, 'Major Isidoro', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1698, 2704906, 'Mar Vermelho', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1699, 2704500, 'Maragogi', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1700, 2704609, 'Maravilha', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1701, 2704708, 'Marechal Deodoro', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1702, 2704807, 'Maribondo', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1703, 2705002, 'Mata Grande', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1704, 2705101, 'Matriz de Camaragibe', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1705, 2705200, 'Messias', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1706, 2705309, 'Minador do Negrão', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1707, 2705408, 'Monteirópolis', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1708, 2705507, 'Murici', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1709, 2705606, 'Novo Lino', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1710, 2705705, 'Olho d''Água das Flores', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1711, 2705804, 'Olho d''Água do Casado', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1712, 2705903, 'Olho d''Água Grande', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1713, 2706000, 'Olivença', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1714, 2706109, 'Ouro Branco', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1715, 2706208, 'Palestina', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1716, 2706307, 'Palmeira dos Índios', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1717, 2706406, 'Pão de Açúcar', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1718, 2706422, 'Pariconha', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1719, 2706448, 'Paripueira', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1720, 2706505, 'Passo de Camaragibe', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1721, 2706604, 'Paulo Jacinto', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1722, 2706703, 'Penedo', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1723, 2706802, 'Piaçabuçu', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1724, 2706901, 'Pilar', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1725, 2707008, 'Pindoba', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1726, 2707107, 'Piranhas', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1727, 2707206, 'Poço das Trincheiras', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1728, 2707305, 'Porto Calvo', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1729, 2707404, 'Porto de Pedras', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1730, 2707503, 'Porto Real do Colégio', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1731, 2707602, 'Quebrangulo', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1732, 2707701, 'Rio Largo', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1733, 2707800, 'Roteiro', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1734, 2707909, 'Santa Luzia do Norte', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1735, 2708006, 'Santana do Ipanema', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1736, 2708105, 'Santana do Mundaú', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1737, 2708204, 'São Brás', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1738, 2708303, 'São José da Laje', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1739, 2708402, 'São José da Tapera', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1740, 2708501, 'São Luís do Quitunde', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1741, 2708600, 'São Miguel dos Campos', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1742, 2708709, 'São Miguel dos Milagres', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1743, 2708808, 'São Sebastião', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1744, 2708907, 'Satuba', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1745, 2708956, 'Senador Rui Palmeira', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1746, 2709004, 'Tanque d''Arca', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1747, 2709103, 'Taquarana', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1748, 2709152, 'Teotônio Vilela', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1749, 2709202, 'Traipu', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1750, 2709301, 'União dos Palmares', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1751, 2709400, 'Viçosa', NULL, 2)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1752, 2800100, 'Amparo de São Francisco', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1753, 2800209, 'Aquidabã', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1754, 2800308, 'Aracaju', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1755, 2800407, 'Arauá', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1756, 2800506, 'Areia Branca', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1757, 2800605, 'Barra dos Coqueiros', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1758, 2800670, 'Boquim', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1759, 2800704, 'Brejo Grande', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1760, 2801009, 'Campo do Brito', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1761, 2801108, 'Canhoba', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1762, 2801207, 'Canindé de São Francisco', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1763, 2801306, 'Capela', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1764, 2801405, 'Carira', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1765, 2801504, 'Carmópolis', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1766, 2801603, 'Cedro de São João', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1767, 2801702, 'Cristinápolis', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1768, 2801900, 'Cumbe', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1769, 2802007, 'Divina Pastora', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1770, 2802106, 'Estância', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1771, 2802205, 'Feira Nova', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1772, 2802304, 'Frei Paulo', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1773, 2802403, 'Gararu', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1774, 2802502, 'General Maynard', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1775, 2802601, 'Gracho Cardoso', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1776, 2802700, 'Ilha das Flores', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1777, 2802809, 'Indiaroba', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1778, 2802908, 'Itabaiana', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1779, 2803005, 'Itabaianinha', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1780, 2803104, 'Itabi', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1781, 2803203, 'Itaporanga d''Ajuda', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1782, 2803302, 'Japaratuba', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1783, 2803401, 'Japoatã', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1784, 2803500, 'Lagarto', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1785, 2803609, 'Laranjeiras', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1786, 2803708, 'Macambira', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1787, 2803807, 'Malhada dos Bois', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1788, 2803906, 'Malhador', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1789, 2804003, 'Maruim', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1790, 2804102, 'Moita Bonita', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1791, 2804201, 'Monte Alegre de Sergipe', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1792, 2804300, 'Muribeca', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1793, 2804409, 'Neópolis', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1794, 2804458, 'Nossa Senhora Aparecida', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1795, 2804508, 'Nossa Senhora da Glória', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1796, 2804607, 'Nossa Senhora das Dores', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1797, 2804706, 'Nossa Senhora de Lourdes', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1798, 2804805, 'Nossa Senhora do Socorro', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1799, 2804904, 'Pacatuba', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1800, 2805000, 'Pedra Mole', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1801, 2805109, 'Pedrinhas', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1802, 2805208, 'Pinhão', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1803, 2805307, 'Pirambu', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1804, 2805406, 'Poço Redondo', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1805, 2805505, 'Poço Verde', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1806, 2805604, 'Porto da Folha', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1807, 2805703, 'Propriá', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1808, 2805802, 'Riachão do Dantas', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1809, 2805901, 'Riachuelo', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1810, 2806008, 'Ribeirópolis', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1811, 2806107, 'Rosário do Catete', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1812, 2806206, 'Salgado', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1813, 2806305, 'Santa Luzia do Itanhy', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1814, 2806503, 'Santa Rosa de Lima', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1815, 2806404, 'Santana do São Francisco', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1816, 2806602, 'Santo Amaro das Brotas', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1817, 2806701, 'São Cristóvão', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1818, 2806800, 'São Domingos', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1819, 2806909, 'São Francisco', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1820, 2807006, 'São Miguel do Aleixo', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1821, 2807105, 'Simão Dias', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1822, 2807204, 'Siriri', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1823, 2807303, 'Telha', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1824, 2807402, 'Tobias Barreto', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1825, 2807501, 'Tomar do Geru', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1826, 2807600, 'Umbaúba', NULL, 26)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1827, 2900108, 'Abaíra', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1828, 2900207, 'Abaré', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1829, 2900306, 'Acajutiba', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1830, 2900355, 'Adustina', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1831, 2900405, 'Água Fria', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1832, 2900603, 'Aiquara', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1833, 2900702, 'Alagoinhas', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1834, 2900801, 'Alcobaça', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1835, 2900900, 'Almadina', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1836, 2901007, 'Amargosa', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1837, 2901106, 'Amélia Rodrigues', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1838, 2901155, 'América Dourada', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1839, 2901205, 'Anagé', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1840, 2901304, 'Andaraí', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1841, 2901353, 'Andorinha', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1842, 2901403, 'Angical', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1843, 2901502, 'Anguera', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1844, 2901601, 'Antas', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1845, 2901700, 'Antônio Cardoso', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1846, 2901809, 'Antônio Gonçalves', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1847, 2901908, 'Aporá', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1848, 2901957, 'Apuarema', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1849, 2902054, 'Araças', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1850, 2902005, 'Aracatu', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1851, 2902104, 'Araci', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1852, 2902203, 'Aramari', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1853, 2902252, 'Arataca', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1854, 2902302, 'Aratuípe', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1855, 2902401, 'Aurelino Leal', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1856, 2902500, 'Baianópolis', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1857, 2902609, 'Baixa Grande', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1858, 2902658, 'Banzaê', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1859, 2902708, 'Barra', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1860, 2902807, 'Barra da Estiva', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1861, 2902906, 'Barra do Choça', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1862, 2903003, 'Barra do Mendes', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1863, 2903102, 'Barra do Rocha', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1864, 2903201, 'Barreiras', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1865, 2903235, 'Barro Alto', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1866, 2903300, 'Barro Preto', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1867, 2903276, 'Barrocas', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1868, 2903409, 'Belmonte', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1869, 2903508, 'Belo Campo', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1870, 2903607, 'Biritinga', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1871, 2903706, 'Boa Nova', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1872, 2903805, 'Boa Vista do Tupim', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1873, 2903904, 'Bom Jesus da Lapa', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1874, 2903953, 'Bom Jesus da Serra', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1875, 2904001, 'Boninal', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1876, 2904050, 'Bonito', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1877, 2904100, 'Boquira', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1878, 2904209, 'Botuporã', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1879, 2904308, 'Brejões', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1880, 2904407, 'Brejolândia', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1881, 2904506, 'Brotas de Macaúbas', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1882, 2904605, 'Brumado', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1883, 2904704, 'Buerarema', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1884, 2904753, 'Buritirama', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1885, 2904803, 'Caatiba', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1886, 2904852, 'Cabaceiras do Paraguaçu', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1887, 2904902, 'Cachoeira', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1888, 2905008, 'Caculé', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1889, 2905107, 'Caém', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1890, 2905156, 'Caetanos', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1891, 2905206, 'Caetité', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1892, 2905305, 'Cafarnaum', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1893, 2905404, 'Cairu', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1894, 2905503, 'Caldeirão Grande', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1895, 2905602, 'Camacan', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1896, 2905701, 'Camaçari', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1897, 2905800, 'Camamu', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1898, 2905909, 'Campo Alegre de Lourdes', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1899, 2906006, 'Campo Formoso', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1900, 2906105, 'Canápolis', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1901, 2906204, 'Canarana', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1902, 2906303, 'Canavieiras', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1903, 2906402, 'Candeal', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1904, 2906501, 'Candeias', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1905, 2906600, 'Candiba', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1906, 2906709, 'Cândido Sales', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1907, 2906808, 'Cansanção', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1908, 2906824, 'Canudos', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1909, 2906857, 'Capela do Alto Alegre', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1910, 2906873, 'Capim Grosso', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1911, 2906899, 'Caraíbas', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1912, 2906907, 'Caravelas', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1913, 2907004, 'Cardeal da Silva', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1914, 2907103, 'Carinhanha', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1915, 2907202, 'Casa Nova', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1916, 2907301, 'Castro Alves', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1917, 2907400, 'Catolândia', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1918, 2907509, 'Catu', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1919, 2907558, 'Caturama', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1920, 2907608, 'Central', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1921, 2907707, 'Chorrochó', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1922, 2907806, 'Cícero Dantas', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1923, 2907905, 'Cipó', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1924, 2908002, 'Coaraci', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1925, 2908101, 'Cocos', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1926, 2908200, 'Conceição da Feira', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1927, 2908309, 'Conceição do Almeida', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1928, 2908408, 'Conceição do Coité', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1929, 2908507, 'Conceição do Jacuípe', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1930, 2908606, 'Conde', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1931, 2908705, 'Condeúba', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1932, 2908804, 'Contendas do Sincorá', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1933, 2908903, 'Coração de Maria', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1934, 2909000, 'Cordeiros', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1935, 2909109, 'Coribe', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1936, 2909208, 'Coronel João Sá', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1937, 2909307, 'Correntina', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1938, 2909406, 'Cotegipe', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1939, 2909505, 'Cravolândia', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1940, 2909604, 'Crisópolis', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1941, 2909703, 'Cristópolis', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1942, 2909802, 'Cruz das Almas', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1943, 2909901, 'Curaçá', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1944, 2910008, 'Dário Meira', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1945, 2910057, 'Dias d''Ávila', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1946, 2910107, 'Dom Basílio', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1947, 2910206, 'Dom Macedo Costa', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1948, 2910305, 'Elísio Medrado', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1949, 2910404, 'Encruzilhada', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1950, 2910503, 'Entre Rios', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1951, 2900504, 'Érico Cardoso', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1952, 2910602, 'Esplanada', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1953, 2910701, 'Euclides da Cunha', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1954, 2910727, 'Eunápolis', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1955, 2910750, 'Fátima', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1956, 2910776, 'Feira da Mata', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1957, 2910800, 'Feira de Santana', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1958, 2910859, 'Filadélfia', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1959, 2910909, 'Firmino Alves', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1960, 2911006, 'Floresta Azul', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1961, 2911105, 'Formosa do Rio Preto', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1962, 2911204, 'Gandu', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1963, 2911253, 'Gavião', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1964, 2911303, 'Gentio do Ouro', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1965, 2911402, 'Glória', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1966, 2911501, 'Gongogi', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1967, 2911600, 'Governador Mangabeira', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1968, 2911659, 'Guajeru', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1969, 2911709, 'Guanambi', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1970, 2911808, 'Guaratinga', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1971, 2911857, 'Heliópolis', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1972, 2911907, 'Iaçu', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1973, 2912004, 'Ibiassucê', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1974, 2912103, 'Ibicaraí', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1975, 2912202, 'Ibicoara', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1976, 2912301, 'Ibicuí', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1977, 2912400, 'Ibipeba', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1978, 2912509, 'Ibipitanga', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1979, 2912608, 'Ibiquera', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1980, 2912707, 'Ibirapitanga', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1981, 2912806, 'Ibirapuã', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1982, 2912905, 'Ibirataia', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1983, 2913002, 'Ibitiara', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1984, 2913101, 'Ibititá', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1985, 4104105, 'Campo do Tenente', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1986, 4104204, 'Campo Largo', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1987, 4104253, 'Campo Magro', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1988, 4104303, 'Campo Mourão', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1989, 4104402, 'Cândido de Abreu', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1990, 4104428, 'Candói', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1991, 4104451, 'Cantagalo', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1992, 4104501, 'Capanema', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1993, 4104600, 'Capitão Leônidas Marques', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1994, 4104659, 'Carambeí', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1995, 4104709, 'Carlópolis', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1996, 4104808, 'Cascavel', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1997, 4104907, 'Castro', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1998, 4105003, 'Catanduvas', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (1999, 4105102, 'Centenário do Sul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2000, 4105201, 'Cerro Azul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2001, 4105300, 'Céu Azul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2002, 4105409, 'Chopinzinho', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2003, 4105508, 'Cianorte', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2004, 4105607, 'Cidade Gaúcha', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2005, 4105706, 'Clevelândia', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2006, 4105805, 'Colombo', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2007, 4105904, 'Colorado', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2008, 4106001, 'Congonhinhas', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2009, 4106100, 'Conselheiro Mairinck', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2010, 4106209, 'Contenda', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2011, 4106308, 'Corbélia', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2012, 4106407, 'Cornélio Procópio', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2013, 4106456, 'Coronel Domingos Soares', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2014, 4106506, 'Coronel Vivida', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2015, 4106555, 'Corumbataí do Sul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2016, 4106803, 'Cruz Machado', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2017, 4106571, 'Cruzeiro do Iguaçu', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2018, 4106605, 'Cruzeiro do Oeste', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2019, 4106704, 'Cruzeiro do Sul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2020, 4106852, 'Cruzmaltina', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2021, 4106902, 'Curitiba', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2022, 4107009, 'Curiúva', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2023, 4107108, 'Diamante do Norte', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2024, 4107124, 'Diamante do Sul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2025, 4107157, 'Diamante d''Oeste', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2026, 4107207, 'Dois Vizinhos', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2027, 4107256, 'Douradina', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2028, 4107306, 'Doutor Camargo', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2029, 4128633, 'Doutor Ulysses', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2030, 4107405, 'Enéas Marques', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2031, 4107504, 'Engenheiro Beltrão', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2032, 4107538, 'Entre Rios do Oeste', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2033, 4107520, 'Esperança Nova', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2034, 4107546, 'Espigão Alto do Iguaçu', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2035, 4107553, 'Farol', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2036, 4107603, 'Faxinal', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2037, 4107652, 'Fazenda Rio Grande', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2038, 4107702, 'Fênix', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2039, 4107736, 'Fernandes Pinheiro', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2040, 4107751, 'Figueira', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2041, 4107850, 'Flor da Serra do Sul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2042, 4107801, 'Floraí', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2043, 4107900, 'Floresta', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2044, 4108007, 'Florestópolis', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2045, 4108106, 'Flórida', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2046, 4108205, 'Formosa do Oeste', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2047, 4108304, 'Foz do Iguaçu', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2048, 4108452, 'Foz do Jordão', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2049, 4108320, 'Francisco Alves', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2050, 4108403, 'Francisco Beltrão', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2051, 4108502, 'General Carneiro', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2052, 4108551, 'Godoy Moreira', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2053, 4108601, 'Goioerê', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2054, 4108650, 'Goioxim', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2055, 4108700, 'Grandes Rios', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2056, 4108809, 'Guaíra', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2057, 4108908, 'Guairaçá', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2058, 4108957, 'Guamiranga', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2059, 4109005, 'Guapirama', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2060, 4109104, 'Guaporema', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2061, 4109203, 'Guaraci', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2062, 4109302, 'Guaraniaçu', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2063, 4109401, 'Guarapuava', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2064, 4109500, 'Guaraqueçaba', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2065, 4109609, 'Guaratuba', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2066, 4109658, 'Honório Serpa', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2067, 4109708, 'Ibaiti', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2068, 4109757, 'Ibema', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2069, 4109807, 'Ibiporã', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2070, 4109906, 'Icaraíma', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2071, 4110003, 'Iguaraçu', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2072, 4110052, 'Iguatu', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2073, 4110078, 'Imbaú', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2074, 4110102, 'Imbituva', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2075, 4110201, 'Inácio Martins', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2076, 4110300, 'Inajá', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2077, 4110409, 'Indianópolis', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2078, 4110508, 'Ipiranga', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2079, 4110607, 'Iporã', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2080, 4110656, 'Iracema do Oeste', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2081, 4110706, 'Irati', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2082, 4110805, 'Iretama', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2083, 4110904, 'Itaguajé', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2084, 4110953, 'Itaipulândia', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2085, 4111001, 'Itambaracá', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2086, 4111100, 'Itambé', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2087, 4111209, 'Itapejara d''Oeste', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2088, 4111258, 'Itaperuçu', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2089, 4111308, 'Itaúna do Sul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2090, 4111407, 'Ivaí', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2091, 4111506, 'Ivaiporã', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2092, 4111555, 'Ivaté', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2093, 4111605, 'Ivatuba', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2094, 4111704, 'Jaboti', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2095, 4111803, 'Jacarezinho', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2096, 4111902, 'Jaguapitã', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2097, 4112009, 'Jaguariaíva', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2098, 4112108, 'Jandaia do Sul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2099, 4112207, 'Janiópolis', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2100, 4112306, 'Japira', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2101, 4112405, 'Japurá', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2102, 4112504, 'Jardim Alegre', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2103, 4112603, 'Jardim Olinda', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2104, 4112702, 'Jataizinho', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2105, 4112751, 'Jesuítas', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2106, 4112801, 'Joaquim Távora', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2107, 4112900, 'Jundiaí do Sul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2108, 4112959, 'Juranda', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2109, 4113007, 'Jussara', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2110, 4113106, 'Kaloré', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2111, 4113205, 'Lapa', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2112, 4113254, 'Laranjal', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2113, 4113304, 'Laranjeiras do Sul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2114, 4113403, 'Leópolis', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2115, 4113429, 'Lidianópolis', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2116, 4113452, 'Lindoeste', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2117, 4113502, 'Loanda', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2118, 4113601, 'Lobato', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2119, 4113700, 'Londrina', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2120, 4113734, 'Luiziana', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2121, 4113759, 'Lunardelli', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2122, 4113809, 'Lupionópolis', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2123, 4113908, 'Mallet', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2124, 4114005, 'Mamborê', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2125, 4114104, 'Mandaguaçu', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2126, 4114203, 'Mandaguari', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2127, 4114302, 'Mandirituba', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2128, 4114351, 'Manfrinópolis', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2129, 4114401, 'Mangueirinha', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2130, 4114500, 'Manoel Ribas', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2131, 4114609, 'Marechal Cândido Rondon', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2132, 4114708, 'Maria Helena', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2133, 4114807, 'Marialva', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2134, 4114906, 'Marilândia do Sul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2135, 4115002, 'Marilena', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2136, 4115101, 'Mariluz', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2137, 4115200, 'Maringá', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2138, 4115309, 'Mariópolis', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2139, 4115358, 'Maripá', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2140, 4115408, 'Marmeleiro', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2141, 4115457, 'Marquinho', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2142, 4115507, 'Marumbi', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2143, 4115606, 'Matelândia', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2144, 4115705, 'Matinhos', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2145, 4115739, 'Mato Rico', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2146, 4115754, 'Mauá da Serra', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2147, 4115804, 'Medianeira', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2148, 4115853, 'Mercedes', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2149, 4115903, 'Mirador', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2150, 4116000, 'Miraselva', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2151, 4116059, 'Missal', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2152, 4116109, 'Moreira Sales', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2153, 4116208, 'Morretes', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2154, 4116307, 'Munhoz de Melo', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2155, 4116406, 'Nossa Senhora das Graças', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2156, 4116505, 'Nova Aliança do Ivaí', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2157, 4116604, 'Nova América da Colina', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2158, 4116703, 'Nova Aurora', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2159, 4116802, 'Nova Cantu', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2160, 4116901, 'Nova Esperança', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2161, 4116950, 'Nova Esperança do Sudoeste', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2162, 4117008, 'Nova Fátima', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2163, 4117057, 'Nova Laranjeiras', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2164, 4117107, 'Nova Londrina', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2165, 4117206, 'Nova Olímpia', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2166, 4117255, 'Nova Prata do Iguaçu', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2167, 4117214, 'Nova Santa Bárbara', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2168, 4117222, 'Nova Santa Rosa', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2169, 4117271, 'Nova Tebas', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2170, 4117297, 'Novo Itacolomi', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2171, 4117305, 'Ortigueira', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2172, 4117404, 'Ourizona', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2173, 4117453, 'Ouro Verde do Oeste', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2174, 4117503, 'Paiçandu', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2175, 4117602, 'Palmas', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2176, 4117701, 'Palmeira', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2177, 4117800, 'Palmital', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2178, 4117909, 'Palotina', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2179, 4118006, 'Paraíso do Norte', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2180, 4118105, 'Paranacity', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2181, 4118204, 'Paranaguá', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2182, 4118303, 'Paranapoema', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2183, 4118402, 'Paranavaí', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2184, 4118451, 'Pato Bragado', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2185, 4118501, 'Pato Branco', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2186, 4118600, 'Paula Freitas', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2187, 4118709, 'Paulo Frontin', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2188, 4118808, 'Peabiru', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2189, 4118857, 'Perobal', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2190, 4118907, 'Pérola', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2191, 4119004, 'Pérola d''Oeste', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2192, 4119103, 'Piên', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2193, 4119152, 'Pinhais', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2194, 4119251, 'Pinhal de São Bento', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2195, 4119202, 'Pinhalão', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2196, 4119301, 'Pinhão', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2197, 4119400, 'Piraí do Sul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2198, 4119509, 'Piraquara', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2199, 4119608, 'Pitanga', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2200, 4119657, 'Pitangueiras', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2201, 4119707, 'Planaltina do Paraná', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2202, 4119806, 'Planalto', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2203, 4119905, 'Ponta Grossa', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2204, 4119954, 'Pontal do Paraná', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2205, 4120002, 'Porecatu', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2206, 4120101, 'Porto Amazonas', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2207, 4120150, 'Porto Barreiro', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2208, 4120200, 'Porto Rico', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2209, 4120309, 'Porto Vitória', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2210, 4120333, 'Prado Ferreira', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2211, 4120358, 'Pranchita', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2212, 4120408, 'Presidente Castelo Branco', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2213, 4120507, 'Primeiro de Maio', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2214, 4120606, 'Prudentópolis', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2215, 4120655, 'Quarto Centenário', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2216, 4120705, 'Quatiguá', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2217, 4120804, 'Quatro Barras', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2218, 4120853, 'Quatro Pontes', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2219, 4120903, 'Quedas do Iguaçu', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2220, 4121000, 'Querência do Norte', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2221, 4121109, 'Quinta do Sol', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2222, 4121208, 'Quitandinha', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2223, 4121257, 'Ramilândia', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2224, 4121307, 'Rancho Alegre', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2225, 4121356, 'Rancho Alegre d''Oeste', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2226, 4121406, 'Realeza', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2227, 4121505, 'Rebouças', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2228, 4121604, 'Renascença', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2229, 4121703, 'Reserva', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2230, 4121752, 'Reserva do Iguaçu', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2231, 4121802, 'Ribeirão Claro', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2232, 4121901, 'Ribeirão do Pinhal', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2233, 4122008, 'Rio Azul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2234, 4122107, 'Rio Bom', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2235, 4122156, 'Rio Bonito do Iguaçu', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2236, 4122172, 'Rio Branco do Ivaí', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2237, 4122206, 'Rio Branco do Sul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2238, 4122305, 'Rio Negro', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2239, 4122404, 'Rolândia', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2240, 4122503, 'Roncador', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2241, 4122602, 'Rondon', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2242, 4122651, 'Rosário do Ivaí', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2243, 4122701, 'Sabáudia', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2244, 4122800, 'Salgado Filho', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2245, 4122909, 'Salto do Itararé', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2246, 4123006, 'Salto do Lontra', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2247, 4123105, 'Santa Amélia', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2248, 4123204, 'Santa Cecília do Pavão', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2249, 4123303, 'Santa Cruz de Monte Castelo', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2250, 4123402, 'Santa Fé', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2251, 4123501, 'Santa Helena', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2252, 4123600, 'Santa Inês', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2253, 4123709, 'Santa Isabel do Ivaí', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2254, 4123808, 'Santa Izabel do Oeste', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2255, 4123824, 'Santa Lúcia', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2256, 4123857, 'Santa Maria do Oeste', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2257, 4123907, 'Santa Mariana', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2258, 4123956, 'Santa Mônica', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2259, 4124020, 'Santa Tereza do Oeste', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2260, 4124053, 'Santa Terezinha de Itaipu', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2261, 4124004, 'Santana do Itararé', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2262, 4124103, 'Santo Antônio da Platina', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2263, 4124202, 'Santo Antônio do Caiuá', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2264, 4124301, 'Santo Antônio do Paraíso', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2265, 4124400, 'Santo Antônio do Sudoeste', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2266, 4124509, 'Santo Inácio', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2267, 4124608, 'São Carlos do Ivaí', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2268, 4124707, 'São Jerônimo da Serra', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2269, 4124806, 'São João', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2270, 4124905, 'São João do Caiuá', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2271, 4125001, 'São João do Ivaí', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2272, 4125100, 'São João do Triunfo', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2273, 4125308, 'São Jorge do Ivaí', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2274, 4125357, 'São Jorge do Patrocínio', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2275, 4125209, 'São Jorge d''Oeste', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2276, 4125407, 'São José da Boa Vista', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2277, 4125456, 'São José das Palmeiras', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2278, 4125506, 'São José dos Pinhais', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2279, 4125555, 'São Manoel do Paraná', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2280, 4125605, 'São Mateus do Sul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2281, 4125704, 'São Miguel do Iguaçu', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2282, 4125753, 'São Pedro do Iguaçu', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2283, 4125803, 'São Pedro do Ivaí', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2284, 4125902, 'São Pedro do Paraná', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2285, 4126009, 'São Sebastião da Amoreira', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2286, 4126108, 'São Tomé', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2287, 4126207, 'Sapopema', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2288, 4126256, 'Sarandi', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2289, 4126272, 'Saudade do Iguaçu', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2290, 4126306, 'Sengés', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2291, 4126355, 'Serranópolis do Iguaçu', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2292, 4126405, 'Sertaneja', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2293, 4126504, 'Sertanópolis', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2294, 4126603, 'Siqueira Campos', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2295, 4126652, 'Sulina', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2296, 4126678, 'Tamarana', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2297, 4126702, 'Tamboara', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2298, 4126801, 'Tapejara', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2299, 4126900, 'Tapira', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2300, 4127007, 'Teixeira Soares', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2301, 4127106, 'Telêmaco Borba', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2302, 4127205, 'Terra Boa', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2303, 4127304, 'Terra Rica', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2304, 4127403, 'Terra Roxa', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2305, 4127502, 'Tibagi', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2306, 4127601, 'Tijucas do Sul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2307, 4127700, 'Toledo', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2308, 4127809, 'Tomazina', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2309, 4127858, 'Três Barras do Paraná', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2310, 4127882, 'Tunas do Paraná', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2311, 4127908, 'Tuneiras do Oeste', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2312, 4127957, 'Tupãssi', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2313, 4127965, 'Turvo', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2314, 4128005, 'Ubiratã', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2315, 4128104, 'Umuarama', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2316, 4128203, 'União da Vitória', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2317, 4128302, 'Uniflor', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2318, 4128401, 'Uraí', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2319, 4128534, 'Ventania', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2320, 4128559, 'Vera Cruz do Oeste', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2321, 4128609, 'Verê', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2322, 4128658, 'Virmond', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2323, 4128708, 'Vitorino', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2324, 4128500, 'Wenceslau Braz', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2325, 4128807, 'Xambrê', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2326, 4200051, 'Abdon Batista', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2327, 4200101, 'Abelardo Luz', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2328, 4200200, 'Agrolândia', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2329, 4200309, 'Agronômica', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2330, 4200408, 'Água Doce', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2331, 4200507, 'Águas de Chapecó', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2332, 4200556, 'Águas Frias', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2333, 4200606, 'Águas Mornas', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2334, 4200705, 'Alfredo Wagner', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2335, 4200754, 'Alto Bela Vista', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2336, 4200804, 'Anchieta', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2337, 4200903, 'Angelina', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2338, 4201000, 'Anita Garibaldi', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2339, 4201109, 'Anitápolis', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2340, 4201208, 'Antônio Carlos', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2341, 4201257, 'Apiúna', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2342, 4201273, 'Arabutã', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2343, 4201307, 'Araquari', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2344, 4201406, 'Araranguá', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2345, 4201505, 'Armazém', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2346, 4201604, 'Arroio Trinta', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2347, 4201653, 'Arvoredo', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2348, 4201703, 'Ascurra', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2349, 4201802, 'Atalanta', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2350, 4201901, 'Aurora', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2351, 4201950, 'Balneário Arroio do Silva', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2352, 4202057, 'Balneário Barra do Sul', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2353, 4202008, 'Balneário Camboriú', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2354, 4202073, 'Balneário Gaivota', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2355, 4212809, 'Balneário Piçarras', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2356, 4202081, 'Bandeirante', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2357, 4202099, 'Barra Bonita', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2358, 4202107, 'Barra Velha', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2359, 4202131, 'Bela Vista do Toldo', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2360, 4202156, 'Belmonte', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2361, 4202206, 'Benedito Novo', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2362, 4202305, 'Biguaçu', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2363, 4202404, 'Blumenau', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2364, 4202438, 'Bocaina do Sul', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2365, 4202503, 'Bom Jardim da Serra', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2366, 4202537, 'Bom Jesus', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2367, 4202578, 'Bom Jesus do Oeste', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2368, 4202602, 'Bom Retiro', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2369, 4202453, 'Bombinhas', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2370, 4202701, 'Botuverá', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2371, 4202800, 'Braço do Norte', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2372, 4202859, 'Braço do Trombudo', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2373, 4202875, 'Brunópolis', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2374, 4202909, 'Brusque', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2375, 4203006, 'Caçador', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2376, 4203105, 'Caibi', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2377, 4203154, 'Calmon', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2378, 4203204, 'Camboriú', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2379, 4203303, 'Campo Alegre', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2380, 4203402, 'Campo Belo do Sul', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2381, 4203501, 'Campo Erê', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2382, 4203600, 'Campos Novos', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2383, 4203709, 'Canelinha', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2384, 4203808, 'Canoinhas', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2385, 4203253, 'Capão Alto', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2386, 4203907, 'Capinzal', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2387, 4203956, 'Capivari de Baixo', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2388, 4204004, 'Catanduvas', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2389, 4204103, 'Caxambu do Sul', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2390, 4204152, 'Celso Ramos', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2391, 4204178, 'Cerro Negro', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2392, 4204194, 'Chapadão do Lageado', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2393, 4204202, 'Chapecó', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2394, 4204251, 'Cocal do Sul', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2395, 4204301, 'Concórdia', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2396, 4204350, 'Cordilheira Alta', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2397, 4204400, 'Coronel Freitas', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2398, 4204459, 'Coronel Martins', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2399, 4204558, 'Correia Pinto', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2400, 4204509, 'Corupá', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2401, 4204608, 'Criciúma', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2402, 4204707, 'Cunha Porã', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2403, 4204756, 'Cunhataí', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2404, 4204806, 'Curitibanos', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2405, 4204905, 'Descanso', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2406, 4205001, 'Dionísio Cerqueira', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2407, 4205100, 'Dona Emma', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2408, 4205159, 'Doutor Pedrinho', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2409, 4205175, 'Entre Rios', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2410, 4205191, 'Ermo', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2411, 4205209, 'Erval Velho', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2412, 4205308, 'Faxinal dos Guedes', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2413, 4205357, 'Flor do Sertão', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2414, 4205407, 'Florianópolis', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2415, 4205431, 'Formosa do Sul', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2416, 4205456, 'Forquilhinha', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2417, 4205506, 'Fraiburgo', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2418, 4205555, 'Frei Rogério', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2419, 4205605, 'Galvão', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2420, 4205704, 'Garopaba', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2421, 4205803, 'Garuva', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2422, 4205902, 'Gaspar', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2423, 4206009, 'Governador Celso Ramos', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2424, 4206108, 'Grão Pará', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2425, 4206207, 'Gravatal', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2426, 4206306, 'Guabiruba', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2427, 4206405, 'Guaraciaba', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2428, 4206504, 'Guaramirim', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2429, 4206603, 'Guarujá do Sul', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2430, 4206652, 'Guatambú', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2431, 4206702, 'Herval d''Oeste', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2432, 4206751, 'Ibiam', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2433, 4206801, 'Ibicaré', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2434, 4206900, 'Ibirama', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2435, 4207007, 'Içara', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2436, 4207106, 'Ilhota', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2437, 4207205, 'Imaruí', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2438, 4207304, 'Imbituba', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2439, 4207403, 'Imbuia', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2440, 4207502, 'Indaial', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2441, 4207577, 'Iomerê', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2442, 4207601, 'Ipira', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2443, 4207650, 'Iporã do Oeste', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2444, 4207684, 'Ipuaçu', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2445, 4207700, 'Ipumirim', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2446, 4207759, 'Iraceminha', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2447, 4207809, 'Irani', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2448, 4207858, 'Irati', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2449, 4207908, 'Irineópolis', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2450, 4208005, 'Itá', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2451, 4208104, 'Itaiópolis', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2452, 4208203, 'Itajaí', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2453, 4208302, 'Itapema', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2454, 4208401, 'Itapiranga', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2455, 4208450, 'Itapoá', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2456, 4208500, 'Ituporanga', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2457, 4208609, 'Jaborá', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2458, 4208708, 'Jacinto Machado', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2459, 4208807, 'Jaguaruna', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2460, 4208906, 'Jaraguá do Sul', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2461, 4208955, 'Jardinópolis', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2462, 4209003, 'Joaçaba', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2463, 4209102, 'Joinville', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2464, 4209151, 'José Boiteux', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2465, 4209177, 'Jupiá', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2466, 4209201, 'Lacerdópolis', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2467, 4209300, 'Lages', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2468, 4209409, 'Laguna', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2469, 4209458, 'Lajeado Grande', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2470, 4209508, 'Laurentino', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2471, 4209607, 'Lauro Muller', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2472, 4209706, 'Lebon Régis', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2473, 4209805, 'Leoberto Leal', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2474, 4209854, 'Lindóia do Sul', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2475, 4209904, 'Lontras', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2476, 4210001, 'Luiz Alves', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2477, 4210035, 'Luzerna', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2478, 4210050, 'Macieira', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2479, 4210100, 'Mafra', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2480, 4210209, 'Major Gercino', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2481, 4210308, 'Major Vieira', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2482, 4210407, 'Maracajá', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2483, 4210506, 'Maravilha', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2484, 4210555, 'Marema', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2485, 4210605, 'Massaranduba', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2486, 4210704, 'Matos Costa', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2487, 4210803, 'Meleiro', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2488, 4210852, 'Mirim Doce', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2489, 4210902, 'Modelo', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2490, 4211009, 'Mondaí', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2491, 4211058, 'Monte Carlo', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2492, 4211108, 'Monte Castelo', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2493, 4211207, 'Morro da Fumaça', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2494, 4211256, 'Morro Grande', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2495, 4211306, 'Navegantes', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2496, 4211405, 'Nova Erechim', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2497, 4211454, 'Nova Itaberaba', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2498, 4211504, 'Nova Trento', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2499, 4211603, 'Nova Veneza', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2500, 4211652, 'Novo Horizonte', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2501, 4211702, 'Orleans', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2502, 4211751, 'Otacílio Costa', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2503, 4211801, 'Ouro', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2504, 4211850, 'Ouro Verde', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2505, 4211876, 'Paial', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2506, 4211892, 'Painel', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2507, 4211900, 'Palhoça', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2508, 4212007, 'Palma Sola', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2509, 4212056, 'Palmeira', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2510, 4212106, 'Palmitos', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2511, 4212205, 'Papanduva', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2512, 4212239, 'Paraíso', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2513, 4212254, 'Passo de Torres', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2514, 4212270, 'Passos Maia', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2515, 4212304, 'Paulo Lopes', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2516, 4212403, 'Pedras Grandes', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2517, 4212502, 'Penha', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2518, 4212601, 'Peritiba', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2519, 4212700, 'Petrolândia', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2520, 4212908, 'Pinhalzinho', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2521, 4213005, 'Pinheiro Preto', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2522, 4213104, 'Piratuba', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2523, 4213153, 'Planalto Alegre', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2524, 4213203, 'Pomerode', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2525, 4213302, 'Ponte Alta', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2526, 4213351, 'Ponte Alta do Norte', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2527, 4213401, 'Ponte Serrada', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2528, 4213500, 'Porto Belo', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2529, 4213609, 'Porto União', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2530, 4213708, 'Pouso Redondo', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2531, 4213807, 'Praia Grande', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2532, 4213906, 'Presidente Castello Branco', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2533, 4214003, 'Presidente Getúlio', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2534, 4214102, 'Presidente Nereu', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2535, 4214151, 'Princesa', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2536, 4214201, 'Quilombo', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2537, 4214300, 'Rancho Queimado', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2538, 4214409, 'Rio das Antas', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2539, 4214508, 'Rio do Campo', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2540, 4214607, 'Rio do Oeste', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2541, 4214805, 'Rio do Sul', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2542, 4214706, 'Rio dos Cedros', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2543, 4214904, 'Rio Fortuna', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2544, 4215000, 'Rio Negrinho', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2545, 4215059, 'Rio Rufino', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2546, 4215075, 'Riqueza', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2547, 4215109, 'Rodeio', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2548, 4215208, 'Romelândia', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2549, 4215307, 'Salete', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2550, 4215356, 'Saltinho', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2551, 4215406, 'Salto Veloso', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2552, 4215455, 'Sangão', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2553, 4215505, 'Santa Cecília', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2554, 4215554, 'Santa Helena', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2555, 4215604, 'Santa Rosa de Lima', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2556, 4215653, 'Santa Rosa do Sul', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2557, 4215679, 'Santa Terezinha', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2558, 4215687, 'Santa Terezinha do Progresso', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2559, 4215695, 'Santiago do Sul', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2560, 4215703, 'Santo Amaro da Imperatriz', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2561, 4215802, 'São Bento do Sul', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2562, 4215752, 'São Bernardino', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2563, 4215901, 'São Bonifácio', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2564, 4216008, 'São Carlos', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2565, 4216057, 'São Cristovão do Sul', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2566, 4216107, 'São Domingos', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2567, 4216206, 'São Francisco do Sul', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2568, 4216305, 'São João Batista', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2569, 4216354, 'São João do Itaperiú', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2570, 4216255, 'São João do Oeste', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2571, 4216404, 'São João do Sul', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2572, 4216503, 'São Joaquim', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2573, 4216602, 'São José', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2574, 4216701, 'São José do Cedro', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2575, 4216800, 'São José do Cerrito', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2576, 4216909, 'São Lourenço do Oeste', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2577, 4217006, 'São Ludgero', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2578, 4217105, 'São Martinho', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2579, 4217154, 'São Miguel da Boa Vista', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2580, 4217204, 'São Miguel do Oeste', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2581, 4217253, 'São Pedro de Alcântara', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2582, 4217303, 'Saudades', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2583, 4217402, 'Schroeder', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2584, 4217501, 'Seara', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2585, 4217550, 'Serra Alta', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2586, 4217600, 'Siderópolis', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2587, 4217709, 'Sombrio', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2588, 4217758, 'Sul Brasil', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2589, 4217808, 'Taió', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2590, 4217907, 'Tangará', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2591, 4217956, 'Tigrinhos', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2592, 4218004, 'Tijucas', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2593, 4218103, 'Timbé do Sul', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2594, 4218202, 'Timbó', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2595, 4218251, 'Timbó Grande', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2596, 4218301, 'Três Barras', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2597, 4218350, 'Treviso', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2598, 4218400, 'Treze de Maio', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2599, 4218509, 'Treze Tílias', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2600, 4218608, 'Trombudo Central', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2601, 4218707, 'Tubarão', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2602, 4218756, 'Tunápolis', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2603, 4218806, 'Turvo', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2604, 4218855, 'União do Oeste', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2605, 4218905, 'Urubici', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2606, 4218954, 'Urupema', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2607, 4219002, 'Urussanga', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2608, 4219101, 'Vargeão', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2609, 4219150, 'Vargem', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2610, 4219176, 'Vargem Bonita', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2611, 4219200, 'Vidal Ramos', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2612, 4219309, 'Videira', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2613, 4219358, 'Vitor Meireles', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2614, 4219408, 'Witmarsum', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2615, 4219507, 'Xanxerê', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2616, 4219606, 'Xavantina', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2617, 4219705, 'Xaxim', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2618, 4219853, 'Zortéa', NULL, 25)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2619, 4300034, 'Aceguá', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2620, 4300059, 'Água Santa', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2621, 4300109, 'Agudo', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2622, 4300208, 'Ajuricaba', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2623, 4300307, 'Alecrim', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2624, 4300406, 'Alegrete', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2625, 4300455, 'Alegria', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2626, 4300471, 'Almirante Tamandaré do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2627, 4300505, 'Alpestre', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2628, 4300554, 'Alto Alegre', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2629, 4300570, 'Alto Feliz', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2630, 4300604, 'Alvorada', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2631, 4300638, 'Amaral Ferrador', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2632, 4300646, 'Ametista do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2633, 4300661, 'André da Rocha', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2634, 4300703, 'Anta Gorda', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2635, 4300802, 'Antônio Prado', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2636, 4300851, 'Arambaré', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2637, 4300877, 'Araricá', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2638, 4300901, 'Aratiba', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2639, 4301008, 'Arroio do Meio', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2640, 4301073, 'Arroio do Padre', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2641, 4301057, 'Arroio do Sal', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2642, 4301206, 'Arroio do Tigre', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2643, 4301107, 'Arroio dos Ratos', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2644, 4301305, 'Arroio Grande', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2645, 4301404, 'Arvorezinha', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2646, 4301503, 'Augusto Pestana', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2647, 4301552, 'Áurea', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2648, 4301602, 'Bagé', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2649, 4301636, 'Balneário Pinhal', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2650, 4301651, 'Barão', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2651, 4301701, 'Barão de Cotegipe', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2652, 4301750, 'Barão do Triunfo', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2653, 4301859, 'Barra do Guarita', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2654, 4301875, 'Barra do Quaraí', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2655, 4301909, 'Barra do Ribeiro', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2656, 4301925, 'Barra do Rio Azul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2657, 4301958, 'Barra Funda', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2658, 4301800, 'Barracão', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2659, 4302006, 'Barros Cassal', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2660, 4302055, 'Benjamin Constant do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2661, 4302105, 'Bento Gonçalves', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2662, 4302154, 'Boa Vista das Missões', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2663, 4302204, 'Boa Vista do Buricá', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2664, 4302220, 'Boa Vista do Cadeado', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2665, 4302238, 'Boa Vista do Incra', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2666, 4302253, 'Boa Vista do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2667, 4302303, 'Bom Jesus', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2668, 4302352, 'Bom Princípio', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2669, 4302378, 'Bom Progresso', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2670, 4302402, 'Bom Retiro do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2671, 4302451, 'Boqueirão do Leão', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2672, 4302501, 'Bossoroca', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2673, 4302584, 'Bozano', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2674, 4302600, 'Braga', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2675, 4302659, 'Brochier', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2676, 4302709, 'Butiá', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2677, 4302808, 'Caçapava do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2678, 4302907, 'Cacequi', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2679, 4303004, 'Cachoeira do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2680, 4303103, 'Cachoeirinha', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2681, 4303202, 'Cacique Doble', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2682, 4303301, 'Caibaté', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2683, 4303400, 'Caiçara', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2684, 4303509, 'Camaquã', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2685, 4303558, 'Camargo', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2686, 4303608, 'Cambará do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2687, 4303673, 'Campestre da Serra', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2688, 4303707, 'Campina das Missões', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2689, 4303806, 'Campinas do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2690, 4303905, 'Campo Bom', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2691, 4304002, 'Campo Novo', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2692, 4304101, 'Campos Borges', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2693, 4304200, 'Candelária', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2694, 4304309, 'Cândido Godói', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2695, 4304358, 'Candiota', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2696, 4304408, 'Canela', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2697, 4304507, 'Canguçu', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2698, 4304606, 'Canoas', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2699, 4304614, 'Canudos do Vale', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2700, 4304622, 'Capão Bonito do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2701, 4304630, 'Capão da Canoa', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2702, 4304655, 'Capão do Cipó', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2703, 4304663, 'Capão do Leão', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2704, 4304689, 'Capela de Santana', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2705, 4304697, 'Capitão', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2706, 4304671, 'Capivari do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2707, 4304713, 'Caraá', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2708, 4304705, 'Carazinho', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2709, 4304804, 'Carlos Barbosa', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2710, 4304853, 'Carlos Gomes', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2711, 4304903, 'Casca', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2712, 4304952, 'Caseiros', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2713, 4305009, 'Catuípe', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2714, 4305108, 'Caxias do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2715, 4305116, 'Centenário', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2716, 4305124, 'Cerrito', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2717, 4305132, 'Cerro Branco', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2718, 4305157, 'Cerro Grande', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2719, 4305173, 'Cerro Grande do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2720, 4305207, 'Cerro Largo', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2721, 4305306, 'Chapada', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2722, 4305355, 'Charqueadas', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2723, 4305371, 'Charrua', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2724, 4305405, 'Chiapetta', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2725, 4305439, 'Chuí', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2726, 4305447, 'Chuvisca', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2727, 4305454, 'Cidreira', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2728, 4305504, 'Ciríaco', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2729, 4305587, 'Colinas', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2730, 4305603, 'Colorado', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2731, 4305702, 'Condor', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2732, 4305801, 'Constantina', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2733, 4305835, 'Coqueiro Baixo', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2734, 4305850, 'Coqueiros do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2735, 4305871, 'Coronel Barros', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2736, 4305900, 'Coronel Bicaco', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2737, 4305934, 'Coronel Pilar', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2738, 4305959, 'Cotiporã', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2739, 4305975, 'Coxilha', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2740, 4306007, 'Crissiumal', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2741, 4306056, 'Cristal', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2742, 4306072, 'Cristal do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2743, 4306106, 'Cruz Alta', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2744, 4306130, 'Cruzaltense', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2745, 4306205, 'Cruzeiro do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2746, 4306304, 'David Canabarro', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2747, 4306320, 'Derrubadas', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2748, 4306353, 'Dezesseis de Novembro', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2749, 4306379, 'Dilermando de Aguiar', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2750, 4306403, 'Dois Irmãos', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2751, 4306429, 'Dois Irmãos das Missões', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2752, 4306452, 'Dois Lajeados', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2753, 4306502, 'Dom Feliciano', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2754, 4306601, 'Dom Pedrito', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2755, 4306551, 'Dom Pedro de Alcântara', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2756, 4306700, 'Dona Francisca', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2757, 4306734, 'Doutor Maurício Cardoso', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2758, 4306759, 'Doutor Ricardo', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2759, 4306767, 'Eldorado do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2760, 4306809, 'Encantado', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2761, 4306908, 'Encruzilhada do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2762, 4306924, 'Engenho Velho', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2763, 4306957, 'Entre Rios do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2764, 4306932, 'Entre-Ijuís', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2765, 4306973, 'Erebango', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2766, 4307005, 'Erechim', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2767, 4307054, 'Ernestina', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2768, 4307203, 'Erval Grande', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2769, 4307302, 'Erval Seco', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2770, 4307401, 'Esmeralda', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2771, 4307450, 'Esperança do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2772, 4307500, 'Espumoso', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2773, 4307559, 'Estação', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2774, 4307609, 'Estância Velha', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2775, 4307708, 'Esteio', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2776, 4307807, 'Estrela', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2777, 4307815, 'Estrela Velha', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2778, 4307831, 'Eugênio de Castro', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2779, 4307864, 'Fagundes Varela', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2780, 4307906, 'Farroupilha', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2781, 4308003, 'Faxinal do Soturno', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2782, 4308052, 'Faxinalzinho', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2783, 4308078, 'Fazenda Vilanova', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2784, 4308102, 'Feliz', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2785, 4308201, 'Flores da Cunha', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2786, 4308250, 'Floriano Peixoto', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2787, 4308300, 'Fontoura Xavier', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2788, 4308409, 'Formigueiro', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2789, 4308433, 'Forquetinha', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2790, 4308458, 'Fortaleza dos Valos', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2791, 4308508, 'Frederico Westphalen', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2792, 4308607, 'Garibaldi', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2793, 4308656, 'Garruchos', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2794, 4308706, 'Gaurama', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2795, 4308805, 'General Câmara', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2796, 4308854, 'Gentil', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2797, 4308904, 'Getúlio Vargas', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2798, 4309001, 'Giruá', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2799, 4309050, 'Glorinha', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2800, 4309100, 'Gramado', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2801, 4309126, 'Gramado dos Loureiros', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2802, 4309159, 'Gramado Xavier', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2803, 4309209, 'Gravataí', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2804, 4309258, 'Guabiju', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2805, 4309308, 'Guaíba', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2806, 4309407, 'Guaporé', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2807, 4309506, 'Guarani das Missões', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2808, 4309555, 'Harmonia', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2809, 4307104, 'Herval', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2810, 4309571, 'Herveiras', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2811, 4309605, 'Horizontina', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2812, 4309654, 'Hulha Negra', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2813, 4309704, 'Humaitá', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2814, 4309753, 'Ibarama', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2815, 4309803, 'Ibiaçá', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2816, 4309902, 'Ibiraiaras', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2817, 4309951, 'Ibirapuitã', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2818, 4310009, 'Ibirubá', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2819, 4310108, 'Igrejinha', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2820, 4310207, 'Ijuí', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2821, 4310306, 'Ilópolis', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2822, 4310330, 'Imbé', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2823, 4310363, 'Imigrante', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2824, 4310405, 'Independência', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2825, 4310413, 'Inhacorá', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2826, 4310439, 'Ipê', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2827, 4310462, 'Ipiranga do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2828, 4310504, 'Iraí', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2829, 4310538, 'Itaara', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2830, 4310553, 'Itacurubi', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2831, 4310579, 'Itapuca', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2832, 4310603, 'Itaqui', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2833, 4310652, 'Itati', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2834, 4310702, 'Itatiba do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2835, 4310751, 'Ivorá', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2836, 4310801, 'Ivoti', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2837, 4310850, 'Jaboticaba', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2838, 4310876, 'Jacuizinho', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2839, 4310900, 'Jacutinga', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2840, 4311007, 'Jaguarão', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2841, 4311106, 'Jaguari', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2842, 4311122, 'Jaquirana', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2843, 4311130, 'Jari', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2844, 4311155, 'Jóia', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2845, 4311205, 'Júlio de Castilhos', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2846, 4311239, 'Lagoa Bonita do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2847, 4311270, 'Lagoa dos Três Cantos', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2848, 4311304, 'Lagoa Vermelha', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2849, 4311254, 'Lagoão', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2850, 4311403, 'Lajeado', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2851, 4311429, 'Lajeado do Bugre', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2852, 4311502, 'Lavras do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2853, 4311601, 'Liberato Salzano', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2854, 4311627, 'Lindolfo Collor', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2855, 4311643, 'Linha Nova', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2856, 4311718, 'Maçambará', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2857, 4311700, 'Machadinho', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2858, 4311734, 'Mampituba', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2859, 4311759, 'Manoel Viana', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2860, 4311775, 'Maquiné', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2861, 4311791, 'Maratá', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2862, 4311809, 'Marau', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2863, 4311908, 'Marcelino Ramos', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2864, 4311981, 'Mariana Pimentel', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2865, 4312005, 'Mariano Moro', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2866, 4312054, 'Marques de Souza', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2867, 4312104, 'Mata', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2868, 4312138, 'Mato Castelhano', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2869, 4312153, 'Mato Leitão', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2870, 4312179, 'Mato Queimado', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2871, 4312203, 'Maximiliano de Almeida', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2872, 4312252, 'Minas do Leão', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2873, 4312302, 'Miraguaí', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2874, 4312351, 'Montauri', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2875, 4312377, 'Monte Alegre dos Campos', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2876, 4312385, 'Monte Belo do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2877, 4312401, 'Montenegro', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2878, 4312427, 'Mormaço', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2879, 4312443, 'Morrinhos do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2880, 4312450, 'Morro Redondo', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2881, 4312476, 'Morro Reuter', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2882, 4312500, 'Mostardas', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2883, 4312609, 'Muçum', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2884, 4312617, 'Muitos Capões', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2885, 4312625, 'Muliterno', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2886, 4312658, 'Não-Me-Toque', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2887, 4312674, 'Nicolau Vergueiro', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2888, 4312708, 'Nonoai', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2889, 4312757, 'Nova Alvorada', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2890, 4312807, 'Nova Araçá', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2891, 4312906, 'Nova Bassano', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2892, 4312955, 'Nova Boa Vista', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2893, 4313003, 'Nova Bréscia', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2894, 4313011, 'Nova Candelária', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2895, 4313037, 'Nova Esperança do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2896, 4313060, 'Nova Hartz', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2897, 4313086, 'Nova Pádua', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2898, 4313102, 'Nova Palma', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2899, 4313201, 'Nova Petrópolis', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2900, 4313300, 'Nova Prata', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2901, 4313334, 'Nova Ramada', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2902, 4313359, 'Nova Roma do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2903, 4313375, 'Nova Santa Rita', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2904, 4313490, 'Novo Barreiro', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2905, 4313391, 'Novo Cabrais', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2906, 4313409, 'Novo Hamburgo', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2907, 4313425, 'Novo Machado', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2908, 4313441, 'Novo Tiradentes', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2909, 4313466, 'Novo Xingu', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2910, 4313508, 'Osório', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2911, 4313607, 'Paim Filho', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2912, 4313656, 'Palmares do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2913, 4313706, 'Palmeira das Missões', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2914, 4313805, 'Palmitinho', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2915, 4313904, 'Panambi', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2916, 4313953, 'Pantano Grande', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2917, 4314001, 'Paraí', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2918, 4314027, 'Paraíso do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2919, 4314035, 'Pareci Novo', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2920, 4314050, 'Parobé', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2921, 4314068, 'Passa Sete', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2922, 4314076, 'Passo do Sobrado', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2923, 4314100, 'Passo Fundo', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2924, 4314134, 'Paulo Bento', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2925, 4314159, 'Paverama', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2926, 4314175, 'Pedras Altas', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2927, 4314209, 'Pedro Osório', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2928, 4314308, 'Pejuçara', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2929, 4314407, 'Pelotas', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2930, 4314423, 'Picada Café', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2931, 4314456, 'Pinhal', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2932, 4314464, 'Pinhal da Serra', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2933, 4314472, 'Pinhal Grande', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2934, 4314498, 'Pinheirinho do Vale', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2935, 4314506, 'Pinheiro Machado', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2936, 4314555, 'Pirapó', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2937, 4314605, 'Piratini', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2938, 4314704, 'Planalto', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2939, 4314753, 'Poço das Antas', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2940, 4314779, 'Pontão', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2941, 4314787, 'Ponte Preta', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2942, 4314803, 'Portão', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2943, 4314902, 'Porto Alegre', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2944, 4315008, 'Porto Lucena', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2945, 4315057, 'Porto Mauá', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2946, 4315073, 'Porto Vera Cruz', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2947, 4315107, 'Porto Xavier', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2948, 4315131, 'Pouso Novo', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2949, 4315149, 'Presidente Lucena', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2950, 4315156, 'Progresso', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2951, 4315172, 'Protásio Alves', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2952, 4315206, 'Putinga', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2953, 4315305, 'Quaraí', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2954, 4315313, 'Quatro Irmãos', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2955, 4315321, 'Quevedos', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2956, 4315354, 'Quinze de Novembro', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2957, 4315404, 'Redentora', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2958, 4315453, 'Relvado', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2959, 4315503, 'Restinga Seca', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2960, 4315552, 'Rio dos Índios', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2961, 4315602, 'Rio Grande', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2962, 4315701, 'Rio Pardo', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2963, 4315750, 'Riozinho', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2964, 4315800, 'Roca Sales', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2965, 4315909, 'Rodeio Bonito', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2966, 4315958, 'Rolador', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2967, 4316006, 'Rolante', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2968, 4316105, 'Ronda Alta', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2969, 4316204, 'Rondinha', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2970, 4316303, 'Roque Gonzales', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2971, 4316402, 'Rosário do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2972, 4316428, 'Sagrada Família', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2973, 4316436, 'Saldanha Marinho', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2974, 4316451, 'Salto do Jacuí', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2975, 4316477, 'Salvador das Missões', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2976, 4316501, 'Salvador do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2977, 4316600, 'Sananduva', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2978, 4316709, 'Santa Bárbara do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2979, 4316733, 'Santa Cecília do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2980, 4316758, 'Santa Clara do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2981, 4316808, 'Santa Cruz do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2982, 4316972, 'Santa Margarida do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2983, 4316907, 'Santa Maria', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2984, 4316956, 'Santa Maria do Herval', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2985, 4317202, 'Santa Rosa', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2986, 4317251, 'Santa Tereza', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2987, 4317301, 'Santa Vitória do Palmar', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2988, 4317004, 'Santana da Boa Vista', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2989, 4317103, 'Santana do Livramento', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2990, 4317400, 'Santiago', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2991, 4317509, 'Santo Ângelo', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2992, 4317608, 'Santo Antônio da Patrulha', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2993, 4317707, 'Santo Antônio das Missões', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2994, 4317558, 'Santo Antônio do Palma', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2995, 4317756, 'Santo Antônio do Planalto', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2996, 4317806, 'Santo Augusto', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2997, 4317905, 'Santo Cristo', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2998, 4317954, 'Santo Expedito do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (2999, 4318002, 'São Borja', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3000, 4318051, 'São Domingos do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3001, 4318101, 'São Francisco de Assis', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3002, 4318200, 'São Francisco de Paula', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3003, 4318309, 'São Gabriel', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3004, 4318408, 'São Jerônimo', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3005, 4318424, 'São João da Urtiga', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3006, 4318432, 'São João do Polêsine', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3007, 4318440, 'São Jorge', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3008, 4318457, 'São José das Missões', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3009, 4318465, 'São José do Herval', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3010, 4318481, 'São José do Hortêncio', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3011, 4318499, 'São José do Inhacorá', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3012, 4318507, 'São José do Norte', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3013, 4318606, 'São José do Ouro', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3014, 4318614, 'São José do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3015, 4318622, 'São José dos Ausentes', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3016, 4318705, 'São Leopoldo', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3017, 4318804, 'São Lourenço do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3018, 4318903, 'São Luiz Gonzaga', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3019, 4319000, 'São Marcos', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3020, 4319109, 'São Martinho', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3021, 4319125, 'São Martinho da Serra', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3022, 4319158, 'São Miguel das Missões', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3023, 4319208, 'São Nicolau', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3024, 4319307, 'São Paulo das Missões', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3025, 4319356, 'São Pedro da Serra', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3026, 4319364, 'São Pedro das Missões', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3027, 4319372, 'São Pedro do Butiá', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3028, 4319406, 'São Pedro do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3029, 4319505, 'São Sebastião do Caí', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3030, 4319604, 'São Sepé', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3031, 4319703, 'São Valentim', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3032, 4319711, 'São Valentim do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3033, 4319737, 'São Valério do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3034, 4319752, 'São Vendelino', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3035, 4319802, 'São Vicente do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3036, 4319901, 'Sapiranga', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3037, 4320008, 'Sapucaia do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3038, 4320107, 'Sarandi', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3039, 4320206, 'Seberi', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3040, 4320230, 'Sede Nova', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3041, 4320263, 'Segredo', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3042, 4320305, 'Selbach', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3043, 4320321, 'Senador Salgado Filho', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3044, 4320354, 'Sentinela do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3045, 4320404, 'Serafina Corrêa', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3046, 4320453, 'Sério', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3047, 4320503, 'Sertão', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3048, 4320552, 'Sertão Santana', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3049, 4320578, 'Sete de Setembro', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3050, 4320602, 'Severiano de Almeida', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3051, 4320651, 'Silveira Martins', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3052, 4320677, 'Sinimbu', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3053, 4320701, 'Sobradinho', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3054, 4320800, 'Soledade', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3055, 4320859, 'Tabaí', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3056, 4320909, 'Tapejara', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3057, 4321006, 'Tapera', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3058, 4321105, 'Tapes', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3059, 4321204, 'Taquara', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3060, 4321303, 'Taquari', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3061, 4321329, 'Taquaruçu do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3062, 4321352, 'Tavares', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3063, 4321402, 'Tenente Portela', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3064, 4321436, 'Terra de Areia', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3065, 4321451, 'Teutônia', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3066, 4321469, 'Tio Hugo', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3067, 4321477, 'Tiradentes do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3068, 4321493, 'Toropi', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3069, 4321501, 'Torres', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3070, 4321600, 'Tramandaí', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3071, 4321626, 'Travesseiro', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3072, 4321634, 'Três Arroios', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3073, 4321667, 'Três Cachoeiras', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3074, 4321709, 'Três Coroas', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3075, 4321808, 'Três de Maio', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3076, 4321832, 'Três Forquilhas', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3077, 4321857, 'Três Palmeiras', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3078, 4321907, 'Três Passos', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3079, 4321956, 'Trindade do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3080, 4322004, 'Triunfo', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3081, 4322103, 'Tucunduva', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3082, 4322152, 'Tunas', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3083, 4322186, 'Tupanci do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3084, 4322202, 'Tupanciretã', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3085, 4322251, 'Tupandi', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3086, 4322301, 'Tuparendi', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3087, 4322327, 'Turuçu', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3088, 4322343, 'Ubiretama', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3089, 4322350, 'União da Serra', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3090, 4322376, 'Unistalda', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3091, 4322400, 'Uruguaiana', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3092, 4322509, 'Vacaria', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3093, 4322533, 'Vale do Sol', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3094, 4322541, 'Vale Real', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3095, 4322525, 'Vale Verde', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3096, 4322558, 'Vanini', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3097, 4322608, 'Venâncio Aires', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3098, 4322707, 'Vera Cruz', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3099, 4322806, 'Veranópolis', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3100, 4322855, 'Vespasiano Correa', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3101, 4322905, 'Viadutos', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3102, 4323002, 'Viamão', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3103, 4323101, 'Vicente Dutra', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3104, 4323200, 'Victor Graeff', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3105, 4323309, 'Vila Flores', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3106, 4323358, 'Vila Lângaro', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3107, 4323408, 'Vila Maria', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3108, 4323457, 'Vila Nova do Sul', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3109, 4323507, 'Vista Alegre', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3110, 4323606, 'Vista Alegre do Prata', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3111, 4323705, 'Vista Gaúcha', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3112, 4323754, 'Vitória das Missões', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3113, 4323770, 'Westfalia', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3114, 4323804, 'Xangri-lá', NULL, 22)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3115, 5000203, 'Água Clara', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3116, 5000252, 'Alcinópolis', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3117, 5000609, 'Amambai', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3118, 5000708, 'Anastácio', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3119, 5000807, 'Anaurilândia', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3120, 5000856, 'Angélica', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3121, 5000906, 'Antônio João', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3122, 5001003, 'Aparecida do Taboado', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3123, 5001102, 'Aquidauana', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3124, 5001243, 'Aral Moreira', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3125, 5001508, 'Bandeirantes', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3126, 5001904, 'Bataguassu', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3127, 5002001, 'Batayporã', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3128, 5002100, 'Bela Vista', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3129, 5002159, 'Bodoquena', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3130, 5002209, 'Bonito', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3131, 5002308, 'Brasilândia', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3132, 5002407, 'Caarapó', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3133, 5002605, 'Camapuã', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3134, 5002704, 'Campo Grande', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3135, 5002803, 'Caracol', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3136, 5002902, 'Cassilândia', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3137, 5002951, 'Chapadão do Sul', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3138, 5003108, 'Corguinho', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3139, 5003157, 'Coronel Sapucaia', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3140, 5003207, 'Corumbá', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3141, 5003256, 'Costa Rica', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3142, 5003306, 'Coxim', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3143, 5003454, 'Deodápolis', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3144, 5003488, 'Dois Irmãos do Buriti', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3145, 5003504, 'Douradina', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3146, 5003702, 'Dourados', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3147, 5003751, 'Eldorado', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3148, 5003801, 'Fátima do Sul', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3149, 5003900, 'Figueirão', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3150, 5004007, 'Glória de Dourados', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3151, 5004106, 'Guia Lopes da Laguna', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3152, 5004304, 'Iguatemi', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3153, 5004403, 'Inocência', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3154, 5004502, 'Itaporã', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3155, 5004601, 'Itaquiraí', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3156, 5004700, 'Ivinhema', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3157, 5004809, 'Japorã', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3158, 5004908, 'Jaraguari', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3159, 5005004, 'Jardim', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3160, 5005103, 'Jateí', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3161, 5005152, 'Juti', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3162, 5005202, 'Ladário', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3163, 5005251, 'Laguna Carapã', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3164, 5005400, 'Maracaju', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3165, 5005608, 'Miranda', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3166, 5005681, 'Mundo Novo', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3167, 5005707, 'Naviraí', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3168, 5005806, 'Nioaque', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3169, 5006002, 'Nova Alvorada do Sul', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3170, 5006200, 'Nova Andradina', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3171, 5006259, 'Novo Horizonte do Sul', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3172, 5006309, 'Paranaíba', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3173, 5006358, 'Paranhos', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3174, 5006408, 'Pedro Gomes', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3175, 5006606, 'Ponta Porã', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3176, 5006903, 'Porto Murtinho', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3177, 5007109, 'Ribas do Rio Pardo', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3178, 5007208, 'Rio Brilhante', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3179, 5007307, 'Rio Negro', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3180, 5007406, 'Rio Verde de Mato Grosso', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3181, 5007505, 'Rochedo', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3182, 5007554, 'Santa Rita do Pardo', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3183, 5007695, 'São Gabriel do Oeste', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3184, 5007802, 'Selvíria', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3185, 5007703, 'Sete Quedas', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3186, 5007901, 'Sidrolândia', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3187, 5007935, 'Sonora', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3188, 5007950, 'Tacuru', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3189, 5007976, 'Taquarussu', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3190, 5008008, 'Terenos', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3191, 5008305, 'Três Lagoas', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3192, 5008404, 'Vicentina', NULL, 13)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3193, 5100102, 'Acorizal', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3194, 5100201, 'Água Boa', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3195, 5100250, 'Alta Floresta', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3196, 5100300, 'Alto Araguaia', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3197, 5100359, 'Alto Boa Vista', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3198, 5100409, 'Alto Garças', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3199, 5100508, 'Alto Paraguai', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3200, 5100607, 'Alto Taquari', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3201, 5100805, 'Apiacás', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3202, 5101001, 'Araguaiana', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3203, 5101209, 'Araguainha', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3204, 5101258, 'Araputanga', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3205, 5101308, 'Arenápolis', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3206, 5101407, 'Aripuanã', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3207, 5101605, 'Barão de Melgaço', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3208, 5101704, 'Barra do Bugres', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3209, 5101803, 'Barra do Garças', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3210, 5101852, 'Bom Jesus do Araguaia', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3211, 5101902, 'Brasnorte', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3212, 5102504, 'Cáceres', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3213, 5102603, 'Campinápolis', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3214, 5102637, 'Campo Novo do Parecis', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3215, 5102678, 'Campo Verde', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3216, 5102686, 'Campos de Júlio', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3217, 5102694, 'Canabrava do Norte', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3218, 5102702, 'Canarana', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3219, 5102793, 'Carlinda', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3220, 5102850, 'Castanheira', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3221, 5103007, 'Chapada dos Guimarães', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3222, 5103056, 'Cláudia', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3223, 5103106, 'Cocalinho', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3224, 5103205, 'Colíder', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3225, 5103254, 'Colniza', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3226, 5103304, 'Comodoro', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3227, 5103353, 'Confresa', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3228, 5103361, 'Conquista d''Oeste', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3229, 5103379, 'Cotriguaçu', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3230, 5103403, 'Cuiabá', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3231, 5103437, 'Curvelândia', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3232, 5103452, 'Denise', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3233, 5103502, 'Diamantino', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3234, 5103601, 'Dom Aquino', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3235, 5103700, 'Feliz Natal', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3236, 5103809, 'Figueirópolis d''Oeste', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3237, 5103858, 'Gaúcha do Norte', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3238, 5103908, 'General Carneiro', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3239, 5103957, 'Glória d''Oeste', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3240, 5104104, 'Guarantã do Norte', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3241, 5104203, 'Guiratinga', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3242, 5104500, 'Indiavaí', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3243, 5104526, 'Ipiranga do Norte', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3244, 5104542, 'Itanhangá', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3245, 5104559, 'Itaúba', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3246, 5104609, 'Itiquira', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3247, 5104807, 'Jaciara', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3248, 5104906, 'Jangada', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3249, 5105002, 'Jauru', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3250, 5105101, 'Juara', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3251, 5105150, 'Juína', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3252, 5105176, 'Juruena', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3253, 5105200, 'Juscimeira', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3254, 5105234, 'Lambari d''Oeste', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3255, 5105259, 'Lucas do Rio Verde', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3256, 5105309, 'Luciara', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3257, 5105580, 'Marcelândia', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3258, 5105606, 'Matupá', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3259, 5105622, 'Mirassol d''Oeste', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3260, 5105903, 'Nobres', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3261, 5106000, 'Nortelândia', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3262, 5106109, 'Nossa Senhora do Livramento', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3263, 5106158, 'Nova Bandeirantes', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3264, 5106208, 'Nova Brasilândia', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3265, 5106216, 'Nova Canaã do Norte', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3266, 5108808, 'Nova Guarita', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3267, 5106182, 'Nova Lacerda', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3268, 5108857, 'Nova Marilândia', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3269, 5108907, 'Nova Maringá', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3270, 5108956, 'Nova Monte Verde', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3271, 5106224, 'Nova Mutum', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3272, 5106174, 'Nova Nazaré', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3273, 5106232, 'Nova Olímpia', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3274, 5106190, 'Nova Santa Helena', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3275, 5106240, 'Nova Ubiratã', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3276, 5106257, 'Nova Xavantina', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3277, 5106273, 'Novo Horizonte do Norte', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3278, 5106265, 'Novo Mundo', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3279, 5106315, 'Novo Santo Antônio', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3280, 5106281, 'Novo São Joaquim', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3281, 5106299, 'Paranaíta', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3282, 5106307, 'Paranatinga', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3283, 5106372, 'Pedra Preta', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3284, 5106422, 'Peixoto de Azevedo', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3285, 5106455, 'Planalto da Serra', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3286, 5106505, 'Poconé', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3287, 5106653, 'Pontal do Araguaia', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3288, 5106703, 'Ponte Branca', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3289, 5106752, 'Pontes e Lacerda', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3290, 5106778, 'Porto Alegre do Norte', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3291, 5106802, 'Porto dos Gaúchos', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3292, 5106828, 'Porto Esperidião', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3293, 5106851, 'Porto Estrela', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3294, 5107008, 'Poxoréo', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3295, 5107040, 'Primavera do Leste', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3296, 5107065, 'Querência', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3297, 5107156, 'Reserva do Cabaçal', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3298, 5107180, 'Ribeirão Cascalheira', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3299, 5107198, 'Ribeirãozinho', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3300, 5107206, 'Rio Branco', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3301, 5107578, 'Rondolândia', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3302, 5107602, 'Rondonópolis', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3303, 5107701, 'Rosário Oeste', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3304, 5107750, 'Salto do Céu', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3305, 5107248, 'Santa Carmem', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3306, 5107743, 'Santa Cruz do Xingu', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3307, 5107768, 'Santa Rita do Trivelato', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3308, 5107776, 'Santa Terezinha', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3309, 5107263, 'Santo Afonso', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3310, 5107792, 'Santo Antônio do Leste', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3311, 5107800, 'Santo Antônio do Leverger', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3312, 5107859, 'São Félix do Araguaia', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3313, 5107297, 'São José do Povo', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3314, 5107305, 'São José do Rio Claro', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3315, 5107354, 'São José do Xingu', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3316, 5107107, 'São José dos Quatro Marcos', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3317, 5107404, 'São Pedro da Cipa', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3318, 5107875, 'Sapezal', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3319, 5107883, 'Serra Nova Dourada', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3320, 5107909, 'Sinop', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3321, 5107925, 'Sorriso', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3322, 5107941, 'Tabaporã', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3323, 5107958, 'Tangará da Serra', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3324, 5108006, 'Tapurah', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3325, 5108055, 'Terra Nova do Norte', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3326, 5108105, 'Tesouro', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3327, 5108204, 'Torixoréu', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3328, 5108303, 'União do Sul', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3329, 5108352, 'Vale de São Domingos', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3330, 5108402, 'Várzea Grande', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3331, 5108501, 'Vera', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3332, 5105507, 'Vila Bela da Santíssima Trindade', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3333, 5108600, 'Vila Rica', NULL, 12)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3334, 5200050, 'Abadia de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3335, 5200100, 'Abadiânia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3336, 5200134, 'Acreúna', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3337, 5200159, 'Adelândia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3338, 5200175, 'Água Fria de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3339, 5200209, 'Água Limpa', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3340, 5200258, 'Águas Lindas de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3341, 5200308, 'Alexânia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3342, 5200506, 'Aloândia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3343, 5200555, 'Alto Horizonte', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3344, 5200605, 'Alto Paraíso de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3345, 5200803, 'Alvorada do Norte', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3346, 5200829, 'Amaralina', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3347, 5200852, 'Americano do Brasil', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3348, 5200902, 'Amorinópolis', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3349, 5201108, 'Anápolis', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3350, 5201207, 'Anhanguera', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3351, 5201306, 'Anicuns', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3352, 5201405, 'Aparecida de Goiânia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3353, 5201454, 'Aparecida do Rio Doce', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3354, 5201504, 'Aporé', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3355, 5201603, 'Araçu', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3356, 5201702, 'Aragarças', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3357, 5201801, 'Aragoiânia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3358, 5202155, 'Araguapaz', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3359, 5202353, 'Arenópolis', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3360, 5202502, 'Aruanã', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3361, 5202601, 'Aurilândia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3362, 5202809, 'Avelinópolis', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3363, 5203104, 'Baliza', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3364, 5203203, 'Barro Alto', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3365, 5203302, 'Bela Vista de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3366, 5203401, 'Bom Jardim de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3367, 5203500, 'Bom Jesus de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3368, 5203559, 'Bonfinópolis', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3369, 5203575, 'Bonópolis', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3370, 5203609, 'Brazabrantes', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3371, 5203807, 'Britânia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3372, 5203906, 'Buriti Alegre', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3373, 5203939, 'Buriti de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3374, 5203962, 'Buritinópolis', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3375, 5204003, 'Cabeceiras', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3376, 5204102, 'Cachoeira Alta', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3377, 5204201, 'Cachoeira de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3378, 5204250, 'Cachoeira Dourada', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3379, 5204300, 'Caçu', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3380, 5204409, 'Caiapônia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3381, 5204508, 'Caldas Novas', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3382, 5204557, 'Caldazinha', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3383, 5204607, 'Campestre de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3384, 5204656, 'Campinaçu', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3385, 5204706, 'Campinorte', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3386, 5204805, 'Campo Alegre de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3387, 5204854, 'Campo Limpo de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3388, 5204904, 'Campos Belos', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3389, 5204953, 'Campos Verdes', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3390, 5205000, 'Carmo do Rio Verde', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3391, 5205059, 'Castelândia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3392, 5205109, 'Catalão', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3393, 5205208, 'Caturaí', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3394, 5205307, 'Cavalcante', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3395, 5205406, 'Ceres', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3396, 5205455, 'Cezarina', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3397, 5205471, 'Chapadão do Céu', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3398, 5205497, 'Cidade Ocidental', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3399, 5205513, 'Cocalzinho de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3400, 5205521, 'Colinas do Sul', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3401, 5205703, 'Córrego do Ouro', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3402, 5205802, 'Corumbá de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3403, 5205901, 'Corumbaíba', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3404, 5206206, 'Cristalina', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3405, 5206305, 'Cristianópolis', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3406, 5206404, 'Crixás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3407, 5206503, 'Cromínia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3408, 5206602, 'Cumari', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3409, 5206701, 'Damianópolis', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3410, 5206800, 'Damolândia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3411, 5206909, 'Davinópolis', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3412, 5207105, 'Diorama', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3413, 5208301, 'Divinópolis de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3414, 5207253, 'Doverlândia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3415, 5207352, 'Edealina', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3416, 5207402, 'Edéia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3417, 5207501, 'Estrela do Norte', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3418, 5207535, 'Faina', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3419, 5207600, 'Fazenda Nova', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3420, 5207808, 'Firminópolis', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3421, 5207907, 'Flores de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3422, 5208004, 'Formosa', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3423, 5208103, 'Formoso', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3424, 5208152, 'Gameleira de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3425, 5208400, 'Goianápolis', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3426, 5208509, 'Goiandira', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3427, 5208608, 'Goianésia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3428, 5208707, 'Goiânia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3429, 5208806, 'Goianira', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3430, 5208905, 'Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3431, 5209101, 'Goiatuba', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3432, 5209150, 'Gouvelândia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3433, 5209200, 'Guapó', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3434, 5209291, 'Guaraíta', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3435, 5209408, 'Guarani de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3436, 5209457, 'Guarinos', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3437, 5209606, 'Heitoraí', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3438, 5209705, 'Hidrolândia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3439, 5209804, 'Hidrolina', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3440, 5209903, 'Iaciara', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3441, 5209937, 'Inaciolândia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3442, 5209952, 'Indiara', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3443, 5210000, 'Inhumas', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3444, 5210109, 'Ipameri', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3445, 5210158, 'Ipiranga de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3446, 5210208, 'Iporá', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3447, 5210307, 'Israelândia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3448, 5210406, 'Itaberaí', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3449, 5210562, 'Itaguari', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3450, 5210604, 'Itaguaru', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3451, 5210802, 'Itajá', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3452, 5210901, 'Itapaci', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3453, 5211008, 'Itapirapuã', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3454, 5211206, 'Itapuranga', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3455, 5211305, 'Itarumã', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3456, 5211404, 'Itauçu', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3457, 5211503, 'Itumbiara', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3458, 5211602, 'Ivolândia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3459, 5211701, 'Jandaia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3460, 5211800, 'Jaraguá', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3461, 5211909, 'Jataí', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3462, 5212006, 'Jaupaci', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3463, 5212055, 'Jesúpolis', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3464, 5212105, 'Joviânia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3465, 5212204, 'Jussara', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3466, 5212253, 'Lagoa Santa', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3467, 5212303, 'Leopoldo de Bulhões', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3468, 5212501, 'Luziânia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3469, 5212600, 'Mairipotaba', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3470, 5212709, 'Mambaí', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3471, 5212808, 'Mara Rosa', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3472, 5212907, 'Marzagão', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3473, 5212956, 'Matrinchã', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3474, 5213004, 'Maurilândia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3475, 5213053, 'Mimoso de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3476, 5213087, 'Minaçu', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3477, 5213103, 'Mineiros', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3478, 5213400, 'Moiporá', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3479, 5213509, 'Monte Alegre de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3480, 5213707, 'Montes Claros de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3481, 5213756, 'Montividiu', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3482, 5213772, 'Montividiu do Norte', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3483, 5213806, 'Morrinhos', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3484, 5213855, 'Morro Agudo de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3485, 5213905, 'Mossâmedes', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3486, 5214002, 'Mozarlândia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3487, 5214051, 'Mundo Novo', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3488, 5214101, 'Mutunópolis', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3489, 5214408, 'Nazário', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3490, 5214507, 'Nerópolis', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3491, 5214606, 'Niquelândia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3492, 5214705, 'Nova América', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3493, 5214804, 'Nova Aurora', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3494, 5214838, 'Nova Crixás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3495, 5214861, 'Nova Glória', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3496, 5214879, 'Nova Iguaçu de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3497, 5214903, 'Nova Roma', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3498, 5215009, 'Nova Veneza', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3499, 5215207, 'Novo Brasil', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3500, 5215231, 'Novo Gama', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3501, 5215256, 'Novo Planalto', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3502, 5215306, 'Orizona', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3503, 5215405, 'Ouro Verde de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3504, 5215504, 'Ouvidor', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3505, 5215603, 'Padre Bernardo', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3506, 5215652, 'Palestina de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3507, 5215702, 'Palmeiras de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3508, 5215801, 'Palmelo', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3509, 5215900, 'Palminópolis', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3510, 5216007, 'Panamá', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3511, 5216304, 'Paranaiguara', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3512, 5216403, 'Paraúna', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3513, 5216452, 'Perolândia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3514, 5216809, 'Petrolina de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3515, 5216908, 'Pilar de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3516, 5217104, 'Piracanjuba', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3517, 5217203, 'Piranhas', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3518, 5217302, 'Pirenópolis', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3519, 5217401, 'Pires do Rio', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3520, 5217609, 'Planaltina', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3521, 5217708, 'Pontalina', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3522, 5218003, 'Porangatu', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3523, 5218052, 'Porteirão', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3524, 5218102, 'Portelândia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3525, 5218300, 'Posse', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3526, 5218391, 'Professor Jamil', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3527, 5218508, 'Quirinópolis', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3528, 5218607, 'Rialma', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3529, 5218706, 'Rianápolis', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3530, 5218789, 'Rio Quente', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3531, 5218805, 'Rio Verde', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3532, 5218904, 'Rubiataba', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3533, 5219001, 'Sanclerlândia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3534, 5219100, 'Santa Bárbara de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3535, 5219209, 'Santa Cruz de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3536, 5219258, 'Santa Fé de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3537, 5219308, 'Santa Helena de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3538, 5219357, 'Santa Isabel', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3539, 5219407, 'Santa Rita do Araguaia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3540, 5219456, 'Santa Rita do Novo Destino', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3541, 5219506, 'Santa Rosa de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3542, 5219605, 'Santa Tereza de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3543, 5219704, 'Santa Terezinha de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3544, 5219712, 'Santo Antônio da Barra', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3545, 5219738, 'Santo Antônio de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3546, 5219753, 'Santo Antônio do Descoberto', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3547, 5219803, 'São Domingos', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3548, 5219902, 'São Francisco de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3549, 5220058, 'São João da Paraúna', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3550, 5220009, 'São João d''Aliança', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3551, 5220108, 'São Luís de Montes Belos', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3552, 5220157, 'São Luíz do Norte', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3553, 5220207, 'São Miguel do Araguaia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3554, 5220264, 'São Miguel do Passa Quatro', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3555, 5220280, 'São Patrício', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3556, 5220405, 'São Simão', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3557, 5220454, 'Senador Canedo', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3558, 5220504, 'Serranópolis', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3559, 5220603, 'Silvânia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3560, 5220686, 'Simolândia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3561, 5220702, 'Sítio d''Abadia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3562, 5221007, 'Taquaral de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3563, 5221080, 'Teresina de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3564, 5221197, 'Terezópolis de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3565, 5221304, 'Três Ranchos', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3566, 5221403, 'Trindade', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3567, 5221452, 'Trombas', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3568, 5221502, 'Turvânia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3569, 5221551, 'Turvelândia', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3570, 5221577, 'Uirapuru', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3571, 5221601, 'Uruaçu', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3572, 5221700, 'Uruana', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3573, 5221809, 'Urutaí', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3574, 5221858, 'Valparaíso de Goiás', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3575, 5221908, 'Varjão', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3576, 5222005, 'Vianópolis', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3577, 5222054, 'Vicentinópolis', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3578, 5222203, 'Vila Boa', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3579, 5222302, 'Vila Propício', NULL, 9)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3580, 5300108, 'Brasília', NULL, 7)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3581, 2913200, 'Ibotirama', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3582, 2913309, 'Ichu', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3583, 2913408, 'Igaporã', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3584, 2913457, 'Igrapiúna', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3585, 2913507, 'Iguaí', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3586, 2913606, 'Ilhéus', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3587, 2913705, 'Inhambupe', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3588, 2913804, 'Ipecaetá', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3589, 2913903, 'Ipiaú', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3590, 2914000, 'Ipirá', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3591, 2914109, 'Ipupiara', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3592, 2914208, 'Irajuba', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3593, 2914307, 'Iramaia', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3594, 2914406, 'Iraquara', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3595, 2914505, 'Irará', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3596, 2914604, 'Irecê', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3597, 2914653, 'Itabela', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3598, 2914703, 'Itaberaba', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3599, 2914802, 'Itabuna', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3600, 2914901, 'Itacaré', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3601, 2915007, 'Itaeté', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3602, 2915106, 'Itagi', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3603, 2915205, 'Itagibá', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3604, 2915304, 'Itagimirim', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3605, 2915353, 'Itaguaçu da Bahia', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3606, 2915403, 'Itaju do Colônia', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3607, 2915502, 'Itajuípe', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3608, 2915601, 'Itamaraju', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3609, 2915700, 'Itamari', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3610, 2915809, 'Itambé', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3611, 2915908, 'Itanagra', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3612, 2916005, 'Itanhém', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3613, 2916104, 'Itaparica', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3614, 2916203, 'Itapé', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3615, 2916302, 'Itapebi', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3616, 2916401, 'Itapetinga', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3617, 2916500, 'Itapicuru', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3618, 2916609, 'Itapitanga', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3619, 2916708, 'Itaquara', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3620, 2916807, 'Itarantim', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3621, 2916856, 'Itatim', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3622, 2916906, 'Itiruçu', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3623, 2917003, 'Itiúba', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3624, 2917102, 'Itororó', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3625, 2917201, 'Ituaçu', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3626, 2917300, 'Ituberá', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3627, 2917334, 'Iuiú', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3628, 2917359, 'Jaborandi', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3629, 2917409, 'Jacaraci', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3630, 2917508, 'Jacobina', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3631, 2917607, 'Jaguaquara', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3632, 2917706, 'Jaguarari', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3633, 2917805, 'Jaguaripe', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3634, 2917904, 'Jandaíra', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3635, 2918001, 'Jequié', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3636, 2918100, 'Jeremoabo', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3637, 2918209, 'Jiquiriçá', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3638, 2918308, 'Jitaúna', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3639, 2918357, 'João Dourado', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3640, 2918407, 'Juazeiro', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3641, 2918456, 'Jucuruçu', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3642, 2918506, 'Jussara', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3643, 2918555, 'Jussari', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3644, 2918605, 'Jussiape', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3645, 2918704, 'Lafaiete Coutinho', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3646, 2918753, 'Lagoa Real', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3647, 2918803, 'Laje', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3648, 2918902, 'Lajedão', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3649, 2919009, 'Lajedinho', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3650, 2919058, 'Lajedo do Tabocal', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3651, 2919108, 'Lamarão', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3652, 2919157, 'Lapão', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3653, 2919207, 'Lauro de Freitas', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3654, 2919306, 'Lençóis', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3655, 2919405, 'Licínio de Almeida', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3656, 2919504, 'Livramento de Nossa Senhora', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3657, 2919553, 'Luís Eduardo Magalhães', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3658, 2919603, 'Macajuba', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3659, 2919702, 'Macarani', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3660, 2919801, 'Macaúbas', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3661, 2919900, 'Macururé', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3662, 2919926, 'Madre de Deus', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3663, 2919959, 'Maetinga', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3664, 2920007, 'Maiquinique', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3665, 2920106, 'Mairi', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3666, 2920205, 'Malhada', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3667, 2920304, 'Malhada de Pedras', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3668, 2920403, 'Manoel Vitorino', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3669, 2920452, 'Mansidão', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3670, 2920502, 'Maracás', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3671, 2920601, 'Maragogipe', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3672, 2920700, 'Maraú', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3673, 2920809, 'Marcionílio Souza', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3674, 2920908, 'Mascote', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3675, 2921005, 'Mata de São João', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3676, 2921054, 'Matina', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3677, 2921104, 'Medeiros Neto', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3678, 2921203, 'Miguel Calmon', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3679, 2921302, 'Milagres', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3680, 2921401, 'Mirangaba', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3681, 2921450, 'Mirante', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3682, 2921500, 'Monte Santo', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3683, 2921609, 'Morpará', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3684, 2921708, 'Morro do Chapéu', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3685, 2921807, 'Mortugaba', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3686, 2921906, 'Mucugê', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3687, 2922003, 'Mucuri', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3688, 2922052, 'Mulungu do Morro', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3689, 2922102, 'Mundo Novo', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3690, 2922201, 'Muniz Ferreira', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3691, 2922250, 'Muquém de São Francisco', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3692, 2922300, 'Muritiba', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3693, 2922409, 'Mutuípe', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3694, 2922508, 'Nazaré', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3695, 2922607, 'Nilo Peçanha', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3696, 2922656, 'Nordestina', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3697, 2922706, 'Nova Canaã', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3698, 2922730, 'Nova Fátima', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3699, 2922755, 'Nova Ibiá', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3700, 2922805, 'Nova Itarana', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3701, 2922854, 'Nova Redenção', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3702, 2922904, 'Nova Soure', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3703, 2923001, 'Nova Viçosa', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3704, 2923035, 'Novo Horizonte', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3705, 2923050, 'Novo Triunfo', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3706, 2923100, 'Olindina', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3707, 2923209, 'Oliveira dos Brejinhos', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3708, 2923308, 'Ouriçangas', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3709, 2923357, 'Ourolândia', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3710, 2923407, 'Palmas de Monte Alto', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3711, 2923506, 'Palmeiras', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3712, 2923605, 'Paramirim', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3713, 2923704, 'Paratinga', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3714, 2923803, 'Paripiranga', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3715, 2923902, 'Pau Brasil', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3716, 2924009, 'Paulo Afonso', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3717, 2924058, 'Pé de Serra', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3718, 2924108, 'Pedrão', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3719, 2924207, 'Pedro Alexandre', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3720, 2924306, 'Piatã', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3721, 2924405, 'Pilão Arcado', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3722, 2924504, 'Pindaí', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3723, 2924603, 'Pindobaçu', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3724, 2924652, 'Pintadas', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3725, 2924678, 'Piraí do Norte', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3726, 2924702, 'Piripá', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3727, 2924801, 'Piritiba', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3728, 2924900, 'Planaltino', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3729, 2925006, 'Planalto', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3730, 2925105, 'Poções', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3731, 2925204, 'Pojuca', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3732, 2925253, 'Ponto Novo', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3733, 2925303, 'Porto Seguro', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3734, 2925402, 'Potiraguá', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3735, 2925501, 'Prado', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3736, 2925600, 'Presidente Dutra', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3737, 2925709, 'Presidente Jânio Quadros', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3738, 2925758, 'Presidente Tancredo Neves', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3739, 2925808, 'Queimadas', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3740, 2925907, 'Quijingue', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3741, 2925931, 'Quixabeira', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3742, 2925956, 'Rafael Jambeiro', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3743, 2926004, 'Remanso', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3744, 2926103, 'Retirolândia', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3745, 2926202, 'Riachão das Neves', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3746, 2926301, 'Riachão do Jacuípe', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3747, 2926400, 'Riacho de Santana', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3748, 2926509, 'Ribeira do Amparo', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3749, 2926608, 'Ribeira do Pombal', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3750, 2926657, 'Ribeirão do Largo', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3751, 2926707, 'Rio de Contas', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3752, 2926806, 'Rio do Antônio', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3753, 2926905, 'Rio do Pires', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3754, 2927002, 'Rio Real', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3755, 2927101, 'Rodelas', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3756, 2927200, 'Ruy Barbosa', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3757, 2927309, 'Salinas da Margarida', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3758, 2927408, 'Salvador', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3759, 2927507, 'Santa Bárbara', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3760, 2927606, 'Santa Brígida', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3761, 2927705, 'Santa Cruz Cabrália', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3762, 2927804, 'Santa Cruz da Vitória', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3763, 2927903, 'Santa Inês', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3764, 2928059, 'Santa Luzia', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3765, 2928109, 'Santa Maria da Vitória', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3766, 2928406, 'Santa Rita de Cássia', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3767, 2928505, 'Santa Teresinha', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3768, 2928000, 'Santaluz', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3769, 2928208, 'Santana', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3770, 2928307, 'Santanópolis', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3771, 2928604, 'Santo Amaro', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3772, 2928703, 'Santo Antônio de Jesus', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3773, 2928802, 'Santo Estêvão', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3774, 2928901, 'São Desidério', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3775, 2928950, 'São Domingos', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3776, 2929107, 'São Felipe', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3777, 2929008, 'São Félix', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3778, 2929057, 'São Félix do Coribe', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3779, 2929206, 'São Francisco do Conde', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3780, 2929255, 'São Gabriel', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3781, 2929305, 'São Gonçalo dos Campos', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3782, 2929354, 'São José da Vitória', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3783, 2929370, 'São José do Jacuípe', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3784, 2929404, 'São Miguel das Matas', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3785, 2929503, 'São Sebastião do Passé', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3786, 2929602, 'Sapeaçu', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3787, 2929701, 'Sátiro Dias', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3788, 2929750, 'Saubara', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3789, 2929800, 'Saúde', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3790, 2929909, 'Seabra', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3791, 2930006, 'Sebastião Laranjeiras', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3792, 2930105, 'Senhor do Bonfim', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3793, 2930204, 'Sento Sé', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3794, 2930154, 'Serra do Ramalho', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3795, 2930303, 'Serra Dourada', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3796, 2930402, 'Serra Preta', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3797, 2930501, 'Serrinha', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3798, 2930600, 'Serrolândia', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3799, 2930709, 'Simões Filho', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3800, 2930758, 'Sítio do Mato', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3801, 2930766, 'Sítio do Quinto', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3802, 2930774, 'Sobradinho', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3803, 2930808, 'Souto Soares', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3804, 2930907, 'Tabocas do Brejo Velho', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3805, 2931004, 'Tanhaçu', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3806, 2931053, 'Tanque Novo', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3807, 2931103, 'Tanquinho', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3808, 2931202, 'Taperoá', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3809, 2931301, 'Tapiramutá', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3810, 2931350, 'Teixeira de Freitas', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3811, 2931400, 'Teodoro Sampaio', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3812, 2931509, 'Teofilândia', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3813, 2931608, 'Teolândia', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3814, 2931707, 'Terra Nova', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3815, 2931806, 'Tremedal', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3816, 2931905, 'Tucano', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3817, 2932002, 'Uauá', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3818, 2932101, 'Ubaíra', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3819, 2932200, 'Ubaitaba', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3820, 2932309, 'Ubatã', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3821, 2932408, 'Uibaí', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3822, 2932457, 'Umburanas', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3823, 2932507, 'Una', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3824, 2932606, 'Urandi', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3825, 2932705, 'Uruçuca', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3826, 2932804, 'Utinga', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3827, 2932903, 'Valença', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3828, 2933000, 'Valente', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3829, 2933059, 'Várzea da Roça', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3830, 2933109, 'Várzea do Poço', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3831, 2933158, 'Várzea Nova', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3832, 2933174, 'Varzedo', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3833, 2933208, 'Vera Cruz', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3834, 2933257, 'Vereda', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3835, 2933307, 'Vitória da Conquista', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3836, 2933406, 'Wagner', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3837, 2933455, 'Wanderley', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3838, 2933505, 'Wenceslau Guimarães', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3839, 2933604, 'Xique-Xique', NULL, 5)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3840, 3100104, 'Abadia dos Dourados', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3841, 3100203, 'Abaeté', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3842, 3100302, 'Abre Campo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3843, 3100401, 'Acaiaca', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3844, 3100500, 'Açucena', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3845, 3100609, 'Água Boa', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3846, 3100708, 'Água Comprida', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3847, 3100807, 'Aguanil', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3848, 3100906, 'Águas Formosas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3849, 3101003, 'Águas Vermelhas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3850, 3101102, 'Aimorés', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3851, 3101201, 'Aiuruoca', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3852, 3101300, 'Alagoa', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3853, 3101409, 'Albertina', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3854, 3101508, 'Além Paraíba', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3855, 3101607, 'Alfenas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3856, 3101631, 'Alfredo Vasconcelos', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3857, 3101706, 'Almenara', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3858, 3101805, 'Alpercata', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3859, 3101904, 'Alpinópolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3860, 3102001, 'Alterosa', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3861, 3102050, 'Alto Caparaó', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3862, 3153509, 'Alto Jequitibá', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3863, 3102100, 'Alto Rio Doce', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3864, 3102209, 'Alvarenga', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3865, 3102308, 'Alvinópolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3866, 3102407, 'Alvorada de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3867, 3102506, 'Amparo do Serra', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3868, 3102605, 'Andradas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3869, 3102803, 'Andrelândia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3870, 3102852, 'Angelândia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3871, 3102902, 'Antônio Carlos', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3872, 3103009, 'Antônio Dias', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3873, 3103108, 'Antônio Prado de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3874, 3103207, 'Araçaí', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3875, 3103306, 'Aracitaba', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3876, 3103405, 'Araçuaí', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3877, 3103504, 'Araguari', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3878, 3103603, 'Arantina', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3879, 3103702, 'Araponga', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3880, 3103751, 'Araporã', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3881, 3103801, 'Arapuá', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3882, 3103900, 'Araújos', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3883, 3104007, 'Araxá', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3884, 3104106, 'Arceburgo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3885, 3104205, 'Arcos', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3886, 3104304, 'Areado', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3887, 3104403, 'Argirita', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3888, 3104452, 'Aricanduva', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3889, 3104502, 'Arinos', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3890, 3104601, 'Astolfo Dutra', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3891, 3104700, 'Ataléia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3892, 3104809, 'Augusto de Lima', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3893, 3104908, 'Baependi', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3894, 3105004, 'Baldim', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3895, 3105103, 'Bambuí', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3896, 3105202, 'Bandeira', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3897, 3105301, 'Bandeira do Sul', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3898, 3105400, 'Barão de Cocais', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3899, 3105509, 'Barão de Monte Alto', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3900, 3105608, 'Barbacena', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3901, 3105707, 'Barra Longa', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3902, 3105905, 'Barroso', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3903, 3106002, 'Bela Vista de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3904, 3106101, 'Belmiro Braga', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3905, 3106200, 'Belo Horizonte', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3906, 3106309, 'Belo Oriente', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3907, 3106408, 'Belo Vale', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3908, 3106507, 'Berilo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3909, 3106655, 'Berizal', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3910, 3106606, 'Bertópolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3911, 3106705, 'Betim', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3912, 3106804, 'Bias Fortes', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3913, 3106903, 'Bicas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3914, 3107000, 'Biquinhas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3915, 3107109, 'Boa Esperança', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3916, 3107208, 'Bocaina de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3917, 3107307, 'Bocaiúva', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3918, 3107406, 'Bom Despacho', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3919, 3107505, 'Bom Jardim de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3920, 3107604, 'Bom Jesus da Penha', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3921, 3107703, 'Bom Jesus do Amparo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3922, 3107802, 'Bom Jesus do Galho', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3923, 3107901, 'Bom Repouso', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3924, 3108008, 'Bom Sucesso', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3925, 3108107, 'Bonfim', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3926, 3108206, 'Bonfinópolis de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3927, 3108255, 'Bonito de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3928, 3108305, 'Borda da Mata', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3929, 3108404, 'Botelhos', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3930, 3108503, 'Botumirim', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3931, 3108701, 'Brás Pires', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3932, 3108552, 'Brasilândia de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3933, 3108602, 'Brasília de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3934, 3108909, 'Brasópolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3935, 3108800, 'Braúnas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3936, 3109006, 'Brumadinho', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3937, 3109105, 'Bueno Brandão', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3938, 3109204, 'Buenópolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3939, 3109253, 'Bugre', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3940, 3109303, 'Buritis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3941, 3109402, 'Buritizeiro', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3942, 3109451, 'Cabeceira Grande', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3943, 3109501, 'Cabo Verde', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3944, 3109600, 'Cachoeira da Prata', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3945, 3109709, 'Cachoeira de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3946, 3102704, 'Cachoeira de Pajeú', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3947, 3109808, 'Cachoeira Dourada', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3948, 3109907, 'Caetanópolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3949, 3110004, 'Caeté', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3950, 3110103, 'Caiana', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3951, 3110202, 'Cajuri', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3952, 3110301, 'Caldas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3953, 3110400, 'Camacho', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3954, 3110509, 'Camanducaia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3955, 3110608, 'Cambuí', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3956, 3110707, 'Cambuquira', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3957, 3110806, 'Campanário', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3958, 3110905, 'Campanha', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3959, 3111002, 'Campestre', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3960, 3111101, 'Campina Verde', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3961, 3111150, 'Campo Azul', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3962, 3111200, 'Campo Belo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3963, 3111309, 'Campo do Meio', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3964, 3111408, 'Campo Florido', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3965, 3111507, 'Campos Altos', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3966, 3111606, 'Campos Gerais', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3967, 3111903, 'Cana Verde', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3968, 3111705, 'Canaã', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3969, 3111804, 'Canápolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3970, 3112000, 'Candeias', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3971, 3112059, 'Cantagalo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3972, 3112109, 'Caparaó', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3973, 3112208, 'Capela Nova', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3974, 3112307, 'Capelinha', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3975, 3112406, 'Capetinga', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3976, 3112505, 'Capim Branco', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3977, 3112604, 'Capinópolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3978, 3112653, 'Capitão Andrade', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3979, 3112703, 'Capitão Enéas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3980, 3112802, 'Capitólio', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3981, 3112901, 'Caputira', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3982, 3113008, 'Caraí', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3983, 3113107, 'Caranaíba', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3984, 3113206, 'Carandaí', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3985, 3113305, 'Carangola', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3986, 3113404, 'Caratinga', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3987, 3113503, 'Carbonita', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3988, 3113602, 'Careaçu', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3989, 3113701, 'Carlos Chagas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3990, 3113800, 'Carmésia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3991, 3113909, 'Carmo da Cachoeira', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3992, 3114006, 'Carmo da Mata', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3993, 3114105, 'Carmo de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3994, 3114204, 'Carmo do Cajuru', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3995, 3114303, 'Carmo do Paranaíba', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3996, 3114402, 'Carmo do Rio Claro', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3997, 3114501, 'Carmópolis de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3998, 3114550, 'Carneirinho', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (3999, 3114600, 'Carrancas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4000, 3114709, 'Carvalhópolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4001, 3114808, 'Carvalhos', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4002, 3114907, 'Casa Grande', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4003, 3115003, 'Cascalho Rico', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4004, 3115102, 'Cássia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4005, 3115300, 'Cataguases', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4006, 3115359, 'Catas Altas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4007, 3115409, 'Catas Altas da Noruega', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4008, 3115458, 'Catuji', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4009, 3115474, 'Catuti', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4010, 3115508, 'Caxambu', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4011, 3115607, 'Cedro do Abaeté', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4012, 3115706, 'Central de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4013, 3115805, 'Centralina', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4014, 3115904, 'Chácara', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4015, 3116001, 'Chalé', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4016, 3116100, 'Chapada do Norte', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4017, 3116159, 'Chapada Gaúcha', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4018, 3116209, 'Chiador', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4019, 3116308, 'Cipotânea', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4020, 3116407, 'Claraval', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4021, 3116506, 'Claro dos Poções', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4022, 3116605, 'Cláudio', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4023, 3116704, 'Coimbra', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4024, 3116803, 'Coluna', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4025, 3116902, 'Comendador Gomes', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4026, 3117009, 'Comercinho', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4027, 3117108, 'Conceição da Aparecida', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4028, 3115201, 'Conceição da Barra de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4029, 3117306, 'Conceição das Alagoas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4030, 3117207, 'Conceição das Pedras', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4031, 3117405, 'Conceição de Ipanema', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4032, 3117504, 'Conceição do Mato Dentro', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4033, 3117603, 'Conceição do Pará', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4034, 3117702, 'Conceição do Rio Verde', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4035, 3117801, 'Conceição dos Ouros', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4036, 3117836, 'Cônego Marinho', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4037, 3117876, 'Confins', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4038, 3117900, 'Congonhal', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4039, 3118007, 'Congonhas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4040, 3118106, 'Congonhas do Norte', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4041, 3118205, 'Conquista', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4042, 3118304, 'Conselheiro Lafaiete', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4043, 3118403, 'Conselheiro Pena', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4044, 3118502, 'Consolação', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4045, 3118601, 'Contagem', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4046, 3118700, 'Coqueiral', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4047, 3118809, 'Coração de Jesus', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4048, 3118908, 'Cordisburgo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4049, 3119005, 'Cordislândia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4050, 3119104, 'Corinto', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4051, 3119203, 'Coroaci', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4052, 3119302, 'Coromandel', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4053, 3119401, 'Coronel Fabriciano', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4054, 3119500, 'Coronel Murta', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4055, 3119609, 'Coronel Pacheco', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4056, 3119708, 'Coronel Xavier Chaves', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4057, 3119807, 'Córrego Danta', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4058, 3119906, 'Córrego do Bom Jesus', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4059, 3119955, 'Córrego Fundo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4060, 3120003, 'Córrego Novo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4061, 3120102, 'Couto de Magalhães de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4062, 3120151, 'Crisólita', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4063, 3120201, 'Cristais', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4064, 3120300, 'Cristália', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4065, 3120409, 'Cristiano Otoni', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4066, 3120508, 'Cristina', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4067, 3120607, 'Crucilândia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4068, 3120706, 'Cruzeiro da Fortaleza', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4069, 3120805, 'Cruzília', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4070, 3120839, 'Cuparaque', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4071, 3120870, 'Curral de Dentro', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4072, 3120904, 'Curvelo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4073, 3121001, 'Datas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4074, 3121100, 'Delfim Moreira', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4075, 3121209, 'Delfinópolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4076, 3121258, 'Delta', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4077, 3121308, 'Descoberto', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4078, 3121407, 'Desterro de Entre Rios', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4079, 3121506, 'Desterro do Melo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4080, 3121605, 'Diamantina', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4081, 3121704, 'Diogo de Vasconcelos', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4082, 3121803, 'Dionísio', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4083, 3121902, 'Divinésia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4084, 3122009, 'Divino', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4085, 3122108, 'Divino das Laranjeiras', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4086, 3122207, 'Divinolândia de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4087, 3122306, 'Divinópolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4088, 3122355, 'Divisa Alegre', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4089, 3122405, 'Divisa Nova', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4090, 3122454, 'Divisópolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4091, 3122470, 'Dom Bosco', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4092, 3122504, 'Dom Cavati', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4093, 3122603, 'Dom Joaquim', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4094, 3122702, 'Dom Silvério', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4095, 3122801, 'Dom Viçoso', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4096, 3122900, 'Dona Eusébia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4097, 3123007, 'Dores de Campos', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4098, 3123106, 'Dores de Guanhães', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4099, 3123205, 'Dores do Indaiá', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4100, 3123304, 'Dores do Turvo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4101, 3123403, 'Doresópolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4102, 3123502, 'Douradoquara', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4103, 3123528, 'Durandé', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4104, 3123601, 'Elói Mendes', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4105, 3123700, 'Engenheiro Caldas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4106, 3123809, 'Engenheiro Navarro', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4107, 3123858, 'Entre Folhas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4108, 3123908, 'Entre Rios de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4109, 3124005, 'Ervália', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4110, 3124104, 'Esmeraldas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4111, 3124203, 'Espera Feliz', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4112, 3124302, 'Espinosa', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4113, 3124401, 'Espírito Santo do Dourado', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4114, 3124500, 'Estiva', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4115, 3124609, 'Estrela Dalva', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4116, 3124708, 'Estrela do Indaiá', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4117, 3124807, 'Estrela do Sul', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4118, 3124906, 'Eugenópolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4119, 3125002, 'Ewbank da Câmara', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4120, 3125101, 'Extrema', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4121, 3125200, 'Fama', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4122, 3125309, 'Faria Lemos', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4123, 3125408, 'Felício dos Santos', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4124, 3125606, 'Felisburgo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4125, 3125705, 'Felixlândia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4126, 3125804, 'Fernandes Tourinho', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4127, 3125903, 'Ferros', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4128, 3125952, 'Fervedouro', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4129, 3126000, 'Florestal', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4130, 3126109, 'Formiga', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4131, 3126208, 'Formoso', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4132, 3126307, 'Fortaleza de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4133, 3126406, 'Fortuna de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4134, 3126505, 'Francisco Badaró', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4135, 3126604, 'Francisco Dumont', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4136, 3126703, 'Francisco Sá', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4137, 3126752, 'Franciscópolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4138, 3126802, 'Frei Gaspar', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4139, 3126901, 'Frei Inocêncio', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4140, 3126950, 'Frei Lagonegro', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4141, 3127008, 'Fronteira', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4142, 3127057, 'Fronteira dos Vales', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4143, 3127073, 'Fruta de Leite', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4144, 3127107, 'Frutal', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4145, 3127206, 'Funilândia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4146, 3127305, 'Galiléia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4147, 3127339, 'Gameleiras', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4148, 3127354, 'Glaucilândia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4149, 3127370, 'Goiabeira', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4150, 3127388, 'Goianá', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4151, 3127404, 'Gonçalves', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4152, 3127503, 'Gonzaga', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4153, 3127602, 'Gouveia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4154, 3127701, 'Governador Valadares', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4155, 3127800, 'Grão Mogol', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4156, 3127909, 'Grupiara', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4157, 3128006, 'Guanhães', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4158, 3128105, 'Guapé', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4159, 3128204, 'Guaraciaba', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4160, 3128253, 'Guaraciama', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4161, 3128303, 'Guaranésia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4162, 3128402, 'Guarani', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4163, 3128501, 'Guarará', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4164, 3128600, 'Guarda-Mor', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4165, 3128709, 'Guaxupé', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4166, 3128808, 'Guidoval', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4167, 3128907, 'Guimarânia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4168, 3129004, 'Guiricema', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4169, 3129103, 'Gurinhatã', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4170, 3129202, 'Heliodora', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4171, 3129301, 'Iapu', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4172, 3129400, 'Ibertioga', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4173, 3129509, 'Ibiá', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4174, 3129608, 'Ibiaí', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4175, 3129657, 'Ibiracatu', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4176, 3129707, 'Ibiraci', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4177, 3129806, 'Ibirité', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4178, 3129905, 'Ibitiúra de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4179, 3130002, 'Ibituruna', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4180, 3130051, 'Icaraí de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4181, 3130101, 'Igarapé', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4182, 3130200, 'Igaratinga', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4183, 3130309, 'Iguatama', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4184, 3130408, 'Ijaci', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4185, 3130507, 'Ilicínea', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4186, 3130556, 'Imbé de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4187, 3130606, 'Inconfidentes', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4188, 3130655, 'Indaiabira', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4189, 3130705, 'Indianópolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4190, 3130804, 'Ingaí', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4191, 3130903, 'Inhapim', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4192, 3131000, 'Inhaúma', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4193, 3131109, 'Inimutaba', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4194, 3131158, 'Ipaba', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4195, 3131208, 'Ipanema', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4196, 3131307, 'Ipatinga', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4197, 3131406, 'Ipiaçu', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4198, 3131505, 'Ipuiúna', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4199, 3131604, 'Iraí de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4200, 3131703, 'Itabira', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4201, 3131802, 'Itabirinha', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4202, 3131901, 'Itabirito', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4203, 3132008, 'Itacambira', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4204, 3132107, 'Itacarambi', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4205, 3132206, 'Itaguara', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4206, 3132305, 'Itaipé', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4207, 3132404, 'Itajubá', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4208, 3132503, 'Itamarandiba', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4209, 3132602, 'Itamarati de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4210, 3132701, 'Itambacuri', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4211, 3132800, 'Itambé do Mato Dentro', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4212, 3132909, 'Itamogi', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4213, 3133006, 'Itamonte', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4214, 3133105, 'Itanhandu', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4215, 3133204, 'Itanhomi', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4216, 3133303, 'Itaobim', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4217, 3133402, 'Itapagipe', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4218, 3133501, 'Itapecerica', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4219, 3133600, 'Itapeva', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4220, 3133709, 'Itatiaiuçu', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4221, 3133758, 'Itaú de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4222, 3133808, 'Itaúna', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4223, 3133907, 'Itaverava', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4224, 3134004, 'Itinga', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4225, 3134103, 'Itueta', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4226, 3134202, 'Ituiutaba', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4227, 3134301, 'Itumirim', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4228, 3134400, 'Iturama', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4229, 3134509, 'Itutinga', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4230, 3134608, 'Jaboticatubas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4231, 3134707, 'Jacinto', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4232, 3134806, 'Jacuí', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4233, 3134905, 'Jacutinga', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4234, 3135001, 'Jaguaraçu', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4235, 3135050, 'Jaíba', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4236, 3135076, 'Jampruca', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4237, 3135100, 'Janaúba', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4238, 3135209, 'Januária', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4239, 3135308, 'Japaraíba', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4240, 3135357, 'Japonvar', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4241, 3135407, 'Jeceaba', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4242, 3135456, 'Jenipapo de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4243, 3135506, 'Jequeri', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4244, 3135605, 'Jequitaí', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4245, 3135704, 'Jequitibá', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4246, 3135803, 'Jequitinhonha', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4247, 3135902, 'Jesuânia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4248, 3136009, 'Joaíma', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4249, 3136108, 'Joanésia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4250, 3136207, 'João Monlevade', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4251, 3136306, 'João Pinheiro', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4252, 3136405, 'Joaquim Felício', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4253, 3136504, 'Jordânia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4254, 3136520, 'José Gonçalves de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4255, 3136553, 'José Raydan', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4256, 3136579, 'Josenópolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4257, 3136652, 'Juatuba', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4258, 3136702, 'Juiz de Fora', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4259, 3136801, 'Juramento', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4260, 3136900, 'Juruaia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4261, 3136959, 'Juvenília', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4262, 3137007, 'Ladainha', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4263, 3137106, 'Lagamar', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4264, 3137205, 'Lagoa da Prata', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4265, 3137304, 'Lagoa dos Patos', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4266, 3137403, 'Lagoa Dourada', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4267, 3137502, 'Lagoa Formosa', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4268, 3137536, 'Lagoa Grande', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4269, 3137601, 'Lagoa Santa', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4270, 3137700, 'Lajinha', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4271, 3137809, 'Lambari', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4272, 3137908, 'Lamim', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4273, 3138005, 'Laranjal', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4274, 3138104, 'Lassance', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4275, 3138203, 'Lavras', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4276, 3138302, 'Leandro Ferreira', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4277, 3138351, 'Leme do Prado', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4278, 3138401, 'Leopoldina', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4279, 3138500, 'Liberdade', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4280, 3138609, 'Lima Duarte', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4281, 3138625, 'Limeira do Oeste', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4282, 3138658, 'Lontra', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4283, 3138674, 'Luisburgo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4284, 3138682, 'Luislândia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4285, 3138708, 'Luminárias', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4286, 3138807, 'Luz', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4287, 3138906, 'Machacalis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4288, 3139003, 'Machado', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4289, 3139102, 'Madre de Deus de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4290, 3139201, 'Malacacheta', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4291, 3139250, 'Mamonas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4292, 3139300, 'Manga', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4293, 3139409, 'Manhuaçu', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4294, 3139508, 'Manhumirim', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4295, 3139607, 'Mantena', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4296, 3139805, 'Mar de Espanha', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4297, 3139706, 'Maravilhas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4298, 3139904, 'Maria da Fé', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4299, 3140001, 'Mariana', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4300, 3140100, 'Marilac', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4301, 3140159, 'Mário Campos', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4302, 3140209, 'Maripá de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4303, 3140308, 'Marliéria', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4304, 3140407, 'Marmelópolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4305, 3140506, 'Martinho Campos', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4306, 3140530, 'Martins Soares', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4307, 3140555, 'Mata Verde', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4308, 3140605, 'Materlândia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4309, 3140704, 'Mateus Leme', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4310, 3171501, 'Mathias Lobato', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4311, 3140803, 'Matias Barbosa', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4312, 3140852, 'Matias Cardoso', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4313, 3140902, 'Matipó', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4314, 3141009, 'Mato Verde', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4315, 3141108, 'Matozinhos', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4316, 3141207, 'Matutina', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4317, 3141306, 'Medeiros', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4318, 3141405, 'Medina', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4319, 3141504, 'Mendes Pimentel', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4320, 3141603, 'Mercês', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4321, 3141702, 'Mesquita', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4322, 3141801, 'Minas Novas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4323, 3141900, 'Minduri', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4324, 3142007, 'Mirabela', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4325, 3142106, 'Miradouro', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4326, 3142205, 'Miraí', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4327, 3142254, 'Miravânia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4328, 3142304, 'Moeda', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4329, 3142403, 'Moema', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4330, 3142502, 'Monjolos', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4331, 3142601, 'Monsenhor Paulo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4332, 3142700, 'Montalvânia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4333, 3142809, 'Monte Alegre de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4334, 3142908, 'Monte Azul', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4335, 3143005, 'Monte Belo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4336, 3143104, 'Monte Carmelo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4337, 3143153, 'Monte Formoso', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4338, 3143203, 'Monte Santo de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4339, 3143401, 'Monte Sião', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4340, 3143302, 'Montes Claros', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4341, 3143450, 'Montezuma', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4342, 3143500, 'Morada Nova de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4343, 3143609, 'Morro da Garça', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4344, 3143708, 'Morro do Pilar', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4345, 3143807, 'Munhoz', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4346, 3143906, 'Muriaé', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4347, 3144003, 'Mutum', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4348, 3144102, 'Muzambinho', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4349, 3144201, 'Nacip Raydan', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4350, 3144300, 'Nanuque', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4351, 3144359, 'Naque', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4352, 3144375, 'Natalândia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4353, 3144409, 'Natércia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4354, 3144508, 'Nazareno', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4355, 3144607, 'Nepomuceno', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4356, 3144656, 'Ninheira', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4357, 3144672, 'Nova Belém', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4358, 3144706, 'Nova Era', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4359, 3144805, 'Nova Lima', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4360, 3144904, 'Nova Módica', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4361, 3145000, 'Nova Ponte', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4362, 3145059, 'Nova Porteirinha', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4363, 3145109, 'Nova Resende', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4364, 3145208, 'Nova Serrana', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4365, 3136603, 'Nova União', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4366, 3145307, 'Novo Cruzeiro', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4367, 3145356, 'Novo Oriente de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4368, 3145372, 'Novorizonte', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4369, 3145406, 'Olaria', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4370, 3145455, 'Olhos-d''Água', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4371, 3145505, 'Olímpio Noronha', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4372, 3145604, 'Oliveira', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4373, 3145703, 'Oliveira Fortes', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4374, 3145802, 'Onça de Pitangui', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4375, 3145851, 'Oratórios', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4376, 3145877, 'Orizânia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4377, 3145901, 'Ouro Branco', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4378, 3146008, 'Ouro Fino', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4379, 3146107, 'Ouro Preto', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4380, 3146206, 'Ouro Verde de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4381, 3146255, 'Padre Carvalho', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4382, 3146305, 'Padre Paraíso', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4383, 3146552, 'Pai Pedro', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4384, 3146404, 'Paineiras', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4385, 3146503, 'Pains', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4386, 3146602, 'Paiva', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4387, 3146701, 'Palma', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4388, 3146750, 'Palmópolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4389, 3146909, 'Papagaios', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4390, 3147105, 'Pará de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4391, 3147006, 'Paracatu', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4392, 3147204, 'Paraguaçu', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4393, 3147303, 'Paraisópolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4394, 3147402, 'Paraopeba', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4395, 3147600, 'Passa Quatro', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4396, 3147709, 'Passa Tempo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4397, 3147501, 'Passabém', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4398, 3147808, 'Passa-Vinte', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4399, 3147907, 'Passos', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4400, 3147956, 'Patis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4401, 3148004, 'Patos de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4402, 3148103, 'Patrocínio', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4403, 3148202, 'Patrocínio do Muriaé', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4404, 3148301, 'Paula Cândido', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4405, 3148400, 'Paulistas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4406, 3148509, 'Pavão', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4407, 3148608, 'Peçanha', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4408, 3148707, 'Pedra Azul', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4409, 3148756, 'Pedra Bonita', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4410, 3148806, 'Pedra do Anta', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4411, 3148905, 'Pedra do Indaiá', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4412, 3149002, 'Pedra Dourada', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4413, 3149101, 'Pedralva', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4414, 3149150, 'Pedras de Maria da Cruz', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4415, 3149200, 'Pedrinópolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4416, 3149309, 'Pedro Leopoldo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4417, 3149408, 'Pedro Teixeira', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4418, 3149507, 'Pequeri', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4419, 3149606, 'Pequi', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4420, 3149705, 'Perdigão', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4421, 3149804, 'Perdizes', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4422, 3149903, 'Perdões', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4423, 3149952, 'Periquito', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4424, 3150000, 'Pescador', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4425, 3150109, 'Piau', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4426, 3150158, 'Piedade de Caratinga', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4427, 3150208, 'Piedade de Ponte Nova', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4428, 3150307, 'Piedade do Rio Grande', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4429, 3150406, 'Piedade dos Gerais', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4430, 3150505, 'Pimenta', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4431, 3150539, 'Pingo-d''Água', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4432, 3150570, 'Pintópolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4433, 3150604, 'Piracema', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4434, 3150703, 'Pirajuba', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4435, 3150802, 'Piranga', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4436, 3150901, 'Piranguçu', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4437, 3151008, 'Piranguinho', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4438, 3151107, 'Pirapetinga', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4439, 3151206, 'Pirapora', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4440, 3151305, 'Piraúba', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4441, 3151404, 'Pitangui', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4442, 3151503, 'Piumhi', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4443, 3151602, 'Planura', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4444, 3151701, 'Poço Fundo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4445, 3151800, 'Poços de Caldas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4446, 3151909, 'Pocrane', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4447, 3152006, 'Pompéu', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4448, 3152105, 'Ponte Nova', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4449, 3152131, 'Ponto Chique', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4450, 3152170, 'Ponto dos Volantes', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4451, 3152204, 'Porteirinha', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4452, 3152303, 'Porto Firme', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4453, 3152402, 'Poté', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4454, 3152501, 'Pouso Alegre', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4455, 3152600, 'Pouso Alto', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4456, 3152709, 'Prados', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4457, 3152808, 'Prata', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4458, 3152907, 'Pratápolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4459, 3153004, 'Pratinha', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4460, 3153103, 'Presidente Bernardes', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4461, 3153202, 'Presidente Juscelino', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4462, 3153301, 'Presidente Kubitschek', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4463, 3153400, 'Presidente Olegário', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4464, 3153608, 'Prudente de Morais', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4465, 3153707, 'Quartel Geral', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4466, 3153806, 'Queluzito', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4467, 3153905, 'Raposos', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4468, 3154002, 'Raul Soares', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4469, 3154101, 'Recreio', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4470, 3154150, 'Reduto', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4471, 3154200, 'Resende Costa', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4472, 3154309, 'Resplendor', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4473, 3154408, 'Ressaquinha', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4474, 3154457, 'Riachinho', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4475, 3154507, 'Riacho dos Machados', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4476, 3154606, 'Ribeirão das Neves', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4477, 3154705, 'Ribeirão Vermelho', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4478, 3154804, 'Rio Acima', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4479, 3154903, 'Rio Casca', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4480, 3155108, 'Rio do Prado', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4481, 3155009, 'Rio Doce', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4482, 3155207, 'Rio Espera', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4483, 3155306, 'Rio Manso', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4484, 3155405, 'Rio Novo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4485, 3155504, 'Rio Paranaíba', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4486, 3155603, 'Rio Pardo de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4487, 3155702, 'Rio Piracicaba', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4488, 3155801, 'Rio Pomba', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4489, 3155900, 'Rio Preto', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4490, 3156007, 'Rio Vermelho', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4491, 3156106, 'Ritápolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4492, 3156205, 'Rochedo de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4493, 3156304, 'Rodeiro', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4494, 3156403, 'Romaria', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4495, 3156452, 'Rosário da Limeira', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4496, 3156502, 'Rubelita', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4497, 3156601, 'Rubim', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4498, 3156700, 'Sabará', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4499, 3156809, 'Sabinópolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4500, 3156908, 'Sacramento', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4501, 3157005, 'Salinas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4502, 3157104, 'Salto da Divisa', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4503, 3157203, 'Santa Bárbara', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4504, 3157252, 'Santa Bárbara do Leste', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4505, 3157278, 'Santa Bárbara do Monte Verde', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4506, 3157302, 'Santa Bárbara do Tugúrio', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4507, 3157336, 'Santa Cruz de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4508, 3157377, 'Santa Cruz de Salinas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4509, 3157401, 'Santa Cruz do Escalvado', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4510, 3157500, 'Santa Efigênia de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4511, 3157609, 'Santa Fé de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4512, 3157658, 'Santa Helena de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4513, 3157708, 'Santa Juliana', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4514, 3157807, 'Santa Luzia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4515, 3157906, 'Santa Margarida', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4516, 3158003, 'Santa Maria de Itabira', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4517, 3158102, 'Santa Maria do Salto', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4518, 3158201, 'Santa Maria do Suaçuí', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4519, 3159209, 'Santa Rita de Caldas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4520, 3159407, 'Santa Rita de Ibitipoca', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4521, 3159308, 'Santa Rita de Jacutinga', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4522, 3159357, 'Santa Rita de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4523, 3159506, 'Santa Rita do Itueto', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4524, 3159605, 'Santa Rita do Sapucaí', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4525, 3159704, 'Santa Rosa da Serra', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4526, 3159803, 'Santa Vitória', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4527, 3158300, 'Santana da Vargem', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4528, 3158409, 'Santana de Cataguases', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4529, 3158508, 'Santana de Pirapama', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4530, 3158607, 'Santana do Deserto', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4531, 3158706, 'Santana do Garambéu', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4532, 3158805, 'Santana do Jacaré', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4533, 3158904, 'Santana do Manhuaçu', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4534, 3158953, 'Santana do Paraíso', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4535, 3159001, 'Santana do Riacho', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4536, 3159100, 'Santana dos Montes', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4537, 3159902, 'Santo Antônio do Amparo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4538, 3160009, 'Santo Antônio do Aventureiro', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4539, 3160108, 'Santo Antônio do Grama', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4540, 3160207, 'Santo Antônio do Itambé', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4541, 3160306, 'Santo Antônio do Jacinto', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4542, 3160405, 'Santo Antônio do Monte', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4543, 3160454, 'Santo Antônio do Retiro', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4544, 3160504, 'Santo Antônio do Rio Abaixo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4545, 3160603, 'Santo Hipólito', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4546, 3160702, 'Santos Dumont', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4547, 3160801, 'São Bento Abade', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4548, 3160900, 'São Brás do Suaçuí', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4549, 3160959, 'São Domingos das Dores', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4550, 3161007, 'São Domingos do Prata', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4551, 3161056, 'São Félix de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4552, 3161106, 'São Francisco', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4553, 3161205, 'São Francisco de Paula', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4554, 3161304, 'São Francisco de Sales', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4555, 3161403, 'São Francisco do Glória', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4556, 3161502, 'São Geraldo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4557, 3161601, 'São Geraldo da Piedade', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4558, 3161650, 'São Geraldo do Baixio', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4559, 3161700, 'São Gonçalo do Abaeté', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4560, 3161809, 'São Gonçalo do Pará', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4561, 3161908, 'São Gonçalo do Rio Abaixo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4562, 3125507, 'São Gonçalo do Rio Preto', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4563, 3162005, 'São Gonçalo do Sapucaí', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4564, 3162104, 'São Gotardo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4565, 3162203, 'São João Batista do Glória', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4566, 3162252, 'São João da Lagoa', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4567, 3162302, 'São João da Mata', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4568, 3162401, 'São João da Ponte', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4569, 3162450, 'São João das Missões', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4570, 3162500, 'São João del Rei', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4571, 3162559, 'São João do Manhuaçu', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4572, 3162575, 'São João do Manteninha', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4573, 3162609, 'São João do Oriente', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4574, 3162658, 'São João do Pacuí', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4575, 3162708, 'São João do Paraíso', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4576, 3162807, 'São João Evangelista', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4577, 3162906, 'São João Nepomuceno', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4578, 3162922, 'São Joaquim de Bicas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4579, 3162948, 'São José da Barra', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4580, 3162955, 'São José da Lapa', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4581, 3163003, 'São José da Safira', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4582, 3163102, 'São José da Varginha', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4583, 3163201, 'São José do Alegre', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4584, 3163300, 'São José do Divino', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4585, 3163409, 'São José do Goiabal', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4586, 3163508, 'São José do Jacuri', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4587, 3163607, 'São José do Mantimento', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4588, 3163706, 'São Lourenço', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4589, 3163805, 'São Miguel do Anta', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4590, 3163904, 'São Pedro da União', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4591, 3164100, 'São Pedro do Suaçuí', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4592, 3164001, 'São Pedro dos Ferros', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4593, 3164209, 'São Romão', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4594, 3164308, 'São Roque de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4595, 3164407, 'São Sebastião da Bela Vista', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4596, 3164431, 'São Sebastião da Vargem Alegre', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4597, 3164472, 'São Sebastião do Anta', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4598, 3164506, 'São Sebastião do Maranhão', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4599, 3164605, 'São Sebastião do Oeste', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4600, 3164704, 'São Sebastião do Paraíso', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4601, 3164803, 'São Sebastião do Rio Preto', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4602, 3164902, 'São Sebastião do Rio Verde', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4603, 3165206, 'São Thomé das Letras', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4604, 3165008, 'São Tiago', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4605, 3165107, 'São Tomás de Aquino', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4606, 3165305, 'São Vicente de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4607, 3165404, 'Sapucaí-Mirim', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4608, 3165503, 'Sardoá', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4609, 3165537, 'Sarzedo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4610, 3165560, 'Sem-Peixe', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4611, 3165578, 'Senador Amaral', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4612, 3165602, 'Senador Cortes', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4613, 3165701, 'Senador Firmino', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4614, 3165800, 'Senador José Bento', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4615, 3165909, 'Senador Modestino Gonçalves', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4616, 3166006, 'Senhora de Oliveira', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4617, 3166105, 'Senhora do Porto', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4618, 3166204, 'Senhora dos Remédios', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4619, 3166303, 'Sericita', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4620, 3166402, 'Seritinga', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4621, 3166501, 'Serra Azul de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4622, 3166600, 'Serra da Saudade', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4623, 3166808, 'Serra do Salitre', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4624, 3166709, 'Serra dos Aimorés', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4625, 3166907, 'Serrania', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4626, 3166956, 'Serranópolis de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4627, 3167004, 'Serranos', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4628, 3167103, 'Serro', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4629, 3167202, 'Sete Lagoas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4630, 3165552, 'Setubinha', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4631, 3167301, 'Silveirânia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4632, 3167400, 'Silvianópolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4633, 3167509, 'Simão Pereira', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4634, 3167608, 'Simonésia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4635, 3167707, 'Sobrália', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4636, 3167806, 'Soledade de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4637, 3167905, 'Tabuleiro', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4638, 3168002, 'Taiobeiras', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4639, 3168051, 'Taparuba', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4640, 3168101, 'Tapira', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4641, 3168200, 'Tapiraí', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4642, 3168309, 'Taquaraçu de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4643, 3168408, 'Tarumirim', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4644, 3168507, 'Teixeiras', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4645, 3168606, 'Teófilo Otoni', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4646, 3168705, 'Timóteo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4647, 3168804, 'Tiradentes', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4648, 3168903, 'Tiros', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4649, 3169000, 'Tocantins', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4650, 3169059, 'Tocos do Moji', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4651, 3169109, 'Toledo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4652, 3169208, 'Tombos', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4653, 3169307, 'Três Corações', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4654, 3169356, 'Três Marias', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4655, 3169406, 'Três Pontas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4656, 3169505, 'Tumiritinga', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4657, 3169604, 'Tupaciguara', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4658, 3169703, 'Turmalina', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4659, 3169802, 'Turvolândia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4660, 3169901, 'Ubá', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4661, 3170008, 'Ubaí', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4662, 3170057, 'Ubaporanga', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4663, 3170107, 'Uberaba', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4664, 3170206, 'Uberlândia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4665, 3170305, 'Umburatiba', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4666, 3170404, 'Unaí', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4667, 3170438, 'União de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4668, 3170479, 'Uruana de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4669, 3170503, 'Urucânia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4670, 3170529, 'Urucuia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4671, 3170578, 'Vargem Alegre', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4672, 3170602, 'Vargem Bonita', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4673, 3170651, 'Vargem Grande do Rio Pardo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4674, 3170701, 'Varginha', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4675, 3170750, 'Varjão de Minas', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4676, 3170800, 'Várzea da Palma', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4677, 3170909, 'Varzelândia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4678, 3171006, 'Vazante', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4679, 3171030, 'Verdelândia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4680, 3171071, 'Veredinha', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4681, 3171105, 'Veríssimo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4682, 3171154, 'Vermelho Novo', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4683, 3171204, 'Vespasiano', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4684, 3171303, 'Viçosa', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4685, 3171402, 'Vieiras', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4686, 3171600, 'Virgem da Lapa', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4687, 3171709, 'Virgínia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4688, 3171808, 'Virginópolis', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4689, 3171907, 'Virgolândia', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4690, 3172004, 'Visconde do Rio Branco', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4691, 3172103, 'Volta Grande', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4692, 3172202, 'Wenceslau Braz', NULL, 14)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4693, 3200102, 'Afonso Cláudio', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4694, 3200169, 'Água Doce do Norte', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4695, 3200136, 'Águia Branca', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4696, 3200201, 'Alegre', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4697, 3200300, 'Alfredo Chaves', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4698, 3200359, 'Alto Rio Novo', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4699, 3200409, 'Anchieta', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4700, 3200508, 'Apiacá', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4701, 3200607, 'Aracruz', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4702, 3200706, 'Atilio Vivacqua', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4703, 3200805, 'Baixo Guandu', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4704, 3200904, 'Barra de São Francisco', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4705, 3201001, 'Boa Esperança', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4706, 3201100, 'Bom Jesus do Norte', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4707, 3201159, 'Brejetuba', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4708, 3201209, 'Cachoeiro de Itapemirim', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4709, 3201308, 'Cariacica', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4710, 3201407, 'Castelo', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4711, 3201506, 'Colatina', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4712, 3201605, 'Conceição da Barra', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4713, 3201704, 'Conceição do Castelo', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4714, 3201803, 'Divino de São Lourenço', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4715, 3201902, 'Domingos Martins', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4716, 3202009, 'Dores do Rio Preto', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4717, 3202108, 'Ecoporanga', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4718, 3202207, 'Fundão', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4719, 3202256, 'Governador Lindenberg', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4720, 3202306, 'Guaçuí', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4721, 3202405, 'Guarapari', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4722, 3202454, 'Ibatiba', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4723, 3202504, 'Ibiraçu', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4724, 3202553, 'Ibitirama', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4725, 3202603, 'Iconha', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4726, 3202652, 'Irupi', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4727, 3202702, 'Itaguaçu', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4728, 3202801, 'Itapemirim', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4729, 3202900, 'Itarana', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4730, 3203007, 'Iúna', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4731, 3203056, 'Jaguaré', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4732, 3203106, 'Jerônimo Monteiro', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4733, 3203130, 'João Neiva', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4734, 3203163, 'Laranja da Terra', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4735, 3203205, 'Linhares', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4736, 3203304, 'Mantenópolis', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4737, 3203320, 'Marataízes', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4738, 3203346, 'Marechal Floriano', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4739, 3203353, 'Marilândia', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4740, 3203403, 'Mimoso do Sul', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4741, 3203502, 'Montanha', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4742, 3203601, 'Mucurici', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4743, 3203700, 'Muniz Freire', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4744, 3203809, 'Muqui', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4745, 3203908, 'Nova Venécia', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4746, 3204005, 'Pancas', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4747, 3204054, 'Pedro Canário', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4748, 3204104, 'Pinheiros', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4749, 3204203, 'Piúma', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4750, 3204252, 'Ponto Belo', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4751, 3204302, 'Presidente Kennedy', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4752, 3204351, 'Rio Bananal', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4753, 3204401, 'Rio Novo do Sul', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4754, 3204500, 'Santa Leopoldina', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4755, 3204559, 'Santa Maria de Jetibá', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4756, 3204609, 'Santa Teresa', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4757, 3204658, 'São Domingos do Norte', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4758, 3204708, 'São Gabriel da Palha', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4759, 3204807, 'São José do Calçado', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4760, 3204906, 'São Mateus', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4761, 3204955, 'São Roque do Canaã', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4762, 3205002, 'Serra', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4763, 3205010, 'Sooretama', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4764, 3205036, 'Vargem Alta', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4765, 3205069, 'Venda Nova do Imigrante', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4766, 3205101, 'Viana', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4767, 3205150, 'Vila Pavão', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4768, 3205176, 'Vila Valério', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4769, 3205200, 'Vila Velha', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4770, 3205309, 'Vitória', NULL, 8)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4771, 3300100, 'Angra dos Reis', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4772, 3300159, 'Aperibé', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4773, 3300209, 'Araruama', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4774, 3300225, 'Areal', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4775, 3300233, 'Armação dos Búzios', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4776, 3300258, 'Arraial do Cabo', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4777, 3300308, 'Barra do Piraí', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4778, 3300407, 'Barra Mansa', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4779, 3300456, 'Belford Roxo', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4780, 3300506, 'Bom Jardim', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4781, 3300605, 'Bom Jesus do Itabapoana', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4782, 3300704, 'Cabo Frio', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4783, 3300803, 'Cachoeiras de Macacu', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4784, 3300902, 'Cambuci', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4785, 3301009, 'Campos dos Goytacazes', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4786, 3301108, 'Cantagalo', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4787, 3300936, 'Carapebus', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4788, 3301157, 'Cardoso Moreira', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4789, 3301207, 'Carmo', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4790, 3301306, 'Casimiro de Abreu', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4791, 3300951, 'Comendador Levy Gasparian', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4792, 3301405, 'Conceição de Macabu', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4793, 3301504, 'Cordeiro', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4794, 3301603, 'Duas Barras', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4795, 3301702, 'Duque de Caxias', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4796, 3301801, 'Engenheiro Paulo de Frontin', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4797, 3301850, 'Guapimirim', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4798, 3301876, 'Iguaba Grande', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4799, 3301900, 'Itaboraí', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4800, 3302007, 'Itaguaí', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4801, 3302056, 'Italva', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4802, 3302106, 'Itaocara', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4803, 3302205, 'Itaperuna', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4804, 3302254, 'Itatiaia', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4805, 3302270, 'Japeri', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4806, 3302304, 'Laje do Muriaé', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4807, 3302403, 'Macaé', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4808, 3302452, 'Macuco', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4809, 3302502, 'Magé', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4810, 3302601, 'Mangaratiba', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4811, 3302700, 'Maricá', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4812, 3302809, 'Mendes', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4813, 3302858, 'Mesquita', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4814, 3302908, 'Miguel Pereira', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4815, 3303005, 'Miracema', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4816, 3303104, 'Natividade', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4817, 3303203, 'Nilópolis', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4818, 3303302, 'Niterói', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4819, 3303401, 'Nova Friburgo', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4820, 3303500, 'Nova Iguaçu', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4821, 3303609, 'Paracambi', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4822, 3303708, 'Paraíba do Sul', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4823, 3303807, 'Parati', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4824, 3303856, 'Paty do Alferes', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4825, 3303906, 'Petrópolis', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4826, 3303955, 'Pinheiral', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4827, 3304003, 'Piraí', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4828, 3304102, 'Porciúncula', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4829, 3304110, 'Porto Real', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4830, 3304128, 'Quatis', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4831, 3304144, 'Queimados', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4832, 3304151, 'Quissamã', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4833, 3304201, 'Resende', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4834, 3304300, 'Rio Bonito', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4835, 3304409, 'Rio Claro', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4836, 3304508, 'Rio das Flores', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4837, 3304524, 'Rio das Ostras', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4838, 3304557, 'Rio de Janeiro', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4839, 3304607, 'Santa Maria Madalena', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4840, 3304706, 'Santo Antônio de Pádua', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4841, 3304805, 'São Fidélis', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4842, 3304755, 'São Francisco de Itabapoana', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4843, 3304904, 'São Gonçalo', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4844, 3305000, 'São João da Barra', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4845, 3305109, 'São João de Meriti', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4846, 3305133, 'São José de Ubá', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4847, 3305158, 'São José do Vale do Rio Preto', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4848, 3305208, 'São Pedro da Aldeia', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4849, 3305307, 'São Sebastião do Alto', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4850, 3305406, 'Sapucaia', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4851, 3305505, 'Saquarema', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4852, 3305554, 'Seropédica', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4853, 3305604, 'Silva Jardim', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4854, 3305703, 'Sumidouro', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4855, 3305752, 'Tanguá', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4856, 3305802, 'Teresópolis', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4857, 3305901, 'Trajano de Morais', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4858, 3306008, 'Três Rios', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4859, 3306107, 'Valença', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4860, 3306156, 'Varre-Sai', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4861, 3306206, 'Vassouras', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4862, 3306305, 'Volta Redonda', NULL, 20)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4863, 3500105, 'Adamantina', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4864, 3500204, 'Adolfo', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4865, 3500303, 'Aguaí', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4866, 3500402, 'Águas da Prata', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4867, 3500501, 'Águas de Lindóia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4868, 3500550, 'Águas de Santa Bárbara', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4869, 3500600, 'Águas de São Pedro', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4870, 3500709, 'Agudos', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4871, 3500758, 'Alambari', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4872, 3500808, 'Alfredo Marcondes', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4873, 3500907, 'Altair', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4874, 3501004, 'Altinópolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4875, 3501103, 'Alto Alegre', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4876, 3501152, 'Alumínio', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4877, 3501202, 'Álvares Florence', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4878, 3501301, 'Álvares Machado', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4879, 3501400, 'Álvaro de Carvalho', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4880, 3501509, 'Alvinlândia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4881, 3501608, 'Americana', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4882, 3501707, 'Américo Brasiliense', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4883, 3501806, 'Américo de Campos', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4884, 3501905, 'Amparo', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4885, 3502002, 'Analândia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4886, 3502101, 'Andradina', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4887, 3502200, 'Angatuba', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4888, 3502309, 'Anhembi', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4889, 3502408, 'Anhumas', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4890, 3502507, 'Aparecida', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4891, 3502606, 'Aparecida d''Oeste', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4892, 3502705, 'Apiaí', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4893, 3502754, 'Araçariguama', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4894, 3502804, 'Araçatuba', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4895, 3502903, 'Araçoiaba da Serra', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4896, 3503000, 'Aramina', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4897, 3503109, 'Arandu', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4898, 3503158, 'Arapeí', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4899, 3503208, 'Araraquara', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4900, 3503307, 'Araras', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4901, 3503356, 'Arco-Íris', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4902, 3503406, 'Arealva', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4903, 3503505, 'Areias', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4904, 3503604, 'Areiópolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4905, 3503703, 'Ariranha', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4906, 3503802, 'Artur Nogueira', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4907, 3503901, 'Arujá', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4908, 3503950, 'Aspásia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4909, 3504008, 'Assis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4910, 3504107, 'Atibaia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4911, 3504206, 'Auriflama', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4912, 3504305, 'Avaí', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4913, 3504404, 'Avanhandava', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4914, 3504503, 'Avaré', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4915, 3504602, 'Bady Bassitt', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4916, 3504701, 'Balbinos', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4917, 3504800, 'Bálsamo', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4918, 3504909, 'Bananal', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4919, 3505005, 'Barão de Antonina', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4920, 3505104, 'Barbosa', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4921, 3505203, 'Bariri', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4922, 3505302, 'Barra Bonita', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4923, 3505351, 'Barra do Chapéu', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4924, 3505401, 'Barra do Turvo', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4925, 3505500, 'Barretos', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4926, 3505609, 'Barrinha', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4927, 3505708, 'Barueri', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4928, 3505807, 'Bastos', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4929, 3505906, 'Batatais', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4930, 3506003, 'Bauru', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4931, 3506102, 'Bebedouro', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4932, 3506201, 'Bento de Abreu', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4933, 3506300, 'Bernardino de Campos', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4934, 3506359, 'Bertioga', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4935, 3506409, 'Bilac', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4936, 3506508, 'Birigui', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4937, 3506607, 'Biritiba-Mirim', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4938, 3506706, 'Boa Esperança do Sul', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4939, 3506805, 'Bocaina', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4940, 3506904, 'Bofete', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4941, 3507001, 'Boituva', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4942, 3507100, 'Bom Jesus dos Perdões', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4943, 3507159, 'Bom Sucesso de Itararé', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4944, 3507209, 'Borá', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4945, 3507308, 'Boracéia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4946, 3507407, 'Borborema', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4947, 3507456, 'Borebi', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4948, 3507506, 'Botucatu', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4949, 3507605, 'Bragança Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4950, 3507704, 'Braúna', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4951, 3507753, 'Brejo Alegre', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4952, 3507803, 'Brodowski', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4953, 3507902, 'Brotas', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4954, 3508009, 'Buri', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4955, 3508108, 'Buritama', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4956, 3508207, 'Buritizal', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4957, 3508306, 'Cabrália Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4958, 3508405, 'Cabreúva', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4959, 3508504, 'Caçapava', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4960, 3508603, 'Cachoeira Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4961, 3508702, 'Caconde', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4962, 3508801, 'Cafelândia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4963, 3508900, 'Caiabu', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4964, 3509007, 'Caieiras', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4965, 3509106, 'Caiuá', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4966, 3509205, 'Cajamar', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4967, 3509254, 'Cajati', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4968, 3509304, 'Cajobi', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4969, 3509403, 'Cajuru', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4970, 3509452, 'Campina do Monte Alegre', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4971, 3509502, 'Campinas', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4972, 3509601, 'Campo Limpo Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4973, 3509700, 'Campos do Jordão', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4974, 3509809, 'Campos Novos Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4975, 3509908, 'Cananéia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4976, 3509957, 'Canas', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4977, 3510005, 'Cândido Mota', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4978, 3510104, 'Cândido Rodrigues', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4979, 3510153, 'Canitar', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4980, 3510203, 'Capão Bonito', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4981, 3510302, 'Capela do Alto', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4982, 3510401, 'Capivari', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4983, 3510500, 'Caraguatatuba', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4984, 3510609, 'Carapicuíba', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4985, 3510708, 'Cardoso', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4986, 3510807, 'Casa Branca', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4987, 3510906, 'Cássia dos Coqueiros', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4988, 3511003, 'Castilho', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4989, 3511102, 'Catanduva', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4990, 3511201, 'Catiguá', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4991, 3511300, 'Cedral', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4992, 3511409, 'Cerqueira César', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4993, 3511508, 'Cerquilho', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4994, 3511607, 'Cesário Lange', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4995, 3511706, 'Charqueada', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4996, 3557204, 'Chavantes', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4997, 3511904, 'Clementina', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4998, 3512001, 'Colina', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (4999, 3512100, 'Colômbia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5000, 3512209, 'Conchal', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5001, 3512308, 'Conchas', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5002, 3512407, 'Cordeirópolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5003, 3512506, 'Coroados', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5004, 3512605, 'Coronel Macedo', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5005, 3512704, 'Corumbataí', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5006, 3512803, 'Cosmópolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5007, 3512902, 'Cosmorama', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5008, 3513009, 'Cotia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5009, 3513108, 'Cravinhos', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5010, 3513207, 'Cristais Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5011, 3513306, 'Cruzália', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5012, 3513405, 'Cruzeiro', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5013, 3513504, 'Cubatão', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5014, 3513603, 'Cunha', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5015, 3513702, 'Descalvado', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5016, 3513801, 'Diadema', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5017, 3513850, 'Dirce Reis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5018, 3513900, 'Divinolândia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5019, 3514007, 'Dobrada', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5020, 3514106, 'Dois Córregos', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5021, 3514205, 'Dolcinópolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5022, 3514304, 'Dourado', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5023, 3514403, 'Dracena', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5024, 3514502, 'Duartina', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5025, 3514601, 'Dumont', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5026, 3514700, 'Echaporã', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5027, 3514809, 'Eldorado', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5028, 3514908, 'Elias Fausto', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5029, 3514924, 'Elisiário', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5030, 3514957, 'Embaúba', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5031, 3515004, 'Embu', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5032, 3515103, 'Embu-Guaçu', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5033, 3515129, 'Emilianópolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5034, 3515152, 'Engenheiro Coelho', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5035, 3515186, 'Espírito Santo do Pinhal', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5036, 3515194, 'Espírito Santo do Turvo', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5037, 3557303, 'Estiva Gerbi', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5038, 3515301, 'Estrela do Norte', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5039, 3515202, 'Estrela d''Oeste', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5040, 3515350, 'Euclides da Cunha Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5041, 3515400, 'Fartura', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5042, 3515608, 'Fernando Prestes', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5043, 3515509, 'Fernandópolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5044, 3515657, 'Fernão', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5045, 3515707, 'Ferraz de Vasconcelos', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5046, 3515806, 'Flora Rica', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5047, 3515905, 'Floreal', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5048, 3516002, 'Flórida Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5049, 3516101, 'Florínia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5050, 3516200, 'Franca', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5051, 3516309, 'Francisco Morato', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5052, 3516408, 'Franco da Rocha', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5053, 3516507, 'Gabriel Monteiro', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5054, 3516606, 'Gália', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5055, 3516705, 'Garça', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5056, 3516804, 'Gastão Vidigal', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5057, 3516853, 'Gavião Peixoto', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5058, 3516903, 'General Salgado', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5059, 3517000, 'Getulina', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5060, 3517109, 'Glicério', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5061, 3517208, 'Guaiçara', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5062, 3517307, 'Guaimbê', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5063, 3517406, 'Guaíra', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5064, 3517505, 'Guapiaçu', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5065, 3517604, 'Guapiara', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5066, 3517703, 'Guará', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5067, 3517802, 'Guaraçaí', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5068, 3517901, 'Guaraci', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5069, 3518008, 'Guarani d''Oeste', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5070, 3518107, 'Guarantã', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5071, 3518206, 'Guararapes', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5072, 3518305, 'Guararema', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5073, 3518404, 'Guaratinguetá', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5074, 3518503, 'Guareí', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5075, 3518602, 'Guariba', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5076, 3518701, 'Guarujá', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5077, 3518800, 'Guarulhos', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5078, 3518859, 'Guatapará', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5079, 3518909, 'Guzolândia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5080, 3519006, 'Herculândia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5081, 3519055, 'Holambra', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5082, 3519071, 'Hortolândia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5083, 3519105, 'Iacanga', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5084, 3519204, 'Iacri', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5085, 3519253, 'Iaras', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5086, 3519303, 'Ibaté', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5087, 3519402, 'Ibirá', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5088, 3519501, 'Ibirarema', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5089, 3519600, 'Ibitinga', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5090, 3519709, 'Ibiúna', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5091, 3519808, 'Icém', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5092, 3519907, 'Iepê', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5093, 3520004, 'Igaraçu do Tietê', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5094, 3520103, 'Igarapava', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5095, 3520202, 'Igaratá', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5096, 3520301, 'Iguape', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5097, 3520426, 'Ilha Comprida', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5098, 3520442, 'Ilha Solteira', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5099, 3520400, 'Ilhabela', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5100, 3520509, 'Indaiatuba', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5101, 3520608, 'Indiana', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5102, 3520707, 'Indiaporã', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5103, 3520806, 'Inúbia Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5104, 3520905, 'Ipaussu', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5105, 3521002, 'Iperó', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5106, 3521101, 'Ipeúna', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5107, 3521150, 'Ipiguá', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5108, 3521200, 'Iporanga', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5109, 3521309, 'Ipuã', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5110, 3521408, 'Iracemápolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5111, 3521507, 'Irapuã', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5112, 3521606, 'Irapuru', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5113, 3521705, 'Itaberá', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5114, 3521804, 'Itaí', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5115, 3521903, 'Itajobi', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5116, 3522000, 'Itaju', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5117, 3522109, 'Itanhaém', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5118, 3522158, 'Itaóca', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5119, 3522208, 'Itapecerica da Serra', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5120, 3522307, 'Itapetininga', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5121, 3522406, 'Itapeva', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5122, 3522505, 'Itapevi', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5123, 3522604, 'Itapira', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5124, 3522653, 'Itapirapuã Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5125, 3522703, 'Itápolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5126, 3522802, 'Itaporanga', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5127, 3522901, 'Itapuí', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5128, 3523008, 'Itapura', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5129, 3523107, 'Itaquaquecetuba', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5130, 3523206, 'Itararé', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5131, 3523305, 'Itariri', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5132, 3523404, 'Itatiba', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5133, 3523503, 'Itatinga', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5134, 3523602, 'Itirapina', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5135, 3523701, 'Itirapuã', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5136, 3523800, 'Itobi', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5137, 3523909, 'Itu', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5138, 3524006, 'Itupeva', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5139, 3524105, 'Ituverava', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5140, 3524204, 'Jaborandi', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5141, 3524303, 'Jaboticabal', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5142, 3524402, 'Jacareí', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5143, 3524501, 'Jaci', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5144, 3524600, 'Jacupiranga', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5145, 3524709, 'Jaguariúna', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5146, 3524808, 'Jales', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5147, 3524907, 'Jambeiro', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5148, 3525003, 'Jandira', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5149, 3525102, 'Jardinópolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5150, 3525201, 'Jarinu', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5151, 3525300, 'Jaú', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5152, 3525409, 'Jeriquara', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5153, 3525508, 'Joanópolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5154, 3525607, 'João Ramalho', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5155, 3525706, 'José Bonifácio', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5156, 3525805, 'Júlio Mesquita', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5157, 3525854, 'Jumirim', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5158, 3525904, 'Jundiaí', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5159, 3526001, 'Junqueirópolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5160, 3526100, 'Juquiá', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5161, 3526209, 'Juquitiba', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5162, 3526308, 'Lagoinha', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5163, 3526407, 'Laranjal Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5164, 3526506, 'Lavínia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5165, 3526605, 'Lavrinhas', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5166, 3526704, 'Leme', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5167, 3526803, 'Lençóis Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5168, 3526902, 'Limeira', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5169, 3527009, 'Lindóia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5170, 3527108, 'Lins', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5171, 3527207, 'Lorena', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5172, 3527256, 'Lourdes', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5173, 3527306, 'Louveira', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5174, 3527405, 'Lucélia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5175, 3527504, 'Lucianópolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5176, 3527603, 'Luís Antônio', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5177, 3527702, 'Luiziânia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5178, 3527801, 'Lupércio', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5179, 3527900, 'Lutécia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5180, 3528007, 'Macatuba', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5181, 3528106, 'Macaubal', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5182, 3528205, 'Macedônia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5183, 3528304, 'Magda', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5184, 3528403, 'Mairinque', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5185, 3528502, 'Mairiporã', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5186, 3528601, 'Manduri', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5187, 3528700, 'Marabá Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5188, 3528809, 'Maracaí', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5189, 3528858, 'Marapoama', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5190, 3528908, 'Mariápolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5191, 3529005, 'Marília', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5192, 3529104, 'Marinópolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5193, 3529203, 'Martinópolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5194, 3529302, 'Matão', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5195, 3529401, 'Mauá', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5196, 3529500, 'Mendonça', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5197, 3529609, 'Meridiano', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5198, 3529658, 'Mesópolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5199, 3529708, 'Miguelópolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5200, 3529807, 'Mineiros do Tietê', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5201, 3530003, 'Mira Estrela', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5202, 3529906, 'Miracatu', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5203, 3530102, 'Mirandópolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5204, 3530201, 'Mirante do Paranapanema', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5205, 3530300, 'Mirassol', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5206, 3530409, 'Mirassolândia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5207, 3530508, 'Mococa', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5208, 3530607, 'Mogi das Cruzes', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5209, 3530706, 'Mogi Guaçu', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5210, 3530805, 'Moji Mirim', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5211, 3530904, 'Mombuca', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5212, 3531001, 'Monções', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5213, 3531100, 'Mongaguá', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5214, 3531209, 'Monte Alegre do Sul', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5215, 3531308, 'Monte Alto', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5216, 3531407, 'Monte Aprazível', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5217, 3531506, 'Monte Azul Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5218, 3531605, 'Monte Castelo', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5219, 3531803, 'Monte Mor', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5220, 3531704, 'Monteiro Lobato', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5221, 3531902, 'Morro Agudo', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5222, 3532009, 'Morungaba', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5223, 3532058, 'Motuca', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5224, 3532108, 'Murutinga do Sul', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5225, 3532157, 'Nantes', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5226, 3532207, 'Narandiba', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5227, 3532306, 'Natividade da Serra', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5228, 3532405, 'Nazaré Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5229, 3532504, 'Neves Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5230, 3532603, 'Nhandeara', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5231, 3532702, 'Nipoã', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5232, 3532801, 'Nova Aliança', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5233, 3532827, 'Nova Campina', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5234, 3532843, 'Nova Canaã Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5235, 3532868, 'Nova Castilho', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5236, 3532900, 'Nova Europa', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5237, 3533007, 'Nova Granada', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5238, 3533106, 'Nova Guataporanga', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5239, 3533205, 'Nova Independência', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5240, 3533304, 'Nova Luzitânia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5241, 3533403, 'Nova Odessa', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5242, 3533254, 'Novais', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5243, 3533502, 'Novo Horizonte', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5244, 3533601, 'Nuporanga', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5245, 3533700, 'Ocauçu', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5246, 3533809, 'Óleo', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5247, 3533908, 'Olímpia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5248, 3534005, 'Onda Verde', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5249, 3534104, 'Oriente', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5250, 3534203, 'Orindiúva', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5251, 3534302, 'Orlândia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5252, 3534401, 'Osasco', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5253, 3534500, 'Oscar Bressane', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5254, 3534609, 'Osvaldo Cruz', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5255, 3534708, 'Ourinhos', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5256, 3534807, 'Ouro Verde', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5257, 3534757, 'Ouroeste', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5258, 3534906, 'Pacaembu', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5259, 3535002, 'Palestina', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5260, 3535101, 'Palmares Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5261, 3535200, 'Palmeira d''Oeste', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5262, 3535309, 'Palmital', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5263, 3535408, 'Panorama', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5264, 3535507, 'Paraguaçu Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5265, 3535606, 'Paraibuna', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5266, 3535705, 'Paraíso', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5267, 3535804, 'Paranapanema', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5268, 3535903, 'Paranapuã', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5269, 3536000, 'Parapuã', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5270, 3536109, 'Pardinho', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5271, 3536208, 'Pariquera-Açu', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5272, 3536257, 'Parisi', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5273, 3536307, 'Patrocínio Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5274, 3536406, 'Paulicéia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5275, 3536505, 'Paulínia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5276, 3536570, 'Paulistânia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5277, 3536604, 'Paulo de Faria', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5278, 3536703, 'Pederneiras', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5279, 3536802, 'Pedra Bela', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5280, 3536901, 'Pedranópolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5281, 3537008, 'Pedregulho', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5282, 3537107, 'Pedreira', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5283, 3537156, 'Pedrinhas Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5284, 3537206, 'Pedro de Toledo', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5285, 3537305, 'Penápolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5286, 3537404, 'Pereira Barreto', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5287, 3537503, 'Pereiras', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5288, 3537602, 'Peruíbe', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5289, 3537701, 'Piacatu', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5290, 3537800, 'Piedade', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5291, 3537909, 'Pilar do Sul', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5292, 3538006, 'Pindamonhangaba', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5293, 3538105, 'Pindorama', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5294, 3538204, 'Pinhalzinho', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5295, 3538303, 'Piquerobi', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5296, 3538501, 'Piquete', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5297, 3538600, 'Piracaia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5298, 3538709, 'Piracicaba', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5299, 3538808, 'Piraju', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5300, 3538907, 'Pirajuí', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5301, 3539004, 'Pirangi', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5302, 3539103, 'Pirapora do Bom Jesus', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5303, 3539202, 'Pirapozinho', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5304, 3539301, 'Pirassununga', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5305, 3539400, 'Piratininga', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5306, 3539509, 'Pitangueiras', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5307, 3539608, 'Planalto', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5308, 3539707, 'Platina', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5309, 3539806, 'Poá', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5310, 3539905, 'Poloni', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5311, 3540002, 'Pompéia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5312, 3540101, 'Pongaí', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5313, 3540200, 'Pontal', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5314, 3540259, 'Pontalinda', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5315, 3540309, 'Pontes Gestal', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5316, 3540408, 'Populina', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5317, 3540507, 'Porangaba', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5318, 3540606, 'Porto Feliz', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5319, 3540705, 'Porto Ferreira', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5320, 3540754, 'Potim', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5321, 3540804, 'Potirendaba', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5322, 3540853, 'Pracinha', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5323, 3540903, 'Pradópolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5324, 3541000, 'Praia Grande', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5325, 3541059, 'Pratânia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5326, 3541109, 'Presidente Alves', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5327, 3541208, 'Presidente Bernardes', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5328, 3541307, 'Presidente Epitácio', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5329, 3541406, 'Presidente Prudente', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5330, 3541505, 'Presidente Venceslau', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5331, 3541604, 'Promissão', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5332, 3541653, 'Quadra', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5333, 3541703, 'Quatá', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5334, 3541802, 'Queiroz', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5335, 3541901, 'Queluz', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5336, 3542008, 'Quintana', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5337, 3542107, 'Rafard', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5338, 3542206, 'Rancharia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5339, 3542305, 'Redenção da Serra', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5340, 3542404, 'Regente Feijó', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5341, 3542503, 'Reginópolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5342, 3542602, 'Registro', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5343, 3542701, 'Restinga', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5344, 3542800, 'Ribeira', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5345, 3542909, 'Ribeirão Bonito', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5346, 3543006, 'Ribeirão Branco', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5347, 3543105, 'Ribeirão Corrente', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5348, 3543204, 'Ribeirão do Sul', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5349, 3543238, 'Ribeirão dos Índios', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5350, 3543253, 'Ribeirão Grande', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5351, 3543303, 'Ribeirão Pires', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5352, 3543402, 'Ribeirão Preto', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5353, 3543600, 'Rifaina', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5354, 3543709, 'Rincão', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5355, 3543808, 'Rinópolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5356, 3543907, 'Rio Claro', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5357, 3544004, 'Rio das Pedras', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5358, 3544103, 'Rio Grande da Serra', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5359, 3544202, 'Riolândia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5360, 3543501, 'Riversul', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5361, 3544251, 'Rosana', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5362, 3544301, 'Roseira', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5363, 3544400, 'Rubiácea', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5364, 3544509, 'Rubinéia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5365, 3544608, 'Sabino', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5366, 3544707, 'Sagres', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5367, 3544806, 'Sales', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5368, 3544905, 'Sales Oliveira', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5369, 3545001, 'Salesópolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5370, 3545100, 'Salmourão', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5371, 3545159, 'Saltinho', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5372, 3545209, 'Salto', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5373, 3545308, 'Salto de Pirapora', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5374, 3545407, 'Salto Grande', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5375, 3545506, 'Sandovalina', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5376, 3545605, 'Santa Adélia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5377, 3545704, 'Santa Albertina', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5378, 3545803, 'Santa Bárbara d''Oeste', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5379, 3546009, 'Santa Branca', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5380, 3546108, 'Santa Clara d''Oeste', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5381, 3546207, 'Santa Cruz da Conceição', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5382, 3546256, 'Santa Cruz da Esperança', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5383, 3546306, 'Santa Cruz das Palmeiras', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5384, 3546405, 'Santa Cruz do Rio Pardo', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5385, 3546504, 'Santa Ernestina', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5386, 3546603, 'Santa Fé do Sul', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5387, 3546702, 'Santa Gertrudes', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5388, 3546801, 'Santa Isabel', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5389, 3546900, 'Santa Lúcia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5390, 3547007, 'Santa Maria da Serra', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5391, 3547106, 'Santa Mercedes', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5392, 3547502, 'Santa Rita do Passa Quatro', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5393, 3547403, 'Santa Rita d''Oeste', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5394, 3547601, 'Santa Rosa de Viterbo', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5395, 3547650, 'Santa Salete', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5396, 3547205, 'Santana da Ponte Pensa', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5397, 3547304, 'Santana de Parnaíba', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5398, 3547700, 'Santo Anastácio', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5399, 3547809, 'Santo André', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5400, 3547908, 'Santo Antônio da Alegria', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5401, 3548005, 'Santo Antônio de Posse', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5402, 3548054, 'Santo Antônio do Aracanguá', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5403, 3548104, 'Santo Antônio do Jardim', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5404, 3548203, 'Santo Antônio do Pinhal', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5405, 3548302, 'Santo Expedito', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5406, 3548401, 'Santópolis do Aguapeí', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5407, 3548500, 'Santos', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5408, 3548609, 'São Bento do Sapucaí', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5409, 3548708, 'São Bernardo do Campo', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5410, 3548807, 'São Caetano do Sul', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5411, 3548906, 'São Carlos', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5412, 3549003, 'São Francisco', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5413, 3549102, 'São João da Boa Vista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5414, 3549201, 'São João das Duas Pontes', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5415, 3549250, 'São João de Iracema', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5416, 3549300, 'São João do Pau d''Alho', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5417, 3549409, 'São Joaquim da Barra', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5418, 3549508, 'São José da Bela Vista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5419, 3549607, 'São José do Barreiro', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5420, 3549706, 'São José do Rio Pardo', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5421, 3549805, 'São José do Rio Preto', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5422, 3549904, 'São José dos Campos', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5423, 3549953, 'São Lourenço da Serra', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5424, 3550001, 'São Luís do Paraitinga', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5425, 3550100, 'São Manuel', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5426, 3550209, 'São Miguel Arcanjo', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5427, 3550308, 'São Paulo', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5428, 3550407, 'São Pedro', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5429, 3550506, 'São Pedro do Turvo', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5430, 3550605, 'São Roque', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5431, 3550704, 'São Sebastião', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5432, 3550803, 'São Sebastião da Grama', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5433, 3550902, 'São Simão', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5434, 3551009, 'São Vicente', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5435, 3551108, 'Sarapuí', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5436, 3551207, 'Sarutaiá', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5437, 3551306, 'Sebastianópolis do Sul', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5438, 3551405, 'Serra Azul', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5439, 3551603, 'Serra Negra', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5440, 3551504, 'Serrana', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5441, 3551702, 'Sertãozinho', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5442, 3551801, 'Sete Barras', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5443, 3551900, 'Severínia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5444, 3552007, 'Silveiras', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5445, 3552106, 'Socorro', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5446, 3552205, 'Sorocaba', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5447, 3552304, 'Sud Mennucci', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5448, 3552403, 'Sumaré', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5449, 3552551, 'Suzanápolis', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5450, 3552502, 'Suzano', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5451, 3552601, 'Tabapuã', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5452, 3552700, 'Tabatinga', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5453, 3552809, 'Taboão da Serra', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5454, 3552908, 'Taciba', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5455, 3553005, 'Taguaí', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5456, 3553104, 'Taiaçu', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5457, 3553203, 'Taiúva', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5458, 3553302, 'Tambaú', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5459, 3553401, 'Tanabi', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5460, 3553500, 'Tapiraí', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5461, 3553609, 'Tapiratiba', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5462, 3553658, 'Taquaral', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5463, 3553708, 'Taquaritinga', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5464, 3553807, 'Taquarituba', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5465, 3553856, 'Taquarivaí', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5466, 3553906, 'Tarabai', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5467, 3553955, 'Tarumã', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5468, 3554003, 'Tatuí', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5469, 3554102, 'Taubaté', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5470, 3554201, 'Tejupá', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5471, 3554300, 'Teodoro Sampaio', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5472, 3554409, 'Terra Roxa', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5473, 3554508, 'Tietê', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5474, 3554607, 'Timburi', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5475, 3554656, 'Torre de Pedra', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5476, 3554706, 'Torrinha', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5477, 3554755, 'Trabiju', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5478, 3554805, 'Tremembé', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5479, 3554904, 'Três Fronteiras', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5480, 3554953, 'Tuiuti', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5481, 3555000, 'Tupã', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5482, 3555109, 'Tupi Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5483, 3555208, 'Turiúba', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5484, 3555307, 'Turmalina', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5485, 3555356, 'Ubarana', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5486, 3555406, 'Ubatuba', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5487, 3555505, 'Ubirajara', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5488, 3555604, 'Uchoa', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5489, 3555703, 'União Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5490, 3555802, 'Urânia', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5491, 3555901, 'Uru', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5492, 3556008, 'Urupês', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5493, 3556107, 'Valentim Gentil', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5494, 3556206, 'Valinhos', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5495, 3556305, 'Valparaíso', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5496, 3556354, 'Vargem', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5497, 3556404, 'Vargem Grande do Sul', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5498, 3556453, 'Vargem Grande Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5499, 3556503, 'Várzea Paulista', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5500, 3556602, 'Vera Cruz', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5501, 3556701, 'Vinhedo', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5502, 3556800, 'Viradouro', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5503, 3556909, 'Vista Alegre do Alto', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5504, 3556958, 'Vitória Brasil', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5505, 3557006, 'Votorantim', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5506, 3557105, 'Votuporanga', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5507, 3557154, 'Zacarias', NULL, 11)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5508, 4100103, 'Abatiá', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5509, 4100202, 'Adrianópolis', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5510, 4100301, 'Agudos do Sul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5511, 4100400, 'Almirante Tamandaré', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5512, 4100459, 'Altamira do Paraná', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5513, 4128625, 'Alto Paraíso', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5514, 4100608, 'Alto Paraná', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5515, 4100707, 'Alto Piquiri', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5516, 4100509, 'Altônia', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5517, 4100806, 'Alvorada do Sul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5518, 4100905, 'Amaporã', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5519, 4101002, 'Ampére', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5520, 4101051, 'Anahy', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5521, 4101101, 'Andirá', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5522, 4101150, 'Ângulo', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5523, 4101200, 'Antonina', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5524, 4101309, 'Antônio Olinto', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5525, 4101408, 'Apucarana', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5526, 4101507, 'Arapongas', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5527, 4101606, 'Arapoti', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5528, 4101655, 'Arapuã', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5529, 4101705, 'Araruna', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5530, 4101804, 'Araucária', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5531, 4101853, 'Ariranha do Ivaí', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5532, 4101903, 'Assaí', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5533, 4102000, 'Assis Chateaubriand', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5534, 4102109, 'Astorga', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5535, 4102208, 'Atalaia', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5536, 4102307, 'Balsa Nova', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5537, 4102406, 'Bandeirantes', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5538, 4102505, 'Barbosa Ferraz', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5539, 4102703, 'Barra do Jacaré', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5540, 4102604, 'Barracão', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5541, 4102752, 'Bela Vista da Caroba', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5542, 4102802, 'Bela Vista do Paraíso', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5543, 4102901, 'Bituruna', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5544, 4103008, 'Boa Esperança', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5545, 4103024, 'Boa Esperança do Iguaçu', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5546, 4103040, 'Boa Ventura de São Roque', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5547, 4103057, 'Boa Vista da Aparecida', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5548, 4103107, 'Bocaiúva do Sul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5549, 4103156, 'Bom Jesus do Sul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5550, 4103206, 'Bom Sucesso', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5551, 4103222, 'Bom Sucesso do Sul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5552, 4103305, 'Borrazópolis', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5553, 4103354, 'Braganey', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5554, 4103370, 'Brasilândia do Sul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5555, 4103404, 'Cafeara', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5556, 4103453, 'Cafelândia', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5557, 4103479, 'Cafezal do Sul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5558, 4103503, 'Califórnia', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5559, 4103602, 'Cambará', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5560, 4103701, 'Cambé', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5561, 4103800, 'Cambira', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5562, 4103909, 'Campina da Lagoa', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5563, 4103958, 'Campina do Simão', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5564, 4104006, 'Campina Grande do Sul', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5565, 4104055, 'Campo Bonito', NULL, 17)GO
INSERT INTO [$(DatabaseName)].[Location].[City] ([Id], [Code], [Name], [Flag], [Location.State.Id]) VALUES (5566, 9999999, 'Exterior', NULL, 28)GO
SET IDENTITY_INSERT [$(DatabaseName)].[Location].[City] OFF

