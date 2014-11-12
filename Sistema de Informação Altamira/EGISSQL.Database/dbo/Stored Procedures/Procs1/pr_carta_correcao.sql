
CREATE PROCEDURE pr_carta_correcao
--------------------------------------------------------------------------------------------------------
--pr_carta_correcao
--------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda           	    2004
--------------------------------------------------------------------------------------------------------
--Stored Procedure    : Microsoft SQL Server 2000
--Autor(es)           : Elias Pereira da Silva
--Banco de Dados      : SQL 
--Objetivo            : Rotinas de Carta de Correção (SLF)
--Data                : 19/06/2002
--Atualizado          : 21/06/2002 - Criada Opção de Listar Cabeçalho da Carta p/ Cod de Carta - ELIAS
--                    : 21/06/2002 - Criada Opção de Consultar única Carta - ELIAS 
--                    : 25/06/2002 - Diversos Acertos - ELIAS
--                    : 25/06/2002 - Criação da Rotina que atualiza o status de Listado - ELIAS
--                    : 27/08/2002 - Mudança na estrutura da Nota_Entrada - ELIAS
--		      : 23/10/2002 - Eliminação do Parâmetro 5 
--                                 - Inclusão de Novos Campos na Nota de Entrada
--			           - Inclusão do Parâmetro 7 - Daniel C. Neto.
--	              : 24/10/2002 - Incluido campo Serie da tabela Serie_Nota_Fiscal - Daniel C. Neto.
--                    : 19/11/2002 - Acerto no filtro do Parâmetro 7 - Daniel C. Neto.
--                    : 07/04/2004 - Incluído sigla da nota fiscal - Daniel c. Neto.
--                    : 15/04/2004 - Acertos - Daniel C. Neto.
--                    : 21.10.2004 - Alterações das querys para pegar os dados dos destinatários através da view destinatário.
--                    : 14/12/2004 - Incluído tipo de pessoa - Daniel C. Neto.
--                    : 28/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                    : 16.11.2007 - Tipo de Emissão da Carta de Correção - Carlos Fernandes
-- 07.04.2009 - Nota Fiscal Eletrônica - Carlos Fernandes
-- 06.10.2009 - Cabeçalho da Nota Fiscal - Carlos Fernandes
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
------------------------------------------------------------------------------------------------

@ic_parametro          int,
@cd_carta_correcao     int,
@dt_inicial            datetime,
@dt_final              datetime,
@cd_nota_saida         int,
@cd_nota_entrada       int,
@cd_serie_nota_fiscal  int,
@cd_fornecedor         int
as

  declare @cd_tipo_destinatario int
  declare @cd_destinatario      int

  declare @sg_serie_nota_fiscal varchar(40)

  set @sg_serie_nota_fiscal = ( select 
                                  sns.sg_serie_nota_fiscal
                                from
                                  Carta_Correcao cc                with (nolock) 
                                  inner join Serie_Nota_Fiscal sns with (nolock) on sns.cd_serie_nota_fiscal = cc.cd_serie_nota_fiscal
                                where
                                  cc.cd_carta_correcao = @cd_carta_correcao)

-------------------------------------------------------------------------------
if @ic_parametro = 1  -- lista o cabeçalho da carta de correção p/ Nota Fiscal
-------------------------------------------------------------------------------
begin

  -- Criação de Tabela Temporária que irá guardar os dados do destinatário
  -- 1	Cliente
	-- 2	Fornecedor
	-- 3	Vendedor
	-- 4	Transportadora
	-- 5	Representante
	-- 6	Funcionário
	-- 7	Outros

  select 
    @cd_tipo_destinatario = cd_tipo_destinatario 
  from
    Nota_Saida with (nolock) 
  where
    cd_nota_saida = @cd_nota_saida

  if IsNull(@cd_tipo_destinatario,1) in(1, 2, 3, 4, 6)
    select distinct

      cc.cd_carta_correcao			    as 'CartaCorrecao',
      cc.dt_carta_correcao			    as 'Emissao',
      cc.ic_lista_carta_correcao	            as 'Listada',
      cc.nm_obs_carta_correcao	                    as 'Observacao',
      ns.cd_mascara_operacao			    as 'CFOP',
      op.nm_operacao_fiscal			    as 'DescCFOP',
      vw.cd_destinatario	                    as 'Codigo',

      ns.cd_nota_saida,

      case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
          ns.cd_identificacao_nota_saida
      else
          ns.cd_nota_saida                              
      end                                           as 'NotaSaida',

      case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
        ns.cd_identificacao_nota_saida
      else
        ns.cd_nota_saida
      end                                       as cd_identificacao_nota_saida,

