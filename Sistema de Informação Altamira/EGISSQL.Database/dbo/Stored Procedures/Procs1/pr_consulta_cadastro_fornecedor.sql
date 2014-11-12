
CREATE PROCEDURE pr_consulta_cadastro_fornecedor
---------------------------------------------------------
--GBS - Global Business Solution	             2001
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		    : ?
--Banco de Dados	: EGISSQL
--Objetivo		    : Consultar Fornecedor na tela de Cadastro.
--Data			      : Daniel C. Neto
---------------------------------------------------
@nm_fantasia_fornecedor varchar(15),
@ic_tipo_consulta char(1)

AS

    Select
      f.cd_fornecedor,
      f.nm_fantasia_fornecedor,
      f.nm_razao_social,
      f.nm_razao_social_comple, 
      r.nm_ramo_atividade,
      c.nm_fantasia_comprador,
      f.cd_ddd, 
      f.cd_telefone,
      f.cd_cep,
      ci.nm_cidade,
      e.sg_estado,
      f.dt_cadastro_fornecedor,
   	  f.cd_pais
    into #Fornecedor
    from
      Fornecedor f
    Left Join Ramo_Atividade r
    On f.cd_ramo_atividade = r.cd_ramo_atividade
    Left Join Estado e
    On f.cd_estado = e.cd_estado
    Left Join Cidade ci
    On f.cd_cidade = ci.cd_cidade
    left outer join Comprador c
    on c.cd_comprador = f.cd_comprador
    where 
      f.nm_fantasia_Fornecedor = @nm_fantasia_fornecedor
    order by f.nm_fantasia_fornecedor

  if (select count(cd_fornecedor) from #Fornecedor) = 1
    select * from #Fornecedor
  else
    begin
      Select
        f.cd_fornecedor,
        f.nm_fantasia_fornecedor,
        f.nm_razao_social,
        r.nm_ramo_atividade,
        f.cd_ddd, 
        f.cd_telefone,
        f.cd_cep,
        ci.nm_cidade,
        e.sg_estado,
        f.dt_cadastro_fornecedor,
        f.cd_pais
      from
        Fornecedor f
      Left Join Ramo_Atividade r
      On f.cd_ramo_atividade = r.cd_ramo_atividade
      Left Join Estado e
      On f.cd_estado = e.cd_estado
      Left Join Cidade ci
      On f.cd_cidade = ci.cd_cidade
      where 
        (f.nm_fantasia_Fornecedor like @nm_fantasia_fornecedor + '%' and @ic_tipo_consulta = 'F') or
        (f.nm_razao_social like @nm_fantasia_fornecedor + '%' and @ic_tipo_consulta = 'R') or
        (f.cd_cnpj_fornecedor like @nm_fantasia_fornecedor + '%' and @ic_tipo_consulta = 'C')
      order by f.nm_fantasia_fornecedor
    end


-- =============================================  
-- Testando a procedure  
-- ============================================= 
