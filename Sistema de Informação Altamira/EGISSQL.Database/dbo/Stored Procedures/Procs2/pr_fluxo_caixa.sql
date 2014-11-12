

CREATE PROCEDURE pr_fluxo_caixa
@ic_parametro int,
@dt_inicial   datetime,
@dt_final     datetime,
@pc_liquidez  float = 100,
@ic_periodo   int   

as

  -- variável usada como chave p/ leitura
  declare @DataFluxo datetime
  declare @DiaUtil   char(1)

  declare @Semana int
  declare @Mes    int
  declare @Ano    int

  -- usada p/ criação da tabela temporária
  declare @Comando   varchar(8000)
  declare @Cabecalho varchar(100)

  -- usada como contador de dias não uteis
  declare @TipoAnt  char(1)
  declare @Controle int

  declare @DataInicial datetime
  declare @DataFinal   datetime

  declare @UnicoMes char(1)
  declare @UnicoAno char(1)

  DECLARE @GRANT AS VARCHAR(100)


  -- limita o processamento apenas no período pedido
  -- Existe um erro ao pedir um período que não seja diário,
  -- o processamento é efetuado pelo período informado em dias.
  -- Corrigir Futuramente - ELIAS


  -- identifica se a listagem é de mais de um mes
  if (Month(@dt_inicial)) <> (Month(@dt_final))
    set @UnicoMes = 'N'
  else
    set @UnicoMes = 'S'

  -- criação da tabela temporária que guardará o cabeçalho p/ pesquisa
  create table #Cabecalho (DataCab datetime, NomeCab varchar(50))

  -- seleção dos dias do período p/ montagem da tabela temporária
  select 
    dt_agenda	as 'DataFluxo',
    case when isnull(ic_financeiro,'N') <> isnull(ic_util,'N') then
      isnull(ic_financeiro,'N')
    else
      isnull(ic_util,'N')
    end as 'DiaUtil' 
  into
    #Periodo
  from 
    Agenda 
  where 
    dt_agenda between @dt_inicial and @dt_final
  order by
    dt_agenda desc

  Create Index IX_Agenda on #Periodo (DataFluxo)


  -- montagem do script inicial
  set @Comando = 'CREATE TABLE dbo.' + 'Fluxo_Caixa (CODCONTA INT NULL, SUMARIZAR CHAR(1) NULL, TIPO INT NULL, CODIGO INT NULL, GRUPO VARCHAR(40) NULL, CONTA VARCHAR(50) NULL, INICIAL FLOAT'

