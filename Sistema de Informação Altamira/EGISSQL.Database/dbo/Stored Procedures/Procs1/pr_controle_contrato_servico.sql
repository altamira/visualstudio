
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
--pr_controle_contrato_servico
---------------------------------------------------------
--GBS - Global Business Solution	             2002
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Daniel C. Neto.
--Banco de Dados	: EGISSQL
--Objetivo		: Controlar Contratos de Serviço no Período.
--Data			: 07/04/2004
---------------------------------------------------

CREATE PROCEDURE pr_controle_contrato_servico

@ic_parametro         int, 
@cd_referencia        varchar(20),
@dt_inicial           datetime,
@dt_final             datetime,
@cd_contrato_servico  int = 0

AS

-------------------------------------------------------------------------
if @ic_parametro = 1 -- Seleção de Contratos de Serviço no Período.
-------------------------------------------------------------------------
begin

SELECT 
  cs.cd_contrato_servico,
  cs.cd_ref_contrato_servico, 
  sc.nm_status_contrato, 
  c.nm_fantasia_cliente, 
  cs.dt_contrato_servico, 
  cs.vl_contrato_servico,  
  cs.dt_base_reajuste_contrato, 
  tr.nm_tipo_reajuste, 
  ir.nm_indice_reajuste,
  s.nm_servico,
  cs.cd_cliente,
  cs.dt_ini_contrato_servico,
  cs.dt_final_contrato_servico,
  v.nm_fantasia_vendedor,
  case when cast(cs.dt_base_reajuste_contrato -  (GetDate()-1) as int) < 0 then
   1 else 0 end as 'ic_atraso',    
  case when cs.dt_cancelamento_contrato is null then 0 else 1 end as 'ic_cancelado',

  case when ( select top 1 'x' 
              from Contrato_Servico_Reajuste x
              where x.cd_contrato_servico = cs.cd_contrato_servico ) is null then
  0 else 1 end as 'ic_reajuste',

  case when ( select top 1 'x' 
              from Contrato_Servico_Composicao csc
              where csc.cd_contrato_servico = cs.cd_contrato_servico and
                    IsNull(csc.cd_pedido_venda,0) <> 0 ) is null then 
  0 else 1 end as 'ic_pedido_venda',

  case when ( select top 1 'x' 
              from Contrato_Servico_Composicao csc
              where csc.cd_contrato_servico = cs.cd_contrato_servico and
                    IsNull(csc.cd_nota_saida,0) <> 0 ) is null then
  0 else 1 end as 'ic_nota_saida',

  case when ( select 'x' 
              from Contrato_Servico_Composicao csc inner join
                   Documento_Receber dr on dr.cd_nota_saida = csc.cd_nota_saida 
              where cast(str(dr.vl_saldo_documento,25,2) as decimal(25,2)) = 0 and 
                    csc.cd_contrato_servico = cs.cd_contrato_servico ) is null then
  0 else 1 end as 'ic_recebido'


FROM         
  Contrato_Servico cs left outer join
  Status_Contrato sc ON cs.cd_status_contrato = sc.cd_status_contrato left outer join
  Cliente c ON cs.cd_cliente = c.cd_cliente left outer join
  Tipo_Reajuste tr on tr.cd_tipo_reajuste = cs.cd_tipo_reajuste left outer join
  Servico s ON cs.cd_servico = s.cd_servico left outer join
  Indice_Reajuste ir on ir.cd_indice_reajuste = cs.cd_indice_reajuste left outer join
  Vendedor v on v.cd_vendedor = cs.cd_vendedor
where
   ( cs.dt_contrato_servico between @dt_inicial and @dt_final and
     @cd_referencia = '#!$' ) or
   ( cs.cd_ref_contrato_servico like @cd_referencia + '%')
   

end

---------------------------------------------------------
else -- Seleção da Composição selecionada.
---------------------------------------------------------
begin

  declare @vl_total float

  set @vl_total = ( select 
                      sum(vl_parc_contrato_servico) 
                    from 
                      Contrato_Servico_Composicao
                    where
                      cd_contrato_servico = @cd_contrato_servico)

select
   0 as Sel, *, @vl_total as 'vl_total'
from
  Contrato_Servico_Composicao
where
  cd_contrato_servico = @cd_contrato_servico
order by 
  cd_item_contrato_servico


end


