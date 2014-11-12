
-------------------------------------------------------------------------------
--sp_helptext pr_rel_fluxo_caixa_entrada_saida
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta do Fluxo de Caixa por Entrada/Saída
--Data             : 03.03.2008
--Alteração        : 21.10.2008
-- 11.08.2010 - Ajustes Diversos - Carlos Fernandes
--
------------------------------------------------------------------------------
create procedure pr_rel_fluxo_caixa_entrada_saida
@dt_inicial   datetime = '',
@dt_final     datetime = '',
@ic_parametro int = 0,
@cd_usuario   int = 0
as

declare @ic_pagamento_fluxo char(1)
declare @Saldoanterior      float
declare @dt_inicio_mes      datetime

set @SaldoAnterior = 0

--Atualiza o Saldo Anterior

exec dbo.pr_posicao_saldo_banco 
     1,
     @dt_inicial,
     2, 
     @dt_inicial,
     @cd_usuario,
     0,
     'R',
     @vl_retorno_saldo = @SaldoAnterior output

--select @SaldoAnterior


select
  @ic_pagamento_fluxo = isnull(ic_pagamento_fluxo,'N')
from
  Parametro_Financeiro with (nolock) 
where
  cd_empresa = dbo.fn_empresa()

SELECT     
  dr.cd_identificacao, 
  drp.dt_pagamento_documento                         as dt_vencimento_documento, 
  dr.cd_cliente, 
  c.nm_fantasia_cliente, 
  ( isnull(drp.vl_pagamento_documento, 0) ) 

                                                     as vl_documento_receber, 
  p.nm_portador,
  dr.vl_saldo_documento,
  dr.dt_emissao_documento,
  pf.cd_mascara_plano_financeiro,
  pf.nm_conta_plano_financeiro,
  drp.dt_pagamento_documento

into #DocumentoReceberPagamento
FROM         
  Documento_Receber_Pagamento drp with (nolock) left outer join
  Documento_Receber dr            with (nolock) on drp.cd_documento_receber = dr.cd_documento_receber LEFT OUTER JOIN
  Portador p                      with (nolock) on dr.cd_portador = p.cd_portador LEFT OUTER JOIN
  Cliente c                       with (nolock) on dr.cd_cliente = c.cd_cliente        LEFT OUTER JOIN
  Plano_Financeiro pf             with (nolock) on pf.cd_plano_financeiro = dr.cd_plano_financeiro

where
  @ic_pagamento_fluxo = 'S' and
  drp.dt_pagamento_documento between @dt_inicial and @dt_final and
  isnull(dr.cd_lote_receber,0)=0
order by
  drp.dt_pagamento_documento desc

SELECT     
  dr.cd_identificacao, 
  dr.dt_vencimento_documento, 
  dr.cd_cliente, 
  c.nm_fantasia_cliente, 
  case when IsNull(dr.vl_saldo_documento,0)=0 then
       case when @ic_pagamento_fluxo = 'S' 
            then dr.vl_documento_receber
            else 0.00 end
  else
       dr.vl_saldo_documento end        as vl_documento_receber, 
  p.nm_portador,
  dr.vl_saldo_documento,
  dr.dt_emissao_documento,
  pf.cd_mascara_plano_financeiro,
  pf.nm_conta_plano_financeiro,
  null                                  as  dt_pagamento_documento

into #DocumentoReceber

FROM         
  Documento_Receber dr                with (nolock)
  LEFT OUTER JOIN Portador p          with (nolock) on dr.cd_portador = p.cd_portador
  LEFT OUTER JOIN Cliente c           with (nolock) on dr.cd_cliente  = c.cd_cliente
  LEFT OUTER JOIN Plano_Financeiro pf with (nolock) on pf.cd_plano_financeiro = dr.cd_plano_financeiro
  
where
  isnull(dr.cd_lote_receber,0)=0 and
  dbo.fn_dia_util(( dr.dt_vencimento_documento + IsNull(p.qt_credito_efetivo,0) ),'S','U')
  between @dt_inicial and @dt_final and
 ((dr.dt_cancelamento_documento is null) or (dr.dt_cancelamento_documento > @dt_final)) and
 ((dr.dt_devolucao_documento    is null) or (dr.dt_devolucao_documento    > @dt_final)) and
  dr.vl_saldo_documento > 0 and
  dr.cd_documento_receber not in ( select cd_documento_receber from documento_receber_desconto )

