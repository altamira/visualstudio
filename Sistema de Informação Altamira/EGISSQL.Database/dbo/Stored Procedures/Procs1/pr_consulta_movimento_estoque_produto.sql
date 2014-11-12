
CREATE PROCEDURE pr_consulta_movimento_estoque_produto
-----------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
-----------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Duela
--Banco de Dados: EgisSQL
--Objetivo      : Consulta de Movimentação no Estoque por Produto
--Data          : 25/03/2002
--Atualizado    : 25/07/2002
--                19/05/2003 - Retirado loop (cursor) para maior performace - ELIAS
--                08/07/2003 - Acertado Parâmetro 1 e 2 para trazer um registro vazio somente
--                             com o saldo quando não houver movimentações no período - ELIAS
--                08/08/2003 - Inclusão do Campo: Pedido de Venda e item do Pedido - Daniel C. Neto
--                10/09/2003 - Acerto no join entre o código da Nota Fiscal e Nota_Saida_Item e Número do Documento no Movimento_Estoque (cast) - DUELA
--                07/01/2004 - Alteração no Parâmetro referente ao Saldo do Produto.
--                             Caso o produto for de Consignação, o Saldo Atual e o Saldo Reserva serão somados
--                             com a quantidade em Consignacao.
--                30/06/2004 - Passa a buscar o Pedido de Venda ou o Pedido de Compra, dependendo do tipo de Movimentação - IGOR
--                           - Acertado para filtrar pelo produto para não gerar duplicidade de registros - ELIAS
-- 03/11/2004 - Transformado lote para varchar - Daniel C. NEto.
-- 09/11/2004 - Colocado Isnull - Daniel C. neto.
-- 24/01/2005 - Acertado local da Ordenação da Consulta, que estava sendo feita somente no preenchimento da tabela
--              temporária e consequentemente, em alguns casos a consulta não estava sendo ordenada corretamente.
--              Movido Order By para a Listagem da Consulta. - ELIAS
-- 30/03/2005 - Acertado Consulta do Saldo que estava calculando incorretamente os Valores de Consignação. - ELIAS
-- 02/09/2005 - Consulta da quantidade do Pedido de Importação
-- 22/10/2005 - Produto na Consulta do Lote do Produto  - Carlos Fernandes
-- 22/12/2005 - Acerto para não duplicar registro quando contêm PV parcial. - ELIAS
--              Acerto para melhorar a performace geral da consulta. - ELIAS
-- 12/04/2006 - Acrescenta ao total de requisição de compra as requisições de importação e inserido coluna para
--              pedidos de importação - Paulo Souza
-- 22.05.2006 - Acerto da Consulta para Movimentação do Lote, já tinha sido acertado 
-- 31/08/2006 - Acerto no campo de requisicao total - Daniel C. Neto.
-- 13.09.2006 - Tratamento para melhor performance - Fabio Cesar
-- 01/11/2006 - Retirado relações de indices por problemas nos clientes - Daniel C.Neto.
-- 11.05.2007 - Preço Unitário - Carlos Fernandes
-- 12.06.2007 - Lote - Carlos Fernandes
-- 05.09.2007 - Custo Comissão - Carlos Fernandes
-- 06.02.2008 - Mostrar o custo comissão referente a nota de entrada - Carlos Fernandes
-- 21.03.2009 - Alocação de Produto - Carlos Fernandes
-- 05.05.2009 - Múltiplo de Embalagem - Carlos Fernandes
-- 05.03.2010 - Não mostrar os itens faturados no Período Seguinte - Carlos Fernandes
-- 05.06.2010 - Não mostrar as Notas Canceladas e Ativadas - Carlos Fernandes
-- 05.07.2010 - Verificação da Velocidade - Carlos Fernandes
-- 31.07.2010 - Ajuste da Procedure para busca da nota fiscal de saída cancelada - Carlos Fernandes
-------------------------------------------------------------------------------------------------------------------
@ic_parametro               int         = 0, 
@dt_inicial                 datetime, 
@dt_final                   datetime,
@cd_produto                 int         = 0,
@cd_fase_produto            int         = 0,
@cd_tipo_movimento_estoque  int         = 0,
@nm_atributo_produto_saldo  varchar(30) = '',
@ic_comp_movimento_estoque  char(1)     = 'N',
@cd_lote_produto            varchar(25) = ''

