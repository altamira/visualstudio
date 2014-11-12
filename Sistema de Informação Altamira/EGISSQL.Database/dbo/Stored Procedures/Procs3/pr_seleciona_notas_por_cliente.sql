

/****** Object:  Stored Procedure dbo.pr_seleciona_notas_por_cliente    Script Date: 13/12/2002 15:08:42 ******/

CREATE  procedure pr_seleciona_notas_por_cliente
  (
    @nm_fantasia varchar(40), @dt_inicio  datetime,
    @dt_termino datetime
  ) as
declare
   @qt_itens int, @qt_duplicata int, @vl_total money,
   @cd_nota int, @dt_saida datetime, @nm_operacao varchar(40),
   @nm_vendedor_interno varchar(40), @nm_vendedor_externo varchar(40)

declare
   cur_nota_cliente cursor local static for
   select cd_nota_saida, dt_nota_saida, o.nm_operacao_fiscal,
          vl_total
     from nota_saida n, operacao_fiscal o
    where o.cd_operacao_fiscal = n.cd_operacao_fiscal
      and @nm_fantasia  = nm_fantasia_nota_saida
      and dt_nota_saida between @dt_inicio and @dt_termino
begin
 
  create table #selecao_notas_por_cliente
  (
    cd_nota_saida int,
    dt_nota_saida datetime,
    nm_operacao_fiscal varchar(40),
    va_total_nota_saida money,
    qt_itens int,
    qt_duplicatas int,
    nm_vendedor_interno varchar(40),
    nm_vendedor_externo varchar(40)
    primary key (cd_nota_saida)
  )

  open cur_nota_cliente
  
  fetch next from cur_nota_cliente into
     @cd_nota, @dt_saida, @nm_operacao, @vl_total

  while @@fetch_status = 0
  begin
    select @qt_itens = count(*)
      from nota_saida_item
     where cd_nota_saida = @cd_nota

    select @qt_duplicata = 0
    
    insert into #selecao_notas_por_cliente
    values
    (    
      @cd_nota,
      @dt_saida,
      @nm_operacao,
      @vl_total,
      @qt_itens,
      @qt_duplicata,
      @nm_vendedor_interno,
      @nm_vendedor_externo
    )  
    fetch next from cur_nota_cliente into
       @cd_nota, @dt_saida, @nm_operacao, @vl_total
  end

  close cur_nota_cliente
  deallocate cur_nota_cliente

  select * from #selecao_notas_por_cliente
  drop table #selecao_notas_por_cliente
end



