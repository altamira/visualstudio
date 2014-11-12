
CREATE  PROCEDURE pr_consulta_fornecedor
---------------------------------------------------------
--GBS - Global Business Solution	             2001
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		    : ?
--Banco de Dados	: EGISSQL
--Objetivo		    : Consultar Fornecedor
--Data			    : ?
--Alteração		    : Fabio Cesar - 28/02/2003
--Desc. Alteração	: Inclusão do campo pais
-- - 24/06/2003 - Incluída 3 novos tipos de pesquisa.
--              - Razão Social ,CNPJ e CPF
--Alteração                 : Igor Gama - 16/02/2004
--Desc                      : Inclusão de campo pais
-- 02/03/2004 - Inclusão do campo tipo de mercado.
-- Alteração : 02/12/2004 - Paulo Santos
---------------------------------------------------
@ic_parametro integer,
@nm_fantasia_fornecedor varchar(15),
@ic_tipo_consulta char(5) = 'F'

AS
-------------------------------------------------------------------------------------------
  if @ic_parametro = 1 --Consulta Todos Fornecedores
-------------------------------------------------------------------------------------------
  begin
    
    Select
      ic_status_fornecedor =
      case
			when isNull(f.ic_status_fornecedor,'A') = 'A' then
				'Ativo' 
			else 
				 'Inativo' 
      end,         

      f.cd_tipo_mercado,
      f.cd_condicao_pagamento,
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
      f.cd_pais,
      p.nm_pais,
      f.cd_cnpj_fornecedor,
      f.ic_simples_fornecedor,
      tp.nm_mascara_tipo_pessoa,
      tm.nm_tipo_mercado
    from
      Fornecedor f
    left Join Tipo_Pessoa tp 
		On f.cd_tipo_pessoa = tp.cd_tipo_pessoa
    Left Join Ramo_Atividade r
    On f.cd_ramo_atividade = r.cd_ramo_atividade
    Left Join Estado e
    On f.cd_estado = e.cd_estado
    Left Join Cidade ci
    On f.cd_cidade = ci.cd_cidade
    left outer join Comprador c
    on c.cd_comprador = f.cd_comprador
    left outer join pais p
    on f.cd_pais = p.cd_pais
    left outer join tipo_mercado tm 
    on tm.cd_tipo_mercado = f.cd_tipo_mercado
    order by f.nm_fantasia_fornecedor
  end
-------------------------------------------------------------------------------------------
  else if @ic_parametro = 2 --Consulta Somente fornecedor que começa com o nome fantasia informado
-------------------------------------------------------------------------------------------
  begin


    Select distinct
      f.cd_tipo_mercado,
      f.cd_condicao_pagamento,
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
      f.cd_pais,
      p.nm_pais,
      f.cd_cnpj_fornecedor ,
      f.ic_simples_fornecedor,
      tp.nm_mascara_tipo_pessoa,
      tm.nm_tipo_mercado
    into 
      #Fornecedor
    from
      Fornecedor f
    left Join Tipo_Pessoa tp 
		On f.cd_tipo_pessoa = tp.cd_tipo_pessoa
    Left Join Ramo_Atividade r
    On f.cd_ramo_atividade = r.cd_ramo_atividade
    Left Join Estado e
    On f.cd_estado = e.cd_estado
    Left Join Cidade ci
    On f.cd_cidade = ci.cd_cidade
    left outer join Comprador c
    on c.cd_comprador = f.cd_comprador
    left outer join pais p
    on f.cd_pais = p.cd_pais
    left outer join Tipo_Mercado tm
    on tm.cd_tipo_mercado = f.cd_tipo_mercado
    where 
      (f.nm_fantasia_Fornecedor = @nm_fantasia_fornecedor and @ic_tipo_consulta = 'F') or
      (f.nm_razao_social = @nm_fantasia_fornecedor and @ic_tipo_consulta = 'R') or
      (f.cd_cnpj_fornecedor = @nm_fantasia_fornecedor and @ic_tipo_consulta = 'CNPJ' and f.cd_tipo_pessoa = 1) or
      (f.cd_cnpj_fornecedor = @nm_fantasia_fornecedor and @ic_tipo_consulta = 'CPF' and f.cd_tipo_pessoa = 2)
    order by f.nm_fantasia_fornecedor

  if (select count(cd_fornecedor) from #Fornecedor) = 1
    select * from #Fornecedor
  else
    begin
      Select distinct
        f.cd_tipo_mercado,
        f.cd_condicao_pagamento,
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
	      f.cd_pais,
        p.nm_pais,
	      f.cd_cnpj_fornecedor,
        f.ic_simples_fornecedor,
        tp.nm_mascara_tipo_pessoa,
        tm.nm_tipo_mercado
      from
	      Fornecedor f
      left Join Tipo_Pessoa tp 
        On f.cd_tipo_pessoa = tp.cd_tipo_pessoa
      Left Join Ramo_Atividade r
        On f.cd_ramo_atividade = r.cd_ramo_atividade
      Left Join Estado e
        On f.cd_estado = e.cd_estado
      Left Join Cidade ci
        On f.cd_cidade = ci.cd_cidade
      left outer join Comprador c
        on c.cd_comprador = f.cd_comprador
      Left outer join pais p
        on f.cd_pais = p.cd_pais
      left outer join Tipo_Mercado tm
        on tm.cd_tipo_mercado = f.cd_tipo_mercado
      where 
        (f.nm_fantasia_Fornecedor like @nm_fantasia_fornecedor + '%' and @ic_tipo_consulta = 'F') or
        (f.nm_razao_social like @nm_fantasia_fornecedor + '%' and @ic_tipo_consulta = 'R') or
        (f.cd_cnpj_fornecedor like @nm_fantasia_fornecedor + '%' and @ic_tipo_consulta = 'CNPJ' and f.cd_tipo_pessoa = 1) or
        (f.cd_cnpj_fornecedor like @nm_fantasia_fornecedor + '%' and @ic_tipo_consulta = 'CPF' and f.cd_tipo_pessoa = 2)
      order by f.nm_fantasia_fornecedor
    end
  end

-------------------------------------------------------------------------------------------
  else if @ic_parametro = 3 --Abre a consulta mas não traz nenhum fornecedor
-------------------------------------------------------------------------------------------
  begin
    Select
      f.cd_tipo_mercado,
      f.cd_condicao_pagamento,
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
      f.cd_pais,
      '' nm_pais,
      f.cd_cnpj_fornecedor,
      f.ic_simples_fornecedor,
      tp.nm_mascara_tipo_pessoa,
      cast(null as varchar) as nm_tipo_mercado
    from
      (Select * from fornecedor where 1=2) as  f
    left Join Tipo_Pessoa tp 
    On f.cd_tipo_pessoa = tp.cd_tipo_pessoa
    Left Join Ramo_Atividade r
    On f.cd_ramo_atividade = r.cd_ramo_atividade
    Left Join Estado e
    On f.cd_estado = e.cd_estado
    Left Join Cidade ci
    On f.cd_cidade = ci.cd_cidade
    left outer join Comprador c
    on c.cd_comprador = f.cd_comprador 
    left outer join Tipo_mercado tm
    on tm.cd_tipo_mercado = f.cd_tipo_mercado
    order by f.nm_fantasia_fornecedor
  end

-- =============================================  
-- Testando a procedure  
-- ============================================= 