--      cc.cd_nota_saida				    as 'NotaSaida',

      cc.cd_nota_entrada			    as 'NotaEntrada',

      case when isnull(cc.cd_nota_saida,0)>0 then
         --cc.cd_nota_saida
         case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
            ns.cd_identificacao_nota_saida
         else
            ns.cd_nota_saida                              
         end                           
      else
         cc.cd_nota_entrada
      end                                           as 'Nota',

      case when cc.cd_nota_saida is null 
        then (Select top 1 cd_rem from nota_entrada_registro ner 
              where ner.cd_nota_entrada = ne.cd_nota_entrada and
                    ner.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal and
                    ner.cd_fornecedor = ne.cd_fornecedor and
                    ner.cd_operacao_fiscal = ne.cd_operacao_fiscal) 
        else 
          0
      end	as 'cd_rem',
      IsNull(ns.dt_nota_saida, ne.dt_nota_entrada)          as 'EmissaoNotaFiscal',
      ns.cd_pedido_venda				    as 'PedidoVenda',
      vn.nm_vendedor				            as 'Vendedor',
      cast(vw.nm_fantasia as varchar(15))	            as 'Fantasia',   
      cast(vw.nm_razao_social as varchar(40))               as 'RazaoSocial',
      cast(vw.nm_razao_social_complemento as varchar(40))   as 'RazaoSocialC',
      cast(vw.nm_endereco as varchar(60))	            as 'Endereco',
      cast(vw.cd_numero_endereco as char(10))	            as 'NumEndereco',
      cast(vw.nm_complemento_endereco as varchar(30))       as 'ComplEndereco',
      cast(vw.nm_bairro as varchar(25))		            as 'Bairro',
      cast(ci.nm_cidade as varchar(60))		            as 'Cidade',
  	  cast(uf.sg_estado as char(2))		            as 'UF',
      cast(vw.cd_cep as char(9))			    as 'CEP',
      '(' + ltrim(rtrim(vw.cd_ddd)) + ')' + vw.cd_telefone  as 'Telefone',
      cast(vw.cd_cnpj as varchar(18))	                    as 'CNPJ',
      vw.cd_tipo_pessoa,
      cast(vw.cd_inscestadual as varchar(18))	            as 'InscEstadual',
      cc.cd_usuario,
      cc.dt_usuario,
	    cc.cd_fornecedor,
 	    cc.cd_serie_nota_fiscal,
      @sg_serie_nota_fiscal as sg_serie_nota_fiscal,
      cc.cd_usuario_carta,
      isnull(ns.cd_num_formulario_nota,0)               as cd_num_formulario_nota         

    from
      Nota_Saida ns          with (nolock) 
        left outer join
      Carta_Correcao cc      with (nolock) 
        on cc.cd_nota_saida = ns.cd_nota_saida
        left outer join
      Operacao_Fiscal op     with (nolock) 
        on ns.cd_operacao_fiscal = op.cd_operacao_fiscal
        left outer join
      vw_destinatario vw     with (nolock) 
        on ns.cd_cliente = vw.cd_destinatario and
           ns.cd_tipo_destinatario = vw.cd_tipo_destinatario
        left outer join
      Cidade ci              with (nolock) 
        on vw.cd_cidade = ci.cd_cidade and
           vw.cd_estado = ci.cd_estado and
           vw.cd_pais   = ci.cd_pais
        left outer join
      Estado uf              with (nolock) 
        on vw.cd_estado = uf.cd_estado and
           vw.cd_pais   = uf.cd_pais  
        left outer join
      Vendedor vn            with (nolock) 
        on ns.cd_vendedor = vn.cd_vendedor
        left outer join
      Nota_Entrada ne        with (nolock) 
        on ne.cd_nota_entrada      = cc.cd_nota_entrada and
           ne.cd_serie_nota_fiscal = cc.cd_serie_nota_fiscal and
           ne.cd_fornecedor        = cc.cd_fornecedor
    where
      ns.cd_nota_saida = @cd_nota_saida
    order by
      cc.cd_carta_correcao desc

	-- Representante (AGUARDANDO TABELA)
        --if @cd_tipo_destinatario = 5
          
	-- Outros (CARREGAR DA PRÓPRIA NF)

  if @cd_tipo_destinatario > 6
    select distinct
      cc.cd_carta_correcao			as 'CartaCorrecao',
      cc.dt_carta_correcao			as 'Emissao',
      cc.ic_lista_carta_correcao		as 'Listada',
      cc.nm_obs_carta_correcao			as 'Observacao',

      ns.cd_nota_saida,

