

CREATE     procedure [sp_PegaCodigoantiga]
@nm_tabela varchar(50),
@nm_campo varchar(50),
@codigo int output
as
  declare @comando varchar(8000)
  declare @cd_codigo int
  create table #teste (codigo int)
  -- Procura o menor código marcado como 'L'ivre
  if exists(select * from codigo where sg_status = 'L'  and nm_tabela = @nm_tabela)
    goto TrataCodLivre
  else
    if exists(select * from codigo where sg_status = 'A'  and nm_tabela = @nm_tabela) 
      goto TrataCodAtivo
    else
      goto TrataTabOriginal
  return
  
TrataCodLivre:
  begin transaction
  print('TrataCodLivre:')
  select @cd_codigo = isnull(min(cd_atual),0) 
    from Codigo tablock where sg_status = 'L'  and nm_tabela = @nm_tabela
  -- Checa se encontrou
  if @cd_codigo <> 0 
  begin
    -- encontrou, atualiza status pra "A"tivo
    update Codigo set sg_status = 'A' 
     where nm_tabela = @nm_tabela and
           cd_atual  = @cd_codigo
   
  end
  if @@ERROR = 0 
  begin
    Commit Tran
    set @codigo = @cd_codigo
    print(@codigo)
  end
  else
    RollBack Tran
return
TrataCodAtivo:    
  begin transaction
  print('TrataCodAtivo:')
  select @cd_codigo = isnull(max(cd_atual),0)+1 
    from Codigo tablock where sg_status = 'A'  and nm_tabela = @nm_tabela
  -- Checa se encontrou
  if @cd_codigo <> 0 
  begin
    create table #Codigo (cd_codigo int)
    set  @Comando = 'insert into #Codigo select isnull(max('+@nm_campo+'),0) from ' + @nm_tabela
    exec(@Comando)
    
    if @cd_codigo <= (select cd_codigo from #Codigo)
    begin
      set @cd_codigo = (select cd_codigo from #Codigo) + 1
      insert into Codigo (nm_tabela, cd_atual, sg_status)
      values (@nm_tabela, @cd_codigo, 'A')         
    end
    else
      -- encontrou, atualiza status pra "A"tivo
      insert into Codigo (nm_tabela, cd_atual, sg_status)
      values (@nm_tabela, @cd_codigo, 'A')     
     
  end
  if @@ERROR = 0 
  begin
    Commit Tran
    set @codigo = @cd_codigo
    print(@codigo)
  end
  else
    RollBack Tran
     
return
TrataTabOriginal:
  begin transaction
  print('TrataTabOriginal:')
  -- Se nao encontrou, gera um novo código
  set @Comando = 'INSERT INTO #TESTE (CODIGO) ' +
                 'SELECT  ISNULL(MAX(' + @nm_campo + '),0)+1 ' +
                 'FROM ' + @nm_tabela + ' TABLOCK '
   
  exec(@Comando) 
  select @cd_codigo = Codigo from #TESTE
  insert into Codigo (nm_tabela, cd_atual, sg_status)
       values (@nm_tabela, @cd_codigo, 'A')
  if @@ERROR = 0 
  begin
    Commit Tran
    set @codigo = @cd_codigo
    print(@codigo)
  end
  else
    RollBack Tran
     
return


