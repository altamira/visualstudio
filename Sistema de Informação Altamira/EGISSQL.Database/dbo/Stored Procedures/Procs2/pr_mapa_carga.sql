
-------------------------------------------------------------------------------
--sp_helptext pr_mapa_carga
-------------------------------------------------------------------------------
--pr_mapa_carga
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Mapa de Carga
--Data             : 01.01.2008
--Alteração        : 16.12.2008 
--
-- 17.03.2009 - Ajustes - Carlos Fernandes
-- 23.03.2009 - Conversão de Unidade/Embalagem - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_mapa_carga
@ic_parametro       int           = 0,
@cd_veiculo         int           = 0,
@cd_area_entrega    int           = 0,
@dt_inicial         datetime      = '',
@dt_final           datetime      = '',
@cd_usuario         int           = 0,
@dt_base            datetime      = null,
@cd_nota_saida      int           = 0,
@cd_item_nota_saida int           = 0,
@selecao            varchar(8000) = '',
@ic_relatorio       int           = 0,
@dt_faturamento     datetime      = ''
 
as

if @dt_base is null
begin
  set @dt_base = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)
end

if @dt_faturamento is null
   set @dt_faturamento = @dt_base - 1

declare @cd_dia int
--declare @cd_semana_final   int


select
  @cd_dia = datepart(dw,@dt_base)

--  @cd_semana_final   = datepart(dw,@dt_final)

  select
    v.cd_veiculo,
    v.nm_veiculo, 
    mv.nm_marca_veiculo,
    m.cd_motorista,
    m.nm_fantasia_motorista,
    va.cd_vendedor,
    ve.nm_fantasia_vendedor,
    ae.nm_area_entrega,
    ae.sg_area_entrega,
    va.cd_tipo_carga,
    tc.nm_tipo_carga,
    tc.sg_tipo_carga
  into
    #VeiculoCarga
  from 
    veiculo_area_regiao          va   with(nolock)
    left outer join vendedor ve       with(nolock) on ve.cd_vendedor      = va.cd_vendedor 
    left outer join veiculo v         with(nolock) on v.cd_veiculo        = va.cd_veiculo
    left outer join marca_veiculo mv  with(nolock) on mv.cd_marca_veiculo = v.cd_marca_veiculo 
    left outer join motorista m       with(nolock) on m.cd_veiculo        = v.cd_veiculo
    left outer join area_entrega ae   with(nolock) on ae.cd_area_entrega  = va.cd_area_entrega
    left outer join tipo_carga   tc   with(nolock) on tc.cd_tipo_carga    = va.cd_tipo_carga
  where
    va.cd_area_entrega in (select 
                             x.cd_area_entrega 
                           from 
                             area_entrega x with(nolock)
                           where 
                             x.cd_semana between @cd_dia and @cd_dia )

  if object_id('tempdb.dbo.##VeiculoCarga') is not null drop table ##VeiculoCarga

  --select @Selecao

  if ((@Selecao is null) or (@Selecao = '') or (@Selecao = '0'))  
    select * into ##VeiculoCarga from #VeiculoCarga
  else
    exec ('select * into ##VeiculoCarga from #VeiculoCarga where cd_veiculo in ('+@Selecao+')') -- Declarando Tabela Global no SQL


--select * from #VeiculoCarga
  
--Dados
  
