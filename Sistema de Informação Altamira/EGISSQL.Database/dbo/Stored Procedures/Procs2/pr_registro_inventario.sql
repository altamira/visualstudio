
create procedure pr_registro_inventario
@ic_parametro       int,
@dt_base            datetime,
@cd_fase_produto    int,
@ic_gerar_mastersaf char(1) = 'N',
@cd_usuario         int     = 999,
@qt_arredondamento  int     = 6
as

  declare @dt_custo            datetime
  declare @dt_inicial_controle datetime

  set @qt_arredondamento = 2 --> Colocar no parametro custo

  set @dt_inicial_controle = (@dt_base - 30)
  set @dt_custo = convert(datetime,left(convert(varchar,@dt_base,121),10)+' 23:59:00',121)

-- 

select
  @qt_arredondamento = isnull(qt_arredondamento,@qt_arredondamento)
from
  parametro_custo
where
  cd_empresa = dbo.fn_empresa()


-- TABELA TEMPORÁRIA COM OS CAMPOS DE INVENTARIO

create table #GrupoInventario
 (GrupoInventario        int null,
  Fase                   varchar(60) null,
  CodFase                int null,
  CodProduto             int null,
  CodGrupoProduto        int null,
  CodGrupoEstoque        int null,
  CodTipoGrupoInventario int null,
  CodLancamentoPadrao int null,
  PVE                 int null,
  ItemPVE             int null,
  TipoDestinatario    int null,
  Destinatario        int null,
  GrupoEstoque        varchar(60) null,
  GrupoProduto        varchar(60) null,
  ClassificacaoFiscal varchar(60) null,
  Codigo              varchar(20) null,
  Produto             varchar(30) null, 
  Discriminacao       varchar(60) null,
  Unidade             char(10) null,
  PesoUnitario        float null,
  Quantidade          float null, 
  Unitario            float null,
  Total               decimal(25,2) null,
  CodMetodoValoracao  int null,
  MateriaPrima        varchar(20) null,
  Bitola              varchar(20) null,
  Especial            char(1) null,
  OrigemInventario    char(2) null )


SET LOCK_TIMEOUT 15000

-------------------------------------------------------------------------------
if @ic_parametro in (1, 2)   -- INVENTARIO DOS PRODUTOS PADRÃO
-------------------------------------------------------------------------------
begin

  -- SALDOS DE PRODUTOS PRÓPRIOS EM ESTOQUE

  insert into #GrupoInventario
  select
    --Grupo de Inventário ( Grupo de Produto ou Produto )
    case when isnull(pc.cd_grupo_inventario,0)=0 
         then gpc.cd_grupo_inventario
         else pc.cd_grupo_inventario end                                      as GrupoInventario,
    fp.nm_fase_produto                                                        as Fase,
    fec.cd_fase_produto                                                       as CodFase,
    fec.cd_produto                                                            as CodProduto,
    ge.cd_grupo_estoque                                                       as CodGrupoEstoque,
    gp.cd_grupo_produto                                                       as CodGrupoProduto,
    isnull(gi.cd_tipo_grupo_inventario, 
    isnull(pv.cd_tipo_grupo_inventario, gpv.cd_tipo_grupo_inventario))        as CodTipoGrupoInventario,

    isnull(gi.cd_lancamento_padrao, 
    isnull(pv.cd_lancamento_padrao, gpv.cd_lancamento_padrao))                as CodLancamentoPadrao,
    0                                                                         as PVE,
    0                                                                         as ItemPVE,
    0                                                                         as TipoDestinatario,
    0                                                                         as Destinatario,
    ge.nm_grupo_estoque                                                       as GrupoEstoque,
    gp.nm_grupo_produto                                                       as GrupoProduto,
    cf.cd_mascara_classificacao                                               as ClassificacaoFiscal,
    dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto, p.cd_mascara_produto) as Codigo,
    p.nm_fantasia_produto                                                     as Produto,
    ltrim(rtrim(p.nm_produto))                                                as Discriminacao,
    isnull(um.sg_unidade_medida,ump.sg_unidade_medida)                        as Unidade, 
    p.qt_peso_bruto                                                           as PesoUnitario,
    isnull(cast(fec.qt_atual_prod_fechamento as decimal(25,3)),0)             as Quantidade,
    round((fec.vl_custo_prod_fechamento / isnull(fec.qt_atual_prod_fechamento,0)),@qt_arredondamento) as Unitario,
    cast(fec.vl_custo_prod_fechamento as decimal(25,2))                              as Total,
    mv.cd_metodo_valoracao                                                           as CodMetodoValoracao,
    mp.nm_fantasia_mat_prima                                                         as MateriaPrima,
    b.nm_fantasia_bitola                                                             as Bitola,
    'N'                                                                              as Especial,
    'P'                                                                              as OrigemInventario

  from 
    Produto_Fechamento fec                      with(nolock)
    inner join Fase_Produto fp                  with(nolock) on fec.cd_fase_produto        = fp.cd_fase_produto
    left outer join Produto p                   with(nolock) on fec.cd_produto             = p.cd_produto 
    left outer join Produto_Custo pc            with(nolock) on pc.cd_produto              = p.cd_produto
    left outer join Grupo_Produto gp            with(nolock) on gp.cd_grupo_produto        = p.cd_grupo_produto   
    left outer join Grupo_Produto_Custo gpc     with(nolock) on gpc.cd_grupo_produto       = p.cd_grupo_produto   
    left outer join Unidade_Medida um           with(nolock) on um.cd_unidade_medida       = gpc.cd_unidade_valoracao
    left outer join Unidade_Medida ump          with(nolock) on ump.cd_unidade_medida      = p.cd_unidade_medida
    left outer join Produto_Fiscal pf           with(nolock) on pf.cd_produto              = p.cd_produto 
    left outer join Classificacao_Fiscal cf     with(nolock) on pf.cd_classificacao_fiscal = cf.cd_classificacao_fiscal


    left outer join Metodo_Valoracao mv         with(nolock) on fec.cd_metodo_valoracao    = mv.cd_metodo_valoracao 
    left outer join Grupo_Inventario gi         with(nolock) on gi.cd_grupo_inventario     = isnull(pc.cd_grupo_inventario, gpc.cd_grupo_inventario)
    left outer join Grupo_Produto_Valoracao gpv with(nolock) on gpv.cd_grupo_produto       = p.cd_grupo_produto and
                                                                gpv.cd_fase_produto        = fec.cd_fase_produto and
                                                                gpv.cd_metodo_valoracao    = fec.cd_metodo_valoracao 

    left outer join Produto_Valoracao pv        with(nolock) on pv.cd_produto              = fec.cd_produto     and
                                                                pv.cd_fase_produto         = fec.cd_fase_produto and 
                                                                pv.cd_metodo_valoracao     = fec.cd_metodo_valoracao

    left outer join Materia_Prima mp            with(nolock) on pc.cd_mat_prima            = mp.cd_mat_prima
    left outer join Bitola b                    with(nolock) on pc.cd_bitola               = b.cd_bitola
    left outer join Grupo_Estoque ge            with(nolock) on ge.cd_grupo_estoque        = isnull(pc.cd_grupo_estoque, gpc.cd_grupo_estoque)

  where 
    isnull(mv.ic_controla_inventario,'N') = 'S' 
    and
    fec.cd_fase_produto = case when @cd_fase_produto = 0 then fec.cd_fase_produto else @cd_fase_produto end and      
    fec.dt_produto_fechamento = @dt_base and
    isnull(fec.qt_atual_prod_fechamento,0) > 0      
    and isnull(pc.ic_peps_produto,'N') = 'S'            
    and isnull(fp.ic_registro_inventario,'S')='S' 


  -- SALDOS DE INVENTÁRIO CONFORME DIGITAÇÃO DE TERCEIROS

  insert into #GrupoInventario
  select
    ig.cd_grupo_inventario      as GrupoInventario,
    fp.nm_fase_produto          as Fase,
    ig.cd_fase_produto          as CodFase,
    ig.cd_produto               as CodProduto,
    gp.cd_grupo_produto         as CodGrupoProduto,
    ge.cd_grupo_estoque         as CodGrupoEstoque,
    isnull(gi.cd_tipo_grupo_inventario, isnull(pv.cd_tipo_grupo_inventario, gpv.cd_tipo_grupo_inventario)) as CodTipoGrupoInventario,
    isnull(gi.cd_lancamento_padrao, isnull(pv.cd_lancamento_padrao, gpv.cd_lancamento_padrao)) as CodLancamentoPadrao,
    ig.cd_pedido_venda          as PVE,
    ig.cd_item_pedido_venda     as ItemPVE,
    ig.cd_tipo_destinatario     as TipoDestinatario,
    ig.cd_destinatario          as Destinatario,
    ge.nm_grupo_estoque         as GrupoEstoque,
    gp.nm_grupo_produto         as GrupoProduto,
    cf.cd_mascara_classificacao as ClassificacaoFiscal,
    case when isnull(ig.cd_produto,0) <> 0 then 
      dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto, p.cd_mascara_produto) 
    else
      'PVE '+cast(ig.cd_pedido_venda as varchar)+'/'+cast(ig.cd_item_pedido_venda as varchar) 
    end as Codigo,
    p.nm_fantasia_produto as Produto,
    isnull(p.nm_produto, ig.nm_produto_inventario) as Discriminacao,
    um.sg_unidade_medida as Unidade, 
    p.qt_peso_bruto as PesoUnitario,
    isnull(cast(ig.qt_inventario_gestao as decimal(25,3)),0) as Quantidade,
    (ig.vl_custo_total_gestao / isnull(ig.qt_inventario_gestao,0)) as Unitario,
    cast(ig.vl_custo_total_gestao as decimal(25,2)) as Total,
    null                       as CodMetodoValoracao,
    mp.nm_fantasia_mat_prima   as MateriaPrima,
    b.nm_fantasia_bitola       as Bitola,
    'N'                        as Especial,
    'D'                        as OrigemInventario

  from Inventario_Gestao ig               with(nolock) 
    left outer join Produto p             with(nolock) on ig.cd_produto = p.cd_produto 
    left outer join Produto_Custo pc      with(nolock) on p.cd_produto = pc.cd_produto
    left outer join Pedido_Venda_Item pvi with(nolock) on ig.cd_pedido_venda = pvi.cd_pedido_venda and
                                                          ig.cd_item_pedido_venda = pvi.cd_item_pedido_venda
    left outer join Grupo_Produto gp with(nolock) on gp.cd_grupo_produto = isnull(p.cd_grupo_produto, pvi.cd_grupo_produto)   
    left outer join Grupo_Produto_Custo gpc with(nolock) on gpc.cd_grupo_produto = p.cd_grupo_produto   
    left outer join Unidade_Medida um with(nolock) on um.cd_unidade_medida = isnull(gpc.cd_unidade_valoracao, isnull(pvi.cd_unidade_medida, p.cd_unidade_medida))
    left outer join Produto_Fiscal pf with(nolock) on p.cd_produto = pf.cd_produto 
    left outer join Classificacao_Fiscal cf with(nolock) on isnull(pf.cd_classificacao_fiscal, ig.cd_classificacao_fiscal) = cf.cd_classificacao_fiscal
    left outer join Fase_Produto fp with(nolock) on ig.cd_fase_produto = fp.cd_fase_produto
    left outer join Grupo_Inventario gi with(nolock) on gi.cd_grupo_inventario = ig.cd_grupo_inventario
    left outer join Grupo_Produto_Valoracao gpv with(nolock) on gpv.cd_grupo_produto = isnull(pvi.cd_grupo_produto, p.cd_grupo_produto) and
                                                                gpv.cd_fase_produto = ig.cd_fase_produto 
    left outer join Produto_Valoracao pv with(nolock) on pv.cd_produto = ig.cd_produto and
                                                         pv.cd_fase_produto = ig.cd_fase_produto
    left outer join Materia_Prima mp with(nolock) on pc.cd_mat_prima = mp.cd_mat_prima
    left outer join Bitola b with(nolock) on pc.cd_bitola = b.cd_bitola
    left outer join Grupo_Estoque ge with(nolock) on ge.cd_grupo_estoque = isnull(pc.cd_grupo_estoque, gpc.cd_grupo_estoque)
  where 
    ig.cd_fase_produto = case when @cd_fase_produto = 0 
                          then ig.cd_fase_produto 
                          else @cd_fase_produto end and      
    ig.dt_fim_inventario_gestao = @dt_base and
    isnull(ig.qt_inventario_gestao,0) > 0 
    and isnull(fp.ic_registro_inventario,'S')='S' 

