
CREATE PROCEDURE sp_PegaCodigo



-- OBS: ANTES DE ALTERAR ESTA PROCEDURE CRIAR AS NOVAS TABELAS
-- ATRAVÉS DOS COMANDOS:
/*

  SELECT * INTO CODIGO_ME FROM CODIGO WHERE NM_TABELA LIKE '%MOVIMENTO_ESTOQUE%'
  SELECT * INTO CODIGO_PVH FROM CODIGO WHERE NM_TABELA LIKE '%PEDIDO_VENDA_HISTORICO%'
  SELECT * INTO CODIGO_PCH FROM CODIGO WHERE NM_TABELA LIKE '%PEDIDO_COMPRA_HISTORICO%'
  SELECT * INTO CODIGO_PV FROM CODIGO WHERE NM_TABELA LIKE '%PEDIDO_VENDA'
  SELECT * INTO CODIGO_PC FROM CODIGO WHERE NM_TABELA LIKE '%PEDIDO_COMPRA'
  SELECT * INTO CODIGO_CS FROM CODIGO WHERE NM_TABELA LIKE '%CONSULTA'
  SELECT * INTO CODIGO_CT FROM CODIGO WHERE NM_TABELA LIKE '%COTACAO'

  ALTER TABLE CODIGO_ME DROP CONSTRAINT PK_CODIGO_ME
  ALTER TABLE CODIGO_PCH DROP CONSTRAINT PK_CODIGO_PCH
  ALTER TABLE CODIGO_PVH DROP CONSTRAINT PK_CODIGO_PVH
  ALTER TABLE CODIGO_PV DROP CONSTRAINT PK_CODIGO_PV
  ALTER TABLE CODIGO_PC DROP CONSTRAINT PK_CODIGO_PC
  ALTER TABLE CODIGO_CS DROP CONSTRAINT PK_CODIGO_CS
  ALTER TABLE CODIGO_CT DROP CONSTRAINT PK_CODIGO_CT

  ALTER TABLE CODIGO_ME ADD CONSTRAINT PK_CODIGO_ME PRIMARY KEY(CD_ATUAL)
  ALTER TABLE CODIGO_PCH ADD CONSTRAINT PK_CODIGO_PCH PRIMARY KEY(CD_ATUAL)
  ALTER TABLE CODIGO_PVH ADD CONSTRAINT PK_CODIGO_PVH PRIMARY KEY(CD_ATUAL)
  ALTER TABLE CODIGO_PV ADD CONSTRAINT PK_CODIGO_PV PRIMARY KEY(CD_ATUAL)
  ALTER TABLE CODIGO_PC ADD CONSTRAINT PK_CODIGO_PC PRIMARY KEY(CD_ATUAL)
  ALTER TABLE CODIGO_CS ADD CONSTRAINT PK_CODIGO_CS PRIMARY KEY(CD_ATUAL)
  ALTER TABLE CODIGO_CT ADD CONSTRAINT PK_CODIGO_CT PRIMARY KEY(CD_ATUAL)

  ALTER TABLE CODIGO_ME ALTER COLUMN NM_TABELA VARCHAR(100) NULL
  ALTER TABLE CODIGO_PVH ALTER COLUMN NM_TABELA VARCHAR(100) NULL
  ALTER TABLE CODIGO_PCH ALTER COLUMN NM_TABELA VARCHAR(100) NULL
  ALTER TABLE CODIGO_PV ALTER COLUMN NM_TABELA VARCHAR(100) NULL
  ALTER TABLE CODIGO_PC ALTER COLUMN NM_TABELA VARCHAR(100) NULL
  ALTER TABLE CODIGO_CS ALTER COLUMN NM_TABELA VARCHAR(100) NULL
  ALTER TABLE CODIGO_CT ALTER COLUMN NM_TABELA VARCHAR(100) NULL

*/

