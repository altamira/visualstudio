-- use egissql
-- go

CREATE PROCEDURE pr_consulta_documento_pagar  
------------------------------------------------------------------------  
--pr_consulta_documento_pagar  
------------------------------------------------------------------------  
--GBS - Global Business Solution Ltda                               2004  
------------------------------------------------------------------------  
--Stored Procedure      : Microsoft SQL Server 2000         
--Autor(es)             : Carlos Cardoso Fernandes  
--Banco de Dados        : EGISSQL  
--Objetivo              : Fazer consultas de Duplicatas a Pagar.  
--Data                  : 15/12/2004 - Inclusão de parâmetros e possibilidade de consultas individuais - Daniel C. Neto.  
--Atualização           : 07/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso  
--                      : 12.02.2005 - Inclusão da Loja na Consulta - Carlos Fernandes  
--                      : 23/02/2005 - Acerto para evitar duplicação. - Daniel C. NEto.  
--                      : 29/04/2005 - Comentado trecho de código na sessão 7 que estava filtrando indevidamente - ELIAS  
--                      : 11.07.2005 - Novos Atributos  
--                      : 26.07.2005 - Retirado o comentario feito pelo elias. - Rafael Santiago   
--                      : 17.09.2005 - Filtro quando utilizado pela manutenção pela data de Vencimento do Documento Desc  
--                                     Carlos Fernandes  
--                      : 07.12.2005 - Ordem de Vencimento descendig - Carlos Fernandes  
--                      : 20.12.2005 - Consulta da Observação do Documento - Carlos Fernandes  
--                      : 01.03.2006 - Ajuste dos parâmetros - Carlos/Danilo
--                      : 29.03.2006 - Correção do Parâmetro 8, tipo de conta com left outer join - Carlos Fernandes
--                      : 30.03.2006 - Correção para Checar apenas as Cfops´s que geram Contas a pagar - Carlos Fernandes
--                      : 03.04.2006 - Incluído o Flag para controloar o tipo de consulta - Carlos Fernandes
--                                   - Aberto / Pagos / Todos 
--                      : 15.07.2006 - Cancelamento do Documento na Grid e no filtro de Todos - Carlos Fernandes
--                      : 04.10.2006 - Consulta de Documento em Aberto por Portador, parametro 9 
--                      : 02.01.2007 - Parâmetro 7 - Relatório em Aberto, ordem de data e valor desc - Carlos Fernandes
--                      : 04.01.2007 - Parâmetro 7 - Relatório em Aberto, Data REM - Anderson
--                      : 05.01.2007 - Parâmetro 7 - Relatório em Aberto, Data REM - Anderson - Correção para notas com 2 CFOP
--                      : 07.03.2007 - Parâmetro 7 - Adicionando Situação do Documento
--                      : 09.04.2007 - Parametro 7 - Adição de um Case para ordenar a consulta ASC ou DESC - Anderson
--                      : 24.04.2007 - Acerto da Data de Entrada da Nota na Consulta - Carlos Fernandes.
--                      : 19.05.2007 - Consulta de Documento, foi colocado o Número da AP - Carlos Fernandes.
--                      : 26.05.2007 - Data da Aprovação da AP - Carlos Fernandes
--                      : 18.07.2007 - Máscara do Plano Financeiro - Carlos Fernades 
--                      : 28.10.2007 - Valor da Multa - Carlos Fernandes
-- 24.05.2008 - Imposto na Grid / Dados do Favorecido - Carlos Fernandes 
-- 21.10.2008 - Ajuste do Código do Favorecido da Empresa Diversa - Carlos Fernandes
-- 06.11.2008 - CNPJ e Razão Social - Carlos Fernandes
-- 28.03.2009 - Documento Pagos - Carlos Fernandes
-- 22.07.2009 - Novo Campo Agência/Conta/Banco na Consulta documentos pagos - Carlos Fernandes
-- 06.11.2009 - Ajuste dos Campos p/ Consulta p/ Vencimento - Carlos Fernandes
-- 08.12.2009 - Novo Campo referência - Carlos Fernandes
-- 19.12.2010 - Razão Social quando temos empresa diversas - Carlos Fernandes
-- 27.03.2010 - Verificar a Duplicidade - Carlos Fernandes
-- 31.05.2010 - Tipo de Destinatário - Carlos Fernandes
-- 08.07.2010 - Label do Tipo de Destinatario - Carlos Fernandes
-- 25.09.2010 - Novas Colunas na Consulta - Status/Dia - Carlos Fernandes
-- 14.10.2010 - Novos Campos para Consulta de Documentos pagos (5) - Carlos Fernandes/Fagner
-- 25.11.2010 - Verificação de Documentos Pagos - Carlos Fernandes
-------------------------------------------------------------------------------------------------------------------------  
  
@ic_parametro              int,  
@dt_inicial                datetime,  
@dt_final                  datetime,  
@cd_favorecido             varchar(30) = '',  
@cd_tipo_conta_pagar       int         = 0,  
@ic_filtrar_favorecido     char(1)     = 'N',  
@cd_tipo_favorecido        char(10)    = '',  
@cd_identificacao          varchar(50) = '',  
@ic_tipo_consulta          char(1)     = 'A',
@cd_portador               int         = 0,
@cd_plano_financeiro       int         = 0,
@cd_centro_custo           int         = 0,
@ic_ordem_documento        char(1)     = 'A', -- Utilizado no parametro 7 para ordernar ASC or DESC
@cd_favorecido_empresa_div int         = 0

AS  

--select * from favorecido_empresa

declare @ic_rateio int

  set @ic_rateio = dbo.fn_ver_uso_custom('RATEIO')


declare @dt_hoje datetime

set @dt_hoje = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)
  
-------------------------------------------------------------------------------  
if @ic_parametro = 1   -- consulta de duplicatas em aberto  
-------------------------------------------------------------------------------  
  begin  
    select  
--      distinct  
      d.dt_vencimento_documento,  
      c.sg_tipo_conta_pagar,  
      case when (isnull(d.cd_empresa_diversa, 0)      <> 0)  then cast((select top 1 z.sg_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(30))  
           when (isnull(d.cd_contrato_pagar, 0)       <> 0)  then cast((select top 1 w.nm_fantasia_fornecedor from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(30))  
           when (isnull(d.cd_funcionario, 0)          <> 0)  then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(30))  
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast(d.nm_fantasia_fornecedor as varchar(30))  
      end                             as 'cd_favorecido',                 
      case when (isnull(d.cd_empresa_diversa, 0)      <> 0)  then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(50))  
           when (isnull(d.cd_contrato_pagar, 0)       <> 0)  then cast((select top 1 w.nm_contrato_pagar from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(50))  
           when (isnull(d.cd_funcionario, 0)          <> 0)  then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(50))  
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast((select top 1 o.nm_razao_social from fornecedor o where o.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(50))    
      end                             as 'nm_favorecido',     

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
      end as varchar(30))             as 'nm_favorecido_empresa',
   
      d.cd_documento_pagar,   
      d.cd_identificacao_document,  

      case when max(d.dt_cancelamento_documento) is null 
      then
        cast(str(d.vl_saldo_documento_pagar,25,2) as decimal(25,2)) 
      else
        0.00
      end                                             as 'vl_saldo_documento_pagar',  