/*
  -- SALDOS DE PRODUTOS EM PODER DE TERCEIROS
  insert into #GrupoInventario
  select
    2 as GrupoInventario,
    fp.nm_fase_produto as Fase,
    gp.nm_grupo_produto as GrupoProduto,
    cf.cd_mascara_classificacao as ClassificacaoFiscal,
    dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto, p.cd_mascara_produto) as Codigo,
    p.nm_fantasia_produto as Produto,
    p.nm_produto as Discriminacao,
    um.sg_unidade_medida as Unidade, 
    ((isnull(fec.qt_terc_prod_fechamento,0) +
      isnull(fec.qt_consig_prod_fechamento,0)) * (-1)) as Quantidade,
    (fec.vl_custo_prod_fechamento / ((isnull(fec.qt_terc_prod_fechamento,0) +
                                      isnull(fec.qt_consig_prod_fechamento,0)) * (-1))) as Unitario,
    fec.vl_custo_prod_fechamento as Total      
  from Produto_Fechamento fec
    inner join Produto p on p.cd_produto = fec.cd_produto
    inner join Grupo_Produto gp on gp.cd_grupo_produto = p.cd_grupo_produto
    inner join Unidade_Medida um on p.cd_unidade_medida = um.cd_unidade_medida
    inner join Produto_Fiscal pf on p.cd_produto = pf.cd_produto 
    inner join Classificacao_Fiscal cf on pf.cd_classificacao_fiscal = cf.cd_classificacao_fiscal
    inner join Fase_Produto fp on fec.cd_fase_produto = fp.cd_fase_produto
  where fec.dt_produto_fechamento = @dt_base and
    fec.cd_fase_produto = case when @cd_fase_produto = 0 
                          then fec.cd_fase_produto 
                          else @cd_fase_produto
                          end and
    ((isnull(fec.qt_terc_prod_fechamento,0) +
      isnull(fec.qt_consig_prod_fechamento,0)) < 0)

  -- SALDOS DE PRODUTOS DE TERCEIROS EM NOSSO PODER
  insert into #GrupoInventario
  select
    3 as cd_grupo_inventario,
    fp.nm_fase_produto as Fase,
    gp.nm_grupo_produto as GrupoProduto,
    cf.cd_mascara_classificacao as ClassificacaoFiscal,
    dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto, p.cd_mascara_produto) as Codigo,
    p.nm_fantasia_produto as Produto,
    p.nm_produto as Discriminacao,
    um.sg_unidade_medida as Unidade, 
    (isnull(fec.qt_terc_prod_fechamento,0) +
     isnull(fec.qt_consig_prod_fechamento,0)) as Quantidade,
    (fec.vl_custo_prod_fechamento / (isnull(fec.qt_terc_prod_fechamento,0) +
                                     isnull(fec.qt_consig_prod_fechamento,0))) as Unitario,
    fec.vl_custo_prod_fechamento as Total      
  from Produto_Fechamento fec
    inner join Produto p on p.cd_produto = fec.cd_produto
    inner join Grupo_Produto gp on gp.cd_grupo_produto = p.cd_grupo_produto
    inner join Unidade_Medida um on p.cd_unidade_medida = um.cd_unidade_medida
    inner join Produto_Fiscal pf on p.cd_produto = pf.cd_produto 
    inner join Classificacao_Fiscal cf on pf.cd_classificacao_fiscal = cf.cd_classificacao_fiscal
    inner join Fase_Produto fp on fec.cd_fase_produto = fp.cd_fase_produto
  where fec.dt_produto_fechamento = @dt_base and
    fec.cd_fase_produto = case when @cd_fase_produto = 0 
                          then fec.cd_fase_produto 
                          else @cd_fase_produto
                          end and
    (isnull(fec.qt_terc_prod_fechamento,0) +
     isnull(fec.qt_consig_prod_fechamento,0)) > 0

*/

  -----------------------------------------------------------------------------
  if @ic_parametro = 2  -- INVENTARIO DOS PRODUTOS ESPECIAIS
  -----------------------------------------------------------------------------
  begin

    -- NOTAS FISCAIS FATURADAS APÓS O PERÍODO FINAL
    select nsi.cd_pedido_venda, nsi.cd_item_pedido_venda, 
      sum(nsi.qt_item_nota_saida - (case when (nsi.dt_cancel_item_nota_saida is null) then
                                      case when (nsi.dt_restricao_item_nota < @dt_base) then 
                                        isnull(nsi.qt_devolucao_item_nota,0) 
                                      else
                                        0
                                      end
                                    else
                                      nsi.qt_item_nota_saida
                                    end)) as qt_item_faturado
    into #NotaSaidaCustoFaturado
    from Nota_Saida_Item nsi with(nolock) 
      inner join Nota_Saida ns with(nolock)           on nsi.cd_nota_saida = ns.cd_nota_saida 
      inner join Pedido_Venda_Item pvi with(nolock)   on nsi.cd_pedido_venda = pvi.cd_pedido_venda and
                                                         nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda
      inner join Operacao_Fiscal op with(nolock)      on nsi.cd_operacao_fiscal = op.cd_operacao_fiscal
      inner join Grupo_Produto gp with(nolock)        on pvi.cd_grupo_produto = gp.cd_grupo_produto
      inner join Grupo_Produto_Custo gpc with(nolock) on pvi.cd_grupo_produto = gpc.cd_grupo_produto 
    where (nsi.dt_nota_saida > @dt_base) and
      (not (isnull(nsi.dt_cancel_item_nota_saida, isnull(dt_restricao_item_nota, @dt_base)) > @dt_base)) and
      isnull(gp.ic_especial_grupo_produto,'N') = 'S' and
      isnull(gpc.ic_custo,'N')                 = 'S' and
      isnull(op.ic_estoque_op_fiscal,'N')      = 'S' and
      isnull(op.ic_comercial_operacao,'N')     = 'S' 
    group by nsi.cd_pedido_venda, nsi.cd_item_pedido_venda

    -- NOTAS CANCELADAS/DEVOLVIDAS APÓS O PERÍODO FINAL MAS 
    -- QUE ESTAVAM FATURADAS ATÉ O PERIODO FINAL
    select nsi.cd_pedido_venda, nsi.cd_item_pedido_venda, 
      sum(case when (isnull(nsi.qt_devolucao_item_nota,0) <> 0) 
          then nsi.qt_devolucao_item_nota
          else nsi.qt_item_nota_saida
          end) as qt_item_devolvido
    into #NotaSaidaCustoDevolvido
    from Nota_Saida_Item nsi with(nolock) 
      inner join Nota_Saida ns with(nolock) on nsi.cd_nota_saida = ns.cd_nota_saida 
      inner join Pedido_Venda_Item pvi with(nolock)   on nsi.cd_pedido_venda = pvi.cd_pedido_venda and
                                                         nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda
      inner join Operacao_Fiscal op with(nolock)      on nsi.cd_operacao_fiscal = op.cd_operacao_fiscal
      inner join Grupo_Produto gp with(nolock)        on pvi.cd_grupo_produto = gp.cd_grupo_produto
      inner join Grupo_Produto_Custo gpc with(nolock) on pvi.cd_grupo_produto = gpc.cd_grupo_produto 
    where (isnull(nsi.dt_cancel_item_nota_saida, dt_restricao_item_nota) > @dt_base) and
      isnull(gp.ic_especial_grupo_produto,'N') = 'S' and
      isnull(gpc.ic_custo,'N')                 = 'S' and
      isnull(op.ic_estoque_op_fiscal,'N')      = 'S' and
      isnull(op.ic_comercial_operacao,'N')     = 'S' and
      ns.dt_nota_saida <= @dt_base
    group by nsi.cd_pedido_venda, nsi.cd_item_pedido_venda

    -- PEDIDOS DE VENDA EM PROCESSO CONFORME HISTÓRICO DO PVE

    insert into #GrupoInventario
    select
      1 as GrupoInventario,
      fp.nm_fase_produto as Fase, -- Processo
      pvihc.cd_fase_produto as CodFase, 
      0 as CodProduto,
      gp.cd_grupo_produto                                               as CodGrupoProduto,
      ge.cd_grupo_estoque                                               as CodGrupoEstoque,
      isnull(gi.cd_tipo_grupo_inventario, gpv.cd_tipo_grupo_inventario) as CodTipoGrupoInventario,
      isnull(gi.cd_lancamento_padrao, gpv.cd_lancamento_padrao)         as CodLancamentoPadrao,
      pvihc.cd_pedido_venda                                             as PVE,
      pvihc.cd_item_pedido_venda                                        as ItemPVE,
      0                                                                 as TipoDestinatario, 
      0                                                                 as Destinatario,
      ge.nm_grupo_estoque as GrupoEstoque,
      gp.nm_grupo_produto as GrupoProduto,
      cf.cd_mascara_classificacao as ClassificacaoFiscal,
      'PVE '+cast(pvihc.cd_pedido_venda as varchar)+'/'+cast(pvihc.cd_item_pedido_venda as varchar) as Codigo,

      isnull(pvi.nm_fantasia_produto,(select nm_fantasia_produto
                                      from Pedido_Venda_Item
                                      where cd_pedido_venda = pvihc.cd_pedido_venda and
                                            cd_item_pedido_venda = 1)) as Produto,

      isnull(pvi.nm_produto_pedido,(select nm_produto_pedido

                                      from Pedido_Venda_Item
                                      where cd_pedido_venda = pvihc.cd_pedido_venda and
                                            cd_item_pedido_venda = 1)) as Discriminacao,
      'KG'                      as Unidade, 
      pvihc.qt_peso_bruto_saldo as PesoUnitario,
      pvihc.qt_peso_bruto_saldo as PesoBruto,
      (pvihc.vl_custo_total_item_ped_venda / pvihc.qt_peso_bruto_saldo) as Unitario,
      cast(pvihc.vl_custo_total_item_ped_venda as decimal(25,2)) as Total,
      pvihc.cd_metodo_valoracao as CodMetodoValoracao,
      null                      as MateriaPrima,
      null                      as Bitola,
      'S'                       as Especial,
      'E'                       as OrigemInventario

    from Pedido_Venda_Item_Historico_Custo pvihc with(nolock) 
      inner join Materia_Prima mp with(nolock) on mp.cd_mat_prima = pvihc.cd_materia_prima
      inner join Grupo_Produto gp with(nolock) on gp.cd_grupo_produto = pvihc.cd_grupo_produto
      inner join Grupo_Produto_Fiscal gpf with(nolock) on gp.cd_grupo_produto = gpf.cd_grupo_produto
      inner join Grupo_Produto_Custo gpc with(nolock) on gp.cd_grupo_produto = gpc.cd_grupo_produto
      inner join Fase_Produto fp with(nolock) on pvihc.cd_fase_produto = fp.cd_fase_produto
      left outer join Grupo_Inventario gi with(nolock) on gi.cd_grupo_inventario = 1
      left outer join Grupo_Produto_Valoracao gpv with(nolock) on gpv.cd_grupo_produto = pvihc.cd_grupo_produto and
                                                                  gpv.cd_fase_produto = pvihc.cd_fase_produto 
      left outer join Grupo_Estoque ge with(nolock) on ge.cd_grupo_estoque = gpc.cd_grupo_estoque
      left outer join Classificacao_Fiscal cf with(nolock) on gpf.cd_classificacao_fiscal = cf.cd_classificacao_fiscal
      left outer join Pedido_Venda_Item pvi with(nolock) on pvihc.cd_pedido_venda = pvi.cd_pedido_venda and
                                                            pvihc.cd_item_pedido_venda = pvi.cd_item_pedido_venda
    where pvihc.dt_apuracao_custo <= @dt_custo and
      isnull(pvihc.dt_baixa_estoque, @dt_custo) >= @dt_custo and      
      pvihc.cd_fase_produto = case when (@cd_fase_produto = 0) or (@cd_fase_produto = 2) 
                              then 2 else 0 end

    and isnull(fp.ic_registro_inventario,'S')='S' 

    -- PEDIDOS DE VENDA EM PROCESSO CONFORME COMPRAS 

    insert into #GrupoInventario
    select
      1                  as GrupoInventario,
      fp.nm_fase_produto as Fase, -- Processo
      fp.cd_fase_produto as CodFase,
      0                                                                 as CodProduto,
      gp.cd_grupo_produto                                               as CodGrupoProduto,
      ge.cd_grupo_estoque                                               as CodGrupoEstoque,
      isnull(gi.cd_tipo_grupo_inventario, gpv.cd_tipo_grupo_inventario) as CodTipoGrupoInventario,
      isnull(gi.cd_lancamento_padrao, gpv.cd_lancamento_padrao)         as CodLancamentoPadrao,
      pvi.cd_pedido_venda                                               as PVE,
      pvi.cd_item_pedido_venda                                          as ItemPVE,
      0                                                                 as TipoDestinatario,
      0                           as Destinatario,
      ge.nm_grupo_estoque         as GrupoEstoque,
      gp.nm_grupo_produto         as GrupoProduto,
      cf.cd_mascara_classificacao as ClassificacaoFiscal,
      'PVE '+cast(pvi.cd_pedido_venda as varchar)+'/'+cast(pvi.cd_item_pedido_venda as varchar) as Codigo,
      isnull(pvi.nm_fantasia_produto,'') as Produto,
      isnull(pvi.nm_produto_pedido,'')   as Discriminacao,
      'KG'                               as Unidade, 

      sum(nei.qt_pesbru_nota_entrada) / 
         pvi.qt_item_pedido_venda *
        ((case when pvi.dt_cancelamento_item is null then
            pvi.qt_saldo_pedido_venda
          else
            pvi.qt_item_pedido_venda
          end) + isnull(nsf.qt_item_faturado,0) - 
                 isnull(nsd.qt_item_devolvido,0)) as PesoUnitario,

      sum(nei.qt_pesbru_nota_entrada) / 
         pvi.qt_item_pedido_venda *
        ((case when pvi.dt_cancelamento_item is null then
            pvi.qt_saldo_pedido_venda
          else
            pvi.qt_item_pedido_venda
          end) + isnull(nsf.qt_item_faturado,0) - 
                 isnull(nsd.qt_item_devolvido,0)) as PesoBruto,

      (case when (op.ic_imp_operacao_fiscal = 'S') then
         -- SE IMPORTAÇÃO
         cast((sum(cast(isnull(nei.vl_total_nota_entr_item,0) as decimal(25,2))) * 1.5) as decimal(25,2))
       else
         -- SE COMPRA MERCADO NACIONAL
         cast((sum(cast(cast(isnull(nei.vl_total_nota_entr_item,0) as decimal(25,2)) *
                cast(((100-nei.pc_icms_nota_entrada)/100) as decimal(25,2)) as decimal(25,2))) * 1.5) as decimal(25,2))
       end) / (sum(nei.qt_pesbru_nota_entrada) / 
               pvi.qt_item_pedido_venda *
              ((case when pvi.dt_cancelamento_item is null then
                  pvi.qt_saldo_pedido_venda
                else
                  pvi.qt_item_pedido_venda
                end) + isnull(nsf.qt_item_faturado,0) - 
                       isnull(nsd.qt_item_devolvido,0))) as Unitario,
      cast(
      case when (op.ic_imp_operacao_fiscal = 'S') then
        -- SE IMPORTAÇÃO
        sum(isnull(nei.vl_total_nota_entr_item,0) * 1.5)
      else
        -- SE COMPRA MERCADO NACIONAL
        sum(isnull(nei.vl_total_nota_entr_item,0) *
          ((100-nei.pc_icms_nota_entrada)/100) * 1.5)
      end / 
         pvi.qt_item_pedido_venda *
        ((case when pvi.dt_cancelamento_item is null then
            pvi.qt_saldo_pedido_venda
          else
            pvi.qt_item_pedido_venda
          end) + isnull(nsf.qt_item_faturado,0) - 
                 isnull(nsd.qt_item_devolvido,0)) as decimal(25,2)) as CustoTotal,

      2    as CodMetodoValoracao,
      null as MateriaPrima,
      null as Bitola,
      'S'  as Especial,
      'E'  as OrigemInventario
    from Nota_Entrada_Item nei with(nolock) 
      inner join Pedido_Compra_Item pci with(nolock) on nei.cd_pedido_compra = pci.cd_pedido_compra and
                                                        nei.cd_item_pedido_compra = pci.cd_item_pedido_compra
      inner join Pedido_Venda_Item pvi with(nolock) on pci.cd_pedido_venda = pvi.cd_pedido_venda and
                                                       pci.cd_item_pedido_venda = pvi.cd_item_pedido_venda
      inner join Pedido_Venda pv with(nolock) on pvi.cd_pedido_venda = pv.cd_pedido_venda
      inner join Materia_Prima mp with(nolock) on pci.cd_materia_prima = mp.cd_mat_prima
      inner join Operacao_Fiscal op with(nolock) on nei.cd_operacao_fiscal = op.cd_operacao_fiscal
      inner join Grupo_Produto gp with(nolock) on gp.cd_grupo_produto = pvi.cd_grupo_produto
      inner join Grupo_Produto_Custo gpc with(nolock) on gpc.cd_grupo_produto = pvi.cd_grupo_produto
      inner join Grupo_Produto_Fiscal gpf with(nolock) on gp.cd_grupo_produto = gpf.cd_grupo_produto
      inner join Fase_Produto fp with(nolock) on fp.cd_fase_produto = case when (@cd_fase_produto = 0) or (@cd_fase_produto = 2) 
                                                                      then 2 else 0 end
      left outer join Grupo_Inventario gi with(nolock) on gi.cd_grupo_inventario = 1
      left outer join Grupo_Estoque ge with(nolock) on ge.cd_grupo_estoque = gpc.cd_grupo_estoque
      left outer join Classificacao_Fiscal cf with(nolock) on gpf.cd_classificacao_fiscal = cf.cd_classificacao_fiscal
      left outer join Grupo_Produto_Valoracao gpv with(nolock) on gpv.cd_grupo_produto = pvi.cd_grupo_produto and
                                                                  gpv.cd_fase_produto = case when (@cd_fase_produto = 0) or (@cd_fase_produto = 2) 
                                                                                        then 2 else 0 end
      left outer join #NotaSaidaCustoFaturado nsf with(nolock) on nsf.cd_pedido_venda = pvi.cd_pedido_venda and
                                                                  nsf.cd_item_pedido_venda = pvi.cd_item_pedido_venda
      left outer join #NotaSaidaCustoDevolvido nsd with(nolock) on nsd.cd_pedido_venda = pvi.cd_pedido_venda and
                                                                   nsd.cd_item_pedido_venda = pvi.cd_item_pedido_venda

    where 
      -- QUE TENHAM COMPRA ATÉ A DATA ATUAL
      nei.dt_item_receb_nota_entrad <= @dt_base and
      -- QUE NÃO SEJAM ROSCAS
      isnull(nei.cd_produto,0) <> 53786 and 
      -- QUE NÃO ESTEJAM CANCELADOS
      ((pvi.dt_cancelamento_item is null) or (pvi.dt_cancelamento_item > @dt_base)) and
      -- QUE TENHAM QUANTIDADE
      (((case when pvi.dt_cancelamento_item is null then
           pvi.qt_saldo_pedido_venda
         else
           pvi.qt_item_pedido_venda
         end) + isnull(nsf.qt_item_faturado,0) - 
                isnull(nsd.qt_item_devolvido,0)) > 0) and
      -- QUE NÃO FORAM FABRICADOS ATÉ A DATA FINAL
      (pvi.dt_entrega_fabrica_pedido is null or pvi.dt_entrega_fabrica_pedido > @dt_base) and
      -- NAO BUSCAR SMO
      isnull(pv.ic_smo_pedido_venda, 'N') = 'N' and
      -- NÃO BUSCAR PEDIDOS DE VENDA COM VALOR SIMBÓLICO (R$ 0,01)
      pvi.vl_unitario_item_pedido <> 0.01 and
      -- SOMENTE GRUPOS QUE CONTROLAM CUSTO
      isnull(gpc.ic_custo,'N')                 = 'S' and
      isnull(gp.ic_especial_grupo_produto,'N') = 'S' 
      and isnull(fp.ic_registro_inventario,'S')='S' 

    group by
      fp.nm_fase_produto, fp.cd_fase_produto, pvi.cd_pedido_venda, pvi.cd_item_pedido_venda, 
      pvi.nm_fantasia_produto, pvi.nm_produto_pedido, op.ic_imp_operacao_fiscal, gp.cd_grupo_produto,
      pvi.dt_cancelamento_item, pvi.qt_item_pedido_venda, pvi.qt_saldo_pedido_venda, nsf.qt_item_faturado, nsd.qt_item_devolvido,
      ge.cd_grupo_estoque, ge.nm_grupo_estoque, gp.nm_grupo_produto, cf.cd_mascara_classificacao,
      gi.cd_tipo_grupo_inventario, gpv.cd_tipo_grupo_inventario, gi.cd_lancamento_padrao, 
      gpv.cd_lancamento_padrao

    -- PRODUTOS ACABADOS PRÓPRIOS OU EM PODER DE TERCEIROS CONFORME HISTÓRICO DO PVE

    select
      pvihc.cd_grupo_inventario   as GrupoInventario,
      fp.nm_fase_produto          as Fase, -- Acabados
      pvihc.cd_fase_produto       as CodFase,
      0                           as CodProduto,
      ge.cd_grupo_estoque         as CodGrupoEstoque,
      isnull(gi.cd_tipo_grupo_inventario, gpv.cd_tipo_grupo_inventario) as CodTipoGrupoInventario,
      isnull(gi.cd_lancamento_padrao, gpv.cd_lancamento_padrao)         as CodLancamentoPadrao,
      pvihc.cd_pedido_venda       as PVE,
      pvihc.cd_item_pedido_venda  as ItemPVE,
      1                           as TipoDestinatario, -- CLIENTE
      isnull(pv.cd_cliente,0)     as Destinatario,
      ge.nm_grupo_estoque         as GrupoEstoque,
      gp.cd_grupo_produto         as CodGrupoProduto,
      gp.nm_grupo_produto         as GrupoProduto,
      cf.cd_mascara_classificacao as ClassificacaoFiscal,
      'PVE '+cast(pvihc.cd_pedido_venda as varchar)+'/'+cast(pvihc.cd_item_pedido_venda as varchar) as Codigo,
      isnull(pvi.nm_fantasia_produto,(select nm_fantasia_produto
                                      from Pedido_Venda_Item
                                      where cd_pedido_venda = pvihc.cd_pedido_venda and
                                            cd_item_pedido_venda = 1)) as Produto,
      isnull(pvi.nm_produto_pedido,(select nm_produto_pedido
                                      from Pedido_Venda_Item
                                      where cd_pedido_venda = pvihc.cd_pedido_venda and
                                            cd_item_pedido_venda = 1)) as Discriminacao,
      'KG'                           as Unidade, 
      sum(pvihc.qt_peso_bruto_saldo) as PesoBruto,
      cast(sum(pvihc.vl_custo_total_item_ped_venda) as decimal(25,2)) as ValorBase,
      cast(pvihc.vl_preco_lista_pedido as decimal(25,2))              as Preco
    into #PVEAcabado
    from Pedido_Venda_Item_Historico_Custo pvihc with(nolock) 
      inner join Materia_Prima mp with(nolock) on mp.cd_mat_prima = pvihc.cd_materia_prima
      inner join Grupo_Produto gp with(nolock) on gp.cd_grupo_produto = pvihc.cd_grupo_produto
      inner join Grupo_Produto_Fiscal gpf with(nolock) on gp.cd_grupo_produto = gpf.cd_grupo_produto
      inner join Grupo_Produto_Custo gpc with(nolock) on gp.cd_grupo_produto = gpc.cd_grupo_produto
      inner join Fase_Produto fp with(nolock) on pvihc.cd_fase_produto = fp.cd_fase_produto
      left outer join Grupo_Inventario gi with(nolock) on gi.cd_grupo_inventario = pvihc.cd_grupo_inventario
      left outer join Grupo_Estoque ge with(nolock) on ge.cd_grupo_estoque = gpc.cd_grupo_estoque
      left outer join Grupo_Produto_Valoracao gpv with(nolock) on gpv.cd_grupo_produto = pvihc.cd_grupo_produto and
                                                                  gpv.cd_fase_produto = pvihc.cd_fase_produto 
      left outer join Classificacao_Fiscal cf with(nolock) on gpf.cd_classificacao_fiscal = cf.cd_classificacao_fiscal
      left outer join Pedido_Venda_Item pvi with(nolock) on pvihc.cd_pedido_venda = pvi.cd_pedido_venda and
                                                            pvihc.cd_item_pedido_venda = pvi.cd_item_pedido_venda
      left outer join Pedido_Venda pv with(nolock) on pvihc.cd_pedido_venda = pv.cd_pedido_venda
    where pvihc.dt_apuracao_custo <= @dt_custo and
      isnull(pvihc.dt_baixa_estoque, @dt_custo) >= @dt_custo and
      pvihc.cd_fase_produto = case when (@cd_fase_produto = 0) or (@cd_fase_produto = 3) 
                              then 3 else 0 end

      and isnull(fp.ic_registro_inventario,'S')='S' 

    group by

      fp.nm_fase_produto, pvihc.cd_fase_produto, pvihc.cd_grupo_inventario, pv.cd_cliente, pvihc.cd_pedido_venda, 
      pvihc.cd_item_pedido_venda, pvi.nm_fantasia_produto, pvi.nm_produto_pedido, 
      gp.cd_grupo_produto, ge.cd_grupo_estoque, ge.nm_grupo_estoque, gp.nm_grupo_produto,
      pvihc.vl_preco_lista_pedido, cf.cd_mascara_classificacao, gi.cd_tipo_grupo_inventario, 
      gpv.cd_tipo_grupo_inventario, gi.cd_lancamento_padrao, gpv.cd_lancamento_padrao

    union all

    select
      1                   as GrupoInventario,
      fp.nm_fase_produto  as Fase, -- Acabados
      fp.cd_fase_produto  as CodFase,
      0                   as CodProduto,
      gp.cd_grupo_produto                                                as CodGrupoProduto,
      ge.cd_grupo_estoque                                                as CodGrupoEstoque,
      isnull(gi.cd_tipo_grupo_inventario, gpv.cd_tipo_grupo_inventario)  as CodTipoGrupoInventario,
      isnull(gi.cd_lancamento_padrao, gpv.cd_lancamento_padrao)          as CodLancamentoPadrao,
      pvi.cd_pedido_venda as PVE,
      pvi.cd_item_pedido_venda as ItemPVE,
      0 as TipoDestinatario,
      0 as Destinatario,
      ge.nm_grupo_estoque as GrupoEstoque,
      gp.nm_grupo_produto as GrupoProduto, 
      cf.cd_mascara_classificacao as ClassificacaoFiscal,
      'PVE '+cast(pvi.cd_pedido_venda as varchar)+'/'+cast(pvi.cd_item_pedido_venda as varchar) as Codigo,
      isnull(pvi.nm_fantasia_produto,'') as Produto,
      isnull(pvi.nm_produto_pedido,'') as Discriminacao,
      'KG' as Unidade, 

      (sum(nei.qt_pesbru_nota_entrada) / 
         pvi.qt_item_pedido_venda *
        ((case when pvi.dt_cancelamento_item is null then
            pvi.qt_saldo_pedido_venda
          else
            pvi.qt_item_pedido_venda
          end) + isnull(nsf.qt_item_faturado,0) - 
                 isnull(nsd.qt_item_devolvido,0))) as PesoBruto,

      cast(sum(nei.vl_total_nota_entr_item) as decimal(25,2)) as ValorBase,

      cast(case when isnull(pvi.vl_unitario_item_pedido, 0.00) between 0.00 and 0.01 
        then cast(pvi.vl_lista_item_pedido as decimal(25,2))
        else cast(pvi.vl_unitario_item_pedido as decimal(25,2)) end *
        ((case when pvi.dt_cancelamento_item is null then
            pvi.qt_saldo_pedido_venda
          else
            pvi.qt_item_pedido_venda
          end) + isnull(nsf.qt_item_faturado,0) - 
                 isnull(nsd.qt_item_devolvido,0)) as decimal(25,2)) as Preco

    from Nota_Entrada_Item nei with(nolock) 
      inner join Nota_Entrada ne with(nolock) on nei.cd_nota_entrada = ne.cd_nota_entrada and
                                                 nei.cd_fornecedor = ne.cd_fornecedor and
                                                 nei.cd_operacao_fiscal = ne.cd_operacao_fiscal and
                                                 nei.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal      
      inner join Pedido_Compra_Item pci with(nolock) on nei.cd_pedido_compra = pci.cd_pedido_compra and
                                                        nei.cd_item_pedido_compra = pci.cd_item_pedido_compra
      inner join Pedido_Venda_Item pvi with(nolock) on pci.cd_pedido_venda = pvi.cd_pedido_venda and
                                                       pci.cd_item_pedido_venda = pvi.cd_item_pedido_venda
      inner join Pedido_Venda pv with(nolock) on pvi.cd_pedido_venda = pv.cd_pedido_venda
      inner join Cliente c with(nolock) on c.cd_cliente = pv.cd_cliente
      inner join Materia_Prima mp with(nolock) on pci.cd_materia_prima = mp.cd_mat_prima
      inner join Grupo_Produto gp with(nolock) on gp.cd_grupo_produto = pvi.cd_grupo_produto
      inner join Grupo_Produto_Custo gpc with(nolock) on gpc.cd_grupo_produto = pvi.cd_grupo_produto
      inner join Grupo_Produto_Fiscal gpf with(nolock) on gp.cd_grupo_produto = gpf.cd_grupo_produto
      inner join Fase_Produto fp with(nolock) on fp.cd_fase_produto = case when (@cd_fase_produto = 0) or (@cd_fase_produto = 3) 
                                                                      then 3 else 0 end
      left outer join Grupo_Inventario gi with(nolock) on gi.cd_grupo_inventario = 1
      left outer join Grupo_Produto_Valoracao gpv with(nolock) on gpv.cd_grupo_produto = pvi.cd_grupo_produto and
                                                                  gpv.cd_fase_produto = case when (@cd_fase_produto = 0) or (@cd_fase_produto = 3) 
                                                                                        then 3 else 0 end
      left outer join Classificacao_Fiscal cf with(nolock) on gpf.cd_classificacao_fiscal = cf.cd_classificacao_fiscal
      inner join Tipo_Pedido tp with(nolock) on pv.cd_tipo_pedido = tp.cd_tipo_pedido
      left outer join #NotaSaidaCustoFaturado nsf on nsf.cd_pedido_venda = pvi.cd_pedido_venda and
                                                     nsf.cd_item_pedido_venda = pvi.cd_item_pedido_venda
      left outer join #NotaSaidaCustoDevolvido nsd on nsd.cd_pedido_venda = pvi.cd_pedido_venda and
                                                      nsd.cd_item_pedido_venda = pvi.cd_item_pedido_venda
      left outer join Grupo_Estoque ge with(nolock) on ge.cd_grupo_estoque = gpc.cd_grupo_estoque
    where 
      -- QUE TENHAM SIDO FABRICADOS ATÉ O MÊS
      (pvi.dt_entrega_fabrica_pedido <= @dt_base) and  
      -- QUE NÃO SEJAM ROSCAS
      isnull(nei.cd_produto,0) <> 53786 and -- ROSCAS
      -- QUE TENHAM SALDO
      (((case when pvi.dt_cancelamento_item is null then
           pvi.qt_saldo_pedido_venda
         else
           pvi.qt_item_pedido_venda
         end) + isnull(nsf.qt_item_faturado,0) - 
                isnull(nsd.qt_item_devolvido,0)) > 0) and
      -- QUE NÃO ESTEJAM CANCELADOS
      ((pvi.dt_cancelamento_item is null) or (pvi.dt_cancelamento_item > @dt_base)) and
      -- GRUPOS ESPECIAIS
      isnull(gp.ic_especial_grupo_produto,'N') = 'S' and
      -- SOMENTE GRUPOS QUE CONTROLAM CUSTO
      isnull(gpc.ic_custo,'N') = 'S' and
      -- SOMENTE SE ESTIVER FECHADO
      isnull(pv.ic_fechamento_total,'N') = 'S' and
      -- SOMENTE PVE ABERTOS OU LIQUIDADOS
      pv.cd_status_pedido in (1,2) and
      -- SOMENTE TIPO ESPECIAL PEDIDOS ESPECIAIS
      isnull(tp.ic_especial_tipo_pedido,'S') = 'S' and
      -- NÃO BUSCAR ITENS 99 - PEDIDOS DE VENDA MERCADO EXTERNO
      pvi.cd_item_pedido_venda <= (case isnull(c.cd_pais,1) 
                                   when 1 then 80
                                   else  pvi.cd_item_pedido_venda
                                   end) and
      -- NAO BUSCAR SMO
      isnull(pv.ic_smo_pedido_venda, 'N') = 'N' and
      -- NÃO BUSCAR PEDIDOS DE VENDA COM VALOR SIMBÓLICO (R$ 0,01)
      pvi.vl_unitario_item_pedido <> 0.01 and
      -- QUE NÃO ESTEJAM CADASTRADOS NO HISTÓRICO ACIMA
      pvi.cd_pedido_venda not in (select distinct cd_pedido_venda 
                                  from Pedido_Venda_Item_Historico_Custo with(nolock) 
                                  where cd_fase_produto = 3)

      and isnull(fp.ic_registro_inventario,'S')='S' 

    group by
      fp.nm_fase_produto, fp.cd_fase_produto, ge.cd_grupo_estoque, ge.nm_grupo_estoque, gp.cd_grupo_produto,
      gp.nm_grupo_produto,
      cf.cd_mascara_classificacao, pvi.cd_pedido_venda, pvi.cd_item_pedido_venda, pvi.nm_fantasia_produto, 
      pvi.nm_produto_pedido, pvi.vl_unitario_item_pedido, pvi.vl_lista_item_pedido, pv.vl_total_pedido_venda, 
      pvi.dt_cancelamento_item, pvi.qt_item_pedido_venda, pvi.qt_saldo_pedido_venda, nsf.qt_item_faturado, nsd.qt_item_devolvido,
      gi.cd_tipo_grupo_inventario, gpv.cd_tipo_grupo_inventario, gi.cd_lancamento_padrao, gpv.cd_lancamento_padrao

    insert into #GrupoInventario
    select 
      pve.GrupoInventario,
      pve.Fase,
      pve.CodFase,
      pve.CodProduto, 
      pve.CodGrupoProduto, 
      pve.CodGrupoEstoque, 
      pve.CodTipoGrupoinventario,
      pve.CodLancamentoPadrao,
      pve.PVE,
      pve.ItemPVE, 
      pve.TipoDestinatario, 
      pve.Destinatario, 
      pve.GrupoEstoque,
      pve.GrupoProduto, 
      pve.ClassificacaoFiscal,
      pve.Codigo, 
      pve.Produto, 
      pve.Discriminacao,
      pve.Unidade, 
      sum(pve.PesoBruto) as PesoUnitario,
      sum(pve.PesoBruto) as PesoBruto,

      ((pve.Preco * (pve.ValorBase / 
                          (select sum(aux.ValorBase) 
                           from #PVEAcabado aux 
                           where aux.Codigo = pve.Codigo)) * 0.7) / sum(pve.PesoBruto)) as Unitario,


      cast((pve.Preco * (pve.ValorBase / (select sum(aux.ValorBase) 
                                     from #PVEAcabado aux 
                                     where aux.Codigo = pve.Codigo)) * 0.7) as decimal(25,2)) as Total,
      3    as CodMetodoValoracao,
      null as MateriaPrima,
      null as Bitola,
      'S'  as Especial,
      'E'  as OrigemInventario

    from #PVEAcabado pve
    group by
      pve.GrupoInventario, pve.Fase, pve.CodFase, pve.CodProduto, pve.CodGrupoProduto, 
      pve.CodGrupoEstoque, 
      pve.CodTipoGrupoInventario, pve.CodLancamentoPadrao, pve.PVE, pve.ItemPVE, 
      pve.TipoDestinatario, pve.Destinatario, pve.GrupoEstoque, pve.GrupoProduto, 
      pve.ClassificacaoFiscal, pve.Codigo, pve.Produto, pve.Discriminacao, 
      pve.Unidade, pve.Preco, pve.ValorBase

    drop table #NotaSaidaCustoFaturado
    drop table #NotaSaidaCustoDevolvido
    drop table #PVEAcabado
  end

  -----------------------------------------------------------------------------
  -- GRAVAÇÃO DA TABELA AUXILIAR PARA PROCESSO DE IMPORTAÇÃO MASTERSAF
  -----------------------------------------------------------------------------
  if (@ic_gerar_mastersaf = 'S')
  begin

    if not exists(select name from sysobjects 
                  where name = N'Inventario_Mastersaf' and type = 'U')
    begin

      create table Inventario_MasterSaf (
        dt_apuracao_inventario datetime null,
        cd_grupo_inventario int null,
        cd_fase_produto int null,
        cd_grupo_estoque int null,
        cd_tipo_grupo_inventario int null,
        cd_lancamento_padrao int null,
        cd_produto int null,
        cd_pedido_venda int null,
        cd_item_pedido_venda int null,
        cd_tipo_destinatario int null,
        cd_destinatario int null,
        cd_mascara_produto varchar(30) null,
        nm_fantasia_produto varchar(35) null,       
        nm_produto varchar(60) null,
        nm_classificacao_fiscal varchar(10) null,
        sg_unidade_medida varchar(10) null,
        qt_peso_unitario float null,
        qt_saldo_inventario float null,
        vl_unitario_inventario float null,
        vl_total_inventario float null) 

    end

    delete from Inventario_MasterSaf
    where dt_apuracao_inventario = @dt_base

    insert into Inventario_MasterSaf
    select @dt_base as dt_apuracao_inventario,
      GrupoInventario,
      CodFase,  
      CodGrupoEstoque,
      CodTipoGrupoinventario,
      CodLancamentoPadrao,
      CodProduto,
      PVE,
      ItemPVE,
      TipoDestinatario, 
      Destinatario,
      case when substring(Codigo,1,3) in ('PVE','NFS') then
        replace(Codigo,' ','')
      else
        dbo.fn_limpa_mascara(Codigo)
      end,
      Produto,
      Discriminacao,
      ClassificacaoFiscal,
      Unidade,
      PesoUnitario,
      Quantidade, 
      Unitario,
      Total
    from #GrupoInventario
    
  end

  --Gera a Tabela de Registro de Inventário

   select
     1                           as cd_registro_inventario,
     @dt_base                    as dt_registro_inventario,     
     CodProduto                  as cd_produto,
     Quantidade                  as qt_registro_inventario,          
     round(Unitario,4)           as vl_registro_inventario,            
     round(Total,4)              as vl_total_registro_inventario, 
     @cd_usuario                 as cd_usuario         ,
     getdate()                   as dt_usuario,
     'RI'                        as nm_obs_registro_inventario,
     'S'                         as ic_registro_inventario,
      CodFase                    as cd_fase_produto,