--@dt_saldo                   datetime    = ''

AS

declare 

	@cd_movimento_estoque       int, 
	@Saldo_Inicial              float,
	@Entrada                    float,
	@Saida                      float,
	@Saldo                      float,
	@vl_saldo_inicial           float,
	@vl_saldo_anterior          float,

        -- Para otimização

	@nm_fantasia_produto        varchar(25),
	@gp_cd_mascara_produto	    varchar(25),
	@cd_mascara_produto         varchar(25),
	@cd_mascara_grupo_produto   varchar(25),
	@ic_consignacao_produto     char(1),
        @nm_produto                 varchar(50)


set @vl_saldo_inicial       = 0
set @vl_saldo_anterior      = 0
set @Entrada                = 0
set @Saida                  = 0
set @Saldo                  = 0

-- Apenas os Campos necessários do Produto

select 
  @nm_fantasia_produto      = p.nm_fantasia_produto,
  @cd_mascara_produto       = p.cd_mascara_produto,
  @cd_mascara_grupo_produto = gp.cd_mascara_grupo_produto,
  @ic_consignacao_produto   = p.ic_consignacao_produto,
  @nm_produto               = p.nm_produto
from 
  Produto p                   with(nolock)
  inner join Grupo_Produto gp with(nolock) on p.cd_grupo_produto = gp.cd_grupo_produto

where
  p.cd_produto = @cd_produto

------------------------------------------------------------------------------
-- Achando o Saldo Final do Mês Anterior 
-------------------------------------------------------------------------------
if @cd_produto>0 and @dt_inicial is not null and @dt_final is not null
begin

  EXECUTE pr_saldo_inicial 
          1, @dt_inicial, @dt_final, @cd_produto, @cd_fase_produto, @vl_saldo_inicial=@vl_saldo_inicial output

end

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta Movimentação do Estoque do Produto 
                        -- (Todos)
