
CREATE  PROCEDURE pr_saldo_inicial
@ic_parametro     int,
@dt_inicial       datetime,
@dt_final         datetime,        
@cd_produto       int,
@cd_fase_produto  int,
@vl_saldo_inicial float output

as

----------------------------------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda            2002
----------------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Daniel Duela
--Banco de Dados: EgisSql
--Objetivo: Achar o Saldo Inicial de uma determinada data
--Data:
--Atualizado: 04/07/2002
--            08/07/2003 - Acerto da data a ser pesquisada na produto_fechamento - ELIAS
--            02/12/2003 - O sistema estava calculando erroneamente o data de fechamento
--                         quando o mês era Dezembro - Eduardo
-- 26/04/2004 - Refeito cálculo para Saldo Inicial quando não coincide com a data de fechamento
-- anterior. - Daniel C. Neto: Fechamento Anterior = Anterior + Mov. Entrada - Mov. Saída
-- 26/05/2004 - Acerto no período pesquisado que deve ser da data do fechamento até o dia 
--              imediatamente anterior a data final - ELIAS
--              Comentado vários prints que atrapalhavam na execução - ELIAS
-- 08/12/2005 - Reformulação para buscar o saldo inicial sempre baseado no saldo atual do produto
--              ELIAS
-- 07.12.2009 - Ajustes Diversos - Carlos Fernandes
-- 23.03.2010 - Ajustes Diversos - Carlos Fernandes
----------------------------------------------------------------------------------------------------------

declare 
@dt_produto_fechamento      datetime,
@vl_saldo_fechamento        float,
@qt_entrada                 float,
@qt_saida                   float,
@dt_saldo_fechamento        datetime

set @dt_produto_fechamento  = ''
set @vl_saldo_fechamento    = 0.00
set @dt_saldo_fechamento    = dateadd(dd,-1,@dt_inicial)
set @qt_saida               = 0
set @qt_entrada             = 0

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Acha o Saldo Inicial de acordo com o Produto, Fase,
                        -- data inicial e final
-------------------------------------------------------------------------------
begin

  select 

    @vl_saldo_inicial =

    -- SALDO ATUAL - SEM MOVIMENTAÇÕES APÓS O PERÍODO

    (select 
       isnull(ps.qt_saldo_atual_produto,0) 

       -

--       case when (count(me.cd_movimento_estoque)) > 0 then

         isnull((select sum(case when tme.ic_mov_tipo_movimento = 'E'
                          then isnull(mex.qt_movimento_estoque,0)
                          else 0 end) -

                      sum(case when tme.ic_mov_tipo_movimento =  'S'
                          then isnull(mex.qt_movimento_estoque,0)
                          else 0 end) 
               from 
                 Movimento_Estoque mex                 with (nolock) 
                 inner join Tipo_Movimento_Estoque tme with (NOLOCK) 
                            on tme.cd_tipo_movimento_estoque = mex.cd_tipo_movimento_estoque

               where
                  --Antes 06/07/2010
                  mex.dt_movimento_estoque > @dt_final and

                  --me.dt_movimento_estoque between @dt_inicial and @dt_final and

                 ((tme.cd_tipo_movimento_estoque = 1  ) or ((tme.nm_atributo_produto_saldo = 'qt_saldo_atual_produto') or
                 (tme.nm_atributo_produto_saldo  = '')) or
                 (tme.nm_atributo_produto_saldo  = 'qt_saldo_atual_produto' and mex.ic_tipo_lancto_movimento='M')) and
                 mex.cd_produto = @cd_produto and cd_fase_produto = @cd_fase_produto),0)
 
--         else
--           0.00
--         end

     from 
        Produto_Saldo ps with (nolock) 

     where 
       ps.cd_produto      = @cd_produto       and
       ps.cd_fase_produto = @cd_fase_produto)  

    -

    -- ENTRADAS NO PERÍODO
    isnull(sum(case when tme.ic_mov_tipo_movimento = 'E'
             then me.qt_movimento_estoque
             else 0 end),0) +

    -- SAIDAS NO PERIODO
    isnull(sum(case when tme.ic_mov_tipo_movimento =  'S'
        then me.qt_movimento_estoque
        else 0 end),0)

--    @qt_entrada =  isnull(sum(case when tme.ic_mov_tipo_movimento = 'E'
--              then me.qt_movimento_estoque
--              else 0 end),0),
-- 
--    @qt_saida   =      isnull(sum(case when tme.ic_mov_tipo_movimento =  'S'
--         then me.qt_movimento_estoque
--         else 0 end),0)



  from
    Movimento_Estoque me                  with (NOLOCK) 
    inner join Tipo_Movimento_Estoque tme with (NOLOCK) on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque

  where
     me.dt_movimento_estoque between @dt_inicial and @dt_final and

    ((tme.cd_tipo_movimento_estoque = 1)   or ((tme.nm_atributo_produto_saldo = 'qt_saldo_atual_produto') or
     (tme.nm_atributo_produto_saldo = '')) or
    (tme.nm_atributo_produto_saldo  = 'qt_saldo_atual_produto' and me.ic_tipo_lancto_movimento='M')) and

    cd_produto      = @cd_produto and
    cd_fase_produto = @cd_fase_produto

--   select @qt_saida,@qt_entrada

--select @dt_saldo_fechamento


   --Verifica se Houve Fechamento Mensal---------------------------------------------------------

   select
     @vl_saldo_fechamento = isnull(qt_atual_prod_fechamento,0)

   from
     produto_fechamento pf with (nolock) 

   where
     pf.cd_produto            = @cd_produto          and
     pf.cd_fase_produto       = @cd_fase_produto     and
     pf.dt_produto_fechamento = @dt_saldo_fechamento 

   if @vl_saldo_inicial <> @vl_saldo_fechamento  --and @vl_saldo_fechamento<=0
      set @vl_saldo_inicial = @vl_saldo_fechamento

 
end