--      cast(str(d.vl_saldo_documento_pagar,25,2) as decimal(25,2)) as 'vl_saldo_documento_pagar',  

      d.nm_observacao_documento,  
      d.dt_emissao_documento_paga,  
      case when exists(select * from documento_pagar_pagamento p where p.cd_documento_pagar = d.cd_documento_pagar and p.cd_tipo_pagamento = 1) then   
           (select top 1 p.cd_identifica_documento from documento_pagar_pagamento p where p.cd_documento_pagar = d.cd_documento_pagar and p.cd_tipo_pagamento = 1) else null end as 'cd_bordero',   

      case when e.dt_receb_nota_entrada is null then  
        d.dt_emissao_documento_paga  
      else   
        e.dt_receb_nota_entrada end as 'dt_recebimento',  
       
       pf.cd_mascara_plano_financeiro,
       pf.nm_conta_plano_financeiro,  
       l.nm_fantasia_loja,  
       d.vl_juros_documento,  
       d.vl_abatimento_documento,  
       d.vl_desconto_documento,
       isnull(pt.nm_portador,'Sem Portador')   as nm_portador,
       dcc.pc_centro_custo,
       dcc.vl_centro_custo, 
       dpf.pc_plano_financeiro, 
       dpf.vl_plano_financeiro,
       cc.nm_centro_custo,
       d.vl_multa_documento,
       d.nm_ref_documento_pagar

    from   
      documento_pagar d                   with (nolock)        
      left outer join  Tipo_Conta_pagar c with (nolock) on d.cd_tipo_conta_pagar = c.cd_tipo_conta_pagar
      left outer join  Nota_Entrada e     with (nolock) on d.cd_nota_fiscal_entrada = cast(e.cd_nota_entrada as varchar) and  
                                             d.cd_fornecedor = e.cd_fornecedor and  
                                             d.cd_serie_nota_fiscal = e.cd_serie_nota_fiscal 
      left outer join  Documento_Pagar_Pagamento p with (nolock) on p.cd_documento_pagar = d.cd_documento_pagar
      left outer join  
      Bordero b on cast(b.cd_bordero as varchar) = p.cd_identifica_documento and p.cd_tipo_pagamento = 1
      left outer join  
      Loja l on l.cd_loja = d.cd_loja  
      left join
      Portador pt on (pt.cd_portador = d.cd_portador) 
      left outer join
      Documento_pagar_centro_custo dcc on case when @ic_rateio = 0 then 0 else dcc.cd_documento_pagar end = d.cd_documento_pagar left outer join
      Documento_pagar_plano_financ dpf on case when @ic_rateio = 0 then 0 else dpf.cd_documento_pagar end = d.cd_documento_pagar left outer join
      centro_custo cc                  on cc.cd_centro_custo = IsNull(dcc.cd_centro_custo,d.cd_centro_custo) left outer join
      Plano_Financeiro pf              on pf.cd_plano_financeiro = IsNull(dpf.cd_plano_financeiro , d.cd_plano_financeiro )

    where  
      d.dt_vencimento_documento between @dt_inicial and @dt_final and   
      d.dt_cancelamento_documento is null and  
      cast(str(d.vl_saldo_documento_pagar,25,2) as decimal(25,2)) > 0 and  
      b.cd_bordero is null         and 
      isnull(d.cd_portador,0) = (case isnull(@cd_portador,0) 
				 when 0 then isnull(d.cd_portador,0)
				 else isnull(@cd_portador,0) end) and
      IsNull(IsNull(dpf.cd_plano_financeiro , d.cd_plano_financeiro ),0) = ( case when IsNull(@cd_plano_financeiro,0) = 0 then
									IsNull(IsNull(dpf.cd_plano_financeiro , d.cd_plano_financeiro ),0) else
 								    @cd_plano_financeiro end ) and
      IsNull(IsNull(dcc.cd_centro_custo,d.cd_centro_custo),0) = ( case when IsNull(@cd_centro_custo,0) = 0 then
							  IsNull(IsNull(dcc.cd_centro_custo,d.cd_centro_custo),0) else
							  @cd_centro_custo end ) 
  
   group by
      	d.dt_vencimento_documento,  
      	c.sg_tipo_conta_pagar,
      	d.cd_documento_pagar,
      	d.cd_identificacao_document,
      	d.nm_observacao_documento,  
      	d.dt_emissao_documento_paga,  
        pf.cd_mascara_plano_financeiro,
      	pf.nm_conta_plano_financeiro,
       	l.nm_fantasia_loja,
       	d.vl_juros_documento,
       	d.vl_abatimento_documento,
       	d.vl_desconto_documento,
 	pt.nm_portador,
	d.cd_empresa_diversa,
        d.cd_favorecido_empresa,
	d.cd_contrato_pagar,
	d.cd_funcionario,
	d.nm_fantasia_fornecedor,
	d.vl_saldo_documento_pagar,
	e.dt_receb_nota_entrada,
        dcc.pc_centro_custo,
        dcc.vl_centro_custo, 
        dpf.pc_plano_financeiro, 
        dpf.vl_plano_financeiro,
        cc.nm_centro_custo,
        d.vl_multa_documento,
        d.nm_ref_documento_pagar


    order by  
     (case when @cd_portador >= 0 then pt.nm_portador end),
      d.dt_vencimento_documento,-- desc,  
      d.vl_saldo_documento_pagar desc       
  
  end  
  
