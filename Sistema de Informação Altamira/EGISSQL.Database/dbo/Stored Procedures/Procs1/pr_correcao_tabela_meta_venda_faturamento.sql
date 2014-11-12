
-------------------------------------------------------------------------------
--pr_correcao_tabela_meta_venda_faturamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Acerto da Tabela de Meta Venda / Meta de Faturamento
--                   para ajuste das novas chaves
--Data             : 30.05.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_correcao_tabela_meta_venda_faturamento
as

select
  *
into
  Aux_Meta_Venda
from
  Meta_Venda

drop table Meta_Venda

--Criação da Nova Tabela

Create Table Meta_Venda(
[cd_empresa] INT  NOT NULL ,
[cd_meta_venda] INT  NOT NULL ,
[dt_inicial_meta_venda] DATETIME  NOT NULL ,
[dt_final_meta_venda] DATETIME  NOT NULL ,
[vl_venda_imediato_meta] FLOAT  NULL ,
[vl_venda_mes_meta] FLOAT  NULL ,
[vl_proposta_imediato_meta] FLOAT  NULL ,
[vl_proposta_mes_meta] FLOAT  NULL ,
[nm_obs_meta_venda] VARCHAR (40) NULL ,
[cd_usuario] INT  NULL ,
[dt_usuario] DATETIME  NULL ,
[ic_padrao_meta_venda] CHAR (1) NULL ,
[ic_filtro_loja_meta] CHAR (1) NULL ,
[cd_tipo_mercado] INT  NULL ,
CONSTRAINT PK_Meta_Venda PRIMARY KEY(cd_empresa,cd_meta_venda)) ON [PRIMARY] 

ALTER TABLE EGISSQL.dbo.Meta_Venda ADD CONSTRAINT FK_Meta_Venda_Tipo_Mercado FOREIGN KEY (cd_tipo_mercado) REFERENCES Tipo_Mercado (cd_tipo_mercado )


declare @cd_meta_venda       int
declare @cd_meta_faturamento int
declare @cd_empresa          int
declare @dt_inicial          datetime
declare @dt_final            datetime

set @cd_meta_venda = 0

while exists ( select top 1 cd_empresa from Aux_Meta_Venda )
begin

   set 
     @cd_meta_venda = @cd_meta_venda + 1

  select top 1
    @cd_empresa = cd_empresa,
    @dt_inicial = dt_inicial_meta_venda,
    @dt_final   = dt_final_meta_venda
  from
    Aux_Meta_Venda 

  insert
    Meta_Venda
  select top 1
    cd_empresa,
    @cd_meta_venda,
    dt_inicial_meta_venda,
    dt_final_meta_venda,
    vl_venda_imediato_meta,
    vl_venda_mes_meta,
    vl_proposta_imediato_meta,
    vl_proposta_mes_meta,
    nm_obs_meta_venda,
    cd_usuario,
    dt_usuario,
    ic_padrao_meta_venda,
    ic_filtro_loja_meta,
    cd_tipo_mercado 
  from
    Aux_Meta_Venda

  delete from Aux_Meta_Venda 
  where 
    @cd_empresa = cd_empresa            and
    @dt_inicial = dt_inicial_meta_venda and
    @dt_final   = dt_final_meta_venda

           
end

drop table Aux_Meta_Venda 

--Meta de Faturamento

select
  *
into
  Aux_Meta_Faturamento
from
  Meta_Faturamento

drop table Meta_Faturamento


--Criação da Nova Tabela

Create Table Meta_Faturamento(
[cd_empresa] INT  NOT NULL ,
[cd_meta_faturamento] INT  NOT NULL ,
[dt_ini_meta_faturamento] DATETIME  NOT NULL ,
[dt_fim_meta_faturamento] DATETIME  NOT NULL ,
[vl_meta_faturamento] FLOAT  NULL ,
[ic_pad_meta_faturamento] CHAR (1) NULL ,
[nm_obs_meta_faturamento] VARCHAR (40) NULL ,
[cd_usuario] INT  NULL ,
[dt_usuario] DATETIME  NULL ,
[cd_tipo_mercado] INT  NULL ,
CONSTRAINT PK_Meta_Faturamento PRIMARY KEY(cd_empresa,cd_meta_faturamento)) ON [PRIMARY] 

ALTER TABLE EGISSQL.dbo.Meta_Faturamento ADD CONSTRAINT FK_Meta_Faturamento_Tipo_Mercado FOREIGN KEY (cd_tipo_mercado) REFERENCES Tipo_Mercado (cd_tipo_mercado )

--select * from meta_faturamento

set @cd_meta_faturamento = 0

while exists ( select top 1 cd_empresa from Aux_Meta_Faturamento )
begin

   set 
     @cd_meta_faturamento = @cd_meta_faturamento + 1

  select top 1
    @cd_empresa = cd_empresa,
    @dt_inicial = dt_ini_meta_faturamento,
    @dt_final   = dt_fim_meta_faturamento
  from
    Aux_Meta_Faturamento

  insert
    Meta_Faturamento
  select top 1
    cd_empresa,
    @cd_meta_faturamento,
    dt_ini_meta_faturamento,
    dt_fim_meta_faturamento,
    vl_meta_faturamento,
    ic_pad_meta_faturamento,
    nm_obs_meta_faturamento,
    cd_usuario,
    dt_usuario,
    cd_tipo_mercado
  from
    Aux_Meta_Faturamento

  delete from Aux_Meta_Faturamento
  where 
    @cd_empresa = cd_empresa              and
    @dt_inicial = dt_ini_meta_faturamento and
    @dt_final   = dt_fim_meta_faturamento
          
end

drop table Aux_Meta_Faturamento