--  set @Comando = 'CREATE TABLE ' + USER_NAME() + '.' + 'Fluxo_Caixa (CODCONTA INT NULL, SUMARIZAR CHAR(1) NULL, TIPO INT NULL, CODIGO INT NULL, GRUPO VARCHAR(40) NULL, CONTA VARCHAR(50) NULL, INICIAL FLOAT'

  set @TipoAnt = ''
  set @Controle = 0

  -- Listagem Diária
  if @ic_periodo = 1
    begin
      
      -- montagem da tabela temporária
      while exists(select top 1 DataFluxo from #Periodo)
        begin

          select
            @DataFluxo = DataFluxo,
            @DiaUtil   = DiaUtil
          from
            #Periodo


          if @DiaUtil = 'S'
            begin

              if ((@TipoAnt = 'S') or (@TipoAnt = ''))
                begin
                  set @Cabecalho = ''
                  set @Cabecalho = cast(day(@DataFluxo) as varchar(2))
                  set @DataInicial = @DataFluxo
                end
              else 
                begin
                  set @Cabecalho = @Cabecalho+'/'+cast(day(@DataFluxo) as varchar(2))             
                  set @DataFinal = @DataFluxo
                end

              set @TipoAnt = @DiaUtil
    
              if @UnicoMes = 'S'
                begin
                  set @Comando = @Comando+' NULL, '+QuoteName(@Cabecalho)+' float'
                  if @DataInicial <= @DataFluxo 
                    begin
                      while @DataInicial <= @DataFluxo
                        begin
                          insert into #Cabecalho values (@DataInicial, @Cabecalho)
                          set @DataInicial = DateAdd(day, 1, @DataInicial)
                        end
                    end
                  else
                    begin
                      insert into #Cabecalho values (@DataInicial, @Cabecalho)
                    end                  
                end
              else
                begin
                  set @Comando = @Comando+' NULL, '+QuoteName(@Cabecalho+'('+cast(Month(@DataFluxo) as varchar(2))+')')+' float '
                  if @DataInicial <= @DataFluxo
                    begin
                      while @DataInicial <= @DataFluxo
                        begin
                          insert into #Cabecalho values (@DataInicial, @Cabecalho+'('+cast(Month(@DataFluxo) as varchar(2))+')')
                          set @DataInicial = DateAdd(day, 1, @DataInicial)
                        end                   
                    end
                  else
                    begin
                      insert into #Cabecalho values (@DataInicial, @Cabecalho+'('+cast(Month(@DataFluxo) as varchar(2))+')')
                    end
                end

              set @Controle = 1
            end
          else
            begin

              if @TipoAnt = @DiaUtil
                begin
                  set @Cabecalho = @Cabecalho+'/'+cast(day(@DataFluxo) as varchar(2))
                  set @DataFinal = @DataFluxo
                end
              else
                begin
                  set @Controle    = 0
                  set @Cabecalho   = cast(day(@DataFluxo) as varchar(2))
                  set @DataInicial = @DataFluxo
                  set @TipoAnt     = @DiaUtil
                end
            end

          delete
            #Periodo
          where
            DataFluxo = @DataFluxo      

        end

      if @Controle = 0
        begin

          if @UnicoMes = 'S' 
            begin

              set @Comando = @Comando+' NULL, '+QuoteName(@Cabecalho)+' float'
              if @DataInicial <= @DataFluxo
                begin 

                  while @DataInicial <= @DataFluxo
                    begin

                      insert into #Cabecalho values (@DataInicial, @Cabecalho)
                      set @DataInicial = DateAdd(day, 1, @DataInicial)

                    end                   

                end

              else

                begin

                  insert into #Cabecalho values (@DataInicial, @Cabecalho)

                end

            end

          else
            begin

              set @Comando = @Comando+' NULL, '+QuoteName(@Cabecalho+'('+cast(Month(@DataFluxo) as varchar(2))+')')+' float '

              if @DataInicial <= @DataFluxo
                begin

                  while @DataInicial <= @DataFluxo
                    begin

                      insert into #Cabecalho values (@DataInicial, @Cabecalho+'('+cast(Month(@DataFluxo) as varchar(2))+')')
                      set @DataInicial = DateAdd(day, 1, @DataInicial)

                    end                   

                end

              else
                begin

                  insert into #Cabecalho values (@DataInicial, @Cabecalho+'('+cast(Month(@DataFluxo) as varchar(2))+')')

                end  

            end

        end

    end

  -- Listagem Semanal
  else if @ic_periodo = 2

    begin

      -- data que será usada como contador
      set @DataFluxo = @dt_inicial

      -- carrega a primeira semana
      set @Semana = datepart(wk, @DataFluxo)

      -- verifica se irá mostrar o ano na coluna ou não
      if (year(@dt_inicial) <> year(@dt_final))
        set @UnicoAno = 'N'
      else
        set @UnicoAno = 'S'

      -- montagem da tabela temporária
      while (@DataFluxo <= @dt_final)
        begin

          if @Semana <> datepart(wk, @DataFluxo)
            begin

              if @UnicoAno = 'S'      
                begin
                  insert into #Cabecalho values (@DataFluxo, cast(@Semana as varchar(2)))
                  set @Comando = @Comando+' NULL, '+QuoteName(cast(@Semana as varchar(2)))+' float '
                end
              else
                begin
                  insert into #Cabecalho values (@DataFluxo, cast(@Semana as varchar(2))+'('+cast(year(@DataFluxo) as varchar(4))+')')
                  set @Comando = @Comando+' NULL, '+QuoteName(cast(@Semana as varchar(2))+'('+cast(year(@DataFluxo) as varchar(4))+')')+' float '
                end
      
              set @Semana = datepart(wk, @DataFluxo)

            end
          else 
            begin

              if @UnicoAno = 'S'      
                insert into #Cabecalho values (@DataFluxo, cast(@Semana as varchar(2)))
              else
                insert into #Cabecalho values (@DataFluxo, cast(@Semana as varchar(2))+'('+cast(year(@DataFluxo) as varchar(4))+')')

            end

          set @DataFluxo = @DataFluxo + 1

        end

      if @UnicoAno = 'S'      
        set @Comando = @Comando+' NULL, '+QuoteName(cast(@Semana as varchar(2)))+' float '
      else
        set @Comando = @Comando+' NULL, '+QuoteName(cast(@Semana as varchar(2))+'('+cast(year(@DataFluxo) as varchar(4))+')')+' float '

    end

  -- Listagem Mensal

  else if @ic_periodo = 3 
    begin

      -- data que será usada como contador
      set @DataFluxo = @dt_inicial

      -- verifica se irá mostrar o ano na coluna ou não
      if (year(@dt_inicial) <> year(@dt_final))
        set @UnicoAno = 'N'
      else
        set @UnicoAno = 'S'

      -- carrega o primeiro mes
      set @Mes = month(@DataFluxo)

      -- montagem da tabela temporária
      while (@DataFluxo <= @dt_final)
        begin

          if @Mes <> month(@DataFluxo)
            begin
      
              if @UnicoAno = 'S'
                begin
                  insert into #Cabecalho values (@DataFluxo, cast(@Mes as varchar(2)))
                  set @Comando = @Comando+' NULL, '+QuoteName(cast(@Mes as varchar(2)))+' float '
                end
              else
                begin
                  insert into #Cabecalho values (@DataFluxo, cast(@Mes as varchar(2))+'/'+cast(year(@DataFluxo) as varchar(4)))
                  set @Comando = @Comando+' NULL, '+QuoteName(cast(@Mes as varchar(2))+'/'+cast(year(@DataFluxo) as varchar(4)))+' float '
                end

              set @Mes = month(@DataFluxo)

            end
          else 
            begin

              if @UnicoAno = 'S'
                insert into #Cabecalho values (@DataFluxo, cast(@Mes as varchar(2)))
              else
                insert into #Cabecalho values (@DataFluxo, cast(@Mes as varchar(2))+'/'+cast(year(@DataFluxo) as varchar(4)))
             
            end

          set @DataFluxo = @DataFluxo + 1

        end


      if @UnicoAno = 'S'
        set @Comando = @Comando+' NULL, '+QuoteName(cast(@Mes as varchar(2)))+' float '
      else
        set @Comando = @Comando+' NULL, '+QuoteName(cast(@Mes as varchar(2))+'/'+cast(year(@DataFluxo) as varchar(4)))+' float '

    end

  -- Listagem Anual
  else if @ic_periodo = 4 
    begin

      -- data que será usada como contador
      set @DataFluxo = @dt_inicial

      -- carrega o primeiro ano
      set @Ano = year(@DataFluxo)

      -- montagem da tabela temporária
      while (@DataFluxo <= @dt_final)
        begin

          if @Ano <> year(@DataFluxo)
            begin
      
              insert into #Cabecalho values (@DataFluxo, cast(@Ano as varchar(4)))
              set @Comando = @Comando+' NULL, '+QuoteName(cast(@Ano as varchar(4)))+' float '
      
              set @Ano = year(@DataFluxo)

            end
          else 
            begin

              insert into #Cabecalho values (@DataFluxo, cast(@Ano as varchar(4)))
             
            end

          set @DataFluxo = @DataFluxo + 1

        end


      set @Comando = @Comando+' NULL, '+QuoteName(cast(@Ano as varchar(4)))+' float '

    end

--  if ( USER_NAME() = 'dbo' ) and (@ic_periodo <> 1)
    set @Comando = @Comando + ' NULL, TOTAL FLOAT NULL, PERC FLOAT NULL) ' 
--  else
--    set @Comando = @Comando + ' Teste ] varchar(1) NULL, TOTAL FLOAT NULL, PERC FLOAT NULL) ' 


--  set @Comando = @Comando + ' , TOTAL FLOAT NULL, PERC FLOAT NULL) ' 


  declare @comando2 varchar(2000)

  IF EXISTS (SELECT top 1 name 
	   FROM   sysobjects 
	   WHERE  name = N'Fluxo_Caixa'
	   AND 	  type = 'U' 
     AND    uid in ( USER_ID(), 1 ))
  begin
    set @Comando2 = ' DROP TABLE dbo.' + 'Fluxo_Caixa'
--    set @Comando2 = ' DROP TABLE ' + USER_NAME() + '.' + 'Fluxo_Caixa'
    exec(@Comando2) 
  end
  

--  print(@Comando)

  exec(@Comando)

  SET @GRANT = 'GRANT INSERT, UPDATE, DELETE, SELECT ON Fluxo_Caixa TO ' + USER_NAME()

  EXEC (@GRANT)

	---------------------------------------------------
	-- Criar um índice para agilizar os Updates logo abaixo
	---------------------------------------------------
  Create Index IX_Fluxo_Caixa on Fluxo_Caixa (CODCONTA)


  -- Inserção dos registros que funcionarão como totais e sub totais
  /*     (1)SALDO ANTERIOR     .........
         (2)Despesas           .........
         (3)TOTAL DE DESPESAS  .........
         (4)Receitas           .........
         (5)TOTAL DE RECEITAS  .........
         (6)SALDO ATUAL        .........  */

  set @comando2 = 
  'insert into dbo.' + 'Fluxo_Caixa 
    (TIPO, CODIGO, CONTA, INICIAL)
  values
    (1, 999, ''SALDO INICIAL'', 0.00) '

  exec(@comando2)

--  'insert into ' + USER_NAME() + '.' + 'Fluxo_Caixa 

  set @comando2 = 
  'insert into dbo.' + 'Fluxo_Caixa 
    (TIPO, CODIGO, CONTA, INICIAL)
  values
    (3, 999, ''TOTAL DE RECEITAS'', 0.00) '

  exec(@comando2)

  set @comando2 = 
  'insert into dbo.' + 'Fluxo_Caixa 
    (TIPO, CODIGO, CONTA, INICIAL)
  values
    (5, 999, ''TOTAL DE DESPESAS'', 0.00) '

  exec(@comando2)

  set @comando2 = 
  'insert into dbo.' + 'Fluxo_Caixa 
    (TIPO, CODIGO, CONTA, INICIAL)
  values
    (6, 999, ''SALDO ATUAL'', 0.00) '

  exec(@comando2)

  print 'Incluiu tudo!'

  -- variáveis usadas p/ preenchimento da tabela de fluxo de caixa
  declare @Codigo    int
  declare @DataPlano datetime
  declare @Grupo     varchar(50)
  declare @TipoGrupo as int
  declare @Conta     varchar(50)
  declare @CodConta  as int
  declare @Saldo     float
  declare @DC        int
  declare @DCGrupo   int
  declare @Tipo      int
  declare @Sumarizar char(1)

  declare @SaldoInicial float
  declare @SaldoFinal   float

  declare @DCSaldoInicial int
  declare @DCSaldoFinal int


  -- tabela temporária com os dados de preenchimento 
  create table #Fluxo_Caixa_Composicao (
    Codigo    int identity(1,1),
    TipoGrupo int,
    Grupo     varchar(40),
    Conta     varchar(40),
    CodConta  int,
    DataPlano datetime,
    Saldo     float,
    DC        int,
    DCGrupo   int,
    Tipo      int,
    Sumarizar char(1) )        

  Create Index IX_Fluxo_Caixa_Composicao on #Fluxo_Caixa_Composicao (Codigo)


  -- PLANO FINANCEIRO

  -- preenchendo com todas as contas do plano para pesquisa futura do saldo inicial das
  -- contas que não tiveram movimentação no período - ELIAS

  insert into
    #Fluxo_Caixa_Composicao (
    TipoGrupo,
    Grupo,
    Conta,
    CodConta,
    DataPlano,
    Saldo,
    DC,
    DCGrupo,
    Tipo,
    Sumarizar )
  select
    case when p.cd_grupo_financeiro = 1 then 2 else 4 end,
    g.nm_grupo_financeiro,
    p.nm_conta_plano_financeiro,
    p.cd_plano_financeiro,
    s.dt_saldo_plano_financeiro,    
    case when g.cd_tipo_operacao = 1 then
      s.vl_saida - s.vl_entrada
    else
      s.vl_entrada - s.vl_saida end,
    g.cd_tipo_operacao,
    g.cd_tipo_operacao,
    1,
    'S'
  from
    grupo_financeiro g,
    plano_financeiro p,
    plano_financeiro_saldo s
  where
    g.cd_grupo_financeiro = p.cd_grupo_financeiro and
    p.cd_plano_financeiro = s.cd_plano_financeiro and
    s.dt_saldo_plano_financeiro between @dt_inicial and @dt_final and
    s.cd_tipo_lancamento_fluxo = @ic_parametro

  insert into
    #Fluxo_Caixa_Composicao (
    TipoGrupo,
    Grupo,
    Conta,
    CodConta,
    DataPlano,
    Saldo,
    DC,
    DCGrupo,
    Tipo,
    Sumarizar )    
  select    
    case when p.cd_grupo_financeiro = 1 then 2 else 4 end 
 				as 'TipoGrupo',
    g.nm_grupo_financeiro       as 'Grupo',
    p.nm_conta_plano_financeiro as 'Conta',
    p.cd_plano_financeiro       as 'CodConta',
    @dt_inicial - 1	        as 'DataPlano',
    cast(0.00 as float)  	as 'Saldo',
    g.cd_tipo_operacao          as 'DC',
    g.cd_tipo_operacao		as 'DCGrupo',
    1				as 'Tipo',
    'S'				as 'Sumarizar'
  from
    grupo_financeiro g,
    plano_financeiro p
  where
    g.cd_grupo_financeiro = p.cd_grupo_financeiro and
    p.ic_conta_analitica = 'S' and 
    p.cd_plano_financeiro not in (select
                                    top 1
		                    xp.cd_plano_financeiro
		                  from
   	  	                    grupo_financeiro xg,
		                    plano_financeiro xp,
		                    plano_financeiro_saldo xs
		                  where
		                    xg.cd_grupo_financeiro = xp.cd_grupo_financeiro and
		                    xp.cd_plano_financeiro = xs.cd_plano_financeiro and
		                    xs.dt_saldo_plano_financeiro between @dt_inicial and @dt_final and
		                    xs.cd_tipo_lancamento_fluxo = @ic_parametro)                               

  -- CAIXA
  insert into #Fluxo_Caixa_Composicao (
    TipoGrupo,
    Grupo,
    Conta,
    CodConta,
    DataPlano,
    Saldo,
    DC,
    DCGrupo,
    Tipo,
    Sumarizar )    
  select
    2				as 'TipoGrupo',
    g.nm_grupo_financeiro	as 'Grupo',
    p.nm_conta_plano_financeiro	as 'Conta',
    p.cd_plano_financeiro	as 'CodConta',
    c.dt_saldo_caixa		as 'DataPlano',
    c.vl_saldo_final_caixa	as 'Saldo',
    c.cd_tipo_operacao_final	as 'DC',
    g.cd_tipo_operacao		as 'DCGrupo',
    2                           as 'Tipo',
    'N'				as 'Sumarizar'
  from
    grupo_financeiro g,
    plano_financeiro p,
    caixa_saldo c
  where
    g.cd_grupo_financeiro = p.cd_grupo_financeiro and
    p.cd_plano_financeiro = c.cd_plano_financeiro and
    c.dt_saldo_caixa between @dt_inicial and @dt_final
  order by
    c.dt_saldo_caixa desc

  -- BANCO
  insert into #Fluxo_Caixa_Composicao (
    TipoGrupo,
    Grupo,
    Conta,
    CodConta,
    DataPlano,
    Saldo,
    DC,
    DCGrupo,
    Tipo,
    Sumarizar )    
  select
    2				 as 'TipoGrupo',
    g.nm_grupo_financeiro	 as 'Grupo',
    p.nm_conta_plano_financeiro	 as 'Conta',
    p.cd_plano_financeiro	 as 'CodConta',
    b.dt_saldo_conta_banco	 as 'DataPlano',
    b.vl_saldo_final_conta_banco as 'Saldo',
    b.cd_tipo_operacao_final	 as 'DC',
    g.cd_tipo_operacao		 as 'DCGrupo',
    3				 as 'Tipo',
    'N'				 as 'Sumarizar'
  from
    grupo_financeiro g,
    plano_financeiro p,
    conta_banco_saldo b
  where
    g.cd_grupo_financeiro = p.cd_grupo_financeiro and
    p.cd_plano_financeiro = b.cd_plano_financeiro and
    b.dt_saldo_conta_banco between @dt_inicial and @dt_final
  order by
    b.dt_saldo_conta_banco desc

  if @ic_parametro = 1  -- Lançamento do Percentual de Liquidez nos Recebimentos quando Tipo = Previsto
    begin

      update
        #Fluxo_Caixa_Composicao
      set
        Saldo = ((Saldo * @pc_liquidez) / 100)
      where
        DCGrupo = 2

    end
         
  while exists(select Codigo from #Fluxo_Caixa_Composicao)
    begin

      set @SaldoInicial = 0.00
      set @SaldoFinal = 0.00
     
      -- seleção dos dados usados na gravação
      select
        @Codigo = Codigo,
        @TipoGrupo = TipoGrupo,
        @Grupo = Grupo,
        @Conta = Conta,
        @CodConta = CodConta,
        @DataPlano = DataPlano,
        @Saldo = isnull(Saldo,0),
        @DC = DC,
        @DCGrupo = DCGrupo,
        @Tipo = Tipo,
        @Sumarizar = Sumarizar
      from
        #Fluxo_Caixa_Composicao

      -- encontrando o cabeçalho
      select
        @Cabecalho = NomeCab
      from
        #Cabecalho
      where
        DataCab = @DataPlano

      -- encontrando o saldo inicial

      -- PLANO FINANCEIRO
      if @Tipo = 1
        begin

          select
            top 1
            @SaldoInicial = isnull(vl_saldo_final,0)
          from
            Plano_Financeiro_Saldo
          where
            cd_plano_financeiro = @CodConta and
            dt_saldo_plano_financeiro < @dt_inicial and
            cd_tipo_lancamento_fluxo = @ic_parametro
          order by
            dt_saldo_plano_financeiro desc      

          set @DCSaldoInicial = @DC
 
        end

      -- CAIXA
      if @Tipo = 2
        begin

          select
            top 1
            @SaldoInicial = isnull(vl_saldo_final_caixa,0),
            @DCSaldoInicial = cd_tipo_operacao_final
          from
            Caixa_Saldo
          where
            cd_plano_financeiro = @CodConta and
            dt_saldo_caixa <= (@dt_inicial - 1)
          order by
            dt_saldo_caixa desc
   
        end

      -- BANCO
      if @Tipo = 3
        begin

          select
            top 1
            @SaldoInicial = isnull(vl_saldo_final_conta_banco,0),
            @DCSaldoInicial = cd_tipo_operacao_final
          from
            Conta_Banco_Saldo
          where
            cd_plano_financeiro = @CodConta and
            dt_saldo_conta_banco <= (@dt_inicial -1)
          order by
            dt_saldo_conta_banco desc

        end

      -- Lançamento do % de Liquidez      
      if ((@ic_parametro = 1) and (@DC = 2)) 
        set @SaldoInicial = isnull(((@SaldoInicial * @pc_liquidez) / 100),0)

      -- encontrando o saldo final

      -- PLANO FINANCEIRO
      if @Tipo = 1
        begin

          select top 1
            @SaldoFinal = sum(isnull(Saldo,0)) + @SaldoInicial
          from
            #Fluxo_Caixa_Composicao
          where
            DataPlano between @dt_inicial -1 and @dt_final and
            CodConta = @CodConta

          set @DCSaldoFinal = @DC

        end

      -- CAIXA
      if @Tipo = 2
        begin

          select
            @SaldoFinal = isnull(vl_saldo_final_caixa,0),
            @DCSaldoFinal = cd_tipo_operacao_final
          from
            Caixa_Saldo
          where
            cd_plano_financeiro = @CodConta and
            dt_saldo_caixa <= @dt_final

        end

      -- BANCO
      if @Tipo = 3
        begin

          select
            @SaldoFinal = isnull(vl_saldo_final_conta_banco,0),
            @DCSaldoFinal = cd_tipo_operacao_final
          from
            Conta_Banco_Saldo
          where
            cd_plano_financeiro = @CodConta and
            dt_saldo_conta_banco <= @dt_final

        end

      -- Lançamento do % de Liquidez
      if ((@ic_parametro = 1) and (@DCGrupo = 2)) 
        set @SaldoFinal = ((@SaldoFinal * @pc_liquidez) / 100)

      -- DC = 1 Débito/ 2 Crédito
      if @DC = 1
        set @Saldo = (@Saldo * -1)

      if @DCSaldoInicial = 1
        set @SaldoInicial = (@SaldoInicial * -1)

      if @DCSaldoFinal = 1
        set @SaldoFinal = (@SaldoFinal * -1)

      -- inclui no fluxo somente as contas que tiveram movimento no período
      if ((@SaldoInicial = 0.00) and (@SaldoFinal = 0.00)) 
        if ((select 
               sum(isnull(Saldo,0)) 
             from 
               #Fluxo_Caixa_Composicao
             where
               Codigo = @Codigo) = 0) 
          begin
            delete from #Fluxo_Caixa_Composicao where Codigo = @Codigo
            continue
          end           

      set @Comando = ''

      -- Localiza o valor já gravado no fluxo de caixa para acúmulo
      -- (somente para o plano financeiro, as contas de banco e caixa não se acumula)
      SET @GRANT = 'GRANT SELECT ON FLUXO_CAIXA TO ' + USER_NAME()

      EXEC (@GRANT)

      if exists(select top 1 CONTA from Fluxo_Caixa where CONTA = @Conta)
        begin

          if exists(Select top 1 * from sysobjects
                    where name = 'ValorDiaTemp' and
                    xtype = 'U' AND
                    uid in ( USER_ID(), 1 ))
          begin
            set @Comando2 = ' DROP TABLE ' + USER_NAME() + '.' + 'ValorDiaTemp'
            print(@Comando2)
            exec(@Comando2) 
          end

        
          set @Comando = 'SELECT '+QuoteName(@Cabecalho)+' as ValorDia INTO ' + USER_NAME() + '.' + 'ValorDiaTemp FROM dbo.' + 'FLUXO_CAIXA WHERE CODCONTA = '+cast(@CodConta as varchar(6))+' AND TIPO = '+''''+cast(@TipoGrupo as varchar(6))+''''
 
--          set @Comando = 'SELECT '+QuoteName(@Cabecalho)+' as ValorDia INTO ' + USER_NAME() + '.' + 'ValorDiaTemp FROM '+ USER_NAME() + '.' + 'FLUXO_CAIXA WHERE CODCONTA = '+cast(@CodConta as varchar(6))+' AND TIPO = '+''''+cast(@TipoGrupo as varchar(6))+''''
          print(@Comando)
          exec(@Comando) 

          SET @GRANT = 'GRANT SELECT ON ValorDiaTemp TO ' + USER_NAME()
 
          EXEC (@GRANT)

          set @Comando = ' declare @ValorDia float ' +
                         ' select ' + 
                         '   @ValorDia = ValorDia ' +
                         ' from '  
                         + USER_NAME() + '.' + ' ValorDiaTemp ' + 
                         'UPDATE dbo.' + 'FLUXO_CAIXA SET '+ QuoteName(@Cabecalho)+' = ('+cast(@Saldo as varchar(50)) + ' + IsNull(@ValorDia,0)) WHERE CODCONTA = '+cast(@CodConta as varchar(6))+' AND TIPO = '+''''+cast(@TipoGrupo as varchar(6))+''''

--                         'UPDATE '+ USER_NAME() + '.' + 'FLUXO_CAIXA SET '+ QuoteName(@Cabecalho)+' = ('+cast(@Saldo as varchar(50)) + ' + IsNull(@ValorDia,0)) WHERE CODCONTA = '+cast(@CodConta as varchar(6))+' AND TIPO = '+''''+cast(@TipoGrupo as varchar(6))+''''

          --print(@Comando)

        end
      else
        begin


          set @Comando = 'INSERT INTO dbo.' + 'FLUXO_CAIXA (CODCONTA, SUMARIZAR, TIPO, CODIGO, CONTA, GRUPO, INICIAL, '+QuoteName(@Cabecalho)+', '+'TOTAL '+')'
--          set @Comando = 'INSERT INTO '+ USER_NAME() + '.' + 'FLUXO_CAIXA (CODCONTA, SUMARIZAR, TIPO, CODIGO, CONTA, GRUPO, INICIAL, '+QuoteName(@Cabecalho)+', '+'TOTAL '+')'
          set @Comando = @Comando + ' VALUES ( '+cast(@CodConta as varchar(6))+', '+''''+@Sumarizar+''''+', '+cast(@TipoGrupo as varchar(6))+', '+cast(@Codigo as varchar(6))+
                          ', '+''''+@Conta+''''+', '+''''+@Grupo+''''+', '+cast(@SaldoInicial as varchar(50))+', '+cast(@Saldo as varchar(50))+
                          ', '+cast(@SaldoFinal as varchar(50))+')'
          --print(@Comando)

        end
             
      --print(@Comando)     
      exec(@Comando)
  
      delete from #Fluxo_Caixa_Composicao where Codigo = @Codigo

    end
  
  -- CARREGAMENTO DOS TOTAIS E SUB TOTAIS

  -- Sub Total de Receitas (INICIAL)
  update
    Fluxo_Caixa
  set
    INICIAL = (select 
                 sum(isnull(INICIAL,0))
               from
                 Fluxo_Caixa
               where
                 TIPO = 2 and
  		 SUMARIZAR = 'S')
  where
    TIPO = 3 

  -- Sub Total de Despesas (INICIAL)
  update
    Fluxo_Caixa
  set
    INICIAL = (select 
                 sum(isnull(INICIAL,0))
               from
                 Fluxo_Caixa
               where
                 TIPO = 4 and
                 SUMARIZAR = 'S')
  where
    TIPO = 5 

  -- Sub Total de Receitas (TOTAL)
  update
    Fluxo_Caixa
  set
    TOTAL = (select 
               sum(isnull(TOTAL,0))
             from
               Fluxo_Caixa
             where
               TIPO = 2 and
               SUMARIZAR = 'S')
  where
    TIPO = 3 

  -- Sub Total de Despesas (TOTAL)
  update
    Fluxo_Caixa
  set
    TOTAL = (select 
               sum(isnull(TOTAL,0))
             from
               Fluxo_Caixa
             where
               TIPO = 4 and
               SUMARIZAR = 'S')
  where
    TIPO = 5 

  -- Saldo Atual (INICIAL)
  update
    Fluxo_Caixa
  set
    INICIAL = (select top 1
                 isnull(INICIAL,0)
               from
                 Fluxo_Caixa
               where
                 TIPO = 3) +
              (select top 1 
                 isnull(INICIAL,0)
               from
                 Fluxo_Caixa
               where
                 TIPO = 5)
  where
    TIPO = 6

  -- carrega o 1º saldo inicial para a leitura no loop abaixo
  select
    @SaldoInicial = isnull(INICIAL,0)
  from
    Fluxo_Caixa
  where
    TIPO = 6               

  -- Lê todo o fluxo e atualiza os saldos em todas as colunas
  while exists(select * from #Cabecalho)
    begin

      select
        @Cabecalho = NomeCab
      from
        #Cabecalho
      order by 
        DataCab desc

      -- Sub Total de Receitas (INICIAL)
      set @Comando = 'update dbo.' + 'Fluxo_Caixa set '+QuoteName(@Cabecalho)+' = (select sum(isnull('+QuoteName(@Cabecalho)+
                     ',0)) from dbo.' + 'Fluxo_Caixa where TIPO = 2 and SUMARIZAR = '+''''+'S'+''''+') where TIPO = 3 '
--      set @Comando = 'update '+ USER_NAME() + '.' + 'Fluxo_Caixa set '+QuoteName(@Cabecalho)+' = (select sum(isnull('+QuoteName(@Cabecalho)+
--                     ',0)) from '+ USER_NAME() + '.' + 'Fluxo_Caixa where TIPO = 2 and SUMARIZAR = '+''''+'S'+''''+') where TIPO = 3 '
      --print(@Comando)
      exec(@Comando)

      -- Sub Total de Despesas (INICIAL)
      set @Comando = 'UPDATE dbo.' + 'Fluxo_Caixa set '+QuoteName(@Cabecalho)+' = (select sum(isnull('+QuoteName(@Cabecalho)+
                     ',0)) from dbo.' + 'Fluxo_Caixa where TIPO = 4 and SUMARIZAR = '+''''+'S'+''''+') where TIPO = 5'

