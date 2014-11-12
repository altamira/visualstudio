
CREATE PROCEDURE pr_alterar_vendedor_cliente

---------------------------------------------------
--pr_alterar_vendedor_cliente
---------------------------------------------------
--POLIMOLD Industrial S/A
---------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)      : Fabio Cesar
--Banco de Dados : EgisSql
--Criação        : 25.01.2006
--Objetivo       : Realizar o procedimento de mudança do vendedor para o cliente
--------------------------------------------------------------------------------------------
@cd_vendedor_filtro int,
@cd_tipo_vendedor_filtro int,
@cd_vendedor_atualizacao int, 
@cd_tipo_vendedor_atualizacao int,
@cd_usuario int = 0,
@nm_usuario varchar(50) = ''
AS
Begin

  declare
    @cd_cliente int,
    @nm_vendedor_interno varchar(50),
    @nm_vendedor_externo varchar(50),
    @nm_vendedor_historico varchar(50),
    @nm_novo_vendedor varchar(50),
    @qt_atualizado int,
    @dt_atualizacao datetime

  set @qt_atualizado = 0

  Select top 1
    @nm_novo_vendedor = nm_vendedor
  from 
    Vendedor with (nolock)
  where
    cd_vendedor = @cd_vendedor_atualizacao

  --Define os clientes que serão atualizados

  DECLARE Cliente_Cursor CURSOR FOR 
  Select
     c.cd_cliente,
     vi.nm_vendedor as nm_vendedor_interno,
     ve.nm_vendedor as nm_vendedor_externo
  from
     Cliente c with (nolock)
     Left outer join Vendedor vi with (nolock)
       on c.cd_vendedor_interno = vi.cd_vendedor
     Left outer join Vendedor ve with (nolock)
       on c.cd_vendedor = ve.cd_vendedor   
  where
     ( c.cd_vendedor = @cd_vendedor_filtro and @cd_tipo_vendedor_filtro <> 1) 
  UNION ALL
  Select
     c.cd_cliente,
     vi.nm_vendedor as nm_vendedor_interno,
     ve.nm_vendedor as nm_vendedor_externo
  from
     Cliente c with (nolock)
     Left outer join Vendedor vi with (nolock)
       on c.cd_vendedor_interno = vi.cd_vendedor
     Left outer join Vendedor ve with (nolock)
       on c.cd_vendedor = ve.cd_vendedor   
  where
     ( c.cd_vendedor_interno = @cd_vendedor_filtro and @cd_tipo_vendedor_filtro = 1)
  
  OPEN Cliente_Cursor
  
  FETCH NEXT FROM Cliente_Cursor 
  INTO @cd_cliente, @nm_vendedor_interno, @nm_vendedor_externo
  

  BEGIN TRANSACTION

  select @dt_atualizacao = getdate()

  WHILE @@FETCH_STATUS = 0
  BEGIN

    set @qt_atualizado = @qt_atualizado + 1

    if ( @cd_tipo_vendedor_atualizacao = 1 )
    begin
      --Atualiza o vendedor interno para o cliente
      update cliente
      set cd_vendedor_interno = @cd_vendedor_atualizacao
      where cd_cliente = @cd_cliente 

      set @nm_vendedor_historico = @nm_vendedor_interno

    end
    else
    begin
      --Atualiza o vendedor interno para o cliente
      update cliente
      set cd_vendedor = @cd_vendedor_atualizacao
      where cd_cliente = @cd_cliente 

      set @nm_vendedor_historico = @nm_vendedor_externo

    end

    --Verifica se foi definido o vendedor na tabela Cliente_Vendedor
    if not exists(Select 'x' from Cliente_Vendedor 
                  where cd_cliente = @cd_cliente and cd_tipo_vendedor = @cd_tipo_vendedor_atualizacao )
      Insert into Cliente_Vendedor
        (cd_cliente, cd_vendedor, cd_cliente_vendedor, cd_tipo_vendedor)
      values
        (@cd_cliente, @cd_vendedor_atualizacao, 1, @cd_tipo_vendedor_atualizacao)
    else
      Update Cliente_Vendedor
      set 
        cd_vendedor = @cd_vendedor_atualizacao
      where
        cd_cliente = @cd_cliente and cd_tipo_vendedor = @cd_tipo_vendedor_atualizacao


  
    insert into Cliente_Historico  
      ( cd_cliente, dt_historico_lancamento, cd_sequencia_historico,
        cd_usuario, dt_usuario, nm_assunto, ds_historico_lancamento)
    values 
      ( @cd_cliente, getdate(), 1,
        @cd_usuario, getdate(), 'Alteração do Vendedor.', 
        'Alteração automática do Vendedor ' + @nm_vendedor_historico + ' para ' 
        + @nm_novo_vendedor + ' pelo usuário ' + @nm_usuario + ' em ' + cast(datepart(dd, @dt_atualizacao) as varchar) 
        + '/' + cast(datepart(mm,@dt_atualizacao) as varchar) + '/' + cast(datepart(yyyy,@dt_atualizacao) as varchar))

    FETCH NEXT FROM Cliente_Cursor 
    INTO @cd_cliente, @nm_vendedor_interno, @nm_vendedor_externo
  END

  IF @@ERROR != 0
     ROLLBACK TRANSACTION
  ELSE
     COMMIT TRANSACTION

  CLOSE Cliente_Cursor
  DEALLOCATE Cliente_Cursor
end
  
