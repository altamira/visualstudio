
create procedure pr_geracao_automatica_projeto

------------------------------------------------------------------------
--pr_geracao_automatica_projeto
------------------------------------------------------------------------
--GBS - Global Business Solution	               2004
--Stored Procedure	: Microsoft SQL Server         2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Geração Automática de Projetos
--Data			: 02/12/2004
--Alteração             : 02/12/2004
------------------------------------------------------------------------

@ic_parametro         int,
@cd_pedido_venda      int,
@cd_item_pedido_venda int,
@cd_projeto           int,
@cd_usuario           int

as

if @ic_parametro = 1
begin

   declare @cd_status_projeto int

   select 
     @cd_status_projeto = isnull(cd_status_projeto,0) 
   from 
     status_projeto 
   where 
     isnull(ic_pad_status_projeto,'N')='S'

   --Busca o Próximo número de Projeto
   select @cd_projeto = isnull( max(cd_projeto),0 ) + 1 from Projeto

   --select @cd_projeto

   insert 
      Projeto (
        cd_projeto,
        dt_entrada_projeto,
        cd_interno_projeto,
        dt_inicio_projeto,
        cd_pedido_venda,
        cd_item_pedido_venda,
        cd_consulta,
        cd_item_consulta,
        cd_cliente,
        cd_status_projeto,
        cd_usuario,
        dt_usuario )
   select
        @cd_projeto,
        pv.dt_pedido_venda,
        pv.cd_identificacao_empresa,
        pv.dt_pedido_venda + 2,
        pv.cd_pedido_venda,
       pvi.cd_item_pedido_venda,
       pvi.cd_consulta,
       pvi.cd_item_consulta,
        pv.cd_cliente,
        @cd_status_projeto,
        @cd_usuario,
        getdate()
        
   from
       Pedido_Venda pv,
       Pedido_Venda_item pvi
   where
       @cd_pedido_venda         = pv.cd_pedido_venda  and
       pv.cd_pedido_venda       = pvi.cd_pedido_venda and
       pvi.cd_item_pedido_venda = @cd_item_pedido_venda
        
end

if @ic_parametro = 9
begin

   delete from projeto where cd_projeto = @cd_projeto

end

--select * from pedido_venda
--select cd_consulta,cd_item_consulta,* from pedido_venda_item
--select * from projeto  order by cd_projeto
