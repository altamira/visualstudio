
CREATE PROCEDURE pr_emitir_cheque_pagar
--------------------------------------------------------------------------------------------------------------- 
--GBS - Global Business Solution              2002 
--------------------------------------------------------------------------------------------------------------- 
--Stored Procedure : Microsoft SQL Server       2000 
--Autor(es)        :   Daniel C. Neto 
--Banco de Dados   : EGISSQL 
--Objetivo         : Selecionar dados para a emissão do Cheque a Pagar.
--Data             : 31/03/2003
--Alterações       : 13.04.2007 - Verificação e Acertos Diversos - Carlos Fernandes
--                 : 23.04.2007 - Acerto do Valor Monetário do Cheque - Carlos Fernandes
-- 20.11.2009 - Ajustes Diversos para emitir o verso do Cheque - Carlos Fernandes
-- 17.12.2009 - Ponto - Carlos Fernandes
----------------------------------------------------------------------------------------------------------------- 

@ic_parametro            int           = 1,
@cd_cheque_pagar         varchar(8000) = '',
@vl_cheque_pagar         float         = 0.00,
@vl_cheque_extenso       Varchar(200)  = '',
@dt_emissao_cheque_pagar datetime      = '',
@nm_favorecido           varchar(60)   = '',
@nm_filtro               varchar(500)  = ''

AS 

---------------------------------------------------------
if @ic_parametro = 1 -- Impressão Cheque Avulso
---------------------------------------------------------
begin

SELECT top 1

  '#('+ltrim(rtrim(cast(cast(@vl_cheque_pagar as money) as varchar)))+')#'   as 'Valor',
  replicate('.', 8) + '('+ltrim(rtrim(@vl_cheque_extenso))+')'               as 'ValorExtenso' ,
  day(@dt_emissao_cheque_pagar)                                              as 'Dia',
  m.nm_mes                                                                   as 'Mes',
  year(@dt_emissao_cheque_pagar)                                             as 'Ano',
  '('+ltrim(rtrim(@nm_favorecido))+')'                                       as 'Favorecido',
  cid.nm_cidade                                                              as 'Local',
  '.'                                                                        as 'Ponto'

FROM
   Cheque_Pagar p with (nolock) 
   left outer join
           Mes m with (nolock) on m.cd_mes = month(@dt_emissao_cheque_pagar)
   left outer join
           EGISADMIN.dbo.Empresa e with (nolock) on e.cd_empresa = dbo.fn_empresa() 
   left outer join
           Cidade cid with (nolock) on cid.cd_pais   = e.cd_pais   and
                                       cid.cd_estado = e.cd_estado and
                                       cid.cd_cidade = e.cd_cidade

--WHERE       cd_cheque_pagar = @cd_cheque_pagar

end


-------------------------------------------------------
if @ic_parametro <> 9  -- Impressão Cheques Contínuos
-------------------------------------------------------
begin

  declare @SQL varchar(8000)
  
set @SQL = 
   ' SELECT  identity(int,1,1) as cd_chave, ' + 
   ' 0 as Sel, ' +
   ' cp.cd_cheque_pagar, ' + 
   ' cp.dt_emissao_cheque_pagar, cp.cd_agencia_banco, cab.cd_banco, ' + 
   ' cp.vl_cheque_pagar,  dt_liquidacao_cheque, dt_impressao_cheque_pagar, ' + 
   ' cp.ic_baixado_cheque_pagar, cp.nm_favorecido, cab.nm_conta_banco, ' + 
   ' ( select count(*) from Documento_Pagar_Pagamento x with (nolock) ' + 
   '   where x.cd_identifica_documento = cast(cp.cd_cheque_pagar as varchar(20)) and ' + 
		'	x.cd_tipo_pagamento = 2 and x.cd_conta_banco = cp.cd_conta_banco ' + 
	     ' group by x.cd_identifica_documento ) as qtddoc' + 
   ' into #Doc ' + 
   ' FROM     Cheque_Pagar  cp with (nolock) left outer join ' + 
            ' Conta_Agencia_Banco cab on cab.cd_conta_banco = cp.cd_conta_banco ' + 
   case when @nm_filtro <> '' then
      ' where ' + @nm_filtro 
   else
      ''
   end
   + 
   ' order by dt_emissao_cheque_pagar ' 
  
  set @SQl = @SQL + 
    ' select ' + 
--     '''#('' as MI,'+
--     ''')#'' as MF,'+
    '''#(''+ltrim(rtrim(cast(cast(cp.vl_cheque_pagar as decimal(25,2)) as varchar) ))+'')#''     as Valor, ' + 
    '''(''+ltrim(rtrim(dbo.fn_valor_extenso(cp.vl_cheque_pagar)))+'')'' as ValorExtenso , ' + 
    'rtrim(ltrim(cast(substring(ltrim(rtrim(dbo.fn_valor_extenso(cp.vl_cheque_pagar))),1,50) as varchar(50)))) as ValorExtenso1 , ' + 
    'rtrim(ltrim(cast(substring(ltrim(rtrim(dbo.fn_valor_extenso(cp.vl_cheque_pagar))),51,50) as varchar(50)))) as ValorExtenso2 , ' + 
    ' day(cp.dt_emissao_cheque_pagar) as Dia, ' + 
    ' m.nm_mes as Mes, ' + 
    ' year(cp.dt_emissao_cheque_pagar) as Ano, ' + 
    '''(''+cp.nm_favorecido+'')'' as Favorecido, ' + 
    ' rtrim(ltrim(cid.nm_cidade)) as Local, ' + 
    ' cp.vl_cheque_pagar, ' +
    '''.'''+'                                                             as Ponto' +
    ' FROM       #Doc cp left outer join ' + 
               ' Mes m on m.cd_mes = month(cp.dt_emissao_cheque_pagar) left outer join ' + 
               ' EGISADMIN.dbo.Empresa e on e.cd_empresa = dbo.fn_empresa() left outer join ' + 
               ' Cidade cid on cid.cd_pais = e.cd_pais and '     + 
                             ' cid.cd_estado = e.cd_estado and ' + 
                             ' cid.cd_cidade = e.cd_cidade '     + 
    --Comentado em 20.11.2009
    --' where cd_chave in ( ' + @cd_cheque_pagar + ')'
    ' where cd_cheque_pagar in ( ' + @cd_cheque_pagar + ')'


print (@SQL) 

exec (@SQL) 

end

---------------------------------------------------------------
--Verso do Cheque
----------------------------------------------------------------

if @ic_parametro = 9
begin
  if @cd_cheque_pagar > 0
  begin
  --select * from cheque_pagar
  --select * from documento_pagar where cd_cheque_pagar>0

  select
     d.cd_identificacao_document  as Documento,
     d.dt_emissao_documento_paga  as Emissao,
     d.dt_vencimento_documento    as Vencimento,
     isnull(m.sg_moeda,'R$')      as SiglaMoeda,
     d.vl_documento_pagar         as ValorDocumento,
     d.nm_observacao_documento    as Observacao,

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
    Documento_pagar d with (nolock) 
    left outer join Moeda m with (nolock) on m.cd_moeda = d.cd_moeda
  where
    cd_cheque_pagar = @cd_cheque_pagar 
     

  end

end

