

--pr_atualizar_regiao_cep
---------------------------------------------------
--Polimold Industrial S/A                      2001
--Stored Procedure: Microsoft SQL Server 7.0 / 2000
--Autor(es): Johnny Mendes de Souza
--Banco de Dados: SAPSQL
--Objetivo: Atualizar tabela de Cep
--Data       : 11/07/2002
--Atualizado : 
---------------------------------------------------

CREATE PROCEDURE pr_atualizar_regiao_cep

as

 update 
   Cep 
 set
  cd_regiao         = 0,
  cd_divisao_regiao = 0

 update
   Cep 
 set
   cd_regiao         = r.cd_regiao,
   cd_divisao_regiao = g.cd_divisao_regiao

 from
   sap.dbo.tabcep t, cep c, 
   sap.dbo.cadreg rs, regiao r,
   divisao_regiao g

  where replace(t.cep,'-','') = c.cd_cep and
        rs.NOMREG = r.nm_regiao and
        rs.CODREG = t.codreg and
        g.nm_divisao_regiao = t.ref_new 


