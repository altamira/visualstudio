
-------------------------------------------------------------------------------
--sp_helptext pr_Consulta_nota_etiqueta_pedido
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : David Becker
--Banco de Dados   : Egissql
--Objetivo         : Emissão de Etiqueta para Item da Nota
--Data             : 14-05-2010
----------------------------------------------------------------------------------------------
create procedure pr_Consulta_nota_etiqueta_pedido
@ic_parametro         int      = 0,
@cd_pedido_venda      int      = 0,
--@cd_pedido_venda_item int      = 0,
@dt_inicial           datetime = '',
@dt_final             datetime = ''

as

declare @ic_tipo char(1)
declare @dt_hoje datetime

set @dt_hoje = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)


if @ic_parametro = 1 --Não Impressas
begin
  set @ic_tipo      = 'N'   
end

if @ic_parametro = 2 --Reimpressão
begin
  set @ic_tipo      = 'S'
end

 --Nota Fiscal
  -- select * from nota_saida
  -- select * from pedido_venda 
  select
    0                                                       as Selecao,
    pv.cd_pedido_venda                                      as Pedido_Venda,
    pv.dt_pedido_venda                                      as Emissao,
    ns.nm_fantasia_nota_saida                               as Destinatario,
    pv.vl_total_pedido_venda                                as Total_pedido_venda,
    u.nm_fantasia_usuario                                   as Usuario,
    '('+ns.cd_ddd_nota_saida+')-'+ns.cd_telefone_nota_saida as Telefone,
--     ns.sg_estado_nota_saida,
    ns.nm_cidade_nota_saida                                 as Cidade_Nota_Saida_Pedido,
    pv.dt_cancelamento_pedido                               as Dt_Cancelamento_Pedido,
    pv.ic_etiq_emb_pedido_venda                             as Etiqueta_Pedido_Venda
--     ns.qt_peso_liq_nota_saida,
--     ns.qt_peso_bruto_nota_saida,
--     ns.qt_volume_nota_saida           

-- select * from nota_saida
    
  from
    Pedido_Venda  pv                        with (nolock) 
    left outer join egisadmin.dbo.Usuario u with (nolock) on u.cd_usuario = pv.cd_usuario
    left outer join cliente c               with (nolock) on c.cd_cliente = pv.cd_cliente
    left outer join nota_saida ns           with (nolock) on ns.cd_pedido_venda = pv.cd_pedido_venda    
  where
    
    pv.cd_pedido_venda = case when @cd_pedido_venda=0 then pv.cd_pedido_venda else @cd_pedido_venda end and
    pv.dt_pedido_venda between @dt_inicial and @dt_final and
    pv.dt_cancelamento_pedido is null                    and --Somente as Nota não Canceladas
    isnull(pv.ic_etiq_emb_pedido_venda,'N') = @ic_tipo       --Etiquetas não impressas p/ Impressão ou Reimpressão

------------------------------------------------------------------------------
--Testando a Stored Procedure
------------------------------------------------------------------------------
--Pedido de Venda
--exec pr_Consulta_nota_etiqueta_pedido 0,0,'12/01/2004','14/05/2010'

----------------------------------------------------------------------------
-- exec pr_Consulta_nota_etiqueta_pedido 0,0,'05/01/2006','06/30/2010'
-- exec pr_Consulta_nota_etiqueta_pedido 1,0,'05/01/2006','06/30/2010'
-- exec pr_Consulta_nota_etiqueta_pedido 2,0,'05/01/2006','06/30/2010'
--exec dbo.pr_Consulta_nota_etiqueta_pedido  @ic_parametro = 1, @cd_pedido_venda = 0, @dt_inicial = '2006/05/01', @dt_final = '2010/05/31'
-- exec dbo.pr_Consulta_nota_etiqueta_pedido  @ic_parametro = 2, @cd_pedido_venda = 0, @dt_inicial = '2006/05/01', @dt_final = '2010/05/31'
-- -exec dbo.pr_Consulta_nota_etiqueta_pedido  @ic_parametro = , @cd_pedido_venda = 0, @dt_inicial = '2003/01/01', @dt_final = '2010/05/31'
-- 
-- exec dbo.pr_Consulta_nota_etiqueta_pedido  @ic_parametro = 1, @cd_pedido_venda = 0, @dt_inicial = 'jan  1 2009 12:00AM', @dt_final = 'mai 31 2010 12:00AM'
-- exec dbo.pr_Consulta_nota_etiqueta_pedido  @ic_parametro = 2, @cd_pedido_venda = 0, @dt_inicial = '2003/01/01', @dt_final = '2010/05/31'
--exec dbo.pr_Consulta_nota_etiqueta_pedido  @ic_parametro = 1, @cd_pedido_venda = 0, @dt_inicial = '2009/01/01', @dt_final = '2010/05/31'