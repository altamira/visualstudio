
CREATE  PROCEDURE pr_consulta_fornecedor
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2001
-----------------------------------------------------------------------------------------
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
-- 29.06.2005 - Incluido o campo de nome do usuário
-- 07.09.2005 - Grupo de Fornecedor - Carlos Fernandes
-- 22/11/2006 - Incluído parâmetro para não trazer fornecedores inativos. - Daniel C. Neto.
-- 23/01/2007 - Incluído cd_destinacao_produto para carregar no pedido de compra - Anderson
-- 18.06.2007 - Tipo de Mercado - Carlos Fernandes
-- 08.10.2007 - Complemento dos Campos - Carlos Fernandes
-- 26.08.2008 - Endereço do Fornecedor - Carlos Fernandes
-- 20.02.2009 - Complemento (DDI do fornecedor) Douglas de Paula
-- 20.07.2009 - Código do IBGE da Cidade - Carlos Fernadnes
-- 18.01.2011 - Consulta por Código - Carlos Fernandes
-----------------------------------------------------------------------------------------
@ic_parametro           integer     = 0,
@nm_fantasia_fornecedor varchar(15) = '',
@ic_tipo_consulta       char(5)     = 'F',
@ic_trazer_inativo      char(1)     = 'S'


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
      p.cd_ddi_pais, 
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
      tm.nm_tipo_mercado,
      us.nm_fantasia_usuario,
      gf.nm_grupo_fornecedor,
      f.cd_destinacao_produto,
      f.cd_aplicacao_produto,
      dp.nm_destinacao_produto,
      ap.nm_aplicacao_produto,
      cp.nm_condicao_pagamento,
      --Endereço do Fornecedor
      rtrim(ltrim(f.nm_endereco_fornecedor))+', '+rtrim(ltrim(f.cd_numero_endereco)) as nm_endereco_fornecedor,
      f.nm_complemento_endereco,
      f.nm_bairro,
      ci.cd_cidade_ibge      
      
--select * from fornecedor

--     into
--       #ConsultaFornecedor

    from
      Fornecedor f with (nolock)
    left Join Tipo_Pessoa tp                 On f.cd_tipo_pessoa = tp.cd_tipo_pessoa
    Left Join Ramo_Atividade r               On f.cd_ramo_atividade = r.cd_ramo_atividade
    Left Join Estado e                       On f.cd_estado = e.cd_estado
    Left Join Cidade ci                      On f.cd_cidade = ci.cd_cidade
    left outer join Comprador c              on c.cd_comprador = f.cd_comprador
    left outer join pais p                   on f.cd_pais = p.cd_pais
    left outer join tipo_mercado tm          on tm.cd_tipo_mercado = f.cd_tipo_mercado
    left outer join EGISADMIN.dbo.Usuario us on f.cd_usuario = us.cd_usuario
    left outer join Grupo_Fornecedor gf      on gf.cd_grupo_fornecedor = f.cd_grupo_fornecedor
    left outer join Destinacao_Produto dp    on dp.cd_destinacao_produto = f.cd_destinacao_produto
    left outer join Aplicacao_produto ap     on ap.cd_aplicacao_produto  = f.cd_aplicacao_produto
    left outer join Condicao_Pagamento cp    on cp.cd_condicao_pagamento = f.cd_condicao_pagamento
    where
	( case when IsNull(@ic_trazer_inativo,'S') = 'S' then 1
             when IsNull(@ic_trazer_inativo,'S') = 'N' and isNull(f.ic_status_fornecedor,'A') = 'A' then 1
             else 0 end ) = 1
    order by f.nm_fantasia_fornecedor

  end

-------------------------------------------------------------------------------------------
  else if @ic_parametro = 2 --Consulta Somente fornecedor que começa com o nome fantasia informado
