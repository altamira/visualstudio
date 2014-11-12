
-------------------------------------------------------------------------------
--sp_helptext pr_diario_veiculo
-------------------------------------------------------------------------------
--pr_diario_veiculo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Diário de Veículo
--Data             : 23.12.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_diario_veiculo
@cd_diario_veiculo int      = 0,
@dt_base           datetime = '',
@dt_inicial        datetime = '',
@dt_final          datetime = '',
@ic_parametro      int      = 0,
@cd_veiculo        int      = 0


as


--Diário do Veículo-----------------------------------------------------------

--select * from diario_veiculo

--Geração da Tabela

if @ic_parametro = 0 and @cd_veiculo>0
begin

  select
    ns.cd_veiculo,
    ns.dt_nota_saida        as dt_diario_veiculo,
    count(ns.cd_nota_saida) as qt_nota_diario,
    sum(ns.vl_total)        as vl_total_diario,
    0.00                    as qt_caixa_diario,
    0.00                    as qt_produto_diario
  into
    #AuxNotaDiario
  from
    Nota_Saida ns
  where
    ns.cd_veiculo    = @cd_veiculo and
    ns.dt_nota_saida = @dt_base
  group by
    ns.cd_veiculo, 
    ns.dt_nota_saida

  update
    Diario_Veiculo
  set
    qt_nota_diario  = x.qt_nota_diario,
    vl_total_diario = x.vl_total_diario
  from
    Diario_Veiculo dv
    inner join #AuxNotaDiario x on x.cd_veiculo        = dv.cd_veiculo and
                                   x.dt_diario_veiculo = dv.cd_diario_veiculo
 
end

--Consulta--------------------------------------------------------------------

if @ic_parametro = 1
begin
  select
    dv.*,
    --Veículo
    v.nm_veiculo,
    v.aa_veiculo,
    v.cd_placa_veiculo,
    v.cd_chassi_veiculo

  from
    Diario_Veiculo dv         with (nolock) 
    left outer join Veiculo v with (nolock) on v.cd_veiculo = dv.cd_veiculo
   where
     dv.cd_diario_veiculo = case when @cd_diario_veiculo = 0 then dv.cd_diario_veiculo else @cd_diario_veiculo end and
     dv.dt_diario_veiculo = @dt_base 
end