-------------------------------------------------------------------------------  
else if @ic_parametro = 2     -- documentos p/ vencimento (consulta geral)  
-------------------------------------------------------------------------------  
  begin  
    select  
      distinct  
      d.dt_vencimento_documento,  
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.sg_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(30))  
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_fantasia_fornecedor from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(30))  
           when (isnull(d.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(30))  
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast(d.nm_fantasia_fornecedor as varchar(30))  
      end                             as 'cd_favorecido',   
        case when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(50))  
             when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_fantasia_fornecedor from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(50))  
             when (isnull(d.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(50))  
             when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast(d.nm_fantasia_fornecedor as varchar(50))  
        end                             as 'nm_favorecido',                 

      cast(case when isnull(d.cd_favorecido_empresa,0)=0
      then 
         ''
      else
        ( select top 1 fe.nm_favorecido_empresa 
          from 
             favorecido_empresa fe 
          where
             fe.cd_empresa_diversa        = d.cd_empresa_diversa and 
             fe.cd_favorecido_empresa_div = d.cd_favorecido_empresa )
      end as varchar(30))             as 'nm_favorecido_empresa',

      t.sg_tipo_conta_pagar,  
      d.cd_documento_pagar,   
      d.cd_identificacao_document,  

      case when ( d.dt_cancelamento_documento is null or d.dt_devolucao_documento is null )
      then
        cast(str(d.vl_saldo_documento_pagar,25,2) as decimal(25,2)) 
      else
        0.00
      end                                             as 'vl_saldo_documento_pagar',  

--      cast(str(d.vl_saldo_documento_pagar,25,2) as decimal(25,2)) as 'vl_saldo_documento_pagar',  

      isnull(d.vl_documento_pagar,0)                 as vl_documento_pagar,
  
      case when p.dt_pagamento_documento is not null then   
        ((p.vl_pagamento_documento) +  
        (p.vl_juros_documento_pagar) -  
        (p.vl_desconto_documento) -  
        (p.vl_abatimento_documento))  
      else  
        (d.vl_documento_pagar  
         + isnull(d.vl_juros_documento,0) 
         - isnull(d.vl_abatimento_documento,0)
         - isnull(d.vl_desconto_documento,0))  
      end                       as 'vl_pagamento_documento',  

      p.dt_pagamento_documento  as 'dt_pagamento',   
      c.sg_tipo_pagamento,  
      p.cd_identifica_documento,  
      d.nm_observacao_documento,  
      d.dt_emissao_documento_paga,  
      case when e.dt_receb_nota_entrada is null then  
        d.dt_emissao_documento_paga  
      else   
        e.dt_receb_nota_entrada end                   as 'dt_recebimento',  

      pf.cd_mascara_plano_financeiro,
      pf.nm_conta_plano_financeiro                    as 'PlanoFinanceiro',  
      l.nm_fantasia_loja,  
      case when isnull(p.vl_juros_documento_pagar,0)>0 then
        p.vl_juros_documento_pagar
      else
        d.vl_juros_documento                          
      end                                             as vl_juros_documento,  
      case when isnull(p.vl_desconto_documento,0)>0 then
        p.vl_desconto_documento
      else
        d.vl_desconto_documento                       
      end                                             as vl_desconto_documento,
      case when isnull(p.vl_abatimento_documento,0)>0 then
        p.vl_abatimento_documento
      else
        d.vl_abatimento_documento
      end                                             as vl_abatimento_documento,
        
 
--      d.vl_juros_documento,  
--      d.vl_abatimento_documento,  
--      d.vl_desconto_documento , 
      pt.nm_portador,
      dcc.pc_centro_custo,
      dcc.vl_centro_custo, 
      dpf.pc_plano_financeiro, 
      dpf.vl_plano_financeiro,
      cc.nm_centro_custo,
      d.vl_multa_documento,
      d.nm_ref_documento_pagar

  
    from  
      documento_pagar d with (nolock)
      left outer join tipo_conta_pagar t on t.cd_tipo_conta_pagar = d.cd_tipo_conta_pagar 
      left outer join 
      Nota_Entrada e on        d.cd_nota_fiscal_entrada = cast(e.cd_nota_entrada as varchar) and  
			       d.cd_fornecedor = e.cd_fornecedor and  
			       d.cd_serie_nota_fiscal = e.cd_serie_nota_fiscal left outer join 
      documento_pagar_pagamento p on d.cd_documento_pagar = p.cd_documento_pagar left outer join 
      tipo_pagamento_documento c  on  p.cd_tipo_pagamento = c.cd_tipo_pagamento left outer join 
      Loja l                      on l.cd_loja = d.cd_loja left outer join 
      operacao_fiscal opf         on opf.cd_operacao_fiscal=e.cd_operacao_fiscal left join
      Portador pt                 on (pt.cd_portador = d.cd_portador) left outer join
      Documento_pagar_centro_custo dcc on case when @ic_rateio = 0 then 0 else dcc.cd_documento_pagar end = d.cd_documento_pagar left outer join
      Documento_pagar_plano_financ dpf on case when @ic_rateio = 0 then 0 else dpf.cd_documento_pagar end = d.cd_documento_pagar left outer join
      centro_custo cc             on cc.cd_centro_custo = IsNull(dcc.cd_centro_custo,d.cd_centro_custo) left outer join
      Plano_Financeiro pf         on pf.cd_plano_financeiro = IsNull(dpf.cd_plano_financeiro , d.cd_plano_financeiro )
    where    
      d.dt_vencimento_documento between @dt_inicial and @dt_final and    
      d.dt_cancelamento_documento is null and
      'S' = case when e.cd_nota_entrada>0 then isnull(opf.ic_comercial_operacao,'N') else 'S' end and
      IsNull(IsNull(dpf.cd_plano_financeiro , d.cd_plano_financeiro ),0) = ( case when IsNull(@cd_plano_financeiro,0) = 0 then
									IsNull(IsNull(dpf.cd_plano_financeiro , d.cd_plano_financeiro ),0) else
 								    @cd_plano_financeiro end ) and
      IsNull(IsNull(dcc.cd_centro_custo,d.cd_centro_custo),0) = ( case when IsNull(@cd_centro_custo,0) = 0 then
							  IsNull(IsNull(dcc.cd_centro_custo,d.cd_centro_custo),0) else
							  @cd_centro_custo end ) 

    order by  
      d.dt_vencimento_documento desc,  
      d.nm_favorecido,  
      d.cd_identificacao_document        

    end   
  
-------------------------------------------------------------------------------  
else if @ic_parametro = 3  -- documentos p/ vencimento (consulta p/ Favorecido)  
-------------------------------------------------------------------------------  
  begin  
  
    select  
      distinct  
      d.cd_documento_pagar,  
      d.cd_identificacao_document,  
      d.dt_vencimento_documento,  
      d.vl_documento_pagar,  
      p.dt_pagamento_documento,  
      p.cd_tipo_pagamento,  
      p.cd_identifica_documento,  
      d.cd_tipo_conta_pagar,  
      d.nm_observacao_documento,  
      d.dt_emissao_documento_paga,  
      p.dt_pagamento_documento as 'dt_recebimento',  
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.sg_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(30))  
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_fantasia_fornecedor from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(30))  
           when (isnull(d.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(30))  
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast(d.nm_fantasia_fornecedor as varchar(30))  
      end                             as 'cd_favorecido',                 
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(50))  
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_contrato_pagar from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(50))  
           when (isnull(d.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(50))  
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast((select top 1 o.nm_razao_social from fornecedor o where o.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(50))    
      end                             as 'nm_favorecido',  
      pf.cd_mascara_plano_financeiro,
      pf.nm_conta_plano_financeiro                  as 'PlanoFinanceiro',  
      l.nm_fantasia_loja,  
      d.vl_juros_documento,  
      d.vl_abatimento_documento,  
      d.vl_desconto_documento,  
      pt.nm_portador,
      d.vl_multa_documento,
      d.nm_ref_documento_pagar


    from  
      documento_pagar d                           with (nolock)  
      left outer join Documento_Pagar_Pagamento p on p.cd_documento_pagar  = d.cd_documento_pagar  
      left outer join Plano_Financeiro pf         on d.cd_plano_financeiro = pf.cd_plano_financeiro  
      left outer join Loja l                      on l.cd_loja             = d.cd_loja  
      left outer join Portador pt                 on (pt.cd_portador = d.cd_portador)
    where  
      d.dt_vencimento_documento between @dt_inicial and @dt_final  and  
      d.dt_cancelamento_documento is null and  
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast(d.cd_empresa_diversa as varchar(30))  
           when (isnull(d.cd_contrato_pagar, 0)  <> 0) then cast(d.cd_contrato_pagar as varchar(30))  
           when (isnull(d.cd_funcionario, 0)     <> 0) then cast(d.cd_funcionario as varchar(30))  
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast(d.nm_fantasia_fornecedor as varchar(30))  
      end like @cd_favorecido+'%'   
    order by  
      d.dt_vencimento_documento desc, d.cd_tipo_conta_pagar, cd_favorecido, d.cd_identificacao_document  
  end  
-------------------------------------------------------------------------------  
else if @ic_parametro = 4  -- documentos p/ vencimento (consulta p/ Tipo de Conta)  
-------------------------------------------------------------------------------  
  begin  
    select  
      distinct  
      d.cd_documento_pagar,   
      d.dt_vencimento_documento,  
      d.cd_tipo_conta_pagar,  
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.sg_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(30))  
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_fantasia_fornecedor from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(30))  
           when (isnull(d.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(30))  
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast(d.nm_fantasia_fornecedor as varchar(30))  
      end                             as 'cd_favorecido',                 
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(50))  
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_contrato_pagar from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(50))  
           when (isnull(d.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(50))  
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast((select top 1 o.nm_razao_social from fornecedor o where o.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(50))    
      end                             as 'nm_favorecido',     

      cast(case when isnull(d.cd_favorecido_empresa,0)=0
      then 
         ''
      else
        ( select top 1 fe.nm_favorecido_empresa 
          from 
             favorecido_empresa fe 
          where
             fe.cd_empresa_diversa        = d.cd_empresa_diversa and 
             fe.cd_favorecido_empresa_div = d.cd_favorecido_empresa )
      end as varchar(30))             as 'nm_favorecido_empresa',

      d.cd_identificacao_document,  

      --cast(str(d.vl_saldo_documento_pagar,25,2) as decimal(25,2)) as 'vl_saldo_documento_pagar',  

      case when d.dt_cancelamento_documento is null 
      then
        cast(str(d.vl_saldo_documento_pagar,25,2) as decimal(25,2)) 
      else
        0.00
      end                                             as 'vl_saldo_documento_pagar',  


      d.vl_documento_pagar - isnull((select   
                                       (isnull(sum(p.vl_desconto_documento),0) +  
                                        isnull(sum(p.vl_abatimento_documento),0)) -  
                                        isnull(sum(p.vl_juros_documento_pagar),0)  
                                     from   
                                       documento_pagar_pagamento p  with (nolock) 
                                     where   
                                       p.cd_documento_pagar = d.cd_documento_pagar), 0) as 'vl_documento_pagar',  
      p.dt_pagamento_documento,  
      p.cd_tipo_pagamento,  
      p.cd_identifica_documento,  
      d.nm_observacao_documento,  
      d.dt_emissao_documento_paga,  

      case when e.dt_receb_nota_entrada is null then  
        d.dt_emissao_documento_paga  
      else   
        e.dt_receb_nota_entrada end        as 'dt_recebimento',  

      c.sg_tipo_conta_pagar,  
      pf.cd_mascara_plano_financeiro,
      pf.nm_conta_plano_financeiro         as 'PlanoFinanceiro',  
      l.nm_fantasia_loja,  
      d.vl_juros_documento,  
      d.vl_abatimento_documento,  
      d.vl_desconto_documento,  
      pt.nm_portador,
      dcc.pc_centro_custo,
      dcc.vl_centro_custo, 
      dpf.pc_plano_financeiro, 
      dpf.vl_plano_financeiro,
      cc.nm_centro_custo,
      nm_tipo_pagamento,
      d.vl_multa_documento,
      d.nm_ref_documento_pagar


    from  
      documento_pagar d           with (nolock) left outer join  
      documento_pagar_pagamento p with (nolock) on p.cd_documento_pagar = d.cd_documento_pagar left outer join  
      Nota_Entrada e              with (nolock) on  d.cd_nota_fiscal_entrada = cast(e.cd_nota_entrada as varchar) and  
       		         d.cd_fornecedor = e.cd_fornecedor and  
			 d.cd_serie_nota_fiscal = e.cd_serie_nota_fiscal left outer join  
      Fornecedor f                with (nolock) on  e.cd_fornecedor=f.cd_fornecedor and  
		         isnull(d.cd_serie_nota_fiscal_entr,'') = isnull(e.cd_serie_nota_fiscal,'') and  
		         d.nm_fantasia_fornecedor = f.nm_fantasia_fornecedor left outer join  
      Tipo_conta_pagar c               on c.cd_tipo_conta_pagar = d.cd_tipo_conta_pagar left outer join  
      Loja l                           on l.cd_loja = d.cd_loja  left join
      Portador pt                      on (pt.cd_portador = d.cd_portador) left outer join
      Documento_pagar_centro_custo dcc on case when @ic_rateio = 0 then 0 else dcc.cd_documento_pagar end = d.cd_documento_pagar left outer join
      Documento_pagar_plano_financ dpf on case when @ic_rateio = 0 then 0 else dpf.cd_documento_pagar end = d.cd_documento_pagar left outer join
      centro_custo cc                  on cc.cd_centro_custo = IsNull(dcc.cd_centro_custo,d.cd_centro_custo) left outer join
      Plano_Financeiro pf              on pf.cd_plano_financeiro = IsNull(dpf.cd_plano_financeiro , d.cd_plano_financeiro ) left outer join
      Tipo_Pagamento_Documento tp      on tp.cd_tipo_pagamento = p.cd_tipo_pagamento

  
    where  
      d.dt_vencimento_documento between @dt_inicial and @dt_final and   
      d.dt_cancelamento_documento is null and       
      ((d.cd_tipo_conta_pagar = @cd_tipo_conta_pagar) or (@cd_tipo_conta_pagar = 0)) and
      IsNull(IsNull(dpf.cd_plano_financeiro , d.cd_plano_financeiro ),0) = ( case when IsNull(@cd_plano_financeiro,0) = 0 then
									IsNUll(IsNull(dpf.cd_plano_financeiro , d.cd_plano_financeiro ),0) else
 								    @cd_plano_financeiro end ) and
      IsNull(IsNull(dcc.cd_centro_custo,d.cd_centro_custo),0) = ( case when IsNull(@cd_centro_custo,0) = 0 then
							  IsNull(IsNull(dcc.cd_centro_custo,d.cd_centro_custo),0) else
							  @cd_centro_custo end ) 

    order by  
      d.dt_vencimento_documento desc, d.cd_tipo_conta_pagar, cd_favorecido, d.cd_identificacao_document              

  end  
-------------------------------------------------------------------------------  
else if @ic_parametro = 5    -- documentos p/ pagamento  
-------------------------------------------------------------------------------  
  begin  
  
    select  
--      distinct  
      p.dt_pagamento_documento,  

      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.sg_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(30))  
           when (isnull(d.cd_contrato_pagar, 0) <> 0)  then cast((select top 1 w.nm_fantasia_fornecedor from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(30))  
           when (isnull(d.cd_funcionario, 0) <> 0)     then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(30))  
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast(d.nm_fantasia_fornecedor as varchar(30))  
      end                             as 'cd_favorecido',                 
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(50))  
           when (isnull(d.cd_contrato_pagar, 0) <> 0)  then cast((select top 1 w.nm_contrato_pagar from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(50))  
           when (isnull(d.cd_funcionario, 0) <> 0)     then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(50))  
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast((select top 1 o.nm_razao_social from fornecedor o where o.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(50))    
      end                             as 'nm_favorecido',     
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
      end as varchar(30))             as 'nm_favorecido_empresa',

      t.sg_tipo_conta_pagar,  
      d.cd_identificacao_document,  
      pg.sg_tipo_pagamento,  
      p.cd_identifica_documento,  
      p.vl_pagamento_documento,  
      p.vl_juros_documento_pagar,  
      p.vl_desconto_documento,  
      p.vl_abatimento_documento,  
      tcp.ic_tipo_bordero,  

      case when isnull(pg.ic_zera_tipo_pagamento,'N') = 'N'
      then
        (p.vl_pagamento_documento +  
         isnull(p.vl_juros_documento_pagar,0) -  
         isnull(p.vl_desconto_documento,0) -  
         isnull(p.vl_abatimento_documento,0))
      else
         0.00
      end                  as 'vl_total',  

      d.dt_emissao_documento_paga,  
  
      case when e.dt_receb_nota_entrada is null then  
        d.dt_emissao_documento_paga  
      else   
        e.dt_receb_nota_entrada end as 'dt_recebimento',  
  
      pf.cd_mascara_plano_financeiro,
      pf.nm_conta_plano_financeiro,  
      l.nm_fantasia_loja,
      isnull(pt.nm_portador, 'Sem Portador') as nm_portador,
      dcc.pc_centro_custo,
      dcc.vl_centro_custo, 
      dpf.pc_plano_financeiro, 
      dpf.vl_plano_financeiro,
      cc.nm_centro_custo,
      d.dt_vencimento_documento,
      d.vl_multa_documento,
      isnull(pg.ic_zera_tipo_pagamento,'N') as ic_zera_tipo_pagamento,
      max(cab.nm_conta_banco)               as nm_conta_banco,
      max(b.cd_numero_banco)                as cd_numero_banco,
      max(ag.cd_numero_agencia_banco)       as cd_numero_agencia,
      max(p.nm_obs_documento_pagar)         as nm_obs_documento_pagar
      

