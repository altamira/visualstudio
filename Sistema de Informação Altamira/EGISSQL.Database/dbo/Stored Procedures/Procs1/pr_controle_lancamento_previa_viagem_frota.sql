
CREATE PROCEDURE pr_controle_lancamento_previa_viagem_frota
------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2005
------------------------------------------------------------------------------------------

--Stored Procedure	: Microsoft SQL Server      
--Autor(es)		: Wellington Souza Fagundes
--Banco de Dados	: EGISSQL
--Objetivo		: Seleção de Viagens de frota, atualização e inserção de pagamentos
--                        e recebimentos de acordo com o Contas a Pagar (Documento_Pagar) e
--                        Contas a receber (Documento_Receber) 
--                        Obs.: Esta stored Procedure foi baseada na stored pr_controle_guia_remessa 
--Data			: 06-10-2005
--Atualização           : 07.05.2006 - Acertos Diversos - Carlos Fernandes
------------------------------------------------------------------------------------------

  @dt_inicial        datetime,
  @dt_final          datetime,
  @ic_parametro      int,
  @cd_remessa_viagem int = 0,
  @cd_pedido_venda   int = 0,
  @cd_usuario        int = 0,
  @cd_nota_saida     int = 0

AS

  -- variáveis locais
  declare @cd_parcela int
  declare @vl_parcela decimal(25,2)
  declare @nm_obs_parc varchar(40)
  declare @dt_parcela datetime
  declare @dt_remessa datetime
  declare @cd_plano_financeiro int
  declare @cd_tipo_conta int
  declare @cd_ident_parc varchar(25)
  declare @nm_fantasia varchar(30)
  declare @cd_documento int
  declare @cd_cliente int

  declare @cd_identificacao varchar(80)
  declare @cd_favorecido int
  declare @nm_observacao varchar(80)
  declare @Tabela varchar(50)


------------------------------------------------------------------------
if @ic_parametro = 2 -- Trazer todas as guias em aberto no período
------------------------------------------------------------------------
begin

--Consulta para efetuar a soma dos valores de crédito e debito
--de acordo com o código cd_remessa_viagem

