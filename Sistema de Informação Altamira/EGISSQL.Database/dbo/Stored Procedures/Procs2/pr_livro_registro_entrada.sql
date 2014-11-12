
CREATE PROCEDURE pr_livro_registro_entrada
------------------------------------------------------------------------------------------------------------------ 
--GBS - Global Business Solution                2002 
------------------------------------------------------------------------------------------------------------------ 
--Stored Procedure : Microsoft SQL Server       2000 
--Autor(es) : Daniel C. Neto / Elias Pereira
--Banco de Dados : EGISSQL 
--Objetivo : Consulta de Livro de Entrada
--Data : 31/10/2002 
--Atualização: 05/11/2002 - Elias/Daniel
--             12/11/2002 - Elias
--             25/11/2002 - Tirar do Nota_Entrada_Item_Registro - Daniel C. Neto.
--             15/10/2003 - Acertos Gerais - ELIAS
--             20/10/2003 - Acertos Gerais - ELIAS
--             27/10/2003 - Acerto na listagem do campo de Observações - ELIAS
--             04/11/2003 - Acerto p/ Listagem correta quando NFE é somente Complemento - ELIAS
--             05/11/2003 - Incluído Filtro p/ somente CFOPs de Entrada - ELIAS
--             10/11/2003 - Acerto na listagem de Isentas de IPI - ELIAS
--                          Acerto da forma como era buscado os valores de Outras - ELIAS
--             12/11/2003 - Acerto na listagem de Outras de IPI - ELIAS
--             14/11/2003 - Implementação do Resumo por CFOP - ELIAS 
--                        - Acerto na Listagem de Outras de IPI - ELIAS
--             17/11/2003 - Implementação do Resumo por UF - ELIAS
--                          Incluído campo de grupo p/ Sub-Totais em Resumo por CFOP - ELIAS
--             18/11/2003 - Implementação da Consulta do Livro utilizado p/SLF (Diferente da do livro) - ELIAS
--             01/12/2003 - Aumentado tamanho do campo Chave para comportar um campo de número de NF com 10 dígitos - ELIAS
--             02/12/2003 - Acerto na Listagem de Emitentes para ter o mesmo filtro do livro - ELIAS
--             05/01/2004 - Filtro para buscar apenas as CFOP de Saída - ELIAS
--             06.01.2004 - Correção da forma que a tabela #Nota_CFOP estava sendo gerada devido ao 
--                          problema de collation
--             15/03/2004 - Acerto no agrupamento dos valores do IPI no Livro - ELIAS
--             18/03/2004 - Acerto do Group By o campo cd_operacao_fiscal e a Chave para diferença da CFOP 
--             12/07/2004 - Busca o Valor do IPI Obs mesmo quando não haver mais nenhum outro valor de IPI
--                          indicado no Registro (Caso de NF Complemento) - ELIAS
--             20/09/2004 - Incluído Cálculo de Diferença do ICMS no Livro e Resumo CFOP somente de Consulta (5 e 6) - ELIAS
--             10/11/2004 - Acerto de Erro de Arredondamento entre as comparações de Valores na Montagem do Livro para Impressão,
--                          Parâmetro 1 - ELIAS
--             17/01/2005 - Comentado filtro de Prestação de Serviço, devido a visualização de NFE de Serviço no Livro de Entradas 
--                          a partir de 01/01/2005 - ELIAS 17/01/2005
--             06/09/2005 - Ajuste na Listagem do Valor da BC do IPI mesmo se não haver imposto. Desde que informado no livro
--                          pelo usuário do Depto. Fiscal - ELIAS
--             10/07/2006 - Ajuste na Listagem do Valor da BC do IPI, quando repetido numa mesma NFE com Alíquotas de ICMS Diferentes - ELIAS
--                          Ajuste do Resumo por CFOP que devido erro acima estava agrupando incorretamente - ELIAS
--             06/11/2006 - Ajuste no arredondamento das informações para listagem de resumo p/ estado - Fabio Cesar
--             09/02/2007 - Colocando o livro de Entrada na Ordem, DATA, NOTA, CFOP ( carlos mandou TMBevo ) - Anderson
--             22.03.2007 - Verificado resumo - carlos fernandes
--             24.04.2007 - Resumo de Entradas por CFOP - Carlos Fernandes
-- 14.07.2008 - Ajuste na emissão do Livro (Notas de Clientes) - Carlos Fernandes
-- 07.07.2009 - Ajuste das Notas de Entrada geradas no Faturamento que são digitadas no Controle de Recebimento - Carlos Fernandes
-- 13.02.2010 - Verificação - Carlos Fernandes
-- 01.11.2010 - Número da Nota de Saída - Carlos Fernandes
--------------------------------------------------------------------------------------------------------------------------------------- 
 
@ic_parametro int,
@dt_inicial   datetime,
@dt_final     datetime

AS


declare @ic_tipo_emitente_livro      char(1)
declare @ic_nf_entrada_livro_entrada char(1)

select
  @ic_tipo_emitente_livro      = isnull(ic_tipo_emitente_livro,'1'),
  @ic_nf_entrada_livro_entrada = isnull(ic_nf_entrada_livro_entrada,'S')

from
  parametro_fiscal with (nolock) 

where
  cd_empresa = dbo.fn_empresa()


-------------------------------------------------------------------------------
if @ic_parametro = 1   -- Listagem do Livro de Entradas  -- FORMA 2
-------------------------------------------------------------------------------
  begin

    -- DADOS DO EMITENTE/FAVORECIDO

    select
      cast(ni.dt_receb_nota_entrada as char(11)) +
      --cast(ni.nm_serie_nota_entrada	as char(6)) +
      cast(ni.sg_serie_nota_fiscal as char(6)) +
      cast(ni.cd_nota_entrada as char(10)) +
      cast(ni.cd_mascara_operacao as char(6)) +
      cast(ni.dt_nota_entrada as char(11)) +
      cast(ni.cd_destinatario as char(6)) +
      cast(ni.cd_tipo_destinatario as char(1)) +
      cast(ni.sg_estado as char(2)) + 
      cast(op.cd_operacao_fiscal as char(10))  as 'Chave',
      ni.dt_receb_nota_entrada                 as 'Entrada',
      n.nm_especie_nota_entrada                as 'SubSerie',
      ni.sg_serie_nota_fiscal                  as 'Especie',
      ni.cd_nota_entrada                       as 'Numero',
      ni.dt_nota_entrada                       as 'Data',

      case when @ic_tipo_emitente_livro='1' then
        
        ( select top 1 substring(replace(f.cd_cnpj,'.',''),1,8) from vw_destinatario f 
          where
            ni.cd_destinatario      = f.cd_destinatario and
            ni.cd_tipo_destinatario = f.cd_tipo_destinatario )  
      else
      cast(ni.cd_destinatario as varchar(6)) + '/' +
        cast(ni.cd_tipo_destinatario as char(1)) 
      end                                              as 'Emitente',


--       cast(ni.cd_destinatario as varchar(6)) + '/' +
--         cast(ni.cd_tipo_destinatario as char(1)) 
--                                                as 'Emitente',
      ni.cd_tipo_destinatario                  as 'TipoEmitente',
      ni.sg_estado                             as 'UF',
      max(ni.cd_rem)			       as 'REM'

    into
      #Nota_Entrada_Emitente

    from
      Nota_Entrada_Item_Registro ni with (nolock) 
    inner join
      Nota_Entrada n                with (nolock)   
    on
      n.cd_nota_entrada      = ni.cd_nota_entrada    and
      n.cd_fornecedor        = ni.cd_fornecedor      and
      n.cd_operacao_fiscal   = ni.cd_operacao_fiscal and
      n.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal
    left outer join Operacao_fiscal op        with (nolock) on op.cd_operacao_fiscal        = ni.cd_operacao_fiscal
    left outer join Grupo_Operacao_Fiscal gop with (nolock) on gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      n.dt_receb_nota_entrada between @dt_inicial and @dt_final and  -- ELIAS 10/11/2003
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
    group by
      ni.dt_receb_nota_entrada,
      op.cd_operacao_fiscal,
      ni.cd_mascara_operacao,
--      ni.nm_serie_nota_entrada,
      n.nm_especie_nota_entrada,
      ni.sg_serie_nota_fiscal,
      ni.cd_nota_entrada,
      ni.dt_nota_entrada,
      ni.cd_destinatario,
      ni.cd_tipo_destinatario,
      ni.sg_estado,
      --ni.cd_rem,
      op.ic_servico_operacao

    union all

    select
      cast(ni.dt_nota_saida as char(11)) +
      --cast(ni.nm_serie_nota_entrada	as char(6)) +
      cast(sn.sg_serie_nota_fiscal as char(6)) +
      cast(ni.cd_nota_saida        as char(10)) +
      cast(ni.cd_mascara_operacao  as char(6)) +
      cast(ni.dt_nota_saida as char(11)) +
      cast(n.cd_cliente as char(6)) +
      cast(n.cd_tipo_destinatario as char(1)) +
      cast(ni.sg_estado as char(2)) + 
      cast(op.cd_operacao_fiscal as char(10))     as 'Chave',
      ni.dt_nota_saida                            as 'Entrada',
      cast(sn.cd_modelo_serie_nota as varchar(2)) as 'SubSerie',
      sn.sg_serie_nota_fiscal                     as 'Especie',

      max(case when isnull(n.cd_identificacao_nota_saida,0)>0 then
        n.cd_identificacao_nota_saida
      else
        ni.cd_nota_saida 
      end)                                        as 'Numero',

      ni.dt_nota_saida                            as 'Data',

      case when @ic_tipo_emitente_livro='1' then
        
        ( select top 1 substring(replace(f.cd_cnpj,'.',''),1,8) from vw_destinatario f 
          where
            n.cd_cliente           = f.cd_destinatario and
            n.cd_tipo_destinatario = f.cd_tipo_destinatario )  
      else
      cast(n.cd_cliente as varchar(6)) + '/' +
        cast(n.cd_tipo_destinatario as char(1)) 
      end                                              as 'Emitente',


--       cast(ni.cd_destinatario as varchar(6)) + '/' +
--         cast(ni.cd_tipo_destinatario as char(1)) 
--                                                as 'Emitente',
      n.cd_tipo_destinatario                  as 'TipoEmitente',
      ni.sg_estado                             as 'UF',
      max(0)	                               as 'REM'

    from
      Nota_Saida_Item_Registro ni with (nolock) 

--select * from nota_saida_item_registro

    inner join
      Nota_Saida n                            with (nolock) on n.cd_nota_saida        = ni.cd_nota_saida
    left outer join serie_nota_fiscal sn      with (nolock) on sn.cd_serie_nota_fiscal      = n.cd_serie_nota
    left outer join Operacao_fiscal op        with (nolock) on op.cd_operacao_fiscal        = case when isnull(ni.cd_operacao_fiscal,0)=0 then n.cd_operacao_fiscal else ni.cd_operacao_fiscal end
    left outer join Grupo_Operacao_Fiscal gop with (nolock) on gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal

    where
      n.dt_nota_saida between @dt_inicial and @dt_final and  -- ELIAS 10/11/2003
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
      and
      @ic_nf_entrada_livro_entrada = 'S'
 
    group by
      n.dt_nota_saida,
      op.cd_operacao_fiscal,
      ni.cd_mascara_operacao,
--      ni.nm_serie_nota_entrada,
      --sn.nm_especie_nota_entrada,
      sn.sg_serie_nota_fiscal,
      sn.cd_modelo_serie_nota,
      ni.cd_nota_saida,
      ni.dt_nota_saida,
      n.cd_cliente,
      n.cd_tipo_destinatario,
      ni.sg_estado,
      --ni.cd_rem,
      op.ic_servico_operacao

--select * from nota_saida_Item_registro
--select * from serie_nota_fiscal
--select * from fornecedor
--select * from vw_destinatario
--select * from nota_entrada


--   select * from #Nota_Entrada_Emitente order by Numero

    -- VALOR CONTÁBIL E CFOP

    select
      cast(ni.dt_receb_nota_entrada as char(11)) +
      --cast(ni.nm_serie_nota_entrada	as char(6)) +
      cast(ni.sg_serie_nota_fiscal as char(6)) +
      cast(ni.cd_nota_entrada as char(10)) +
      cast(ni.cd_mascara_operacao as char(6)) +
      cast(ni.dt_nota_entrada as char(11)) +
      cast(ni.cd_destinatario as char(6)) +
      cast(ni.cd_tipo_destinatario as char(1)) +
      cast(ni.sg_estado as char(2)) +
      cast(op.cd_operacao_fiscal as char(10))             as 'Chave',
      sum(round(isnull(ni.vl_cont_reg_nota_entrada,0),2)) as 'VlrContabil',
      ni.cd_mascara_operacao                              as 'ClassFiscal'
    into
      #Nota_Entrada_VlrContabil

    from
      Nota_Entrada_Item_Registro ni with (nolock)

    inner join
      Nota_Entrada ne               with (nolock)
    on
      ne.cd_nota_entrada      = ni.cd_nota_entrada and
      ne.cd_fornecedor        = ni.cd_fornecedor and
      ne.cd_operacao_fiscal   = ni.cd_operacao_fiscal and
      ne.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal
    left outer join
      Operacao_fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
    group by
      ni.dt_receb_nota_entrada,
      op.cd_operacao_fiscal,
      ni.cd_mascara_operacao,
--      ni.nm_serie_nota_entrada,
      ni.sg_serie_nota_fiscal,
      ni.cd_nota_entrada,
      ni.dt_nota_entrada,
      ni.cd_destinatario,
      ni.cd_tipo_destinatario,
      ni.sg_estado,
      ni.cd_mascara_operacao,
      op.ic_servico_operacao      

    union all

    select
      cast(ni.dt_nota_saida as char(11)) +
      --cast(ni.nm_serie_nota_entrada	as char(6)) +
      cast(sn.sg_serie_nota_fiscal as char(6)) +
      cast(ni.cd_nota_saida as char(10)) +
      cast(ni.cd_mascara_operacao as char(6)) +
      cast(ni.dt_nota_saida as char(11)) +
      cast(ne.cd_cliente as char(6)) +
      cast(ne.cd_tipo_destinatario as char(1)) +
      cast(ni.sg_estado as char(2)) +
      cast(op.cd_operacao_fiscal as char(10))             as 'Chave',
    

      --Carlos 05.07.2010-----------------------------------------------
      --Importação

      case when
           max(isnull(op.ic_imp_operacao_fiscal,'N')) = 'S' or max(isnull(op.ic_importacao_op_fiscal,'N')) = 'S' 
      then 
         max( round(ne.vl_total,2) )  
      else
         sum(round(isnull(ni.vl_contabil_item_nota,0),2))
      end                                                 as 'VlrContabil',
      

      ni.cd_mascara_operacao                              as 'ClassFiscal'

--select * from nota_saida_item_registro

    from
      Nota_Saida_Item_Registro ni with (nolock)

    inner join
      Nota_Saida ne               with (nolock)
    on
      ne.cd_nota_saida      = ni.cd_nota_saida
    left outer join serie_nota_fiscal sn on sn.cd_serie_nota_fiscal = ne.cd_serie_nota
    left outer join
      Operacao_fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ne.dt_nota_saida between @dt_inicial and @dt_final and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
      and
      @ic_nf_entrada_livro_entrada = 'S'

    group by
      ni.dt_nota_saida,
      op.cd_operacao_fiscal,
      ni.cd_mascara_operacao,
--      ni.nm_serie_nota_entrada,
      sn.sg_serie_nota_fiscal,
      ni.cd_nota_saida,
      ni.dt_nota_saida,
      ne.cd_cliente,
      ne.cd_tipo_destinatario,
      ni.sg_estado,
      ni.cd_mascara_operacao,
      op.ic_servico_operacao      

