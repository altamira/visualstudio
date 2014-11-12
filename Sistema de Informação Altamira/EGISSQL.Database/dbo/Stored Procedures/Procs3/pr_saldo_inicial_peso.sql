CREATE PROCEDURE pr_saldo_inicial_peso
@ic_parametro     int,
@dt_inicial       datetime,
@dt_final         datetime,        
@cd_produto       int,
@cd_fase_produto  int,
@vl_peso_inicial float output

as
---------------------------------------------------
--GBS-Global Business Solution Ltda            2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Elias
--Banco de Dados: EgisSql
--Objetivo: Achar o Saldo em Peso Inicial de uma determinada data
--Data:
--Atualizado: 12/08/2005
---------------------------------------------------
declare 

@dt_produto_fechamento      datetime,
@vl_saldo_fechamento        float,

-- ELIAS 08/07/2003
@dt_saldo_fechamento        datetime

set @dt_produto_fechamento  = ''
set @vl_saldo_fechamento    = 0
set @dt_saldo_fechamento = dateadd(dd,-1,@dt_inicial)


-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Acha o Saldo Inicial de acordo com o Produto, Fase,
                        -- data inicial e final
-------------------------------------------------------------------------------
  begin

    if exists(select top 1 * from Produto_Fechamento
              where
                dt_produto_fechamento = @dt_saldo_fechamento and
                cd_produto = @cd_produto and
                cd_fase_produto = @cd_fase_produto)
    --Caso houver fechamento no mês anterior
      begin

        --Produto_Fechamento
        set @dt_produto_fechamento=(select distinct pf.dt_produto_fechamento
        from Produto_Fechamento pf
        where 
           pf.cd_produto=@cd_produto           and
           pf.cd_fase_produto=@cd_fase_produto and
           pf.dt_produto_fechamento = @dt_saldo_fechamento)

        --Achando o Saldo Inicial
        set @vl_peso_inicial=(select distinct isnull(pf.qt_peso_prod_fechamento,0.00) 
                               from Produto_Fechamento pf
                               where 
                                 pf.cd_produto=@cd_produto and
                                 pf.cd_fase_produto=@cd_fase_produto and
                                 pf.dt_produto_fechamento = @dt_saldo_fechamento)
                              
      end

    --Se não houver fechamento no mês anterior
    else
    begin

        --Produto_Fechamento
        -- Achando o Último Fechamento.
        set @dt_produto_fechamento=(select max(pf.dt_produto_fechamento)
        from Produto_Fechamento pf
        where 
           pf.cd_produto=@cd_produto           and
           pf.cd_fase_produto=@cd_fase_produto and
           pf.dt_produto_fechamento <= @dt_saldo_fechamento)

       ---------------------------------------------------------------------------
       --  MOVIMENTAÇÃO REAL DO ESTOQUE
       ---------------------------------------------------------------------------

       -- MOVIMENTOS DE ENTRADAS/SAÍDAS
       -- Calculando as entradas e saída a partir desta data.
       select
         sum( case when tme.ic_mov_tipo_movimento =  'E'
                  then me.qt_peso_movimento_estoque
              else 0
              end ) as qt_entrada,

         sum( case when tme.ic_mov_tipo_movimento =  'S'
              then me.qt_peso_movimento_estoque
              else 0
   end ) as qt_saida
      into
        #EntradaSaida
      from
        Movimento_Estoque me with (NOLOCK)
        inner join Tipo_Movimento_Estoque tme
          on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
      where 
        -- ELIAS 26/05/2004
        me.dt_movimento_estoque between @dt_produto_fechamento and (@dt_inicial - 1) and
        ((tme.cd_tipo_movimento_estoque = 1)
         or
        ((tme.nm_atributo_produto_saldo = 'qt_saldo_atual_produto') or
         (tme.nm_atributo_produto_saldo = ''))
         or
         (tme.nm_atributo_produto_saldo='qt_saldo_atual_produto' and
          me.ic_tipo_lancto_movimento='M')) and
        cd_produto=@cd_produto           and
        cd_fase_produto=@cd_fase_produto

        --Achando o Saldo Inicial do último fechamento.
        set @vl_peso_inicial=(select distinct isnull(pf.qt_peso_prod_fechamento,0.00) 
                               from Produto_Fechamento pf
                               where 
                                 pf.cd_produto=@cd_produto and
                                 pf.cd_fase_produto=@cd_fase_produto and
                                 pf.dt_produto_fechamento = @dt_produto_fechamento)

        set @vl_peso_inicial = IsNull(@vl_peso_inicial,0) + ( select IsNull(qt_entrada,0) - IsNull(qt_saida,0)
                                                                from #EntradaSaida )

    end
 
  end