--      set @Comando = 'UPDATE '+ USER_NAME() + '.' + 'Fluxo_Caixa set '+QuoteName(@Cabecalho)+' = (select sum(isnull('+QuoteName(@Cabecalho)+
--                     ',0)) from '+ USER_NAME() + '.' + 'Fluxo_Caixa where TIPO = 4 and SUMARIZAR = '+''''+'S'+''''+') where TIPO = 5'
      --print(@Comando)
      exec(@Comando)

      -- Atualizando o Saldo Inicial
      set @Comando = 'UPDATE dbo.' + 'FLUXO_CAIXA SET '+QuoteName(@Cabecalho)+' = '+cast(@SaldoInicial as varchar(50))+' WHERE TIPO = 1'

--      set @Comando = 'UPDATE '+ USER_NAME() + '.' + 'FLUXO_CAIXA SET '+QuoteName(@Cabecalho)+' = '+cast(@SaldoInicial as varchar(50))+' WHERE TIPO = 1'
      --print(@Comando)
      exec(@Comando)

      -- Atualizando o Saldo Final
      set @Comando = 'UPDATE dbo.' + 'FLUXO_CAIXA SET '+QuoteName(@Cabecalho)+' = ((ISNULL((SELECT top 1 '+
                        QuoteName(@Cabecalho)+' FROM dbo.' + 'FLUXO_CAIXA WHERE TIPO = 3),0) + ISNULL((SELECT top 1 '+
                        QuoteName(@Cabecalho)+' FROM dbo.' + 'FLUXO_CAIXA WHERE TIPO = 5),0)) + '+

