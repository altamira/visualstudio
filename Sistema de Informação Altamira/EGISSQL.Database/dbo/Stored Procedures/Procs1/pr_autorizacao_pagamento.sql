
CREATE PROCEDURE pr_autorizacao_pagamento

---------------------------------------------------------------------------------------------------------
--pr_autorizacao_pagamento
---------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                         2004
---------------------------------------------------------------------------------------------------------
--Stored Procedure  : Microsoft SQL Server 2000
--Autor(es)         : Daniel C. Neto.
--Banco de Dados    : EGISSQL 
--Objetivo          : Seleção de Documentos para Autorização de Pagamentos.
--Data              : 26/03/2004
--Atualização       : Acerto do Cabeçalho - Sérgio Cardoso
--                  : 18.05.2007 - Acerto Geral da Procedure - Carlos Fernandes
--                    23.05.2007 - Acerto para mostrar a Requisição de Viagem/Solicitação de Adiantamento
--                    26.05.2007 - Mostrar somente as Ap´s Autorizadas - Carlos Fernandes
--                    13.07.2007 - Checagem geral - Carlos Fernandes
--                    19.07.2007 - Acerto na stored procedure - Dados do Fornecedor - Carlos Fernandes
--                    31.08.2007 - Checagem do Documento quando é Requisição de Viagem - Carlos Fernandes
-- 05.11.2007 - Verificação do Favorecido para Solicitação de Pagamento - Carlos Fernandes
-- 09.11.2007 - Favorecido da Solicitação de Pagamento - Carlos Fernandes
-- 26.02.2008 - Ajuste para performance de velocidade - Carlos Fernandes
-- 27.03.2008 - Acerto de performance - Carlos Fernandes
-- 17.07.2008 - Duplicidade na Consulta - Carlos Fernandes
-- 26.07.2008 - Complemento dos campos - Carlos Fernandes
-- 04.12.2008 - Pedido de Importação - Carlos Fernandes
---------------------------------------------------------------------------------------------------------
@ic_parametro     int      = 0,
@dt_inicial       datetime = '',
@dt_final         datetime = '',
@cd_documento     int      = 0,
@ic_tipo_consulta char(1)  = 'N',
@ic_selecao       int      = 0,
@cd_ap            int      = 0

as

--select * from autorizacao_pagamento
--select * from autorizacao_pagto_composicao
--select * from cheque_pagar
--select * from conta_agencia_banco
--select * from funcionario
--select * from requisicao_viagem

---------------------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------------------

if @ic_parametro = 1
begin

  select 
    @ic_selecao                           as Sel,
    cast(ap.cd_ap as varchar)             as Numero,
    ap.cd_ap                              as CodDocumento,
    ap.dt_ap                              as Emissao,
    case when cp.dt_emissao_cheque_pagar is not null then
        cp.dt_emissao_cheque_pagar 
    else
        getdate()              end                         as Vencimento, 

    isnull(ap.vl_ap,0)                                     as Valor,

    case when ap.cd_tipo_ap = 11 then
     isnull(( select top 1 sp.nm_favorecido_solicitacao from solicitacao_pagamento sp 
       where
         sp.cd_solicitacao = ap.cd_solicitacao ),fu.nm_funcionario)
     
    else
    case when isnull(cp.nm_favorecido,'')<>'' then
      cp.nm_favorecido
    else
      case when isnull(f.nm_fantasia_fornecedor,'')<>'' 
      then
        f.nm_fantasia_fornecedor
      else     
         case when isnull(fu.nm_funcionario,'')<>''
         then
            fu.nm_funcionario
         else
           cast('** Ver Composição' as varchar) end   
         end
    end 
    end                                                   as Favorecido,

    case when isnull(cab.nm_conta_banco,'')<>'' then
       rtrim(ltrim(cab.nm_conta_banco)) + '/'+ag.nm_agencia_banco
    else
       case when isnull(f.cd_conta_banco,'')<>'' then
          rtrim(ltrim(bf.nm_banco)) + '/'+f.cd_agencia_banco+'-'+f.cd_conta_banco
       else
         case when isnull(fu.cd_agencia_funcionario,'')<>'' 
         then
           rtrim(ltrim(fu.cd_conta_funcionario))+'/'+fu.cd_agencia_funcionario
         else
          cast('' as varchar) end
       end                            
    end                                                    as Conta,

    tap.sg_tipo_ap                                         as Tipo,
    tap.nm_referencia_tipo_ap,
    tap.nm_forma_pagto_tipo_ap                             as FormaPagamento,
    cast(ap.ds_ap as varchar(100))                         as Observacao,
    case when isnull(fu.cd_banco,0)>0 
    then
      cast(fu.cd_banco as varchar(3))
    else
    cast(b.cd_numero_banco as varchar(3))+'-'+b.sg_banco 
    end                                                    as Banco,
