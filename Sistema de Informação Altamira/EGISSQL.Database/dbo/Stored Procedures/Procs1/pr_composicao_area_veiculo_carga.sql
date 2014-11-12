
-------------------------------------------------------------------------------
--sp_helptext pr_composicao_area_veiculo_carga
-------------------------------------------------------------------------------
--pr_composicao_area_veiculo_carga
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta da Composição de Veículo x Área x Carga
--
--Data             : 19.11.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_composicao_area_veiculo_carga
@cd_veiculo int = 0

as

--select * from veiculo
--select * from veiculo_area_regiao
--select * from veiculo_capacidade
--select * from area_entrega
--select * from vendedor

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
    Veiculo v 
    left outer join veiculo_area_regiao va with (nolock) on va.cd_veiculo      = v.cd_veiculo
    left outer join motorista m            with (nolock) on m.cd_veiculo       = v.cd_veiculo
    left outer join area_entrega ae        with (nolock) on ae.cd_area_entrega = va.cd_area_entrega
    left outer join tipo_carga   tc        with (nolock) on tc.cd_tipo_carga   = va.cd_tipo_carga
  where
    v.cd_veiculo = case when @cd_veiculo = 0 then v.cd_veiculo else @cd_veiculo end

--select * from veiculo_area_regiao
--select * from #VeiculoCarga

select
  va.*,
  --v.cd_veiculo,
  v.nm_veiculo,
  v.cd_placa_veiculo,
  vc.qt_peso_bruto_veiculo,
  vc.qt_volume_veiculo,
  ae.nm_area_entrega,
  ae.nm_identificacao_area,
  tc.nm_tipo_carga,
  vd.cd_vendedor,
  vd.sg_vendedor,

  --Cargas

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
  Veiculo_Area_Regiao va                with (nolock)
  inner join Veiculo  v                 with (nolock) on v.cd_veiculo       = va.cd_veiculo
  left outer join Veiculo_Capacidade vc with (nolock) on vc.cd_veiculo      = v.cd_veiculo
  left outer join Area_Entrega       ae with (nolock) on ae.cd_area_entrega = va.cd_area_entrega
  left outer join Tipo_Carga         tc with (nolock) on tc.cd_tipo_carga   = va.cd_tipo_carga
  left outer join Vendedor           vd with (nolock) on vd.cd_vendedor     = va.cd_vendedor
where
  va.cd_veiculo = case when @cd_veiculo = 0 then va.cd_veiculo else @cd_veiculo end




--select * from veiculo

