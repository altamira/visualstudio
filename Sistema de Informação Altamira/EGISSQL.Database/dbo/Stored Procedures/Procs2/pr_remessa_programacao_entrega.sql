
-------------------------------------------------------------------------------
--sp_helptext pr_remessa_programacao_entrega
-------------------------------------------------------------------------------
--pr_remessa_programacao_entrega
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Controle de Remessa de Produtos
--                 : Programação de Entregas
--Data             : 17/09/2007
--Alteração        : 18.09.2007 - Complemento da Tabela gravação do Pedido Venda/Item
--                 : 20.09.2007 - Nota/Fiscal - Carlos Fernandes.
-- 30.05.2008 - Não mostrar nota fiscal cancelada - Carlos Fernandes
-- 17.09.2008 - Ajuste do Cancelamento - Carlos Fernandes
-------------------------------------------------------------------------------------

create procedure pr_remessa_programacao_entrega
@ic_parametro           int      = 0,
@cd_remessa_informada   int      = 0,
@cd_programacao_entrega float    = 0,
@cd_produto             int      = 0,
@qt_remessa_produto     float    = 0,
@dt_remessa_produto     datetime = '',
@cd_usuario             int      = 0

as

-----------------------------------------------------------

if @ic_parametro = 1
begin

  declare @Tabela	     varchar(80)
  declare @cd_remessa  int

  set @Tabela      = cast(DB_NAME()+'.dbo.Programacao_Entrega_Remessa' as varchar(80))
  set @cd_remessa  = 0

  -- campo chave utilizando a tabela de códigos
  exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_remessa', @codigo = @cd_remessa output

  while exists(Select top 1 'x' from programacao_entrega_remessa where cd_remessa = @cd_remessa)
  begin
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_remessa', @codigo = @cd_remessa output	     
    -- limpeza da tabela de código
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_remessa, 'D'
  end


  insert into programacao_entrega_remessa
  select
    @cd_remessa,
    @cd_programacao_entrega,
    @cd_produto,
    @qt_remessa_produto,
    @dt_remessa_produto,
    @cd_usuario,
    getdate(),
    null,
    null,
    null

  -- limpeza da tabela de código
  exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_remessa, 'D'

end

------------------------------------------------------------------------------
--Consulta
------------------------------------------------------------------------------

if @ic_parametro = 2
begin
  --select * from programacao_entrega
  select
    per.cd_remessa,
    per.cd_programacao_entrega,
    per.dt_remessa_produto,
    per.qt_remessa_produto,
    pe.dt_necessidade_entrega,
    pe.qt_programacao_entrega,
    p.cd_mascara_produto,
    p.nm_fantasia_produto,
    p.nm_produto,
    per.cd_pedido_venda,
    per.cd_item_pedido_venda,
    per.cd_previa_faturamento,	
    nsi.cd_nota_saida,
    nsi.cd_item_nota_saida,
    nsi.dt_nota_saida
  from
    Programacao_Entrega_Remessa per       with(nolock)
    inner join Programacao_Entrega pe     with(nolock) on pe.cd_programacao_entrega = per.cd_programacao_entrega
    inner join Produto p                  with(nolock) on p.cd_produto = pe.cd_produto

    left outer join Pedido_Venda_item pvi with(nolock) on pvi.cd_pedido_venda = per.cd_pedido_venda            and
                                                          pvi.cd_item_pedido_venda = per.cd_item_pedido_venda

    left outer join Nota_Saida_item nsi   with(nolock) on nsi.cd_pedido_venda      = pvi.cd_pedido_venda      and
                                                          nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda and
                                                          nsi.dt_restricao_item_nota is null and
                                                          nsi.dt_cancel_item_nota_saida is null

    left outer join Nota_Saida      ns    with(nolock) on ns.cd_nota_saida         = nsi.cd_nota_saida        and
                                                          ns.cd_status_nota        <> 7    --Nota Emitida
 
--select * from nota_saida 
--select * from status_nota
--select * from nota_saida_item
                                 
  where
    per.cd_programacao_entrega = case when @cd_programacao_entrega = 0 then per.cd_programacao_entrega else @cd_programacao_entrega end  
  order by
    per.dt_remessa_produto

end

------------------------------------------------------------------------------
--Exclusão
------------------------------------------------------------------------------
if @ic_parametro = 3
begin

  --Busca a Programação

  select @cd_programacao_entrega = isnull(cd_programacao_entrega,0) 
  from
    programacao_entrega_remessa 
  where
   cd_remessa = @cd_remessa_informada

  --select @cd_programacao_entrega

  --Deleta a Remessa
  delete from programacao_entrega_remessa where cd_remessa = @cd_remessa_informada

  --Atualiza o Saldo

  --select * from programacao_entrega
  if @cd_programacao_entrega>0
  begin

    declare @qt_total_remessa float

    select
      @qt_total_remessa =  sum( isnull(qt_remessa_produto,0) ) 
    from 
      programacao_entrega_remessa
    where
     cd_programacao_entrega = @cd_programacao_entrega 

    update
      programacao_entrega
    set
      qt_remessa_programacao = isnull(@qt_total_remessa,0),
      qt_saldo_programacao   = x.qt_programacao_entrega - isnull(@qt_total_remessa,0)

    from
      programacao_entrega x
    where
      x.cd_programacao_entrega = @cd_programacao_entrega

  end
 
end

------------------------------------------------------------------------------
--Alteração
------------------------------------------------------------------------------

if @ic_parametro = 4
begin
  --delete from programacao_entrega_remessa where cd_remessa = @cd_remessa_informada
  print ''
end

------------------------------------------------------------------------------
--Ajuste do Saldo
------------------------------------------------------------------------------
if @ic_parametro = 5
begin
  --print ''

  
  --select * from programacao_entrega
  if @cd_programacao_entrega>0
  begin
    update
      programacao_entrega
    set
      qt_remessa_programacao = isnull(( select sum( isnull(qt_remessa_produto,0)) from programacao_entrega_remessa
                                where
                                  cd_programacao_entrega = x.cd_programacao_entrega ),0),
      qt_saldo_programacao   = qt_programacao_entrega - qt_remessa_programacao
    from
      programacao_entrega x
    where
      x.cd_programacao_entrega = @cd_programacao_entrega
  end
 

end