SELECT 
    
   sum(rvd.vl_debito_despesa)    as vl_debito,
   sum(rvd.vl_credito_reembolso) as vl_credito,
   rvd.cd_remessa_viagem         as cd_remessa
   
   --Tabela temporária DC (referente a soma do débito é crédito 
   into #DC
   
   from Remessa_Viagem rv left outer join
        Remessa_Viagem_Despesa rvd on rv.cd_remessa_viagem = rvd.cd_remessa_viagem 
   
   where rv.cd_remessa_viagem = rvd.cd_remessa_viagem

   group by rv.cd_remessa_viagem,rvd.cd_remessa_viagem 

   --Excluir a tabela temporária
   --drop table #DC

SELECT     
  rv.CD_REMESSA_VIAGEM, 
  rv.DT_REMESSA_VIAGEM,
  rv.CD_FROTA,
  cl.nm_fantasia_cliente,
  v.nm_VEICULO,
  mt.nm_MOTORISTA,
  rv.CD_VIAGEM,
  rv.dt_previsao_chegada as DtPrev,
  rvd.vl_debito,
  rvd.vl_credito, 
  case	when exists ( select 'rvp' from Remessa_Viagem_Parcela rvp where rvp.cd_remessa_viagem = rv.cd_remessa_viagem )
       	then 'S' 
	else 'N' 
	end as ic_conta_pagar,
  case when exists ( select 'rvpr' from Remessa_Viagem_Parcela_Recebimento rvpr where rvpr.cd_remessa_viagem = rv.cd_remessa_viagem )
       then 'S' else 'N' end as ic_conta_receber,
  rv.qt_km_final,
  rv.qt_km_real_chegada,
  rv.dt_chegada,
  rv.dt_fechamento_viagem,
  ( isnull(rvd.vl_credito,0) - isnull(rvd.vl_debito,0) ) as vl_liquido

into #Teste
FROM         
  Remessa_Viagem rv          left outer join
  FROTA_CLIENTE fc           on rv.cd_frota = fc.cd_frota                    left outer join
  CLIENTE cl                 on rv.cd_cliente = cl.cd_cliente                left outer join
  VEICULO v                  on rv.cd_veiculo = v.cd_veiculo                 left outer join
  MOTORISTA mt               on rv.cd_motorista = mt.cd_motorista            left outer join
  #DC       rvd              on rv.cd_remessa_viagem = rvd.cd_remessa

where
   rv.DT_REMESSA_VIAGEM between @dt_inicial and @dt_final 
   --and IsNull(rv.ic_fechada_remessa,'N') = 'N'

--select * from remessa_viagem


select * into #Teste2 from #Teste

declare @cd_guia_remessa int

while exists ( select 'x' from #Teste )
begin

  set @cd_guia_remessa = ( select top 1 cd_remessa_viagem from #Teste )

SELECT     
  dbo.fn_vl_total_pedido_remessa(rvp.cd_remessa_viagem, rvp.cd_pedido_venda,'R') as vl_total_somar
into #Teste3
FROM         
  REMESSA_VIAGEM_PEDIDO rvp left outer join
  Pedido_Venda pv ON rvp.CD_PEDIDO_VENDA = pv.cd_pedido_venda left outer join
  Cliente c ON pv.cd_cliente = c.cd_cliente left outer join
  Cidade cid ON c.cd_pais = cid.cd_pais and
                          c.cd_estado = cid.cd_estado and
                          c.cd_cidade = cid.cd_cidade left outer join
  Tipo_Pedido tp on tp.cd_tipo_pedido = pv.cd_tipo_pedido
where
   rvp.cd_remessa_viagem = @cd_guia_remessa


--SELECT
   

--update #Teste2
--set vl_remessa = ( select sum(vl_total_somar) from #Teste3 ),
--    vl_remessa_somar = ( select sum(vl_total_somar) from #Teste3)
--where cd_remessa_viagem = @cd_guia_remessa

drop table #Teste3

delete from #Teste where cd_remessa_viagem = @cd_guia_remessa

end

select * from #Teste2

end

---------------------------------------------------------------------------------
else if @ic_parametro = 3 -- Trazer as despesas de uma determinada remessa
---------------------------------------------------------------------------------
begin

  select
	  rvd.CD_REMESSA_VIAGEM,
		rvd.CD_REMESSA_VIAGEM_DESPESA,
		rvd.CD_TIPO_DESPESA_VIAGEM,
		rvd.VL_DEBITO_DESPESA,
		rvd.VL_CREDITO_REEMBOLSO,
		rvd.NM_REMESSA_VIAGEM_DESPESA,
		rvd.CD_USUARIO,
		rvd.DT_USUARIO,
		rvd.ic_valor_comercial_despesa,
		tdv.cd_despesa_viagem,
		tdv.nm_despesa_viagem,
		tdv.sg_despesa_viagem,
		tdv.ic_gerar_km_final,
		tdv.cd_plano_financeiro,
		tdv.ic_tipo_despesa_viagem
  from
    REMESSA_VIAGEM_DESPESA rvd left outer join
    TIPO_DESPESA_VIAGEM   tdv on rvd.cd_tipo_despesa_viagem = tdv.cd_despesa_viagem 
  where
    rvd.cd_remessa_viagem = @cd_remessa_viagem
    

end

-------------------------------------------------------------------------------------------------------
else if @ic_parametro = 4 -- Trazer todos os itens do pedido de venda ainda não gravados na Remessa
-------------------------------------------------------------------------------------------------------
begin

SELECT     
  rvp.cd_remessa_viagem, 
  rvp.cd_pedido_venda,
  pv.cd_item_pedido_venda,
  IsNull(( select pv.qt_item_pedido_venda
           from
             Pedido_Venda_Item x
           where
             x.cd_pedido_venda = rvp.cd_pedido_venda and
             x.cd_item_pedido_venda = pv.cd_item_pedido_venda ),0) -
  IsNull(( select sum(x.qt_item_pedido_venda)
           from
             REMESSA_VIAGEM_ITEM_PEDIDO x
           where
             x.cd_pedido_venda = rvp.cd_pedido_venda and
             x.cd_item_pedido_venda = pv.cd_item_pedido_venda ),0)

 as qt_saldo_pedido_venda,
 pv.vl_unitario_item_pedido, 
 ( case when
      ( select t.ic_sem_valor_remessa 
        from 
          Pedido_Venda x left outer join
          tipo_pedido t on x.cd_tipo_pedido = t.cd_tipo_pedido
        where
          x.cd_pedido_venda = pv.cd_pedido_venda ) = 'S' then 0
    else pv.vl_unitario_item_pedido end ) as vl_unitario_somar, 

  pv.qt_bruto_item_pedido, 
  pv.pc_ipi, 
  pv.pc_icms, 
  p.nm_produto,
  dbo.fn_mascara_produto(pv.cd_produto) as cd_mascara_produto


FROM         
  REMESSA_VIAGEM_PEDIDO rvp inner join
  Pedido_Venda_Item pv ON rvp.CD_PEDIDO_VENDA = pv.cd_pedido_venda and
                          not exists ( select 'x' from REMESSA_VIAGEM_ITEM_PEDIDO x
                                       where x.cd_remessa_viagem = rvp.cd_remessa_viagem and
                                             x.cd_pedido_venda = pv.cd_pedido_venda and
                                             x.cd_item_pedido_venda = pv.cd_item_pedido_venda ) inner join
  Nota_Saida_item nsi on nsi.cd_pedido_venda = pv.cd_pedido_venda and
                         nsi.cd_item_pedido_venda = pv.cd_item_pedido_venda left outer join
  Produto p ON pv.cd_produto = p.cd_produto

where
   rvp.cd_remessa_viagem = @cd_remessa_viagem and
   IsNull(( select sum(x.qt_item_pedido_venda)
            from
              REMESSA_VIAGEM_ITEM_PEDIDO x
            where
              x.cd_pedido_venda = rvp.cd_pedido_venda and
              x.cd_item_pedido_venda = pv.cd_item_pedido_venda ),0) < 

   IsNull(( select x.qt_item_pedido_venda
            from
              Pedido_Venda_Item x
            where
              x.cd_pedido_venda = rvp.cd_pedido_venda and
              x.cd_item_pedido_venda = pv.cd_item_pedido_venda ),0) and
   rvp.cd_pedido_venda = ( case when @cd_pedido_venda = 0 then
                             rvp.cd_pedido_venda else 
                             @cd_pedido_venda end ) and
   nsi.cd_nota_saida = ( case when @cd_nota_saida = 0 then
                             nsi.cd_nota_saida else 
                             @cd_nota_saida end ) and

   pv.dt_cancelamento_item is null and
   nsi.dt_cancel_item_nota_saida is null
                            



end

-----------------------------------------------------------------
else if @ic_parametro = 5 -- Gerar Documentos a Pagar pela Remessa.
-----------------------------------------------------------------
begin
 
    -- Nome da Tabela usada na geração e liberação de códigos
    set @Tabela = cast(DB_NAME()+'.dbo.Documento_Pagar' as varchar(50))

    -- Tabela temporária com as informações da Parcela  
    select 
      rp.cd_remessa_viagem,
      rp.cd_parcela_remessa_viagem,
      rp.cd_identificacao_parcela,
      rp.dt_vencimento_remessa,
      rp.vl_parcela_remessa,
      rp.nm_parcela_remessa,
      t.cd_empresa_diversa,
      r.dt_remessa_viagem,
      tcp.cd_plano_financeiro as cd_plano_financeiro,
      t.cd_tipo_conta_pagar as cd_tipo_conta_pagar,
      rp.cd_documento_pagar
    into
      #Remessa_Parcela
    from
       Remessa_Viagem_Parcela rp left outer join
       Remessa_Viagem r on r.cd_remessa_viagem = rp.cd_remessa_viagem left outer join
       Transportadora t on t.cd_transportadora = r.cd_transportadora left outer join
       Tipo_Conta_Pagar tcp on tcp.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar

    where
      r.cd_remessa_viagem = @cd_remessa_viagem

    select
      @nm_fantasia = nm_fantasia
    from
      Remessa_Viagem r left outer join
      Transportadora t on t.cd_transportadora = r.cd_transportadora
    where
      r.cd_remessa_viagem = @cd_remessa_viagem



    -- verifica se as duplicatas geradas anteriormente já foram pagas
    if exists (select top 1 'x' from documento_pagar_pagamento where
               cd_documento_pagar in (select cd_documento_pagar from #Remessa_Parcela))
      raiserror('Já foi efetuado pagamento de uma ou mais parcelas geradas anteriormente!
                 Não foi possível gerar as parcelas novamente.', 16,1)
    else 
    begin

 
      delete from 
        Documento_Pagar 
      where 
        cd_documento_pagar in (select cd_documento_pagar from #Remessa_Parcela) 

    end   
    -- leitura das parcelas e geração das duplicatas
    while exists(select cd_parcela_remessa_viagem from #Remessa_Parcela)
      begin
       
        -- Código Único    
        --exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_pagar', @codigo = @cd_documento output
        set @cd_documento = (select cast(isnull(max(cd_documento_pagar),0) + 1 as int) from Documento_Pagar)

        select
          top 1
          @cd_parcela = cd_parcela_remessa_viagem,
          @vl_parcela = cast(str(vl_parcela_remessa,25,2) as decimal(25,2)),
          @nm_obs_parc = nm_parcela_remessa,
          @dt_remessa  = dt_remessa_viagem,
          @dt_parcela = dt_vencimento_remessa,
          @cd_ident_parc  = cd_identificacao_parcela,
          @cd_tipo_conta      = cd_tipo_conta_pagar,
          @cd_plano_financeiro      = cd_plano_financeiro,
          @cd_favorecido        = cd_empresa_diversa
        from
          #Remessa_Parcela

        insert into Documento_Pagar (
          cd_documento_pagar,
          cd_identificacao_document,
          dt_emissao_documento_paga,
          dt_vencimento_documento,
          vl_documento_pagar,
          cd_nota_fiscal_entrada,
          cd_serie_nota_fiscal_entr,
          cd_serie_nota_fiscal,
          nm_observacao_documento,
          vl_saldo_documento_pagar,
          cd_tipo_documento,
          cd_tipo_conta_pagar,
          cd_empresa_diversa,
          cd_usuario,
          dt_usuario,
          cd_pedido_compra,
          cd_plano_financeiro,
          cd_moeda,
          nm_fantasia_fornecedor )
        values (
          @cd_documento,
          @cd_ident_parc,
          @dt_remessa,
          @dt_parcela,
          @vl_parcela,
          0,
          '',
          0,
          @nm_obs_parc,
          @vl_parcela,
          1, --Somente Duplicata correspondente ao campo cd_tipo_documento
          @cd_tipo_conta,
          @cd_favorecido,
          @cd_usuario,
          getDate(),
          0,
          @cd_plano_financeiro,
          1, --Somente a moeda real
          '' )

          exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento, 'D'   

          update 
            Remessa_Viagem_Parcela
          set 
            cd_documento_pagar = @cd_documento
          where
            cd_remessa_viagem = @cd_remessa_viagem and
            cd_parcela_remessa_viagem = @cd_parcela
           
          delete from
            #Remessa_Parcela
          where
            cd_parcela_remessa_viagem = @cd_parcela
            
      end 



end

------------------------------------------------------------------------------
else if @ic_parametro = 6 -- Gerar Documentos a Receber pela Remessa.
------------------------------------------------------------------------------

-- Nome da Tabela usada na geração e liberação de códigos
    set @Tabela = cast(DB_NAME()+'.dbo.Documento_Receber' as varchar(50))

    -- Tabela temporária com as informações da Parcela  
    select 
      rvpr.cd_remessa_viagem,
      rvpr.cd_parcela_viagem_recebimento,
      rvpr.cd_identificacao_parcela,
      rvpr.dt_vencimento_remessa,
      rvpr.vl_parcela_remessa,
      rvpr.nm_parcela_remessa,
      rvpr.cd_documento_receber,
      t.cd_empresa_diversa,
      r.dt_remessa_viagem,
      rvpr.cd_cliente,
     -- tcp.cd_plano_financeiro as cd_plano_financeiro,
      t.cd_tipo_conta_pagar as cd_tipo_conta_pagar
    into
      #Remessa_Parcela_Receber
    from
       Remessa_Viagem_Parcela_Recebimento rvpr left outer join
       Remessa_Viagem r on r.cd_remessa_viagem = rvpr.cd_remessa_viagem left outer join
       Transportadora t on t.cd_transportadora = r.cd_transportadora --left outer join
      -- Tipo_Conta_Pagar tcp on tcp.cd_tipo_conta_pagar = t.cd_tipo_conta_pagar

    where
      r.cd_remessa_viagem = @cd_remessa_viagem



    select
      @nm_fantasia = nm_fantasia
    from
      Remessa_Viagem r left outer join
      Transportadora t on t.cd_transportadora = r.cd_transportadora
    where
      r.cd_remessa_viagem = @cd_remessa_viagem

    


    -- verifica se as duplicatas geradas anteriormente já foram recebidas
    if exists (select top 1 'x' from documento_receber_pagamento where
               cd_documento_receber in (select cd_documento_receber from #Remessa_Parcela_Receber))
      raiserror('Já foi efetuado recebimento de uma ou mais parcelas geradas anteriormente!
                 Não será possível gerar as parcelas novamente.', 16,1)
    else 
    begin
 
      delete from 
        Documento_Receber 
      where 
        cd_documento_receber in (select cd_documento_receber from #Remessa_Parcela_Receber) 

    end   
    -- leitura das parcelas e geração das duplicatas
    while exists(select cd_parcela_viagem_recebimento from #Remessa_Parcela_Receber)
      begin
       
        -- Código Único    
        --exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_receber', @codigo = @cd_documento output
	set @cd_documento = (select cast(isnull(max(cd_documento_receber),0) + 1 as int) from Documento_receber)

        
 
        select
          top 1
          @cd_parcela = cd_parcela_viagem_recebimento,
          @vl_parcela = cast(str(vl_parcela_remessa,25,2) as decimal(25,2)),
          @nm_obs_parc = nm_parcela_remessa,
          @dt_remessa = dt_remessa_viagem,
          @dt_parcela = dt_vencimento_remessa,
          @cd_ident_parc  = cd_identificacao_parcela,
         -- @cd_plano_financeiro      = cd_plano_financeiro,
         -- @cd_favorecido        = cd_empresa_diversa,
          @cd_cliente           = cd_cliente
        from
          #Remessa_Parcela_Receber

    
        insert into Documento_Receber (
          ic_credito_icms_documento,
          cd_documento_receber,
          cd_identificacao,
          dt_emissao_documento,
          dt_vencimento_documento,
          dt_vencimento_original,
          vl_documento_receber,
          vl_saldo_documento,
          cd_modulo,
          cd_tipo_cobranca,
          cd_cliente,
          cd_tipo_documento,
          cd_pedido_venda,
          cd_usuario,
          dt_usuario,
          cd_plano_financeiro,
          cd_tipo_destinatario,
          cd_moeda,
          cd_portador )
        values (
          'N',
          @cd_documento,
          @cd_ident_parc,
          @dt_remessa,
          @dt_parcela,
          @dt_parcela,
          @vl_parcela,  
          @vl_parcela,
          108,
          1,
          @cd_cliente,
          1,  -- Somente duplicata
          0,
          @cd_usuario,
          getDate(),
          0,
          1,
          1,
          0)
         
                  
          exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento, 'D'  

          update 
            Remessa_Viagem_Parcela_Recebimento
          set 
            cd_documento_receber = @cd_documento
          where
            cd_remessa_viagem = @cd_remessa_viagem and
            cd_parcela_viagem_recebimento = @cd_parcela


           
          delete from
            #Remessa_Parcela_Receber
          where
            cd_parcela_viagem_recebimento = @cd_parcela
            
   
end

-- ---------------------------------------------------------------------------------
-- else if @ic_parametro = 7 -- Calcular fundo de caixa do relatório de remessa.
-- --------------------------------------------------------------------------------
-- begin
-- 
-- SELECT     
--   (case when rvpp.dt_vencimento_parcela = rv.dt_remessa_viagem then
--      'Total a vista' else 'Total a Prazo' end) as 'ic_vencimento',
-- --  rvp.CD_PEDIDO_VENDA, 
--   tp.nm_tipo_documento as nm_tipo_pagamento, 
--   rvpp.CD_IDENTIFICACAO_PARCELA, 
--   rvpp.VL_PARCELA_RECEBIMENTO - IsNull(vl_desconto_recebimento,0) as vl_parcela_recebimento,
-- 
--   ( case when IsNull(tpe.ic_sem_valor_remessa,'N') = 'S' then 0 else
--     rvpp.VL_PARCELA_RECEBIMENTO - IsNull(vl_desconto_recebimento,0) end ) as vl_parcela_somar,
-- 
--   rvpp.dt_vencimento_parcela
-- into #Resumo
-- FROM         
--   REMESSA_VIAGEM rv inner join
--   REMESSA_VIAGEM_PEDIDO rvp on rv.cd_remessa_viagem = rvp.cd_remessa_viagem left outer join
--   REMESSA_VIAGEM_Parcela_Recebimento rvpp ON 
--              rvp.CD_REMESSA_VIAGEM = rvpp.CD_REMESSA_VIAGEM AND 
--              rvp.CD_PEDIDO_VENDA = rvpp.CD_PEDIDO_VENDA left outer join
--   Tipo_Documento tp ON rvpp.CD_TIPO_DOCUMENTO = tp.cd_tipo_documento left outer join
--   Pedido_Venda pv on pv.cd_pedido_venda = rvp.cd_pedido_venda left outer join
--   Tipo_pedido tpe on tpe.cd_tipo_pedido = pv.cd_tipo_pedido
-- where
--   rvp.cd_remessa_viagem = @cd_remessa_viagem
-- order by
--   rvp.cd_pedido_venda,
--   tp.nm_tipo_documento
-- 
-- select
--   ic_vencimento,
--   nm_tipo_pagamento,
--   sum(vl_parcela_recebimento) as vl_total,
--   sum(vl_parcela_somar) as vl_total_somar
-- from
--   #Resumo
-- group by
--   ic_vencimento,
--   nm_tipo_pagamento
-- 
-- 
-- 
-- end



------------------------------------------------------------------------
if @ic_parametro = 8 -- Controle de Viagem no Periodo
------------------------------------------------------------------------
begin
 SELECT       
    rv.cd_remessa_viagem,   
    rv.dt_previsao_saida,  
    rv.cd_frota,  
    cl.nm_fantasia_cliente,  
    rv.cd_cliente,  
    v.nm_veiculo,  
    rv.cd_viagem,  
    rv.ic_quinzena,  
    isnull(sum(rvd.vl_debito_despesa),0)    as vl_debito,  
    isnull(sum(rvd.vl_credito_reembolso),0) as vl_credito,  
    (isnull(sum(rvd.vl_credito_reembolso),0) - isnull(sum(rvd.vl_debito_despesa),0) ) as vl_liquido  
FROM           
  Remessa_Viagem rv          left outer join  
  Frota_Cliente fc           on rv.cd_frota     = fc.cd_frota                  left outer join  
  Cliente cl                 on rv.cd_cliente   = cl.cd_cliente                left outer join  
  Veiculo v                  on rv.cd_veiculo   = v.cd_veiculo                 left outer join  
  Motorista mt               on rv.cd_motorista = mt.cd_motorista      left outer join  
  Remessa_Viagem_Despesa rvd on rv.cd_remessa_viagem = rvd.cd_remessa_viagem              
  
  
where  
   rv.dt_previsao_saida between @dt_inicial and @dt_final   
   --and IsNull(rv.ic_fechada_remessa,'N') = 'N'  
  
group by  
    rv.cd_remessa_viagem,   
    rv.dt_previsao_saida,  
    rv.cd_frota,  
    cl.nm_fantasia_cliente,  
      rv.cd_cliente,  
    v.nm_veiculo,  
    rv.cd_viagem,  
      rv.ic_quinzena  
--select * from remessa_viagem  
order by      
    cl.nm_fantasia_cliente,  
    rv.ic_quinzena,  
    rv.cd_remessa_viagem   
end  

------------------------------------------------------------------------
if @ic_parametro = 9 -- Fecha Viagem
------------------------------------------------------------------------
begin
		Update Remessa_Viagem set
    		dt_fechamento_viagem = Getdate(),
    		ic_fechada_remessa   = 'S',
         cd_usuario           = @cd_usuario 
      where
			cd_remessa_viagem = @cd_remessa_viagem
end  
  
