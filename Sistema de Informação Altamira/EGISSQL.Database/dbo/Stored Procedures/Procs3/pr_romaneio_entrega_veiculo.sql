
-------------------------------------------------------------------------------
--sp_helptext pr_romaneio_entrega_veiculo
-------------------------------------------------------------------------------
--pr_romaneio_entrega_veiculo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Romaneio de Entrega por Veículo
--Data             : 12.01.2009
--Alteração        : 
--
-- 12.03.2009 - Verificação da Rotina e ajustes diversos - Carlos Fernandes 
-- 01.04.2009 - Verificação da Rotina - Carlos Fernandes
-- 02.04.2009 - Ajustes Diversos - Carlos Fernandes
-- 11.04.2009 - Verificação para não mostrar nota fiscal cancelada - Carlos Fernandes
-- 14.04.2009 - Data da Saída da Nota - Carlos Fernandes
-- 23.10.2010 - Número de Identificação da Nota Fiscal - Carlos Fernandes
-------------------------------------------------------------------------------------
create procedure pr_romaneio_entrega_veiculo
@cd_veiculo   int      = 0,
@dt_inicial   datetime = '',
@dt_final     datetime = '',
@dt_base      datetime = null,
@ic_parametro int      = 0,
@dt_entrega   datetime = ''
as

--Data Base passar no Formulário

if @dt_base is null
begin
  set @dt_base = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)
end

--set @dt_base = @dt_base + 1

if @dt_entrega is null
begin
   set @dt_entrega = @dt_base + 1
end

--select @dt_base,@dt_entrega

------------------------------------------------------------------------------

declare @cd_semana_inicial int
declare @cd_semana_final   int

-- select * from vendedor
-- select
--   @cd_semana_inicial = datepart(dw,@dt_inicial),
--   @cd_semana_final   = datepart(dw,@dt_final)

select
  @cd_semana_inicial = datepart(dw,@dt_entrega),
  @cd_semana_final   = datepart(dw,@dt_entrega)

--select @cd_semana_inicial,@cd_semana_final

  select
    v.cd_veiculo,
    v.nm_veiculo, 
    m.nm_fantasia_motorista,
    va.cd_vendedor,
    ae.nm_area_entrega,
    ae.sg_area_entrega,
    va.cd_tipo_carga,
    tc.nm_tipo_carga,
    tc.sg_tipo_carga
  into
    #VeiculoCarga

  from 
    veiculo_area_regiao va
    left outer join veiculo v       on v.cd_veiculo       = va.cd_veiculo
    left outer join motorista m     on m.cd_veiculo       = v.cd_veiculo
    left outer join area_entrega ae on ae.cd_area_entrega = va.cd_area_entrega
    left outer join tipo_carga   tc on tc.cd_tipo_carga   = va.cd_tipo_carga
  where
    va.cd_veiculo = case when @cd_veiculo = 0 then va.cd_veiculo else @cd_veiculo end  
    and
    va.cd_area_entrega in ( select x.cd_area_entrega 
                         from area_entrega x with (nolock) 
                         where 
                           x.cd_semana between @cd_semana_inicial and @cd_semana_final )

--select * from #VeiculoCarga

------------------------------------------------------------------------------
--Composição da Carga no Dia de Entrega do Veículo
------------------------------------------------------------------------------


-- select
--   *
-- from
--   #VeiculoCarga

------------------------------------------------------------------------------

select
  ns.cd_veiculo,
  isnull(v.nm_veiculo,'Sem Veículo Definido') as nm_veiculo,
  ve.nm_fantasia_vendedor,
  ns.cd_vendedor,
  ns.cd_cliente,
--  ns.cd_nota_saida,
  case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
    ns.cd_identificacao_nota_saida
  else
    ns.cd_nota_saida                              
  end                                                     as cd_nota_saida,

  ns.dt_nota_saida,
  ns.dt_saida_nota_saida,
  ns.nm_fantasia_nota_saida,
  ns.nm_razao_social_nota,
  ns.vl_total,
  cp.sg_condicao_pagamento,
  fp.nm_forma_pagamento,
  fp.sg_forma_pagamento,
  ns.nm_endereco_nota_saida+', '+cd_numero_end_nota_saida as nm_endereco,
  ns.nm_bairro_nota_saida,
  ns.nm_cidade_nota_saida,
  ns.sg_estado_nota_saida,
  ns.cd_cep_nota_saida,
  ltrim(rtrim(cast(ns.cd_vendedor as varchar(8)))) + '/' + cv.sg_area_criterio_visita as STAR,