--   select * from       #Nota_Entrada_VlrContabil


 -- NOTAS COM ICMS (Operação 1)

    select
      cast(ni.dt_receb_nota_entrada as char(11)) +
      --cast(ni.nm_serie_nota_entrada	as char(6)) +
      cast(ni.sg_serie_nota_fiscal as char(6)) +
      cast(ni.cd_nota_entrada as char(10)) +
      cast(ni.cd_mascara_operacao as char(6)) +
      cast(ni.dt_nota_entrada as char(11)) +
      cast(ni.cd_destinatario as char(6)) +
      cast(ni.cd_tipo_destinatario as char(1)) +
      cast(ni.sg_estado as char(2)) +
      cast(op.cd_operacao_fiscal as char(10))     as 'Chave',
      1		   				  as 'CodOperICMS',
      sum(round(isnull(ni.vl_bicms_reg_nota_entrada,0),2)) as 'BCICMS',
      -- ELIAS 15/03/2004
      isnull(ni.pc_icms_reg_nota_entrada,0)                 as 'AliqICMS',
      sum(round(isnull(ni.vl_icms_reg_nota_entrada,0),2))  as 'ICMS',
      sum(round(isnull(ni.vl_icmsobs_reg_nota_entr,0),2))  as 'ICMSObs',
      max(isnull(ni.nm_obsicms_reg_nota_entr,op.nm_obs_livro_operacao)) as 'ObservacaoICMS'

    into
      #Nota_Entrada_ICMS

    from
      Nota_Entrada_Item_Registro ni with (nolock)

    inner join                      
      Nota_Entrada ne               with (nolock)
    on
      ne.cd_nota_entrada      = ni.cd_nota_entrada and
      ne.cd_fornecedor        = ni.cd_fornecedor and
      ne.cd_operacao_fiscal   = ni.cd_operacao_fiscal and
      ne.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
      (isnull(ni.vl_icms_reg_nota_entrada,0)<>0) and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
    group by
      ni.dt_receb_nota_entrada,
      op.cd_operacao_fiscal,
      ni.cd_mascara_operacao,
--      ni.nm_serie_nota_entrada,
      ni.sg_serie_nota_fiscal,
      ni.cd_nota_entrada,
      ni.dt_nota_entrada,
      ni.cd_destinatario,
      ni.cd_tipo_destinatario,
      ni.sg_estado,
      ni.cd_mascara_operacao,
      -- ELIAS 15/03/2004
      isnull(ni.pc_icms_reg_nota_entrada,0),
      op.ic_servico_operacao

    union all

    select
      cast(ni.dt_nota_saida as char(11)) +
      --cast(ni.nm_serie_nota_entrada	as char(6)) +
      cast(sn.sg_serie_nota_fiscal as char(6)) +
      cast(ni.cd_nota_saida as char(10)) +
      cast(ni.cd_mascara_operacao as char(6)) +
      cast(ni.dt_nota_saida as char(11)) +
      cast(ne.cd_cliente as char(6)) +
      cast(ne.cd_tipo_destinatario as char(1)) +
      cast(ni.sg_estado as char(2)) +
      cast(op.cd_operacao_fiscal as char(10))              as 'Chave',
      1		   				           as 'CodOperICMS',
      case when
           max(isnull(op.ic_imp_operacao_fiscal,'N')) = 'S' or max(isnull(op.ic_importacao_op_fiscal,'N')) = 'S' 
      then
           max(ne.vl_bc_icms)
      else
         sum(round(isnull(ni.vl_base_icms_item_nota,0),2)) 
      end                                                  as 'BCICMS',

      -- ELIAS 15/03/2004
      isnull(ni.pc_icms_item_nota_saida,0)                 as 'AliqICMS',
      sum(round(isnull(ni.vl_icms_item_nota_saida,0),2))   as 'ICMS',
      sum(round(isnull(ni.vl_icms_obs_item_nota,0),2))     as 'ICMSObs',
      max(op.nm_obs_livro_operacao)                        as 'ObservacaoICMS'

--select * from nota_saida_item_registro

    from
      Nota_Saida_Item_Registro ni with (nolock)

    inner join                      
      Nota_Saida ne               with (nolock)
    on
      ne.cd_nota_saida      = ni.cd_nota_saida
    left outer join serie_nota_fiscal sn on sn.cd_serie_nota_fiscal = ne.cd_serie_nota
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ne.dt_nota_saida between @dt_inicial and @dt_final and
      (isnull(ni.vl_base_icms_item_nota,0)<>0) and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
      and
      @ic_nf_entrada_livro_entrada = 'S'

    group by
      ni.dt_nota_saida,
      op.cd_operacao_fiscal,
      ni.cd_mascara_operacao,
--      ni.nm_serie_nota_entrada,
      sn.sg_serie_nota_fiscal,
      ni.cd_nota_saida,
      ni.dt_nota_saida,
      ne.cd_cliente,
      ne.cd_tipo_destinatario,
      ni.sg_estado,
      ni.cd_mascara_operacao,
      -- ELIAS 15/03/2004
      isnull(ni.pc_icms_item_nota_saida,0),
      op.ic_servico_operacao

    -- NOTAS COM IPI (Operacao 1)

    select
      cast(ni.dt_receb_nota_entrada as char(11)) +
      --cast(ni.nm_serie_nota_entrada	as char(6)) +
      cast(ni.sg_serie_nota_fiscal  as char(6)) +
      cast(ni.cd_nota_entrada       as char(10)) +
      cast(ni.cd_mascara_operacao   as char(6)) +
      cast(ni.dt_nota_entrada       as char(11)) +
      cast(ni.cd_destinatario       as char(6)) +
      cast(ni.cd_tipo_destinatario  as char(1)) +
      cast(ni.sg_estado             as char(2)) +
      cast(op.cd_operacao_fiscal    as char(10))                       as 'Chave',
      1				   	  	                       as 'CodOperIPI',
      sum(round(isnull(ni.vl_bipi_reg_nota_entrada,0),2))              as 'BCIPI',
      sum(round(isnull(ni.vl_ipi_reg_nota_entrada,0),2))               as 'IPI',
      sum(round(isnull(ni.vl_ipiobs_reg_nota_entr,0),2))               as 'IPIObs',

      -- 15/03/2004
      max(isnull(ni.nm_obsipi_reg_nota_entr,op.nm_obs_livro_operacao)) as 'ObservacaoIPI',
      max(isnull(ni.pc_icms_reg_nota_entrada,0))                       as 'AliqICMS'

    into
      #Nota_Entrada_IPI

    from
      Nota_Entrada_Item_Registro ni with (nolock)
    inner join
      Nota_Entrada ne               with (nolock)
    on
      ne.cd_nota_entrada      = ni.cd_nota_entrada and
      ne.cd_fornecedor        = ni.cd_fornecedor and
      ne.cd_operacao_fiscal   = ni.cd_operacao_fiscal and
      ne.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
      -- ELIAS 06/09/2005
      ((isnull(ni.vl_ipi_reg_nota_entrada,0)<>0) or 
       (isnull(ni.vl_bipi_reg_nota_entrada,0)<>0))  and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
    group by
      ni.dt_receb_nota_entrada,
      op.cd_operacao_fiscal,
      ni.cd_mascara_operacao,
--      ni.nm_serie_nota_entrada,
      ni.sg_serie_nota_fiscal,
      ni.cd_nota_entrada,
      ni.dt_nota_entrada,
      ni.cd_destinatario,
      ni.cd_tipo_destinatario,
      ni.sg_estado,
      ni.cd_mascara_operacao,
      op.ic_servico_operacao

    union all

    select
      cast(ni.dt_nota_saida        as char(11)) +
      --cast(ni.nm_serie_nota_entrada	as char(6)) +
      cast(sn.sg_serie_nota_fiscal as char(6)) +
      cast(ni.cd_nota_saida        as char(10)) +
      cast(ni.cd_mascara_operacao  as char(6)) +
      cast(ni.dt_nota_saida as char(11)) +
      cast(ne.cd_cliente as char(6)) +
      cast(ne.cd_tipo_destinatario as char(1)) +
      cast(ni.sg_estado as char(2)) +
      cast(op.cd_operacao_fiscal as char(10))                           as 'Chave',
      1				   	  	                        as 'CodOperIPI',
      sum(round(isnull(ni.vl_base_ipi_item_nota,0),2))                  as 'BCIPI',

--       case when
--            max(isnull(op.ic_imp_operacao_fiscal,'N')) = 'S' or max(isnull(op.ic_importacao_op_fiscal,'N')) = 'S' 
--       then
--            max(ne.vl_bc_icms)
--       else
--           sum(round(isnull(ni.vl_base_ipi_item_nota,0),2))                
--       end   as 'BCIPI',

      sum(round(isnull(ni.vl_ipi_item_nota_saida,0),2))                 as 'IPI',
      sum(round(isnull(ni.vl_ipi_obs_item_nota,0),2))                   as 'IPIObs',
      -- 15/03/2004
      max(op.nm_obs_livro_operacao)                                     as 'ObservacaoIPI',
      max(isnull(ni.pc_icms_item_nota_saida,0))                         as 'AliqICMS'

--select * from nota_saida_item_registro

    from
      Nota_Saida_Item_Registro ni with (nolock)
    inner join
      Nota_Saida ne               with (nolock)
    on
      ne.cd_nota_saida      = ni.cd_nota_saida

    left outer join serie_nota_fiscal sn on sn.cd_serie_nota_fiscal = ne.cd_serie_nota
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ne.dt_nota_saida between @dt_inicial and @dt_final and
      -- ELIAS 06/09/2005
      ((isnull(ni.vl_ipi_item_nota_saida,0)<>0) or 
       (isnull(ni.vl_base_ipi_item_nota,0)<>0))  and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and

      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
      and
      @ic_nf_entrada_livro_entrada = 'S'

    group by
      ni.dt_nota_saida,
      op.cd_operacao_fiscal,
      ni.cd_mascara_operacao,
--      ni.nm_serie_nota_entrada,
      sn.sg_serie_nota_fiscal,
      ni.cd_nota_saida,
      ni.dt_nota_saida,
      ne.cd_cliente,
      ne.cd_tipo_destinatario,
      ni.sg_estado,
      ni.cd_mascara_operacao,
      op.ic_servico_operacao


    --select 1,* from #Nota_Entrada_IPI

    -- NOTAS COM ICMS - ISENTAS (Operacao 2)

    select
      distinct  -- ELIAS 10/11/2003
      cast(ni.dt_receb_nota_entrada as char(11)) +
      --cast(ni.nm_serie_nota_entrada	as char(6)) +
      cast(ni.sg_serie_nota_fiscal as char(6)) +
      cast(ni.cd_nota_entrada as char(10)) +
      cast(ni.cd_mascara_operacao as char(6)) +
      cast(ni.dt_nota_entrada as char(11)) +
      cast(ni.cd_destinatario as char(6)) +
      cast(ni.cd_tipo_destinatario as char(1)) +
      cast(ni.sg_estado as char(2)) +
      cast(op.cd_operacao_fiscal as char(10))              as 'Chave',
      2	                                                   as 'CodOperICMS',
      sum(round(isnull(ni.vl_icmsisen_reg_nota_entr,0),2)) as 'BCICMS',
      case when (isnull((select 
                         sum(icms.ICMSObs)
                       from
                         #Nota_Entrada_ICMS icms
                       where
                         icms.Chave = (cast(ni.dt_receb_nota_entrada as char(11)) +
                                       --cast(ni.nm_serie_nota_entrada as char(6)) +
                                       cast(ni.sg_serie_nota_fiscal as char(6)) +
                                       cast(ni.cd_nota_entrada as char(10)) +
                                       cast(ni.cd_mascara_operacao as char(6)) +
                                       cast(ni.dt_nota_entrada as char(11)) +
                                       cast(ni.cd_destinatario as char(6)) +
                                       cast(ni.cd_tipo_destinatario as char(1)) +
                                       cast(ni.sg_estado as char(2)) +
                                       cast(op.cd_operacao_fiscal as char(10)))),'') = '') then 
        max(round(isnull(ni.vl_icmsobs_reg_nota_entr,0),2)) 
      else 
        0 end as 'ICMSObs',
      case when (isnull((select 
                         top 1
                         icms.ObservacaoICMS
                       from
                         #Nota_Entrada_ICMS icms
                       where
                         icms.Chave = (cast(ni.dt_receb_nota_entrada as char(11)) +
                                       --cast(ni.nm_serie_nota_entrada as char(6)) +
                                       cast(ni.sg_serie_nota_fiscal as char(6)) +
                                       cast(ni.cd_nota_entrada as char(10)) +
                                       cast(ni.cd_mascara_operacao as char(6)) +
                                       cast(ni.dt_nota_entrada as char(11)) +
                                       cast(ni.cd_destinatario as char(6)) +
                                       cast(ni.cd_tipo_destinatario as char(1)) +
                                       cast(ni.sg_estado as char(2)) +
                                       cast(op.cd_operacao_fiscal as char(10)))),'') = '') then 
        max(isnull(ni.nm_obsicms_reg_nota_entr,op.nm_obs_livro_operacao)) 
      else 
        cast(null as varchar(50)) end as 'ObservacaoICMS'
    into
      #Nota_Entrada_ICMS_Isento

    from
      Nota_Entrada_Item_Registro ni with (nolock)

    inner join
      Nota_Entrada ne               with (nolock)
    on
      ne.cd_nota_entrada      = ni.cd_nota_entrada and
      ne.cd_fornecedor        = ni.cd_fornecedor and
      ne.cd_operacao_fiscal   = ni.cd_operacao_fiscal and
      ne.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
      (isnull(ni.vl_icmsisen_reg_nota_entr,0)<>0) and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
    group by
      ni.dt_receb_nota_entrada,
      op.cd_operacao_fiscal,
      ni.cd_mascara_operacao,
--      ni.nm_serie_nota_entrada,
      ni.sg_serie_nota_fiscal,
      ni.cd_nota_entrada,
      ni.dt_nota_entrada,
      ni.cd_destinatario,
      ni.cd_tipo_destinatario,
      ni.sg_estado,
      ni.cd_mascara_operacao,
      op.ic_servico_operacao

    union all

    select
      distinct  -- ELIAS 10/11/2003
      cast(ni.dt_nota_saida as char(11)) +
      --cast(ni.nm_serie_nota_entrada	as char(6)) +
      cast(sn.sg_serie_nota_fiscal as char(6)) +
      cast(ni.cd_nota_saida as char(10)) +
      cast(ni.cd_mascara_operacao as char(6)) +
      cast(ni.dt_nota_saida as char(11)) +
      cast(ne.cd_cliente as char(6)) +
      cast(ne.cd_tipo_destinatario as char(1)) +
      cast(ni.sg_estado as char(2)) +
      cast(op.cd_operacao_fiscal as char(10))              as 'Chave',
      2	                                                   as 'CodOperICMS',
      sum(round(isnull(ni.vl_icms_isento_item_nota,0),2))  as 'BCICMS',
      case when (isnull((select 
                         sum(icms.ICMSObs)
                       from
                         #Nota_Entrada_ICMS icms
                       where
                         icms.Chave = (cast(ni.dt_nota_saida as char(11)) +
                                       --cast(ni.nm_serie_nota_entrada as char(6)) +
                                       cast(sn.sg_serie_nota_fiscal as char(6)) +
                                       cast(ni.cd_nota_saida as char(10)) +
                                       cast(ni.cd_mascara_operacao as char(6)) +
                                       cast(ni.dt_nota_saida as char(11)) +
                                       cast(ne.cd_cliente as char(6)) +
                                       cast(ne.cd_tipo_destinatario as char(1)) +
                                       cast(ni.sg_estado as char(2)) +
                                       cast(op.cd_operacao_fiscal as char(10)))),'') = '') then 
        max(round(isnull(ni.vl_icms_obs_item_nota,0),2)) 
      else 
        0.00
      end as 'ICMSObs',
      case when (isnull((select 
                         top 1
                         icms.ObservacaoICMS
                       from
                         #Nota_Entrada_ICMS icms
                       where
                         icms.Chave = (cast(ni.dt_nota_saida as char(11)) +
                                       --cast(ni.nm_serie_nota_entrada as char(6)) +
                                       cast(sn.sg_serie_nota_fiscal as char(6)) +
                                       cast(ni.cd_nota_saida as char(10)) +
                                       cast(ni.cd_mascara_operacao as char(6)) +
                                       cast(ni.dt_nota_saida as char(11)) +
                                       cast(ne.cd_cliente as char(6)) +
                                       cast(ne.cd_tipo_destinatario as char(1)) +
                                       cast(ni.sg_estado as char(2)) +
                                       cast(op.cd_operacao_fiscal as char(10)))),'') = '') then 
        max(op.nm_obs_livro_operacao)
      else 
        cast('' as varchar(50)) 
      end                              as 'ObservacaoICMS'