--//    '(*'+dbo.fn_valor_extenso(ap.vl_ap)+'*)'               as nm_extenso,
    dt_aprovacao_ap,

   --Dados do Funcionario

   fu.cd_cpf_funcionario,
   fu.cd_rg_funcionario,
   fu.cd_chapa_funcionario,
   fu.cd_registro_funcionario,
   fu.cd_identificacao_funcionario,   
   cc.sg_centro_custo,
   cc.nm_centro_custo,
   u.nm_fantasia_usuario as nm_usuario_aprovacao

   --cast(convert(varchar(10),ap.dt_ap,103) as datetime ) as xEmissao

--select * from centro_custo

  into
    #ap
  from
    autorizacao_pagamento ap                       with (nolock)  
    left outer join tipo_autorizacao_pagamento tap with (nolock) on tap.cd_tipo_ap          = ap.cd_tipo_ap
    left outer join cheque_pagar               cp  with (nolock) on cp.cd_cheque_pagar      = ap.cd_cheque_pagar 
    left outer join banco b                        with (nolock) on b.cd_banco              = cp.cd_banco
    left outer join conta_agencia_banco       cab  with (nolock) on cab.cd_conta_banco      = cp.cd_conta_banco
    left outer join agencia_banco             ag   with (nolock) on ag.cd_agencia_banco     = cab.cd_agencia_banco and
                                                                    ag.cd_banco             = cab.cd_banco
    left outer join fornecedor_adiantamento   fa   with (nolock) on fa.cd_ap                = ap.cd_ap
    left outer join fornecedor                f    with (nolock) on f.cd_fornecedor         = fa.cd_fornecedor
    left outer join funcionario               fu   with (nolock) on fu.cd_funcionario       = ap.cd_funcionario
--     left outer join conta_agencia_banco      cabf  on cabf.cd_conta_banco     = f.cd_conta_banco
--     left outer join agencia_banco             agf  on agf.cd_agencia_banco    = cabf.cd_agencia_banco and
--                                                       agf.cd_banco            = cabf.cd_banco
    left outer join banco                     bf   with (nolock) on bf.cd_banco             = f.cd_banco
    left outer join centro_custo              cc   with (nolock) on cc.cd_centro_custo      = fu.cd_centro_custo
    left outer join egisadmin.dbo.Usuario     u    with (nolock) on u.cd_usuario            = ap.cd_usuario_aprovacao

  order by
     ap.dt_ap desc, ap.cd_ap desc

--  print '1'

  if isnull(@cd_ap,0) = 0
  begin
    if ( isnull(@ic_tipo_consulta,'N')='N' )
    begin

--      print '2'

      select
        *,
       '(*'+dbo.fn_valor_extenso(valor)+'*)'               as nm_extenso
      from 
        #ap with (nolock)
      where
--        ( cast(convert(varchar(10),Emissao,103) as datetime) between @dt_inicial and @dt_final ) and
        dt_aprovacao_ap is null
    end
    else
    begin

--      print '3'

      select
        *,
       '(*'+dbo.fn_valor_extenso(valor)+'*)'               as nm_extenso
 
      from 
        #ap with (nolock)
      where
        cast(convert(varchar(12),Emissao,103)as datetime) between @dt_inicial and @dt_final and
        dt_aprovacao_ap is not null
      order by
        emissao desc
    end
  end
  else
  begin

--    print '4'

    select
      *,
     '(*'+dbo.fn_valor_extenso(valor)+'*)'               as nm_extenso
 
    from 
      #ap with (nolock)
    where
      Numero = @cd_ap

  end

end

------------------------------------------------------------------
--Composição
------------------------------------------------------------------