--select * from criterio_visita

--    ltrim(rtrim((select top 1
--                                                                           vc.sg_area_entrega
--                                                                         from
--                                                                           #VeiculoCarga vc
--                                                                         where
--                                                                           vc.cd_veiculo     = v.cd_veiculo and
--                                                                           vc.cd_vendedor    = ns.cd_vendedor))) as STAR,
  ( select top 1 cd_pedido_venda 
    from nota_saida_item with (nolock) 
    where
      cd_nota_saida = ns.cd_nota_saida ) as cd_pedido_venda,

  cv.sg_area_criterio_visita as sg_criterio_visita,
  mot.nm_motorista,

  --Dados da Carga para Montagem do Cabeçalho

  @dt_entrega                                        as 'Data_Entrega',

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

    cast('' as varchar(40) )                        as 'Observacao',

    ( select count(*)
      from
        #VeiculoCarga vc
      where
        vc.cd_veiculo = v.cd_veiculo)
                                                    as 'Qtd_Area'      

into
  #RomaneioEntregaVeiculo

from 
  nota_saida                         ns         with (nolock)
  left outer join cliente            c          with (nolock) on c.cd_cliente              = ns.cd_cliente
  left outer join cliente_informacao_credito ci with (nolock) on ci.cd_cliente             = c.cd_cliente
  left outer join Veiculo            v          with (nolock) on v.cd_veiculo              = ns.cd_veiculo
  left outer join Vendedor           ve         with (nolock) on ve.cd_vendedor            = ns.cd_vendedor
  left outer join area_atuacao_venda aav        with (nolock) on aav.cd_area_atuacao_venda = ve.cd_area_atuacao_venda
--  left outer join Area_Entrega       ae         with (nolock) on ae.cd_area_entrega        = ns.
  left outer join Condicao_Pagamento cp         with (nolock) on cp.cd_condicao_pagamento  = ns.cd_condicao_pagamento
  left outer join Operacao_fiscal    opf        with (nolock) on opf.cd_operacao_fiscal    = ns.cd_operacao_fiscal
  left outer join Forma_Pagamento    fp         with (nolock) on fp.cd_forma_pagamento     = ci.cd_forma_pagamento
  left outer join criterio_visita    cv         with (nolock) on cv.cd_criterio_visita     = c.cd_criterio_visita
  left outer join Motorista          mot        with (nolock) on mot.cd_motorista          = ns.cd_motorista
where
--  ns.dt_nota_saida between @dt_inicial and @dt_final                                  and
  ns.dt_nota_saida between  @dt_base and @dt_base and 
  isnull(ns.cd_veiculo,0)   = case when @cd_veiculo = 0 then isnull(ns.cd_veiculo,0) else @cd_veiculo end and
  ns.dt_cancel_nota_saida is null
  --and isnull(opf.ic_comercial_operacao,'N') = 'S'
  --Verifica qual operação deve entrar no Romanei/Mapa de Carga
  and isnull(opf.ic_carga_op_fiscal,'N') = 'S'  
  and ns.dt_cancel_nota_saida is null
  and isnull(ns.cd_ordem_carga,0)=0

--select * from operacao_fiscal

order by
  ns.cd_veiculo,
  ns.nm_fantasia_nota_saida

if @ic_parametro = 0
begin

  select
    *
  from
    #RomaneioEntregaVeiculo

  order by
    cd_veiculo,
    cd_vendedor, 
    cd_nota_saida

end

-------------------------------------------------------------------------------
--Resumo por Vendedor
-------------------------------------------------------------------------------

if @ic_parametro = 1
begin

  select
    cd_vendedor,
    count(*)          as qtd_nota
  from
    #RomaneioEntregaVeiculo
  group by
    cd_vendedor

  order by
    cd_vendedor

end

-------------------------------------------------------------------------------
--Mapa de Carga 
-------------------------------------------------------------------------------

--Resumo por Carga

if @ic_parametro = 2
begin
  print '1'
end

--Resumo da Carga por Embalagem

if @ic_parametro = 3
begin
  print '1'
end

-------------------------------------------------------------------------------

