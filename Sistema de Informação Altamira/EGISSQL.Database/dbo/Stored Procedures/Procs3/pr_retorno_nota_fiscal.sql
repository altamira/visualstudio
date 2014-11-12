
------------------------------------------------------------------------------------------
--pr_retorno_nota_fiscal
------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Elias P. da Silva
--Banco de Dados: EGISSQL 
--Objetivo      : Listar as Informações dos Itens Retornados na Nota Fiscal
--Data          : 08/12/2004
--Atualizado    : 08/04/2005 - Acertos gerais - ELIAS
--              : 04/05/2005 - Acerto no retorno Parcial/Total - ELIAS 
--              : 04.10.2005 - Acerto do Destinatario - Rafael
--              : 14.07.2007 - Total das Quantidades de Retorno - Carlos Fernandes  
--              : 03.10.2007 - Acerto para mostrar as notas fiscais quando mais de 1 nota no retorno
-- 07.04.2008 - Ajuste na impressão do retorno - Carlos Fernandes
-- 03.09.2008 - Montagem de uma tabela auxiliar com o Retorno - Carlos Fernandes
-- 06.02.2009 - Acerto da correta do cliente - Carlos Fernandes
----------------------------------------------------------------------------------------------------

CREATE  PROCEDURE pr_retorno_nota_fiscal
@ic_parametro        int         = 0,
@nm_fantasia_empresa varchar(20) = '',
@cd_nota_fiscal      int         = 0

as  

  --select * from movimento_produto_terceiro where cd_movimento_origem = 33451

  select sum(qt_movimento_terceiro) as qt_movimento_saida, 
    isnull(cd_movimento_origem, (select top 1 cd_movimento_origem 
                                 from movimento_produto_terceiro with (nolock) 
                                 where cd_nota_saida = @cd_nota_fiscal and
                                       cd_movimento_origem is not null)) as cd_movimento_origem
  into
        #MPTS
  from
        movimento_produto_terceiro with (nolock) 
  where 
       cd_nota_saida = @cd_nota_fiscal
  group by 
       cd_movimento_origem


--  select * from #MPTS

--select sum(qt_movimento_saida) as qt_total_saida from #mpts

-- Tabelas Temporarias

  select 
    cd_movimento_origem, 
    sum(cast(0 as float)) as qt_movimento_terceiro,
    ic_tipo_movimento,
    cd_nota_saida 
  into #tmp
  from 
    movimento_produto_terceiro  with (nolock) 
  where 
    cd_nota_saida = @cd_nota_fiscal
  group by cd_movimento_origem,
           ic_tipo_movimento,
           cd_nota_saida 


  --select * from #tmp

  select 
    a.cd_movimento_origem, 
    sum( isnull(mpt.qt_movimento_terceiro,0) ) as qt_movimento_terceiro
  into #tmp2
  from 
    #tmp a,
    movimento_produto_terceiro mpt with (nolock) 
  where 
    a.cd_movimento_origem     = mpt.cd_movimento_origem 
    and mpt.ic_tipo_movimento = 'S' 
    and mpt.cd_nota_saida < @cd_nota_fiscal
  group by 
    a.cd_movimento_origem

  --select * from #tmp2

  update 
    #tmp 
  set 
    qt_movimento_terceiro = b.qt_movimento_terceiro
  from 
    #tmp a,
    #tmp2 b
  where 
    a.cd_movimento_origem = b.cd_movimento_origem 

  --select * from #tmp

