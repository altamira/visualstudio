create procedure pr_consulta_produto_propaganda_proposta
  @cd_consulta int
as

	declare @ds_propaganda varchar(255)
	declare @ds_prod varchar(255)
	declare @item varchar(255)
	declare @cd_item int
	
	DECLARE cCursor CURSOR FOR
		select
		  i.cd_item_consulta,
		  Cast(pp.ds_propaganda as varchar(255)) ds_propaganda
		from
		  consulta_itens i
		    left outer join
		  Produto p
		    on i.cd_produto = p.cd_produto
        left outer join
      Propaganda pp
        on p.cd_propaganda = pp.cd_propaganda
		where
		  pp.ds_propaganda is not null and
		  cd_consulta = @cd_consulta
		order by ds_propaganda, cd_item_consulta

    create table #teste
    ( cd_item_consulta int,
      ds_propaganda	varchar(255))
	  truncate table #teste
	
begin
	OPEN cCursor 

	select 
	  @ds_prod = 
		  Cast(pp.ds_propaganda as varchar(255))
		from
		  consulta_itens i
		    left outer join
		  Produto p
		    on i.cd_produto = p.cd_produto
        left outer join
      Propaganda pp
        on p.cd_propaganda = pp.cd_propaganda
		where
		  pp.ds_propaganda is not null and
		  cd_consulta = @cd_consulta

  set @item = ''
	
	FETCH NEXT FROM cCursor INTO @cd_item, @ds_propaganda
	WHILE @@FETCH_STATUS = 0
	BEGIN
		  IF @ds_propaganda = @ds_prod
		    set @item = IsNull(@item,'') + ',' + LTrim(RTrim(Cast(@cd_item as varchar)))
		  Else Begin
		    insert into #Teste (cd_item_consulta, ds_propaganda)
	 	    values (0 ,Replace(cast(RTrim(LTrim('Item(s) ' + IsNull(@item,0) + ' - ' + IsNull(@ds_prod,''))) as varchar(255)), ' ,',''))
	      set @item = ''
		    set @item = IsNull(@item,'') + ',' + LTrim(RTrim(Cast(@cd_item as varchar)))
	      set @ds_prod = @ds_propaganda
	    end

	  FETCH NEXT FROM cCursor INTO @cd_item, @ds_propaganda
	END

  If Exists(select * from #teste)
	    insert into #Teste (cd_item_consulta, ds_propaganda)
 	    values (0 ,Replace(cast(RTrim(LTrim('Item(s) ' + IsNull(@item,0) + ' - ' + IsNull(@ds_propaganda,''))) as varchar(255)), ' ,',''))
	
	CLOSE cCursor
	DEALLOCATE cCursor
  select * from #teste
end
