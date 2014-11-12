

--pr_atualizar_cep
---------------------------------------------------
--Polimold Industrial S/A                      2001
--Stored Procedure: Microsoft SQL Server 7.0 / 2000
--Autor(es): Johnny Mendes de Souza
--Banco de Dados: SAPSQL
--Objetivo: Atualizar tabela de Cep
--Data       : 11/07/2002
--Atualizado : 
---------------------------------------------------

CREATE PROCEDURE pr_atualizar_cep

as

/*  
  
  select t.cep,
         t.codzona,
         z.cd_zona,
         t.coddis,
         d.cd_distrito,
         t.codreg,
         r.cd_regiao,
         t.ref_geo,
         t.ref_new,
         g.cd_divisao_regiao

  from sap.dbo.tabcep t, cep c, 
       sap.dbo.cadzona zs, zona z, 
       sap.dbo.caddist ds, distrito d,
       sap.dbo.cadreg rs, regiao r,
       divisao_regiao g

  where replace(t.cep,'-','') = c.cd_cep and
        zs.NOMZONA = z.nm_zona  AND
        zs.CODZONA = t.codzona AND
        ds.NOMDIST = d.nm_distrito AND
        ds.CODDIST = t.coddis AND
        rs.NOMREG = r.nm_regiao and
        rs.CODREG = t.codreg and
        g.nm_divisao_regiao = t.ref_new 
*/

 update 
   Cep 
 set
  cd_zona           = 0,
  cd_distrito       = 0,
  cd_regiao         = 0,
  cd_divisao_regiao = 0

 update
   Cep 
 set
   cd_zona           = z.cd_zona,
   cd_distrito       = d.cd_distrito,
   cd_regiao         = r.cd_regiao,
   cd_divisao_regiao = g.cd_divisao_regiao

 from
   sap.dbo.tabcep t, cep c, 
   sap.dbo.cadzona zs, zona z, 
   sap.dbo.caddist ds, distrito d,
   sap.dbo.cadreg rs, regiao r,
   divisao_regiao g

  where replace(t.cep,'-','') = c.cd_cep and
        zs.NOMZONA = z.nm_zona  AND
        zs.CODZONA = t.codzona AND
        ds.NOMDIST = d.nm_distrito AND
        ds.CODDIST = t.coddis AND
        rs.NOMREG = r.nm_regiao and
        rs.CODREG = t.codreg and
        g.nm_divisao_regiao = t.ref_new 

--select * from sap.dbo.cadgeomp
--select * from sap.dbo.tabcep
--select * from divisao_regiao where cd_divisao_regiao = 14 and nm_divisao_REGIAO='55N'

/*
  update
    cast(c.CEP8_LOG as char(9)) 	as 'cd_cep',
    cast(e.CHAVE_UF as int)		as 'cd_estado',
    cast(c.CHVLOCAL_LOG as int) 	as 'cd_cidade',
    1 					as 'cd_regiao', -- Padrão
    1 					as 'cd_zona', 	-- Padrão
    cast(c.CHVBAI1_LOG as int) 		as 'cd_distrito',
    cast(null as int)			as 'cd_divisao_regiao',

  from
*/    