--      CodTipoGrupoInventario     as cd_grupo_inventario,
      g.cd_grupo_inventario,
      CodGrupoProduto            as cd_grupo_produto,
-     CodGrupoEstoque            as cd_grupo_estoque, 
      pf.cd_classificacao_fiscal as cd_classificacao_fiscal,
      p.cd_unidade_medida        as cd_unidade_medida,
      CodMetodoValoracao         as cd_metodo_valoracao,
      OrigemInventario           as ic_origem_registro_inventario,
      pc.cd_mat_prima            as cd_mat_prima,
      pc.cd_bitola               as cd_bitola,
      Especial                   as ic_especial,
      identity(int,1,1)          as cd_controle,
      'A'                        as ic_tipo_lancamento,
      CodLancamentoPadrao        as cd_lancamento_padrao  

  into
     #Registro_Inventario   

  from
    #GrupoInventario gi                       with (nolock) 
    inner join Grupo_Inventario g             with (nolock) on g.cd_grupo_inventario      = gi.GrupoInventario
    left outer join Metodo_Valoracao mv       with (nolock) on gi.CodMetodoValoracao      = mv.cd_metodo_valoracao
    left outer join Tipo_Grupo_Inventario tgi with (nolock) on gi.CodTipoGrupoInventario  = tgi.cd_tipo_grupo_inventario
    left outer join Lancamento_Padrao lp      with (nolock) on gi.CodLancamentoPadrao     = lp.cd_lancamento_padrao
    left outer join Produto p                 with (nolock) on p.cd_produto               = gi.CodProduto
    left outer join Produto_Fiscal pf         with (nolock) on pf.cd_produto              = p.cd_produto
    left outer join Produto_Custo  pc         with (nolock) on pc.cd_produto              = p.cd_produto
    left outer join classificacao_fiscal cf   with (nolock) on cf.cd_classificacao_fiscal = pf.cd_classificacao_fiscal

  where  
     gi.Quantidade >= 0 and gi.Total > 0
     
  order by 
     gi.GrupoInventario, 
     tgi.nm_tipo_grupo_inventario, 
     lp.nm_lancamento_padrao, 
     gi.GrupoProduto,
     gi.ClassificacaoFiscal, 
     gi.Codigo

  --select * from registro_inventario