-------------------------------------------------------------------------------------------
  begin


    Select 
      distinct
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
      p.cd_ddi_pais, 
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
      tm.nm_tipo_mercado,
      us.nm_fantasia_usuario,
      gf.nm_grupo_fornecedor,
      f.cd_destinacao_produto,
      f.cd_aplicacao_produto,
      dp.nm_destinacao_produto,
      ap.nm_aplicacao_produto,
      cp.nm_condicao_pagamento,
      --Endereço do Fornecedor
      rtrim(ltrim(f.nm_endereco_fornecedor))+', '+rtrim(ltrim(f.cd_numero_endereco)) as nm_endereco_fornecedor,
      f.nm_complemento_endereco,
      f.nm_bairro,
      ci.cd_cidade_ibge      

    into 
      #Fornecedor
    from
      Fornecedor f with (nolock)
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
    left outer join EGISADMIN.dbo.Usuario us
    on f.cd_usuario = us.cd_usuario
    left outer join Grupo_Fornecedor gf on gf.cd_grupo_fornecedor = f.cd_grupo_fornecedor
    left outer join Destinacao_Produto dp    on dp.cd_destinacao_produto = f.cd_destinacao_produto
    left outer join Aplicacao_produto ap     on ap.cd_aplicacao_produto  = f.cd_aplicacao_produto
    left outer join Condicao_Pagamento cp    on cp.cd_condicao_pagamento = f.cd_condicao_pagamento
    where 
      (f.nm_fantasia_Fornecedor = @nm_fantasia_fornecedor and @ic_tipo_consulta  = 'F') or
      (f.nm_razao_social        = @nm_fantasia_fornecedor  and @ic_tipo_consulta = 'R') or
      (replace(replace(replace(f.cd_cnpj_fornecedor, '.', '' ), '-', ''),'/','') like replace(replace(replace(@nm_fantasia_fornecedor, '.', '' ), '-', ''),'/','') + '%' and @ic_tipo_consulta = 'CNPJ' and f.cd_tipo_pessoa = 1) or
      (replace(replace(replace(f.cd_cnpj_fornecedor, '.', '' ), '-', ''),'/','') like replace(replace(replace(@nm_fantasia_fornecedor, '.', '' ), '-', ''),'/','') + '%' and @ic_tipo_consulta = 'CPF'  and f.cd_tipo_pessoa = 2) or
      (cast(f.cd_fornecedor as varchar) = @nm_fantasia_fornecedor  and @ic_tipo_consulta = 'C') 


      --(f.cd_cnpj_fornecedor = @nm_fantasia_fornecedor and @ic_tipo_consulta = 'CNPJ' and f.cd_tipo_pessoa = 1) or
      --(f.cd_cnpj_fornecedor = @nm_fantasia_fornecedor and @ic_tipo_consulta = 'CPF' and f.cd_tipo_pessoa = 2) 
    order by f.nm_fantasia_fornecedor

  if (select count(cd_fornecedor) from #Fornecedor) = 1
    select * from #Fornecedor where 	( case when IsNull(@ic_trazer_inativo,'S') = 'S' then 1
             when IsNull(@ic_trazer_inativo,'S') = 'N' and isNull(ic_status_fornecedor,'Ativo') = 'Ativo' then 1
             else 0 end ) = 1 

  else
    begin
      Select distinct
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
        p.cd_ddi_pais, 
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
        tm.nm_tipo_mercado,
        us.nm_fantasia_usuario,
        gf.nm_grupo_fornecedor,
        f.cd_destinacao_produto,
        f.cd_aplicacao_produto,
        dp.nm_destinacao_produto,
        ap.nm_aplicacao_produto,
        cp.nm_condicao_pagamento,
      --Endereço do Fornecedor
      rtrim(ltrim(f.nm_endereco_fornecedor))+', '+rtrim(ltrim(f.cd_numero_endereco)) as nm_endereco_fornecedor,
      f.nm_complemento_endereco,
      f.nm_bairro,
      ci.cd_cidade_ibge      

      from
	      Fornecedor f with (nolock)
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
      left outer join EGISADMIN.dbo.Usuario us
        on f.cd_usuario = us.cd_usuario
      left outer join Grupo_Fornecedor gf on gf.cd_grupo_fornecedor = f.cd_grupo_fornecedor
      left outer join Destinacao_Produto dp    on dp.cd_destinacao_produto = f.cd_destinacao_produto
      left outer join Aplicacao_produto ap     on ap.cd_aplicacao_produto  = f.cd_aplicacao_produto
      left outer join Condicao_Pagamento cp    on cp.cd_condicao_pagamento = f.cd_condicao_pagamento
      where 
        ( (f.nm_fantasia_Fornecedor like @nm_fantasia_fornecedor + '%' and @ic_tipo_consulta = 'F') or
        (  f.nm_razao_social        like @nm_fantasia_fornecedor + '%' and @ic_tipo_consulta = 'R') or
        --(f.cd_cnpj_fornecedor like @nm_fantasia_fornecedor + '%' and @ic_tipo_consulta = 'CNPJ' and f.cd_tipo_pessoa = 1) or
        --(f.cd_cnpj_fornecedor like @nm_fantasia_fornecedor + '%' and @ic_tipo_consulta = 'CPF' and f.cd_tipo_pessoa = 2) ) and
        (replace(replace(replace(f.cd_cnpj_fornecedor, '.', '' ), '-', ''),'/','') like replace(replace(replace(@nm_fantasia_fornecedor, '.', '' ), '-', ''),'/','') + '%' and @ic_tipo_consulta = 'CNPJ' and f.cd_tipo_pessoa = 1) or
        (replace(replace(replace(f.cd_cnpj_fornecedor, '.', '' ), '-', ''),'/','') like replace(replace(replace(@nm_fantasia_fornecedor, '.', '' ), '-', ''),'/','') + '%' and @ic_tipo_consulta = 'CPF' and f.cd_tipo_pessoa = 2)  or
        ( cast(f.cd_fornecedor as varchar) = @nm_fantasia_fornecedor  and @ic_tipo_consulta = 'C') 

        ) 
       and
	( case when IsNull(@ic_trazer_inativo,'S') = 'S' then 1
             when (IsNull(@ic_trazer_inativo,'S') = 'N') and (isNull(f.ic_status_fornecedor,'A') = 'A') then 1
             else 0 end ) = 1 

      order by f.nm_fantasia_fornecedor
    end
  end

