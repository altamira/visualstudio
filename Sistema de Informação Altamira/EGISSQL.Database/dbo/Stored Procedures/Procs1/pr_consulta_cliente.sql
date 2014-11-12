
CREATE PROCEDURE pr_consulta_cliente
-------------------------------------------------------------------------------------------------------------
--pr_consulta_cliente
--------------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                                                 2004
--------------------------------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Fabio Cesar Magalhães
--Banco de Dados	: EgisSQL
--Objetivo		: Filtrar as informações do cliente
--Data			: 14.08.2002
--Alteração		: <Data de Atualização>
--Desc. Alteração	: <Descrição da Alteração>
-- 29/07/2003 - Daniel C. Neto - Incluído Consultas de Nome Fantasia , Razão Social, CNPJ e CPF.
-- 26/09/2003 - Inclusão dos campos 'ic_habilitado_suframa' e 'cd_suframa_cliente' - Daniel Duela
-- 05/10/2003 - Inclusão do campo 'cd_tipo_pessoa' - Eduardo
-- 02.02.2004 - Inclusao dos campos 'nm_pais' e 'nm_tipo_mercado' - RAFAEL M. SANTIAGO
-- 08/10/2004 - Acerto das Clausulas WHERE, utilizando Case para melhorar Desempenho - ELIAS
-- 08/10/2004 - Acerto na consulta de cliente para trazer primeiro o cliente exato, caso não encontre, utilizar
-- like - Daniel C. Neto.
-- 08/10/2004 - Colocado IsNull - Daniel C. Neto.
-- 23/11/2004 - Incluído filtro por loja - Daniel c. Neto.
-- 24/11/2004 - Acerto na Lógica Implementada pelo Carrasco - ELIAS
-- 10/12/2004 - Acerto no Cabeçalho - Sérgio Cardoso
-- 01/02/2005 - Acerto no Parâmetro 2 de problema encontrado com o uso conjunto dos operadores like e case
--              que não retornavam nenhum registro. Problema ocorrido na SMC. - ELIAS
-- 04/02/2005 - Acerto de problema que ocorria ao selecionar um fantasia que não existe - ELIAS
-- 29.06.2005 - Incluido o Campo de Nome do Usuário - Rafael Santiago
-- 09.09.2005 - Alterado para puxar o Vendedor da tabela Cliente_Vendedor - RAFAEL SANTIAGO
-- 22.08.2006 - Adição de "With (nolock)" para evitar travamentos - Fabio Cesar - 22.08.2006
-- 20/09/2006 - Retirado referência explícita a Indices de tabelas - Daniel C. Neto.
-- 06/11/2006 - Incluído vários campos na consulta. Otimização do SQL - Daniel C. Neto.
-- 21/12/2006 - Incluído Pais, UF, Cidade na pesquisa de Cliente - Anderson
-- 05/02/2007 - Incluindo Fantasia do Usuário e a data na Grid. - Anderson
-- 26/03/2007 - Incluindo Pesquisa pelo código interno do cliente - Anderson
-- 14.08.2007 - Verificação dos flags de Suspensão de Crédito - Carlos Fernandes
-- 28.07.2008 - Região do Cliente - Carlos Fernandes
-- 03.10.2008 - Tabela de Preço na Grid - Carlos Fernandes
-- 16.10.2008 - Complemento dos Campos - Carlos Fernandes
-- 12.03.2009 - Pesquisa de Cliente por Endereço - Carlos Fernandes
-- 20.07.2009 - Código do IBGE da Cidade - Carlos Fernandes
-- 04.03.2010 - Aplicação do Segmento - Carlos Fernandes
-----------------------------------------------------------------------------------------------------------------
@ic_parametro              integer,
@nm_fantasia_cliente       varchar(15) = '',
@ic_tipo_consulta          char(4)     = 'F',
@cd_usuario                int         = 0, --Código do usuário.
@ic_trazer_cliente_inativo char(1)     = 'S'