--select * from documento_pagar_pagamento (cd_conta_banco )
--select * from conta
--select * from conta_agencia_banco
--select * from banco
--select * from agencia_banco

    from  
      documento_pagar d                           with (nolock) 
      left outer join documento_pagar_pagamento p with (nolock) on p.cd_documento_pagar     = d.cd_documento_pagar 
      left outer join tipo_conta_pagar t          with (nolock) on t.cd_tipo_conta_pagar    = d.cd_tipo_conta_pagar
      left outer join tipo_pagamento_documento pg with (nolock) on pg.cd_tipo_pagamento     = p.cd_tipo_pagamento 
      left outer join Nota_Entrada e              with (nolock) on d.cd_nota_fiscal_entrada = cast(e.cd_nota_entrada as varchar) and  
                                                                   d.cd_fornecedor          = e.cd_fornecedor and  
                                                                   d.cd_serie_nota_fiscal = e.cd_serie_nota_fiscal
      left outer join Tipo_Conta_Pagar tcp        with (nolock) on d.cd_tipo_conta_pagar = tcp.cd_tipo_conta_pagar 
      left outer join Loja l                      with (nolock) on l.cd_loja = d.cd_loja  
      left outer join Portador pt                 with (nolock) on (pt.cd_portador = d.cd_portador) 
      left outer join Documento_pagar_centro_custo dcc on case when @ic_rateio = 0 then 0 else dcc.cd_documento_pagar end = d.cd_documento_pagar 
      left outer join Documento_pagar_plano_financ dpf on case when @ic_rateio = 0 then 0 else dpf.cd_documento_pagar end = d.cd_documento_pagar 
      left outer join centro_custo cc             with (nolock) on cc.cd_centro_custo      = IsNull(dcc.cd_centro_custo,d.cd_centro_custo) 
      left outer join Plano_Financeiro pf         with (nolock) on pf.cd_plano_financeiro = IsNull(dpf.cd_plano_financeiro , d.cd_plano_financeiro )
      left outer join Conta_Agencia_Banco cab     with (nolock) on cab.cd_conta_banco  = p.cd_conta_banco
      left outer join Banco b                     with (nolock) on b.cd_banco          = cab.cd_banco
      left outer join Agencia_Banco ag            with (nolock) on ag.cd_agencia_banco = cab.cd_agencia_banco

     where  
      isnull(d.cd_documento_pagar,0)>0    and
      d.dt_cancelamento_documento is null and  
      p.dt_pagamento_documento between @dt_inicial and @dt_final  and
      isnull(d.cd_portador,0) = (case isnull(@cd_portador,0) 
				 when 0 then 
					isnull(d.cd_portador,0)
			      	 else 
					isnull(@cd_portador,0) 
				 end) and
      IsNull(IsNull(dpf.cd_plano_financeiro , d.cd_plano_financeiro ),0) = ( case when IsNull(@cd_plano_financeiro,0) = 0 then
									IsNull(IsNull(dpf.cd_plano_financeiro , d.cd_plano_financeiro ),0) else
 								    @cd_plano_financeiro end ) and
      IsNull(IsNull(dcc.cd_centro_custo,d.cd_centro_custo),0) = ( case when IsNull(@cd_centro_custo,0) = 0 then
							  Isnull(IsNull(dcc.cd_centro_custo,d.cd_centro_custo),0) else
							  @cd_centro_custo end ) 
	 GROUP BY
      d.cd_empresa_diversa,
      d.cd_favorecido_empresa,
      d.cd_contrato_pagar,
      d.cd_funcionario,
      d.nm_fantasia_fornecedor,
      t.sg_tipo_conta_pagar,
      d.cd_identificacao_document,
      pg.sg_tipo_pagamento,
      p.cd_identifica_documento,
      p.cd_item_pagamento,
      p.vl_pagamento_documento,
      p.vl_juros_documento_pagar,
      p.vl_desconto_documento,
      p.vl_abatimento_documento,
      tcp.ic_tipo_bordero,
      d.dt_emissao_documento_paga,
      e.dt_receb_nota_entrada,
      pf.cd_mascara_plano_financeiro,
      pf.nm_conta_plano_financeiro,
      l.nm_fantasia_loja,
      p.dt_pagamento_documento,
      pt.nm_portador,
      dcc.pc_centro_custo,
      dcc.vl_centro_custo, 
      dpf.pc_plano_financeiro, 
      dpf.vl_plano_financeiro,
      cc.nm_centro_custo,
      d.dt_vencimento_documento,
      d.vl_multa_documento,
      pg.ic_zera_tipo_pagamento

    order by   
      (case when @cd_portador >= 0 then pt.nm_portador  end),
	p.dt_pagamento_documento desc ,  
        vl_total desc