-------------------------------------------------------------------------------------------
  else if @ic_parametro = 3 --Abre a consulta mas não traz nenhum fornecedor
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
      p.cd_ddi_pais, 
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
      cast(null as varchar) as nm_tipo_mercado,
      us.nm_fantasia_usuario,
      gf.nm_grupo_fornecedor,
      f.cd_destinacao_produto,
      f.cd_aplicacao_produto,
      dp.nm_destinacao_produto,
      ap.nm_aplicacao_produto,
      cp.nm_condicao_pagamento,
      --Endereço do Fornecedor
      rtrim(ltrim(f.nm_endereco_fornecedor))+', '+rtrim(ltrim(f.cd_numero_endereco)) as nm_endereco_fornecedor,
      f.nm_complemento_endereco,
      f.nm_bairro,
      ci.cd_cidade_ibge      

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
    left outer join EGISADMIN.dbo.Usuario us
    on f.cd_usuario = us.cd_usuario
    left outer join pais p
    on p.cd_pais = f.cd_pais 
    left outer join Grupo_Fornecedor gf on gf.cd_grupo_fornecedor = f.cd_grupo_fornecedor
    left outer join Destinacao_Produto dp    on dp.cd_destinacao_produto = f.cd_destinacao_produto
    left outer join Aplicacao_produto ap     on ap.cd_aplicacao_produto  = f.cd_aplicacao_produto
    left outer join Condicao_Pagamento cp    on cp.cd_condicao_pagamento = f.cd_condicao_pagamento

    order by f.nm_fantasia_fornecedor

  end