--      cc.cd_nota_saida				as 'NotaSaida',

      case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
        ns.cd_identificacao_nota_saida
      else
        ns.cd_nota_saida                              
      end                                       as 'NotaSaida',

      case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
        ns.cd_identificacao_nota_saida
      else
        ns.cd_nota_saida
      end                                       as cd_identificacao_nota_saida,

      cc.cd_nota_entrada			as 'NotaEntrada',
      ns.dt_nota_saida				as 'EmissaoNotaFiscal',
      ns.cd_pedido_venda				as 'PedidoVenda',
	    ns.cd_mascara_operacao			as 'CFOP',
      op.nm_operacao_fiscal			as 'DescCFOP',
      ns.cd_cliente				as 'Codigo',
      vn.nm_vendedor				as 'Vendedor',
      0 as 'cd_rem',
      cast(ns.nm_fantasia_nota_saida as varchar(15))	as 'Fantasia',
      cast(ns.nm_razao_social_nota as varchar(40)) as 'RazaoSocial',
      cast(ns.nm_razao_social_c as varchar(40)) as 'RazaoSocialC',
      cast(ns.nm_endereco_nota_saida as varchar(60))	as 'Endereco',
      cast(ns.cd_numero_end_nota_saida as char(10))	as 'NumEndereco',
      cast(ns.nm_compl_endereco_nota as varchar(30))as 'ComplEndereco',
      cast(ns.nm_bairro_nota_saida as varchar(25))		as 'Bairro',
      cast(ns.nm_cidade_nota_saida as varchar(60))		as 'Cidade',
  	  cast(ns.sg_estado_nota_saida as char(2))		as 'UF',
      cast(ns.cd_cep_nota_saida as char(9))			as 'CEP',
      '('+ltrim(rtrim(ns.cd_ddd_nota_saida))+')'+ns.cd_telefone_nota_saida as 'Telefone',
      cast(ns.cd_cnpj_nota_saida as varchar(18))	as 'CNPJ',
      0 as cd_tipo_pessoa, 
      cast(ns.cd_inscest_nota_saida as varchar(18))	as 'InscEstadual',
      cc.cd_usuario,
      cc.dt_usuario,
	    cc.cd_fornecedor,
 	    cc.cd_serie_nota_fiscal,
      @sg_serie_nota_fiscal as sg_serie_nota_fiscal,
      isnull(ns.cd_num_formulario_nota,0)               as cd_num_formulario_nota,
         
      case when isnull(cc.cd_nota_saida,0)>0 then
         cc.cd_nota_saida
      else
         cc.cd_nota_entrada
      end                                           as 'Nota'


