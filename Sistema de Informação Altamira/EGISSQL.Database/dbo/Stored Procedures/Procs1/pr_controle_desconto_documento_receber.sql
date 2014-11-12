
-------------------------------------------------------------------------------
--sp_helptext pr_controle_desconto_documento_receber
-------------------------------------------------------------------------------
--pr_controle_desconto_documento_receber
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--
--Objetivo         : Controle de Desconto de Documentos a Receber
--
--Data             : 27.10.2009
--Alteração        : 04.11.2009 - Ajustes Diversos - Carlos Fernandes
--
-- 22.12.2009 - Ajustes Diversos - Carlos Fernandes
-- 29.12.2009 - Cálculo do IOF   - Carlos Fernandes
-- 13.12.2010 - Geração do Movimento de Conta Bancária - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_controle_desconto_documento_receber
@ic_parametro        int      = 0,
@dt_inicial          datetime = '',
@dt_final            datetime = '',
@cd_conta_banco      int      = 0,
@dt_base_calculo     datetime = null,
@cd_bordero_desconto int      = 0,
@cd_usuario          int      = 0,
@cd_portador         int      = 0

as

if @dt_base_calculo is null
begin
   set @dt_base_calculo = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)
end

--select * from documento_receber

--select * from conta_agencia_banco

declare @Tabela                   varchar(80)
declare @vl_taxa_desconto         float --decimal(25,4)
declare @vl_taxa_custo_desconto   decimal(25,2)
declare @vl_taxa_bordero_desconto decimal(25,2)
declare @vl_taxa_iof_desconto     decimal(25,4)
declare @cd_empresa               int
declare @cd_banco                 int

select
  @cd_empresa = dbo.fn_empresa()

-- select
--   isnull(vl_taxa_desconto,1),
--   isnull(vl_taxa_custo_desconto,1),
--   isnull(vl_taxa_bordero_desconto,1),
--   isnull(vl_taxa_iof_desconto,1),
--   cd_banco
--   
-- 
-- from
--   conta_agencia_banco with (nolock) 
-- 
-- where
--   cd_conta_banco = @cd_conta_banco

--select * from bordero_desconto

select
  @vl_taxa_desconto         = isnull(vl_taxa_desconto,1),
  @vl_taxa_custo_desconto   = isnull(vl_taxa_custo_desconto,1),
  @vl_taxa_bordero_desconto = isnull(vl_taxa_bordero_desconto,1),
  @vl_taxa_iof_desconto     = isnull(vl_taxa_iof_desconto,1),
  @cd_banco                 = cd_banco
  

from
  conta_agencia_banco with (nolock) 

where
  cd_conta_banco = @cd_conta_banco

--select @vl_taxa_desconto,@vl_taxa_custo_desconto,@vl_taxa_bordero_desconto,@vl_taxa_iof_desconto

--Busca o Portador

if @cd_portador = 0
begin

  select
     @cd_portador = isnull(cd_portador,0)
  from
    portador with (nolock) 
  where
    cd_conta_banco = @cd_conta_banco

end


--Calculo---------------------------------------------------------------------------------------------

if @ic_parametro = 1 
begin

select 
  identity(int,1,1)            as cd_item_desconto,
  isnull(@cd_portador,0)       as cd_portador,
  c.nm_fantasia_cliente,
  c.nm_razao_social_cliente,
  d.cd_documento_receber,
  d.cd_identificacao,
  d.dt_emissao_documento,
  d.dt_vencimento_documento,
  d.vl_saldo_documento,

  pc_desconto_documento = @vl_taxa_desconto,

  qt_dia_desconto       = cast( d.dt_vencimento_documento - @dt_base_calculo as int ),

  vl_juros_desconto     =
     --cast(
     case when @cd_banco = 1 then
        (d.vl_saldo_documento * @vl_taxa_desconto * cast( d.dt_vencimento_documento - @dt_base_calculo as int ) / 3000 )
     else
        (d.vl_saldo_documento * ( (@vl_taxa_desconto/30 * cast( ( d.dt_vencimento_documento - @dt_base_calculo ) as int ) )/100 ))
     end, 
     --as decimal(25,2)),

  --select * from bordero_desconto

   vl_desconto_documento = cast(0.00 as decimal(25,2)),
   vl_iof_desconto       = cast(0.00 as decimal(25,2)),
   vl_custo_desconto     = @vl_taxa_custo_desconto,
   vl_liquido_documento  = cast(0.00 as decimal(25,2)),
   dt_desconto_documento = @dt_base_calculo
  
