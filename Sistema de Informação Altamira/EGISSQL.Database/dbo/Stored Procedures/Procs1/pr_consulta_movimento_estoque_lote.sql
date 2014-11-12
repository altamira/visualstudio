
CREATE PROCEDURE pr_consulta_movimento_estoque_lote
---------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
---------------------------------------------------------------------------------------------------
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
-- 02.09.2005 - Consulta da quantidade do Pedido de Importação
-- 22.10.2004 - Produto na Consulta do Lote do Produto  - Carlos Fernandes
-- 16/03/2007 - Separando a procedure do lote do movimento do estoque
-- 11.05.2007 - Valor Unitário do Movimento de Estoque - Carlos Fernandes
-- 12.06.2007 - Margem - Carlos Fernandes
-- 05.09.2007 - Custo Comissão - Carlos Fernandes
-------------------------------------------------------------------------------------------------------------------
@ic_parametro               int, 
@dt_inicial                 datetime, 
@dt_final                   datetime,
@cd_produto                 int,
@cd_fase_produto            int,
@cd_tipo_movimento_estoque  int,
@nm_atributo_produto_saldo  varchar(20),
@ic_comp_movimento_estoque  char(1)     = 'N',
@cd_lote_produto            varchar(20) = ''

AS

declare 
	@cd_movimento_estoque       int, 
	@Saldo_Inicial              float,
	@Entrada                    float,
	@Saida                      float,
	@Saldo                      float,
	@vl_saldo_inicial           float,
	@vl_saldo_anterior          float

set @vl_saldo_inicial       = 0
set @vl_saldo_anterior      = 0
set @Entrada                = 0
set @Saida                  = 0
set @Saldo                  = 0


------------------------------------------------------------------------------
-- Achando o Saldo Final do Mês Anterior 
-------------------------------------------------------------------------------
  EXECUTE pr_saldo_inicial 
          1, @dt_inicial, @dt_final, @cd_produto, @cd_fase_produto, @vl_saldo_inicial=@vl_saldo_inicial output
-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta Movimentação do Estoque do Produto 
                        -- (Todos)