--select * from nota_saida

    from
      Nota_Saida ns      with (nolock) 
        left outer join
      Carta_Correcao cc  with (nolock) 
        on cc.cd_nota_saida = ns.cd_nota_saida
        left outer join
      Operacao_Fiscal op with (nolock) 
        on ns.cd_operacao_fiscal = op.cd_operacao_fiscal
        left outer join
      Vendedor vn        with (nolock) 
        on ns.cd_vendedor = vn.cd_vendedor
    where
      ns.cd_nota_saida = @cd_nota_saida
    order by
      cc.cd_carta_correcao desc

end

-------------------------------------------------------------------------------
else if @ic_parametro = 2  -- Consulta de Cartas de Correção no Período
-------------------------------------------------------------------------------
begin

  select
    cc.cd_carta_correcao		as 'CartaCorrecao',
    cc.dt_carta_correcao		as 'Emissao',
    sf.sg_serie_nota_fiscal as 'Serie',

    case when cc.cd_nota_saida is null 
         then 'Entrada' else 'Saída'
    end	as 'TipoNota',

    case when cc.cd_nota_saida is null 
      then (Select top 1 cd_rem from nota_entrada_registro ner 
            where ner.cd_nota_entrada = ne.cd_nota_entrada and
                  ner.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal and
                  ner.cd_fornecedor = ne.cd_fornecedor and
                  ner.cd_operacao_fiscal = ne.cd_operacao_fiscal) 
      else 
        0
    end	as 'cd_rem',

    case when cc.cd_nota_saida is null 
         then cc.cd_nota_entrada 
    else 
       --cc.cd_nota_saida 
      case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
          ns.cd_identificacao_nota_saida
      else
          ns.cd_nota_saida                              
      end                                           

    end                         as 'NotaFiscal',

    vd.nm_fantasia              as 'Destinatario',
    td.nm_tipo_destinatario     as 'Tipo_Destinatario',
    cc.nm_obs_carta_correcao	as 'Observacao', 

    ns.cd_nota_saida,

    case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
       ns.cd_identificacao_nota_saida
    else
       ns.cd_nota_saida
    end                                       as cd_identificacao_nota_saida,

    ns.cd_tipo_destinatario,
    cc.cd_tipo_destinatario,
    cc.cd_fornecedor,
    u.nm_fantasia_usuario,
    cc.cd_usuario_carta,
    isnull(ns.cd_num_formulario_nota,0)               as cd_num_formulario_nota,

    case when isnull(cc.cd_nota_saida,0)>0 then
       cc.cd_nota_saida
    else
       cc.cd_nota_entrada
    end                                           as 'Nota'
        

--select * from carta_correcao

  from
    Carta_Correcao cc with (nolock)
    left outer join
    Nota_Saida ns
      on ns.cd_nota_saida = cc.cd_nota_saida
      left outer join
    Nota_Entrada ne
      on  ne.cd_nota_entrada = cc.cd_nota_entrada and
          ne.cd_serie_nota_fiscal = cc.cd_serie_nota_fiscal and
          ne.cd_fornecedor = cc.cd_fornecedor and
          ne.cd_tipo_destinatario = isnull(cc.cd_tipo_destinatario,2)
      left outer join
    vw_destinatario_rapida vd
      on vd.cd_destinatario = isnull( cc.cd_fornecedor, (case when isnull(cc.cd_nota_saida,0) = 0
                                                              then ne.cd_fornecedor else ns.cd_cliente end)) and
         vd.cd_tipo_destinatario = isnull( cc.cd_tipo_destinatario, (case when isnull(cc.cd_nota_saida,0) = 0
                                                                          then ne.cd_tipo_destinatario else ns.cd_tipo_destinatario end))
      left outer join
    Serie_Nota_Fiscal sf
      on sf.cd_serie_nota_fiscal = isnull( cc.cd_serie_nota_fiscal, ne.cd_serie_nota_fiscal)
      left outer join
    Tipo_destinatario td
      on td.cd_tipo_destinatario = vd.cd_tipo_destinatario
    left outer join egisadmin.dbo.Usuario u on u.cd_usuario = cc.cd_usuario_carta
  where
    ((cc.dt_carta_correcao between @dt_inicial and @dt_final) and IsNull(@cd_carta_correcao,0) = 0) or
    ((cc.cd_carta_correcao = @cd_carta_correcao) and (IsNull(@cd_carta_correcao,0) <> 0))
  order by
    cc.cd_carta_correcao desc

