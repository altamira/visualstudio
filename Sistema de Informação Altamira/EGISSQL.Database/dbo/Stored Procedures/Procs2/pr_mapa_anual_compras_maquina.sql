
CREATE PROCEDURE pr_mapa_anual_compras_maquina
@ic_parametro        int, -- 0 para emissão, 1 para entrega.
@ano_base            int,
@dt_inicial          datetime,
@dt_final            datetime

AS

  declare @vl_total decimal(25,2)


  -----------------------------------------------------------------------------
  -- RECEBIDOS
  -----------------------------------------------------------------------------
  --select cd_maquina, * from pedido_compra_item 
  --select * from maquina

    select 
       m.nm_fantasia_maquina              as 'Maquina',

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
      Maquina m
    on
      m.cd_maquina = pci.cd_maquina
    where 
      year(nei.dt_item_receb_nota_entrad) = @ano_base 

    group by 
      m.nm_fantasia_maquina,
      nei.dt_item_receb_nota_entrad
    order by
      m.nm_fantasia_maquina

  select 
    @vl_total = sum(Total_Grupo)
  from
    #MapaAnualRecebido

  select 
    Maquina,
    sum(Janeiro)     as Janeiro,
    sum(Fevereiro)   as Fevereiro,
    sum(Marco)       as Marco,
    sum(Abril)       as Abril,
    sum(Maio)        as Maio,
    sum(Junho)       as Junho,
    sum(Julho)       as Julho,
    sum(Agosto)      as Agosto,
    sum(Setembro)    as Setembro,
    sum(Outubro)     as Outubro,
    sum(Novembro)    as Novembro,
    sum(Dezembro)    as Dezembro,
    sum(Total_Grupo) as Total_Grupo,
    cast((isnull(sum(Total_Grupo), 1) / @vl_total ) * 100 as numeric(25,2)) as Porcent
  from
    #MapaAnualRecebido
  group by
    Maquina
  order by
    Maquina