if @ic_parametro = 0
begin

  select distinct
    0                                               as Selecionado,
    v.cd_veiculo,
    v.nm_veiculo,
    v.cd_placa_veiculo,
    m.cd_motorista,
    m.nm_motorista,
    @dt_base                                        as 'Data_Entrega',
    cast((select top 1 vc.sg_tipo_carga + '-' + cast(vc.cd_vendedor as varchar)
         from 
           #VeiculoCarga vc 
         where 
           vc.cd_veiculo    = v.cd_veiculo and
           vc.cd_tipo_carga = 1 ) as varchar(40) )  as 'Carga_A',

    cast((select top 1 vc.sg_tipo_carga + '-' + cast(vc.cd_vendedor as varchar)
         from 
           #VeiculoCarga vc 
         where 
           vc.cd_veiculo    = v.cd_veiculo and
           vc.cd_tipo_carga = 2 ) as varchar(40) )  as 'Carga_B',

    cast((select top 1 vc.sg_tipo_carga + '-' + cast(vc.cd_vendedor as varchar)
         from 
           #VeiculoCarga vc 
         where 
           vc.cd_veiculo    = v.cd_veiculo and
           vc.cd_tipo_carga = 3 ) as varchar(40) )  as 'Carga_C',

    cast((select top 1 vc.sg_tipo_carga + '-' + cast(vc.cd_vendedor as varchar)
         from 
           #VeiculoCarga vc 
         where 
           vc.cd_veiculo    = v.cd_veiculo and
           vc.cd_tipo_carga = 4 ) as varchar(40) )  as 'Carga_D',

    cast((select top 1 vc.sg_tipo_carga + '-' + cast(vc.cd_vendedor as varchar)
         from 
           #VeiculoCarga vc 
         where 
           vc.cd_veiculo    = v.cd_veiculo and
           vc.cd_tipo_carga = 5 ) as varchar(40) )  as 'Carga_E',

    cast('' as varchar(40) ) as 'Observacao',

    ( select count(*)
      from
        #VeiculoCarga vc
      where
        vc.cd_veiculo = v.cd_veiculo)
                             as 'Qtd_Area'     

  from 
    Veiculo v                     with (nolock)
    inner join motorista      m   with (nolock) on m.cd_veiculo       = v.cd_veiculo
    inner join ##VeiculoCarga vc  with (nolock) on vc.cd_veiculo      = v.cd_veiculo

  order by
    v.nm_veiculo

end

--select cd_vendedor, * from nota_saida 

--select * from ##VeiculoCarga

--Cargas/Vendedores

if @ic_parametro = 1
begin

  select
    vc.*
  from
    ##VeiculoCarga vc
  where
    vc.cd_veiculo = case when @cd_veiculo = 0 then vc.cd_veiculo else @cd_veiculo end 
  order by
    vc.nm_veiculo, 
    vc.nm_fantasia_motorista,
    vc.cd_vendedor

end


--Montagem da Carga

if @ic_parametro = 2
begin

  select
    nsi.cd_produto,
    nsi.cd_mascara_produto,
    ns.cd_veiculo,
    v.nm_veiculo,
    fp.nm_fase_produto,
    nsi.nm_fantasia_produto,
    nsi.nm_produto_item_nota,
    um.sg_unidade_medida,
    nsi.qt_item_nota_saida,
    p.qt_multiplo_embalagem,
    Embalagem = round( nsi.qt_item_nota_saida / case when p.qt_multiplo_embalagem>0 then p.qt_multiplo_embalagem else 1 end,0),
    Unidade   = nsi.qt_item_nota_saida - ( round( nsi.qt_item_nota_saida / case when p.qt_multiplo_embalagem>0 then p.qt_multiplo_embalagem else 1 end,0) * p.qt_multiplo_embalagem )

  into 
    #Carga

  from
    Nota_Saida_Item                nsi with (nolock) 
    inner join Nota_Saida          ns  with (nolock) on ns.cd_nota_saida     = nsi.cd_nota_saida
    inner join ##VeiculoCarga      vc  with (nolock) on vc.cd_vendedor       = ns.cd_vendedor
    left outer join Unidade_Medida um  with (nolock) on um.cd_unidade_medida = nsi.cd_unidade_medida
    left outer join Fase_Produto   fp  with (nolock) on fp.cd_fase_produto   = nsi.cd_fase_produto   
    inner join Produto             p   with (nolock) on p.cd_produto         = nsi.cd_produto
    left outer join Veiculo        v   with (nolock) on v.cd_veiculo         = ns.cd_veiculo
  where
--    ns.cd_veiculo = case when @cd_veiculo = 0 then ns.cd_veiculo else @cd_veiculo end and
--    ns.dt_nota_saida between @dt_faturamento and @dt_faturamento
    ns.dt_nota_saida between @dt_faturamento and @dt_faturamento
    and nsi.dt_restricao_item_nota is null

