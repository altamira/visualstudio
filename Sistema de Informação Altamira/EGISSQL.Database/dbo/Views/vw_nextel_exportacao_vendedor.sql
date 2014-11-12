
CREATE VIEW vw_nextel_exportacao_vendedor
------------------------------------------------------------------------------------
--vw_nextel_exportacao_vendedor
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2008
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Douglas de Paula Lopes
--Banco de Dados	: EGISSQL
--Objetivo	        : Remessa nextel vendedor.
--Data                  : 22/07/2008  
--Atualização           : 19.11.2008 - Ajuste do flag para identificar os vendedores
-- que devem ser exportados - Carlos Fernandes
------------------------------------------------------------------------------------
as
--create table Vendedor_Nextel ( cd_vendedor              integer CONSTRAINT primarykey PRIMARY KEY,
--                               nm_login_vendedor_nextel varchar(6),
--                               cd_senha_vendedor_nextel varchar(6),
--                               cd_fone_vendedor_nextel  varchar(20),
--                               nm_obs_vendedor_next     varchar(40),     
--                               cd_usuario               int,
--                               dt_usuario               datetime );
--select * from vendedor_nextel

select
cast(v.cd_vendedor as int(8))                   as COD,
cast(v.nm_vendedor as varchar(255))             as NOME,
cast(vn.nm_login_vendedor_nextel as varchar(6)) as LOGIN,
cast(vn.cd_senha_vendedor_nextel as varchar(6)) as SENHA,
cast(vn.cd_fone_vendedor_nextel as varchar(20)) as NEXTEL
from
  vendedor                        v  with(nolock)
  left outer join vendedor_nextel vn with(nolock) on vn.cd_vendedor = v.cd_vendedor
where
  isnull(vn.ic_exporta_vendedor,'N') = 'S'


