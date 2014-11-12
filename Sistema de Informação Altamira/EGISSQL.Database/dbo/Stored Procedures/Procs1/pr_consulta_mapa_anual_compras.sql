
CREATE PROCEDURE pr_consulta_mapa_anual_compras
@ic_parametro        int, -- 0 para emissão, 1 para entrega.
@ano_base            int,
@dt_inicial          datetime,
@dt_final            datetime

AS

  declare @vl_total decimal(25,2)


  -----------------------------------------------------------------------------
  -- RECEBIDOS
  -----------------------------------------------------------------------------

    select 
       gc.nm_grupo_Compra                 as 'GrupoCompra',
       pc.cd_mascara_plano_compra         as 'PlanoCompra',
       pc.nm_plano_compra                 as 'Descricao',

       case when month(nei.dt_item_receb_nota_entrad) = 1 then
         sum(isnull(nei.vl_total_nota_entr_item,0)+
             isnull(nei.vl_ipi_nota_entrada,0)) end as 'Janeiro',

       case when month(nei.dt_item_receb_nota_entrad) = 2 then
         sum(isnull(nei.vl_total_nota_entr_item,0)+
             isnull(nei.vl_ipi_nota_entrada,0)) end as 'Fevereiro',

       case when month(nei.dt_item_receb_nota_entrad) = 3 then
         sum(isnull(nei.vl_total_nota_entr_item,0)+
             isnull(nei.vl_ipi_nota_entrada,0)) end as 'Marco',

       case when month(nei.dt_item_receb_nota_entrad) = 4 then
         sum(isnull(nei.vl_total_nota_entr_item,0)+
             isnull(nei.vl_ipi_nota_entrada,0)) end as 'Abril',

       case when month(nei.dt_item_receb_nota_entrad) = 5 then
         sum(isnull(nei.vl_total_nota_entr_item,0)+
             isnull(nei.vl_ipi_nota_entrada,0)) end as 'Maio',

       case when month(nei.dt_item_receb_nota_entrad) = 6 then
         sum(isnull(nei.vl_total_nota_entr_item,0)+
             isnull(nei.vl_ipi_nota_entrada,0)) end as 'Junho',

       case when month(nei.dt_item_receb_nota_entrad) = 7 then
         sum(isnull(nei.vl_total_nota_entr_item,0)+
             isnull(nei.vl_ipi_nota_entrada,0)) end as 'Julho',

       case when month(nei.dt_item_receb_nota_entrad) = 8 then
         sum(isnull(nei.vl_total_nota_entr_item,0)+
             isnull(nei.vl_ipi_nota_entrada,0)) end as 'Agosto',

       case when month(nei.dt_item_receb_nota_entrad) = 9 then
         sum(isnull(nei.vl_total_nota_entr_item,0)+
             isnull(nei.vl_ipi_nota_entrada,0)) end as 'Setembro',

       case when month(nei.dt_item_receb_nota_entrad) = 10 then
         sum(isnull(nei.vl_total_nota_entr_item,0)+
             isnull(nei.vl_ipi_nota_entrada,0)) end as 'Outubro',

       case when month(nei.dt_item_receb_nota_entrad) = 11 then
         sum(isnull(nei.vl_total_nota_entr_item,0)+
             isnull(nei.vl_ipi_nota_entrada,0)) end as 'Novembro',

       case when month(nei.dt_item_receb_nota_entrad) = 12 then
         sum(isnull(nei.vl_total_nota_entr_item,0)+
             isnull(nei.vl_ipi_nota_entrada,0)) end as 'Dezembro',

       sum(isnull(nei.vl_total_nota_entr_item,0)+
           isnull(nei.vl_ipi_nota_entrada,0))       as 'Total_Grupo'

    into 
      #MapaAnualRecebido
    from 
      Nota_Entrada_Item nei
    inner join
      Pedido_Compra_Item pci
    on
      pci.cd_pedido_compra = nei.cd_pedido_compra and
      pci.cd_item_pedido_compra = nei.cd_item_pedido_compra
    inner join
      Plano_Compra pc
    on
      pc.cd_plano_compra = pci.cd_plano_compra 
    inner join
      Grupo_Compra gc 
    on 
      gc.cd_grupo_compra = pc.cd_grupo_compra 
    where 
      year(nei.dt_item_receb_nota_entrad) = @ano_base and
      (isnull(pc.ic_mapa_plano_compra,'S') = 'S')
    group by 
      gc.nm_grupo_Compra,
      pc.cd_mascara_plano_compra,
      pc.nm_plano_compra,
      nei.dt_item_receb_nota_entrad
    order by
      GrupoCompra

  select 
    @vl_total = sum(Total_Grupo)
  from
    #MapaAnualRecebido

  select 
    GrupoCompra,
    PlanoCompra,
    Descricao,
    sum(Janeiro) as Janeiro,
    sum(Fevereiro) as Fevereiro,
    sum(Marco) as Marco,
    sum(Abril) as Abril,
    sum(Maio) as Maio,
    sum(Junho) as Junho,
    sum(Julho) as Julho,
    sum(Agosto) as Agosto,
    sum(Setembro) as Setembro,
    sum(Outubro) as Outubro,
    sum(Novembro) as Novembro,
    sum(Dezembro) as Dezembro,
    sum(Total_Grupo) as Total_Grupo,
    cast((isnull(sum(Total_Grupo), 1) / @vl_total ) * 100 as numeric(25,2)) as Porcent
  from
    #MapaAnualRecebido
  group by
    GrupoCompra,
    PlanoCompra,
    Descricao
  order by
    PlanoCompra

  -----------------------------------------------------------------------------
  -- COMPRADOS
  -----------------------------------------------------------------------------