--select * from #Carga

    select 
      cd_veiculo,
      cd_produto,
      max(cd_mascara_produto)    as cd_mascara_produto,
      max(nm_veiculo)            as nm_veiculo,
      max(nm_fase_produto)       as nm_fase_produto,
      max(nm_fantasia_produto)   as nm_fantasia_produto,
      max(nm_produto_item_nota)  as nm_produto,
      max(sg_unidade_medida)     as sg_unidade_medida,
      sum(qt_item_nota_saida)    as qt_item_nota_saida,
      sum(Embalagem)             as qt_embalagem,
      sum(Unidade)               as qt_unidade,
      cast( dbo.fn_strzero(sum(Embalagem),6) as varchar) + ' + ' + cast( dbo.fn_strzero(sum(Unidade),3) as varchar) as nm_embalagem_unidade
    from 
      #Carga

    group by
      cd_veiculo,
      cd_produto

    order by
      cd_veiculo

end

--Quantidade por Embalagem

if @ic_parametro = 3
begin

  select
    p.cd_tipo_embalagem,
    vc.cd_veiculo,
    vc.nm_veiculo,
    te.nm_tipo_embalagem   as nm_tipo_embalagem,
    nsi.qt_item_nota_saida as qt_item_nota_saida,
    p.qt_multiplo_embalagem,
    Embalagem = round( nsi.qt_item_nota_saida / case when p.qt_multiplo_embalagem>0 then p.qt_multiplo_embalagem else 1 end,0),
    Unidade   = nsi.qt_item_nota_saida - ( round( nsi.qt_item_nota_saida / case when p.qt_multiplo_embalagem>0 then p.qt_multiplo_embalagem else 1 end,0) * p.qt_multiplo_embalagem )

  into 
    #embalagem

  from
    Nota_Saida_Item                 nsi with (nolock) 
    inner join Nota_Saida           ns  with (nolock) on ns.cd_nota_saida     = nsi.cd_nota_saida
    --inner join ##VeiculoCarga        vc  with (nolock) on vc.cd_vendedor       = ns.cd_vendedor
    left outer join Produto         p   with (nolock) on p.cd_produto         = nsi.cd_produto
    left outer join Tipo_Embalagem  te  with (nolock) on te.cd_tipo_embalagem = p.cd_tipo_embalagem
    left outer join Veiculo vc          with (nolock) on vc.cd_veiculo        = ns.cd_veiculo
  where
    ns.dt_nota_saida between @dt_faturamento and @dt_faturamento
    and ns.cd_veiculo = case when @cd_veiculo = 0 then ns.cd_veiculo else @cd_veiculo end 
    and nsi.dt_restricao_item_nota is null

--select * from nota_saida_item

  order by
    te.nm_tipo_embalagem

--  select * from #embalagem

    select 
      cd_veiculo,
      cd_tipo_embalagem,
      max(nm_veiculo)         as nm_veiculo,
      max(nm_tipo_embalagem)  as nm_tipo_embalagem,
      sum(qt_item_nota_saida) as qt_item_nota_saida,
      sum(Embalagem)             as qt_embalagem,
      sum(Unidade)               as qt_unidade,
      cast( dbo.fn_strzero(sum(Embalagem),6) as varchar) + ' + ' + cast( dbo.fn_strzero(sum(Unidade),3) as varchar) as nm_embalagem_unidade

    from 
      #embalagem
    group by
      cd_veiculo,
      cd_tipo_embalagem
    order by
      cd_veiculo

end


--Notas