end                    
-------------------------------------------------------------------------------
else if @ic_parametro = 3  -- Listagem dos item de uma Carta de Correção
-------------------------------------------------------------------------------
begin

  select
    Carta_Correcao_Item.cd_carta_correcao            as 'CartaCorrecao',
    Carta_Correcao_Item.cd_item_carta_correcao       as 'Item',
    Carta_Correcao_Item.cd_irregularidade_fiscal     as 'Irregularidade',
    Carta_Correcao_Item.cd_tipo_irregularidade_fi    as 'Tipo',
    Carta_Correcao_Item.vl_icms_carta_correcao       as 'ICMS',
    Carta_Correcao_Item.vl_ipi_carta_correcao        as 'IPI',
    Carta_Correcao_Item.vl_iss_carta_correcao	     as 'ISS', 
    Carta_Correcao_Item.nm_informacao_correta	     as 'Correcao',
    Carta_Correcao.nm_obs_carta_correcao	     as 'Observacao',
    Carta_Correcao_Item.cd_usuario,
    Carta_Correcao_Item.dt_usuario,
    Carta_Correcao.cd_tipo_destinatario
  from
    Carta_Correcao_Item, Carta_Correcao
  where
    Carta_Correcao_Item.cd_carta_correcao = Carta_Correcao.cd_carta_correcao and
    Carta_Correcao_Item.cd_carta_correcao = @cd_carta_correcao 
  order by
    Carta_Correcao_Item.cd_item_carta_correcao
     
end
-------------------------------------------------------------------------------
else if @ic_parametro = 4 -- Lista o Cabeçalho p/ Carta de Correção
-------------------------------------------------------------------------------
begin

  -- Criação de Tabela Temporária que irá guardar os dados do destinatário
  -- 1 Cliente
	-- 2 Fornecedor
	-- 3 Vendedor
	-- 4 Transportadora
	-- 5 Representante
	-- 6 Funcionário
	-- 7 Outros

  select top 1
    @cd_tipo_destinatario = isnull(ns.cd_tipo_destinatario,1), 
    @cd_destinatario      = isnull(ns.cd_cliente, 0)
  from 
    Carta_Correcao cc             with (nolock) 
    left outer join Nota_Saida ns with (nolock) on cc.cd_nota_saida = ns.cd_nota_saida
  where cc.cd_carta_correcao = ( case when IsNull(@cd_carta_correcao,0) = 0 then
                                   cc.cd_carta_correcao else @cd_carta_correcao end )

  if isNull(@cd_tipo_destinatario,1) in(1, 2, 3, 4, 6)
    select
      cc.cd_carta_correcao			as 'CartaCorrecao',
      cc.dt_carta_correcao			as 'Emissao',
      cc.ic_lista_carta_correcao		as 'Listada',
      cc.nm_obs_carta_correcao			as 'Observacao',
      ns.cd_mascara_operacao			as 'CFOP',
      op.nm_operacao_fiscal			as 'DescCFOP',
      vw.cd_destinatario			as 'Codigo',

      ns.cd_nota_saida,