--      set @Comando = 'UPDATE '+ USER_NAME() + '.' + 'FLUXO_CAIXA SET '+QuoteName(@Cabecalho)+' = ((ISNULL((SELECT top 1 '+
--                        QuoteName(@Cabecalho)+' FROM '+ USER_NAME() + '.' + 'FLUXO_CAIXA WHERE TIPO = 3),0) + ISNULL((SELECT top 1 '+
--                        QuoteName(@Cabecalho)+' FROM '+ USER_NAME() + '.' + 'FLUXO_CAIXA WHERE TIPO = 5),0)) + '+
                        cast(@SaldoInicial as varchar(50)) +') WHERE TIPO = 6'


      --print(@Comando)
      exec(@Comando)     

      -- Tabela Temporária para apurar o novo saldo inicial
      if exists(Select top 1 * from sysobjects
                where name = 'TotalFluxoTemp' and
                  xtype = 'U' )
      begin
        set @Comando2 = ' DROP TABLE dbo.' + 'TotalFluxoTemp'
--        set @Comando2 = ' DROP TABLE ' + USER_NAME() + '.' + 'TotalFluxoTemp'
        exec(@Comando2) 
      end

      set @Comando = 'SELECT '+QuoteName(@Cabecalho)+' as SALDO_INICIAL INTO dbo.TotalFluxoTemp FROM FLUXO_CAIXA WHERE TIPO = 6'