--select * from documento_receber_desconto
--select * from documento_receber_selecao

 into
   #CalculoDesconto

from
  documento_receber d                      with (nolock) 
  inner join cliente c                     with (nolock) on c.cd_cliente             = d.cd_cliente
  inner join documento_receber_selecao drs with (nolock) on drs.cd_documento_receber = d.cd_documento_receber

where
  isnull(d.vl_saldo_documento,0)>0    and
  d.dt_cancelamento_documento is null and
  d.dt_devolucao_documento    is null and
  d.dt_vencimento_documento >= @dt_base_calculo  and
  d.cd_portador = 999                 --Carteira ( Para depois mudar o Portador )

--select * from #CalculoDesconto

--Calculo do Desconto

update
  #CalculoDesconto

set
  vl_desconto_documento = vl_saldo_documento  - vl_juros_desconto,
  vl_iof_desconto       = (vl_saldo_documento) * ( (@vl_taxa_iof_desconto/30 * qt_dia_desconto)/100) ,
  vl_liquido_documento  = (vl_saldo_documento - vl_juros_desconto ) - 
                          (vl_saldo_documento) * ( (@vl_taxa_iof_desconto/30 * qt_dia_desconto/100)) -
                          vl_custo_desconto

--select * from #CalculoDesconto

--Cálculo do Total do Borderô------------------------------------------------------------------------------------
--select * from bordero_desconto

declare @qt_media_dias_bordero  float
declare @vl_total_bordero       float
declare @vl_juros_bordero       float
declare @vl_iof_bordero         float
declare @vl_custo_bordero       float
declare @qt_documento_bordero   int
declare @vl_liquido_bordero     float

select
  @qt_media_dias_bordero  = sum(qt_dia_desconto)/count(*),
  @vl_total_bordero       = sum(vl_saldo_documento),
  @vl_juros_bordero       = sum(vl_juros_desconto),
  @vl_iof_bordero         = sum(vl_iof_desconto),
  @vl_custo_bordero       = sum(vl_custo_desconto),
  @qt_documento_bordero   = count(*),
  @vl_liquido_bordero     = sum(vl_liquido_documento)
  
from
  #CalculoDesconto


--Gerar o Bordero------------------------------------------------------------------------------------------------

