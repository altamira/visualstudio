
CREATE PROCEDURE pr_programacao_orcamento

@ic_parametro       int,
@cd_consulta        int,
@cd_item_consulta   int,
@dt_inicial    datetime,
@dt_final      datetime,
@cd_usuario int = 0
AS

declare @cd_consulta_str varchar(10)


declare @cd_vendedor int

--Define o vendedor para o cliente
Select
	@cd_vendedor = dbo.fn_vendedor_internet(@cd_usuario)

---------------------------------------------------  
if @ic_parametro = 1 -- Consulta todas do Período.  
---------------------------------------------------  
begin  

  set @cd_consulta_str=case when isnull(@cd_consulta,0)=0 then '%' else cast(@cd_consulta as varchar(10)) end

  select   
     c.cd_consulta,   
     ci.dt_orcamento_liberado_con,  
     ci.cd_item_consulta,   
     ci.dt_item_consulta,   
     ci.nm_fantasia_produto,   
	     ci.qt_item_consulta,   
     ci.vl_unitario_item_consulta,   
    (ci.qt_item_consulta*ci.vl_unitario_item_consulta) as vl_total_item,   
     ci.dt_entrega_consulta,   
     ci.qt_dia_entrega_consulta,  
     ci.cd_consulta_representante,  
     ci.cd_item_consulta_represe,  
     ci.cd_os_consulta,  
     ci.cd_posicao_consulta,  
     ci.ic_orcamento_comercial as 'DiretoVendas',  
     cli.nm_fantasia_cliente,  
     vi.nm_fantasia_vendedor as 'V_I',  
     ve.nm_fantasia_vendedor as 'V_E',  
     case when isnull(c.ic_fatsmo_consulta,'N') = 'S' then 'S' else  
       'N' end as 'SMO',  
     case when isnull(ci.cd_pedido_venda,0) > 0 then 'S' else  
       'N' end as 'Pedido_venda',  
     Atrasado =   
     case when ci.dt_entrega_consulta is null then  
       case when Datediff(dd,GetDate()-1,ci.dt_item_consulta) < 0 then 'S' else 'N' end  
     else  
       case when Datediff(dd,GetDate(),ci.dt_entrega_consulta) < 0 then 'S' else 'N' end  
     end,  
     Dias = qt_dia_entrega_consulta,   
     --case when ci.dt_entrega_consulta is null then  
     --   cast(((getdate()-1) - ci.dt_item_consulta ) as Int)  
     --else datediff(dd,getdate(),ci.dt_entrega_consulta) end,  
     case when ci.dt_orcamento_liberado_con is null then 'N' else  
       'S' end as 'Liberado',  
     case when isnull(ci.vl_orcado_item_consulta,0) = 0 then 'N' else  
       'S' end as 'Orcado',   
     dt_orcamento_consulta =  
    (select top 1 dt_orcamento_consulta   
     from consulta_item_orcamento co  
     where co.cd_consulta      = ci.cd_consulta and  
           co.cd_item_consulta = ci.cd_item_consulta),  
     usulib.nm_fantasia_usuario as 'UsuarioLiberacao',  
     case when isnull(ci.vl_orcado_item_consulta,0) = 0 then 'S' else  
       'N' end as 'SemOrcamento',   
     case when isnull(ci.ic_orcamento_status,'') in ('A','I') then 'S' else -- Alteracao, Inclusao  
       'N' end as 'OrcamentoAndamento',  
     ci.cd_pedido_venda,  
     ci.cd_item_pedido_venda   
  
  into #TmpConsulta  
  
  from  Consulta_Itens ci with (nolock)
  
  inner join Consulta c  with (nolock) on  
  ci.cd_consulta = c.cd_consulta   
  
  inner join Cliente cli  with (nolock) on   
  c.cd_cliente = cli.cd_cliente   
  
  left outer join Vendedor vi  with (nolock) on  
  c.cd_vendedor_interno = vi.cd_vendedor   
  
  left outer join Vendedor ve  with (nolock) on  
  c.cd_vendedor = ve.cd_vendedor  
  
  left outer join EgisAdmin.Dbo.Usuario usulib  with (nolock) on     
  ci.cd_usuario_liberacao_orc = usulib.cd_usuario  
  
  where       
    (ci.dt_item_consulta between @dt_inicial and @dt_final) and  
    --Implementada a filtragem das consultas por vendedor para os casos de conexão remota de vendedor/usuário
    --Fabio 24.01.2006
    IsNull(c.cd_vendedor,0) = ( case @cd_vendedor
                                      when 0 then IsNull(c.cd_vendedor,0)
                                      else @cd_vendedor
                                    end ) and
     ci.dt_perda_consulta_itens is null and  
     isnull(ci.ic_orcamento_consulta,'N') = 'S' and  
		@cd_consulta = case when isnull(@cd_consulta,0)=0 then @cd_consulta else ci.cd_consulta end and