--      set @Comando = 'SELECT '+QuoteName(@Cabecalho)+' as SALDO_INICIAL INTO '+ USER_NAME() + '.' +'TotalFluxoTemp FROM '+ USER_NAME() + '.' + 'FLUXO_CAIXA WHERE TIPO = 6'
      exec(@Comando)

--      SET @GRANT = 'GRANT SELECT ON TotalFluxoTemp TO ' + USER_NAME()
 
--      EXEC(@GRANT)
--      print 'Deucerto!'

      select 
        @SaldoInicial = isnull(SALDO_INICIAL,0)
      from
        TotalFluxoTemp

      delete from
        #Cabecalho
      where
        NomeCab = @Cabecalho

    end   

  -- Saldo Inicial (TOTAL)
  update
    Fluxo_Caixa
  set
    TOTAL = 0
  where
    TIPO = 1 


  -- Saldo Atual (TOTAL)
  select
    @SaldoFinal = (select  top 1
                     isnull(TOTAL,0)
                   from
                     Fluxo_Caixa
                   where
                     TIPO = 3) +
                  (select
                     isnull(TOTAL,0)
                   from
                     Fluxo_Caixa
                   where
                     TIPO = 5)
    
  update
    Fluxo_Caixa
  set
    TOTAL = isnull(@SaldoFinal,0)
  where
    TIPO = 6

  -- Percentual Final (DESPESAS)
  update
    Fluxo_Caixa    
  set
    PERC = TOTAL / (select top 1 case when isnull(TOTAL,0) = 0 then 1 else TOTAL end from Fluxo_Caixa where TIPO = 3) * 100
  where
    TIPO in (2,3)

  -- Percentual Final (RECEITAS)
  update
    Fluxo_Caixa    
  set
    PERC = TOTAL / (select top 1 case when isnull(TOTAL,0) = 0 then 1 else TOTAL end from Fluxo_Caixa where TIPO = 5) * 100
  where
    TIPO in (4,5)
            
  -- Limpesa das Tabelas Temporárias
  drop table #Cabecalho
  drop table #Fluxo_Caixa_Composicao
  drop table #Periodo


  if exists(Select top 1 * from sysobjects
            where name = 'ValorDiaTemp' and
                    xtype = 'U' AND
                    uid in ( USER_ID(), 1 ))
  begin
    set @Comando = ' DROP TABLE ' + USER_NAME() + '.' + 'ValorDiaTemp'
    print(@Comando)
    exec(@Comando) 
  end


  IF EXISTS (SELECT name 
             FROM   sysobjects 
  	     WHERE  name = N'TotalFluxoTemp'
	     AND 	  type = 'U' )
             DROP TABLE TotalFluxoTemp

  select * from 
    Fluxo_Caixa 
  order by
    TIPO,
    GRUPO,
    CONTA
  