if exists(select top 1 cd_documento_receber from #CalculoDesconto) 
begin

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.Bordero_Desconto' as varchar(80))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_bordero_desconto', @codigo = @cd_bordero_desconto output
	
  while exists(Select top 1 'x' from Bordero_Desconto where cd_bordero_desconto = @cd_bordero_desconto)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_bordero_desconto', @codigo = @cd_bordero_desconto output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_bordero_desconto, 'D'
  end
 
  insert into bordero_desconto
  select
    @cd_bordero_desconto,
    @dt_base_calculo          as dt_bordero_desconto,
    @cd_conta_banco           as cd_conta_banco,
    @qt_media_dias_bordero    as qt_media_dias_bordero,
    @vl_total_bordero         as vl_total_bordero,
    @vl_juros_bordero         as vl_juros_bordero,
    @vl_iof_bordero           as vl_iof_bordero,
    @vl_custo_bordero         as vl_custo_bordero,
    @vl_taxa_bordero_desconto as vl_taxa_bordero,
    @qt_documento_bordero     as qt_documento_bordero,
    @vl_liquido_bordero       as vl_liquido_bordero,
    @cd_usuario               as cd_usuario,
    getdate()                 as dt_usuario

    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_bordero_desconto, 'D'

end

-- select * from bordero_desconto where cd_bordero_desconto = @cd_bordero_desconto

--Atualiza da Tabela de Documento_Receber_Desconto---------------------------------------------------------------

delete from documento_receber_desconto
where
  cd_documento_receber in ( select cd_documento_receber from #CalculoDesconto )


--delete from documento_receber_desconto where cd_bordero_desconto = @cd_bordero_desconto


insert into
  documento_receber_desconto
select
  cd_documento_receber,
  cd_item_desconto,
  dt_desconto_documento,
  @cd_banco                 as cd_banco,
  vl_desconto_documento,
  pc_desconto_documento,
  'Desconto Bordero - '+cast(@cd_bordero_desconto as varchar) as nm_obs_desconto,
  @cd_usuario                as cd_usuario,
  getdate()                  as dt_usuario,
  vl_liquido_documento,
  null                       as cd_plano_financeiro,
  @cd_conta_banco            as cd_conta_banco,
  null                       as cd_lancamento,
  vl_juros_desconto,
  vl_iof_desconto,
  vl_custo_desconto,
  qt_dia_desconto,
  @cd_bordero_desconto       as bordero_desconto

from 
  #CalculoDesconto cd 

--Atualiza o Portador do Documento a Receber

update
  documento_receber
set
  cd_portador = cd.cd_portador
from
  documento_receber d with (nolock) 
  inner join #CalculoDesconto cd on cd.cd_documento_receber = d.cd_documento_receber

where
 cd.cd_portador>0

--Movimentação Bancária------------------------------------------------------------------------------
--select * from conta_banco_lancamento
declare @cd_lancamento int
set @cd_lancamento = 0

  -- Nome da Tabela usada na geração e liberação de códigos
  set @Tabela = cast(DB_NAME()+'.dbo.conta_banco_lancamento' as varchar(80))

  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_lancamento', @codigo = @cd_lancamento output
	
  while exists(Select top 1 'x' from conta_banco_lancamento where cd_lancamento = @cd_lancamento)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_lancamento', @codigo = @cd_lancamento output
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_lancamento, 'D'
  end


--select * from tipo_operacao_financeira

select
  @cd_lancamento            as cd_lancamento,
  c.dt_desconto_documento     as dt_lancamento,
  c.vl_desconto_documento     as vl_lancamento,
  'Desconto Bordero - '+cast(@cd_bordero_desconto as varchar) as nm_historico_lancamento,
  @cd_conta_banco                                             as cd_conta_banco,
  null                                                        as cd_plano_financeiro,
  2                                                           as cd_tipo_operacao,
  null                                                        as cd_historico_financeiro,
  1                                                           as cd_moeda,
  @cd_usuario                                                 as cd_usuario,
  getdate()                                                   as dt_usuario,
  2                                                           as cd_tipo_lancamento_fluxo,
  'N' as ic_lancamento_conciliado,
  'N' as ic_transferencia_conta,
  @cd_empresa                                                 as cd_empresa,
  d.cd_identificacao                                          as cd_documento,
  null as cd_documento_baixa,
  null as cd_lancamento_padrao,
  c.cd_documento_receber                                      as cd_documento_receber,
  null as dt_contabilizacao,
  null as cd_lancamento_contabil,
  null as cd_lote,
  null as cd_conta_credito,
  null as cd_conta_debito,
  null as cd_dac_conta_banco,
  'S'  as ic_fluxo_caixa,
  'N'  as ic_manual_lancamento,
  d.cd_identificacao                                        as nm_compl_lancamento

into
  #conta_banco_lancamento

from
  #CalculoDesconto c
  left outer join documento_receber d on d.cd_documento_receber = c.cd_documento_receber

insert into
  conta_banco_lancamento
select
  *
from
  #conta_banco_lancamento


exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_lancamento, 'D'

drop table #conta_banco_lancamento

--Mostra a Tabela Final

-- select
--   *
-- from
--   #CalculoDesconto
-- 

end

------------------------------------------------------------------------------
--Consulta / Relatório
------------------------------------------------------------------------------

if @ic_parametro = 9
begin

  select
    bd.cd_bordero_desconto,
    bd.dt_bordero_desconto,
    b.nm_banco,
    c.nm_fantasia_cliente,
    c.nm_razao_social_cliente,
--    d.cd_documento_receber,
    d.cd_identificacao,
    d.dt_emissao_documento,
    d.dt_vencimento_documento,
    d.vl_saldo_documento,

    drc.*,
    isnull(cab.vl_taxa_desconto,0)         as vl_taxa_desconto,
    cab.nm_conta_banco,
    cab.cd_contrato_conta_banco

  from  
    documento_receber_desconto drc          with (nolock) 
    inner join documento_receber d          with (nolock) on d.cd_documento_receber = drc.cd_documento_receber
    inner join cliente c                    with (nolock) on c.cd_cliente           = d.cd_cliente
    inner join bordero_desconto bd          with (nolock) on bd.cd_bordero_desconto = drc.cd_bordero_desconto
    left outer join Conta_Agencia_Banco cab with (nolock) on cab.cd_conta_banco     = bd.cd_conta_banco
    left outer join Banco        b          with (nolock) on b.cd_banco             = cab.cd_banco

  where
    drc.cd_bordero_desconto = @cd_bordero_desconto

--select * from documento_receber_desconto where cd_bordero_desconto = 1
--select * from bordero_desconto
--select * from documento_receber_selecao
--select * from conta_agencia_banco

end

