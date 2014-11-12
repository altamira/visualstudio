
-------------------------------------------------------------------------------
--sp_helptext pr_emitir_verso_cheque_pagar
-------------------------------------------------------------------------------
--pr_emitir_verso_cheque_pagar
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Emitir informações no Verso do Cheque a Pagar
--
--Data             : 11.11.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_emitir_verso_cheque_pagar
@cd_cheque_pagar int = 0
as


if @cd_cheque_pagar > 0
begin
  --select * from cheque_pagar
  --select * from documento_pagar where cd_cheque_pagar>0
  select
     d.cd_identificacao_document  as Documento,
     d.dt_emissao_documento_paga  as Emissao,
     d.dt_vencimento_documento    as Vencimento,

  --Falta o Nome do Fornecedor
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then   
          cast((select top 1 z.sg_empresa_diversa   
             from empresa_diversa z with (nolock)   
                where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(30))  
             
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then   
              cast((select top 1 w.nm_fantasia_fornecedor   
                from contrato_pagar w   with (nolock)   
                  where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(30))  
  
           when (isnull(d.cd_funcionario, 0) <> 0) then   
              cast((select top 1 k.nm_funcionario   
                 from funcionario k with (nolock)     
                   where k.cd_funcionario = d.cd_funcionario) as varchar(30))  
  
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then   
              cast(d.nm_fantasia_fornecedor as varchar(30))  
      end                             as 'nm_favorecido',  
  
  
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then d.cd_empresa_diversa  
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then d.cd_contrato_pagar  
           when (isnull(d.cd_funcionario, 0) <> 0) then d.cd_funcionario  
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then d.cd_fornecedor  
      end                             as 'cd_favorecido_chave',  
  
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then 'E'  
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then 'C'  
           when (isnull(d.cd_funcionario, 0) <> 0) then 'U'  
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then 'F'   
      end                             as 'ic_tipo_favorecido',  

      cast(case when isnull(d.cd_favorecido_empresa,0)=0
      then 
         ''
      else
        ( select top 1 fe.nm_favorecido_empresa 
          from 
             favorecido_empresa fe with (nolock) 
          where
             fe.cd_empresa_diversa        = d.cd_empresa_diversa and 
             fe.cd_favorecido_empresa_div = d.cd_favorecido_empresa )
      end as varchar(30))             as 'nm_favorecido_empresa'



  from
    Documento_pagar d 
  where
    cd_cheque_pagar = @cd_cheque_pagar 
     

end