if @ic_parametro = 4
begin
  
  --select @dt_faturamento


  select
    v.nm_fantasia_vendedor,
    ns.cd_vendedor,
    ns.cd_nota_saida,
    ns.cd_veiculo,
    vc.nm_veiculo,
    ns.dt_nota_saida,
    ns.nm_fantasia_nota_saida,
    ns.nm_razao_social_nota,
    ns.vl_total,
    p.nm_produto,
    p.nm_fantasia_produto,
    p.cd_mascara_produto,
    case when isnull(nsi.qt_item_nota_saida,0) > 0 then
      (nsi.qt_item_nota_saida * isnull(nsi.vl_unitario_item_nota,0.00))
    else
      case when isnull(nsi.vl_unitario_item_nota,0) > 0 then 
        nsi.vl_unitario_item_nota
      else
        0.00
      end
    end  as TotalItemValor,
    nsi.cd_item_nota_saida,
    nsi.vl_unitario_item_nota,
    nsi.qt_item_nota_saida,
    (select sum(qt_item_nota_saida) from nota_saida_item where cd_nota_saida = ns.cd_nota_saida) as QtdNotaSaida,
    cp.sg_condicao_pagamento,
    fp.nm_forma_pagamento,
    ns.nm_endereco_nota_saida+', '+cd_numero_end_nota_saida as nm_endereco,
    ns.nm_bairro_nota_saida,
  ns.nm_cidade_nota_saida,
  ns.sg_estado_nota_saida,
  ns.cd_cep_nota_saida,
  ( select top 1 cd_pedido_venda from nota_saida_item with (nolock) 
    where
      cd_nota_saida = ns.cd_nota_saida ) as cd_pedido_venda,
  cv.sg_criterio_visita
  from 
    nota_saida                         ns         with (nolock)
    inner join nota_saida_item         nsi        with (nolock) on nsi.cd_nota_saida        = ns.cd_nota_saida
--    inner join ##VeiculoCarga          vc         with (nolock)on vc.cd_vendedor           = ns.cd_vendedor
    left outer join cliente            c          with (nolock) on c.cd_cliente             = ns.cd_cliente
    left outer join produto            p          with (nolock) on p.cd_produto             = nsi.cd_produto
    left outer join cliente_informacao_credito ci with (nolock) on ci.cd_cliente            = c.cd_cliente
    left outer join Vendedor           v          with (nolock) on v.cd_vendedor            = ns.cd_vendedor
    left outer join Condicao_Pagamento cp         with (nolock) on cp.cd_condicao_pagamento = ns.cd_condicao_pagamento
    left outer join Operacao_fiscal    opf        with (nolock) on opf.cd_operacao_fiscal   = ns.cd_operacao_fiscal
    left outer join Forma_Pagamento    fp         with (nolock) on fp.cd_forma_pagamento    = ci.cd_forma_pagamento
    left outer join criterio_visita    cv         with (nolock) on cv.cd_criterio_visita    = c.cd_criterio_visita
    left outer join Veiculo            vc         with (nolock) on vc.cd_veiculo            = ns.cd_veiculo
  where
    ns.cd_veiculo = case when @cd_veiculo = 0 then ns.cd_veiculo else @cd_veiculo end             and
    ns.dt_nota_saida between @dt_faturamento and @dt_faturamento and
    ns.dt_cancel_nota_saida is null                                                               and
    ns.cd_nota_saida = case when @cd_nota_saida = 0 then ns.cd_nota_saida else @cd_nota_saida end and
    nsi.cd_item_nota_saida = case when @cd_item_nota_saida = 0 then 
                               (select 
                                  min(cd_item_nota_saida)
                                from
                                  nota_saida_item
                                where
                                  cd_nota_saida = ns.cd_nota_saida)
                             else
                                nsi.cd_item_nota_saida
                             end      
                             
    and nsi.dt_restricao_item_nota is null

  order by
    ns.cd_vendedor,
    ns.nm_fantasia_nota_saida

end

--Itens da Nota

if @ic_parametro = 5
begin

  select distinct
    v.cd_veiculo,
    v.nm_veiculo,
    v.cd_placa_veiculo,
    m.cd_motorista,
    m.nm_motorista,
    vc.nm_marca_veiculo,
    vc.sg_area_entrega  
  from 
    Veiculo v                     with (nolock)
    left outer join motorista m   with(nolock) on m.cd_veiculo       = v.cd_veiculo
    inner join ##VeiculoCarga vc  with(nolock) on vc.cd_veiculo      = v.cd_veiculo
   
  order by
    v.nm_veiculo

end


drop table ##VeiculoCarga

