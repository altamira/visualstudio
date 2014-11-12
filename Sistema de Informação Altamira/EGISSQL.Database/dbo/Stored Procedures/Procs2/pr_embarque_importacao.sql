
create procedure pr_embarque_importacao

-------------------------------------------------------------------------------------
--pr_embarque_importacao
-------------------------------------------------------------------------------------
-- GBS - Global Business Solution Ltda                    2004
-------------------------------------------------------------------------------------
-- Stored Procedure        : Microsoft SQL Server 2000
-- Autor(es)               : Elias Pereira da Silva
-- Banco de Dados          : EGISSQL
-- Objetivo                : Todas as Rotinas Necessárias ao Embarque de Importacao
-- Data                    : 18/11/2004
-- Atualização             : 27/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                         : 19.08.2007 - complemento dos dados - Carlos Fernandes
-- 27.11.2008 - Ajustes Diversos - Carlos Fernandes
-- 04.12.2008 - Contas a Pagar   - Carlos Fernandes
-- 09.02.2009 - Exclusão do Contas a Pagar - Carlos Fernandes
-- 11.02.2009 - Ajustes Diversos - Carlos Fernandes
------------------------------------------------------------------------------------
@ic_parametro         int      = 0,
@cd_embarque          int      = 0,
@cd_pedido_importacao int      = 0,
@dt_inicial           datetime = '',
@dt_final             datetime = '',
@cd_usuario           int      = 0

as


if @ic_parametro = 1  -- Lista todos os Embarques
begin

  select 
    e.cd_embarque            as Codigo,
    e.cd_pedido_importacao   as PI,
    f.nm_fantasia_fornecedor as Fornecedor,
    e.dt_embarque            as DataEmbarque,
    e.vl_total_embarque      as ValorTotal
    
  from embarque_importacao e      with (nolock) 
  inner join pedido_importacao pi with (nolock) on e.cd_pedido_importacao = pi.cd_pedido_importacao
  inner join fornecedor f         with (nolock) on pi.cd_fornecedor       = f.cd_fornecedor
  where 
     e.cd_embarque = case when isnull(@cd_embarque,0) = 0 
                          then e.cd_embarque else @cd_embarque end and
     e.cd_pedido_importacao = case when isnull(@cd_pedido_importacao,0) = 0 
                              then e.cd_pedido_importacao else @cd_pedido_importacao end
  order by 
    e.dt_embarque, e.cd_pedido_importacao, e.cd_embarque
    

end 

else if @ic_parametro = 2  -- Dados do Embarque
begin

  select e.*,
         pv.cd_identificacao_pedido
         --pv.cd_pedido_importacao
  from embarque_importacao e with (nolock) 
       left outer join pedido_importacao pv on pv.cd_pedido_importacao = e.cd_pedido_importacao
  where e.cd_embarque          = @cd_embarque and
        e.cd_pedido_importacao = @cd_pedido_importacao

End
else if @ic_parametro = 3  -- Itens do Embarque
begin
 
  --select * from embarque_importacao_item
  --select * from pedido_importacao_item

  select 
    ei.*,
    pii.nm_produto_pedido,
    pii.nm_fantasia_produto,   
    um.sg_unidade_medida,
    p.cd_mascara_produto,
    ei.qt_produto_embarque * ei.vl_produto_embarque as vl_item_total
  from 
    embarque_importacao_item ei                with (nolock) 
    left outer join pedido_importacao_item pii with (nolock) on pii.cd_pedido_importacao = ei.cd_pedido_importacao and
                                                                pii.cd_item_ped_imp      = ei.cd_item_ped_imp
    left outer join unidade_medida um          with (nolock) on um.cd_unidade_medida     = pii.cd_unidade_medida
    left outer join produto p                  with (nolock) on p.cd_produto             = pii.cd_produto
  where 
    ei.cd_embarque          = @cd_embarque and
    ei.cd_pedido_importacao = @cd_pedido_importacao

end
else if @ic_parametro = 4  -- Grava Operação de Câmbio
begin

  insert into Operacao_Cambio (
    cd_operacao_cambio,
    cd_ref_operacao_cambio,
    dt_operacao_cambio,
    cd_pedido_importacao,
    cd_embarque,
    cd_usuario,
    dt_usuario)
  select
    (isnull((select max(cd_operacao_cambio) from operacao_cambio),0) + 1),
    cast(cd_pedido_importacao as varchar)+'/'+cast(cd_embarque as varchar),
    dt_embarque,
    cd_pedido_importacao,
    cd_embarque,
    cd_usuario,
    dt_usuario
  from Embarque_Importacao
  where cd_pedido_importacao = @cd_pedido_importacao and 
        cd_embarque = @cd_embarque     