--select * from tipo_pagamento_documento

end  

-------------------------------------------------------------------------------  
else if @ic_parametro = 6    -- total do valor e saldo dos documentos em aberto  
-------------------------------------------------------------------------------  
  begin  
  
    select  
      isnull(sum(cast(vl_documento_pagar as numeric(25,2))),0)                 as 'vl_total_documento_pagar',  
      isnull(sum(cast(str(vl_saldo_documento_pagar,25,2) as decimal(25,2))),0) as 'vl_total_saldo_documento'  
    from  
      Documento_pagar  with (nolock)  
    where   
      dt_cancelamento_documento is null and  
      dt_vencimento_documento between @dt_inicial and @dt_final and   
      cast(str(vl_saldo_documento_pagar,25,2) as decimal(25,2)) <> 0  
  
  end  

-------------------------------------------------------------------------------  
else if @ic_parametro = 7 --lista os documentos em aberto p/ janela de consulta  
-------------------------------------------------------------------------------  
  begin  

--    SELECT @ic_tipo_consulta
-- SELECT @ic_filtrar_favorecido
-- select * from fornecedor_adiantamento

    select  
      0                                                       as 'Selecionado',  
      d.cd_documento_pagar,  

      case when isnull(d.vl_saldo_documento_pagar,0) > 0 then
       case when d.dt_vencimento_documento<@dt_hoje then
         'Vencido'
       else
         'Aberto'
       end
      else
        'Baixado'
      end                                                     as 'nm_status',

      case when isnull(d.vl_saldo_documento_pagar,0) > 0 then
         cast(@dt_hoje - d.dt_vencimento_documento as int )
      else
        0
      end                                                     as  'qt_dia',
      d.dt_vencimento_documento,  
      c.nm_tipo_conta_pagar,  

      --select * from empresa_diversa

      cast(
      case when (isnull(d.cd_empresa_diversa, 0) <> 0)
      then   
         case when isnull(z.sg_empresa_diversa,'')<>'' 
         then
            z.sg_empresa_diversa
         else 
            z.nm_empresa_diversa
         end
      else    
         case when (isnull(d.cd_contrato_pagar, 0) <> 0) 
         then   
             w.nm_fantasia_fornecedor   
         else  
            case when (isnull(d.cd_funcionario, 0) <> 0) 
            then   
               k.nm_funcionario   
            else
              case when (isnull(d.nm_fantasia_fornecedor, '') <> '') or isnull(d.cd_tipo_destinatario,0)<>0 
              then   
                 case when isnull(d.cd_tipo_destinatario,0)=1 then
                   vw.nm_fantasia
                 else
                   d.nm_fantasia_fornecedor 
                 end
              else
                 ''
              end
            end
         end
      end  
      as varchar(30))                             as 'cd_favorecido',  
    
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then d.cd_empresa_diversa  
           when (isnull(d.cd_contrato_pagar, 0)  <> 0) then d.cd_contrato_pagar  
           when (isnull(d.cd_funcionario, 0)     <> 0) then d.cd_funcionario  
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then d.cd_fornecedor  
      end                                         as 'cd_favorecido_chave',  
  
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then 'E'  
           when (isnull(d.cd_contrato_pagar, 0) <> 0)  then 'C'  
           when (isnull(d.cd_funcionario, 0) <> 0)     then 'U'  
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
      end as varchar(30))             as 'nm_favorecido_empresa',

      d.cd_favorecido_empresa,
      d.cd_identificacao_document,  
      d.dt_emissao_documento_paga,  
      isnull(d.vl_documento_pagar,0)                 as vl_documento_pagar,  

      case when d.dt_cancelamento_documento is null 
      then
        cast(str(d.vl_saldo_documento_pagar,25,2) as decimal(25,2)) 
      else
        0.00
      end                                             as 'vl_saldo_documento_pagar',  

      t.nm_tipo_documento,  
      pf.cd_plano_financeiro,  
      pf.cd_mascara_plano_financeiro,
      pf.nm_conta_plano_financeiro,  
      m.sg_moeda,  
      l.nm_fantasia_loja,  
      i.nm_invoice,  
      d.vl_documento_pagar_moeda,  
      u.nm_fantasia_usuario,  
      d.vl_juros_documento,  
      d.vl_abatimento_documento,  
      d.vl_desconto_documento,  
      d.nm_observacao_documento,
      d.dt_cancelamento_documento,
      d.nm_cancelamento_documento,  
      pt.nm_portador,

      --Busca Data de Entrada da Nota Fiscal 
      --Carlos 27.04.2007

      ( Select Top 1
          ne.dt_receb_nota_entrada 
        from
          Nota_Entrada ne with (nolock)           
        Where
          cast(d.cd_nota_fiscal_entrada as int) = ne.cd_nota_entrada and
          d.cd_fornecedor                       = ne.cd_fornecedor   and
          d.cd_serie_nota_fiscal                = ne.cd_serie_nota_fiscal ) as dt_rem,
 