@nm_tabela varchar(60),
@nm_campo varchar(50),
@codigo int output
as

  set nocount on

  declare @cd_codigo int
  set @cd_codigo = null

  declare @Comando varchar(1000)

  -----------------------------------------------------------------------------
  if (@nm_campo = 'CD_MOVIMENTO_ESTOQUE')   -- SOMENTE QUANDO MOVIMENTO_ESTOQUE 
  -----------------------------------------------------------------------------
  begin

	  -- Tentar pegar o primeiro código com status "Livre"
	  Update
	    Codigo_ME --with (TABLOCK,HOLDLOCK)
	  Set
	    sg_status = 'A',
	    @cd_codigo = Codigo_ME.cd_atual
	  From
	    Codigo_ME
	    inner join ( Select top 1
	                   c.cd_atual,
	                   c.sg_status
	                 from
	                   Codigo_ME c
	                 where
	                   ( c.sg_status = 'L' )
	                 order by
	                   c.cd_atual ) PrimeiroCodigo
	     on ( PrimeiroCodigo.cd_atual = Codigo_ME.cd_atual )

	  if ( @cd_codigo is null )
	  begin
    	
	    -- Pega o que seria o próximo Código após o último Ativo
	    Select @cd_codigo = isnull( MAX( c.cd_atual ), 0 ) 
	    From Codigo_ME c --(TABLOCK,HOLDLOCK)
	    Where ( c.sg_status = 'A' )
	
	    -- Insere um novo registro Ativo. O valor do código será o próximo
	    -- na tabela caso o mesmo seja maior que o próximo na tabela de
	    -- códigos 
	    set @Comando =
	      'Select ' +
	        ' case when IsNull( MAX( ' + @nm_campo + ' ), 0 ) > ' +
	           cast(@cd_codigo as varchar) + ' then ' +
	           'IsNull( MAX( ' + @nm_campo + ' ), 0 ) + 1 ' +
	        ' else ' +
	           cast(@cd_codigo + 1 as varchar) +
	        ' end, ' +
	        '''A'' ' +
	      'From ' +
	        @nm_tabela + ' ' +
	      'Where ' +
	        @nm_campo + ' > ' + cast(@cd_codigo as varchar)

	    Insert
	      Codigo_ME ( cd_atual, sg_status ) 
	    Execute
	      ( @Comando ) 
	
	    -- Agora sim, pegar o próximo disponível
	    Select @cd_codigo = MAX( c.cd_atual )
	    From Codigo_ME c
	    Where ( c.sg_status = 'A' )

	  end

  end
  -----------------------------------------------------------------------------
  else if (@nm_campo = 'CD_PEDIDO_VENDA_HISTORICO')   -- SOMENTE QUANDO HISTORICO DE VENDA 
  -----------------------------------------------------------------------------
  begin

	  -- Tentar pegar o primeiro código com status "Livre"
	  Update
	    Codigo_PVH -- with (TABLOCK,HOLDLOCK)
	  Set
	    sg_status = 'A',
	    @cd_codigo = Codigo_PVH.cd_atual
	  From
	    Codigo_PVH
	    inner join ( Select top 1
	                   c.cd_atual,
	                   c.sg_status
	                 from
	                   Codigo_PVH c
	                 where
	                   ( c.sg_status = 'L' )
	                 order by
	                   c.cd_atual ) PrimeiroCodigo
	     on ( PrimeiroCodigo.cd_atual = Codigo_PVH.cd_atual )
	
	  if ( @cd_codigo is null )
	  begin
	
	    -- Pega o que seria o próximo Código após o último Ativo
	    Select @cd_codigo = isnull( MAX( c.cd_atual ), 0 )
	    From Codigo_PVH c -- (TABLOCK,HOLDLOCK)
	    Where ( c.sg_status = 'A' )
	
	    -- Insere um novo registro Ativo. O valor do código será o próximo
	    -- na tabela caso o mesmo seja maior que o próximo na tabela de
	    -- códigos 
	    set @Comando =
	      'Select ' +
	        ' case when IsNull( MAX( ' + @nm_campo + ' ), 0 ) > ' +
	           cast(@cd_codigo as varchar) + ' then ' +
	           'IsNull( MAX( ' + @nm_campo + ' ), 0 ) + 1 ' +
	        ' else ' +
	           cast(@cd_codigo + 1 as varchar) +
	        ' end, ' +
	        '''A'' ' +
	      'From ' +
	        @nm_tabela + ' ' +
	      'Where ' +
	        @nm_campo + ' > ' + cast(@cd_codigo as varchar)

	    Insert
	      Codigo_PVH ( cd_atual, sg_status ) 
	    Execute
	      ( @Comando ) 
	
	    -- Agora sim, pegar o próximo disponível
	    Select @cd_codigo = MAX( c.cd_atual )
	    From Codigo_PVH c
	    Where ( c.sg_status = 'A' )
	
	  end

  end
  -----------------------------------------------------------------------------
  else if (@nm_campo = 'CD_PEDIDO_COMPRA_HISTOR') -- SOMENTE QUANDO HISTORICO DO PC
  -----------------------------------------------------------------------------
  begin

	  -- Tentar pegar o primeiro código com status "Livre"
	  Update
	    Codigo_PCH -- with (TABLOCK,HOLDLOCK)
	  Set
	    sg_status = 'A',
	    @cd_codigo = Codigo_PCH.cd_atual
	  From
	    Codigo_PCH
	    inner join ( Select top 1
	                   c.cd_atual,
	                   c.sg_status
	                 from
	                   Codigo_PCH c
	                 where
	                   ( c.sg_status = 'L' ) 
	                 order by
	                   c.cd_atual ) PrimeiroCodigo
	     on ( PrimeiroCodigo.cd_atual = Codigo_PCH.cd_atual )
	
	  if ( @cd_codigo is null )
	  begin
	
	    -- Pega o que seria o próximo Código após o último Ativo
	    Select @cd_codigo = isnull( MAX( c.cd_atual ), 0 )
	    From Codigo_PCH c -- (TABLOCK,HOLDLOCK)
	    Where ( c.sg_status = 'A' )
	
	    -- Insere um novo registro Ativo. O valor do código será o próximo
	    -- na tabela caso o mesmo seja maior que o próximo na tabela de
	    -- códigos 
	    set @Comando =
	      'Select ' +
	        ' case when IsNull( MAX( ' + @nm_campo + ' ), 0 ) > ' +
	           cast(@cd_codigo as varchar) + ' then ' +
	           'IsNull( MAX( ' + @nm_campo + ' ), 0 ) + 1 ' +
	        ' else ' +
	           cast(@cd_codigo + 1 as varchar) +
	        ' end, ' +
	        '''A'' ' +
	      'From ' +
	        @nm_tabela + ' ' +
	      'Where ' +
	        @nm_campo + ' > ' + cast(@cd_codigo as varchar)

	    Insert
	      Codigo_PCH ( cd_atual, sg_status ) 
	    Execute
	      ( @Comando ) 
	
	    -- Agora sim, pegar o próximo disponível
	    Select @cd_codigo = MAX( c.cd_atual )
	    From Codigo_PCH c
	    Where ( c.sg_status = 'A' )
	
	  end

  end
  -----------------------------------------------------------------------------
  else if (@nm_campo = 'CD_PEDIDO_VENDA') -- SOMENTE QUANDO PEDIDO DE VENDA
  -----------------------------------------------------------------------------
  begin

	  -- Tentar pegar o primeiro código com status "Livre"
	  Update
	    Codigo_PV -- with (TABLOCK,HOLDLOCK)
	  Set
	    sg_status = 'A',
	    @cd_codigo = Codigo_PV.cd_atual
	  From
	    Codigo_PV
	    inner join ( Select top 1
	                   c.cd_atual,
	                   c.sg_status,
                           c.nm_tabela
	                 from
	                   Codigo_PV c
	                 where
	                   ( c.sg_status = 'L' )
	                 order by
	                   c.cd_atual ) PrimeiroCodigo
	     on ( PrimeiroCodigo.cd_atual = Codigo_PV.cd_atual ) 
         where Codigo_PV.nm_tabela like @nm_tabela
	
	  if ( @cd_codigo is null )
	  begin
	
	    -- Pega o que seria o próximo Código após o último Ativo
	    Select @cd_codigo = isnull( MAX( c.cd_atual ), 0 )
	    From Codigo_PV c -- (TABLOCK,HOLDLOCK)
	    Where ( c.sg_status = 'A' ) and
    		(c.nm_tabela like @nm_tabela)
	
	    -- Insere um novo registro Ativo. O valor do código será o próximo
	    -- na tabela caso o mesmo seja maior que o próximo na tabela de
	    -- códigos 
	    set @Comando =
	      'Select ' +
	        ' case when IsNull( MAX( ' + @nm_campo + ' ), 0 ) > ' +
	           cast(@cd_codigo as varchar) + ' then ' +
	           'IsNull( MAX( ' + @nm_campo + ' ), 0 ) + 1 ' +
	        ' else ' +
	           cast(@cd_codigo + 1 as varchar) +
	        ' end, ' +
	        '''A'' ' +
		', '''+@nm_tabela +''' ' +
	      'From ' +
	        @nm_tabela + ' ' +
	      'Where ' +
	        @nm_campo + ' > ' + cast(@cd_codigo as varchar)

	    Insert
	      Codigo_PV ( cd_atual, sg_status, nm_tabela )  
	    Execute
	      ( @Comando ) 
	
	    -- Agora sim, pegar o próximo disponível
	    Select @cd_codigo = MAX( c.cd_atual )
	    From Codigo_PV c
	    Where ( c.sg_status = 'A' ) and
				(c.nm_tabela like @nm_tabela)

	  end

  end
  -----------------------------------------------------------------------------
  else if (@nm_campo = 'CD_PEDIDO_COMPRA') -- SOMENTE QUANDO PEDIDO DE COMPRA
  -----------------------------------------------------------------------------
  begin

	  -- Tentar pegar o primeiro código com status "Livre"
	  Update
	    Codigo_PC -- with (TABLOCK,HOLDLOCK)
	  Set
	    sg_status = 'A',
	    @cd_codigo = Codigo_PC.cd_atual
	  From
	    Codigo_PC
	    inner join ( Select top 1
	                   c.cd_atual,
	                   c.sg_status,
							 nm_tabela	
	                 from
	                   Codigo_PC c
	                 where
	                   ( c.sg_status = 'L' ) and
							 (c.nm_tabela like @nm_tabela)
	                 order by
	                   c.cd_atual ) PrimeiroCodigo
	     on ( PrimeiroCodigo.cd_atual = Codigo_PC.cd_atual and isnull(PrimeiroCodigo.nm_tabela, '') = isnull(Codigo_PC.nm_tabela, '') )
	
	  if ( @cd_codigo is null )
	  begin
	
	    -- Pega o que seria o próximo Código após o último Ativo
	    Select @cd_codigo = isnull( MAX( c.cd_atual ), 0 )
	    From Codigo_PC c -- (TABLOCK,HOLDLOCK)
	    Where ( c.sg_status = 'A' ) and
				(c.nm_tabela like @nm_tabela)
	
	    -- Insere um novo registro Ativo. O valor do código será o próximo
	    -- na tabela caso o mesmo seja maior que o próximo na tabela de
	    -- códigos 
	    set @Comando =
	      'Select ' +
	        ' case when IsNull( MAX( ' + @nm_campo + ' ), 0 ) > ' +
	           cast(@cd_codigo as varchar) + ' then ' +
	           'IsNull( MAX( ' + @nm_campo + ' ), 0 ) + 1 ' +
	        ' else ' +
	           cast(@cd_codigo + 1 as varchar) +
	        ' end, ' +
	        '''A'' ' +
			+ ', '''+@nm_tabela +''' ' +
	      'From ' +
	        @nm_tabela + ' ' +
	      'Where ' +
	        @nm_campo + ' > ' + cast(@cd_codigo as varchar) 
	    print @Comando
	    Insert
	      Codigo_PC ( cd_atual, sg_status, nm_tabela ) 
	    Execute
	      ( @Comando ) 
	
	    -- Agora sim, pegar o próximo disponível
	    Select @cd_codigo = MAX( c.cd_atual )
	    From Codigo_PC c
	    Where ( c.sg_status = 'A' ) and
				(c.nm_tabela like @nm_tabela)
	
	  end

  end
  -----------------------------------------------------------------------------
  else if (@nm_campo = 'CD_CONSULTA') -- SOMENTE QUANDO CONSULTA (PROPOSTA)
  -----------------------------------------------------------------------------
  begin

	  -- Tentar pegar o primeiro código com status "Livre"
	  Update
	    Codigo_CS -- with (TABLOCK,HOLDLOCK)
	  Set
	    sg_status = 'A',
	    @cd_codigo = Codigo_CS.cd_atual
	  From
	    Codigo_CS
	    inner join ( Select top 1
	                   c.cd_atual,
	                   c.sg_status,
							 nm_tabela	
	                 from
	                   Codigo_CS c
	                 where
	                   ( c.sg_status = 'L' ) and
							 (c.nm_tabela like @nm_tabela)
	                 order by
	                   c.cd_atual ) PrimeiroCodigo
	     on ( PrimeiroCodigo.cd_atual = Codigo_CS.cd_atual and isnull(PrimeiroCodigo.nm_tabela, '') = isnull(Codigo_CS.nm_tabela, '') )
       
	  Print @cd_codigo
     Print @nm_tabela
	  if ( @cd_codigo is null )
	  begin
	
	    -- Pega o que seria o próximo Código após o último Ativo
	    Select @cd_codigo = isnull( MAX( c.cd_atual ), 0 )
	    From Codigo_CS c -- (TABLOCK,HOLDLOCK)
	    Where ( c.sg_status = 'A' ) and
				(c.nm_tabela like @nm_tabela)

       Print 'Passo 2'
       Print @cd_codigo
       Print @nm_tabela
	    -- Insere um novo registro Ativo. O valor do código será o próximo
	    -- na tabela caso o mesmo seja maior que o próximo na tabela de
	    -- códigos 
	    set @Comando =
	      'Select ' +
	        ' case when IsNull( MAX( ' + @nm_campo + ' ), 0 ) > ' +
	           cast(@cd_codigo as varchar) + ' then ' +
	           'IsNull( MAX( ' + @nm_campo + ' ), 0 ) + 1 ' +
	        ' else ' +
	           cast(@cd_codigo + 1 as varchar) +
	        ' end, ' +
	        '''A'' ' +
			+ ', '''+@nm_tabela +''' ' +
	      'From ' +
	        @nm_tabela + ' ' +
	      'Where ' +
	        @nm_campo + ' > ' + cast(@cd_codigo as varchar) 
Print @Comando
	    Insert
	      Codigo_CS ( cd_atual, sg_status, nm_tabela ) 
	    Execute
	      ( @Comando ) 
	
	    -- Agora sim, pegar o próximo disponível
	    Select @cd_codigo = MAX( c.cd_atual )
	    From Codigo_CS c
	    Where ( c.sg_status = 'A' )and
				(c.nm_tabela like @nm_tabela)
	
	  end
  end
  -----------------------------------------------------------------------------
  else if (@nm_campo = 'CD_COTACAO') -- SOMENTE QUANDO COTAÇÃO DE COMPRA
  -----------------------------------------------------------------------------
  begin

	  -- Tentar pegar o primeiro código com status "Livre"
	  Update
	    Codigo_CT -- with (TABLOCK,HOLDLOCK)
	  Set
	    sg_status = 'A',
	    @cd_codigo = Codigo_CT.cd_atual
	  From
	    Codigo_CT
	    inner join ( Select top 1
	                   c.cd_atual,
	                   c.sg_status
	                 from
	                   Codigo_CT c
	                 where
	                   ( c.sg_status = 'L' ) 
	                 order by
	                   c.cd_atual ) PrimeiroCodigo
	     on ( PrimeiroCodigo.cd_atual = Codigo_CT.cd_atual )
	
	  if ( @cd_codigo is null )
	  begin
	
	    -- Pega o que seria o próximo Código após o último Ativo
	    Select @cd_codigo = isnull( MAX( c.cd_atual ), 0 )
	    From Codigo_CT c -- (TABLOCK,HOLDLOCK)
	    Where ( c.sg_status = 'A' )
	
	    -- Insere um novo registro Ativo. O valor do código será o próximo
	    -- na tabela caso o mesmo seja maior que o próximo na tabela de
	    -- códigos 
	    set @Comando =
	      'Select ' +
	        ' case when IsNull( MAX( ' + @nm_campo + ' ), 0 ) > ' +
	           cast(@cd_codigo as varchar) + ' then ' +
	           'IsNull( MAX( ' + @nm_campo + ' ), 0 ) + 1 ' +
	        ' else ' +
	           cast(@cd_codigo + 1 as varchar) +
	        ' end, ' +
	        '''A'' ' +
	      'From ' +
	        @nm_tabela + ' ' +
	      'Where ' +
	        @nm_campo + ' > ' + cast(@cd_codigo as varchar)

	    Insert
	      Codigo_CT ( cd_atual, sg_status ) 
	    Execute
	      ( @Comando ) 
	
	    -- Agora sim, pegar o próximo disponível
	    Select @cd_codigo = MAX( c.cd_atual )
	    From Codigo_CT c
	    Where ( c.sg_status = 'A' )
	
	  end

  end
  -----------------------------------------------------------------------------
  else                                           -- CONTROLE DAS OUTRAS TABELAS
  -----------------------------------------------------------------------------
  begin

	  -- Tentar pegar o primeiro código com status "Livre"
	  Update
	    Codigo -- with (TABLOCK,HOLDLOCK)
	  Set
	    sg_status = 'A',
	    @cd_codigo = Codigo.cd_atual
	  From
	    Codigo
	    inner join ( Select top 1
	                   c.nm_tabela,
	                   c.cd_atual,
	                   c.sg_status
	                 from
	                   Codigo c
	                 where
	                   ( c.sg_status = 'L' ) and
	                   ( c.nm_tabela = @nm_tabela )
	                 order by
	                   c.cd_atual ) PrimeiroCodigo
	     on ( PrimeiroCodigo.nm_tabela = Codigo.nm_tabela ) and
	        ( PrimeiroCodigo.cd_atual = Codigo.cd_atual )
	
	  if ( @cd_codigo is null )
	  begin
	
	    -- Pega o que seria o próximo Código após o último Ativo
	    Select @cd_codigo = isnull( MAX( c.cd_atual ), 0 )
	    From Codigo c -- (TABLOCK,HOLDLOCK)
	    Where ( c.nm_tabela = @nm_tabela ) and ( c.sg_status = 'A' )
	
	    -- Insere um novo registro Ativo. O valor do código será o próximo
	    -- na tabela caso o mesmo seja maior que o próximo na tabela de
	    -- códigos 
	    set @Comando =
	      'Select ' +
	        ''''+ @nm_tabela + ''', ' +
	        ' case when IsNull( MAX( ' + @nm_campo + ' ), 0 ) > ' +
	           cast(@cd_codigo as varchar) + ' then ' +
	           'IsNull( MAX( ' + @nm_campo + ' ), 0 ) + 1 ' +
	        ' else ' +
	           cast(@cd_codigo + 1 as varchar) +
	        ' end, ' +
	        '''A'' ' +
	      'From ' +
	        @nm_tabela + ' ' +
	      'Where ' +
	        @nm_campo + ' > ' + cast(@cd_codigo as varchar)
	
	    Insert
	      Codigo ( nm_tabela, cd_atual, sg_status ) 
	    Execute
	      ( @Comando ) 
	
	    -- Agora sim, pegar o próximo disponível
	    Select @cd_codigo = MAX( c.cd_atual )
	    From Codigo c
	    Where ( c.nm_tabela = @nm_tabela ) and ( c.sg_status = 'A' )

	  end

  end

  set @codigo = isnull(@cd_codigo,1)

return 

