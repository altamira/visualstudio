
CREATE  procedure pr_embarque_exportacao
-------------------------------------------------------------------
--pr_embarque_exportacao
-------------------------------------------------------------------
-- GBS - Global Business Solution Ltda                         2004
------------------------------------------------------------------- 
-- Stored Procedure    : Microsoft SQL Server 2000
-- Autor(es)           : Elias Pereira da Silva
-- Banco de Dados      : EGISSQL
-- Objetivo            : Todas as Rotinas Necessárias ao Embarque de Exportação
-- Data                : 29/09/2004
-- Atualizacao         : 14/10/2004 - Trazer informações Moeda, Incoterm e Idioma
--                     : 18/11/2004 - Incluído mais um parâmetro ( despesa) - Daniel C. Neto.
--                     : 28/12/2004 - Acerto do cabeçalho - Sérgio Cardoso
--                     : 22.03.2006 - Verificação de Duplicidade de itens - Carlos Fernandes
--                     : 23.08.2007 - Acerto da Consulta do Produto - Carlos Fernandes
---------------------------------------------------------------------------------------------
@ic_parametro    int = 0,
@cd_embarque     int = 0,
@cd_pedido_venda int = 0,
@dt_inicial      datetime,
@dt_final        datetime

as


if @ic_parametro = 1  -- Lista todos os Embarques por Pedido de Venda ou por Embarque
begin

  select 
    e.cd_embarque         as Codigo,
    e.cd_pedido_venda     as PV,
    c.nm_fantasia_cliente as Cliente,
    e.dt_embarque         as DataEmbarque,
    e.vl_total_embarque   as ValorTotal    
  from embarque e
  inner join pedido_venda pv on e.cd_pedido_venda = pv.cd_pedido_venda
  inner join cliente c on pv.cd_cliente = c.cd_cliente

  where e.cd_embarque = case when isnull(@cd_embarque,0) = 0 
                        then e.cd_embarque else @cd_embarque end and
        e.cd_pedido_venda = case when isnull(@cd_pedido_venda,0) = 0 
                            then e.cd_pedido_venda else @cd_pedido_venda end
  order by e.dt_embarque desc, e.cd_pedido_venda, e.cd_embarque
    

end 

else if @ic_parametro = 2  -- Dados do Embarque
begin

  select e.*,
         pve.cd_tipo_container,
         pv.cd_identificacao_empresa
  from embarque e 
       left outer join pedido_venda pv on pv.cd_pedido_venda = e.cd_pedido_venda
       left outer join pedido_venda_exportacao pve on pve.cd_pedido_venda = pv.cd_pedido_venda
  where e.cd_embarque = @cd_embarque and
        e.cd_pedido_venda = @cd_pedido_venda

End

else if @ic_parametro = 3  -- Itens do Embarque
begin

  --select * from pedido_venda_item
  --select * from embarque_item -- psantos 15/12/2004

  select ei.*, 
       pr.nm_fantasia_produto as FantasiaProduto,
       pr.cd_mascara_produto  as CodigoProduto,
       pr.nm_produto          as Descricao_Produto,
       sg_unidade_medida      as Unidade 
  
  from embarque_item ei 
  left outer join pedido_venda pev      on ei.cd_pedido_venda  = pev.cd_pedido_venda
  left outer join pedido_venda_item pvi on ei.cd_pedido_venda = pvi.cd_pedido_venda and
                                           ei.cd_pedido_venda_item = pvi.cd_item_pedido_venda
  left outer join produto pr on pvi.cd_produto = pr.cd_produto
  left outer join unidade_medida um on pvi.cd_unidade_medida = um.cd_unidade_medida

  where ei.cd_embarque     = @cd_embarque and
        ei.cd_pedido_venda = @cd_pedido_venda

end
else if @ic_parametro = 4  -- Grava Operação de Câmbio
begin

  insert into Operacao_Cambio (
    cd_operacao_cambio,
    cd_ref_operacao_cambio,
    dt_operacao_cambio,
    cd_pedido_venda,
    cd_embarque,
    cd_usuario,
    dt_usuario)
  select
    (isnull((select max(cd_operacao_cambio) from operacao_cambio),0) + 1),
    cast(cd_pedido_venda as varchar)+'/'+cast(cd_embarque as varchar),
    dt_embarque,
    cd_pedido_venda,
    cd_embarque,
    cd_usuario,
    dt_usuario
  from Embarque
  where cd_pedido_venda = @cd_pedido_venda and 
        cd_embarque = @cd_embarque     


end
else if @ic_parametro = 5  --Exclui a Operação de Cambio
begin

  delete from Operacao_Cambio
  where cd_pedido_venda = @cd_pedido_venda and
        cd_embarque = @cd_embarque


