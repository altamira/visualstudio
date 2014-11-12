
CREATE PROCEDURE pr_Cancela_Nota_Saida

@ic_ativar                char(1),
@cd_nota_saida            int,
@cd_item_nota_saida       int,
@dt_cancel_nota_saida     Datetime,
@nm_mot_cancel_nota_saida varchar (8000),  -- Aumentado para o Maior Tamanho Possível
@cd_status_nota           int

AS

if not (@ic_ativar = 'S') 
begin

--Cancelamento

        UPDATE Nota_Saida
        SET   
           nm_mot_cancel_nota_saida = @nm_mot_cancel_nota_saida,
           dt_cancel_nota_saida     = @dt_cancel_nota_saida,
           cd_status_nota           = @cd_status_nota,
           cd_requisicao_fat_ant    = cd_requisicao_faturamento, 
           cd_requisicao_faturamento= 0
        where  
           cd_nota_saida = @cd_nota_saida

	--Atualiza em todos os itens a data de cancelamento da nota

        UPDATE Nota_Saida_item
        SET 
           dt_cancel_item_nota_saida = @dt_cancel_nota_saida,
           cd_status_nota            = @cd_status_nota,
           nm_motivo_restricao_item  = @nm_mot_cancel_nota_saida
        where  
           cd_nota_saida = @cd_nota_saida

	update Nota_Saida_Item_Registro
        set
          ic_cancelada_item_nota = 'S'
	where 
          cd_nota_saida = @cd_nota_saida


        update
           Nota_Saida_Recibo
        set
           ic_cancelada_nfe = 'S'
	where 
          cd_nota_saida = @cd_nota_saida

end
else 
begin

--Ativação

        UPDATE Nota_Saida 
        SET nm_mot_cancel_nota_saida  = '',
            dt_cancel_nota_saida      = null,
            cd_status_nota            = @cd_status_nota,
            cd_requisicao_faturamento = cd_requisicao_fat_ant,
            cd_requisicao_fat_ant     = 0  
        where 
            cd_nota_saida = @cd_nota_saida

	--Atualiza em todos os itens a data de cancelamento da nota

        UPDATE Nota_Saida_item
        SET dt_cancel_item_nota_saida = null,
            cd_status_nota            = @cd_status_nota,
            cd_requisicao_faturamento = null,
            dt_ativacao_nota_saida    = @dt_cancel_nota_saida,
            nm_motivo_restricao_item  = @nm_mot_cancel_nota_saida,
            cd_item_requisicao        = null
        where
            cd_nota_saida             = @cd_nota_saida

        UPDATE Nota_Saida_Item_Registro
        set
          ic_cancelada_item_nota = Null
	where 
          cd_nota_saida = @cd_nota_saida

        update
           Nota_Saida_Recibo
        set
           ic_cancelada_nfe = 'N'
	where 
          cd_nota_saida = @cd_nota_saida and
          cd_protocolo_nfe is null       --Apenas se Não existir Protocolo and
          and isnull(ic_cancelada_nfe,'N') = 'N'    

         
end

-----------------------------------------------------------------------------------
--Ajuste da Ordem de Produção
-----------------------------------------------------------------------------------

declare @cd_pedido_venda      int
declare @cd_item_pedido_venda int 
declare @cd_processo          int
declare @qt_faturado_processo float
declare @cd_produto           int

--select * from processo_producao

select
  p.cd_processo,
  i.cd_pedido_venda,
  i.cd_item_pedido_venda,
  i.cd_produto,
  sum( isnull(i.qt_item_nota_saida,0)) as qt_faturado_processo
into
  #SaldoProcesso

from
  Nota_Saida_Item i              with (nolock)
  inner join processo_producao p with (nolock) on p.cd_pedido_venda      = i.cd_pedido_venda and
                                                  p.cd_item_pedido_venda = i.cd_item_pedido_venda
where
  i.cd_nota_saida = @cd_nota_saida and
  isnull(i.cd_pedido_venda,0)>0    and
  isnull(i.cd_item_pedido_venda,0)>0

group by
  p.cd_processo,
  i.cd_pedido_venda,
  i.cd_item_pedido_venda,
  i.cd_produto


while exists ( select top 1 cd_processo from #SaldoProcesso)
begin
  select top 1
    @cd_processo          = cd_processo,
    @cd_pedido_venda      = cd_pedido_venda,
    @cd_item_pedido_venda = cd_item_pedido_venda,
    @cd_produto           = cd_produto,
    @qt_faturado_processo = qt_faturado_processo

  from
    #SaldoProcesso
 
  update
    processo_producao
  set
    qt_faturado_processo = qt_faturado_processo + 
                           ( @qt_faturado_processo * 
                           case when not (@ic_ativar = 'S') then -1 else 1 end )
  where
    @cd_processo          = cd_processo            and
    @cd_pedido_venda      = cd_pedido_venda        and
    @cd_item_pedido_venda = cd_item_pedido_venda   and
    @cd_produto           = cd_produto

 
  delete from #SaldoProcesso
  where
    @cd_processo          = cd_processo            and
    @cd_pedido_venda      = cd_pedido_venda        and
    @cd_item_pedido_venda = cd_item_pedido_venda   and
    @cd_produto           = cd_produto

 
end

-----------------------------------------------------------------------------------


