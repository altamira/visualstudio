
CREATE PROCEDURE pr_ConsultaValidadeProposta

  @ic_parametro        integer, --Define se serão filtradas todas (1), Atrasadas (2), a Vencer (3)
  @cd_consulta         integer,  --Define se será filtrada uma proposta específica
  @nm_fantasia_cliente varchar(30), --Define se irá ser filtrado por um cliente
  @dt_inicial          datetime, --Data inicial de análise
  @dt_final            datetime    --Data final de análise
AS

Begin

    declare @sSQL                     varchar(2000)
    declare @qt_dia_validade_proposta int

    set @sSQL = ''    

    --Define os filtros passados

    set @sSQL = 'c.dt_consulta between ' + quotename(cast(@dt_inicial as varchar),'''') + ' and ' + quotename(cast(@dt_final as varchar),'''')

    Select 
        @qt_dia_validade_proposta = IsNull(qt_dia_validade_proposta,0)
    From 
        Parametro_comercial with (nolock) 
    where
        cd_empresa = dbo.fn_empresa()
        
    --Por Código da consulta

    if @cd_consulta > 0
    begin
       if @sSQL != '' 
          set @sSQL = @sSQL + ' and '
       set @sSQL = @sSQL + 'c.cd_consulta = ' + cast(@cd_consulta as varchar)
    end

    --somente atrasados ou os a vencer
    if @ic_parametro = 2
    begin
       if @sSQL != '' 
          set @sSQL = @sSQL + ' and '
       set @sSQL = @sSQL+ ' DATEDIFF (dd , c.dt_consulta , getdate()) > ' + cast(@qt_dia_validade_proposta as varchar(3)) 
    end else if @ic_parametro = 3
    begin
       if @sSQL != '' 
          set @sSQL = @sSQL + ' and '
       set @sSQL = @sSQL+ ' DATEDIFF (dd , c.dt_consulta , getdate()) <= ' + cast(@qt_dia_validade_proposta as varchar(3))
    end


    --Por Nome Fantasia do cliente
    if @nm_fantasia_cliente != ''
    begin
       if @sSQL != '' 
          set @sSQL = @sSQL + ' and '
       set @sSQL = @sSQL + 'cli.nm_fantasia_cliente like ' + QuoteName(@nm_fantasia_cliente + '%','''')
    end

    if @sSQL != '' 
       set @sSQL = ' Where ' + @sSQL
    

    exec ('Select
      c.cd_consulta,
      c.dt_consulta,
      cli.nm_fantasia_cliente,
      cli.cd_ddd,
      cli.cd_telefone,
      vend.nm_fantasia_vendedor,
      cont.nm_fantasia_contato,
      c.vl_total_consulta,
      c.vl_sedex_consulta,
      c.vl_total_ipi,
      (c.vl_total_consulta / (1 - (IsNull(c.pc_desconto_consulta,0)/100))) as vl_total_consulta_bruto,
      IsNull(c.pc_desconto_consulta,0) as pc_desconto_consulta,
      '+ @qt_dia_validade_proposta + ' + 
      case 
         when (c.dt_consulta > getdate()) then  DATEDIFF (dd , c.dt_consulta , getdate() )
      else (-1 * DATEDIFF (dd , c.dt_consulta , getdate() ))
      end as qt_dias,' + @qt_dia_validade_proposta + ' as qt_dia_validade,
      sp.nm_status_proposta
    From
      Consulta c with (nolock) 
    left outer join Cliente cli on  c.cd_cliente = cli.cd_cliente
    left outer join Status_Proposta sp on sp.cd_status_proposta = c.cd_status_proposta
    left outer join Vendedor vend on  c.cd_vendedor_interno = vend.cd_vendedor
    left outer join Cliente_Contato Cont
    on  c.cd_cliente = cont.cd_cliente and c.cd_contato = cont.cd_contato ' + @sSQL
    + ' order by c.dt_consulta')

end