--      cc.cd_nota_saida   			as 'NotaSaida',

      case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
        ns.cd_identificacao_nota_saida
      else
        ns.cd_nota_saida
      end                                       as cd_identificacao_nota_saida,


      case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
          ns.cd_identificacao_nota_saida
      else
          ns.cd_nota_saida                              
      end                                               as 'NotaSaida',

      cc.cd_nota_entrada				as 'NotaEntrada',
      0                      	as 'cd_rem', --Nota de Saída não tem
      ns.dt_nota_saida				as 'EmissaoNotaFiscal',
      ns.cd_pedido_venda				as 'PedidoVenda',
      vn.nm_vendedor				as 'Vendedor',
      cast(vw.nm_fantasia as varchar(15))	      as 'Fantasia',
      cast(vw.nm_razao_social as varchar(40))   as 'RazaoSocial',
      cast(vw.nm_razao_social_complemento as varchar(40)) as 'RazaoSocialC',
      cast(vw.nm_endereco as varchar(60))	      as 'Endereco',
      cast(vw.cd_numero_endereco as char(10))	          as 'NumEndereco',
      cast(vw.nm_complemento_endereco as varchar(30))   as 'ComplEndereco',
      cast(vw.nm_bairro as varchar(25))		as 'Bairro',
      cast(ci.nm_cidade as varchar(60))		as 'Cidade',
  	  cast(uf.sg_estado as char(2))		    as 'UF',
      cast(vw.cd_cep as char(9))			    as 'CEP',
      '('+ltrim(rtrim(vw.cd_ddd))+')'+vw.cd_telefone as 'Telefone',
      cast(vw.cd_cnpj as varchar(18))	as 'CNPJ',
      vw.cd_tipo_pessoa,
      cast(vw.cd_inscestadual as varchar(18))	as 'InscEstadual',
      cc.cd_usuario,
      cc.dt_usuario,
      cc.cd_fornecedor,
      cc.cd_serie_nota_fiscal,
      cc.cd_tipo_destinatario,
      @sg_serie_nota_fiscal as sg_serie_nota_fiscal,
      cc.cd_usuario_carta,
      isnull(ns.cd_num_formulario_nota,0)               as cd_num_formulario_nota,
      case when isnull(cc.cd_nota_saida,0)>0 then
         cc.cd_nota_saida
      else
         cc.cd_nota_entrada
      end                                           as 'Nota'
         

    from
      Carta_Correcao cc with (nolock)
        left outer join
      Nota_Saida ns    with (nolock) 
        on cc.cd_nota_saida = ns.cd_nota_saida
        left outer join
      Operacao_Fiscal op with (nolock) 
        on ns.cd_operacao_fiscal = op.cd_operacao_fiscal
        left outer join
      vw_destinatario vw with (nolock) 
        on ns.cd_cliente = vw.cd_destinatario and
           ns.cd_tipo_destinatario = vw.cd_tipo_destinatario
        left outer join
      Cidade ci
        on vw.cd_cidade = ci.cd_cidade and
           vw.cd_estado = ci.cd_estado and
           vw.cd_pais   = ci.cd_pais
        left outer join
      Estado uf
        on vw.cd_estado = uf.cd_estado and
           vw.cd_pais   = uf.cd_pais  
        left outer join
      Vendedor vn
        on ns.cd_vendedor = vn.cd_vendedor
    where
      cc.cd_carta_correcao = @cd_carta_correcao

	-- Representante (AGUARDANDO TABELA)
    --if @cd_tipo_destinatario = 5
         
	-- Outros (CARREGAR DA PRÓPRIA NF)

  if isNull(@cd_tipo_destinatario,0) > 6
    select
      cc.cd_carta_correcao			as 'CartaCorrecao',
      cc.dt_carta_correcao			as 'Emissao',
      cc.ic_lista_carta_correcao		as 'Listada',
      cc.nm_obs_carta_correcao			as 'Observacao',

--      cc.cd_nota_saida				as 'NotaSaida',

