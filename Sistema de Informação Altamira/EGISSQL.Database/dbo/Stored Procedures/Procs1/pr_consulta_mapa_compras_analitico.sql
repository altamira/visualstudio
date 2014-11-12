
CREATE PROCEDURE pr_consulta_mapa_compras_analitico
@cd_grupo_compra        int = 0,
@cd_plano_compra        int = 0,
@dt_inicial             datetime,
@dt_final               datetime,
@ic_parametro           int,           -- 0 Comprado=Emissão do Pedido
                                       -- 1 Recebido=Data de Recebimento da Nota Fiscal
                                       -- 2 Previsto=Data de Entrega
@ic_tipo_consulta       char(1) = 'N', -- 'N' Analítico, 'S' Sintético, 'A' Anual
@ic_liberacao_comprador char(1) = 'S'  -- Checa a Liberação do Comprador


AS

  -- select * from pedido_compra_item

  -- Limpa a Hora das Datas Recebidas
  set @dt_inicial = cast(cast(@dt_inicial as int) as datetime)
  set @dt_final   = cast(cast(@dt_final as int) as datetime)

  declare @ic_mapa_item_ped_compra char(1)
  declare @vl_total                decimal(25,2)
  declare @vl_total_recebido       decimal(25,2)

  if @ic_liberacao_comprador is null 
    set @ic_liberacao_comprador = 'S'

  -- Indica se Será Analítico por Item de Pedido
  set @ic_mapa_item_ped_compra = ( select IsNull(ic_mapa_item_ped_compra,'N') from Parametro_Suprimento with (nolock)
                                   where cd_empresa = dbo.fn_empresa() ) 

  -- Só irá considerar os itens se for uma consulta analítica.
  if @ic_tipo_consulta <> 'N' 
    set @ic_mapa_item_ped_compra = 'N'

  -- PEDIDOS COM DATA DE ENTREGA OU EMISSÃO NO PERÍODO
  -- SOMENTE OS QUE AINDA NÃO FORAM RECEBIDOS
  select 
    distinct
    gc.nm_grupo_Compra                          as 'GrupoCompra',
    pl.cd_plano_compra                          as 'CodPlano',
    pl.cd_mascara_plano_compra                  as 'PlanoCompra',
    pl.nm_plano_compra                          as 'Descricao',
    fo.nm_fantasia_fornecedor                   as 'Fornecedor',
    pc.cd_pedido_compra		                as 'Pedido',
    pci.cd_item_pedido_compra                   as 'Item', 
    pci.qt_item_pedido_compra                   as 'Qtd',
    pci.qt_item_pesbr_ped_compra                as 'Peso',
    case when @ic_mapa_item_ped_compra = 'S' then
      pci.dt_item_pedido_compra
    else 
      pc.dt_pedido_compra end                   as 'Emissao',
    pci.dt_item_nec_ped_compra                  as 'Necessidade',
    pci.dt_entrega_item_ped_compr               as 'Entrega',
    cast(isnull(pci.vl_total_item_pedido_comp,0) - 
         isnull(nei.vl_total_nota_entr_item,0) as decimal(25,2))              
                                                as 'ValorComprado',
    pci.pc_icms                                 as 'ICMS',
    pci.pc_ipi                                  as 'IPI',
    cast(null as datetime)                      as 'Recebimento',
    cast(null as int)                           as 'cd_nota_entrada',
    cast(null as int)                           as 'cd_item_nota_entrada',
    cast(null as float)                         as 'qt_item_nota_entrada',
    cast(0 as decimal(25,2))                    as 'ValorRecebido',
    cast(0    as int)                           as 'DiaEntrega',
    cc.nm_centro_custo,

    case when isnull(pci.cd_servico,0)>0 
    then
       s.cd_mascara_servico
    else
       case when isnull(pci.cd_produto,0)>0 then
          p.cd_mascara_produto
       else
          'Especial'
       end
    end                                         as cd_mascara_produto,

    case when isnull(pci.cd_servico,0)>0 
    then
       s.sg_servico
    else
       case when isnull(pci.cd_produto,0)>0 then
          p.nm_fantasia_produto
       else
          'Especial'
       end
    end                                         as nm_fantasia_produto,

    case when isnull(pci.cd_servico,0)>0 
    then
       s.nm_servico
    else
       case when isnull(pci.cd_produto,0)>0 then
          p.nm_produto
       else
          pci.nm_produto
       end
    end                                         as nm_produto,
    um.sg_unidade_medida,  

    --Impostos

    --ICMS
    isnull(pci.vl_icms_item_pedido_compra,0)        as vl_icms_item_pedido_compra,

    --IPI
    isnull(pci.vl_ipi_item_pedido_compra,0)         as vl_ipi_item_pedido_compra

    --PIS

    --COFIS

