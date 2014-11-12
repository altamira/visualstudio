
--pr_criacao_tabelas_sap
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                      2001                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Criaçao automática de tabelas 
--Data       : 09.01.2001
--Atualizado : 
-----------------------------------------------------------------------------------
create procedure pr_criacao_tabelas_sap
@cd_tabela_inicial int,
@cd_tabela_final   int,
@nm_banco_dados    char(20)
as
--verifica quais tabelas deverao ser criadas
select * from tabela
where
   cd_tabela between @cd_tabela_inicial and @cd_tabela_final
--Verifica os atributos das tabelas para geraçao da tabela
select * from atributo
where
   cd_tabela between @cd_tabela_inicial and @cd_tabela_final
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Pais]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Pais]
CREATE TABLE [dbo].[Pais] (
        [cd_pais] [int] NOT NULL ,
 [nm_fantasia_pais] [char] (15) NULL ,
 [nm_pais] [varchar] (40) NOT NULL ,
 [sg_pais] [char] (5) NULL ,
 [cd_ddi_pais] [char] (2) NULL ,
 [cd_siscomex_pais] [char] (3) NULL ,
 [sg_extensao_internet_pais] [char] (2) NULL ,
 [cd_usuario] [int] NOT NULL ,
 [dt_usuario] [datetime] NOT NULL 
) ON [PRIMARY]