--   (ci.cd_consulta like @cd_consulta_str) and  
     c.cd_status_proposta <> 3  
    


  order by   
     c.cd_consulta desc,  
     ci.cd_item_consulta  
    
  --  
  -- Busca nro. de pedido  
  --  
  select a.*,  
--     cd_pedido_venda =   
--     (select top 1 pvi.cd_pedido_venda from pedido_venda_item pvi  
--      where pvi.cd_consulta = a.cd_consulta and pvi.cd_item_consulta = a.cd_item_consulta),  
--     cd_pedido_venda_item =  
--     (select top 1 pvi.cd_item_pedido_venda from pedido_venda_item pvi   
--      where pvi.cd_consulta = a.cd_consulta and pvi.cd_item_consulta = a.cd_item_consulta),  
     case when pp.cd_processo is null then 'N' else  
       'S' end as 'Processo'  
    
  from #TmpConsulta a  
    
  left outer join Processo_Producao pp  with (nolock) on   
  a.cd_pedido_venda      = pp.cd_pedido_venda and  
  a.cd_item_pedido_venda = pp.cd_item_pedido_venda  
    
end  
  
---------------------------------------------------------------------  
else -- Consulta somente a Proposta Escolhida e seu respectivo item.  
---------------------------------------------------------------------  
begin  
  
  select   
     c.cd_consulta,   
     ci.cd_item_consulta,   
     cli.nm_fantasia_cliente,   
     cli.nm_razao_social_cliente,  
     ci.nm_fantasia_produto,   
     ci.nm_produto_consulta,   
     ci.vl_unitario_item_consulta,   
    (ci.qt_item_consulta*ci.vl_unitario_item_consulta) as vl_total_item,   
     ci.qt_item_consulta,  
     c.ds_observacao_consulta,  
     ci.ds_observacao_fabrica,  
    (ci.vl_unitario_item_consulta * ci.qt_item_consulta) as 'vl_total',  
    (select top 1 nm_fantasia_vendedor from Vendedor v   
     where v.cd_vendedor = c.cd_vendedor_interno) as 'V_I',  
    (select top 1 nm_fantasia_vendedor from Vendedor v   
     where v.cd_vendedor = c.cd_vendedor) as 'V_E',  
    (select top 1 pvi1.cd_pedido_venda from pedido_venda_item pvi1  with (nolock) where pvi1.cd_consulta=ci.cd_consulta and pvi1.cd_item_consulta=ci.cd_item_consulta) as 'cd_pedido_venda',  
     (select top 1 pvi.cd_item_pedido_venda from pedido_venda_item pvi  with (nolock) where pvi.cd_consulta=ci.cd_consulta and pvi.cd_item_consulta=ci.cd_item_consulta) as 'cd_pedido_venda_item'  
  
  from  
     Consulta c  with (nolock)
  
  inner join Consulta_Itens ci  with (nolock) on   
  c.cd_consulta = ci.cd_consulta   
  
  inner join Cliente cli  with (nolock) on  
  c.cd_cliente = cli.cd_cliente  
  
  where  
     c.cd_consulta = @cd_consulta and  
     ci.cd_item_consulta = @cd_item_consulta  
  
end  