end
else if @ic_parametro = 6  -- Comissão do Embarque
begin

  select ec.*,rce.nm_fantasia as nm_fantasia_representante, 
         tpc.nm_tipo_pag_comissao 
  from embarque_comissao ec 
    left outer join representante_com_exterior rce 
    on rce.cd_representante_com_ext = ec.cd_representante_com_ext
    left outer join Tipo_Pagamento_Comissao tpc
    on tpc.cd_tipo_pag_comissao = ec.cd_tipo_pagamento_comissao     
  where ec.cd_embarque = @cd_embarque and
        ec.cd_pedido_venda = @cd_pedido_venda

end
else if @ic_parametro = 7  -- Parcelas do Embarque
begin

  select * from embarque_parcela
  where cd_embarque = @cd_embarque and
        cd_pedido_venda = @cd_pedido_venda

end
else if @ic_parametro = 8  -- Financeiro do Embarque
begin

  select * from embarque_financeiro
  where cd_embarque = @cd_embarque and
        cd_pedido_venda = @cd_pedido_venda

end
else if @ic_parametro = 9  -- Apaga os Documentos a Receber Gerados pelo Embarque
begin

  declare @cd_embarque_chave int

  select @cd_embarque_chave = cd_embarque_chave 
  from embarque 
  where cd_embarque = @cd_embarque and
        cd_pedido_venda = @cd_pedido_venda

  delete from documento_receber where cd_embarque_chave = @cd_embarque_chave
  
end
else if @ic_parametro = 10  -- Gera os Lançamentos Financeiros do Embarque
begin

  -- Variáveis Utilizadas por Esta Rotina
  declare @nm_tabela varchar(200)
  declare @cd_movimento int
  declare @cd_plano_financeiro int
  declare @dt_financeiro_embarque datetime
  declare @vl_financeiro_embarque decimal(25,2)
  declare @nm_historico_lancamento varchar(100)
  declare @cd_historico_lancamento int
  declare @cd_tipo_lancamento_fluxo int
  declare @cd_tipo_operacao int
  declare @cd_moeda int
  declare @cd_usuario int
  declare @cd_lancamento_padrao int
  declare @cd_item_financeiro int
  
  -- Nome da Tabela usada na geração e liberação de códigos
  set @nm_tabela = cast(DB_NAME()+'.dbo.Plano_Financeiro_Movimento' as varchar(50))

  declare cCursor cursor for  
  select cd_item_financeiro, cd_plano_financeiro, dt_financeiro_embarque, vl_financeiro_embarque,
         nm_compl_historico, cd_historico_financeiro, cd_moeda, cd_usuario
  from embarque_financeiro
  where cd_embarque = @cd_embarque and
        cd_pedido_venda = @cd_pedido_venda

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

    update Embarque_Financeiro set cd_movimento_financeiro = @cd_movimento
    where cd_embarque = @cd_embarque and cd_pedido_venda = @cd_pedido_venda and
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
       Embarque_Financeiro ef
  where ef.cd_embarque = @cd_embarque and
        ef.cd_pedido_venda = @cd_pedido_venda and
        pfm.cd_movimento = ef.cd_movimento_financeiro
  
end

else if @ic_parametro = 12  -- Despesas do Embarque
begin
  select e.*, cd_identificacao_document
  from 
    embarque_despesa e left outer join
    Documento_Pagar dp on dp.cd_documento_pagar = e.cd_documento_pagar
  where cd_embarque = @cd_embarque and
        cd_pedido_venda = @cd_pedido_venda
end

else if @ic_parametro = 15
begin
---------------------------------------------------------------------------------------------------------------
--Consulta do Embarque por Período
---------------------------------------------------------------------------------------------------------------
  select 
    e.cd_embarque as Codigo,
    e.cd_pedido_venda as PV,
    c.nm_fantasia_cliente as Cliente,
    e.dt_embarque as DataEmbarque,
    e.vl_total_embarque as ValorTotal    
  from embarque e
  inner join pedido_venda pv on e.cd_pedido_venda = pv.cd_pedido_venda
  inner join cliente c on pv.cd_cliente = c.cd_cliente

  where e.cd_embarque = case when isnull(@cd_embarque,0) = 0 
                        then e.cd_embarque else @cd_embarque end and
        e.cd_pedido_venda = case when isnull(@cd_pedido_venda,0) = 0 
                            then e.cd_pedido_venda else @cd_pedido_venda end
	and e.dt_embarque between @dt_inicial and @dt_final
  order by e.dt_embarque desc, e.cd_pedido_venda, e.cd_embarque

end