end
else if @ic_parametro = 5  --Exclui a Operação de Cambio
begin

  delete from Operacao_Cambio
  where cd_pedido_importacao = @cd_pedido_importacao and
        cd_embarque          = @cd_embarque


end
else if @ic_parametro = 6  -- Comissão do Embarque
begin

  select ec.*,rce.nm_fantasia as nm_fantasia_representante, 
         tpc.nm_tipo_pag_comissao 
  from embarque_importacao_comissao ec             with (nolock) 
    left outer join representante_com_exterior rce with (nolock) on rce.cd_representante_com_ext = ec.cd_representante_com_ext
    left outer join Tipo_Pagamento_Comissao tpc    with (nolock) on tpc.cd_tipo_pag_comissao = ec.cd_tipo_pagamento_comissao     
  where ec.cd_embarque          = @cd_embarque and
        ec.cd_pedido_importacao = @cd_pedido_importacao

end
else if @ic_parametro = 7  -- Parcelas do Embarque
begin

  select * from embarque_importacao_parcela with (nolock) 
  where cd_embarque = @cd_embarque and
        cd_pedido_importacao = @cd_pedido_importacao

end
else if @ic_parametro = 8  -- Financeiro do Embarque
begin

  select * from embarque_importacao_financeiro with (nolock) 
  where cd_embarque = @cd_embarque and
        cd_pedido_importacao = @cd_pedido_importacao

end
else if @ic_parametro = 9  -- Apaga os Documentos a Pagar Gerados pelo Embarque
begin

  declare @cd_embarque_chave int

  select @cd_embarque_chave = cd_embarque_chave 
  from embarque_importacao 
  where cd_embarque          = @cd_embarque and
        cd_pedido_importacao = @cd_pedido_importacao

  delete from documento_pagar where cd_embarque_chave = @cd_embarque_chave
  
end
else if @ic_parametro = 10  -- Gera os Lançamentos Financeiros do Embarque
begin

  -- Variáveis Utilizadas por Esta Rotina
  declare @nm_tabela                varchar(200)
  declare @cd_movimento             int
  declare @cd_plano_financeiro      int
  declare @dt_financeiro_embarque   datetime
  declare @vl_financeiro_embarque   decimal(25,2)
  declare @nm_historico_lancamento  varchar(100)
  declare @cd_historico_lancamento  int
  declare @cd_tipo_lancamento_fluxo int
  declare @cd_tipo_operacao         int
  declare @cd_moeda                 int
--  declare @cd_usuario               int
  declare @cd_lancamento_padrao     int
  declare @cd_item_financeiro       int
  
  -- Nome da Tabela usada na geração e liberação de códigos
  set @nm_tabela = cast(DB_NAME()+'.dbo.Plano_Financeiro_Movimento' as varchar(50))

  declare cCursor cursor for  
  select cd_item_financeiro, cd_plano_financeiro, dt_financeiro_embarque, vl_financeiro_embarque,
         nm_compl_historico, cd_historico_financeiro, cd_moeda, cd_usuario
  from embarque_importacao_financeiro
  where cd_embarque = @cd_embarque and
        cd_pedido_importacao = @cd_pedido_importacao

  open cCursor

  fetch next from cCursor into @cd_item_financeiro, @cd_plano_financeiro, @dt_financeiro_embarque, 
    @vl_financeiro_embarque, @nm_historico_lancamento, @cd_historico_lancamento,
    @cd_moeda, @cd_usuario

  while @@fetch_status = 0
  begin

    exec EgisADMIN.dbo.sp_PegaCodigo @nm_tabela, 'cd_movimento', @codigo = @cd_movimento output
   
	  insert Plano_Financeiro_Movimento 
	  (cd_movimento, cd_plano_financeiro, cd_tipo_lancamento_fluxo, dt_movto_plano_financeiro,
	   vl_plano_financeiro, nm_historico_movimento, cd_historico_financeiro, cd_tipo_operacao,
	   cd_moeda, cd_usuario, dt_usuario, ic_lancamento_automatico, cd_modulo, cd_lancamento_padrao)
	  values (@cd_movimento, @cd_plano_financeiro, 2, @dt_financeiro_embarque,
	   @vl_financeiro_embarque, @nm_historico_lancamento, @cd_historico_lancamento, 1,
     @cd_moeda, @cd_usuario, getdate(), 'S', 0, 0)

    update Embarque_Importacao_Financeiro set cd_movimento_financeiro = @cd_movimento
    where cd_embarque = @cd_embarque and cd_pedido_importacao = @cd_pedido_importacao and
          cd_item_financeiro = @cd_item_financeiro
          
	  -- liberação do código gerado p/ PegaCodigo
	  exec EgisADMIN.dbo.sp_LiberaCodigo @nm_tabela, @cd_movimento, 'D'

	  fetch next from cCursor into @cd_item_financeiro, @cd_plano_financeiro, @dt_financeiro_embarque, 
	    @vl_financeiro_embarque, @nm_historico_lancamento, @cd_historico_lancamento,
	    @cd_moeda, @cd_usuario

  end

  close cCursor
  deallocate cCursor