--     select 
--        gc.nm_grupo_Compra                 as 'GrupoCompra',
--        pc.cd_mascara_plano_compra         as 'PlanoCompra',
--        pc.nm_plano_compra                 as 'Descricao',
--        ( select sum(IsNull(a.vl_total_pedido_ipi,0)) from Pedido_Compra a
--          where (month(a.dt_pedido_compra)=1) and 
--                 a.dt_cancel_ped_compra is null and
--                 a.cd_plano_compra = pci.cd_plano_compra and
--                 year(a.dt_pedido_compra) = @ano_base) as 'Janeiro',
--        ( select sum(IsNull(a.vl_total_pedido_ipi,0)) from Pedido_Compra a
--          where (month(a.dt_pedido_compra)=2) and 
--                 a.dt_cancel_ped_compra is null and
--                 a.cd_plano_compra = pci.cd_plano_compra and
--                 year(a.dt_pedido_compra) = @ano_base)  as 'Fevereiro',
--        ( select sum(IsNull(a.vl_total_pedido_ipi,0)) from Pedido_Compra a
--          where (month(a.dt_pedido_compra)=3) and 
--                 a.dt_cancel_ped_compra is null and
--                 a.cd_plano_compra = pci.cd_plano_compra and
--                 year(a.dt_pedido_compra) = @ano_base)  as 'Marco',
--        ( select sum(IsNull(a.vl_total_pedido_ipi,0)) from Pedido_Compra a
--          where (month(a.dt_pedido_compra)=4) and 
--                 a.dt_cancel_ped_compra is null and
--                 a.cd_plano_compra = pci.cd_plano_compra and
--                 year(a.dt_pedido_compra) = @ano_base) as 'Abril',
--        ( select sum(IsNull(a.vl_total_pedido_ipi,0)) from Pedido_Compra a
--          where (month(a.dt_pedido_compra)=5) and 
--                 a.dt_cancel_ped_compra is null and
--                 a.cd_plano_compra = pci.cd_plano_compra and
--                 year(a.dt_pedido_compra) = @ano_base) as 'Maio',
--        ( select sum(IsNull(a.vl_total_pedido_ipi,0)) from Pedido_Compra a
--          where (month(a.dt_pedido_compra)=6) and 
--                 a.dt_cancel_ped_compra is null and
--                 a.cd_plano_compra = pci.cd_plano_compra and
--                 year(a.dt_pedido_compra) = @ano_base)  as 'Junho',
--        ( select sum(IsNull(a.vl_total_pedido_ipi,0)) from Pedido_Compra a
--          where (month(a.dt_pedido_compra)=7) and 
--                 a.dt_cancel_ped_compra is null and
--                 a.cd_plano_compra = pci.cd_plano_compra and
--                 year(a.dt_pedido_compra) = @ano_base) as 'Julho',
--        ( select sum(IsNull(a.vl_total_pedido_ipi,0)) from Pedido_Compra a
--          where (month(a.dt_pedido_compra)=8) and 
--                 a.dt_cancel_ped_compra is null and
--                 a.cd_plano_compra = pci.cd_plano_compra and
--                 year(a.dt_pedido_compra) = @ano_base) as 'Agosto',
--        ( select sum(IsNull(a.vl_total_pedido_ipi,0)) from Pedido_Compra a
--          where (month(a.dt_pedido_compra)=9) and 
--                 a.dt_cancel_ped_compra is null and
--                 a.cd_plano_compra = pci.cd_plano_compra and
--                 year(a.dt_pedido_compra) = @ano_base) as 'Setembro',
--        ( select sum(IsNull(a.vl_total_pedido_ipi,0)) from Pedido_Compra a
--          where (month(a.dt_pedido_compra)=10) and 
--                 a.dt_cancel_ped_compra is null and
--                 a.cd_plano_compra = pci.cd_plano_compra and
--                 year(a.dt_pedido_compra) = @ano_base) as 'Outubro',
--        ( select sum(IsNull(a.vl_total_pedido_ipi,0)) from Pedido_Compra a
--          where (month(a.dt_pedido_compra)=11) and 
--                 a.dt_cancel_ped_compra is null and
--                 a.cd_plano_compra = pci.cd_plano_compra and
--                 year(a.dt_pedido_compra) = @ano_base) as 'Novembro',
--        ( select sum(IsNull(a.vl_total_pedido_ipi,0)) from Pedido_Compra a
--          where (month(a.dt_pedido_compra)=12) and 
--                 a.dt_cancel_ped_compra is null and
--                 a.cd_plano_compra = pci.cd_plano_compra and
--                 year(a.dt_pedido_compra) = @ano_base) as 'Dezembro', 
--        isnull(sum(pci.vl_total_pedido_ipi),0.00) as 'Total_Grupo'
-- 
--     into #Tabela1
--     from 
-- 
--       Pedido_Compra pci left outer join
--       Plano_Compra pc on pc.cd_plano_compra = pci.cd_plano_compra left outer join 
--       Grupo_Compra gc on gc.cd_grupo_compra = pc.cd_grupo_compra left outer join 
--       Pedido_Compra_item pcit on pcit.cd_pedido_compra = pci.cd_pedido_compra
--     where 
--       ((year(pcit.dt_item_pedido_compra)=@ano_base and @ic_parametro = 0) or
--       (year(pcit.dt_entrega_item_ped_compr)=@ano_base and @ic_parametro = 1) )and
--       pci.dt_cancel_ped_compra is null
-- 
--     group by 
--        pci.cd_plano_compra,
--        gc.nm_grupo_compra,
--        pc.cd_mascara_plano_compra,
--        pc.nm_plano_compra
--     order by
--        gc.nm_grupo_compra
-- 
--   Declare @vl_total decimal(25,2)
-- 
--   select 
--   @vl_total = sum(Total_Grupo)
--   from
--     #Tabela1
-- 
--   select 
--     *,
--     Cast((Isnull(Total_Grupo, 1) / @vl_total )*100 as numeric(25,2)) as Porcent
--   into #Tabela2
--   from
--     #Tabela1
-- 
--   select * from #Tabela2 order by PlanoCompra
-- 
--   drop table #Tabela1 
--   drop table #Tabela2 
--   