--       case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
--           ns.cd_identificacao_nota_saida
--       else
--           ns.cd_nota_saida                              
--       end                                               as 'NotaSaida',

      case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
          ns.cd_identificacao_nota_saida
      else
          ns.cd_nota_saida                              
      end                                           as 'NotaSaida',

      cc.cd_nota_entrada				as 'NotaEntrada',
      ns.dt_nota_saida				as 'EmissaoNotaFiscal',
      ns.cd_pedido_venda				as 'PedidoVenda',
	    ns.cd_mascara_operacao			as 'CFOP',
      op.nm_operacao_fiscal			as 'DescCFOP',
      ns.cd_cliente				as 'Codigo',
      vn.nm_vendedor				as 'Vendedor',
      0 as 'cd_rem',
      cast(ns.nm_fantasia_nota_saida as varchar(15))	as 'Fantasia',
      cast(ns.nm_razao_social_nota as varchar(40)) as 'RazaoSocial',
      cast(ns.nm_razao_social_c as varchar(40)) as 'RazaoSocialC',
      cast(ns.nm_endereco_nota_saida as varchar(60))	as 'Endereco',
      cast(ns.cd_numero_end_nota_saida as char(10))	as 'NumEndereco',
      cast(ns.nm_compl_endereco_nota as varchar(30))as 'ComplEndereco',
      cast(ns.nm_bairro_nota_saida as varchar(25))		as 'Bairro',
      cast(ns.nm_cidade_nota_saida as varchar(60))		as 'Cidade',
  	  cast(ns.sg_estado_nota_saida as char(2))		as 'UF',
      cast(ns.cd_cep_nota_saida as char(9))			as 'CEP',
      '('+ltrim(rtrim(ns.cd_ddd_nota_saida))+')'+ns.cd_telefone_nota_saida as 'Telefone',
      cast(ns.cd_cnpj_nota_saida as varchar(18))	as 'CNPJ',
      0 as cd_tipo_pessoa,
      cast(ns.cd_inscest_nota_saida as varchar(18))	as 'InscEstadual',
      cc.cd_usuario,
      cc.dt_usuario,
      cc.cd_fornecedor,
      cc.cd_serie_nota_fiscal,
      cc.cd_tipo_destinatario,
      @sg_serie_nota_fiscal as sg_serie_nota_fiscal,
      cc.cd_usuario_carta,
      isnull(ns.cd_num_formulario_nota,0)               as cd_num_formulario_nota         

    from
      Carta_Correcao cc                  with (nolock) 
      left outer join Nota_Saida ns      with (nolock) on cc.cd_nota_saida      = ns.cd_nota_saida
      left outer join Operacao_Fiscal op with (nolock) on ns.cd_operacao_fiscal = op.cd_operacao_fiscal
      left outer join Vendedor vn        with (nolock) on ns.cd_vendedor        = vn.cd_vendedor
    where
      cc.cd_carta_correcao = @cd_carta_correcao

end
-------------------------------------------------------------------------------
else if @ic_parametro = 6  -- Atualiza o status de Listado na Carta de Correção
-------------------------------------------------------------------------------
  begin

    begin tran

    update
      Carta_Correcao
    set
      ic_lista_carta_correcao = 'S'
    where
      cd_carta_correcao = @cd_carta_correcao

    if @@error = 0
      commit tran
    else
      rollback tran
      
  end
-------------------------------------------------------------------------------
else if @ic_parametro = 7  -- Carta de Correção para Nota de Entrada.
-------------------------------------------------------------------------------
begin

  select distinct
    cc.cd_carta_correcao			as 'CartaCorrecao',
    cc.dt_carta_correcao			as 'Emissao',
    cc.ic_lista_carta_correcao       		as 'Listada',
    cc.nm_obs_carta_correcao			as 'Observacao',

    case when isnull(cc.cd_nota_saida,0)>0 then
       cc.cd_nota_saida	
    else
      cc.cd_nota_entrada				
    end                                         as 'Nota',
    
    case when isnull(cc.cd_nota_saida,0)>0 then
       cc.cd_nota_saida	
    else
      cc.cd_nota_entrada				
    end                                         as 'cd_identificacao_nota_saida',

    cc.cd_nota_saida,
    cc.cd_nota_saida				as 'NotaSaida',