--       ( Select Top 1
--           isnull(ner.dt_rem,ne.dt_receb_nota_entrada) 
--         from
--           Nota_Entrada_Parcela nep
-- 
--           left outer join Nota_Entrada_Registro ner on cast(d.cd_nota_fiscal_entrada as int ) = ner.cd_nota_entrada and
--                                                        d.cd_fornecedor = ner.cd_fornecedor and
--                                                        nep.cd_serie_nota_fiscal = ner.cd_serie_nota_fiscal
-- 
--           left outer join Nota_Entrada ne           on cast(d.cd_nota_fiscal_entrada as int) = ne.cd_nota_entrada and
--                                                        d.cd_fornecedor          = ne.cd_fornecedor   and
--                                                        d.cd_serie_nota_fiscal   = ne.cd_serie_nota_fiscal
-- 
--         Where
--           d.cd_documento_pagar = nep.cd_documento_pagar
--       )                              as dt_rem,

      d.cd_moeda,
      sd.nm_situacao_documento,
      d.cd_portador,
      d.cd_tipo_conta_pagar,
      d.cd_ap,
      ap.dt_aprovacao_ap,    
      d.cd_cheque_pagar,

      --select * from fornecedor_adiantamento

      isnull(( select
          sum ( isnull(vl_adto_fornecedor,0) ) 
        from 
          fornecedor_adiantamento fa with (nolock) 
        where
          fa.cd_fornecedor = d.cd_fornecedor and            
          fa.dt_baixa_adto_fornecedor is null ),0) as TotalAdiantamento,

      d.vl_multa_documento,
      ip.nm_imposto,
      d.nm_complemento_documento,
      cc.nm_centro_custo,

      --Fornecedor