--select * from pedido_compra_item
--select * from servico

  into 
    #Mapa_Compra

  from 
    Pedido_Compra pc with (nolock)
    left outer join Pedido_Compra_item pci with (nolock) on pci.cd_pedido_compra = pc.cd_pedido_compra
    left outer join Plano_Compra pl        with (nolock) on pl.cd_plano_compra   = pci.cd_plano_compra 
    left outer join Fornecedor fo          with (nolock) on fo.cd_fornecedor     = pc.cd_fornecedor 
    left outer join Grupo_Compra gc        with (nolock) on gc.cd_grupo_compra   = pl.cd_grupo_compra
    left outer join (select cd_pedido_compra, cd_item_pedido_compra, sum(vl_total_nota_entr_item) as vl_total_nota_entr_item, 
                            max(isnull(dt_item_receb_nota_entrad,0)) as dt_item_receb_nota_entrad
                     from Nota_Entrada_Item with (nolock)
                     where dt_item_receb_nota_entrad < @dt_inicial
                     group by cd_pedido_compra, cd_item_pedido_compra) nei on nei.cd_pedido_compra = pci.cd_pedido_compra and
                                                                              nei.cd_item_pedido_compra = pci.cd_item_pedido_compra
    left outer join Centro_Custo 		cc 	on cc.cd_centro_custo   = IsNull(pci.cd_centro_custo,pc.cd_centro_custo)   
    left outer join Produto p             with (nolock) on p.cd_produto         = pci.cd_produto
    left outer join Servico s             with (nolock) on s.cd_servico         = pci.cd_servico
    left outer join Unidade_Medida um     with (nolock) on um.cd_unidade_medida = pci.cd_unidade_medida
  where 
    --Verificar se o Comprador Liberou o Pedido de Compra
    ((exists (select 'x' 
              from pedido_compra_aprovacao pca with (nolock)
              where pca.cd_pedido_compra = pc.cd_pedido_compra and
                    pca.cd_tipo_aprovacao = 1) and 
                    @ic_liberacao_comprador='S' ) or 
                    @ic_liberacao_comprador='N' ) and

     --Data Emissão do Item do Pedido
     ((case when @ic_mapa_item_ped_compra = 'S' then
         pci.dt_item_pedido_compra
       else 
         pc.dt_pedido_compra end between @dt_inicial and @dt_final and @ic_parametro = 0)  or
       (nei.dt_item_receb_nota_entrad between @dt_inicial and @dt_final and @ic_parametro = 1 ) or  
       (pci.dt_entrega_item_ped_compr between @dt_inicial and @dt_final and @ic_parametro = 2 ) ) and

    --Plano de Compra
    (pl.cd_plano_compra = case when @cd_plano_compra = 0 then pl.cd_plano_compra else @cd_plano_compra end ) and      
    (isnull(pl.ic_mapa_plano_compra,'S') = 'S') and  
    (pci.dt_item_canc_ped_compra is null) 

  -- PEDIDOS COM DATA DE RECEBIMENTO NO PERÍODO
  select 
    distinct
    gc.nm_grupo_Compra                          as 'GrupoCompra',
    pl.cd_plano_compra                          as 'CodPlano',
    pl.cd_mascara_plano_compra                  as 'PlanoCompra',
    pl.nm_plano_compra                          as 'Descricao',
    fo.nm_fantasia_fornecedor                   as 'Fornecedor',
    pc.cd_pedido_compra		                as 'Pedido',
    pci.cd_item_pedido_compra                   as 'Item', 
    pci.qt_item_pedido_compra                   as 'Qtd',
    pci.qt_item_pesbr_ped_compra                as 'Peso',

    case when @ic_mapa_item_ped_compra = 'S' then
      pci.dt_item_pedido_compra
    else 
      pc.dt_pedido_compra    end                as 'Emissao',
    pci.dt_item_nec_ped_compra                  as 'Necessidade',
    pci.dt_entrega_item_ped_compr               as 'Entrega',
    pci.pc_icms                                 as 'ICMS',
    pci.pc_ipi                                  as 'IPI',
    DadosReceb.Recebimento,
    DadosReceb.cd_nota_entrada,
    DadosReceb.cd_item_nota_entrada,
    DadosReceb.qt_item_nota_entrada,
    ValorReceb.ValorRecebido,
    cast(DadosReceb.Recebimento-pci.dt_entrega_item_ped_compr as int) as 'DiaEntrega',
    cc.nm_centro_custo,
    case when isnull(pci.cd_servico,0)>0 
    then
       s.cd_mascara_servico
    else
       case when isnull(pci.cd_produto,0)>0 then
          p.cd_mascara_produto
       else
          'Especial'
       end
    end                                         as cd_mascara_produto,

    case when isnull(pci.cd_servico,0)>0 
    then
       s.sg_servico
    else
       case when isnull(pci.cd_produto,0)>0 then
          p.nm_fantasia_produto
       else
          'Especial'
       end
    end                                         as nm_fantasia_produto,

    case when isnull(pci.cd_servico,0)>0 
    then
       s.nm_servico
    else
       case when isnull(pci.cd_produto,0)>0 then
          p.nm_produto
       else
          pci.nm_produto
       end
    end                                         as nm_produto,
    um.sg_unidade_medida,
    --Importos  
    --ICMS
    isnull(pci.vl_icms_item_pedido_compra,0)        as vl_icms_item_pedido_compra,

    --IPI
    isnull(pci.vl_ipi_item_pedido_compra,0)         as vl_ipi_item_pedido_compra

  into
    #Mapa_Recebido

  from 
    Pedido_Compra pc                  with (nolock)
    inner join Pedido_Compra_item pci with (nolock)     on pc.cd_pedido_compra       = pci.cd_pedido_compra 
    left outer join Plano_Compra pl   with (nolock)     on pl.cd_plano_compra        = pci.cd_plano_compra 
    left outer join Fornecedor fo     with (nolock)     on fo.cd_fornecedor          = pc.cd_fornecedor 
    left outer join
    -- Dados do Recebimento
    (select nei.cd_pedido_compra,
            nei.cd_item_pedido_compra,
            max(nei.dt_item_receb_nota_entrad) as Recebimento,
            max(nei.cd_nota_entrada)           as cd_nota_entrada,
            max(nei.cd_item_nota_entrada)      as cd_item_nota_entrada,
            max(nei.qt_item_nota_entrada)      as qt_item_nota_entrada
     from Nota_Entrada_item nei with (nolock)
     where nei.dt_item_receb_nota_entrad between @dt_inicial and @dt_final
     group by nei.cd_pedido_compra,
              nei.cd_item_pedido_compra) DadosReceb on DadosReceb.cd_pedido_compra      = pci.cd_pedido_compra and 
                                                       DadosReceb.cd_item_pedido_compra = pci.cd_item_pedido_compra
     left outer join
    -- Valor do Recebimento
    (select nei.cd_pedido_compra,
            nei.cd_item_pedido_compra,
            cast(sum(isnull(nei.vl_total_nota_entr_item,0) + isnull(nei.vl_ipi_nota_entrada,0)) as decimal(25,2)) as ValorRecebido
     from Nota_Entrada_item nei with (nolock)
     where nei.dt_item_receb_nota_entrad between @dt_inicial and @dt_final
     group by nei.cd_pedido_compra,
              nei.cd_item_pedido_compra) ValorReceb on ValorReceb.cd_pedido_compra      = pci.cd_pedido_compra and 
                                                       ValorReceb.cd_item_pedido_compra = pci.cd_item_pedido_compra     
    left outer join Grupo_Compra gc with (nolock) on gc.cd_grupo_compra = pl.cd_grupo_compra
    left outer join Centro_Custo 		cc 	on cc.cd_centro_custo = IsNull(pci.cd_centro_custo,pc.cd_centro_custo)   
    left outer join Produto p             with (nolock) on p.cd_produto         = pci.cd_produto
    left outer join Servico s             with (nolock) on s.cd_servico         = pci.cd_servico
    left outer join Unidade_Medida um     with (nolock) on um.cd_unidade_medida = pci.cd_unidade_medida

  where
   pl.cd_plano_compra = case when @cd_plano_compra = 0 then pl.cd_plano_compra else @cd_plano_compra end and     
   isnull(pl.ic_mapa_plano_compra,'S') = 'S' and
   --Data de Emissão / Data do Recebimento
   ((case when @ic_mapa_item_ped_compra = 'S' then
       pci.dt_item_pedido_compra
     else 
       pc.dt_pedido_compra end between @dt_inicial and @dt_final and @ic_parametro = 0 ) or
    (DadosReceb.Recebimento between @dt_inicial and @dt_final and @ic_parametro = 1 ) or  
    (pci.dt_entrega_item_ped_compr between @dt_inicial and @dt_final and @ic_parametro = 2 )) 

  -- Atualizando a Tabela de Mapa de Compra com os Recebidos

  update #Mapa_Compra
  set 
      Recebimento          = mr.Recebimento,
      cd_nota_entrada      = mr.cd_nota_entrada,
      cd_item_nota_entrada = mr.cd_item_nota_entrada,
      qt_item_nota_entrada = mr.qt_item_nota_entrada,
      ValorRecebido        = mr.ValorRecebido      
  from
    #Mapa_Compra   mp,
    #Mapa_Recebido mr
  where
    mp.Pedido = mr.Pedido and
    mp.Item   = mr.Item

  delete from #Mapa_Recebido
  from
    #Mapa_Compra   mp,
    #Mapa_Recebido mr
  where
    mp.Pedido = mr.Pedido and
    mp.Item   = mr.Item

  insert into #Mapa_Compra
   (GrupoCompra,
    CodPlano,
    PlanoCompra,
    Descricao,
    Fornecedor,
    Pedido,
    Item, 
    Qtd,
    Peso,
    Emissao,
    Necessidade,
    Entrega,
    ValorComprado,
    ICMS,
    IPI,
    Recebimento,
    cd_nota_entrada,
    cd_item_nota_entrada,
    qt_item_nota_entrada,
    ValorRecebido,
    DiaEntrega,
    nm_centro_custo,
    cd_mascara_produto,
    nm_fantasia_produto,
    nm_produto,
    sg_unidade_medida,
    vl_icms_item_pedido_compra,
    vl_ipi_item_pedido_compra)
  select
    GrupoCompra,
    CodPlano,
    PlanoCompra,
    Descricao,
    Fornecedor,
    Pedido,
    Item, 
    Qtd,
    Peso,
    Emissao,
    Necessidade,
    Entrega,
    ValorRecebido,
    ICMS,
    IPI,
    Recebimento,
    cd_nota_entrada,
    cd_item_nota_entrada,
    qt_item_nota_entrada,
    ValorRecebido,
    DiaEntrega,
    nm_centro_custo,
    cd_mascara_produto,
    nm_fantasia_produto,
    nm_produto,
    sg_unidade_medida,
    vl_icms_item_pedido_compra,
    vl_ipi_item_pedido_compra
  from
    #Mapa_Recebido