--       case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
--           ns.cd_identificacao_nota_saida
--       else
--           ns.cd_nota_saida                              
--       end                                               as 'NotaSaida',

    cc.cd_nota_entrada				as 'NotaEntrada',
    ns.dt_nota_entrada				as 'EmissaoNotaFiscal',
    0						as 'PedidoVenda',
    op.cd_mascara_operacao			as 'CFOP',
    op.nm_operacao_fiscal			as 'DescCFOP',
    ns.cd_fornecedor				as 'Codigo',
    ''						as 'Vendedor',
    cast(vd.nm_fantasia as varchar(15))                 as 'Fantasia',
    cast(vd.nm_razao_social as varchar(40))             as 'RazaoSocial',
    cast(vd.nm_razao_social_complemento as varchar(40)) as 'RazaoSocialC',
    cast(vd.nm_endereco as varchar(60))                 as 'Endereco',
    cast(vd.cd_numero_endereco as char(10))             as 'NumEndereco',
    cast(vd.nm_complemento_endereco as varchar(30))     as 'ComplEndereco',
    cast(vd.nm_bairro as varchar(25))                   as 'Bairro',
    cast(ci.nm_cidade as varchar(60))		as 'Cidade',
    cast(uf.sg_estado as char(2))		as 'UF',
    cast(vd.cd_cep as char(9))			as 'CEP',
    cast('('+ltrim(rtrim(cast(vd.cd_ddd as varchar(3))))+')'+vd.cd_telefone as varchar(21)) as 'Telefone',
    cast(vd.cd_cnpj as varchar(18))	as 'CNPJ',
    vd.cd_tipo_pessoa,
    cast(vd.cd_inscestadual as varchar(18))	as 'InscEstadual',
    cc.cd_usuario,
    cc.dt_usuario,
    cc.cd_fornecedor,
 	  cc.cd_serie_nota_fiscal,
    sf.sg_serie_nota_fiscal,
    cc.cd_tipo_destinatario,

    ( Select top 1 cd_rem 
      from nota_entrada_registro ner with (nolock) 
      where ner.cd_nota_entrada      = ns.cd_nota_entrada and
            ner.cd_serie_nota_fiscal = ns.cd_serie_nota_fiscal and
            ner.cd_fornecedor        = ns.cd_fornecedor and
            ner.cd_operacao_fiscal   = ns.cd_operacao_fiscal) as 'cd_rem',
            cc.cd_usuario_carta,
            isnull(0,0)                                       as cd_num_formulario_nota         
    

  from
    Nota_Entrada ns with (nolock) 
      left outer join
    Carta_Correcao cc
      on cc.cd_nota_entrada = ns.cd_nota_entrada and
         cc.cd_serie_nota_fiscal = ns.cd_serie_nota_fiscal and
         cc.cd_fornecedor = ns.cd_fornecedor
	    left outer join
	  Serie_Nota_Fiscal sf
	    on sf.cd_serie_nota_fiscal = cc.cd_serie_nota_fiscal
      left outer join
    Operacao_Fiscal op
      on ns.cd_operacao_fiscal = op.cd_operacao_fiscal
      left outer join
    vw_destinatario vd
      on vd.cd_destinatario = ns.cd_fornecedor and
         vd.cd_tipo_destinatario = cc.cd_tipo_destinatario
      left outer join
    Cidade ci
      on vd.cd_cidade = ci.cd_cidade and
         vd.cd_estado = ci.cd_estado and
         vd.cd_pais   = ci.cd_pais
      left outer join
    Estado uf
      on vd.cd_estado = uf.cd_estado and
         vd.cd_pais   = uf.cd_pais  
  where
	  cc.cd_carta_correcao = @cd_carta_correcao
--            ns.cd_nota_entrada = @cd_nota_entrada and
--            ns.cd_serie_nota_fiscal = @cd_serie_nota_fiscal and
--            ns.cd_fornecedor = @cd_fornecedor
  order by
    cc.cd_carta_correcao desc

end
else
  return