-------------------------------------------------------------------------------
begin

  --select @vl_saldo_inicial
 
  select 
    me.cd_produto,
    @nm_fantasia_produto                        as nm_fantasia_produto,
    case 
      when isnull(@cd_mascara_grupo_produto, '') = ''
      then isnull(@cd_mascara_produto, '')
      else dbo.fn_formata_mascara(isnull(@cd_mascara_grupo_produto, ''), isnull(@cd_mascara_produto, ''))
    end                                            as 'Mascara',

    @nm_produto                                    as 'nm_produto',
    me.cd_movimento_estoque, 
    me.dt_movimento_estoque,
    me.ic_consig_movimento,
    me.ic_terceiro_movimento,
    me.nm_historico_movimento,
    tme.nm_tipo_movimento_estoque,
    tde.nm_tipo_documento_estoque,
    me.cd_documento_movimento,
    me.cd_item_documento,
    td.nm_tipo_destinatario,
    me.nm_destinatario,
    me.vl_custo_contabil_produto,
    me.vl_fob_produto,
    me.vl_fob_convertido,

    isnull(@vl_saldo_inicial,0.00)                 as 'Saldo_Inicial',

    case when tme.ic_mov_tipo_movimento = 'E'
      then (me.qt_movimento_estoque) 
      else 0 
    end                                            as 'Entrada',

    case 
      when tme.ic_mov_tipo_movimento = 'S' 
      then (me.qt_movimento_estoque) 
      else 0 
    end                                            as 'Saida',

    cast(0.00 as float)                            as 'Saldo',

    me.cd_lote_produto,
    me.ic_tipo_lancto_movimento,
    tme.nm_atributo_produto_saldo,

    case when tme.nm_atributo_produto_saldo like 'qt_saldo_atual_produto' 
      then case when me.cd_tipo_documento_estoque = 4
             then (select top 1 nsi.cd_pedido_venda
                   from Nota_Saida_Item nsi with (nolock)
                   where cast(nsi.cd_nota_saida as varchar(20)) = me.cd_documento_movimento and 
                     nsi.cd_item_nota_saida       = me.cd_item_documento and
                     me.cd_tipo_documento_estoque = 4 and nsi.cd_produto = @cd_produto
                   order by nsi.cd_pedido_venda desc)
             else (select top 1 nei.cd_pedido_compra
                   from Nota_Entrada_Item nei with (nolock)
                   where cast(nei.cd_nota_entrada as varchar(20)) = me.cd_documento_movimento and 
                     nei.cd_item_nota_entrada = me.cd_item_documento and
                     me.cd_tipo_documento_estoque = 3 and nei.cd_produto = @cd_produto
                   order by nei.cd_pedido_compra desc)
             end
      else 0 
    end                                     as 'cd_pedido_venda',

    case when tme.nm_atributo_produto_saldo like 'qt_saldo_atual_produto' 
      then case when me.cd_tipo_documento_estoque = 4
             then (select top 1 nsi.cd_item_pedido_venda
                   from Nota_Saida_Item nsi with (nolock)
                   where cast(nsi.cd_nota_saida as varchar(20)) = me.cd_documento_movimento and 
                     nsi.cd_item_nota_saida = me.cd_item_documento and
                     me.cd_tipo_documento_estoque = 4 and nsi.cd_produto = @cd_produto
                   order by nsi.cd_pedido_venda desc)
             else (select top 1 nei.cd_item_pedido_compra
                   from Nota_Entrada_Item nei with (nolock)
                   where cast(nei.cd_nota_entrada as varchar(20)) = me.cd_documento_movimento and 
                     nei.cd_item_nota_entrada = me.cd_item_documento and
                     me.cd_tipo_documento_estoque = 3 and nei.cd_produto = @cd_produto
                   order by nei.cd_pedido_compra desc)
             end
      else 0 
    end                                    as 'cd_item_pedido_venda',
    u.nm_fantasia_usuario,
    isnull((select top 1 'S' from movimento_estoque_composicao with(nolock) where cd_movimento_estoque = me.cd_movimento_estoque),'N') as ic_movimento_composicao,
    me.cd_movimento_estoque_origem,
    me.cd_fase_produto,
    tme.cd_tipo_movimento_estoque,
    me.vl_unitario_movimento,

    case when tme.ic_mov_tipo_movimento='E'
    then
      0.00 
    else
      case when isnull(me.vl_custo_contabil_produto,0)>0 then
          me.vl_unitario_movimento/isnull(me.vl_custo_contabil_produto,0)
      else
          case when isnull(pc.vl_custo_produto,0)>0 then
            me.vl_unitario_movimento/isnull(pc.vl_custo_produto,0)
          else
            0.00 end
      end
    end                                                      as vl_margem_produto,

    isnull(pc.vl_custo_produto,0)                            as vl_custo_produto,

    case when isnull(me.vl_custo_comissao,0)>0 
    then
      isnull(me.vl_custo_comissao,0)
    else
      isnull(pc.vl_custo_comissao,0)
    end                                                      as vl_custo_comissao,

--    opf.ic_estoque_op_fiscal,

    isnull(opf.ic_estoque_op_fiscal,'N')                     as ic_estoque_op_fiscal,
    isnull(opf.ic_estoque_reserva_op_fis,'N')                as ic_estoque_reserva,
    me.ic_mov_movimento,
    isnull(opf.cd_operacao_fiscal,0)                         as cd_operacao_fiscal

  into
     #Movimento_Estoque_Real_Pre

  from 
    Movimento_Estoque me                       with(nolock) 
    left outer join Tipo_Movimento_Estoque tme with(nolock) on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque 
    Left Outer Join Tipo_documento_estoque tde with(nolock) on me.cd_tipo_documento_estoque  = tde.cd_tipo_documento_estoque 
    Left Outer Join Tipo_Destinatario td       with(nolock) on me.cd_tipo_destinatario       = td.cd_tipo_destinatario 
    Left Outer Join EgisAdmin.dbo.Usuario u    with(nolock) on me.cd_usuario                 = u.cd_usuario 
    Left outer Join Produto p                  with(nolock) on p.cd_produto                  = me.cd_produto
    Left outer Join Produto_Custo pc           with(nolock) on pc.cd_produto                 = p.cd_produto
    Left Outer Join Operacao_Fiscal opf        with(nolock) on opf.cd_operacao_fiscal        = me.cd_operacao_fiscal

  where 
    me.dt_movimento_estoque between @dt_inicial and @dt_final and
    me.cd_produto = @cd_produto  --Foi retornado para filtragem inicial devido ao fato do uso do indice adequadamente
                                 --já existia uma índice chamado "IX_Movimento_Estoque" (por: dt_movimento_estoque, cd_produto)
                                 --tornando a consulta novamente mais rápida - Fabio Cesar
   

   --select * from operacao_fiscal
  
  --Verifica as Reservas que foram faturadas neste mês

  --select * from movimento_estoque
  --select * from tipo_movimento_estoque

  select
    m.*
  into
    #ReservaMesSeguinte

  from
    #Movimento_Estoque_Real_Pre m
    inner join pedido_venda_item i with (nolock) on i.cd_pedido_venda        = m.cd_documento_movimento and
                                                    i.cd_item_pedido_venda   = m.cd_item_documento


    inner join vw_pedido_venda_item_nota_saida nsi on nsi.cd_pedido_venda      = i.cd_pedido_venda        and
                                                      nsi.cd_item_pedido_venda = i.cd_item_pedido_venda   