end
else if @ic_parametro = 11  -- Apaga os Lancamentos Financeiros Gerados
begin

  delete Plano_Financeiro_Movimento
  from Plano_Financeiro_Movimento pfm,
       Embarque_Importacao_Financeiro ef
  where ef.cd_embarque          = @cd_embarque and
        ef.cd_pedido_importacao = @cd_pedido_importacao and
        pfm.cd_movimento        = ef.cd_movimento_financeiro
  
end

else if @ic_parametro = 12  -- Consulta das Despesas de Importação
begin

  select 
    e.*, 
    dp.cd_identificacao_document
  from 
    embarque_importacao_despesa e      with (nolock) 
    left outer join Documento_Pagar dp with (nolock) on dp.cd_documento_pagar = e.cd_documento_pagar
  where e.cd_embarque          = @cd_embarque and
        e.cd_pedido_importacao = @cd_pedido_importacao
end

else if @ic_parametro = 13  --Geração das Despesas
begin

  --embarque_importacao_despesa  

  --Geração automatica

  --select * from despesa_padrao_comex
  --select * from Despesa_Padrao_comex_item
  --select * from tipo_despesa_comex
  --select * from pedido_importacao

  --deleta as Despesas

  delete from embarque_importacao_despesa  
  where cd_embarque          = @cd_embarque and
        cd_pedido_importacao = @cd_pedido_importacao


  declare @cd_despesa_padrao_comex int
  declare @dt_prev_emb_ped_imp     datetime

  select 
    @cd_despesa_padrao_comex = isnull(cd_despesa_padrao_comex,0),
    @dt_prev_emb_ped_imp     = isnull(dt_prev_emb_ped_imp,dt_pedido_importacao)
  from
    pedido_importacao with (nolock) 
  where
    cd_pedido_importacao = @cd_pedido_importacao

  --Composicao

  select
    @cd_pedido_importacao                 as cd_pedido_importacao,
    @cd_embarque                          as cd_embarque,
    identity(int,1,1)                     as cd_item_despesa_embarque,
    d.cd_tipo_despesa_comex,
    @dt_prev_emb_ped_imp +
    isnull(td.qt_dia_pagamento_despesa,0) as dt_despesa_embarque,
    --Checa a conversão
    case when isnull(td.vl_tipo_despesa_comex,0)>0 and isnull(td.ic_conversao_moeda,'N' )='S' then
         td.vl_tipo_despesa_comex * isnull(dbo.fn_vl_moeda_periodo(td.cd_moeda,getdate() ),1)
    else
         td.vl_tipo_despesa_comex 
    end                                   as vl_despesa_embarque,
    cast('' as varchar(40))               as nm_obs_despesa_embarque,
    td.cd_plano_financeiro,
    td.cd_historico_financeiro,
    cast('' as varchar(40))               as nm_compl_historico,
    isnull(td.ic_conversao_moeda,'N')     as ic_conversao_moeda,
    isnull(td.cd_moeda,1)                 as cd_moeda,
    --null                                as dt_conversao_moeda,
    convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121) as dt_conversao_moeda,
    null                                  as cd_movimento_financeiro,
    'N'                                   as ic_scp_despesa_embarque,
    @cd_usuario                           as cd_usuario,
    getdate()                             as dt_usuario,
    null                                  as cd_documento_pagar,
    td.cd_empresa_diversa,
    td.cd_favorecido_empresa,
    @dt_prev_emb_ped_imp + isnull(td.qt_dia_pagamento_despesa,0) as dt_vencimento_despesa,
    td.cd_tipo_conta_pagar,
    td.cd_centro_custo,
    td.vl_tipo_despesa_comex,
    dbo.fn_vl_moeda_periodo(td.cd_moeda,getdate() ) as vl_cotacao_moeda

  into
    #Embarque_Importacao_Despesa
  from
    Despesa_Padrao_comex_item d           with (nolock) 
    left outer join tipo_despesa_comex td with (nolock) on td.cd_tipo_despesa_comex = d.cd_tipo_despesa_comex
  where
    d.cd_despesa_padrao_comex = @cd_despesa_padrao_comex   

  --select * from tipo_despesa_comex
  --select * from embarque_importacao
  --select * from Embarque_Importacao_Despesa
  --select @cd_despesa_padrao_comex as cd_despesa_padrao_comex

  insert into
    Embarque_Importacao_Despesa
  select
    *
  from
    #Embarque_Importacao_Despesa

  drop table #embarque_importacao_despesa

end

--------------------------------------------------------------------------------------------------------
--
--------------------------------------------------------------------------------------------------------