--  select * from #Registro_Inventario

  --deleta todos os registros gerados automaticamente na Data BAse
 
  delete from registro_inventario  where ic_tipo_lancamento = 'A' and dt_registro_inventario = @dt_base
  delete from #registro_inventario where cd_produto in ( select cd_produto from registro_inventario where dt_registro_inventario = @dt_base ) 
      
  --Montagem da Tabela de Registro

  declare @cd_registro_inventario int

  select 
    @cd_registro_inventario = isnull( max( isnull(cd_registro_inventario,0) ),0 ) + 1 
  from
    Registro_Inventario

  if @cd_registro_inventario is null
  begin
     set @cd_registro_inventario = 1
  end
 
  update
    #Registro_Inventario
  set
    cd_registro_inventario = @cd_registro_inventario + cd_controle


--  select * from #Registro_Inventario
--  select * from Registro_Inventario

  --Montagem da Tabela de Registro de Inventário

  insert into Registro_Inventario
  select
     *
  from
     #Registro_Inventario
  
  --Apresentação do Registro de Inventário
 

--  select * from #Registro_Inventario
--  select * from #GrupoInventario

  select 

    --gi.*, 

    case when isnull(GrupoInventario,'')<>'' then
      GrupoInventario
    else
      g.cd_grupo_inventario 
    end                                          as GrupoInventario,

    case when isnull(Fase,'')<>'' then
      Fase
    else
      fp.nm_fase_produto
    end                                          as Fase,

    CodFase,
    CodProduto,
    CodGrupoProduto,
    CodGrupoEstoque,
    CodTipoGrupoInventario,
    CodLancamentoPadrao,
    PVE                ,
    ItemPVE            ,
    TipoDestinatario   ,
    Destinatario       ,

    case when isnull(GrupoEstoque,'')<>'' then
      GrupoEstoque  
    else
      ge.nm_grupo_estoque
    end                                          GrupoEstoque,

    case when isnull(GrupoProduto,'') <>'' then
       GrupoProduto       
    else
       gp.nm_grupo_produto
    end                                          as GrupoProduto,

    case when isnull(ClassificacaoFiscal,'')<>'' then
       ClassificacaoFiscal
    else
       cf.cd_mascara_classificacao
    end                                          as ClassificacaoFiscal,

    case when isnull(Codigo,'')<>'' then
       Codigo             
    else
       p.cd_mascara_produto
    end                                          as Codigo,

    case when isnull(Produto,'')<>'' then
        Produto
    else
      p.nm_fantasia_produto
    end                                          as Produto,
    
    case when isnull(Discriminacao,'')<>'' then
       Discriminacao      
    else
       p.nm_produto
    end                                          as Discriminacao,
   
    case when isnull(Unidade,'')<>''       then
       Unidade            
    else
       um.sg_unidade_medida
    end                                          as Unidade,

    case when isnull(PesoUnitario,0)<>0 then
       --Alteração do Peso do Produto no Inventário
       PesoUnitario       
    else
       p.qt_peso_bruto
    end                                          as PesoUnitario,

    --Alteração da Quantidade

    case when (isnull(ri.qt_registro_inventario,0)>0 and isnull(ri.qt_registro_inventario,0)<>Quantidade ) or isnull(Quantidade,0)=0
    then
      ri.qt_registro_inventario
    else 
      Quantidade       
    end                   as Quantidade ,

    --Alteração do Valor Unitário
    case when (isnull(ri.vl_registro_inventario,0)>0 and isnull(ri.vl_registro_inventario,0)<>Unitario ) or isnull(Unitario,0)=0
    then
      ri.vl_registro_inventario
    else
      Unitario
    end                   as Unitario,

    --Alteração do Valor Total
    case when (isnull(ri.vl_registro_inventario,0)>0 and isnull(ri.vl_registro_inventario,0)<>Unitario and
              isnull(ri.qt_registro_inventario,0)>0 and isnull(ri.qt_registro_inventario,0)<>Quantidade ) or
              ( isnull(Quantidade,0)=0 and isnull(Unitario,0)=0 )
    then
      round(ri.qt_registro_inventario * ri.vl_registro_inventario,2)
    else
       Total             
    end                  as Total,

    CodMetodoValoracao ,
    MateriaPrima       ,
    Bitola             ,
    isnull(Especial,'N')         as Especial           ,

    case when isnull(OrigemInventario,'')<>'' then
      OrigemInventario
    else
      ic_origem_registro_inventario
    end                          as OrigemInventario,    

    g.nm_grupo_inventario        as NomeGrupoInventario, 
    mv.nm_metodo_valoracao       as MetodoValoracao,
    tgi.nm_tipo_grupo_inventario as TipoGrupoinventario,
    lp.nm_lancamento_padrao      as LancamentoPadrao

  from
    Registro_Inventario ri                    with (nolock) 
    left outer join #GrupoInventario  gi      with (nolock) on gi.CodProduto    = ri.cd_produto      and
                                                               gi.CodFase       = ri.cd_fase_produto and
                                                               gi.Quantidade    >= 0                 and
                                                               gi.Total         > 0  

    left outer join Grupo_Inventario g        with (nolock) on g.cd_grupo_inventario      = ri.cd_grupo_inventario
    left outer join Metodo_Valoracao mv       with (nolock) on ri.cd_metodo_valoracao     = mv.cd_metodo_valoracao
    left outer join Tipo_Grupo_Inventario tgi with (nolock) on ri.cd_grupo_inventario     = tgi.cd_tipo_grupo_inventario
    left outer join Lancamento_Padrao lp      with (nolock) on ri.cd_lancamento_padrao    = lp.cd_lancamento_padrao
    left outer join Produto p                 with (nolock) on p.cd_produto               = ri.cd_produto
    left outer join Produto_Fiscal pf         with (nolock) on pf.cd_produto              = p.cd_produto
    left outer join Produto_Custo  pc         with (nolock) on pc.cd_produto              = p.cd_produto
    left outer join classificacao_fiscal cf   with (nolock) on cf.cd_classificacao_fiscal = pf.cd_classificacao_fiscal
    left outer join Unidade_Medida um         with (nolock) on um.cd_unidade_medida       = p.cd_unidade_medida
    left outer join Grupo_Produto  gp         with (nolock) on gp.cd_grupo_produto        = p.cd_grupo_produto  
    left outer join Fase_Produto   fp         with (nolock) on fp.cd_fase_produto         = ri.cd_fase_produto
    left outer join Grupo_Estoque  ge         with (nolock) on ge.cd_grupo_estoque        = ri.cd_grupo_estoque

  where  
     ri.dt_registro_inventario = @dt_base and     
     isnull(ri.ic_registro_inventario,'S') = 'S' 
     and isnull(fp.ic_registro_inventario,'S') = 'S'

  order by 
     gi.GrupoInventario, 
     tgi.nm_tipo_grupo_inventario, 
     lp.nm_lancamento_padrao, 
     gi.GrupoProduto,
     gi.ClassificacaoFiscal, 
     gi.Codigo

  --select * from #GrupoInventario

  SET LOCK_TIMEOUT -1
    
end