--     inner join nota_saida_item nsi on nsi.cd_pedido_venda      = i.cd_pedido_venda        and
--                                       nsi.cd_item_pedido_venda = i.cd_item_pedido_venda   

    inner join nota_saida n        on n.cd_nota_saida          = nsi.cd_nota_saida

  where
    m.dt_movimento_estoque         between @dt_inicial and @dt_final
    and ( m.cd_tipo_movimento_estoque = 2 or m.cd_tipo_movimento_estoque = 3 ) 
    and   --Saída
    n.dt_nota_saida        > @dt_final and
    m.dt_movimento_estoque > n.dt_nota_saida

  --Deleta as Reservas faturadas no Mês Seguinte
  delete from #Movimento_Estoque_Real_Pre where cd_movimento_estoque in ( select cd_movimento_estoque from #ReservaMesSeguinte )

  --Deleta o Movimento de Entrada na Reserva 

  delete from #Movimento_Estoque_Real_Pre
  where cd_operacao_fiscal > 0 and ic_mov_movimento = 'E' and ic_estoque_reserva = 'N'
        and @nm_atributo_produto_saldo = 'qt_saldo_reserva_produto'
        and dt_movimento_estoque < @dt_inicial



  --Delete as Notas Canceladas e as Ativações

--   delete from #Movimento_Estoque_Real_Pre
--   where
--     cd_tipo_movimento_estoque in (12,13) and
--     dt_movimento_estoque  between @dt_inicial and @dt_final
-- 
--   delete from #Movimento_Estoque_Real_Pre
--   where
--      cd_documento_movimento in ( select top 1 cd_nota_saida 
--                                  from
--                                    nota_saida with (nolock) 
--                                  where
--                                      cd_status_nota in (4,7) and 
--                                      cd_documento_movimento = cd_nota_saida and 
--                                      dt_cancel_nota_saida between @dt_inicial and @dt_final )
-- 
--      and
--      ic_mov_movimento = 'S'


  --select * from movimento_estoque
  --select * from tipo_movimento_estoque

  Select 
    * 
  into 
    #Movimento_Estoque_Real 

  from 
    #Movimento_Estoque_Real_Pre

  where 
      cd_fase_produto = @cd_fase_produto and
    ((cd_tipo_movimento_estoque in (1,5)) or  ((nm_atributo_produto_saldo like @nm_atributo_produto_saldo+'%') or
     (nm_atributo_produto_saldo = ''))    or (nm_atributo_produto_saldo = 'qt_saldo_atual_produto' 
      and ic_tipo_lancto_movimento= 'M')) and 
     (cd_lote_produto = @cd_lote_produto  or isnull(@cd_lote_produto,'') = '')

  if exists(select top 1 'x' from #Movimento_Estoque_Real)
  begin
    if (isnull(@ic_comp_movimento_estoque,'N') = 'N' )
      select *,
        cast(null as integer) as cd_item_movimento_estoque,
        cast(null as float)   as qt_movimento_estoque_comp,
        cast(null as float)   as vl_custo_mov_estoque_comp,
        cast(null as float)   as vl_custo_medio
      from #Movimento_Estoque_Real
      order by dt_movimento_estoque, cd_movimento_estoque 
    else
      select 
        m.*,
        mec.cd_item_movimento_estoque,
        mec.qt_movimento_estoque_comp,
        mec.vl_custo_mov_estoque_comp,
        (select isnull(sum(qt_movimento_estoque_comp),1) 
         from Movimento_Estoque_Composicao with(nolock)
         where cd_movimento_estoque = mec.cd_movimento_estoque
         group by cd_movimento_estoque) as vl_custo_medio 
      from 
        #Movimento_Estoque_Real m 
        left outer join Movimento_Estoque_Composicao mec on m.cd_movimento_estoque = mec.cd_movimento_estoque
      order by m.dt_movimento_estoque, m.cd_movimento_estoque 

      drop table #Movimento_Estoque_Real_Pre
      drop table #Movimento_Estoque_Real

  end
  else
  begin
    select
    @cd_produto                as cd_produto,
    cast(null as varchar(30))  as nm_fantasia_produto,
    cast(null as varchar(20))  as Mascara,
    cast(null as varchar(40))  as nm_produto,
    cast(null as int)          as cd_movimento_estoque,
    cast(null as datetime)     as dt_movimento_estoque,
    cast(null as char(1))      as ic_consig_movimento,
    cast(null as char(1))      as ic_terceiro_movimento,
    cast(null as varchar(255)) as nm_historico_movimento,
    cast(null as varchar(30))  as nm_tipo_movimento_estoque,
    cast(null as varchar(30))  as nm_tipo_documento_estoque,
    cast(null as varchar(20))  as cd_documento_movimento,
    cast(null as int)          as cd_item_documento,
    cast(null as varchar(30))  as nm_tipo_destinatario,
    cast(null as varchar(40))  as nm_destinatario,
    cast(null as float)        as vl_custo_contabil_produto,
    cast(null as float)        as vl_fob_produto,
    cast(null as float)        as vl_fob_convertido,
    isnull(@vl_saldo_inicial,0.00) as 'Saldo_Inicial',
    cast(null as float)        as 'Entrada',
    cast(null as float)        as 'Saida',
    isnull(@vl_saldo_inicial,0.00) as Saldo,
    cast(null as varchar(25))  as cd_lote_produto,
    cast(null as char(1))      as ic_tipo_lancto_movimento,
    cast(null as varchar(30))  as nm_atributo_produto_saldo,
    0                          as 'cd_pedido_venda',
    0                          as 'cd_item_pedido_venda',
    cast(null as char(15))     as nm_fantasia_usuario,
    'N'                        as ic_movimento_composicao,
    0                          as cd_movimento_estoque_origem,
    cast(null as integer)      as cd_item_movimento_estoque,
    cast(null as float)        as qt_movimento_estoque_comp,
    cast(null as float)        as vl_custo_mov_estoque_comp,
    cast(null as float)        as vl_custo_medio,
    cast(null as float)        as vl_unitario_movimento,
    cast(null as float)        as vl_margem_produto,
    cast(null as float)        as vl_custo_produto,
    cast(null as float)        as vl_custo_comissao
  end

end


-------------------------------------------------------------------------------
if @ic_parametro = 2    -- Consulta Movimentação do Estoque do Produto 
                        -- (Filtrado por Tipo de Movimento)
-------------------------------------------------------------------------------
begin

  select 
    me.cd_produto,
    @nm_fantasia_produto            as nm_fantasia_produto,
    --p.nm_fantasia_produto,
    Case 
      When IsNull(@cd_mascara_grupo_produto, '') = ''
      then IsNull(@cd_mascara_produto, '')
      Else dbo.fn_formata_mascara(IsNull(@cd_mascara_grupo_produto, ''), IsNull(@cd_mascara_produto, ''))
    End                             as 'Mascara',
    @nm_produto as nm_produto,
--     p.nm_produto,
    me.cd_movimento_estoque, 
    me.dt_movimento_estoque,
    me.ic_consig_movimento,
    me.ic_terceiro_movimento,
    me.nm_historico_movimento,
    tme.nm_tipo_movimento_estoque,
    tde.nm_tipo_documento_estoque,
    me.cd_documento_movimento,
    me.cd_item_documento,
    td.nm_tipo_destinatario,
    me.nm_destinatario,
    me.vl_custo_contabil_produto,
    me.vl_fob_produto,
    me.vl_fob_convertido,
    isnull(@vl_saldo_inicial,0.00)                      as 'Saldo_Inicial',
    case when tme.ic_mov_tipo_movimento='E'then
      (me.qt_movimento_estoque) else 0 end              as 'Entrada',
    case when ic_mov_tipo_movimento='S'then
      (me.qt_movimento_estoque) else 0 end              as 'Saida',
    cast(0.00 as float)                                 as Saldo,
    me.cd_lote_produto,
    me.ic_tipo_lancto_movimento,
    tme.nm_atributo_produto_saldo,
    u.nm_fantasia_usuario,
    IsNull((Select top 1 'S' from movimento_estoque_composicao with(nolock) where cd_movimento_estoque = me.cd_movimento_estoque),'N') as ic_movimento_composicao,
    me.cd_movimento_estoque_origem,
    case when ic_mov_tipo_movimento='E'
    then
      0.00 
    else
      case when isnull(me.vl_custo_contabil_produto,0)>0 then
          me.vl_unitario_movimento/isnull(me.vl_custo_contabil_produto,0)
      else
          case when isnull(pc.vl_custo_produto,0)>0 then
            me.vl_unitario_movimento/isnull(pc.vl_custo_produto,0)
          else
            0.00 end
      end
    end                                                      as vl_margem_produto,
    isnull(pc.vl_custo_produto,0)                            as vl_custo_produto,
    case when isnull(me.vl_custo_comissao,0)>0 
    then
      isnull(me.vl_custo_comissao,0)
    else
      isnull(pc.vl_custo_comissao,0)
    end                                                      as vl_custo_comissao,
    --opf.ic_estoque_op_fiscal,
    isnull(opf.ic_estoque_op_fiscal,'N')                     as ic_estoque_op_fiscal,
    isnull(opf.ic_estoque_reserva_op_fis,'N')                as ic_estoque_reserva,
    me.ic_mov_movimento,
    isnull(opf.cd_operacao_fiscal,0) as cd_operacao_fiscal

  into
    #Movimento_Estoque

  from 
    Movimento_Estoque me                       with(nolock) 
    Left outer join Tipo_Movimento_Estoque tme with(nolock) on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque 
    Left Outer Join Tipo_Documento_Estoque tde with(nolock) on me.cd_tipo_documento_estoque  = tde.cd_tipo_documento_estoque 
    Left Outer Join Tipo_Destinatario td       with(nolock) on me.cd_tipo_destinatario       = td.cd_tipo_destinatario 
    Left Outer Join Usuario u                  with(nolock) on me.cd_usuario                 = u.cd_usuario
    Left Outer Join Produto p                  with(nolock) on p.cd_produto                  = me.cd_produto
    Left Outer Join Produto_Custo pc           with(nolock) on pc.cd_produto                 = p.cd_produto
    Left Outer Join Operacao_Fiscal opf        with(nolock) on opf.cd_operacao_fiscal        = me.cd_operacao_fiscal

  where 
    me.dt_movimento_estoque between @dt_inicial and @dt_final and
    me.cd_produto                = @cd_produto        and
    me.cd_fase_produto           = @cd_fase_produto   and
    me.cd_tipo_movimento_estoque = @cd_tipo_movimento_estoque
    and (me.cd_lote_produto      = IsNull(@cd_lote_produto,'') or IsNull(@cd_lote_produto,'') = '')

  order by 
    me.dt_movimento_estoque,
    me.cd_movimento_estoque 


  select
    m.*
  into
    #ReservaMesSeguinteM

  from
    #Movimento_Estoque m
    inner join pedido_venda_item i with (nolock) on i.cd_pedido_venda        = m.cd_documento_movimento and
                                                    i.cd_item_pedido_venda   = m.cd_item_documento


    inner join vw_pedido_venda_item_nota_saida nsi on nsi.cd_pedido_venda      = i.cd_pedido_venda        and
                                                      nsi.cd_item_pedido_venda = i.cd_item_pedido_venda   

--     inner join nota_saida_item nsi on nsi.cd_pedido_venda      = i.cd_pedido_venda        and
--                                       nsi.cd_item_pedido_venda = i.cd_item_pedido_venda   

    inner join nota_saida n        on n.cd_nota_saida          = nsi.cd_nota_saida
  where
    m.dt_movimento_estoque         between @dt_inicial and @dt_final
    and ( m.cd_tipo_movimento_estoque = 2 or m.cd_tipo_movimento_estoque = 3 ) 
    and   --Saída
    m.dt_movimento_estoque > n.dt_nota_saida

  --Deleta as Reservas faturadas no Mês Seguinte
  delete from #Movimento_Estoque where cd_movimento_estoque in ( select cd_movimento_estoque from #ReservaMesSeguinteM )

  --Deleta o Movimento de Entrada na Reserva 

  delete from #Movimento_Estoque 
  where cd_operacao_fiscal > 0 and ic_mov_movimento = 'E' and ic_estoque_reserva = 'N' and @nm_atributo_produto_saldo = 'qt_saldo_reserva_produto'
        and dt_movimento_estoque < @dt_inicial


  --Carlos 05.06.2010

  --Delete as Notas Canceladas e as Ativações

--   delete from #Movimento_Estoque_Real_Pre
--   where
--     cd_tipo_movimento_estoque in (12,13) and
--     dt_movimento_estoque  between @dt_inicial and @dt_final
-- 
--   delete from #Movimento_Estoque_Real_Pre
--   where
--      cd_documento_movimento in ( select top 1 cd_nota_saida 
--                                  from
--                                    nota_saida with (nolock) 
--                                  where
--                                      cd_status_nota in (4,7) and 
--                                      cd_documento_movimento = cd_nota_saida and 
--                                      dt_cancel_nota_saida between @dt_inicial and @dt_final )
-- 
-- 
--      and
--      ic_mov_movimento = 'S'
-- 
  if exists(select top 1 * from #Movimento_Estoque)
  begin
    if ( IsNull(@ic_comp_movimento_estoque,'N') = 'N' )   
       select 
	      	*,
	      	cast(null as integer) as cd_item_movimento_estoque,
	      	cast(null as float)   as qt_movimento_estoque_comp,
	      	cast(null as float)   as vl_custo_mov_estoque_comp,
		cast(null as float)   as vl_custo_medio
       from 
	      	#Movimento_Estoque
      
    else
        select 
		      m.*,
		      mec.cd_item_movimento_estoque,
		      mec.qt_movimento_estoque_comp,
		      mec.vl_custo_mov_estoque_comp,
		      ( mec.vl_custo_mov_estoque_comp * mec.qt_movimento_estoque_comp ) / 
       		(Select IsNull(sum(qt_movimento_estoque_comp),1) 
        	 from 
            Movimento_Estoque_Composicao with(nolock)
        	 where 
          	cd_movimento_estoque = mec.cd_movimento_estoque
        	 group by 
		        cd_movimento_estoque) as vl_custo_medio 
	      from 
          #Movimento_Estoque m left outer join
          Movimento_Estoque_Composicao mec on m.cd_movimento_estoque = mec.cd_movimento_estoque
	      order by 
          m.dt_movimento_estoque,
          m.cd_movimento_estoque 
  end
  else
  begin
    select
    @cd_produto                    as cd_produto,
    cast(null as varchar(30))      as nm_fantasia_produto,
    cast(null as varchar(20))      as Mascara,
    cast(null as int)              as cd_movimento_estoque,
    cast(null as datetime)         as dt_movimento_estoque,
    cast(null as char(1))          as ic_consig_movimento,
    cast(null as char(1))          as ic_terceiro_movimento,
    cast(null as varchar(255))     as nm_historico_movimento,
    cast(null as varchar(30))      as nm_tipo_movimento_estoque,
    cast(null as varchar(30))      as nm_tipo_documento_estoque,
    cast(null as varchar(20))      as cd_documento_movimento,
    cast(null as int)              as cd_item_documento,
    cast(null as varchar(30))      as nm_tipo_destinatario,
    cast(null as varchar(40))      as nm_destinatario,
    cast(null as float)            as vl_custo_contabil_produto,
    cast(null as float)            as vl_fob_produto,
    cast(null as float)            as vl_fob_convertido,
    isnull(@vl_saldo_inicial,0.00) as 'Saldo_Inicial',
    cast(null as float)            as 'Entrada',
    cast(null as float)            as 'Saida',
    isnull(@vl_saldo_inicial,0.00) as Saldo,
    cast(null as varchar(20))      as cd_lote_produto,
    cast(null as char(1))          as ic_tipo_lancto_movimento,
    cast(null as varchar(30))      as nm_atributo_produto_saldo,
    cast(null as char(15))         as nm_fantasia_usuario,
    'N'                            as ic_movimento_composicao,
    0                              as cd_movimento_estoque_origem,
    cast(null as integer)          as cd_item_movimento_estoque,
    cast(null as float)            as qt_movimento_estoque_comp,
    cast(null as float)            as vl_custo_mov_estoque_comp,
    cast(null as float)            as vl_custo_medio,
    cast(null as float)            as vl_margem_produto,
    cast(null as float)            as vl_custo_produto,
    cast(null as float)            as vl_custo_comissao

  end

end

-------------------------------------------------------------------------------
if @ic_parametro = 3    -- Consulta Saldo do Produto
-------------------------------------------------------------------------------
  begin
    select
      ps.cd_produto,
      case when isnull(p.ic_consignacao_produto,'N') <> 'S' then
        isnull(ps.qt_saldo_atual_produto,0.00) 
      else 
        isnull(ps.qt_saldo_atual_produto,0.00)+isnull(ps.qt_consig_produto,0.00) end as 'Atual',
      case when isnull(p.ic_consignacao_produto,'N') <> 'S' then
        isnull(ps.qt_saldo_reserva_produto,0.00) 
      else
        isnull(ps.qt_saldo_reserva_produto,0.00)+isnull(ps.qt_consig_produto,0.00) end as 'Reserva',                       
      isnull(ps.qt_pd_compra_produto,0.00)+
      isnull(ps.qt_importacao_produto,0.00)                     as 'Compra',
      isnull(ps.qt_req_compra_produto,0.00)                     as 'Requisicao',
      isnull(ps.qt_consumo_produto,0.00)                        as 'Consumo',
      isnull(ps.qt_minimo_produto,0.00)                         as 'Minimo',
      isnull(((ps.qt_saldo_reserva_produto/
               cast(replace(Cast(ps.qt_consumo_produto as varchar(20)),'0','1') as float))*30),0.00)  as 'Duracao',
      IsNull((select Sum(pii.qt_saldo_item_ped_imp)
              from pedido_importacao_item pii
              where pii.cd_produto = ps.cd_produto and
                    pii.qt_saldo_item_ped_imp > 0 and
                    pii.dt_cancel_item_ped_imp is null
              group by pii.cd_produto),0)                       as 'PedidoImportacao',
      (isnull(ps.qt_req_compra_produto,0.00) + IsNull((select Sum(rci.qt_item_requisicao_compra)
                                                      from requisicao_compra_item rci with (nolock) 
                                                           inner join pedido_importacao_item piii on rci.cd_requisicao_compra = piii.cd_requisicao_compra and
                                                                           rci.cd_item_requisicao_compra = piii.cd_item_requisicao_compra and
                                                                           piii.dt_cancel_item_ped_imp is null
                                                      Where rci.cd_produto = ps.cd_produto  
                                                      Group by rci.cd_produto),0)) as 'RequisicaoTotal',
     isNull(p.qt_area_produto,0)                                         as qt_area_produto,
     (IsNull(ps.qt_saldo_atual_produto,0) * isNull(p.qt_area_produto,0)) as qt_total_area_produto,
     isnull(ps.qt_alocado_produto,0)                                     as qt_alocado_produto

--select * from produto_saldo

    from 
      Produto_Saldo ps          with(nolock)
      left outer join Produto p with(nolock) on ps.cd_produto=p.cd_produto
    where
      ps.cd_produto      = @cd_produto and
      ps.cd_fase_produto = @cd_fase_produto

  end  

-------------------------------------------------------------------------------
if @ic_parametro = 4    -- Zera Procedure
-------------------------------------------------------------------------------
  begin
    select 
      0         as 'cd_movimento_estoque', 
      getdate() as 'dt_movimento_estoque',
      ''        as 'ic_consig_movimento',
      ''        as 'ic_terceiro_movimento',
      ''        as 'nm_historico_movimento',
      0.00      as 'Saldo_Inicial',
      0.00      as 'Entrada',
      0.00      as 'Saida',
      0.00      as 'Saldo',
      0.00      as 'Saldo_Final'
    where 1=2
    end