--select * from nota_saida_item_registro

    from
      Nota_Saida_Item_Registro ni with (nolock)

    inner join Nota_Saida ne               with (nolock) on ne.cd_nota_saida = ni.cd_nota_saida
    left outer join serie_nota_fiscal sn on sn.cd_serie_nota_fiscal = ne.cd_serie_nota
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ne.dt_nota_saida between @dt_inicial and @dt_final and
      (isnull(ni.vl_icms_isento_item_nota,0)<>0) and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
      and
      @ic_nf_entrada_livro_entrada = 'S'

    group by
      ni.dt_nota_saida,
      op.cd_operacao_fiscal,
      ni.cd_mascara_operacao,
--      ni.nm_serie_nota_entrada,
      sn.sg_serie_nota_fiscal,
      ni.cd_nota_saida,
      ni.dt_nota_saida,
      ne.cd_cliente,
      ne.cd_tipo_destinatario,
      ni.sg_estado,
      ni.cd_mascara_operacao,
      op.ic_servico_operacao

    -- NOTAS COM IPI - ISENTAS (Operacao 2)

    select
      distinct  -- ELIAS 10/11/2003
      cast(ni.dt_receb_nota_entrada as char(11)) +
      --cast(ni.nm_serie_nota_entrada	as char(6)) +
      cast(ni.sg_serie_nota_fiscal as char(6)) +
      cast(ni.cd_nota_entrada as char(10)) +
      cast(ni.cd_mascara_operacao as char(6)) +
      cast(ni.dt_nota_entrada as char(11)) +
      cast(ni.cd_destinatario as char(6)) +
      cast(ni.cd_tipo_destinatario as char(1)) +
      cast(ni.sg_estado as char(2)) +
      cast(op.cd_operacao_fiscal as char(10))             as 'Chave',
      2	                                                  as 'CodOperIPI',
      sum(round(isnull(ni.vl_ipiisen_reg_nota_entr,0),2)) as 'BCIPI',
      -- 15/03/2004
      max(isnull(ni.pc_icms_reg_nota_entrada,0))          as 'AliqICMS',  -- ELIAS 10/11/2003

      case when (isnull((select 
                         sum(ipi.IPIObs)
                       from
                         #Nota_Entrada_IPI ipi
                       where
                         ipi.Chave = (cast(ni.dt_receb_nota_entrada as char(11)) +
                                      --cast(ni.nm_serie_nota_entrada as char(6)) +
                                      cast(ni.sg_serie_nota_fiscal as char(6)) +
                                      cast(ni.cd_nota_entrada as char(10)) +
                                      cast(ni.cd_mascara_operacao as char(6)) +
                                      cast(ni.dt_nota_entrada as char(11)) +
                                      cast(ni.cd_destinatario as char(6)) +
                                      cast(ni.cd_tipo_destinatario as char(1)) +
                                      cast(ni.sg_estado as char(2)) +
                                      cast(op.cd_operacao_fiscal as char(10)))),'') = '') then 
                                      -- 15/03/2004
                                      max(round(isnull(ni.vl_ipiobs_reg_nota_entr,0),2)) 
      else 
        0.00 end as 'IPIObs',

      case when (isnull((select 
                         top 1
                         ipi.ObservacaoIPI
                       from
                         #Nota_Entrada_IPI ipi
                       where
                         ipi.Chave = (cast(ni.dt_receb_nota_entrada as char(11)) +
                                      --cast(ni.nm_serie_nota_entrada as char(6)) +
                                      cast(ni.sg_serie_nota_fiscal as char(6)) +
                                      cast(ni.cd_nota_entrada as char(10)) +
                                      cast(ni.cd_mascara_operacao as char(6)) +
                                      cast(ni.dt_nota_entrada as char(11)) +
                                      cast(ni.cd_destinatario as char(6)) +
                                      cast(ni.cd_tipo_destinatario as char(1)) +
                                      cast(ni.sg_estado as char(2)) +
                                      cast(op.cd_operacao_fiscal as char(10)))),'') = '') then 
                                      -- 15/03/2004
                                      max(isnull(ni.nm_obsipi_reg_nota_entr,op.nm_obs_livro_operacao)) 
      else 
        cast(null as varchar(50)) end as 'ObservacaoIPI'
    into
      #Nota_Entrada_IPI_Isento

    from
      Nota_Entrada_Item_Registro ni with (nolock)

    inner join
      Nota_Entrada ne               with (nolock)
    on
      ne.cd_nota_entrada      = ni.cd_nota_entrada and
      ne.cd_fornecedor        = ni.cd_fornecedor and
      ne.cd_operacao_fiscal   = ni.cd_operacao_fiscal and
      ne.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
      (isnull(ni.vl_ipiisen_reg_nota_entr,0)<>0) and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS

    group by
      ni.dt_receb_nota_entrada,
      op.cd_operacao_fiscal,
      ni.cd_mascara_operacao,
--    ni.nm_serie_nota_entrada,
      ni.sg_serie_nota_fiscal,
      ni.cd_nota_entrada,
      ni.dt_nota_entrada,
      ni.cd_destinatario,
      ni.cd_tipo_destinatario,
      ni.sg_estado,
      ni.cd_mascara_operacao,
      op.ic_servico_operacao,
      -- 15/03/2004
      ni.pc_icms_reg_nota_entrada

--   select 2,* from #Nota_Entrada_IPI_Isento

    union all

    select
      distinct  -- ELIAS 10/11/2003
      cast(ni.dt_nota_saida as char(11)) +
      --cast(ni.nm_serie_nota_entrada	as char(6)) +
      cast(sn.sg_serie_nota_fiscal as char(6)) +
      cast(ni.cd_nota_saida as char(10)) +
      cast(ni.cd_mascara_operacao as char(6)) +
      cast(ni.dt_nota_saida as char(11)) +
      cast(ne.cd_cliente as char(6)) +
      cast(ne.cd_tipo_destinatario as char(1)) +
      cast(ni.sg_estado as char(2)) +
      cast(op.cd_operacao_fiscal as char(10))             as 'Chave',
      2	                                                  as 'CodOperIPI',
      sum(round(isnull(ni.vl_ipi_isento_item_nota,0),2))  as 'BCIPI',
      -- 15/03/2004
      max(isnull(ni.pc_icms_item_nota_saida,0))          as 'AliqICMS',  -- ELIAS 10/11/2003

--select * from nota_saida_item_registro

      case when (isnull((select 
                         sum(ipi.IPIObs)
                       from
                         #Nota_Entrada_IPI ipi
                       where
                         ipi.Chave = (cast(ni.dt_nota_saida as char(11)) +
                                      --cast(ni.nm_serie_nota_entrada as char(6)) +
                                      cast(sn.sg_serie_nota_fiscal as char(6)) +
                                      cast(ni.cd_nota_saida as char(10)) +
                                      cast(ni.cd_mascara_operacao as char(6)) +
                                      cast(ni.dt_nota_saida as char(11)) +
                                      cast(ne.cd_cliente as char(6)) +
                                      cast(ne.cd_tipo_destinatario as char(1)) +
                                      cast(ni.sg_estado as char(2)) +
                                      cast(op.cd_operacao_fiscal as char(10)))),'') = '') then 
                                      -- 15/03/2004
                                      max(round(isnull(ni.vl_ipi_obs_item_nota,0),2)) 
      else 
        0.00 
      end                        as 'IPIObs',

      case when (isnull((select 
                         top 1
                         ipi.ObservacaoIPI
                       from
                         #Nota_Entrada_IPI ipi
                       where
                         ipi.Chave = (cast(ni.dt_nota_saida as char(11)) +
                                      --cast(ni.nm_serie_nota_entrada as char(6)) +
                                      cast(sn.sg_serie_nota_fiscal as char(6)) +
                                      cast(ni.cd_nota_saida as char(10)) +
                                      cast(ni.cd_mascara_operacao as char(6)) +
                                      cast(ni.dt_nota_saida as char(11)) +
                                      cast(ne.cd_cliente as char(6)) +
                                      cast(ne.cd_tipo_destinatario as char(1)) +
                                      cast(ni.sg_estado as char(2)) +
                                      cast(op.cd_operacao_fiscal as char(10)))),'') = '') then 
                                      -- 15/03/2004
                                      max(op.nm_obs_livro_operacao)
      else 
        cast('' as varchar(50)) 
      end                      as 'ObservacaoIPI'

    from
      Nota_Saida_Item_Registro ni with (nolock)

    inner join
      Nota_Saida ne               with (nolock)
    on
      ne.cd_nota_saida      = ni.cd_nota_saida
    left outer join serie_nota_fiscal sn on sn.cd_serie_nota_fiscal = ne.cd_serie_nota
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ne.dt_nota_saida between @dt_inicial and @dt_final and
      (isnull(ni.vl_ipi_isento_item_nota,0)<>0) and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
      and
      @ic_nf_entrada_livro_entrada = 'S'

    group by
      ni.dt_nota_saida,
      op.cd_operacao_fiscal,
      ni.cd_mascara_operacao,
--    ni.nm_serie_nota_entrada,
      sn.sg_serie_nota_fiscal,
      ni.cd_nota_saida,
      ni.dt_nota_saida,
      ne.cd_cliente,
      ne.cd_tipo_destinatario,
      ni.sg_estado,
      ni.cd_mascara_operacao,
      op.ic_servico_operacao,
      -- 15/03/2004
      ni.pc_icms_item_nota_saida

   
    -- NOTAS COM ICMS - OUTROS (Operacao 3)

    select
      distinct  -- ELIAS 10/11/2003
      cast(ni.dt_receb_nota_entrada as char(11)) +
      --cast(ni.nm_serie_nota_entrada	as char(6)) +
      cast(ni.sg_serie_nota_fiscal as char(6)) +
      cast(ni.cd_nota_entrada as char(10)) +
      cast(ni.cd_mascara_operacao as char(6)) +
      cast(ni.dt_nota_entrada as char(11)) +
      cast(ni.cd_destinatario as char(6)) +
      cast(ni.cd_tipo_destinatario as char(1)) +
      cast(ni.sg_estado as char(2)) +
      cast(op.cd_operacao_fiscal as char(10))     as 'Chave',
      3						  as 'CodOperICMS',
      sum(round(isnull(ni.vl_icmsoutr_reg_nota_entr,0),2)) as 'BCICMS',
      case when (isnull((select 
                         sum(icms.ICMSObs)
                       from
                         #Nota_Entrada_ICMS icms
                       where
                         icms.Chave = (cast(ni.dt_receb_nota_entrada as char(11)) +
                                       --cast(ni.nm_serie_nota_entrada as char(6)) +
                                       cast(ni.sg_serie_nota_fiscal as char(6)) +
                                       cast(ni.cd_nota_entrada as char(10)) +
                                       cast(ni.cd_mascara_operacao as char(6)) +
                                       cast(ni.dt_nota_entrada as char(11)) +
                                       cast(ni.cd_destinatario as char(6)) +
                                       cast(ni.cd_tipo_destinatario as char(1)) +
                                       cast(ni.sg_estado as char(2)) +
                                       cast(op.cd_operacao_fiscal as char(10)))),'') = '') then 
        max(round(isnull(ni.vl_icmsobs_reg_nota_entr,0),2)) 
      else 
        0 end as 'ICMSObs',
      case when (isnull((select 
                         top 1
                         icms.ObservacaoICMS
                       from
                         #Nota_Entrada_ICMS icms
                       where
                         icms.Chave = (cast(ni.dt_receb_nota_entrada as char(11)) +
                                       --cast(ni.nm_serie_nota_entrada as char(6)) +
                                       cast(ni.sg_serie_nota_fiscal as char(6)) +
                                       cast(ni.cd_nota_entrada as char(10)) +
                                       cast(ni.cd_mascara_operacao as char(6)) +
                                       cast(ni.dt_nota_entrada as char(11)) +
                                       cast(ni.cd_destinatario as char(6)) +
                                       cast(ni.cd_tipo_destinatario as char(1)) +
                                       cast(ni.sg_estado as char(2)) +
                                       cast(op.cd_operacao_fiscal as char(10)))),'') = '') then 
        max(isnull(ni.nm_obsicms_reg_nota_entr,op.nm_obs_livro_operacao)) 
      else 
        cast(null as varchar(50)) end as 'ObservacaoICMS'
    into
      #Nota_Entrada_ICMS_Outro

    from
      Nota_Entrada_Item_Registro ni with (nolock)
    inner join
      Nota_Entrada ne               with (nolock)
    on
      ne.cd_nota_entrada      = ni.cd_nota_entrada and
      ne.cd_fornecedor        = ni.cd_fornecedor and
      ne.cd_operacao_fiscal   = ni.cd_operacao_fiscal and
      ne.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
      (isnull(ni.vl_icmsoutr_reg_nota_entr,0)<>0) and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
    group by
      ni.dt_receb_nota_entrada,
      op.cd_operacao_fiscal,
      ni.cd_mascara_operacao,
--    ni.nm_serie_nota_entrada,
      ni.sg_serie_nota_fiscal,
      ni.cd_nota_entrada,
      ni.dt_nota_entrada,
      ni.cd_destinatario,
      ni.cd_tipo_destinatario,
      ni.sg_estado,
      ni.cd_mascara_operacao,
      op.ic_servico_operacao

    union all

    select
      distinct  -- ELIAS 10/11/2003
      cast(ni.dt_nota_saida as char(11)) +
      --cast(ni.nm_serie_nota_entrada	as char(6)) +
      cast(sn.sg_serie_nota_fiscal as char(6)) +
      cast(ni.cd_nota_saida as char(10)) +
      cast(ni.cd_mascara_operacao as char(6)) +
      cast(ni.dt_nota_saida as char(11)) +
      cast(ne.cd_cliente as char(6)) +
      cast(ne.cd_tipo_destinatario as char(1)) +
      cast(ni.sg_estado as char(2)) +
      cast(op.cd_operacao_fiscal as char(10))     as 'Chave',

--select * from nota_saida_item_registro

      3						  as 'CodOperICMS',
      sum(round(isnull(ni.vl_icms_outras_item_nota,0),2)) as 'BCICMS',
      case when (isnull((select 
                         sum(icms.ICMSObs)
                       from
                         #Nota_Entrada_ICMS icms
                       where
                         icms.Chave = (cast(ni.dt_nota_saida as char(11)) +
                                       --cast(ni.nm_serie_nota_entrada as char(6)) +
                                       cast(sn.sg_serie_nota_fiscal as char(6)) +
                                       cast(ni.cd_nota_saida as char(10)) +
                                       cast(ni.cd_mascara_operacao as char(6)) +
                                       cast(ni.dt_nota_saida as char(11)) +
                                       cast(ne.cd_cliente as char(6)) +
                                       cast(ne.cd_tipo_destinatario as char(1)) +
                                       cast(ni.sg_estado as char(2)) +
                                       cast(op.cd_operacao_fiscal as char(10)))),'') = '') then 
        max(round(isnull(ni.vl_icms_obs_item_nota,0),2)) 
      else 
        0.00
      end                     as 'ICMSObs',
      case when (isnull((select 
                         top 1
                         icms.ObservacaoICMS
                       from
                         #Nota_Entrada_ICMS icms
                       where
                         icms.Chave = (cast(ni.dt_nota_saida as char(11)) +
                                       --cast(ni.nm_serie_nota_entrada as char(6)) +
                                       cast(sn.sg_serie_nota_fiscal as char(6)) +
                                       cast(ni.cd_nota_saida as char(10)) +
                                       cast(ni.cd_mascara_operacao as char(6)) +
                                       cast(ni.dt_nota_saida as char(11)) +
                                       cast(ne.cd_cliente as char(6)) +
                                       cast(ne.cd_tipo_destinatario as char(1)) +
                                       cast(ni.sg_estado as char(2)) +
                                       cast(op.cd_operacao_fiscal as char(10)))),'') = '') then 
        max(op.nm_obs_livro_operacao) 
      else 
        cast('' as varchar(50)) 
      end                              as 'ObservacaoICMS'

    from
      Nota_Saida_Item_Registro ni with (nolock)

    inner join
      Nota_Saida ne               with (nolock)
    on
      ne.cd_nota_saida      = ni.cd_nota_saida
    left outer join serie_nota_fiscal sn on sn.cd_serie_nota_fiscal = ne.cd_serie_nota
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ne.dt_nota_saida between @dt_inicial and @dt_final and
      (isnull(ni.vl_icms_outras_item_nota,0)<>0) and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
      and
      @ic_nf_entrada_livro_entrada = 'S'

    group by
      ni.dt_nota_saida,
      op.cd_operacao_fiscal,
      ni.cd_mascara_operacao,
