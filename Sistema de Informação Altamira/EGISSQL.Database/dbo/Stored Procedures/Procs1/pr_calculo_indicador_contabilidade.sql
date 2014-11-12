
-----------------------------------------------------------------------------------
--pr_calculo_indicador_contabilidade
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004                     
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  / 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Objetivo         : Cálculo dos Indicadores da Contabilidade
--                
--Data             : 30.12.2004
--Atualizado       : 
--                 : 
-----------------------------------------------------------------------------------

create procedure pr_calculo_indicador_contabilidade
@ic_parametro         int,           --Cálculo
@dt_inicial           datetime,      --Data Inicial
@dt_final             datetime,      --Data Final
@ic_tipo_apresentacao int,
@cd_usuario           int = 0
as

--Plano de Contas
--select * from plano_conta
--select * from plano_conta_indicador
--select * from saldo_conta


--Zera os valores das Contas no Perído

  update
    Plano_Conta_Indicador
  set
    vl_total_periodo_conta = 0
  where
    cd_indicador = @ic_parametro

--Geração do Total das Contas

  update
    plano_conta_indicador
  set
    vl_total_periodo_conta = isnull(vl_total_periodo_conta,0) +  ( case when ic_saldo_conta = 'C' then isnull(vl_saldo_conta,0) * (-1) else isnull(vl_saldo_conta,0) end )
  from
    indicador_contabilidade ic,
    plano_conta_indicador   pci, 
    saldo_conta             sc
  where
    @ic_parametro     = ic.cd_indicador    and
    ic.cd_indicador   = pci.cd_indicador   and
    pci.cd_conta      = sc.cd_conta        and
    sc.dt_saldo_conta between @dt_inicial  and @dt_final


--Resultado dos Indicadores

  declare @cd_ordem               int
  declare @vl_resultado_indicador float
  declare @vl_aux                 float

  set @cd_ordem               = 0
  set @vl_resultado_indicador = 0
  set @vl_aux                 = 0

-----------------------------------------------------------------------------------
--Liquidez Corrente
-----------------------------------------------------------------------------------

if @ic_parametro = 1
begin

  set @vl_resultado_indicador = 0

  set @vl_aux = 
  ( select 
      isnull(vl_total_periodo_conta,0) 
    from 
      Plano_Conta_Indicador where cd_indicador = @ic_parametro and cd_ordem_calculo = 2)

  --Cálculo do Indicador

  select @vl_resultado_indicador = 
  ( select 
      isnull(vl_total_periodo_conta,0) 
    from 
      Plano_Conta_Indicador where cd_indicador = @ic_parametro and cd_ordem_calculo = 1)

    / 

    case when @vl_aux>0 then @vl_aux else 1 end



end

-----------------------------------------------------------------------------------
--Liquidez Seca
-----------------------------------------------------------------------------------

if @ic_parametro = 2
begin

  set @vl_resultado_indicador = 0

  set @vl_aux = 
  ( select 
      isnull(vl_total_periodo_conta,0) 
    from 
      Plano_Conta_Indicador where cd_indicador = @ic_parametro and cd_ordem_calculo = 3)

  --Cálculo do Indicador

  select @vl_resultado_indicador = 
  (( select 
      isnull(vl_total_periodo_conta,0) 
    from 
      Plano_Conta_Indicador where cd_indicador = @ic_parametro and cd_ordem_calculo = 1) -

   ( select 
      isnull(vl_total_periodo_conta,0) 
    from 
      Plano_Conta_Indicador where cd_indicador = @ic_parametro and cd_ordem_calculo = 2))

    / 

    case when @vl_aux>0 then @vl_aux else 1 end



end


-----------------------------------------------------------------------------------
--Liquidez Imediata
-----------------------------------------------------------------------------------

if @ic_parametro = 3
begin

  set @vl_resultado_indicador = 0

  set @vl_aux = 
  ( select 
      isnull(vl_total_periodo_conta,0) 
    from 
      Plano_Conta_Indicador where cd_indicador = @ic_parametro and cd_ordem_calculo = 2)

  --Cálculo do Indicador

  select @vl_resultado_indicador = 
  ( select 
      isnull(vl_total_periodo_conta,0) 
    from 
      Plano_Conta_Indicador where cd_indicador = @ic_parametro and cd_ordem_calculo = 1)

    / 

    case when @vl_aux>0 then @vl_aux else 1 end


end


-----------------------------------------------------------------------------------
--Atualiza a Tabela com o Cálculo do Indicador
-----------------------------------------------------------------------------------

  --delete o cálculo anterior
  delete from Indicador_Contabilidade_Resultado where cd_indicador           = @ic_parametro and 
                                                      dt_inicial_resultado   = @dt_inicial   and 
                                                      dt_final_resultado     = @dt_final

  --insere o novo cálculo

  insert Indicador_Contabilidade_Resultado (
    cd_indicador,
    dt_inicial_resultado,
    dt_final_resultado,
    vl_resultado_indicador,
    cd_usuario,
    dt_usuario )
  select
    @ic_parametro,
    @dt_inicial,
    @dt_final,
    isnull(@vl_resultado_indicador,0),
    @cd_usuario,
    getdate()

-----------------------------------------------------------------------------------
--Tipo de Apresentacao
-----------------------------------------------------------------------------------
-- 1 -> Indice
-- 2 -> Tabela de Apresentação Temporária com todos os índices cálculados
-----------------------------------------------------------------------------------
if @ic_tipo_apresentacao=1
   begin
     select * from plano_conta_indicador
     select * from indicador_contabilidade_resultado
   end
else
   begin
     select * from plano_conta_indicador
     select * from indicador_contabilidade_resultado
   end