-------------------------------------------------------------------------------
begin

  select 
    me.cd_produto,
    p.nm_fantasia_produto,
    Case 
      When IsNull(gp.cd_mascara_grupo_produto, '') = ''
      then IsNull(p.cd_mascara_produto, '')
      Else dbo.fn_formata_mascara(IsNull(gp.cd_mascara_grupo_produto, ''), IsNull(p.cd_mascara_produto, ''))
    End as 'Mascara',
    p.nm_produto,
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
    isnull(@vl_saldo_inicial,0.00) as 'Saldo_Inicial',
    case when tme.ic_mov_tipo_movimento = 'E'
      then (me.qt_movimento_estoque) 
      else 0 
    end as 'Entrada',
    case 
      when ic_mov_tipo_movimento = 'S' 
      then (me.qt_movimento_estoque) 
      else 0 
    end as 'Saida',
    cast(0.00 as float) as Saldo,
    me.cd_lote_produto,
    me.ic_tipo_lancto_movimento,
    tme.nm_atributo_produto_saldo,
    case when tme.nm_atributo_produto_saldo like 'qt_saldo_atual_produto' 
         then case when me.cd_tipo_documento_estoque = 4
                   then nsi.cd_pedido_venda
                   else nei.cd_pedido_compra
              end
         else 0 
    end as 'cd_pedido_venda',
    case when tme.nm_atributo_produto_saldo like 'qt_saldo_atual_produto' 
         then case when me.cd_tipo_documento_estoque = 4
                   then nsi.cd_item_pedido_venda
                   else nei.cd_item_pedido_compra
              end
         else 0 
    end as 'cd_item_pedido_venda',
    u.nm_fantasia_usuario,
    IsNull((Select top 1 'S' from movimento_estoque_composicao where cd_movimento_estoque = me.cd_movimento_estoque),'N') as ic_movimento_composicao,
    me.cd_movimento_estoque_origem,
    isnull(me.vl_unitario_movimento,0) as vl_unitario_movimento,
    case when ic_mov_tipo_movimento='E'
    then
      0.00 
    else
      case when isnull(me.vl_custo_contabil_produto,0)>0 then
          isnull(me.vl_unitario_movimento,0)/isnull(me.vl_custo_contabil_produto,0)
      else
          case when isnull(pc.vl_custo_produto,0)>0 then
            isnull(me.vl_unitario_movimento,0)/isnull(pc.vl_custo_produto,0)
          else
            0.00 end
      end
    end                                                      as vl_margem_produto,
    pc.vl_custo_produto,
    pc.vl_custo_comissao
  into
    #Movimento_Estoque_Real
  from 
    Movimento_Estoque me 
      left outer join 
    Tipo_Movimento_Estoque tme 
      on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque 
      Left Outer Join
    Tipo_documento_estoque tde 
      on me.cd_tipo_documento_estoque  = tde.cd_tipo_documento_estoque 
      Left Outer Join
    Tipo_Destinatario td 
      on me.cd_tipo_destinatario = td.cd_tipo_destinatario 
      Left Outer Join
    Produto p 
      on me.cd_produto = p.cd_produto 
      Left outer join Produto_custo pc on pc.cd_produto = p.cd_produto
      Left Outer Join
    Grupo_Produto gp 
      on p.cd_grupo_produto = gp.cd_grupo_produto 
      Left Outer Join
    EgisAdmin.dbo.Usuario u 
      on me.cd_usuario = u.cd_usuario 
      left outer join
    Nota_Saida_Item nsi 
      on cast(nsi.cd_nota_saida as varchar(20)) = me.cd_documento_movimento and 
			   nsi.cd_item_nota_saida = me.cd_item_documento and
         -- ELIAS 30/06/2004  
         me.cd_tipo_documento_estoque = 4 and nsi.cd_produto = @cd_produto
      left outer join
    Nota_Entrada_Item nei
      on cast(nei.cd_nota_entrada as varchar(20)) = me.cd_documento_movimento and 
			   nei.cd_item_nota_entrada = me.cd_item_documento and
         -- ELIAS 30/06/2004
         me.cd_tipo_documento_estoque = 3 and nei.cd_produto = @cd_produto
  where 
    me.dt_movimento_estoque between @dt_inicial and @dt_final and
    ((@cd_produto = 0) or (me.cd_produto = @cd_produto))      and
    me.cd_fase_produto = @cd_fase_produto                     and
    ((tme.cd_tipo_movimento_estoque = 1) or ((tme.nm_atributo_produto_saldo like @nm_atributo_produto_saldo+'%') or
     (tme.nm_atributo_produto_saldo = '')) or (tme.nm_atributo_produto_saldo='qt_saldo_atual_produto' and me.ic_tipo_lancto_movimento='M'  )) 
    and (me.cd_lote_produto = @cd_lote_produto or IsNull(@cd_lote_produto,'') = '')


  if exists(select top 1 * from #Movimento_Estoque_Real)
  begin
    if ( IsNull(@ic_comp_movimento_estoque,'N') = 'N' )
        select 
        		*,
		        cast(null as integer) as cd_item_movimento_estoque,
		        cast(null as float)   as qt_movimento_estoque_comp,
		        cast(null as float)   as vl_custo_mov_estoque_comp,
		        cast(null as float)   as vl_custo_medio
	       from 
		        #Movimento_Estoque_Real
         order by
           dt_movimento_estoque,
           cd_movimento_estoque 

     else
        select 
      		m.*,
      		mec.cd_item_movimento_estoque,
      		mec.qt_movimento_estoque_comp,
      		mec.vl_custo_mov_estoque_comp,
		      (Select 
              IsNull(sum(qt_movimento_estoque_comp),1) 
        	 from 
              Movimento_Estoque_Composicao 
        	 where 
          	  cd_movimento_estoque = mec.cd_movimento_estoque
        	 group by 
		        cd_movimento_estoque) as vl_custo_medio 
	      from 
          #Movimento_Estoque_Real m left outer join
          Movimento_Estoque_Composicao mec on m.cd_movimento_estoque = mec.cd_movimento_estoque
	      order by m.dt_movimento_estoque,
              m.cd_movimento_estoque 
  end
  else
  begin
    select
    @cd_produto as cd_produto,
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
    cast(null as float)            as vl_fob_convertido,
    isnull(@vl_saldo_inicial,0.00) as 'Saldo_Inicial',
    cast(null as float) as 'Entrada',
    cast(null as float) as 'Saida',
    isnull(@vl_saldo_inicial,0.00) as Saldo,
    cast(null as varchar(20)) as cd_lote_produto,
    cast(null as char(1)) as ic_tipo_lancto_movimento,
    cast(null as varchar(30)) as nm_atributo_produto_saldo,
    0 as 'cd_pedido_venda',
    0 as 'cd_item_pedido_venda',
    cast(null as char(15)) as nm_fantasia_usuario,
    'N' as ic_movimento_composicao,
    0 as cd_movimento_estoque_origem,
    cast(null as float )  as vl_unitario_movimento,
    cast(null as integer) as cd_item_movimento_estoque,
    cast(null as float)   as qt_movimento_estoque_comp,
    cast(null as float)   as vl_custo_mov_estoque_comp,
    cast(null as float)   as vl_custo_medio,
    cast(null as float)   as vl_margem_produto,    
    cast(null as float)   as vl_custo_produto,
    cast(null as float)   as vl_custo_comissao

  end

end


-------------------------------------------------------------------------------
if @ic_parametro = 2    -- Consulta Movimentação do Estoque do Produto 
                        -- (Filtrado por Tipo de Movimento)
-------------------------------------------------------------------------------
begin

  select 
    me.cd_produto,
    p.nm_fantasia_produto,
    Case 
      When IsNull(gp.cd_mascara_grupo_produto, '') = ''
      then IsNull(p.cd_mascara_produto, '')
      Else dbo.fn_formata_mascara(IsNull(gp.cd_mascara_grupo_produto, ''), IsNull(p.cd_mascara_produto, ''))
    End as 'Mascara',
    p.nm_produto,
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
    isnull(@vl_saldo_inicial,0.00) as 'Saldo_Inicial',
    case when tme.ic_mov_tipo_movimento='E'then
      (me.qt_movimento_estoque) else 0 end              as 'Entrada',
    case when ic_mov_tipo_movimento='S'then
      (me.qt_movimento_estoque) else 0 end              as 'Saida',
    cast(0.00 as float) as Saldo,
    me.cd_lote_produto,
    me.ic_tipo_lancto_movimento,
    tme.nm_atributo_produto_saldo,
    u.nm_fantasia_usuario,
    IsNull((Select top 1 'S' from movimento_estoque_composicao where cd_movimento_estoque = me.cd_movimento_estoque),'N') as ic_movimento_composicao,
    me.cd_movimento_estoque_origem,
    isnull(me.vl_unitario_movimento,0) as vl_unitario_movimento,
    case when ic_mov_tipo_movimento='E'
    then
      0.00 
    else
      case when isnull(me.vl_custo_contabil_produto,0)>0 then
          isnull(me.vl_unitario_movimento,0)/isnull(me.vl_custo_contabil_produto,0)
      else
          case when isnull(pc.vl_custo_produto,0)>0 then
            isnull(me.vl_unitario_movimento,0)/isnull(pc.vl_custo_produto,0)
          else
            0.00 end
      end
    end                                                      as vl_margem_produto

  into
    #Movimento_Estoque
  from 
    Movimento_Estoque me left outer join 
    Tipo_Movimento_Estoque tme 
      on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque Left Outer Join
    Tipo_Documento_Estoque tde 
      on me.cd_tipo_documento_estoque = tde.cd_tipo_documento_estoque Left Outer Join
    Tipo_Destinatario td       
      on me.cd_tipo_destinatario = td.cd_tipo_destinatario Left Outer Join
    Produto p                  
      on me.cd_produto = p.cd_produto Left Outer Join
    Produto_Custo pc
      on pc.cd_produto = p.cd_produto Left Outer Join
    Grupo_Produto gp
      on p.cd_grupo_produto = gp.cd_grupo_produto Left Outer Join
    Usuario u
      on me.cd_usuario = u.cd_usuario
  where 
    me.dt_movimento_estoque between @dt_inicial and @dt_final and
    ((@cd_produto = 0) or (me.cd_produto = @cd_produto))      and
    me.cd_fase_produto = @cd_fase_produto                     and
    me.cd_tipo_movimento_estoque = @cd_tipo_movimento_estoque
    and (me.cd_lote_produto = IsNull(@cd_lote_produto,'') or IsNull(@cd_lote_produto,'') = '')
  order by 
    me.dt_movimento_estoque,
    me.cd_movimento_estoque 

  if exists(select top 1 * from #Movimento_Estoque)
  begin
    if ( IsNull(@ic_comp_movimento_estoque,'N') = 'N' )   
       select 
	      	*,
	      	cast(null as integer) as cd_item_movimento_estoque,
	      	cast(null as float) as qt_movimento_estoque_comp,
	      	cast(null as float) as vl_custo_mov_estoque_comp,
		      cast(null as float) as vl_custo_medio
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
            Movimento_Estoque_Composicao 
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
    @cd_produto as cd_produto,
    cast(null as varchar(30)) as nm_fantasia_produto,
    cast(null as varchar(20)) as Mascara,
    cast(null as int) as cd_movimento_estoque,
    cast(null as datetime) as dt_movimento_estoque,
    cast(null as char(1)) as ic_consig_movimento,
    cast(null as char(1)) as ic_terceiro_movimento,
    cast(null as varchar(255)) as nm_historico_movimento,
    cast(null as varchar(30)) as nm_tipo_movimento_estoque,
    cast(null as varchar(30)) as nm_tipo_documento_estoque,
    cast(null as varchar(20)) as cd_documento_movimento,
    cast(null as int) as cd_item_documento,
    cast(null as varchar(30)) as nm_tipo_destinatario,
    cast(null as varchar(40)) as nm_destinatario,
    cast(null as float) as vl_custo_contabil_produto,
    cast(null as float) as vl_fob_produto,
    cast(null as float) as vl_fob_convertido,
    isnull(@vl_saldo_inicial,0.00) as 'Saldo_Inicial',
    cast(null as float) as 'Entrada',
    cast(null as float) as 'Saida',
    isnull(@vl_saldo_inicial,0.00) as Saldo,
    cast(null as varchar(20)) as cd_lote_produto,
    cast(null as char(1)) as ic_tipo_lancto_movimento,
    cast(null as varchar(30)) as nm_atributo_produto_saldo,
    cast(null as char(15)) as nm_fantasia_usuario,
    'N' as ic_movimento_composicao,
    0 as cd_movimento_estoque_origem,
    cast(null as integer) as cd_item_movimento_estoque,
    cast(null as float) as qt_movimento_estoque_comp,
    cast(null as float) as vl_custo_mov_estoque_comp,
    cast(null as float) as vl_custo_medio,
    cast(null as float) as vl_margem_produto
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
               cast(replace(Cast(ps.qt_consumo_produto as varchar(20)),'0','1') as float))*30),0.00)  as 'Duracao'
    from Produto_Saldo ps
    left outer join Produto p on
      ps.cd_produto=p.cd_produto
    where ps.cd_produto      = @cd_produto and
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