--       case when fo.cd_tipo_pessoa = 1 then
--         dbo.fn_Formata_Mascara('99.999.999/9999-99', fo.cd_cnpj_fornecedor)  
--       else
--         dbo.fn_Formata_Mascara('999.999.999-99',
--                          fo.cd_cnpj_fornecedor)  
--       end                   as cd_cnpj,

      case when vw.cd_tipo_pessoa = 1 then
        dbo.fn_Formata_Mascara('99.999.999/9999-99', vw.cd_cnpj)  
      else
        dbo.fn_Formata_Mascara('999.999.999-99',
                         vw.cd_cnpj)  
      end                   as cd_cnpj,

      --Razão Social
      --fo.nm_razao_social    as nm_razao_social,
      case when (isnull(d.cd_empresa_diversa, 0) <> 0)
      then   
         z.nm_empresa_diversa
      else    
         case when (isnull(d.cd_contrato_pagar, 0) <> 0) 
         then   
             w.nm_fantasia_fornecedor   
         else  
            case when (isnull(d.cd_funcionario, 0) <> 0) 
            then   
               k.nm_funcionario   
            else
              case when (isnull(d.nm_fantasia_fornecedor, '') <> '') or isnull(d.cd_tipo_destinatario,0)<>0 
              then   
                 case when isnull(d.cd_tipo_destinatario,0)=1 then
                   vw.nm_razao_social
                 else
                   fo.nm_razao_social
                 end
              else
                 ''
              end
            end
         end
      end                           as 'nm_razao_social',  

--select * from vw_destinatario

      d.cd_pedido_importacao,
      d.nm_ref_documento_pagar,
      d.cd_tipo_destinatario,
      case when isnull(d.cd_tipo_destinatario,0)>0 then  
        td.nm_tipo_destinatario
      else
        case when (isnull(d.cd_empresa_diversa, 0) <> 0) then 'Empresa Diversa'  
             when (isnull(d.cd_contrato_pagar,  0) <> 0) then 'Contrato'  
             when (isnull(d.cd_funcionario,     0) <> 0) then 'Funcionário'  
        end

      end                            as 'nm_tipo_destinatario'


    --select * from fornecedor

    into
      #DocumentoPagar

    from  
      Documento_Pagar d                           with (nolock) 
      left outer join Fornecedor fo               with (nolock) on fo.cd_fornecedor         = d.cd_fornecedor 
      left outer join Fornecedor_Contato f        with (nolock) on d.cd_fornecedor          = f.cd_fornecedor and
                                                                   f.cd_contato_fornecedor  = 1   
      left outer join Tipo_conta_pagar c          with (nolock) on c.cd_tipo_conta_pagar    = d.cd_tipo_conta_pagar   
      left outer join Tipo_documento t            with (nolock) on t.cd_tipo_documento      = d.cd_tipo_documento   
      left outer join Plano_Financeiro pf         with (nolock) on pf.cd_plano_financeiro   = d.cd_plano_financeiro   
      left outer join Moeda m                     with (nolock) on d.cd_moeda               = m.cd_moeda  
      left outer join Loja l                      with (nolock) on l.cd_loja                = d.cd_loja   
      left outer join invoice i                   with (nolock) on i.cd_invoice             = d.cd_invoice  
      left outer join EgisAdmin.dbo.Usuario u     with (nolock) on d.cd_usuario             = u.cd_usuario  
      left outer join Portador pt                 with (nolock) on pt.cd_portador           = d.cd_portador
      left outer join situacao_documento_pagar sd with (nolock) on sd.cd_situacao_documento = d.cd_situacao_documento
      left outer join Autorizacao_Pagamento ap    with (nolock) on ap.cd_ap                 = d.cd_ap
      left outer join Imposto ip                  with (nolock) on ip.cd_imposto            = d.cd_imposto
      left outer join Centro_Custo cc             with (nolock) on cc.cd_centro_custo       = d.cd_centro_custo

      left outer join Empresa_Diversa z           with (nolock) on z.cd_empresa_diversa     = d.cd_empresa_diversa
      left outer join Funcionario     k           with (nolock) on k.cd_funcionario         = d.cd_funcionario
      left outer join Contrato_Pagar  w           with (nolock) on w.cd_contrato_pagar      = d.cd_contrato_pagar

      left outer join vw_destinatario vw          with (nolock) on vw.cd_tipo_destinatario  = isnull(d.cd_tipo_destinatario,2) and
                                                                   vw.cd_destinatario       = d.cd_fornecedor
           
      left outer join Tipo_Destinatario td        with (nolock) on td.cd_tipo_destinatario  = case when isnull(d.cd_tipo_destinatario,0)>0 
                                                                                              then
                                                                                                d.cd_tipo_destinatario
                                                                                              else
                                                                                                vw.cd_tipo_destinatario
                                                                                              end

      -- Anderson Corrigindo a duplicidade da selecao da nota_entrada_parcela quando tem 2 CFOP na nota de entrada
      --       left outer join Nota_Entrada_Parcela nep  on d.cd_documento_pagar = nep.cd_documento_pagar
      --       left outer join Nota_Entrada_Registro ner on d.cd_nota_fiscal_entrada = ner.cd_nota_entrada and
      --                                                    d.cd_fornecedor = ner.cd_fornecedor and
      --                                                    nep.cd_serie_nota_fiscal = ner.cd_serie_nota_fiscal

--select * from documento_pagar

    where  

      --Carlos  
      --Anterior a 17.09.2005  
      --       IsNull(d.dt_vencimento_documento,'') between (case when @ic_filtrar_favorecido = 'S' then  
      --                                           IsNull(d.dt_vencimento_documento,'') else  
      --                                           @dt_inicial end ) and   
      --                                         (case when @ic_filtrar_favorecido = 'S' then  
      --                                           IsNull(d.dt_vencimento_documento,'') else  
      --                                           @dt_final end )   
  
      --Carlos 17.09.2005  
      --Atual e Correto é filtrar por vencimento  

      IsNull(d.dt_vencimento_documento,'') between @dt_inicial and @dt_final   
                                               
      and   
      IsNull(dt_cancelamento_documento,'') = (case when (@ic_filtrar_favorecido = 'S' or @ic_tipo_consulta = 'T' ) then  
                                                    IsNull(dt_cancelamento_documento,'') else  
                                                     '' end )  
      and   

      --Saldo do Documento