if @ic_parametro = 2
begin

    select distinct
      case when d.dt_vencimento_documento is not null then
          isnull(d.dt_vencimento_documento,a.dt_ap) 
      else
         a.dt_ap end                       as dt_vencimento_documento,

      c.sg_tipo_conta_pagar,

      tap.sg_tipo_ap       as 'ic_tipo_bordero',        

      case when (isnull((select x.cd_empresa_diversa     from documento_pagar x where x.cd_documento_pagar = d.cd_documento_pagar), 0) <> 0)   then cast((select top 1 z.sg_empresa_diversa     from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(30))
           when (isnull((select x.cd_contrato_pagar      from documento_pagar x where x.cd_documento_pagar = d.cd_documento_pagar), 0) <> 0)   then cast((select top 1 w.nm_fantasia_fornecedor from contrato_pagar w  where w.cd_contrato_pagar  = d.cd_contrato_pagar)  as varchar(30))
           when (isnull((select x.cd_funcionario         from documento_pagar x where x.cd_documento_pagar = d.cd_documento_pagar), 0) <> 0)   then cast((select top 1 k.nm_funcionario         from funcionario k     where k.cd_funcionario     = d.cd_funcionario)     as varchar(30))
           when (isnull((select x.nm_fantasia_fornecedor from documento_pagar x where x.cd_documento_pagar = d.cd_documento_pagar), '') <> '') then cast(d.nm_fantasia_fornecedor as varchar(30))
      end                             as 'cd_favorecido',               

      case when (isnull((select x.cd_empresa_diversa     from documento_pagar x where x.cd_documento_pagar = d.cd_documento_pagar), 0) <> 0) then cast((select top 1 z.nm_empresa_diversa from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa)   as varchar(50))
           when (isnull((select x.cd_contrato_pagar      from documento_pagar x where x.cd_documento_pagar = d.cd_documento_pagar), 0) <> 0) then cast((select top 1 w.nm_contrato_pagar from contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar)       as varchar(50))
           when (isnull((select x.cd_funcionario         from documento_pagar x where x.cd_documento_pagar = d.cd_documento_pagar), 0) <> 0) then cast((select top 1 k.nm_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario)                   as varchar(50))
           when (isnull((select x.nm_fantasia_fornecedor from documento_pagar x where x.cd_documento_pagar = d.cd_documento_pagar), '') <> '') then cast((select top 1 o.nm_razao_social from fornecedor o where o.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(50))  

      end                             as 'nm_favorecido',             

    isnull(d.cd_identificacao_document,a.cd_ap ) as cd_identificacao_document,

    case when (isnull(d.cd_fornecedor, 0) <> 0)      then (select top 1 f.cd_banco from fornecedor f                   where f.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor)
         when (isnull(d.cd_empresa_diversa, 0) <> 0) then (select top 1 z.cd_banco from empresa_diversa z              where z.cd_empresa_diversa = d.cd_empresa_diversa)
         when (isnull(d.cd_funcionario, 0) <> 0)     then (select top 1 k.cd_banco from funcionario k                  where k.cd_funcionario = d.cd_funcionario)
         when (isnull(d.cd_contrato_pagar, 0) <> 0)  then (select top 1 f.cd_banco from fornecedor f, contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar and w.cd_fornecedor = f.cd_fornecedor)
    end                               as 'cd_banco',               

    case when (isnull(d.cd_fornecedor, 0) <> 0)      then cast((select top 1f.cd_agencia_banco        from fornecedor f                   where f.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(20))
         when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.cd_agencia_banco       from empresa_diversa z              where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(20))
         when (isnull(d.cd_funcionario, 0) <> 0)     then cast((select top 1 k.cd_agencia_funcionario from funcionario k                  where k.cd_funcionario = d.cd_funcionario) as varchar(20))
         when (isnull(d.cd_contrato_pagar, 0) <> 0)  then cast((select top 1 f.cd_agencia_banco       from fornecedor f, contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar and w.cd_fornecedor = f.cd_fornecedor) as varchar(20))
    end                               as 'cd_agencia_banco',               

    case when (isnull(d.cd_fornecedor, 0) <> 0)      then cast((select top 1 f.cd_conta_banco from fornecedor f where f.nm_fantasia_fornecedor = d.nm_fantasia_fornecedor) as varchar(20))
	 when (isnull(d.cd_empresa_diversa, 0) <> 0) then cast((select top 1 z.cd_conta_corrente from empresa_diversa z where z.cd_empresa_diversa = d.cd_empresa_diversa) as varchar(20))
         when (isnull(d.cd_funcionario, 0) <> 0)     then cast((select top 1 k.cd_conta_funcionario from funcionario k where k.cd_funcionario = d.cd_funcionario) as varchar(20)) 
         when (isnull(d.cd_contrato_pagar, 0) <> 0)  then cast((select top 1 f.cd_conta_banco from fornecedor f, contrato_pagar w where w.cd_contrato_pagar = d.cd_contrato_pagar and w.cd_fornecedor = f.cd_fornecedor) as varchar (20))
    end                                        as 'cd_conta_banco',               

      isnull(d.vl_documento_pagar,a.vl_ap)     as vl_documento_pagar,
      ap.cd_ap,
      f.cd_funcionario,
      f.nm_funcionario,
      ap.cd_documento_ap,
      isnull(d.vl_multa_documento,0)           as vl_multa_documento,
      isnull(d.vl_juros_documento,0)           as vl_juros_documento,
      isnull(d.vl_abatimento_documento,0)      as vl_abatimento_documento,
      isnull(d.vl_desconto_documento,0)        as vl_desconto_documento
     
--select * from documento_pagar

    into #TabelaDistinta

    from
      autorizacao_pagto_composicao ap                with (nolock) 
      inner join autorizacao_pagamento a             with (nolock) on a.cd_ap               = ap.cd_ap

--** Verificar este ponto

--       left outer join documento_pagar d              with (nolock) on d.cd_documento_pagar  = ap.cd_documento_ap and
--                                                                       d.cd_ap               = ap.cd_ap
-- 
      inner join documento_pagar d              with (nolock) on d.cd_documento_pagar  = ap.cd_documento_ap and
                                                                      d.cd_ap               = ap.cd_ap

      left outer join tipo_conta_pagar c             with (nolock) on d.cd_tipo_conta_pagar = c.cd_tipo_conta_pagar
      left outer join tipo_autorizacao_pagamento tap with (nolock) on tap.cd_tipo_ap        = a.cd_tipo_ap
      left outer join funcionario f                  with (nolock) on f.cd_funcionario      = a.cd_funcionario

    where           
      ap.cd_ap = @cd_documento

    select
      * 
    from 
      #TabelaDistinta with (nolock)
    order by
      dt_vencimento_documento desc,
      sg_tipo_conta_pagar,
      cd_favorecido,
      cd_identificacao_document

    drop table #TabelaDistinta

    --select * from autorizacao_pagto_composicao
    --select * from autorizacao_pagamento

end

-----------------------------------------------------------------------------------------
--Exclusão Total
-----------------------------------------------------------------------------------------

if @cd_ap>0 and @ic_parametro = 3
begin

  delete from autorizacao_pagto_composicao where cd_ap = @cd_ap
  delete from autorizacao_pagamento        where cd_ap = @cd_ap
  
  --Cheque Pagar

  update 
    cheque_pagar
  set
    cd_ap = 0
  where 
    cd_ap = @cd_ap


  --Documento a Pagar

  update 
    documento_pagar
  set
    cd_ap     = 0,
    ic_sel_ap = 'N'
  where 
    cd_ap = @cd_ap

  --Requisição de Viagem

  update
    requisicao_viagem
  set
    cd_ap = 0
  where 
    cd_ap = @cd_ap

 
  --Solicitação de Adiantamento
  update
    solicitacao_adiantamento
  set
    cd_ap = 0
  where 
    cd_ap = @cd_ap


  --Solicitação de Pagamento
  update
    solicitacao_pagamento
  set
    cd_ap = 0
  where 
    cd_ap = @cd_ap


  --Adiantamento de Fornecedor
  update
    fornecedor_adiantamento
  set
    cd_ap = 0
  where 
    cd_ap = @cd_ap

  --Prestação de Conta

  update
    prestacao_conta
  set
    cd_ap = 0
  where 
    cd_ap = @cd_ap


end

-----------------------------------------------------------------------------------------
--Retorno da Aprovação
-----------------------------------------------------------------------------------------

if @cd_ap>0 and @ic_parametro = 4
begin

  update
    autorizacao_pagamento
  set
    dt_aprovacao_ap      = null,
    cd_usuario_aprovacao = null
  where
    cd_ap = @cd_ap

end