---------------------------------------------------------------------------------------------
--Verifica se o parâmetro é Recebimento - Deleta todos os pedidos não Recebidos
--------------------------------------------------------------------------------------------
if @ic_parametro = 1 --Somente Para os Pedidos Recebidos
begin

  delete from #Mapa_Compra
  where
    isnull(cd_nota_entrada,0) = 0

end


------------------------------------------------------------------------------------------
if (@ic_tipo_consulta = 'N') and (@ic_mapa_item_ped_compra = 'S') -- Mostra Mapa de Compras 
                                                                  -- por Item do Pedido de Compra.
------------------------------------------------------------------------------------------
begin

  select *
  from
    #Mapa_Compra
  order by 
    PlanoCompra,
    Emissao desc,
    Pedido,
    Item                      

end

------------------------------------------------------------
else -- Vai agrupar por pedido.
------------------------------------------------------------
begin

  -- Total Comprado para Cálculo de Percentual
  select 
    @vl_total = sum(ValorComprado)
  from
    #Mapa_Compra

  -- Total Recebido para Cálculo de Percentual
  select
    @vl_total_recebido = sum(ValorRecebido)
  from
    #Mapa_Compra

  -- Consulta do Mapa Analítico
  if IsNull(@ic_tipo_consulta,'N') = 'N'
    select
      GrupoCompra,
      CodPlano,
      PlanoCompra,
      Descricao,
      Fornecedor,
      Pedido,
      0                         as Item, 
      Sum(qtd)                  as Qtd,
      Sum(Peso)                 as Peso,
      Emissao,
      nm_centro_custo,
      sum(ValorComprado)        as ValorComprado,
      max(Necessidade)          as Necessidade,
      max(Entrega)              as Entrega,
      cast(Null as float)       as ICMS,
      cast(Null as float)       as IPI,
      max(Recebimento)          as Recebimento,
      max(cd_nota_entrada)      as cd_nota_entrada,
      0                         as cd_item_nota_entrada,
      sum(qt_item_nota_entrada) as qt_item_nota_entrada,
      sum(ValorRecebido)        as ValorRecebido,
      sum(DiaEntrega)           as DiaEntrega,
      max(nm_centro_custo)      as nm_centro_custo,
      max(cd_mascara_produto)   as cd_mascara_produto,
      max(nm_fantasia_produto)  as nm_fantasia_produto,
      max(nm_produto)           as nm_produto,
      max(sg_unidade_medida)    as sg_unidade_medida,
      max(vl_icms_item_pedido_compra) as vl_icms_item_pedido_compra,
      max(vl_ipi_item_pedido_compra)  as vl_ipi_item_pedido_compra

    from
      #Mapa_Compra
    group by
      GrupoCompra,
      CodPlano,
      PlanoCompra,
      Descricao,
      Fornecedor,
      Pedido,
      Emissao,
      nm_centro_custo
    order by 
      GrupoCompra,
      CodPlano,
      PlanoCompra,
      Emissao desc,
      nm_centro_custo,
      Pedido,
      Item                      

  -- Consulta do Mapa Sintético
  else if IsNull(@ic_tipo_consulta,'N') = 'S' 
  begin
    select 
      GrupoCompra,
      PlanoCompra,
      Descricao,
      sum(ValorComprado)  as ValorComprado,
      sum(ValorRecebido)  as ValorRecebido,
     (select top 1 isnull(pco.vl_previsto_plano_compra,0) from plano_compra_orcamento pco with (nolock)
      where pco.cd_plano_compra = CodPlano and
            pco.dt_final_plano_compra between @dt_inicial and @dt_final
      order by dt_final_plano_compra) as Estimado,
      cast((sum(ValorComprado) / @vl_total) * 100 as numeric(25,2))          as Porcent,
      cast((sum(ValorRecebido) / @vl_total_recebido) * 100 as numeric(25,2)) as PercRec    

    from
      #Mapa_Compra
    group by
      GrupoCompra,
      PlanoCompra,
      CodPlano,
      Descricao
    order by 
      PlanoCompra

  end    
  else
  -- Consulta do Mapa Anual
  begin

    -- Filtrados por Emissão - Demonstra o Valor Comprado
    if (@ic_parametro = 0)
      select 
        GrupoCompra,
        PlanoCompra,
        Descricao,
        sum(isnull(case when month(Emissao) =  1 then ValorComprado end,0)) as 'Janeiro',
        sum(isnull(case when month(Emissao) =  2 then ValorComprado end,0)) as 'Fevereiro',
        sum(isnull(case when month(Emissao) =  3 then ValorComprado end,0)) as 'Marco',
        sum(isnull(case when month(Emissao) =  4 then ValorComprado end,0)) as 'Abril',
        sum(isnull(case when month(Emissao) =  5 then ValorComprado end,0)) as 'Maio',
        sum(isnull(case when month(Emissao) =  6 then ValorComprado end,0)) as 'Junho',
        sum(isnull(case when month(Emissao) =  7 then ValorComprado end,0)) as 'Julho',
        sum(isnull(case when month(Emissao) =  8 then ValorComprado end,0)) as 'Agosto',
        sum(isnull(case when month(Emissao) =  9 then ValorComprado end,0)) as 'Setembro',
        sum(isnull(case when month(Emissao) = 10 then ValorComprado end,0)) as 'Outubro',
        sum(isnull(case when month(Emissao) = 11 then ValorComprado end,0)) as 'Novembro',
        sum(isnull(case when month(Emissao) = 12 then ValorComprado end,0)) as 'Dezembro',
        sum(ValorComprado) as 'Total_Grupo',
        cast((sum(ValorComprado) / @vl_total ) * 100 as numeric(25,2)) as 'Porcent'
      from
        #Mapa_Compra
      group by
        GrupoCompra,
        PlanoCompra,
        Descricao
      order by
        PlanoCompra

    -- Filtrados por Recebimento - Demonstra o Valor Recebido
    if (@ic_parametro = 1)
      select 
        GrupoCompra,
        PlanoCompra,
        Descricao,
        sum(isnull(case when month(Recebimento) = 1 then ValorRecebido end,0)) as 'Janeiro',
        sum(isnull(case when month(Recebimento) = 2 then ValorRecebido end,0)) as 'Fevereiro',
        sum(isnull(case when month(Recebimento) = 3 then ValorRecebido end,0)) as 'Marco',
        sum(isnull(case when month(Recebimento) = 4 then ValorRecebido end,0)) as 'Abril',
        sum(isnull(case when month(Recebimento) = 5 then ValorRecebido end,0)) as 'Maio',
        sum(isnull(case when month(Recebimento) = 6 then ValorRecebido end,0)) as 'Junho',
        sum(isnull(case when month(Recebimento) = 7 then ValorRecebido end,0)) as 'Julho',
        sum(isnull(case when month(Recebimento) = 8 then ValorRecebido end,0)) as 'Agosto',
        sum(isnull(case when month(Recebimento) = 9 then ValorRecebido end,0)) as 'Setembro',
        sum(isnull(case when month(Recebimento) = 10 then ValorRecebido end,0)) as 'Outubro',
        sum(isnull(case when month(Recebimento) = 11 then ValorRecebido end,0)) as 'Novembro',
        sum(isnull(case when month(Recebimento) = 12 then ValorRecebido end,0)) as 'Dezembro',
        sum(ValorRecebido) as 'Total_Grupo',
        cast((sum(ValorRecebido) / @vl_total_recebido ) * 100 as numeric(25,2)) as 'Porcent'
      from
        #Mapa_Compra
      group by
        GrupoCompra,
        PlanoCompra,
        Descricao
      order by
        PlanoCompra

    -- Filtrados por Entrega - Demonstra o Valor Comprado
    if (@ic_parametro = 2)
      select 
        GrupoCompra,
        PlanoCompra,
        Descricao,
        sum(isnull(case when month(Entrega) = 1 then ValorComprado end,0)) as 'Janeiro',
        sum(isnull(case when month(Entrega) = 2 then ValorComprado end,0)) as 'Fevereiro',
        sum(isnull(case when month(Entrega) = 3 then ValorComprado end,0)) as 'Marco',
        sum(isnull(case when month(Entrega) = 4 then ValorComprado end,0)) as 'Abril',
        sum(isnull(case when month(Entrega) = 5 then ValorComprado end,0)) as 'Maio',
        sum(isnull(case when month(Entrega) = 6 then ValorComprado end,0)) as 'Junho',
        sum(isnull(case when month(Entrega) = 7 then ValorComprado end,0)) as 'Julho',
        sum(isnull(case when month(Entrega) = 8 then ValorComprado end,0)) as 'Agosto',
        sum(isnull(case when month(Entrega) = 9 then ValorComprado end,0)) as 'Setembro',
        sum(isnull(case when month(Entrega) = 10 then ValorComprado end,0)) as 'Outubro',
        sum(isnull(case when month(Entrega) = 11 then ValorComprado end,0)) as 'Novembro',
        sum(isnull(case when month(Entrega) = 12 then ValorComprado end,0)) as 'Dezembro',
        sum(ValorComprado) as 'Total_Grupo',
        cast((sum(ValorComprado) / @vl_total ) * 100 as numeric(25,2)) as 'Porcent'
      from
        #Mapa_Compra
      group by
        GrupoCompra,
        PlanoCompra,
        Descricao
      order by
        PlanoCompra

  end
end