-- Tabelas Temporárias

  select
    @cd_nota_fiscal                  as cd_nota_saida,
         nei.cd_item_nota_entrada    as ITEM,
         --ne.cd_nota_entrada          as NF,
         --03.10.2007 - Carlos

         (select top 1 cd_nota_entrada 
          from movimento_produto_terceiro with (nolock) 
          where 
             cd_movimento_produto_terceiro = mpts.cd_movimento_origem )

                                     as NF,
         ne.dt_nota_entrada          as DATA,
         nei.cd_produto,
         p.cd_mascara_produto,
         p.nm_fantasia_produto,
         qt_movimento_entrada,
         qt_movimento_saida,
         mptt.qt_movimento_terceiro                           as qt_movimento_parcial,
         nei.vl_item_nota_entrada,
         cast((nei.vl_item_nota_entrada * 
         isnull(mpts.qt_movimento_saida,0)) as decimal(25,2)) as VALOR,
         case when (isnull(mpte.qt_movimento_entrada,0) <= (isnull(mpts.qt_movimento_saida,0) + isnull(mptt.qt_movimento_terceiro,0)))
         then CAST('TOTAL'   AS VARCHAR(15))
         else CAST('PARCIAL' AS VARCHAR(15)) end          as SALDO
  into
    #Retorno

  from 
       nota_entrada      ne  with (nolock),
       nota_entrada_item nei with (nolock),

       -- Quantidade do Movimento de Entrada 

       (select cd_movimento_produto_terceiro,
               cd_nota_entrada, 
               cd_destinatario, 
               cd_tipo_destinatario, 
               cd_operacao_fiscal,
               cd_serie_nota_fiscal,
               qt_movimento_terceiro as qt_movimento_entrada,
               cd_produto,
               cd_item_nota_fiscal
        from movimento_produto_terceiro with(nolock)
        where 
            cd_movimento_produto_terceiro in (select cd_movimento_origem 
                                              from 
                                                movimento_produto_terceiro with(nolock)
                                              where cd_nota_saida = @cd_nota_fiscal)) mpte,

       -- Quantidade da Saída desta Nota Fiscal 

       (select cd_movimento_origem, sum(qt_movimento_saida) as qt_movimento_saida
        from #MPTS
        group by cd_movimento_origem) mpts,

       -- Quantidade Movimentada em Notas de Saída Anteriores

       #tmp mptt,
       Produto p

  where
        ne.cd_nota_entrada             = nei.cd_nota_entrada                and
        ne.cd_fornecedor               = nei.cd_fornecedor                  and
        ne.cd_operacao_fiscal          = nei.cd_operacao_fiscal             and
        ne.cd_serie_nota_fiscal        = nei.cd_serie_nota_fiscal           and
        nei.cd_nota_entrada            = mpte.cd_nota_entrada               and
        nei.cd_item_nota_entrada       = mpte.cd_item_nota_fiscal           and
        ne.cd_destinatario_faturamento = mpte.cd_destinatario               and  
        ne.cd_tipo_destinatario_fatura = mpte.cd_tipo_destinatario          and  
        nei.cd_operacao_fiscal         = mpte.cd_operacao_fiscal            and
        nei.cd_serie_nota_fiscal       = mpte.cd_serie_nota_fiscal          and
        mpts.cd_movimento_origem       = mpte.cd_movimento_produto_terceiro and

        --** Atenção **
        --Carlos 11.12.2007
        --Para Plaspint comentar a linha abaixo e outros cliente descomentar
        --Devido ao Recebimento do Produto Logística ( Baixa em outro Código )
        
        nei.cd_produto           in (mpte.cd_produto) and 

        mptt.cd_movimento_origem = mpte.cd_movimento_produto_terceiro and
        nei.cd_produto           = p.cd_produto

--    group by nei.cd_item_nota_entrada, ne.cd_nota_entrada, ne.dt_nota_entrada

--   select * from #Retorno

declare @vl_total_retorno decimal(25,2)

select
  @vl_total_retorno = sum(isnull(valor,0))
from
  #retorno

insert into
  #Retorno
select
  top 1 
  cd_nota_saida,  
  ITEM,
  99999999,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  @vl_total_retorno,
  'TOTAL RETORNO'
from
  #Retorno

select 
  *
--   ITEM,
--   CASE WHEN NF = 99999999 
--   THEN 0
--   ELSE NF
--   END AS NF,
--   DATA,
--   cd_produto,
--   cd_mascara_produto,
--   nm_fantasia_produto,
--   qt_movimento_entrada,
--   qt_movimento_parcial,
--   vl_item_nota_entrada,
--   VALOR,
--   SALDO
from 
  #Retorno
order by
  nf

--Atualiza a Tabela temporária

-- if exists ( select top 1 cd_nota_saida from nota_saida_retorno where cd_nota_saida = @cd_nota_fiscal )
-- begin
--   delete from nota_saida_retorno where cd_nota_saida = @cd_nota_fiscal
-- 
--   insert into
--     nota_saida_retorno
--   select
--     * 
--   from
--     #Retorno
-- end
-- else
--   if not exists ( select top 1 cd_nota_saida from #Retorno )
-- 
--   --Mostra a Tabela Temporária
-- 
--   begin
--     select
--       *
--     from
--       Nota_Saida_Retorno
--     where
--       cd_nota_saida = @cd_nota_fiscal
--     order by
--       nf
--   end