--    ni.nm_serie_nota_entrada,
      sn.sg_serie_nota_fiscal,
      ni.cd_nota_saida,
      ni.dt_nota_saida,
      ne.cd_cliente,
      ne.cd_tipo_destinatario,
      ni.sg_estado,
      ni.cd_mascara_operacao,
      op.ic_servico_operacao

    -- NOTAS COM IPI - OUTROS (Operacao 3)

--    select 3,* from #Nota_Entrada_IPI

    select
      cast(ni.dt_receb_nota_entrada as char(11)) +
      --cast(ni.nm_serie_nota_entrada	as char(6)) +
      cast(ni.sg_serie_nota_fiscal as char(6)) +
      cast(ni.cd_nota_entrada as char(10)) +
      cast(ni.cd_mascara_operacao as char(6)) +
      cast(ni.dt_nota_entrada as char(11)) +
      cast(ni.cd_destinatario as char(6)) +
      cast(ni.cd_tipo_destinatario as char(1)) +
      cast(ni.sg_estado as char(2)) +
      cast(op.cd_operacao_fiscal as char(10))    as 'Chave',
      3		        			 as 'CodOperIPI',
      sum(round(isnull(ni.vl_ipioutr_reg_nota_entr,0),2)) as 'BCIPI',
      -- 15/03/2004
      max(isnull(ni.pc_icms_reg_nota_entrada,0)) as 'AliqICMS',  -- ELIAS 10/11/2003

      case when (isnull((select 
                         sum(ipi.IPIObs)
                       from
                         #Nota_Entrada_IPI ipi
                       where
                         ipi.Chave = (cast(ni.dt_receb_nota_entrada as char(11)) +
                                      --cast(ni.nm_serie_nota_entrada as char(6)) +
                                      cast(ni.sg_serie_nota_fiscal as char(6)) +
                                      cast(ni.cd_nota_entrada as char(10)) +
                                      cast(ni.cd_mascara_operacao as char(6)) +
                                      cast(ni.dt_nota_entrada as char(11)) +
                                      cast(ni.cd_destinatario as char(6)) +
                                      cast(ni.cd_tipo_destinatario as char(1)) +
                                      cast(ni.sg_estado as char(2)) +
                                      cast(op.cd_operacao_fiscal as char(10)))),'') = '') then 
        -- 15/03/2004
        max(round(isnull(ni.vl_ipiobs_reg_nota_entr,0),2)) 
      else 
        0.00 end as 'IPIObs',

      case when (isnull((select 
                           top 1
                           ipi.ObservacaoIPI
                         from
                           #Nota_Entrada_IPI ipi
                         where
                           ipi.Chave = (cast(ni.dt_receb_nota_entrada as char(11)) +
                                        --cast(ni.nm_serie_nota_entrada as char(6)) +
                                        cast(ni.sg_serie_nota_fiscal as char(6)) +
                                        cast(ni.cd_nota_entrada as char(10)) +
                                        cast(ni.cd_mascara_operacao as char(6)) +
                                        cast(ni.dt_nota_entrada as char(11)) +
                                        cast(ni.cd_destinatario as char(6)) +
                                        cast(ni.cd_tipo_destinatario as char(1)) +
                                        cast(ni.sg_estado as char(2)) +
                                        cast(op.cd_operacao_fiscal as char(10)))),'') = '') then 
        -- 15/03/2004
        max(isnull(ni.nm_obsipi_reg_nota_entr,op.nm_obs_livro_operacao)) 
      else 
        cast(null as varchar(50)) end as 'ObservacaoIPI'
    into
      #Nota_Entrada_IPI_Outro_Ant

    from
      Nota_Entrada_Item_Registro ni with (nolock)
    inner join
      Nota_Entrada ne               with (nolock)
    on
      ne.cd_nota_entrada      = ni.cd_nota_entrada and
      ne.cd_fornecedor        = ni.cd_fornecedor and
      ne.cd_operacao_fiscal   = ni.cd_operacao_fiscal and
      ne.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
      -- ELIAS 12/07/2004
      ((isnull(ni.vl_ipioutr_reg_nota_entr,0)<>0) or (isnull(ni.vl_ipiobs_reg_nota_entr,0)<>0)) and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
    group by
      ni.dt_receb_nota_entrada,
      op.cd_operacao_fiscal,
      ni.cd_mascara_operacao,
--    ni.nm_serie_nota_entrada,
      ni.sg_serie_nota_fiscal,
      ni.cd_nota_entrada,
      ni.dt_nota_entrada,
      ni.cd_destinatario,
      ni.cd_tipo_destinatario,
      ni.sg_estado,
      ni.cd_mascara_operacao,
      op.ic_servico_operacao --,

      union all

      select
      cast(ni.dt_nota_saida as char(11)) +
      --cast(ni.nm_serie_nota_entrada	as char(6)) +
      cast(sn.sg_serie_nota_fiscal as char(6)) +
      cast(ni.cd_nota_saida as char(10)) +
      cast(ni.cd_mascara_operacao as char(6)) +
      cast(ni.dt_nota_saida as char(11)) +
      cast(ne.cd_cliente as char(6)) +
      cast(ne.cd_tipo_destinatario as char(1)) +
      cast(ni.sg_estado as char(2)) +
      cast(op.cd_operacao_fiscal as char(10))    as 'Chave',
      3		        			 as 'CodOperIPI',

--select * from nota_saida_item_registro

      sum(round(isnull(ni.vl_ipi_outras_item_nota,0),2)) as 'BCIPI',
      -- 15/03/2004
      max(isnull(ni.pc_icms_item_nota_saida,0))          as 'AliqICMS',  -- ELIAS 10/11/2003

      case when (isnull((select 
                         sum(ipi.IPIObs)
                       from
                         #Nota_Entrada_IPI ipi
                       where
                         ipi.Chave = (cast(ni.dt_nota_saida as char(11)) +
                                      --cast(ni.nm_serie_nota_entrada as char(6)) +
                                      cast(sn.sg_serie_nota_fiscal as char(6)) +
                                      cast(ni.cd_nota_saida as char(10)) +
                                      cast(ni.cd_mascara_operacao as char(6)) +
                                      cast(ni.dt_nota_saida as char(11)) +
                                      cast(ne.cd_cliente as char(6)) +
                                      cast(ne.cd_tipo_destinatario as char(1)) +
                                      cast(ni.sg_estado as char(2)) +
                                      cast(op.cd_operacao_fiscal as char(10)))),'') = '') then 
        -- 15/03/2004
        max(round(isnull(ni.vl_ipi_obs_item_nota,0),2)) 
      else 
        0.00
      end                              as 'IPIObs',

      case when (isnull((select 
                           top 1
                           ipi.ObservacaoIPI
                         from
                           #Nota_Entrada_IPI ipi
                         where
                           ipi.Chave = (cast(ni.dt_nota_saida as char(11)) +
                                        --cast(ni.nm_serie_nota_entrada as char(6)) +
                                        cast(sn.sg_serie_nota_fiscal as char(6)) +
                                        cast(ni.cd_nota_saida as char(10)) +
                                        cast(ni.cd_mascara_operacao as char(6)) +
                                        cast(ni.dt_nota_saida as char(11)) +
                                        cast(ne.cd_cliente as char(6)) +
                                        cast(ne.cd_tipo_destinatario as char(1)) +
                                        cast(ni.sg_estado as char(2)) +
                                        cast(op.cd_operacao_fiscal as char(10)))),'') = '') then 
        -- 15/03/2004
        max(op.nm_obs_livro_operacao)
      else 
        cast('' as varchar(50))
     end                        as 'ObservacaoIPI'

    from
      Nota_Saida_Item_Registro ni with (nolock)
    inner join
      Nota_Saida ne               with (nolock)
    on
      ne.cd_nota_saida      = ni.cd_nota_saida

    left outer join serie_nota_fiscal sn on sn.cd_serie_nota_fiscal = ne.cd_serie_nota
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ne.dt_nota_saida between @dt_inicial and @dt_final and
      -- ELIAS 12/07/2004
      ((isnull(ni.vl_ipi_outras_item_nota,0)<>0) or (isnull(ni.vl_ipi_obs_item_nota,0)<>0)) and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
      and
      @ic_nf_entrada_livro_entrada = 'S'

    group by
      ni.dt_nota_saida,
      op.cd_operacao_fiscal,
      ni.cd_mascara_operacao,
--    ni.nm_serie_nota_entrada,
      sn.sg_serie_nota_fiscal,
      ni.cd_nota_saida,
      ni.dt_nota_saida,
      ne.cd_cliente,
      ne.cd_tipo_destinatario,
      ni.sg_estado,
      ni.cd_mascara_operacao,
      op.ic_servico_operacao --,


      --15/03/2004
      --ni.pc_icms_reg_nota_entrada -- ELIAS 10/11/2003

--    select 4,* from #Nota_Entrada_IPI_Outro_Ant


    -- Necessário devido a casos onde existem NF com a mesma classificação fiscal (máscara) mas
    -- com códigos diferentes (cd_operacao_fiscal) e lançadas separadamente (mais do que um registro em
    -- Nota_Entrada) - ELIAS 14/11/2003


    select 
      Chave,
      CodOperIPI,
      sum(BCIPI)           as BCIPI,
      AliqICMS,
      sum(IPIObs)          as IPIObs,
      ObservacaoIPI
    into
      #Nota_Entrada_IPI_Outro

    from 
      #Nota_Entrada_IPI_Outro_Ant

    group by
      Chave,
      CodOperIPI,
      AliqICMS,
      ObservacaoIPI