--       IsNull(cast(str(vl_saldo_documento_pagar,25,2) as decimal(25,2)),0) <> 
-- 
--          (case when @ic_filtrar_favorecido = 'S' 
--                then IsNull(cast(str(vl_saldo_documento_pagar,25,2) as decimal(25,2)),0) + 1
--                else 
--                     case when @ic_tipo_consulta = 'A' then 0 else 1.001 end
--                end )  

      IsNull(cast(str(vl_saldo_documento_pagar,25,2) as decimal(25,2)),0) = 
      case when @ic_tipo_consulta = 'P'
      then
        0.00
      else
        case when @ic_tipo_consulta = 'T' then
           IsNull(cast(str(vl_saldo_documento_pagar,25,2) as decimal(25,2)),0)
        else
         (case when @ic_filtrar_favorecido = 'S' 
               then
                 IsNull(cast(str(vl_saldo_documento_pagar,25,2) as decimal(25,2)),0) 
               else        
                 case when @ic_tipo_consulta = 'A'
                 then
                   case when IsNull(cast(str(vl_saldo_documento_pagar,25,2) as decimal(25,2)),0)>0
                   then
                     IsNull(cast(str(vl_saldo_documento_pagar,25,2) as decimal(25,2)),0)
                   else
                     -1.001
                   end
                 end
               end )  
        end 

      end   
  
      -- Quando é chamado pela tela de cadastro de documentos a pagar, não pode trazer documentos relacionados a borderô  
      -- quando é chamado pela tela de manutenção de documentos, chamará a todo momento.  

      and   
      not exists ( select top 1 'x'  
                       from  
                         Documento_Pagar x           with (nolock) inner join  
                         Documento_Pagar_Pagamento p with (nolock) on x.cd_documento_pagar = p.cd_documento_pagar inner join  
                         Bordero b on cast(b.cd_bordero as varchar) = p.cd_identifica_documento and p.cd_tipo_pagamento = 1   
                       where  
                         x.cd_documento_pagar = (case when @ic_filtrar_favorecido = 'S'
                                                      then 0 
                                                      else d.cd_documento_pagar end ) )  

      and   
  
      IsNull(case when (isnull(d.cd_empresa_diversa, 0) <> 0) and IsNull(@cd_tipo_favorecido,'') <> ''    then 'E'  
               when (isnull(d.cd_contrato_pagar, 0) <> 0)     and IsNull(@cd_tipo_favorecido,'') <> ''    then 'C'  
               when (isnull(d.cd_funcionario, 0) <> 0)        and IsNull(@cd_tipo_favorecido,'') <> ''    then 'F'  
               when (isnull(d.nm_fantasia_fornecedor, '') <> '') and IsNull(@cd_tipo_favorecido,'') <> '' then 'FO'  
               when @ic_filtrar_favorecido = 'N' then ''  
             end,'') = IsNull(@cd_tipo_favorecido,'')   

       and   
  
       IsNull(case when (isnull(d.cd_empresa_diversa, 0) <> 0)       and IsNull(@cd_tipo_favorecido,'') <> '' then cast(d.cd_empresa_diversa as varchar(30))  
                   when (isnull(d.cd_contrato_pagar, 0)  <> 0)       and IsNull(@cd_tipo_favorecido,'') <> '' then cast(d.cd_contrato_pagar  as varchar(30))  
                   when (isnull(d.cd_funcionario,    0)  <> 0)       and IsNull(@cd_tipo_favorecido,'') <> '' then cast(d.cd_funcionario     as varchar(30))  
                   when (isnull(d.nm_fantasia_fornecedor, '') <> '') and IsNull(@cd_tipo_favorecido,'') <> '' then cast(d.cd_fornecedor      as varchar(30))  
                   when @ic_filtrar_favorecido = 'N' then ''  
               end,'') = IsNull(@cd_favorecido,'') 

      and  
  
      IsNull(d.cd_identificacao_document,'') like IsNull(@cd_identificacao,'') + '%'  and
      isnull(d.cd_portador,0) = (case when isnull(@cd_portador,0) = 0 or (isnull(@cd_portador,0) =  -1) then isnull(d.cd_portador,0) else isnull(@cd_portador,0) end)

    if isnull(@ic_ordem_documento, 'A' )='A'
    begin
 
      select 
        *
      from
        #DocumentoPagar  
      order by  
        case when (@cd_portador = -1) or (@cd_portador > 0) then cd_portador end ,
        dt_vencimento_documento asc,
        vl_documento_pagar      desc,  
        cd_tipo_conta_pagar,  
        cd_favorecido,  
        cd_identificacao_document

    end
    else
    begin

      select 
        *
      from
        #DocumentoPagar  
      order by  
        case when (@cd_portador = -1) or (@cd_portador > 0) then cd_portador end ,
        dt_vencimento_documento desc,
        vl_documento_pagar      desc,  
        cd_tipo_conta_pagar,  
        cd_favorecido,  
        cd_identificacao_document

    end

  end  

-------------------------------------------------------------------------------  
else if @ic_parametro = 8     -- documentos p/ vencimento (relatório)  
-------------------------------------------------------------------------------  
  begin  
    select  
      distinct  
      d.dt_vencimento_documento,  
      case when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.sg_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(30))  
           when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_fantasia_fornecedor from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(30))  
           when (isnull(d.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(30))  
           when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast(d.nm_fantasia_fornecedor as varchar(30))  
      end                             as 'cd_favorecido',   
        case when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(50))  
             when (isnull(d.cd_contrato_pagar, 0) <> 0) then cast((select top 1 w.nm_fantasia_fornecedor from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar) as varchar(50))  
             when (isnull(d.cd_funcionario, 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(50))  
             when (isnull(d.nm_fantasia_fornecedor, '') <> '') then cast(d.nm_fantasia_fornecedor as varchar(50))  
        end                             as 'nm_favorecido',                 
      t.sg_tipo_conta_pagar,  
      d.cd_documento_pagar,   
      d.cd_identificacao_document,  
--      cast(str(d.vl_saldo_documento_pagar,25,2) as decimal(25,2)) as 'vl_saldo_documento_pagar',  

      case when d.dt_cancelamento_documento is null 
      then
        cast(str(d.vl_saldo_documento_pagar,25,2) as decimal(25,2)) 
      else
        0.00
      end                                             as 'vl_saldo_documento_pagar',  

      case when p.dt_pagamento_documento is not null then   
        ((p.vl_pagamento_documento) +  
        (p.vl_juros_documento_pagar) -  
        (p.vl_desconto_documento) -  
        (p.vl_abatimento_documento))  
      else  
        --d.vl_documento_pagar  
        (d.vl_documento_pagar  
         + isnull(d.vl_juros_documento,0) 
         - isnull(d.vl_abatimento_documento,0)
         - isnull(d.vl_desconto_documento,0))  

      end                       as 'vl_documento_pagar',  
      p.dt_pagamento_documento  as 'dt_pagamento',   
      c.sg_tipo_pagamento,  
      p.cd_identifica_documento,  
      d.nm_observacao_documento,  
      d.dt_emissao_documento_paga,  
      d.vl_juros_documento,  
      d.vl_abatimento_documento,  
      d.vl_desconto_documento,  
      pt.nm_portador,
      d.vl_multa_documento,
      d.nm_ref_documento_pagar

 
    from  
      documento_pagar d  with (nolock)
    left outer join tipo_conta_pagar t on  
      t.cd_tipo_conta_pagar = d.cd_tipo_conta_pagar  
    left outer join  
      Nota_Entrada e  
    on  
      d.cd_nota_fiscal_entrada = cast(e.cd_nota_entrada as varchar)and  
      d.cd_fornecedor = e.cd_fornecedor and  
      d.cd_serie_nota_fiscal = e.cd_serie_nota_fiscal  
    left outer join  
      documento_pagar_pagamento p  
    on  
      d.cd_documento_pagar = p.cd_documento_pagar  
    left outer join  
      tipo_pagamento_documento c  
    on  
      p.cd_tipo_pagamento = c.cd_tipo_pagamento      
    left outer join operacao_fiscal opf on opf.cd_operacao_fiscal=e.cd_operacao_fiscal left join
		Portador pt on (pt.cd_portador = d.cd_portador)

    where    
      d.dt_vencimento_documento between @dt_inicial and @dt_final and    
      d.dt_cancelamento_documento is null and
      'S' = case when e.cd_nota_entrada>0 then isnull(opf.ic_comercial_operacao,'N') else 'S' end

    order by  
      d.dt_vencimento_documento desc,  
      d.nm_favorecido,  
      d.cd_identificacao_document        
    
  end   
else  
  return  
  
 
