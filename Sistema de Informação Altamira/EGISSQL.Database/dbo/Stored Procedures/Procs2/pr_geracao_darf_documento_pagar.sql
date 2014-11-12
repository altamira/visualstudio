
-------------------------------------------------------------------------------
--pr_geracao_darf_documento_pagar
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Seleciona os documentos a pagar para a geração de DARF.
--Data             : 01.03.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_geracao_darf_documento_pagar
@dt_inicial datetime,
@dt_final   datetime,
@cd_selecao  int
 
as

declare @nm_empresa      varchar(40)
declare @cd_fone_empresa varchar(18)
declare @cd_cnpj_empresa varchar(18)

--select * from empresa

select
  @nm_empresa      = nm_empresa,
  @cd_cnpj_empresa = cd_cgc_empresa,
  @cd_fone_empresa = cd_telefone_empresa
from
  egisadmin.dbo.Empresa
where
  cd_empresa       = dbo.fn_empresa()

select
  0                              as Selecionado,
  d.cd_documento_pagar,
  d.cd_identificacao_document    as Documento,
  i.nm_imposto                   as imposto,
  d.dt_emissao_documento_paga    as Emissao,
  d.dt_vencimento_documento      as Vencimento,
  d.vl_documento_pagar           as Valor,
  isnull(dc.sg_darf_codigo,'')   as CodigoDarf,
  cast( ' ' as varchar(16) )     as Periodo, 
  cast( ' ' as varchar(15) )     as Referencia,
  d.vl_multa_documento           as Multa,
  d.vl_juros_documento           as Juros,
  isnull(d.vl_saldo_documento_pagar,0) + 
  isnull(d.vl_multa_documento,0) + 
  isnull(d.vl_juros_documento,0)   as ValorTotal,

  --Favorecido
  case when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.sg_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(30))  
       when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_fantasia_fornecedor from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(30))  
       when (isnull(d.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(30))  
       when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast(d.nm_fantasia_fornecedor as varchar(30))  
   end                             as 'cd_favorecido',                 
   case when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(50))  
        when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_contrato_pagar from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(50))  
        when (isnull(d.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(50))  
        when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast((select top 1 o.nm_razao_social from fornecedor o where o.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(50))    
   end                             as 'Favorecido',     
  
   @nm_empresa                    as Empresa,
   @cd_cnpj_empresa               as Cnpj,
   @cd_fone_empresa               as Fone,
   d.cd_darf_automatico           as codigodarf1
         

from
  documento_pagar d
  left outer join imposto i      on i.cd_imposto = d.cd_imposto
  left outer join darf_codigo dc on dc.cd_darf_codigo = i.cd_darf_codigo
where
  d.dt_emissao_documento_paga between @dt_inicial and @dt_final and
  isnull(d.cd_imposto,0)>0                                 and
  isnull(i.ic_geracao_darf_imposto,'N')='S'                and
  isnull(d.vl_saldo_documento_pagar,0)>0 and
  cd_selecao =@cd_selecao
    