--    select 5,* from #Nota_Entrada_IPI_Outro

    -- Crio a tabela de retorno do Livro com todos os campos necessários,
    -- Baseado na primeira tabela (Nota_Entrada_Emitente)
    declare @SQL varchar(2500)

    Select
      cast(null as varchar(70))    as Chave,      
      cast(null as datetime)       as Entrada,
      cast(null as varchar(6))     as Especie,
      cast(null as varchar(6))     as SubSerie,
      cast(null as int)            as Numero,
      cast(null as datetime)       as Data,
      cast(null as varchar(50))    as Emitente,
      cast(null as char(2))        as UF,
      cast(null as numeric(25,2))  as VlrContabil,
      cast(null as varchar(20))    as ClassContabil,
      cast(null as varchar(6))     as ClassFiscal,
      cast(null as char(1))        as CodOperICMS,
      cast(null as numeric(25,2))  as BCICMS,
      cast(null as numeric(25,2))  as AliqICMS,
      cast(null as numeric(25,2))  as ICMS,
      cast(null as char(1))        as CodOperIPI,
      cast(null as numeric(25,2))  as BCIPI,
      cast(null as numeric(25,2))  as IPI,
      cast(null as varchar(500))   as ObservacaoICMS,
      cast(null as numeric(25,2))  as ICMSObs,
      cast(null as varchar(500))   as ObservacaoIPI,
      cast(null as numeric(25,2))  as IPIObs,
      cast(null as int)            as REM
    into
      #Nota_Entrada

    delete from #Nota_Entrada

    insert into
      #Nota_Entrada
    select
      Chave,
      Entrada,
      Especie,
      SubSerie,
      Numero,
      Data,
      Emitente,
      UF,
      cast(null as numeric(25,2)),
      cast(null as varchar(20)),
      cast(null as varchar(6)),
      cast(null as char(1)),
      cast(null as numeric(25,2)),
      cast(null as numeric(25,2)),
      cast(null as numeric(25,2)),
      cast(null as char(1)),
      cast(null as numeric(25,2)),
      cast(null as numeric(25,2)),
      cast(null as varchar(500)),
      cast(null as numeric(25,2)),
      cast(null as varchar(500)),
      cast(null as numeric(25,2)),
      REM
    from
      #Nota_Entrada_Emitente

    drop table 
      #Nota_Entrada_Emitente

    -- Preenchendo com valores contábeis
    update #Nota_Entrada
      set #Nota_Entrada.VlrContabil = #Nota_Entrada_VlrContabil.VlrContabil,
          #Nota_Entrada.ClassFiscal = #Nota_Entrada_VlrContabil.ClassFiscal
      from
        #Nota_Entrada,
        #Nota_Entrada_VlrContabil
      where
        #Nota_Entrada.Chave = #Nota_Entrada_VlrContabil.Chave

    delete from
      #Nota_Entrada_VlrContabil
    from
      #Nota_Entrada_VlrContabil
    inner join
      #Nota_Entrada
    on
      #Nota_Entrada_VlrContabil.Chave = #Nota_Entrada.Chave

    insert into #Nota_Entrada (
      Chave,
      VlrContabil,
      ClassFiscal)      
    select
      Chave,
      VlrContabil,
      ClassFiscal
    from
      #Nota_Entrada_VlrContabil                

    drop table 
      #Nota_Entrada_VlrContabil

    -- Preenchendo com ICMS (Parametro 1)

    update #Nota_Entrada
      set #Nota_Entrada.CodOperICMS    = #Nota_Entrada_ICMS.CodOperICMS,
	  #Nota_Entrada.BCICMS         = #Nota_Entrada_ICMS.BCICMS,
	  #Nota_Entrada.AliqICMS       = #Nota_Entrada_ICMS.AliqICMS,
          #Nota_Entrada.ICMS           = #Nota_Entrada_ICMS.ICMS,
          #Nota_Entrada.ICMSObs        = #Nota_Entrada_ICMS.ICMSObs,
	  #Nota_Entrada.ObservacaoICMS = #Nota_Entrada_ICMS.ObservacaoICMS
      from
        #Nota_Entrada,
        #Nota_Entrada_ICMS
      where
        #Nota_Entrada.Chave = #Nota_Entrada_ICMS.Chave 

    delete from
      #Nota_Entrada_ICMS
    from
      #Nota_Entrada_ICMS
    inner join
      #Nota_Entrada
    on
      #Nota_Entrada_ICMS.Chave              = #Nota_Entrada.Chave and
      isnull(#Nota_Entrada_ICMS.AliqICMS,0) = isnull(#Nota_Entrada.AliqICMS,0)

    insert into #Nota_Entrada (
      Chave,
      CodOperICMS,
      BCICMS,
      AliqICMS,
      ICMS,
      ICMSObs,
      ObservacaoICMS )
    select
      Chave,
      CodOperICMS,
      BCICMS,
      AliqICMS,
      ICMS,
      ICMSObs,
      ObservacaoICMS
    from
      #Nota_Entrada_ICMS   

    drop table 
      #Nota_Entrada_ICMS

    -- Preenchendo o IPI (Parametro 1)

    update #Nota_Entrada
      set #Nota_Entrada.CodOperIPI    = #Nota_Entrada_IPI.CodOperIPI,
	  #Nota_Entrada.BCIPI         = #Nota_Entrada_IPI.BCIPI,
          #Nota_Entrada.IPI           = #Nota_Entrada_IPI.IPI,
          #Nota_Entrada.IPIObs        = #Nota_Entrada_IPI.IPIObs,
	  #Nota_Entrada.ObservacaoIPI = #Nota_Entrada_IPI.ObservacaoIPI
      from
        #Nota_Entrada,
        #Nota_Entrada_IPI
      where
        #Nota_Entrada.Chave = #Nota_Entrada_IPI.Chave and
        isnull(#Nota_Entrada.AliqICMS,#Nota_Entrada_IPI.AliqICMS) = #Nota_Entrada_IPI.AliqICMS

    drop table 
      #Nota_Entrada_IPI
    
    -- Preenchendo com o ICMS Isento (Parametro 2)

    update #Nota_Entrada
      set #Nota_Entrada.CodOperICMS    = #Nota_Entrada_ICMS_Isento.CodOperICMS,
	  #Nota_Entrada.BCICMS         = #Nota_Entrada_ICMS_Isento.BCICMS,
          #Nota_Entrada.ICMSObs        = #Nota_Entrada_ICMS_Isento.ICMSObs,
	  #Nota_Entrada.ObservacaoICMS = #Nota_Entrada_ICMS_Isento.ObservacaoICMS
      from
        #Nota_Entrada,
        #Nota_Entrada_ICMS_Isento
      where
        #Nota_Entrada.Chave = #Nota_Entrada_ICMS_Isento.Chave and
        (isnull(#Nota_Entrada.BCICMS,0)=0)  -- ELIAS

    delete from
      #Nota_Entrada_ICMS_Isento
    from
      #Nota_Entrada_ICMS_Isento
    inner join
      #Nota_Entrada
    on
      #Nota_Entrada_ICMS_Isento.Chave = #Nota_Entrada.Chave and
      #Nota_Entrada.CodOperICMS       = 2

    insert into #Nota_Entrada (
      Chave,
      CodOperICMS,
      BCICMS )
    select
      Chave,
      CodOperICMS,
      BCICMS
    from
      #Nota_Entrada_ICMS_Isento 

    drop table 
      #Nota_Entrada_ICMS_Isento

    -- Preenchendo com o IPI Isento (Parametro 2)

    update #Nota_Entrada
      set #Nota_Entrada.CodOperIPI    = #Nota_Entrada_IPI_Isento.CodOperIPI,
	  #Nota_Entrada.BCIPI         = #Nota_Entrada_IPI_Isento.BCIPI,
          #Nota_Entrada.IPIObs        = #Nota_Entrada_IPI_Isento.IPIObs,
	  #Nota_Entrada.ObservacaoIPI = #Nota_Entrada_IPI_Isento.ObservacaoIPI
      from
        #Nota_Entrada,
        #Nota_Entrada_IPI_Isento
      where
        #Nota_Entrada.Chave = #Nota_Entrada_IPI_Isento.Chave and
        isnull(#Nota_Entrada.AliqICMS,0) = isnull(#Nota_Entrada_IPI_Isento.AliqICMS,0)  -- ELIAS 10/11/2003
--        isnull(#Nota_Entrada.AliqICMS,#Nota_Entrada_IPI_Isento.AliqICMS) = #Nota_Entrada_IPI_Isento.AliqICMS  -- ELIAS 10/11/2003

    delete from
      #Nota_Entrada_IPI_Isento
    from
      #Nota_Entrada_IPI_Isento
    inner join
      #Nota_Entrada
    on
      #Nota_Entrada_IPI_Isento.Chave      = #Nota_Entrada.Chave and
      #Nota_Entrada_IPI_Isento.CodOperIPI = #Nota_Entrada.CodOperIPI and
      isnull(#Nota_Entrada.AliqICMS,#Nota_Entrada_IPI_Isento.AliqICMS) = #Nota_Entrada_IPI_Isento.AliqICMS  -- ELIAS 10/11/2003
--      #Nota_Entrada.CodOperIPI = 2

    insert into #Nota_Entrada (
      Chave,
      CodOperIPI,
      BCIPI )
    select
      Chave,
      CodOperIPI,
      BCIPI
    from
      #Nota_Entrada_IPI_Isento 

    drop table 
      #Nota_Entrada_IPI_Isento

    -- Preenchendo com o ICMS Outros (Parametro 3)

    update #Nota_Entrada
      set #Nota_Entrada.CodOperICMS    = #Nota_Entrada_ICMS_Outro.CodOperICMS,
	  #Nota_Entrada.BCICMS         = #Nota_Entrada_ICMS_Outro.BCICMS,
          #Nota_Entrada.ICMSObs        = #Nota_Entrada_ICMS_Outro.ICMSObs,
	  #Nota_Entrada.ObservacaoICMS = #Nota_Entrada_ICMS_Outro.ObservacaoICMS
      from
        #Nota_Entrada,
        #Nota_Entrada_ICMS_Outro
      where
        #Nota_Entrada.Chave = #Nota_Entrada_ICMS_Outro.Chave and
        (isnull(#Nota_Entrada.BCICMS,0)=0)

    delete from
      #Nota_Entrada_ICMS_Outro
    from
      #Nota_Entrada_ICMS_Outro
    inner join
      #Nota_Entrada
    on
      #Nota_Entrada_ICMS_Outro.Chave = #Nota_Entrada.Chave and
      #Nota_Entrada.CodOperICMS = 3


    insert into #Nota_Entrada (
      Chave,
      CodOperICMS,
      BCICMS,
      ICMSObs )  -- ELIAS 14/11/2003
    select
      Chave,
      CodOperICMS,
      BCICMS,
      ICMSObs  -- ELIAS 14/11/2003
    from
      #Nota_Entrada_ICMS_Outro

    drop table 
      #Nota_Entrada_ICMS_Outro

    -- Preenchendo com o IPI Outros (Parametro 3)

    --select * from #Nota_entrada_ipi_outro

    update #Nota_Entrada
      set #Nota_Entrada.CodOperIPI    = #Nota_Entrada_IPI_Outro.CodOperIPI,
	  #Nota_Entrada.BCIPI         = #Nota_Entrada_IPI_Outro.BCIPI,
          #Nota_Entrada.IPIObs        = #Nota_Entrada_IPI_Outro.IPIObs,
	  #Nota_Entrada.ObservacaoIPI = #Nota_Entrada_IPI_Outro.ObservacaoIPI
      from
        #Nota_Entrada,
        #Nota_Entrada_IPI_Outro
      where
        #Nota_Entrada.Chave = #Nota_Entrada_IPI_Outro.Chave and
        isnull(#Nota_Entrada.AliqICMS,#Nota_Entrada_IPI_Outro.AliqICMS) = #Nota_Entrada_IPI_Outro.AliqICMS and
        --Carlos 22.03.2007
        --(#Nota_Entrada.CodOperICMS = 1 or #Nota_Entrada.CodOperICMS = 2) and

        #Nota_Entrada.CodOperICMS = 1                 and
        (isnull(#Nota_Entrada.BCIPI,0)=0)

    delete from
      #Nota_Entrada_IPI_Outro
    from
      #Nota_Entrada_IPI_Outro
    inner join
      #Nota_Entrada
    on
      #Nota_Entrada_IPI_Outro.Chave = #Nota_Entrada.Chave and
      isnull(#Nota_Entrada.AliqICMS,#Nota_Entrada_IPI_Outro.AliqICMS) = #Nota_Entrada_IPI_Outro.AliqICMS and
     (#Nota_Entrada.CodOperICMS = 1 or #Nota_Entrada.CodOperICMS = 2) and
      #Nota_Entrada.CodOperIPI = 3 and
      cast(#Nota_Entrada.BCIPI as decimal(25,2)) = cast(#Nota_Entrada_IPI_Outro.BCIPI as decimal(25,2))

    update #Nota_Entrada
      set #Nota_Entrada.CodOperIPI    = #Nota_Entrada_IPI_Outro.CodOperIPI,
	  #Nota_Entrada.BCIPI         = #Nota_Entrada_IPI_Outro.BCIPI,
          #Nota_Entrada.IPIObs        = #Nota_Entrada_IPI_Outro.IPIObs,
	  #Nota_Entrada.ObservacaoIPI = #Nota_Entrada_IPI_Outro.ObservacaoIPI
      from
        #Nota_Entrada,
        #Nota_Entrada_IPI_Outro
      where
        #Nota_Entrada.Chave = #Nota_Entrada_IPI_Outro.Chave and
        (#Nota_Entrada.CodOperICMS = 3) and
        (isnull(#Nota_Entrada.BCIPI,0)=0) --and
        
    delete from
      #Nota_Entrada_IPI_Outro
    from
      #Nota_Entrada_IPI_Outro
    inner join
      #Nota_Entrada
    on
      #Nota_Entrada_IPI_Outro.Chave = #Nota_Entrada.Chave and
      isnull(#Nota_Entrada.AliqICMS,#Nota_Entrada_IPI_Outro.AliqICMS) = #Nota_Entrada_IPI_Outro.AliqICMS and
      #Nota_Entrada.CodOperIPI = 3

    insert into #Nota_Entrada (
      Chave,
      CodOperIPI,
      BCIPI,
      IPIObs )  -- ELIAS 14/11/2003
   select
      Chave,
      CodOperIPI,
      BCIPI,
      IPIObs  -- ELIAS 14/11/2003
    from
      #Nota_Entrada_IPI_Outro

    drop table 
      #Nota_Entrada_IPI_Outro

    select 
      * 
    from 
      #Nota_Entrada 
    order by 
      Chave,
      Entrada     desc,
      ClassFiscal asc,
      CodOperICMS asc,
      AliqICMS    asc

         
    drop table 
      #Nota_Entrada

  end

-------------------------------------------------------------------------------
else if @ic_parametro = 2   -- Listagem da relação de emitentes
-------------------------------------------------------------------------------
  begin

    select
      d.cd_destinatario,
      d.cd_tipo_destinatario,
      cast(d.cd_destinatario as varchar(6))+'/'+
      cast(d.cd_tipo_destinatario as char(1))		as 'Emitente',
      d.nm_razao_social 				as 'RazaoSocial',
      e.sg_estado					as 'UF',
      d.cd_cnpj						as 'CNPJ',
      d.cd_inscEstadual					as 'IE'

    into
      #Emitente

    from
      vw_destinatario d
    left outer join
      nota_entrada_item_registro n
    on
      d.cd_tipo_destinatario = n.cd_tipo_destinatario and
      d.cd_destinatario = n.cd_destinatario
    left outer join
      estado e
    on
      e.cd_pais = d.cd_pais and
      e.cd_estado = d.cd_estado
    left outer join
      Operacao_fiscal op
    on
      op.cd_operacao_fiscal = n.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      n.dt_receb_nota_entrada between @dt_inicial and @dt_final and 
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
    group by
      d.cd_destinatario,
      d.cd_tipo_destinatario,
      d.nm_razao_social,
      e.sg_estado,
      d.cd_cnpj,
      d.cd_inscEstadual

--     order by
--       d.cd_destinatario,
--       d.cd_tipo_destinatario    

    union all
      
      select
        d.cd_destinatario,
        d.cd_tipo_destinatario,
        cast(d.cd_destinatario as varchar(6))+'/'+
        cast(d.cd_tipo_destinatario as char(1))		as 'Emitente',
        d.nm_razao_social 				as 'RazaoSocial',
        e.sg_estado					as 'UF',
        d.cd_cnpj						as 'CNPJ',
        d.cd_inscEstadual					as 'IE'

      from
        vw_destinatario d
        left outer join nota_saida ns on d.cd_tipo_destinatario = ns.cd_tipo_destinatario and
                                         d.cd_destinatario      = ns.cd_cliente

        left outer join  nota_saida_item_registro n on n.cd_nota_saida = ns.cd_nota_saida
        left outer join  estado e
        on
          e.cd_pais = d.cd_pais and
          e.cd_estado = d.cd_estado
        left outer join Operacao_fiscal op          on op.cd_operacao_fiscal = n.cd_operacao_fiscal
        left outer join
          Grupo_Operacao_Fiscal gop
        on
          gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
      where
        n.dt_nota_saida between @dt_inicial and @dt_final and 
        isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
        gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
        and
        @ic_nf_entrada_livro_entrada = 'S'

      group by
        d.cd_destinatario,
        d.cd_tipo_destinatario,
        d.nm_razao_social,
        e.sg_estado,
        d.cd_cnpj,
        d.cd_inscEstadual  

    select
      *
    from
      #Emitente
    order by
      cd_destinatario,
      cd_tipo_destinatario    

     
  end


--------------------------------------------------
else if @ic_parametro = 3 -- Resumo por CFOP.
--------------------------------------------------
  begin

    -- VALOR CONTÁBIL E CFOP

    select
      (cast(ni.cd_mascara_operacao as char(6)) +
       cast(isnull(ni.pc_icms_reg_nota_entrada,0) as char(6)))   as 'Chave',
      op.cd_grupo_operacao_fiscal                                as 'Grupo',
      isnull(ni.pc_icms_reg_nota_entrada,0)                      as 'GrupoAliq',
      round(sum(isnull(ni.vl_cont_reg_nota_entrada,0)),2)        as 'VlrContabil',
      ni.cd_mascara_operacao                                     as 'ClassFiscal'
    into
      #Nota_CFOP_VlrContabil_Ant
    from
      Nota_Entrada_Item_Registro ni
    inner join
      Nota_Entrada ne
    on
      ne.cd_nota_entrada      = ni.cd_nota_entrada and
      ne.cd_fornecedor        = ni.cd_fornecedor and
      ne.cd_operacao_fiscal   = ni.cd_operacao_fiscal and
      ne.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal
    left outer join
      Operacao_fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
    group by
      op.cd_grupo_operacao_fiscal,
      ni.cd_mascara_operacao,
      ni.pc_icms_reg_nota_entrada

    select
      Chave,
      Grupo,
      GrupoAliq,
      sum(VlrContabil) as VlrContabil,
      ClassFiscal
    into
      #Nota_CFOP_VlrContabil
    from
      #Nota_CFOP_VlrContabil_Ant
    group by
      Chave,
      Grupo,
      GrupoAliq,
      ClassFiscal

    -- NOTAS COM ICMS (Operação 1)

    select
      (cast(ni.cd_mascara_operacao as char(6)) +
       cast(isnull(ni.pc_icms_reg_nota_entrada,0) as char(6)))    as 'Chave',
      op.cd_grupo_operacao_fiscal                                 as 'Grupo',
      1		   				                  as 'CodOperICMS',
      sum(round(isnull(ni.vl_bicms_reg_nota_entrada,0),2))        as 'BCICMS',
      isnull(ni.pc_icms_reg_nota_entrada,0)                       as 'AliqICMS',
      sum(round(isnull(ni.vl_icms_reg_nota_entrada,0),2))         as 'ICMS',
      sum(round(isnull(ni.vl_icmsobs_reg_nota_entr,0),2))         as 'ICMSObs'
    into
      #Nota_CFOP_ICMS_Ant
    from
      Nota_Entrada_Item_Registro ni
    inner join
      Nota_Entrada ne
    on
      ne.cd_nota_entrada = ni.cd_nota_entrada and
      ne.cd_fornecedor = ni.cd_fornecedor and
      ne.cd_operacao_fiscal = ni.cd_operacao_fiscal and
      ne.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
      (isnull(ni.vl_icms_reg_nota_entrada,0)<>0) and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
    group by
      op.cd_grupo_operacao_fiscal,
      ni.cd_mascara_operacao,
      ni.pc_icms_reg_nota_entrada

    Select 
      Chave,
      Grupo,
      CodOperICMS,
      sum(BCICMS) as BCICMS,
      AliqICMS,
      sum(ICMS) as ICMS,
      sum(ICMSObs) as ICMSObs
    into
      #Nota_CFOP_ICMS
    from
      #Nota_CFOP_ICMS_Ant 
    group by
      Chave,
      Grupo,
      CodOperICMS,
      AliqICMS

    -- NOTAS COM IPI (Operacao 1)

    select
      (cast(ni.cd_mascara_operacao as char(6)) +
       cast(isnull(ni.pc_icms_reg_nota_entrada,0) as char(6)))    as 'Chave',
      op.cd_grupo_operacao_fiscal                                 as 'Grupo',
      1				   	  	                  as 'CodOperIPI',
      sum(round(isnull(ni.vl_bipi_reg_nota_entrada,0),2))         as 'BCIPI',
      sum(round(isnull(ni.vl_ipi_reg_nota_entrada,0),2))          as 'IPI',
      sum(round(isnull(ni.vl_ipiobs_reg_nota_entr,0),2))          as 'IPIObs',
      max(isnull(ni.pc_icms_reg_nota_entrada,0))                  as 'AliqICMS'
    into
      #Nota_CFOP_IPI_Ant
    from
      Nota_Entrada_Item_Registro ni
    inner join
      Nota_Entrada ne
    on
      ne.cd_nota_entrada      = ni.cd_nota_entrada and
      ne.cd_fornecedor        = ni.cd_fornecedor and
      ne.cd_operacao_fiscal   = ni.cd_operacao_fiscal and
      ne.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
      -- ELIAS 06/09/2005
      ((isnull(ni.vl_ipi_reg_nota_entrada,0)<>0) or 
       (isnull(ni.vl_bipi_reg_nota_entrada,0)<>0))  and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
    group by
      op.cd_grupo_operacao_fiscal,
      ni.cd_mascara_operacao,
      ni.pc_icms_reg_nota_entrada

    select
      Chave,
      Grupo,
      CodOperIPI,
      sum(BCIPI) as BCIPI,
      sum(IPI) as IPI,
      sum(IPIObs) as IPIObs,
      AliqICMS
    into
      #Nota_CFOP_IPI
    from
      #Nota_CFOP_IPI_Ant
    group by
      Chave,
      Grupo,
      CodOperIPI,
      AliqICMS      

    -- NOTAS COM ICMS - ISENTAS (Operacao 2)

    select
      (cast(ni.cd_mascara_operacao as char(6)) +
       cast(isnull(ni.pc_icms_reg_nota_entrada,0) as char(6)))    as 'Chave',
      op.cd_grupo_operacao_fiscal                                 as 'Grupo',
      2						                  as 'CodOperICMS',
      max(isnull(ni.pc_icms_reg_nota_entrada,0))                  as 'AliqICMS',
      sum(round(isnull(ni.vl_icmsisen_reg_nota_entr,0),2))        as 'BCICMS',
      case when (isnull((select 
                           sum(icms.ICMSObs)
                         from
                           #Nota_CFOP_ICMS icms
                         where
                           icms.Chave = (cast(ni.cd_mascara_operacao as char(6)) +
                                         cast(isnull(ni.pc_icms_reg_nota_entrada,0) as char(6)))),'') = '') then 
        sum(round(isnull(ni.vl_icmsobs_reg_nota_entr,0),2)) 
      else 
        0 end as 'ICMSObs'
    into
      #Nota_CFOP_ICMS_Isento_Ant
    from
      Nota_Entrada_Item_Registro ni
    inner join
      Nota_Entrada ne
    on
      ne.cd_nota_entrada = ni.cd_nota_entrada and
      ne.cd_fornecedor = ni.cd_fornecedor and
      ne.cd_operacao_fiscal = ni.cd_operacao_fiscal and
      ne.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
      (isnull(ni.vl_icmsisen_reg_nota_entr,0)<>0) and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
    group by
      op.cd_grupo_operacao_fiscal, 
      ni.cd_mascara_operacao,
      ni.pc_icms_reg_nota_entrada

    select
      Chave,
      Grupo,
      CodOperICMS,
      AliqICMS,
      sum(BCICMS)  as BCICMS,
      sum(ICMSObs) as ICMSObs
    into
      #Nota_CFOP_ICMS_Isento
    from
      #Nota_CFOP_ICMS_Isento_Ant
    group by
      Chave,
      Grupo,
      CodOperICMS,
      AliqICMS

    -- NOTAS COM IPI - ISENTAS (Operacao 2)

    select
      (cast(ni.cd_mascara_operacao as char(6)) +
       cast(isnull(ni.pc_icms_reg_nota_entrada,0) as char(6)))    as 'Chave',
      op.cd_grupo_operacao_fiscal                                 as 'Grupo',
      2						                  as 'CodOperIPI',
      sum(round(isnull(ni.vl_ipiisen_reg_nota_entr,0),2))         as 'BCIPI',
      -- 15/03/2004
      max(isnull(ni.pc_icms_reg_nota_entrada,0))                  as 'AliqICMS',  -- ELIAS 10/11/2003
      case when (isnull((select 
                      sum(ipi.IPIObs)
                         from
                #Nota_CFOP_IPI ipi
                         where
                           ipi.Chave = (cast(ni.cd_mascara_operacao as char(6)) +
                                        cast(isnull(ni.pc_icms_reg_nota_entrada,0) as char(6)))),'') = '') then 
        sum(round(isnull(ni.vl_ipiobs_reg_nota_entr,0),2)) 
      else 
        0 end as 'IPIObs'
    into
      #Nota_CFOP_IPI_Isento_Ant
    from
      Nota_Entrada_Item_Registro ni
    inner join
      Nota_Entrada ne
    on
      ne.cd_nota_entrada = ni.cd_nota_entrada and
      ne.cd_fornecedor = ni.cd_fornecedor and
      ne.cd_operacao_fiscal = ni.cd_operacao_fiscal and
      ne.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
      (isnull(ni.vl_ipiisen_reg_nota_entr,0)<>0) and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
    group by
      op.cd_grupo_operacao_fiscal,
      ni.cd_mascara_operacao,
      ni.pc_icms_reg_nota_entrada


    select
      Chave,
      Grupo,
      CodOperIPI,
      AliqICMS,
      sum(BCIPI)  as BCIPI,
      sum(IPIObs) as IPIObs
    into
      #Nota_CFOP_IPI_Isento
    from
      #Nota_CFOP_IPI_Isento_Ant
    group by
      Chave,
      Grupo,
      CodOperIPI,
      AliqICMS

   
    -- NOTAS COM ICMS - OUTROS (Operacao 3)

    select
      (cast(ni.cd_mascara_operacao as char(6)) +
       cast(isnull(ni.pc_icms_reg_nota_entrada,0) as char(6)))    as 'Chave',
      op.cd_grupo_operacao_fiscal                                 as 'Grupo',
      3	        				        	  as 'CodOperICMS',
      sum(round(isnull(ni.vl_icmsoutr_reg_nota_entr,0),2))        as 'BCICMS',
      isnull(ni.pc_icms_reg_nota_entrada,0)                       as 'AliqICMS',
      case when (isnull((select 
                           sum(icms.ICMSObs)
                         from
                           #Nota_CFOP_ICMS icms
                         where
                           icms.Chave = (cast(ni.cd_mascara_operacao as char(6)) +
                                         cast(isnull(ni.pc_icms_reg_nota_entrada,0) as char(6)))),'') = '') then 
        sum(round(isnull(ni.vl_icmsobs_reg_nota_entr,0),2)) 
      else 
        0 end as 'ICMSObs'
    into
      #Nota_CFOP_ICMS_Outro_Ant
    from
      Nota_Entrada_Item_Registro ni
    inner join
      Nota_Entrada ne
    on
      ne.cd_nota_entrada = ni.cd_nota_entrada and
      ne.cd_fornecedor = ni.cd_fornecedor and
      ne.cd_operacao_fiscal = ni.cd_operacao_fiscal and
      ne.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
      (isnull(ni.vl_icmsoutr_reg_nota_entr,0)<>0) and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
    group by
      op.cd_grupo_operacao_fiscal,
      ni.cd_mascara_operacao,
      ni.pc_icms_reg_nota_entrada

    select
      Chave,
      Grupo,
      CodOperICMS,
      AliqICMS,
      sum(BCICMS)  as BCICMS,
      sum(ICMSObs) as ICMSObs
    into
      #Nota_CFOP_ICMS_Outro
    from
      #Nota_CFOP_ICMS_Outro_Ant
    group by
      Chave,
      Grupo,
      CodOperICMS,
      AliqICMS

    -- NOTAS COM IPI - OUTROS (Operacao 3)

    select
     (cast(ni.cd_mascara_operacao as char(6)) +
       cast(isnull(ni.pc_icms_reg_nota_entrada,0) as char(6)))    as 'Chave',
      op.cd_grupo_operacao_fiscal                                 as 'Grupo',
      3	                          				  as 'CodOperIPI',
      sum(round(isnull(ni.vl_ipioutr_reg_nota_entr,0),2))         as 'BCIPI',
      -- 15/03/2004
      max(isnull(ni.pc_icms_reg_nota_entrada,0))                  as 'AliqICMS',  -- ELIAS 10/11/2003
      case when (isnull((select 
                           sum(ipi.IPIObs)
                         from
                           #Nota_CFOP_IPI ipi
                         where
                           ipi.Chave = (cast(ni.cd_mascara_operacao as char(6)) +
                                        cast(isnull(ni.pc_icms_reg_nota_entrada,0) as char(6)))),'') = '') then 
        sum(round(isnull(ni.vl_ipiobs_reg_nota_entr,0),2)) 
      else 
        0 end as 'IPIObs'
    into
      #Nota_CFOP_IPI_Outro_Ant
    from
      Nota_Entrada_Item_Registro ni
    inner join
      Nota_Entrada ne
    on
      ne.cd_nota_entrada = ni.cd_nota_entrada and
      ne.cd_fornecedor = ni.cd_fornecedor and
      ne.cd_operacao_fiscal = ni.cd_operacao_fiscal and
      ne.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ne.dt_receb_nota_entrada between @dt_inicial and @dt_final and
      -- ELIAS 12/07/2004
      ((isnull(ni.vl_ipioutr_reg_nota_entr,0)<>0) or (isnull(ni.vl_ipiobs_reg_nota_entr,0)<>0)) and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
    group by
      op.cd_grupo_operacao_fiscal,
      ni.cd_mascara_operacao,
      ni.pc_icms_reg_nota_entrada


    select
      Chave,
      Grupo,
      CodOperIPI,
      AliqICMS,
      sum(BCIPI)  as BCIPI,
      sum(IPIObs) as IPIObs
    into
      #Nota_CFOP_IPI_Outro
    from
      #Nota_CFOP_IPI_Outro_Ant
    group by
      Chave,
      Grupo,
      CodOperIPI,
      AliqICMS


    -- Crio a tabela de retorno do Livro com todos os campos necessários,
    -- Baseado na primeira tabela (Nota_Entrada_Emitente)

    Select
      cast(null as varchar(70))    as Chave,      
      cast(null as int)            as Grupo,
      cast(null as numeric(25,2))  as GrupoAliq,
      cast(null as datetime)       as Entrada,
      cast(null as varchar(6))     as Especie,
      cast(null as varchar(6))     as SubSerie,
      cast(null as int)            as Numero,
      cast(null as datetime)       as Data,
      cast(null as varchar(50))    as Emitente,
      cast(null as char(2))        as UF,
      cast(null as numeric(25,2))  as VlrContabil,
      cast(null as varchar(20))    as ClassContabil,
      cast(null as varchar(6))     as ClassFiscal,
      cast(null as char(1))        as CodOperICMS,
      cast(null as numeric(25,2))  as BCICMS,
      cast(null as numeric(25,2))  as AliqICMS,
      cast(null as numeric(25,2))  as ICMS,
      cast(null as char(1))        as CodOperIPI,
      cast(null as numeric(25,2))  as BCIPI,
      cast(null as numeric(25,2))  as IPI,
      cast(null as varchar(500))   as ObservacaoICMS,
      cast(null as numeric(25,2))  as ICMSObs,
      cast(null as varchar(500))   as ObservacaoIPI,
      cast(null as numeric(25,2))  as IPIObs,
      cast(null as int)            as REM
    into
      #Nota_CFOP

    delete from #Nota_CFOP

    insert into #Nota_CFOP (
      Chave,
      Grupo,
      GrupoAliq,
      VlrContabil,
      ClassFiscal)      
    select
      Chave,
      Grupo,
      GrupoAliq,
      VlrContabil,
      ClassFiscal
    from
      #Nota_CFOP_VlrContabil   

    drop table 
      #Nota_CFOP_VlrContabil

    -- Preenchendo com ICMS (Parametro 1)

    update #Nota_CFOP
      set #Nota_CFOP.CodOperICMS = #Nota_CFOP_ICMS.CodOperICMS,
	  #Nota_CFOP.BCICMS      = #Nota_CFOP_ICMS.BCICMS,
	  #Nota_CFOP.AliqICMS    = #Nota_CFOP_ICMS.AliqICMS,
          #Nota_CFOP.ICMS        = #Nota_CFOP_ICMS.ICMS,
          #Nota_CFOP.ICMSObs     = #Nota_CFOP_ICMS.ICMSObs
      from
        #Nota_CFOP,
        #Nota_CFOP_ICMS
      where
        #Nota_CFOP.Chave = #Nota_CFOP_ICMS.Chave and
        isnull(#Nota_CFOP.AliqICMS,#Nota_CFOP_ICMS.AliqICMS) = #Nota_CFOP_ICMS.AliqICMS 

    delete from
      #Nota_CFOP_ICMS
    from
      #Nota_CFOP_ICMS
    inner join
      #Nota_CFOP
    on
      isnull(#Nota_CFOP.AliqICMS,#Nota_CFOP_ICMS.AliqICMS) = #Nota_CFOP_ICMS.AliqICMS 

    insert into #Nota_CFOP (
      Chave, 
      Grupo,
      GrupoAliq,
      AliqICMS,
      CodOperICMS,
      BCICMS,
      ICMS,
      ICMSObs )
    select
      Chave,
      Grupo,
      AliqICMS,
      AliqICMS,
      CodOperICMS,
      BCICMS,
      ICMS,
      ICMSObs
    from
      #Nota_CFOP_ICMS   

    drop table 
      #Nota_CFOP_ICMS

    -- Preenchendo com o ICMS Isento (Parametro 2)

    update #Nota_CFOP
      set #Nota_CFOP.CodOperICMS = #Nota_CFOP_ICMS_Isento.CodOperICMS,
	  #Nota_CFOP.BCICMS = #Nota_CFOP_ICMS_Isento.BCICMS,
       #Nota_CFOP.ICMSObs = #Nota_CFOP_ICMS_Isento.ICMSObs
      from
        #Nota_CFOP,
        #Nota_CFOP_ICMS_Isento
      where
        #Nota_CFOP.Chave = #Nota_CFOP_ICMS_Isento.Chave and
        isnull(#Nota_CFOP.AliqICMS,#Nota_CFOP_ICMS_Isento.AliqICMS) = #Nota_CFOP_ICMS_Isento.AliqICMS and
        #Nota_CFOP.CodOperICMS = #Nota_CFOP_ICMS_Isento.CodOperICMS

    delete from
      #Nota_CFOP_ICMS_Isento
    from
      #Nota_CFOP_ICMS_Isento
    inner join
      #Nota_CFOP
    on
      #Nota_CFOP_ICMS_Isento.Chave = #Nota_CFOP.Chave and
      #Nota_CFOP.CodOperICMS = 2

    insert into #Nota_CFOP (
      Chave,
      Grupo,
      GrupoAliq,
      CodOperICMS,
      BCICMS )
    select
      Chave,       
      Grupo,
      AliqICMS,
      CodOperICMS,
      BCICMS
    from
      #Nota_CFOP_ICMS_Isento 

    drop table 
      #Nota_CFOP_ICMS_Isento

    -- Preenchendo com o ICMS Outros (Parametro 3)

    update #Nota_CFOP
      set #Nota_CFOP.CodOperICMS = #Nota_CFOP_ICMS_Outro.CodOperICMS,
	  #Nota_CFOP.BCICMS = #Nota_CFOP_ICMS_Outro.BCICMS,
          #Nota_CFOP.ICMSObs = #Nota_CFOP_ICMS_Outro.ICMSObs
      from
        #Nota_CFOP,
        #Nota_CFOP_ICMS_Outro
      where
        #Nota_CFOP.Chave = #Nota_CFOP_ICMS_Outro.Chave and
        (isnull(#Nota_CFOP.BCICMS,0)=0)

    delete from
      #Nota_CFOP_ICMS_Outro
    from
      #Nota_CFOP_ICMS_Outro
    inner join
      #Nota_CFOP
    on
      #Nota_CFOP_ICMS_Outro.Chave = #Nota_CFOP.Chave and
      #Nota_CFOP.CodOperICMS = 3

    insert into #Nota_CFOP (
      Chave,
      Grupo,
      GrupoAliq,
      CodOperICMS,
      BCICMS,
      ICMSObs )
    select
      Chave,
      Grupo,
      AliqICMS,
      CodOperICMS,
      BCICMS,
      ICMSObs
    from
      #Nota_CFOP_ICMS_Outro

    drop table 
      #Nota_CFOP_ICMS_Outro

    -- Preenchendo o IPI (Parametro 1)

    update #Nota_CFOP
      set #Nota_CFOP.CodOperIPI = #Nota_CFOP_IPI.CodOperIPI,
          #Nota_CFOP.BCIPI = #Nota_CFOP_IPI.BCIPI,
          #Nota_CFOP.IPI = #Nota_CFOP_IPI.IPI,
          #Nota_CFOP.IPIObs = #Nota_CFOP_IPI.IPIObs
      from
        #Nota_CFOP,
        #Nota_CFOP_IPI
      where
        #Nota_CFOP.Chave = #Nota_CFOP_IPI.Chave and
        isnull(#Nota_CFOP.AliqICMS,#Nota_CFOP_IPI.AliqICMS) = #Nota_CFOP_IPI.AliqICMS and
        (isnull(#Nota_CFOP.VlrContabil,0)<>0)

    delete from
      #Nota_CFOP_IPI
    from
      #Nota_CFOP_IPI
    inner join
      #Nota_CFOP
    on
      #Nota_CFOP_IPI.Chave = #Nota_CFOP.Chave and
      #Nota_CFOP.CodOperIPI = 1

    insert into #Nota_CFOP (
      Chave, 
     Grupo,
      GrupoAliq,
      CodOperIPI,
      BCIPI,
      IPIObs )
    select
   Chave,
      Grupo,
      AliqICMS,
      CodOperIPI,
      BCIPI,
      IPIObs
    from
      #Nota_CFOP_IPI

    drop table 
      #Nota_CFOP_IPI
    
    -- Preenchendo com o IPI Isento (Parametro 2)

    update #Nota_CFOP
      set #Nota_CFOP.CodOperIPI = #Nota_CFOP_IPI_Isento.CodOperIPI,
	  #Nota_CFOP.BCIPI      = #Nota_CFOP_IPI_Isento.BCIPI,
          #Nota_CFOP.IPIObs     = #Nota_CFOP_IPI_Isento.IPIObs
      from
        #Nota_CFOP,
        #Nota_CFOP_IPI_Isento
      where
        #Nota_CFOP.Chave = #Nota_CFOP_IPI_Isento.Chave and
        cast(isnull(#Nota_CFOP.AliqICMS,#Nota_CFOP_IPI_Isento.AliqICMS) as decimal(25,2)) = cast(#Nota_CFOP_IPI_Isento.AliqICMS as decimal(25,2)) and
        (isnull(#Nota_CFOP.BCIPI,0)=0) and (isnull(#Nota_CFOP.VlrContabil,0)<>0)-- ELIAS 10/11/2003

    delete from
      #Nota_CFOP_IPI_Isento
    from
      #Nota_CFOP_IPI_Isento
    inner join
      #Nota_CFOP
    on
      #Nota_CFOP_IPI_Isento.Chave = #Nota_CFOP.Chave and
      #Nota_CFOP.CodOperIPI = 2

    insert into #Nota_CFOP (
      Chave, 
      Grupo,
      GrupoAliq,
      CodOperIPI,
      BCIPI )
    select
      Chave,
      Grupo,
      AliqICMS,
      CodOperIPI,
      BCIPI
    from
      #Nota_CFOP_IPI_Isento 

    drop table 
      #Nota_CFOP_IPI_Isento

    -- Preenchendo com o IPI Outros (Parametro 3)

    update #Nota_CFOP
      set #Nota_CFOP.CodOperIPI = #Nota_CFOP_IPI_Outro.CodOperIPI,
	  #Nota_CFOP.BCIPI = #Nota_CFOP_IPI_Outro.BCIPI,
          #Nota_CFOP.IPIObs = #Nota_CFOP_IPI_Outro.IPIObs
      from
        #Nota_CFOP,
        #Nota_CFOP_IPI_Outro
      where
        #Nota_CFOP.Chave = #Nota_CFOP_IPI_Outro.Chave and
        cast(isnull(#Nota_CFOP.AliqICMS,#Nota_CFOP_IPI_Outro.AliqICMS) as decimal(25,2)) = cast(#Nota_CFOP_IPI_Outro.AliqICMS as decimal(25,2)) and
        #Nota_CFOP.CodOperICMS = 1 and
        --Carlos 22.03.2007
        --or #Nota_CFOP.CodOperICMS = 2) and
        (isnull(#Nota_CFOP.BCIPI,0)=0)

    delete from
      #Nota_CFOP_IPI_Outro
    from
      #Nota_CFOP_IPI_Outro
    inner join
      #Nota_CFOP
    on
      #Nota_CFOP_IPI_Outro.Chave = #Nota_CFOP.Chave and
      isnull(#Nota_CFOP.AliqICMS,#Nota_CFOP_IPI_Outro.AliqICMS) = #Nota_CFOP_IPI_Outro.AliqICMS and
     (#Nota_CFOP.CodOperICMS = 1 or #Nota_CFOP.CodOperICMS = 2) and
      #Nota_CFOP.CodOperIPI = 3 

    update #Nota_CFOP
      set #Nota_CFOP.CodOperIPI = #Nota_CFOP_IPI_Outro.CodOperIPI,
	  #Nota_CFOP.BCIPI = #Nota_CFOP_IPI_Outro.BCIPI,
          #Nota_CFOP.IPIObs = #Nota_CFOP_IPI_Outro.IPIObs
      from
        #Nota_CFOP,
        #Nota_CFOP_IPI_Outro
      where
        #Nota_CFOP.Chave = #Nota_CFOP_IPI_Outro.Chave and
        (#Nota_CFOP.CodOperICMS = 3) and (isnull(#Nota_CFOP.BCIPI,0)=0) 
        
    delete from
      #Nota_CFOP_IPI_Outro
    from
      #Nota_CFOP_IPI_Outro
    inner join
      #Nota_CFOP
    on
      #Nota_CFOP_IPI_Outro.Chave = #Nota_CFOP.Chave and
      isnull(#Nota_CFOP.AliqICMS,#Nota_CFOP_IPI_Outro.AliqICMS) = #Nota_CFOP_IPI_Outro.AliqICMS and
      #Nota_CFOP.CodOperIPI = 3

    insert into #Nota_CFOP (
      Chave,
      Grupo,
      GrupoAliq,
      CodOperIPI,
      BCIPI,
      IPIObs )
    select
      Chave,
      Grupo,
      AliqICMS,
      CodOperIPI,
      BCIPI,
      IPIObs
    from
      #Nota_CFOP_IPI_Outro

    drop table 
      #Nota_CFOP_IPI_Outro

    select 
--      (cast(n.Grupo as varchar(1)) + cast('1a00.00' as varchar(8))) as 'TipoRegistro',
      n.*,
      cast(gof.nm_grupo_operacao_fiscal as varchar(50)) as 'nm_grupo_operacao_fiscal'
    from 
      #Nota_CFOP n

      left outer join
      Grupo_Operacao_Fiscal gof on gof.cd_grupo_operacao_fiscal = n.Grupo

    order by 
      Grupo,
      Chave,
      ClassFiscal            desc,
      isnull(CodOperICMS,99) desc,
      isnull(CodOperIPI,99)  desc
         
    drop table 
      #Nota_CFOP

  end

-------------------------------------------------------------------------------
else if @ic_parametro = 4 -- lista resumo p/ estado
-------------------------------------------------------------------------------
  begin

    select
      op.cd_mascara_operacao 				                  as 'CFOP',
      ni.sg_estado		          	       	                  as 'Estado', 
      sum(round(IsNull(ni.vl_cont_reg_nota_entrada,0),2))	          as 'VlrContabil',
      sum(round(IsNull(ni.vl_bicms_reg_nota_entrada,0),2))                as 'BCICMS',	
      sum(round(IsNull(ni.vl_icms_reg_nota_entrada,0),2))	          as 'ICMS',
      sum(round(IsNull(ni.vl_icmsisen_reg_nota_entr,0),2))	as 'ICMSIsento',
      sum(round(IsNull(ni.vl_icmsoutr_reg_nota_entr,0),2))	as 'ICMSOutras',
      sum(round(IsNull(ni.vl_icmsobs_reg_nota_entr,0),2))	as 'ICMSObs',
      sum(round(IsNull(ni.vl_bipi_reg_nota_entrada,0),2))	as 'BCIPI',
      sum(round(IsNUll(ni.vl_ipi_reg_nota_entrada,0),2))	as 'IPI',
      sum(round(IsNUll(ni.vl_ipiisen_reg_nota_entr,0),2))	as 'IPIIsento',
      sum(round(IsNUll(ni.vl_ipioutr_reg_nota_entr,0),2))	as 'IPIOutras',
      sum(round(IsNull(ni.vl_ipiobs_reg_nota_entr,0),2))	as 'IPIObs',
      isnull(op.ic_contribicms_op_fiscal, 'S')  	        as 'ContrICMS'
     into
       #ResumoEstado
 
    from
      Nota_Entrada_Item_Registro ni
      left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ni.dt_receb_nota_entrada between @dt_inicial and @dt_final and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      --isnull(op.ic_opinterestadual_op_fis,'N') = 'S' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
    group by
      isnull(op.ic_contribicms_op_fiscal, 'S'),
      op.cd_mascara_operacao,
      ni.sg_estado

    union all

    select
      op.cd_mascara_operacao 				                  as 'CFOP',
      n.sg_estado_nota_saida            	       	                  as 'Estado', 
      sum(IsNull(ni.vl_contabil_item_nota,0))          as 'VlrContabil',
      sum(IsNull(ni.vl_base_icms_item_nota,0))         as 'BCICMS',	
      sum(IsNull(ni.vl_icms_item_nota_saida,0))        as 'ICMS',
      sum(IsNull(ni.vl_icms_isento_item_nota,0))       as 'ICMSIsento',
      sum(IsNull(ni.vl_icms_outras_item_nota,0))       as 'ICMSOutras',
      sum(IsNull(ni.vl_icms_obs_item_nota,0))          as 'ICMSObs',
      sum(IsNull(ni.vl_base_ipi_item_nota,0))          as 'BCIPI',
      sum(IsNUll(ni.vl_ipi_item_nota_saida,0))	       as 'IPI',
      sum(IsNUll(ni.vl_ipi_isento_item_nota,0))        as 'IPIIsento',
      sum(IsNUll(ni.vl_ipi_outras_item_nota,0))        as 'IPIOutras',
      sum(IsNull(ni.vl_ipi_obs_item_nota,0))	       as 'IPIObs',

      isnull(op.ic_contribicms_op_fiscal, 'S')  	        as 'ContrICMS'
    from
      Nota_Saida_Item_Registro ni  with (nolock) 
      left outer join Nota_Saida n with (nolock) on n.cd_nota_saida        = ni.cd_nota_saida
      left outer join Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      n.dt_nota_saida between @dt_inicial and @dt_final and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      --isnull(op.ic_opinterestadual_op_fis,'N') = 'S' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
      and
      @ic_nf_entrada_livro_entrada = 'S'
    group by
      isnull(op.ic_contribicms_op_fiscal, 'S'),
      op.cd_mascara_operacao,
      n.sg_estado_nota_saida
 
    --Mostra a Tabela Final
    select
      *
    from
      #ResumoEstado
  
    order by
      CFOP,
      Estado

  end

-------------------------------------------------------------------------------
else if @ic_parametro = 5 -- Lista Livro Fiscal, Para Consulta - ELIAS 18/11/2003
-------------------------------------------------------------------------------
  begin

    select
      ni.dt_receb_nota_entrada                         as 'Entrada',
      n.nm_especie_nota_entrada                        as 'SubSerie',
      ni.sg_serie_nota_fiscal                          as 'Especie',
      ni.cd_nota_entrada                               as 'Numero',
      ni.dt_nota_entrada                               as 'Data',

      case when @ic_tipo_emitente_livro='1' then
        
        ( select top 1 substring(replace(f.cd_cnpj,'.',''),1,8) from vw_destinatario f 
          where
            ni.cd_destinatario      = f.cd_destinatario and
            ni.cd_tipo_destinatario = f.cd_tipo_destinatario )  
      else
      cast(ni.cd_destinatario as varchar(6)) + '/' +
        cast(ni.cd_tipo_destinatario as char(1)) 
      end                                              as 'Emitente',

--       cast(ni.cd_destinatario as varchar(6)) + '/' +
--         cast(ni.cd_tipo_destinatario as char(1))       as 'Emitente',

      n.nm_fantasia_destinatario                       as 'Fantasia',
      ni.sg_estado                                     as 'UF',
      sum(IsNull(ni.vl_cont_reg_nota_entrada,0))       as 'VlrContabil',

      op.cd_mascara_operacao 			       as 'CFOP',
      cast(null as varchar(20))                        as 'ClassContabil',
      sum(IsNull(ni.vl_bicms_reg_nota_entrada,0))      as 'BCICMS',	
      -- ELIAS 15/03/2004
      isnull(ni.pc_icms_reg_nota_entrada,0)            as 'AliqICMS',
      sum(IsNull(ni.vl_icms_reg_nota_entrada,0))       as 'ICMS',
      sum(IsNull(ni.vl_icmsisen_reg_nota_entr,0))      as 'ICMSIsento',
      sum(IsNull(ni.vl_icmsoutr_reg_nota_entr,0))      as 'ICMSOutras',
      sum(IsNull(ni.vl_icmsobs_reg_nota_entr,0))       as 'ICMSObs',
      sum(IsNull(ni.vl_bipi_reg_nota_entrada,0))       as 'BCIPI',
      sum(IsNUll(ni.vl_ipi_reg_nota_entrada,0))	       as 'IPI',
      sum(IsNUll(ni.vl_ipiisen_reg_nota_entr,0))       as 'IPIIsento',
      sum(IsNUll(ni.vl_ipioutr_reg_nota_entr,0))       as 'IPIOutras',
      sum(IsNull(ni.vl_ipiobs_reg_nota_entr,0))	       as 'IPIObs',
      max(isnull(ni.nm_obsicms_reg_nota_entr,op.nm_obs_livro_operacao)) 
                                                       as 'ObservacaoICMS',
      max(isnull(ni.nm_obsipi_reg_nota_entr,op.nm_obs_livro_operacao)) 
                                                       as 'ObservacaoIPI',
      max(ni.cd_rem)                                   as 'REM'

    into
      #LivroEntrada

    from
      Nota_Entrada_Item_Registro ni with (nolock) 
      left outer join
      Nota_Entrada n
    on
      n.cd_nota_entrada      = ni.cd_nota_entrada and
      n.cd_fornecedor        = ni.cd_fornecedor and
      n.cd_operacao_fiscal   = ni.cd_operacao_fiscal and
      n.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join Grupo_Operacao_Fiscal gop on gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ni.dt_receb_nota_entrada between @dt_inicial and @dt_final and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
    group by
      ni.dt_receb_nota_entrada,
      n.nm_especie_nota_entrada,
      ni.sg_serie_nota_fiscal,
      ni.cd_nota_entrada,
      ni.dt_nota_entrada,
      ni.cd_destinatario,
      ni.cd_tipo_destinatario,
      n.nm_fantasia_destinatario,
      ni.sg_estado,
      op.cd_operacao_fiscal,
      op.cd_mascara_operacao,
      -- ELIAS 15/03/2004
      isnull(ni.pc_icms_reg_nota_entrada,0)

--     order by
--       ni.dt_receb_nota_entrada,
--   op.cd_mascara_operacao,
--       ni.cd_nota_entrada,
--       -- ELIAS 15/03/2004
--       isnull(ni.pc_icms_reg_nota_entrada,0)

    -- ELIAS 20/09/2004 - Gerado Tabela Temporária #LivroEntrada
    -- para Cálculo das Diferenças de ICMS e IPI

    union all

    select
      n.dt_nota_saida                                   as 'Entrada',
      snf.nm_especie_livro_saida                        as 'SubSerie',
      snf.sg_serie_nota_fiscal                          as 'Especie',
      max(case when isnull(n.cd_identificacao_nota_saida,0)>0 then
        n.cd_identificacao_nota_saida
      else
        n.cd_nota_saida                               
      end)                                               as 'Numero',

      n.dt_nota_saida                                   as 'Data',

      case when @ic_tipo_emitente_livro='1' then
        
        ( select top 1 substring(replace(f.cd_cnpj,'.',''),1,8) from vw_destinatario f 
          where
            n.cd_cliente           = f.cd_destinatario and
            n.cd_tipo_destinatario = f.cd_tipo_destinatario )  
      else

      cast(n.cd_cliente as varchar(6)) + '/' +
        cast(n.cd_tipo_destinatario as char(1)) 
      end                                              as 'Emitente',

--       cast(ni.cd_destinatario as varchar(6)) + '/' +
--         cast(ni.cd_tipo_destinatario as char(1))       as 'Emitente',

      n.nm_fantasia_destinatario                       as 'Fantasia',
      n.sg_estado_nota_saida                           as 'UF',
      sum(IsNull(ni.vl_contabil_item_nota,0))          as 'VlrContabil',
      op.cd_mascara_operacao 			       as 'CFOP',

      cast(null as varchar(20))                        as 'ClassContabil',
      sum(IsNull(ni.vl_base_icms_item_nota,0))         as 'BCICMS',	
      isnull(ni.pc_icms_item_nota_saida,0)             as 'AliqICMS',

      sum(IsNull(ni.vl_icms_item_nota_saida,0))        as 'ICMS',
      sum(IsNull(ni.vl_icms_isento_item_nota,0))       as 'ICMSIsento',
      sum(IsNull(ni.vl_icms_outras_item_nota,0))       as 'ICMSOutras',
      sum(IsNull(ni.vl_icms_obs_item_nota,0))          as 'ICMSObs',
      sum(IsNull(ni.vl_base_ipi_item_nota,0))          as 'BCIPI',
      sum(IsNUll(ni.vl_ipi_item_nota_saida,0))	       as 'IPI',
      sum(IsNUll(ni.vl_ipi_isento_item_nota,0))        as 'IPIIsento',
      sum(IsNUll(ni.vl_ipi_outras_item_nota,0))        as 'IPIOutras',
      sum(IsNull(ni.vl_ipi_obs_item_nota,0))	       as 'IPIObs',
      max(op.nm_obs_livro_operacao)                    as 'ObservacaoICMS',
      max(op.nm_obs_livro_operacao)                    as 'ObservacaoIPI',
      0                                                as 'REM'

    from
      Nota_Saida_Item_Registro ni with (nolock) 
      left outer join
      Nota_Saida n
    on
      n.cd_nota_saida        = ni.cd_nota_saida
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join Grupo_Operacao_Fiscal gop on gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    left outer join Serie_Nota_Fiscal snf     on snf.cd_serie_nota_fiscal     = n.cd_serie_nota

    where
      n.dt_nota_saida between @dt_inicial and @dt_final and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
      and
      @ic_nf_entrada_livro_entrada = 'S'

    group by
      n.dt_nota_saida,
      snf.nm_especie_livro_saida,
      snf.sg_serie_nota_fiscal,
      n.cd_nota_saida,
      n.dt_nota_saida,
      n.cd_cliente,
      n.cd_tipo_destinatario,
      n.nm_fantasia_destinatario,
      n.sg_estado_nota_saida,
      op.cd_operacao_fiscal,
      op.cd_mascara_operacao,
      -- ELIAS 15/03/2004
      isnull(ni.pc_icms_item_nota_saida,0)

--select * from nota_saida_item_registro
--select * from nota_saida
--select * from serie_nota_fiscal


    --Mostra a tabela final

    select *, 
    cast(BCICMS+ICMSIsento+ICMSOutras+ICMSObs+IPIObs+IPI-VlrContabil as decimal(25,2))   as 'DifICMS',
      cast(BCIPI+IPI+IPIIsento+IPIOutras+IPIObs-VlrContabil as decimal(25,2))            as 'DifIPI'
    from
      #LivroEntrada
    order by
      Entrada,
      CFOP,
      Data,
      AliqICMS


  end
----------------------------------------------------------------------------------------
else if @ic_parametro = 6 -- Lista Resumo por CFOP, Para Consulta - ALEXANDRE 29/01/2004
----------------------------------------------------------------------------------------
  begin

    --Nota de Entrada

    select
      sum(IsNull(ni.vl_cont_reg_nota_entrada,0))       as 'VlrContabil',
      op.cd_mascara_operacao 			       							 as 'CFOP',
      cast(null as varchar(20))                        as 'ClassContabil',
      sum(IsNull(ni.vl_bicms_reg_nota_entrada,0))      as 'BCICMS',	
      -- ELIAS 15/03/2004
      isnull(ni.pc_icms_reg_nota_entrada,0)            as 'AliqICMS',
      sum(IsNull(ni.vl_icms_reg_nota_entrada,0))       as 'ICMS',
      sum(IsNull(ni.vl_icmsisen_reg_nota_entr,0))      as 'ICMSIsento',
      sum(IsNull(ni.vl_icmsoutr_reg_nota_entr,0))      as 'ICMSOutras',
      sum(IsNull(ni.vl_icmsobs_reg_nota_entr,0))       as 'ICMSObs',
      sum(IsNull(ni.vl_bipi_reg_nota_entrada,0))       as 'BCIPI',
      sum(IsNUll(ni.vl_ipi_reg_nota_entrada,0))	       as 'IPI',
      sum(IsNUll(ni.vl_ipiisen_reg_nota_entr,0))       as 'IPIIsento',
      sum(IsNUll(ni.vl_ipioutr_reg_nota_entr,0))       as 'IPIOutras',
      sum(IsNull(ni.vl_ipiobs_reg_nota_entr,0))	       as 'IPIObs',
      max(isnull(ni.nm_obsicms_reg_nota_entr,op.nm_obs_livro_operacao)) 
                                                       as 'ObservacaoICMS',
      max(isnull(ni.nm_obsipi_reg_nota_entr,op.nm_obs_livro_operacao)) 
                                                       as 'ObservacaoIPI',
      max(ni.cd_rem)	                               as 'REM'

    into
      #ResumoCFOP

    from
      Nota_Entrada_Item_Registro ni  with (nolock) 
      left outer join Nota_Entrada n with (nolock) 
    on
      n.cd_nota_entrada      = ni.cd_nota_entrada and
      n.cd_fornecedor        = ni.cd_fornecedor and
      n.cd_operacao_fiscal   = ni.cd_operacao_fiscal and
      n.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ni.dt_receb_nota_entrada between @dt_inicial and @dt_final and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
    group by
      op.cd_mascara_operacao,
      -- ELIAS 15/03/2004
      isnull(ni.pc_icms_reg_nota_entrada,0)
--     order by
--       op.cd_mascara_operacao,
--       -- ELIAS 15/03/2004
--       isnull(ni.pc_icms_reg_nota_entrada,0)

   union all

    --Nota de Entrada

    select
      sum(IsNull(ni.vl_contabil_item_nota,0))          as 'VlrContabil',
      op.cd_mascara_operacao                           as 'CFOP',
      cast(null as varchar(20))                        as 'ClassContabil',
      sum(IsNull(ni.vl_base_icms_item_nota,0))         as 'BCICMS',	
      -- ELIAS 15/03/2004
      isnull(ni.pc_icms_item_nota_saida,0)             as 'AliqICMS',
      sum(IsNull(ni.vl_icms_item_nota_saida,0))        as 'ICMS',
      sum(IsNull(ni.vl_icms_isento_item_nota,0))       as 'ICMSIsento',
      sum(IsNull(ni.vl_icms_outras_item_nota,0))       as 'ICMSOutras',
      sum(IsNull(ni.vl_icms_obs_item_nota,0))          as 'ICMSObs',
      sum(IsNull(ni.vl_base_ipi_item_nota,0))          as 'BCIPI',
      sum(IsNUll(ni.vl_ipi_item_nota_saida,0))	       as 'IPI',
      sum(IsNUll(ni.vl_ipi_isento_item_nota,0))        as 'IPIIsento',
      sum(IsNUll(ni.vl_ipi_outras_item_nota,0))        as 'IPIOutras',
      sum(IsNull(ni.vl_ipi_obs_item_nota,0))	       as 'IPIObs',
      max(op.nm_obs_livro_operacao)                    as 'ObservacaoICMS',
      max(op.nm_obs_livro_operacao)                    as 'ObservacaoIPI',
      0                                                as 'REM'

    from
      Nota_Saida_Item_Registro ni  with (nolock) 
      left outer join Nota_Saida n with (nolock) 
    on
      n.cd_nota_saida        = ni.cd_nota_saida      
      left outer join Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = n.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
--select * from nota_saida_item_registro
    where
      n.dt_nota_saida between @dt_inicial and @dt_final and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
      and
      @ic_nf_entrada_livro_entrada = 'S'

    group by
      op.cd_mascara_operacao,
      -- ELIAS 15/03/2004
      isnull(ni.pc_icms_item_nota_saida,0)


    --Nota Fiscal de Saída --> Entrada de Importação <--


    -- ELIAS 20/09/2004 - Gerado Tabela Temporária #ResumoCFOP
    -- para Cálculo das Diferenças de ICMS e IPI
    select *,
      cast(BCICMS+ICMSIsento+ICMSOutras+ICMSObs+IPIObs+IPI-VlrContabil as decimal(25,2)) as 'DifICMS',
      cast(BCIPI+IPI+IPIIsento+IPIOutras+IPIObs-VlrContabil            as decimal(25,2)) as 'DifIPI'
    from
      #ResumoCFOP
    order by
      CFOP,      
      AliqICMS

  end

----------------------------------------------------------------------------------------
else if @ic_parametro = 7 -- Lista Resumo por CFOP, Para Consulta - ALEXANDRE 29/01/2004
----------------------------------------------------------------------------------------
  begin

    select

      sum(IsNull(ni.vl_cont_reg_nota_entrada,0))       as 'VlrContabil',
      op.cd_mascara_operacao 			       							 as 'CFOP',
      cast(null as varchar(20))                        as 'ClassContabil',
      sum(IsNull(ni.vl_bicms_reg_nota_entrada,0))      as 'BCICMS',	
      sum(IsNull(ni.vl_icms_reg_nota_entrada,0))       as 'ICMS',
      sum(IsNull(ni.vl_icmsisen_reg_nota_entr,0))      as 'ICMSIsento',
      sum(IsNull(ni.vl_icmsoutr_reg_nota_entr,0))      as 'ICMSOutras',
      sum(IsNull(ni.vl_icmsobs_reg_nota_entr,0))       as 'ICMSObs',
      sum(IsNull(ni.vl_bipi_reg_nota_entrada,0))       as 'BCIPI',
      sum(IsNUll(ni.vl_ipi_reg_nota_entrada,0))	       as 'IPI',
      sum(IsNUll(ni.vl_ipiisen_reg_nota_entr,0))       as 'IPIIsento',
      sum(IsNUll(ni.vl_ipioutr_reg_nota_entr,0))       as 'IPIOutras',
      sum(IsNull(ni.vl_ipiobs_reg_nota_entr,0))	       as 'IPIObs',
      max(isnull(ni.nm_obsicms_reg_nota_entr,op.nm_obs_livro_operacao)) 
                                                       as 'ObservacaoICMS',
      max(isnull(ni.nm_obsipi_reg_nota_entr,op.nm_obs_livro_operacao)) 
                                                       as 'ObservacaoIPI'
    into
      #CFOP

    from
      Nota_Entrada_Item_Registro ni with (nolock) 
      left outer join Nota_Entrada n
    on
      n.cd_nota_entrada      = ni.cd_nota_entrada and
      n.cd_fornecedor        = ni.cd_fornecedor and
      n.cd_operacao_fiscal   = ni.cd_operacao_fiscal and
      n.cd_serie_nota_fiscal = ni.cd_serie_nota_fiscal
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      ni.dt_receb_nota_entrada between @dt_inicial and @dt_final and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
    group by
      op.cd_mascara_operacao

    union all

    select
--      sum(IsNull(ni.vl_cont_reg_nota_entrada,0))       as 'VlrContabil',
      sum(IsNull(ni.vl_contabil_item_nota,0))          as 'VlrContabil',

      op.cd_mascara_operacao 			       							 as 'CFOP',
      cast(null as varchar(20))                        as 'ClassContabil',
--       sum(IsNull(ni.vl_bicms_reg_nota_entrada,0))      as 'BCICMS',	
--       sum(IsNull(ni.vl_icms_reg_nota_entrada,0))       as 'ICMS',
--       sum(IsNull(ni.vl_icmsisen_reg_nota_entr,0))      as 'ICMSIsento',
--       sum(IsNull(ni.vl_icmsoutr_reg_nota_entr,0))      as 'ICMSOutras',
--       sum(IsNull(ni.vl_icmsobs_reg_nota_entr,0))       as 'ICMSObs',
--       sum(IsNull(ni.vl_bipi_reg_nota_entrada,0))       as 'BCIPI',
--       sum(IsNUll(ni.vl_ipi_reg_nota_entrada,0))	       as 'IPI',
--       sum(IsNUll(ni.vl_ipiisen_reg_nota_entr,0))       as 'IPIIsento',
--       sum(IsNUll(ni.vl_ipioutr_reg_nota_entr,0))       as 'IPIOutras',
--       sum(IsNull(ni.vl_ipiobs_reg_nota_entr,0))	       as 'IPIObs',

      sum(IsNull(ni.vl_base_icms_item_nota,0))         as 'BCICMS',	
      sum(IsNull(ni.vl_icms_item_nota_saida,0))        as 'ICMS',
      sum(IsNull(ni.vl_icms_isento_item_nota,0))       as 'ICMSIsento',
      sum(IsNull(ni.vl_icms_outras_item_nota,0))       as 'ICMSOutras',
      sum(IsNull(ni.vl_icms_obs_item_nota,0))          as 'ICMSObs',
      sum(IsNull(ni.vl_base_ipi_item_nota,0))          as 'BCIPI',
      sum(IsNUll(ni.vl_ipi_item_nota_saida,0))	       as 'IPI',
      sum(IsNUll(ni.vl_ipi_isento_item_nota,0))        as 'IPIIsento',
      sum(IsNUll(ni.vl_ipi_outras_item_nota,0))        as 'IPIOutras',
      sum(IsNull(ni.vl_ipi_obs_item_nota,0))	       as 'IPIObs',

      max(op.nm_obs_livro_operacao)                    as 'ObservacaoICMS',
      max(op.nm_obs_livro_operacao)                    as 'ObservacaoIPI'

    from
      Nota_Saida_Item_Registro ni with (nolock) 
      left outer join Nota_Saida n
    on
      n.cd_nota_saida     = ni.cd_nota_saida 
    left outer join
      Operacao_Fiscal op
    on
      op.cd_operacao_fiscal = ni.cd_operacao_fiscal
    left outer join
      Grupo_Operacao_Fiscal gop
    on
      gop.cd_grupo_operacao_fiscal = op.cd_grupo_operacao_fiscal
    where
      n.dt_nota_saida between @dt_inicial and @dt_final and
      isnull(op.ic_destaca_vlr_livro_op_f,'S') = 'S' and
      -- Comentado, devido a visualização de NFE de Serviço no Livro de Entradas 
      -- a partir de 01/01/2005 - ELIAS 17/01/2005
      -- isnull(op.ic_servico_operacao,'N') = 'N' and
      gop.cd_tipo_operacao_fiscal = 1  -- ENTRADAS
      and
      @ic_nf_entrada_livro_entrada = 'S'
    group by
      op.cd_mascara_operacao


    ---------------------------------------------------------------------------------------
    --- Gerado Tabela Temporária #CFOP
    ---------------------------------------------------------------------------------------

    --  Cálculo das Diferenças de ICMS e IPI
    select *,
      cast(BCICMS+ICMSIsento+ICMSOutras+ICMSObs  +IPIObs+IPI-VlrContabil as decimal(25,2)) as 'DifICMS',
      cast(BCIPI +IPI       +IPIIsento +IPIOutras+IPIObs-VlrContabil            as decimal(25,2)) as 'DifIPI'
    from
      #CFOP
    order by
      CFOP

  end
else
  return
  