order by
  dt_vencimento_documento desc

--deleta os documentos pagos
if @ic_pagamento_fluxo = 'N' 
begin
  delete from #Documento where isnull(vl_saldo_documento,0) = 0
end

--Adiciona os Documentos Pagos
select * into #DocReceber from #DocumentoReceberPagamento

--Todos os Documentos
insert into #DocReceber 
  select * from #DocumentoReceber

SELECT 
  cd_identificacao, 
  dt_vencimento_documento, 
  cd_cliente, 
  nm_fantasia_cliente, 
  sum(IsNull(vl_documento_receber,0)) as vl_documento_receber ,
  nm_portador,
  dt_emissao_documento,
  cd_mascara_plano_financeiro,
  nm_conta_plano_financeiro,
  dt_pagamento_documento
into
  #aux1

from
  #DocReceber
group by
  cd_identificacao, 
  dt_vencimento_documento, 
  cd_cliente, 
  nm_fantasia_cliente, 
  nm_portador,
  dt_emissao_documento,
  cd_mascara_plano_financeiro,
  nm_conta_plano_financeiro,
  dt_pagamento_documento
order by
  dt_vencimento_documento desc

select 
  identity(int,1,1) as Nr,
  (select count(*)  from #DocReceber) as TotalReg,
  (select sum(IsNull(vl_documento_receber,0)) from #DocReceber) as TotalValor,
  a.*
into
  #aux2
from
  #aux1 a
  
SELECT     
  dp.cd_identificacao_document as cd_identificacao, 
  dp.dt_vencimento_documento, 
  IsNull( isnull(dpp.vl_pagamento_documento,0)+
    isnull(dpp.vl_juros_documento_pagar,0)-
    isnull(dpp.vl_desconto_documento,0)-
    isnull(dpp.vl_abatimento_documento,0),0) as vl_documento_pagar,
  case when (isnull(dp.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = dp.cd_empresa_diversa) as varchar(50))
          when (isnull(dp.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_contrato_pagar from contrato_pagar w where w.cd_contrato_pagar = dp.cd_contrato_pagar) as varchar(50))
          when (isnull(dp.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = dp.cd_funcionario) as varchar(50))
           when (isnull(dp.nm_fantasia_fornecedor, '') <> '') then cast((select top 1 o.nm_razao_social from fornecedor o where o.nm_fantasia_fornecedor = dp.nm_fantasia_fornecedor) as varchar(50))  
  end                             as 'nm_favorecido',
  dp.dt_emissao_documento_paga,
  pf.cd_mascara_plano_financeiro,
  pf.nm_conta_plano_financeiro,
 dpp.dt_pagamento_documento

into #DocumentoPagarPagamento

FROM         
  Documento_Pagar_Pagamento dpp       with (nolock) left outer join
  Documento_Pagar dp                  with (nolock) on dp.cd_documento_pagar = dpp.cd_documento_pagar
  left outer join Plano_Financeiro pf with (nolock) on pf.cd_plano_financeiro = dp.cd_plano_financeiro
where
  ( dpp.dt_pagamento_documento between @dt_inicial and @dt_final ) and
  dp.cd_documento_pagar not in ( select cd_documento_pagar from documento_pagar_plano_financ )
order by
 dpp.dt_pagamento_documento desc

SELECT     
  cd_identificacao_document as cd_identificacao, 
  dt_vencimento_documento, 
  isnull(dp.vl_saldo_documento_pagar,0) as vl_documento_pagar,
  case when (isnull(dp.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = dp.cd_empresa_diversa) as varchar(50))
          when (isnull(dp.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_contrato_pagar from contrato_pagar w where w.cd_contrato_pagar = dp.cd_contrato_pagar) as varchar(50))
          when (isnull(dp.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = dp.cd_funcionario) as varchar(50))
           when (isnull(dp.nm_fantasia_fornecedor, '') <> '') then cast((select top 1 o.nm_razao_social from fornecedor o where o.nm_fantasia_fornecedor = dp.nm_fantasia_fornecedor) as varchar(50))  
  end                             as 'nm_favorecido',
  dp.dt_emissao_documento_paga,
  pf.cd_mascara_plano_financeiro,
  pf.nm_conta_plano_financeiro,
  null as dt_pagamento_documento

into #DocumentoPagar

FROM         
  Documento_Pagar dp                  with (nolock) 
  left outer join Plano_Financeiro pf with (nolock) on pf.cd_plano_financeiro = dp.cd_plano_financeiro

where
  ( dbo.fn_dia_util( dp.dt_vencimento_documento,'S','U') between @dt_inicial and @dt_final ) and
  ((dp.dt_cancelamento_documento is null) or (dp.dt_cancelamento_documento > @dt_final)) and
  ((dp.dt_devolucao_documento is null) or (dp.dt_devolucao_documento > @dt_final)) and
  isnull(dp.vl_saldo_documento_pagar,0) > 0 and
  dp.cd_documento_pagar not in ( select cd_documento_pagar from documento_pagar_plano_financ )

order by
 dp.dt_vencimento_documento desc

SELECT     
  cd_identificacao_document as cd_identificacao, 
  dt_vencimento_documento, 
  isnull(dpf.vl_plano_financeiro,0) as vl_documento_pagar,
  case when (isnull(dp.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = dp.cd_empresa_diversa) as varchar(50))
          when (isnull(dp.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_contrato_pagar from contrato_pagar w where w.cd_contrato_pagar = dp.cd_contrato_pagar) as varchar(50))
          when (isnull(dp.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = dp.cd_funcionario) as varchar(50))
           when (isnull(dp.nm_fantasia_fornecedor, '') <> '') then cast((select top 1 o.nm_razao_social from fornecedor o where o.nm_fantasia_fornecedor = dp.nm_fantasia_fornecedor) as varchar(50))  
  end                             as 'nm_favorecido',
  dp.dt_emissao_documento_paga,
  pf.cd_mascara_plano_financeiro,
  pf.nm_conta_plano_financeiro,
  ( select top 1 dt_pagamento_documento from documento_pagar_pagamento where cd_documento_pagar = dpf.cd_documento_pagar ) as dt_pagamento_documento

into #DocumentoPagarRateado

FROM         
  documento_pagar_plano_financ dpf              with (nolock) 
  inner join Documento_Pagar dp                 with (nolock) on dp.cd_documento_pagar  = dpf.cd_documento_pagar
  left outer join Plano_Financeiro pf           with (nolock) on pf.cd_plano_financeiro = dpf.cd_plano_financeiro

where
  ( dbo.fn_dia_util( dp.dt_vencimento_documento,'S','U') between @dt_inicial and @dt_final ) and
  ((dp.dt_cancelamento_documento is null) or (dp.dt_cancelamento_documento > @dt_final)) and
  ((dp.dt_devolucao_documento is null)    or (dp.dt_devolucao_documento > @dt_final)) 
order by
 dp.dt_vencimento_documento desc

select * 
into 
  #DocPagar 
from 
  #DocumentoPagarPagamento

insert into #DocPagar 
  select * from #DocumentoPagar

insert into #DocPagar 
  select * from #DocumentoPagarRateado

select
  cd_identificacao                as cd_identificacao, 
  dt_vencimento_documento, 
  sum(vl_documento_pagar)         as vl_documento_pagar,
  nm_favorecido,
  dt_emissao_documento_paga,
  cd_mascara_plano_financeiro,
  nm_conta_plano_financeiro,
  dt_pagamento_documento
into
  #aux3
from
  #DocPagar
group by
  cd_identificacao, 
  dt_vencimento_documento, 
  nm_favorecido,
  dt_emissao_documento_paga,
  cd_mascara_plano_financeiro,
  nm_conta_plano_financeiro,
  dt_pagamento_documento
order by
 dt_vencimento_documento desc

select
  identity(int,1,1)                 as Nr,
  (select count(*)  from #DocPagar) as TotalReg,
  (select sum(IsNull(vl_documento_pagar,0)) from #DocPagar) as TotalValor,
  a.*
into 
  #aux4
from
  #aux3 a

declare @tamanho1 int 
set @tamanho1 = 0

declare @tamanho2 int 
set @tamanho2 = 0

declare @maior int 
set @maior = 0

set @tamanho1 = (select count(*) from #Aux2)
set @tamanho2 = (select count(*) from #Aux4)

print @tamanho1
print @tamanho2

if @tamanho1 > @tamanho2
  set @maior = @tamanho1
else if @tamanho1 < @tamanho2  
  set @maior = @tamanho2
else
  set @maior = @tamanho2

create table #TabelaFinal (Nr             varchar(100),
                           cd_doc_entrada varchar(21),
                           cliente        varchar(100),
                           venc_entrada   varchar(100),
                           valor_entrada  varchar(100),
                           pagto_entrada  varchar(100),
                           cd_doc_saida   varchar(21),
                           favorecido     varchar(100),
                           venc_saida     varchar(100),
                           valor_saida    varchar(100),
                           pagto_saida    varchar(100))

declare @i int
set @i = 1 

while @i <= @maior
  begin

    insert into #TabelaFinal ( nr,
                               cd_doc_entrada,
                               cliente,
                               venc_entrada,
                               valor_entrada,
                               pagto_entrada,
                               cd_doc_saida,
                               favorecido,
                               venc_saida,
                               valor_saida,
                               pagto_saida)
    values(@i,'','','','','','','','','','')
    set @i = @i + 1  
  end

set @i = 1 

while @i <= @tamanho1
  begin
    update #TabelaFinal -- select convert(varchar,getdate(),103)
      set 
        cd_doc_entrada = isnull(cast((select cd_identificacao        from #aux2 where Nr = @i) as varchar(100)),''),  
        cliente        = isnull(cast((select nm_fantasia_cliente     from #aux2 where Nr = @i) as varchar(100)),''),  
        venc_entrada   = isnull(convert(varchar,(select dt_vencimento_documento from #aux2 where Nr = @i),103),''),  
        valor_entrada  = isnull(CONVERT(varchar, convert(numeric(14,2),round((select vl_documento_receber from #aux2 where Nr = @i),6,2)),103),''),
        pagto_entrada  =  isnull(convert(varchar,(select dt_pagamento_documento from #aux2 where Nr = @i),103),'')

      where
        rtrim(ltrim(cast(Nr as int))) = @i

    set @i = @i + 1  

  end

set @i = 1 

while @i <= @tamanho2
  begin
    update #TabelaFinal 
      set 
        cd_doc_saida =  isnull(cast((select cd_identificacao from #aux4 where Nr = @i) as varchar(100)),''),  
        favorecido   =  isnull(cast((select nm_favorecido from #aux4 where Nr = @i) as varchar(100)),''),  
        venc_saida   =  isnull(convert(varchar,(select dt_vencimento_documento from #aux4 where Nr = @i),103),''),  
        valor_saida  =  isnull(CONVERT(varchar, convert(numeric(14,2),round((select vl_documento_pagar from #aux4 where Nr = @i),6,2)),103),''),
        pagto_saida  =  isnull(convert(varchar,(select dt_pagamento_documento from #aux4 where Nr = @i),103),'')

      where
        rtrim(ltrim(cast(Nr as int))) = @i

    set @i = @i + 1
  end

/*
update #TabelaFinal 
  set 
    venc_entrada = 'Total Receber(+):',
    valor_entrada      = isnull(CONVERT(varchar, convert(numeric(14,2),round((select sum(vl_documento_receber) from #aux2),6,2)),103),'')
  where
    Nr = @maior + 2

update #TabelaFinal 
  set   
    venc_saida  =    'Total Pagar(-):', 
    valor_saida =    isnull(CONVERT(varchar, convert(numeric(14,2),round((select sum(vl_documento_pagar) from #aux4),6,2)),103),'')
  where
    Nr = @maior + 2
*/

declare @Saldo   float
declare @Receber float
declare @Pagar   float
 
set @Saldo   = isnull((select sum(vl_documento_receber) from #aux2),0.00) -
               isnull((select sum(vl_documento_Pagar)   from #aux4),0.00)
set @Receber = isnull((select sum(vl_documento_receber) from #aux2),0.00)
set @Pagar   = isnull((select sum(vl_documento_pagar)   from #aux4),0.00)

/*
update #TabelaFinal 
  set   
    venc_saida  =    'Saldo:', 
    valor_saida =    isnull(CONVERT(varchar, convert(numeric(14,2),round(@Saldo,6,2)),103),'')
  where
    Nr = @maior + 4
*/

if @ic_parametro = 0
    select * from #TabelaFinal
else
    select
      @Saldo   + isnull(@SaldoAnterior,0) as 'Saldo',
      @Receber                            as 'Receber',
      @Pagar                              as 'Pagar' 

--print @maior

drop table #DocumentoReceberPagamento
drop table #DocumentoReceber
drop table #aux1
drop table #aux2 
drop table #DocumentoPagarPagamento
drop table #DocumentoPagar
drop table #DocPagar
drop table #DocumentoPagarRateado
drop table #TabelaFinal