AS


  declare @cd_vendedor                 int,
	  @ic_mostrar_vendedor_caption char(1),
          @cd_loja                     int

  set @cd_vendedor                 = 0
  set @ic_mostrar_vendedor_caption = 'N'

  if IsNull(@cd_usuario,0) <> 0
  begin

    -- ELIAS 24/11/2004 - Deverá buscar o Vendedor do usuário
    -- Internet, filtrando pelo campo cd_usuario e não cd_usuario_internet 
    -- (Não encontrei o significado do campo cd_usuario_internet e nem aonde é entrada
    -- essa informação - ELIAS
    -- ELIAS 24/11/2004 - Modificada a Forma como estava sendo carregado as 
    -- variáveis @cd_vendedor e @cd_loja que estava possibilitando o seu carregamento
    -- como null
    set @cd_vendedor = isnull((select top 1 u.cd_vendedor
                               from EgisAdmin.dbo.Usuario_Internet u with (nolock) 
                               where u.cd_usuario_internet = @cd_usuario and 
                                     IsNull(u.ic_vpn_usuario,'N') = 'S'),0)

    set @cd_loja = isnull((Select top 1 us.cd_loja 
                           from EgisAdmin.dbo.Usuario us with (nolock) 
                           where us.cd_usuario = @cd_usuario),0)
     
    if IsNull(@cd_vendedor,0) > 0 
      set @ic_mostrar_vendedor_caption = 'S'
    else
    begin
      set @ic_mostrar_vendedor_caption = 'N'
  	  set @cd_vendedor = 0
    end     

  end



    Select
      c.cd_cliente,
      c.nm_fantasia_cliente,
      c.nm_razao_social_cliente, 
      r.nm_ramo_atividade,
      f.nm_fonte_informacao,
      s.nm_status_cliente,
      c.cd_ddd, 
      c.cd_telefone,
      ci.nm_cidade,
      e.sg_estado,
      c.dt_cadastro_cliente,
      c.cd_cnpj_cliente,
      c.cd_inscestadual,
      c.cd_cep,
      c.cd_Fax,
      rg.nm_cliente_regiao as nm_regiao,
      c.nm_divisao_area, 
      (Case isNull(c.cd_vendedor,0)
         when 0 then
          (Select top 1 
             b.nm_fantasia_vendedor 
 		    from Cliente_Vendedor a with (nolock)
             inner join Vendedor b with (nolock)
               on (a.cd_vendedor = b.cd_vendedor)  
             inner join Tipo_Vendedor x with (nolock)
               on (a.cd_tipo_vendedor = x.cd_tipo_vendedor)
          where 
		         a.cd_cliente = c.cd_cliente and 
             isnull(x.ic_interno_tipo_vendedor,'N') = 'N'
          order by 
             a.dt_usuario desc)
       else
          (Select top 1 
             b.nm_fantasia_vendedor 
 		       from 
		         Vendedor b with (nolock)
           where 
		         b.cd_vendedor =  c.cd_vendedor)
       end)                                               as nm_fantasia_vendedor,      

      c.cd_vendedor_interno,

      (Case isNull(c.cd_vendedor_interno,0)
         when 0 then
          (Select top 1 
             b.nm_fantasia_vendedor 
 		       from Cliente_Vendedor a with (nolock) 
                inner join Vendedor b with (nolock)
                  on (a.cd_vendedor = b.cd_vendedor)  
                inner join Tipo_Vendedor x with (nolock)
                  on (a.cd_tipo_vendedor = x.cd_tipo_vendedor)
          where 
		       a.cd_cliente = c.cd_cliente and 
             isnull(x.ic_interno_tipo_vendedor,'N') = 'S'
          order by 
             a.dt_usuario desc)
       else
          (Select top 1 
             b.nm_fantasia_vendedor 
 		       from 
             Vendedor b with (nolock)
           where 
		         b.cd_vendedor =  c.cd_vendedor_interno)
         end)                                            as nm_fantasia_vendedor_interno,

      (Select top 1 nm_mascara_tipo_pessoa 
       from 
         Tipo_Pessoa with (nolock)
       where cd_tipo_pessoa = c.cd_tipo_pessoa)          as  nm_mascara_tipo_pessoa,
      gc.nm_cliente_grupo,
  	  @ic_mostrar_vendedor_caption as ic_mostrar_vendedor_caption,
  	  (Select top 1 nm_vendedor from vendedor with (nolock) where cd_vendedor = @cd_vendedor) as nm_vendedor_caption,

      isnull(c.ic_habilitado_suframa,'N')                as ic_habilitado_suframa,
      c.cd_suframa_cliente,
      c.cd_tipo_pessoa,
      tm.nm_tipo_mercado,
      pa.nm_pais,
      c.cd_moeda,
      m.sg_moeda,
      m.nm_moeda,
      us.nm_fantasia_usuario,
      c.dt_usuario,
      c.ic_contrib_icms_cliente,
      c.ic_liberado_pesq_credito,
      ccon.nm_conceito_cliente,
      i.nm_idioma,
      tp.nm_tipo_pessoa,
      t.nm_fantasia,
      dp.nm_destinacao_produto,
      cv.nm_criterio_visita,
      cc.nm_centro_custo,
      cp.nm_condicao_pagamento,
      ttp.nm_tipo_tabela_preco,
      isnull(ic.ic_credito_suspenso,'N')       as ic_credito_suspenso,
      isnull(ic.ic_alerta_credito_cliente,'N') as ic_alerta_credito_cliente,
      --Endereço do Cliente
      rtrim(ltrim(c.nm_endereco_cliente))+', '+rtrim(ltrim(c.cd_numero_endereco)) as nm_endereco_cliente,
      c.nm_complemento_endereco,
      c.nm_bairro,
      tbp.nm_tabela_preco,
      ci.cd_cidade_ibge,
      aps.nm_aplicacao_segmento      

--select * from cliente
--select * from cidade

    from
      Cliente c                     with (nolock) Left Join 
      cliente_informacao_credito ic with (nolock) on ic.cd_cliente = c.cd_cliente                    Left Join
      Ramo_Atividade r              with (nolock) On c.cd_ramo_atividade = r.cd_ramo_atividade 	     Left Join 
      Fonte_Informacao f            with (nolock) On c.cd_Fonte_Informacao = f.cd_Fonte_Informacao    Left Join 
      Status_Cliente s              with (nolock) On c.cd_Status_Cliente = s.cd_Status_Cliente 	     Left Join 
      Cidade ci                     with (nolock) On ci.cd_pais   = c.cd_pais and 
                                                     ci.cd_estado = c.cd_estado and 
                                                     ci.cd_cidade = c.cd_cidade                         Left Join 
      Estado e                      with (nolock) On ci.cd_pais = c.cd_pais and 
					  e.cd_estado = c.cd_estado			     Left Join 
      Cliente_Grupo gc              with (nolock)   On c.cd_cliente_grupo = gc.cd_cliente_grupo           Left Join 
      Cliente_Regiao rg             with (nolock)  On c.cd_regiao         = rg.cd_cliente_regiao                 left outer join
      Tipo_Mercado tm               with (nolock)    on c.cd_tipo_mercado = tm.cd_tipo_mercado             left outer join
      Pais pa                       with (nolock)            on pa.cd_pais = c.cd_pais                             left outer join
      Moeda m                       with (nolock)            on c.cd_moeda = m.cd_moeda                            left outer join
      EgisAdmin.dbo.Usuario us      with (nolock)   on c.cd_usuario = us.cd_usuario   		     left outer join
      Destinacao_produto dp	    with (nolock)   on dp.cd_destinacao_produto = c.cd_destinacao_produto left outer join
      Transportadora t              with (nolock)   on t.cd_transportadora =  c.cd_transportadora         left outer join
      Condicao_Pagamento cp         with (nolock)   on cp.cd_condicao_pagamento = c.cd_condicao_pagamento left outer join
      Idioma i                      with (nolock)   on i.cd_idioma = c.cd_idioma                          left outer join
      Criterio_Visita cv            with (nolock)   on cv.cd_criterio_visita = c.cd_criterio_visita       left outer join
      Centro_Custo cc               with (nolock)   on cc.cd_Centro_Custo = c.cd_Centro_Custo             left outer join
      Tipo_Pessoa tp                with (nolock)   on tp.cd_Tipo_Pessoa = c.cd_Tipo_Pessoa               left outer join
      Cliente_Conceito ccon         with (nolock)   on ccon.cd_conceito_cliente = c.cd_conceito_cliente   left outer join
      tipo_tabela_preco ttp         with (nolock)   on ttp.cd_tipo_tabela_preco = c.cd_tipo_tabela_preco  left outer join
      Tabela_Preco tbp              with (nolock)   on tbp.cd_tabela_preco      = c.cd_tabela_preco       left outer join
      Aplicacao_Segmento Aps        with (nolock)   on aps.cd_aplicacao_segmento = c.cd_aplicacao_segmento
  
      
   where
       isnull(c.cd_vendedor,0) = case when @cd_vendedor > 0 then @cd_vendedor else isnull(c.cd_vendedor,0) end and
       isnull(c.cd_loja,0) = case when @cd_Loja > 0 then @cd_Loja else isnull(c.cd_loja,0) end and
       (case when @ic_parametro = 1 then 1
             when @ic_parametro = 2 and 
                  @ic_tipo_consulta = 'F' and 
                  c.nm_fantasia_cliente like @nm_fantasia_cliente+'%' then 1
             when @ic_parametro = 2 and 
                  @ic_tipo_consulta = 'R' and 
                  IsNull(c.nm_razao_social_cliente,'') like @nm_fantasia_cliente+'%' then 1
             when @ic_parametro = 2 and 
                  @ic_tipo_consulta = 'CNPJ' and 
                  IsNull(c.cd_tipo_pessoa,0) = 1 and 
                  replace(replace(replace(c.cd_cnpj_cliente, '.', '' ), '-', ''),'/','') like replace(replace(replace(@nm_fantasia_cliente, '.', '' ), '-', ''),'/','')+'%' then 1
                  --IsNull(c.cd_cnpj_cliente,'') = @nm_fantasia_cliente then 1
             when @ic_parametro = 2 and
		  @ic_tipo_consulta = 'CPF' and
		  IsNull(c.cd_tipo_pessoa,0) = 2 and 
                  IsNull(c.cd_cnpj_cliente,'') = @nm_fantasia_cliente then 1 
             when @ic_parametro = 2 and 
                  @ic_tipo_consulta = 'PAIS' and 
                  IsNull(pa.nm_pais,'') like @nm_fantasia_cliente+'%' then 1
             when @ic_parametro = 2 and 
                  @ic_tipo_consulta = 'UF' and 
                  IsNull(e.sg_estado,'') like @nm_fantasia_cliente+'%' then 1
             when @ic_parametro = 2 and 
                  @ic_tipo_consulta = 'CID' and 
                  IsNull(ci.nm_cidade,'') like @nm_fantasia_cliente+'%' then 1
             when @ic_parametro = 2 and 
                  @ic_tipo_consulta = 'E' and  --Endereço 
                  IsNull(c.nm_endereco_cliente,'') like @nm_fantasia_cliente+'%' then 1
             when @ic_parametro = 2 and 
                  @ic_tipo_consulta = 'C' and 
                  c.cd_cliente = @nm_fantasia_cliente then 1
             else 0 end ) = 1 and
       (case when IsNull(@ic_trazer_cliente_inativo,'S') = 'S' then 1 
             when IsNull(@ic_trazer_cliente_inativo,'S') = 'N' and
                  IsNull(s.ic_permite_fechamento_proposta,'S') = 'S' then 1
             else 0 end ) = 1
    order by c.nm_fantasia_cliente


