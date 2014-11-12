
----------------------------------------------------------------------------------
--pr_calculo_peps
----------------------------------------------------------------------------------
--Global Business Solution Ltda                                               2004
----------------------------------------------------------------------------------
--Stored Procedure     : SQL Server Microsoft 2000
--Autor (es)           : Carlos Cardoso Fernandes         
--Banco Dados          : EGISSQL
--Objetivo             : Cálculo do Peps - Valoração do Estoque
--Data                 : 02.05.2001
--Atualizado           : 10.07.2001
--                     : 12.02.2003 
--                     : 01.07.2003 - Reestruturação da SP. Parametro cd_grupo_produto não era usado. 
--                     : 05.08.2003 - Otimização no Desempenho da SP. (DUELA)
--                                  - Acerto na Fase de Produto Default
--                     : 07.08.2003 - Validação na Unidade de Medida (DUELA)
--		       : 11.08.2003 - Utilização do Item de NF para filtro (Ludinei)
--                     : 18.08.2003 - Validação conforme Parametro_Custo 
--                                  - ´F´- Valoração pelo Saldo Final do Fechamento
-- 		       : 24/09/2003 - Daniel C. Neto. - Implantação dos parâmetros de Consistência.
--                     : 20/10/2003 - Implementação de Cursor para otimizar processamento (por Grupo) - ELIAS
--                     : 04/11/2003 - Implementação do Filtro por Fase do Produto - DUELA
--                     : 12/11/2003 - Ajustes para quando o fornecedor for 0 (zero) - Danilo
--                     : 03/03/2004 - Acerto no Order by para que na listagem apareça sempre 
--                                    ordenado por grupo principalmente - ELIAS
--                     : 16/04/2004 - Filtrando o update da tabela Produto_Fechamento para atualizar somente
--                                    o registro referentes a data de fechamento, anteriormente estava
--                                   atualizando toda a tabela e causando grande demora :-( - ELIAS
--                     : 28/04/2004 - Corrigido atualização do custo do produto na tabela Produto_fechamento que
--                                    anteriormente atualizava o produto com o último custo e não o custo total - ELIAS
--                     : 02/07/2004 - Arredandado as quantidades para até 4 casas decimais para evitar erro de 
--                                    valoração de saldo, que ocorria devido a subtração da qtde atual - qtde valorada,
--                                    dois campos tipo float - ELIAS
--                     : 30/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                     : 04/02/2005 - Gravacao na tabela fechamento do atributo : qt_peps_prod_fechamento
--                     : 01.08.2005 - Fase do Produto
--                                  - Checagem da Unidade de Valoração
--                                  - Verificarção do Parametro_Custo para mostrar o Peso do Bruto - Carlos Fernandes
--                                  - 
----------------------------------------------------------------------------------------------------------------------
CREATE   procedure pr_calculo_peps
@ic_parametro_peps         int,         --Parâmetros
@dt_inicial                datetime,
@dt_final                  datetime,
@cd_produto                int,
@cd_grupo_produto_inicial  int,
@cd_grupo_produto_final    int,
@cd_fase_produto           int,
@ic_filtro_divergencia     char(1) = 'N',
@ic_resumo_grupo           char(1) = 'N',
@ic_resumo_fase            char(1) = 'N'
as

-- Não adianta colocar os valores Default, se a procedure
-- for rodada do dentro do Egis sem passar os valores, os 
-- parâmetros continuarão vindo Nulos

set @ic_filtro_divergencia = isnull(@ic_filtro_divergencia,'N')
set @ic_resumo_grupo       = isnull(@ic_resumo_grupo,'N')
set @ic_resumo_fase        = isnull(@ic_resumo_fase,'N')

--Definicao de Variáveis para Processamento

declare @mm_calculo          int
declare @aa_calculo          int
declare @cd_fase             int
declare @nm_aux_mes          char(2)
declare @qt_saldo_produto    float  
declare @cmdsql              varchar(255)
declare @cd_nota_fiscal      varchar(100)
declare @cd_item_nota_fiscal float -- Ludinei (11/08)
declare @qt_nota_fiscal      float
declare @qt_peps_aux         float
declare @qt_peps             float
declare @vl_custo_peps       float
declare @cd_mascara_produto  varchar(20)
declare @ic_tipo_valoracao   char(1)
declare @qt_valorado_peps    float
declare @qt_itens_peps       float
declare @dt_documento_peps   varchar(10)

declare @cd_seq_peps               float
declare @cd_produto_first          float
declare @cd_nota_fiscal_first      varchar(20)
declare @cd_item_nota_fiscal_first float
declare @qt_nota_fiscal_first      float
declare @qt_saldo_estoque          float
declare @qt_registros              int

declare @ic_forma_ordenacao        char(1)
declare @ic_peso_peps              char(1) --Apresenta o Peso do produto no Cálculo do Peps
declare @vl_preco_entrada_peps_produto  float

declare @cd_fase_produto_comercial int

set @ic_tipo_valoracao ='F' 
set @mm_calculo        = month( @dt_final )
set @aa_calculo        = year ( @dt_final )
set @qt_peps_aux       = 0
set @vl_custo_peps     = 0
set @qt_valorado_peps  = 0
set @qt_itens_peps     = 0
set @qt_registros      = 0
set @vl_preco_entrada_peps_produto = 0

--Define a forma de exibição
select @ic_forma_ordenacao = IsNull(ic_exibicao_padrao_prod,'F') from parametro_custo where cd_empresa = dbo.fn_empresa()

--Define fase comercial a ser atualizada no custo contabil do produto
select top 1 @cd_fase_produto_comercial = cd_fase_produto from Parametro_Comercial where cd_empresa = dbo.fn_empresa()

if ( IsNull(@ic_forma_ordenacao,'') = '' )
  set @ic_forma_ordenacao = 'F'

Create table #TEMP_PEPS(
  cd_movimento_estoque      int Null,
  cd_produto                int Null,
  cd_fornecedor             int Null,
  cd_documento_entrada_peps varchar(15) Null,
  cd_item_documento_entrada int Null,
  qt_entrada_peps           float Null,
  vl_preco_entrada_peps     float Null,
  vl_custo_total_peps       float null,
  qt_valorizacao_peps       float null,
  vl_custo_valorizacao_peps float null,
  vl_fob_entrada_peps       float null,
  cd_usuario                int null,
  dt_usuario                datetime null,
  dt_documento_entrada_peps datetime null,
  cd_fase_produto           int null,
  cd_controle_nota_entrada  int null,
  dt_controle_nota_entrada  datetime null,
  unitario                  float null,
  fornecedor                varchar(40) null,
  grupoProduto              varchar(40) null,
  codigo                    varchar(15) null,
  produto                   varchar(30) null,
  descricao                 varchar(60) null,
  unidade                   varchar(2) null,
  qt_peso_entrada_peps      float null)

         

/*Create table #TEMP_GRUPO(
  grupoProduto varchar(40) null,
  cd_fase_produto int null,
  qt_entrada_peps float null)

Create table #TEMP_FASE(
  cd_fase_produto int null,
  qt_entrada_peps float null)*/

-- Ludinei (27/10/2003) Ajustar a data final para entender até a ultima hora do dia.
set @dt_final = convert(datetime,left(convert(varchar,@dt_final,121),10)+' 23:59:00',121)

select @ic_tipo_valoracao = isnull(ic_parametro_peps_empresa,'F'),
       @ic_peso_peps      = isnull(ic_peso_peps,'N')
from Parametro_Custo
where
  cd_empresa = dbo.fn_empresa()


--Fase do Produto
select cd_fase_produto into #Fase_Temp
from Fase_Produto
where 
  cd_fase_produto=@cd_fase_produto or @cd_fase_produto=0

--Verifica se as Fases de Valoração estão Atualizadas no Cadastro do Grupo de Produto
--Grupo_Produto_Valoracao
--select * from grupo_produto_valoracao

-------------------------------------------------
if @ic_parametro_peps = 1 --Por Produto
-------------------------------------------------
begin
  while exists(select top 1 cd_fase_produto from #Fase_Temp) 
    begin

      set @cd_fase= (select top 1 cd_fase_produto from #Fase_Temp)

      select 
        @qt_saldo_produto = qt_atual_prod_fechamento+qt_terc_prod_fechamento
      from 
        Produto_Fechamento pf
      where 
        pf.cd_produto      = @cd_produto  and 
        pf.cd_fase_produto = @cd_fase and  
        pf.dt_produto_fechamento between @dt_inicial and @dt_final
 
      -- Zera as Variáveis de Cálculo da Tabela CADPEPS
      update Nota_Entrada_Peps
      set 
        qt_valorizacao_peps       =0,
        vl_custo_valorizacao_peps =0
      where 
        cd_produto      = @cd_produto and
        cd_fase_produto = @cd_fase_produto

      -- Cria Tabela Temporária para Cálculo
      select identity (int,1,1) as 'cd_seq_peps',
             nep.*, 
             isnull(cd_item_documento_entrada,0) as 'cd_item_documento_aux' -- Ludinei 11/08
      into 
        #Aux_peps
      from 
        Nota_Entrada_Peps 	nep left outer join
        Produto_Custo 		pc  on nep.cd_produto = pc.cd_produto
      where
        nep.cd_produto             = @cd_produto and
        nep.cd_fase_produto        = @cd_fase_produto and
        dt_documento_entrada_peps <=  @dt_final  and
        isnull(pc.ic_peps_produto,'S')='S'
      order by
        dt_documento_entrada_peps desc

      set @qt_itens_peps    = 0
      set @qt_saldo_estoque = 0

      while exists ( select top 1 * from #Aux_peps )
        begin
          select
            top 1
            @cd_seq_peps         = cd_seq_peps,
            @cd_nota_fiscal      = cd_documento_entrada_peps,
	    @cd_item_nota_fiscal = cd_item_documento_aux, -- Ludinei 11/08
            @qt_nota_fiscal      = qt_entrada_peps,
            @vl_custo_peps       = vl_custo_total_peps,
            @dt_documento_peps   = cast(dt_documento_entrada_peps as varchar(10))
          from
            #Aux_peps
          order by 
            dt_documento_entrada_peps desc

          if @cd_seq_peps=1
   	        begin  
  	         set @cd_produto_first          = @cd_produto
    	         set @cd_nota_fiscal_first      = @cd_nota_fiscal
	         set @cd_item_nota_fiscal_first = @cd_item_nota_fiscal
	         set @qt_nota_fiscal_first      = @qt_nota_fiscal
	        end

          set @qt_peps     = @qt_nota_fiscal

--           print('1 @qt_peps '+cast(@qt_peps as varchar))
--           print('1 @qt_peps_aux '+cast(@qt_peps_aux as varchar))

          if @qt_saldo_produto < ( @qt_peps_aux + @qt_nota_fiscal )
            begin
              set @vl_custo_peps = (@vl_custo_peps/@qt_nota_fiscal)*( @qt_saldo_produto-@qt_peps_aux )

              if @vl_custo_peps < 0.01
                set @vl_custo_peps = 0.01                    

              set @qt_peps     = round(@qt_saldo_produto,4)-round(@qt_peps_aux,4)
              set @qt_peps_aux = round(@qt_saldo_produto,4)
            end
          else
            set @qt_peps_aux = round(@qt_peps_aux,4) + round(@qt_nota_fiscal,4)


          -- Atualiza o CADPEPS com Valores para PEPS
  	  set @qt_valorado_peps = round(@qt_saldo_produto,4) - 
                                  round((@qt_saldo_produto - @qt_peps),4)  -- Ludinei/Adriano 19/08

--           print('@qt_saldo_produto '+cast(@qt_saldo_produto as varchar))
--           print('@qt_peps '+cast(@qt_peps as varchar))

          set @qt_itens_peps = round(@qt_itens_peps,4) + round(@qt_peps,4)

          if (select count(*) from #aux_peps) = 1
            set @qt_saldo_estoque = @qt_saldo_produto-@qt_itens_peps
       
          update Nota_Entrada_Peps
          set 
            qt_valorizacao_peps       = case when @ic_tipo_valoracao = 'F' then round(@qt_valorado_peps,4) -- Ludinei/Adriano 19/08
	      		                else round(@qt_peps,4) end,
            vl_custo_valorizacao_peps = case when @ic_tipo_valoracao = 'F' then 
                                          case when isnull(round(@qt_peps,4),0) = 0 then 
                                            ((@vl_custo_peps/1)*isnull(round(@qt_valorado_peps,4),1)) 
                                          else
                                            ((@vl_custo_peps/@qt_peps)*isnull(round(@qt_valorado_peps,4),round(@qt_peps,4)))
                                          end
                                        else 
                                          @vl_custo_peps 
                                        end  
          where
            (cd_produto=@cd_produto) and
            @cd_nota_fiscal      = cd_documento_entrada_peps and
      	    @cd_item_nota_fiscal = isnull(cd_item_documento_entrada,0) and -- Ludinei (11/08)
            round(@qt_nota_fiscal,4)      = round(qt_entrada_peps,4)

--          print('@qt_valorado_peps '+cast(@qt_valorado_peps as varchar))
--          print('@qt_peps '+cast(@qt_peps as varchar))

          if (select count(*) from #aux_peps) = 1
	        begin
            update Nota_Entrada_Peps
             set 
               qt_valorizacao_peps       = round(qt_valorizacao_peps,4) + round(@qt_saldo_estoque,4),
               vl_custo_valorizacao_peps = (vl_custo_total_peps/round(qt_entrada_peps,4)) * (round(qt_valorizacao_peps,4) + round(@qt_saldo_estoque,4))
             where
               (cd_produto=@cd_produto) and
                @cd_nota_fiscal_first      = cd_documento_entrada_peps and
	              @cd_item_nota_fiscal_first = isnull(cd_item_documento_entrada,0) and -- Ludinei (11/08)
                round(@qt_nota_fiscal_first,4)      = round(qt_entrada_peps,4)
	        end
  
        -- Deleta Nota Fiscal do Arquivo Auxilar
          delete #Aux_Peps 
          where
            (cd_produto=@cd_produto)                         and
            @cd_nota_fiscal      = cd_documento_entrada_peps and
            @cd_item_nota_fiscal = cd_item_documento_aux     and -- Ludinei (11/08)
            @qt_nota_fiscal      = qt_entrada_peps
        end

      drop table #aux_peps
      -- Apresentacao do Cálculo do Peps
      select
				 a.cd_movimento_estoque,
				 a.cd_produto,
				 a.cd_fornecedor,
				 a.cd_documento_entrada_peps,
				 a.cd_item_documento_entrada,
				 a.qt_entrada_peps,
				 a.vl_preco_entrada_peps,
				 a.vl_custo_total_peps,
				 a.qt_valorizacao_peps,
				 a.vl_custo_valorizacao_peps,
				 a.vl_fob_entrada_peps,
				 a.cd_usuario,
				 a.dt_usuario,
				 a.dt_documento_entrada_peps,
				 a.cd_fase_produto,
				 a.cd_controle_nota_entrada,
				 a.dt_controle_nota_entrada,
         isnull(a.vl_custo_valorizacao_peps,0) / a.qt_valorizacao_peps as 'Unitario',
         isnull(b.nm_fantasia_fornecedor,'Ajuste')           as 'Fornecedor' ,
         gp.nm_grupo_produto                                 as 'GrupoProduto',
         IsNull(dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto,c.cd_mascara_produto),'') as 'Codigo',
         c.nm_fantasia_produto                               as 'Produto',
         c.nm_produto                                        as 'Descricao',
         isnull(um.sg_unidade_medida,'')                     as 'Unidade',
         a.qt_peso_entrada_peps
      into #Nota_Entrada_peps
      from
        Nota_Entrada_Peps a 
      left outer join Movimento_Estoque mv on
        a.cd_movimento_estoque = mv.cd_movimento_estoque and
        mv.cd_fase_produto = @cd_fase
      left outer join Fornecedor b on
        a.cd_fornecedor= b.cd_fornecedor
      left outer join Produto c on
        a.cd_produto        = c.cd_produto
      left outer join Grupo_Produto gp on
        c.cd_grupo_produto  = gp.cd_grupo_produto
      left outer join Unidade_Medida um on 
        c.cd_unidade_medida = um.cd_unidade_medida
      where
        (a.cd_produto=@cd_produto) and
        (a.cd_fase_produto = @cd_fase_produto)  and
        isnull(a.qt_valorizacao_peps,0 ) > 0 and
        -- ELIAS 23/06/2004
        a.dt_documento_entrada_peps <= @dt_final
      order by
        a.dt_documento_entrada_peps desc

      insert into #TEMP_PEPS
        select * from #Nota_Entrada_peps
        
      delete from #Fase_Temp where cd_fase_produto=@cd_fase
      drop table #Nota_Entrada_PEPS
    end

  ------------------------------------
  if @ic_filtro_divergencia = 'N'
  ------------------------------------
    begin

      if @ic_resumo_grupo='N' and @ic_resumo_fase='N'
      begin
        --Atualiza as informações da tabela produto_custo
	      if @ic_forma_ordenacao <> 'F'
           select * from #TEMP_PEPS order by codigo asc, dt_documento_entrada_peps desc
        else
           select * from #TEMP_PEPS order by Produto asc, dt_documento_entrada_peps desc
      end
      else if @ic_resumo_grupo='S'
        select
          tp.grupoproduto,
          sum(tp.qt_entrada_peps) as Qtd,
          fp.nm_fase_produto,
          sum(tp.vl_custo_valorizacao_peps) as Total
        from #TEMP_PEPS tp
        left outer join Fase_Produto fp on 
          fp.cd_fase_produto=tp.cd_fase_produto
        group by tp.grupoproduto, fp.nm_fase_produto        
      else if @ic_resumo_fase='S'
        select
          fp.nm_fase_produto,
          sum(tp.qt_entrada_peps) as Qtd,
          sum(tp.vl_custo_valorizacao_peps) as Total
        from #TEMP_PEPS tp
        left outer join Fase_Produto fp on 
          fp.cd_fase_produto=tp.cd_fase_produto
        group by fp.nm_fase_produto        

        -- ELIAS 28/04/2004 - Passa a armazenar o custo total do produto,
        -- da forma como estava anteriormente armazenava somente o último custo
        Select          
          #TEMP_PEPS.cd_produto,   
          isnull(sum(#TEMP_PEPS.unitario),0) as unitario,
          isnull((sum(#TEMP_PEPS.unitario * #TEMP_PEPS.qt_valorizacao_peps)),0) as total,
          isnull(sum(qt_valorizacao_peps),0) as qt_valorizacao_peps
        into
          #TEMP_PEPS_Produto
        from
          #TEMP_PEPS
        group by
          #TEMP_PEPS.cd_produto
        order by 
          #TEMP_PEPS.cd_produto

--         Select          
--           #TEMP_PEPS.cd_produto,   
--           #TEMP_PEPS.unitario
--         into
--           #TEMP_PEPS_Produto
--         from
--           #TEMP_PEPS,
--           ( select cd_produto, MIN( dt_documento_entrada_peps ) as dt_documento_entrada_peps
--             from #TEMP_PEPS group by cd_produto ) as Peps_Min
--         where
--           #TEMP_PEPS.cd_produto = Peps_Min.cd_produto and
--           #TEMP_PEPS.dt_documento_entrada_peps = Peps_Min.dt_documento_entrada_peps       

        if @cd_fase_produto_comercial = @cd_fase_produto
          --Atualiza a produto custo
          update 
            Produto_Custo
          set 
            Produto_Custo.vl_custo_contabil_produto = cast(peps.unitario as decimal(18,2))
          from  
            Produto_Custo, 
            #TEMP_PEPS_Produto peps
          where 
            Produto_Custo.cd_produto = peps.cd_produto

        -- Atualiza a produto fechamento
        -- Armazena também o campo de custo peps do fechamento (??? não sei por que dois campos e por
        -- não saber qual dos dois é realmente utilizado o melhor é atualizar os dois ??? - ELIAS
        update 
          Produto_Fechamento
        set 
          Produto_Fechamento.vl_custo_prod_fechamento = cast(peps.total as money),
          Produto_Fechamento.vl_custo_peps_fechamento = cast(peps.total as money),
          --Carlos 04.02.2005
          Produto_Fechamento.qt_peps_prod_fechamento  = peps.qt_valorizacao_peps
        from  
          Produto_Fechamento, 
          #TEMP_PEPS_Produto peps
        where 
          Produto_Fechamento.cd_produto      = peps.cd_produto and
          Produto_Fechamento.cd_fase_produto = @cd_fase and  
          Produto_Fechamento.dt_produto_fechamento between @dt_inicial and @dt_final


        --Atualiza a produto saldo
        update 
          Produto_Saldo
        set 
          Produto_Saldo.vl_custo_contabil_produto = cast(peps.unitario as decimal(18,2))
        from  
          Produto_Saldo, 
          #TEMP_PEPS_Produto peps
        where 
          Produto_Saldo.cd_produto = peps.cd_produto and
          Produto_Saldo.cd_fase_produto = @cd_fase          


        drop table #TEMP_PEPS_Produto


    end
  ----------------------------------
  else -- Faz um select separado para as Divergências do PEPS
  ----------------------------------
    select
      a.cd_produto,
      sum(IsNull(a.qt_valorizacao_peps,0))                as 'Saldo_Peps',
      a.GrupoProduto,
      dbo.fn_mascara_produto(a.cd_produto)                as 'Codigo',
      a.Produto,
      ( select top 1 IsNull(pf.qt_atual_prod_fechamento,0)
        from 
	  Produto_Fechamento pf 
        where
          pf.cd_produto = a.cd_produto and
          pf.cd_fase_produto = @cd_fase and
          pf.dt_produto_fechamento between @dt_inicial and @dt_final
        order by pf.dt_produto_fechamento desc ) as 'Saldo_Fechamento',
      ( select top 1 pf.qt_terc_prod_fechamento
        from 
          Produto_Fechamento pf 
        where
          pf.cd_produto = a.cd_produto and
          pf.cd_fase_produto = @cd_fase and
          pf.dt_produto_fechamento between @dt_inicial and @dt_final
        order by pf.dt_produto_fechamento desc )                      as 'Terceiros',
      ( sum(IsNull(a.qt_valorizacao_peps,0)) - 
	((select top 1 IsNull(pf.qt_atual_prod_fechamento,0)
          from 
            Produto_Fechamento pf 
          where
            pf.cd_produto = a.cd_produto and
            pf.cd_fase_produto = @cd_fase and
            pf.dt_produto_fechamento between @dt_inicial and @dt_final
	  order by pf.dt_produto_fechamento desc ) +
      ( select top 1 IsNull(pf.qt_terc_prod_fechamento,0)
        from 
          Produto_Fechamento pf 
        where
          pf.cd_produto = a.cd_produto and
          pf.cd_fase_produto = @cd_fase and
          pf.dt_produto_fechamento between @dt_inicial and @dt_final
	order by pf.dt_produto_fechamento desc ) ) ) AS 'Divergencia'
    from
      #TEMP_PEPS a 
    group by
      a.cd_produto, a.GrupoProduto, a.Produto 
    Having 
      ( ( sum(IsNull(a.qt_valorizacao_peps,0)) <> 
        ( select top 1 IsNull(pf.qt_atual_prod_fechamento ,0)
          from 
  	    Produto_Fechamento pf 
          where
            pf.cd_produto = a.cd_produto and
            pf.cd_fase_produto = @cd_fase and
            pf.dt_produto_fechamento between @dt_inicial and @dt_final
	 order by pf.dt_produto_fechamento desc ) ) and
      ( @ic_filtro_divergencia = 'C' ) ) or
        ( ( sum(IsNull(a.qt_valorizacao_peps,0)) <> 
    	  ( ( select top 1 IsNull(pf.qt_atual_prod_fechamento,0)
              from 
	        Produto_Fechamento pf 
              where
                pf.cd_produto = a.cd_produto and
      pf.cd_fase_produto = @cd_fase and
                pf.dt_produto_fechamento between @dt_inicial and @dt_final
              order by pf.dt_produto_fechamento desc ) +
          ( select top 1 IsNull(pf.qt_terc_prod_fechamento ,0)
            from 
	      Produto_Fechamento pf 
            where
              pf.cd_produto = a.cd_produto and
              pf.cd_fase_produto = @cd_fase and
              pf.dt_produto_fechamento between @dt_inicial and @dt_final
	    order by pf.dt_produto_fechamento desc ) ) ) and
      ( @ic_filtro_divergencia = 'D' ) )        



      drop table #TEMP_PEPS
end

-------------------------------------------------
if @ic_parametro_peps = 2 --Por Grupo de Produto
-------------------------------------------------
begin
  while exists(select top 1 cd_fase_produto from #Fase_Temp) 
    begin
      set @cd_fase= (select top 1 cd_fase_produto from #Fase_Temp)

	  if (isnull(@cd_grupo_produto_inicial,0)=0)
  		set @cd_grupo_produto_inicial = 0

 	  if (isnull(@cd_grupo_produto_final,0)=0)
    		set @cd_grupo_produto_final = 999999
   
		  -- Utilizando CURSOR para melhorar a performance - ELIAS 20/10/2003
		  declare cCalculoPEPS cursor for
		  select distinct
		    p.cd_mascara_produto,
    	            p.cd_produto,
		    pf.qt_atual_prod_fechamento + pf.qt_terc_prod_fechamento as qt_saldo_produto
		  from 
       		Produto p, 
		    Produto_Fechamento pf, 
    		Nota_Entrada_PEPS nep
		  where 
    		nep.cd_produto = p.cd_produto and
		    p.cd_grupo_produto between @cd_grupo_produto_inicial and @cd_grupo_produto_final and
    		p.cd_produto = pf.cd_produto and
		    pf.cd_fase_produto = @cd_fase and
    		pf.dt_produto_fechamento between @dt_inicial and @dt_final and
		    ((pf.qt_atual_prod_fechamento + pf.qt_terc_prod_fechamento) > 0) 
		  order by
    		p.cd_mascara_produto

		  open cCalculoPEPS  
  
		  fetch next from cCalculoPEPS into @cd_mascara_produto, @cd_produto, @qt_saldo_produto

		  while @@fetch_status = 0
		  begin                      
     
		    -- Zera as Variáveis de Cálculo da Tabela CADPEPS
    		update Nota_Entrada_Peps
		    set 
    		  qt_valorizacao_peps        = 0,
		      vl_custo_valorizacao_peps  = 0
    		where 
		      cd_produto = @cd_produto

		    declare cNotaEntradaPEPS cursor for
    		select 
		      nep.cd_documento_entrada_peps,
    		  isnull(nep.cd_item_documento_entrada,0) as 'cd_item_documento_aux', -- Ludinei (11/08)
		      nep.qt_entrada_peps,
    		  nep.vl_custo_total_peps
		    from 
    		  Nota_Entrada_Peps nep left outer join 
		  Produto_Custo     pc  on nep.cd_produto = pc.cd_produto
    		where
		  nep.cd_produto = @cd_produto and
    	          dt_documento_entrada_peps <= @dt_final and
                  nep.cd_fase_produto        = @cd_fase_produto and
		  isnull(pc.ic_peps_produto,'S')='S'
    		order by
		      dt_documento_entrada_peps desc
	
  		  set @qt_peps_aux      = 0
		    set @qt_itens_peps    = 0
    		set @qt_saldo_estoque = 0

		    open cNotaEntradaPEPS
  	
    		fetch next from cNotaEntradaPEPS into @cd_nota_fiscal, @cd_item_nota_fiscal,
        		                                  @qt_nota_fiscal, @vl_custo_peps

		    set @cd_seq_peps = 0
    		set @qt_registros = @@cursor_rows

		    while @@fetch_status = 0
    		begin                              
         
		      set @cd_seq_peps = @cd_seq_peps + 1
		
		  if @cd_seq_peps = 1
			     begin  
  		       set @cd_produto_first          = @cd_produto
  	   		   set @cd_nota_fiscal_first      = @cd_nota_fiscal
			       set @cd_item_nota_fiscal_first = @cd_item_nota_fiscal
	  		     set @qt_nota_fiscal_first      = @qt_nota_fiscal
			     end

    		  set @qt_peps = @qt_nota_fiscal          

	        if @qt_saldo_produto < ( @qt_peps_aux + @qt_nota_fiscal ) 
	    		  begin
			        set @vl_custo_peps = (@vl_custo_peps/@qt_nota_fiscal)*( @qt_saldo_produto-@qt_peps_aux )

  		        if @vl_custo_peps < 0.01
  	  		      set @vl_custo_peps = 0.01                    

		 		      set @qt_peps     = round(@qt_saldo_produto,4)-round(@qt_peps_aux,4)
 		  		    set @qt_peps_aux = round(@qt_saldo_produto,4)
			      end
    		  else
		        set @qt_peps_aux = round(@qt_peps_aux,4) + round(@qt_nota_fiscal,4)

		      -- Atualiza o CADPEPS com Valores para PEPS     
      		set @qt_valorado_peps = round(@qt_saldo_produto,4) - round((@qt_saldo_produto - @qt_peps),4)  -- Ludinei/Adriano 19/08

       		set @qt_itens_peps = round(@qt_itens_peps,4) + round(@qt_peps,4)

		      if @qt_registros = 1
    		    set @qt_saldo_estoque = round(@qt_saldo_produto,4) - round(@qt_itens_peps,4)

		      update Nota_Entrada_Peps
    		    set qt_valorizacao_peps = case when @ic_tipo_valoracao = 'F' then round(@qt_valorado_peps,4) -- Ludinei/Adriano 19/08 
  				else round(@qt_peps,4) end,
            vl_custo_valorizacao_peps = case when @ic_tipo_valoracao = 'F' then 
                                          case when isnull(round(@qt_peps,4),0) = 0 then 
                                            ((@vl_custo_peps/1)*isnull(round(@qt_valorado_peps,4),1)) 
                                          else
                                            ((@vl_custo_peps/round(@qt_peps,4))*isnull(round(@qt_valorado_peps,4),round(@qt_peps,4)))
                                          end
                                        else 
                                          @vl_custo_peps 
                                        end  
       		where
        	  (cd_produto = @cd_produto) and
		        cd_documento_entrada_peps = @cd_nota_fiscal and
					  isnull(cd_item_documento_entrada,0) = @cd_item_nota_fiscal and -- Ludinei (11/08)
      		  round(qt_entrada_peps,4) = round(@qt_nota_fiscal,4)


		      if @qt_registros = 1
	  		    begin

          
              update Nota_Entrada_Peps
              set 
                qt_valorizacao_peps       = round(qt_valorizacao_peps,4) + round(@qt_saldo_estoque,4),
			          vl_custo_valorizacao_peps = (vl_custo_total_peps/round(qt_entrada_peps,4)) * (round(qt_valorizacao_peps,4) + round(@qt_saldo_estoque,4))
      			  where
          			(cd_produto=@cd_produto) and
			          cd_documento_entrada_peps = @cd_nota_fiscal_first and
	    		      isnull(cd_item_documento_entrada,0) = @cd_item_nota_fiscal_first and -- Ludinei (11/08)
          			round(qt_entrada_peps,0) = round(@qt_nota_fiscal_first,4)

	        end
                         

	       set @qt_registros=@qt_registros-1
        
         Select top 1
           @vl_preco_entrada_peps_produto = vl_preco_entrada_peps 
         from 
           Nota_Entrada_Peps
         where
            cd_produto = @cd_produto and
            dt_documento_entrada_peps between @dt_inicial and @dt_final
         order by
            dt_documento_entrada_peps asc


  	     -- Deleta Nota Fiscal do Arquivo Auxilar
    	   fetch next from cNotaEntradaPEPS into @cd_nota_fiscal, @cd_item_nota_fiscal,
                                               @qt_nota_fiscal, @vl_custo_peps     

    	  end
        
        close cNotaEntradaPEPS
        deallocate cNotaEntradaPEPS


				
				if ( @ic_forma_ordenacao  = 'F' )
			    insert into #TEMP_PEPS
	  		  select
		    	  mv.cd_movimento_estoque,
		  	    a.cd_produto,
			      a.cd_fornecedor,
				    a.cd_documento_entrada_peps,
	    		 	a.cd_item_documento_entrada,
			     	a.qt_entrada_peps,
	  		    a.vl_preco_entrada_peps,
		  	   	a.vl_custo_total_peps,
		  	 	  a.qt_valorizacao_peps,
			      a.vl_custo_valorizacao_peps,
	  		    a.vl_fob_entrada_peps,
			      a.cd_usuario,
	  		   	a.dt_usuario,
		  	 	  a.dt_documento_entrada_peps,
		  	    a.cd_fase_produto,
			      a.cd_controle_nota_entrada,
	  		    a.dt_controle_nota_entrada,
			      (isnull(a.vl_custo_valorizacao_peps,0) / a.qt_valorizacao_peps) as 'Unitario',
	  		    isnull(b.nm_fantasia_fornecedor,'Ajuste')             as 'Fornecedor' ,
		  	    gp.nm_grupo_produto                                   as 'GrupoProduto',
		  	    dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto,c.cd_mascara_produto) as 'Codigo',
			      c.nm_fantasia_produto                                 as 'Produto',
	  		    c.nm_produto                                          as 'Descricao',
                            isnull(um.sg_unidade_medida,'')                       as 'Unidade',
                            a.qt_peso_entrada_peps
	  		  from
		  	    Nota_Entrada_Peps a left outer join Movimento_Estoque mv on
		  	    a.cd_movimento_estoque = mv.cd_movimento_estoque and
			      mv.cd_fase_produto = @cd_fase
	  		    left outer join Fornecedor b on b.cd_fornecedor = a.cd_fornecedor
			      left outer join Produto c on c.cd_produto = a.cd_produto
	  		    left outer join Grupo_Produto gp on gp.cd_grupo_produto = c.cd_grupo_produto  
		  	    left outer join Unidade_Medida um on um.cd_unidade_medida = c.cd_unidade_medida
		  	  where
			      a.cd_produto = @cd_produto and
                              a.cd_fase_produto        = @cd_fase_produto and
	  		      isnull(a.qt_valorizacao_peps,0 ) > 0 and
                              a.dt_documento_entrada_peps <= @dt_final
			    order by
	  		    c.nm_fantasia_produto asc, a.dt_documento_entrada_peps desc
				else
			    insert into #TEMP_PEPS
	  		  select
		    	  mv.cd_movimento_estoque,
		  	    a.cd_produto,
			      a.cd_fornecedor,
				    a.cd_documento_entrada_peps,
	    		 	a.cd_item_documento_entrada,
			     	a.qt_entrada_peps,
	  		    a.vl_preco_entrada_peps,
		  	   	a.vl_custo_total_peps,
		  	 	  a.qt_valorizacao_peps,
			      a.vl_custo_valorizacao_peps,
	  		    a.vl_fob_entrada_peps,
			      a.cd_usuario,
	  		   	a.dt_usuario,
		  	 	  a.dt_documento_entrada_peps,
		  	    a.cd_fase_produto,
			      a.cd_controle_nota_entrada,
	  		    a.dt_controle_nota_entrada,
			      (a.vl_custo_valorizacao_peps / a.qt_valorizacao_peps) as 'Unitario',
	  		    isnull(b.nm_fantasia_fornecedor,'Ajuste')             as 'Fornecedor' ,
		  	    gp.nm_grupo_produto                                   as 'GrupoProduto',
		  	    dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto,c.cd_mascara_produto) as 'Codigo',
			      c.nm_fantasia_produto                                 as 'Produto',
	  		    c.nm_produto                                          as 'Descricao',
			      isnull(um.sg_unidade_medida,'')                       as 'Unidade',
                              a.qt_peso_entrada_peps           
	  		  from
		  	    Nota_Entrada_Peps a left outer join Movimento_Estoque mv on
		  	    a.cd_movimento_estoque = mv.cd_movimento_estoque and
			      mv.cd_fase_produto = @cd_fase
	  		    left outer join Fornecedor b on b.cd_fornecedor = a.cd_fornecedor
			      left outer join Produto c on c.cd_produto = a.cd_produto
	  		    left outer join Grupo_Produto gp on gp.cd_grupo_produto = c.cd_grupo_produto  
		  	    left outer join Unidade_Medida um on um.cd_unidade_medida = c.cd_unidade_medida
		  	  where
			      a.cd_produto = @cd_produto and
	  		    isnull(a.qt_valorizacao_peps,0 ) > 0 and
        a.dt_documento_entrada_peps <= @dt_final     
			    order by
	  		    dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto,c.cd_mascara_produto) asc, a.dt_documento_entrada_peps desc


        fetch next from cCalculoPEPS into @cd_mascara_produto, @cd_produto, @qt_saldo_produto           
	     end      

      delete from #Fase_Temp where cd_fase_produto=@cd_fase

	  	close cCalculoPEPS
  		deallocate cCalculoPEPS
    end

  ------------------------------------
if @ic_filtro_divergencia = 'N'
  ------------------------------------
    begin
      if @ic_resumo_grupo='N' and @ic_resumo_fase='N'
      begin
        -- ELIAS 03/03/2004 - Ordenando por Grupo, antes de qualquer coisa
        if @ic_forma_ordenacao <> 'F'
           select * from #TEMP_PEPS order by GrupoProduto, codigo, dt_documento_entrada_peps desc
        else
           select * from #TEMP_PEPS order by GrupoProduto, Produto, dt_documento_entrada_peps desc
      end

      else if @ic_resumo_grupo='S'
        select
          tp.grupoproduto,
          sum(tp.qt_entrada_peps) as Qtd,
          fp.nm_fase_produto,
          sum(tp.vl_custo_valorizacao_peps) as Total
        from #TEMP_PEPS tp
        left outer join Fase_Produto fp on 
          fp.cd_fase_produto=tp.cd_fase_produto
        group by tp.grupoproduto, fp.nm_fase_produto        

      else if @ic_resumo_fase='S'
        select
          fp.nm_fase_produto,
          sum(tp.qt_entrada_peps) as Qtd,
          sum(tp.vl_custo_valorizacao_peps) as Total
        from #TEMP_PEPS tp
        left outer join Fase_Produto fp on 
          fp.cd_fase_produto=tp.cd_fase_produto
        group by fp.nm_fase_produto        
    end

  ----------------------------------
  else -- Faz um select separado para as Divergências do PEPS
  ----------------------------------
    select
      sum(IsNull(a.qt_valorizacao_peps,0))                as 'Saldo_Peps',
      a.GrupoProduto,
      dbo.fn_mascara_produto(a.cd_produto)                as 'Codigo',
      a.Produto,
      ( select top 1 IsNull(pf.qt_atual_prod_fechamento,0)
            from 
	      Produto_Fechamento pf 
            where
              pf.cd_produto = a.cd_produto and
              pf.cd_fase_produto = @cd_fase and
              pf.dt_produto_fechamento between @dt_inicial and @dt_final
	    order by pf.dt_produto_fechamento desc ) as 'Saldo_Fechamento',
        ( select top 1 pf.qt_terc_prod_fechamento
            from 
	      Produto_Fechamento pf 
            where
              pf.cd_produto = a.cd_produto and
              pf.cd_fase_produto = @cd_fase and
              pf.dt_produto_fechamento between @dt_inicial and @dt_final
	    order by pf.dt_produto_fechamento desc )                      as 'Terceiros',
      ( sum(IsNull(a.qt_valorizacao_peps,0)) - 
  	    ( ( select top 1 IsNull(pf.qt_atual_prod_fechamento,0)
            from 
	            Produto_Fechamento pf 
            where
              pf.cd_produto = a.cd_produto and
              pf.cd_fase_produto = @cd_fase and
              pf.dt_produto_fechamento between @dt_inicial and @dt_final
	          order by pf.dt_produto_fechamento desc ) +
          ( select top 1 IsNull(pf.qt_terc_prod_fechamento,0)
            from 
      	      Produto_Fechamento pf 
            where
              pf.cd_produto = a.cd_produto and
              pf.cd_fase_produto = @cd_fase and
              pf.dt_produto_fechamento between @dt_inicial and @dt_final
	          order by pf.dt_produto_fechamento desc ) ) ) AS 'Divergencia'
      from
        #TEMP_PEPS a 
      group by
        a.cd_produto, a.GrupoProduto, a.Produto
      Having 
      	( ( sum(IsNull(a.qt_valorizacao_peps,0)) <> 
        	( select top 1 IsNull(pf.qt_atual_prod_fechamento ,0)
            from 
				      Produto_Fechamento pf 
      	    where
              pf.cd_produto = a.cd_produto and
              pf.cd_fase_produto = @cd_fase and
              pf.dt_produto_fechamento between @dt_inicial and @dt_final
	    			order by pf.dt_produto_fechamento desc ) ) and
				( @ic_filtro_divergencia = 'C' ) ) or
      		( ( sum(IsNull(a.qt_valorizacao_peps,0)) <> 
					( ( select top 1 IsNull(pf.qt_atual_prod_fechamento,0)
        		  from 
					      Produto_Fechamento pf 
        	    where
          	    pf.cd_produto = a.cd_produto and
            	  pf.cd_fase_produto = @cd_fase and
	pf.dt_produto_fechamento between @dt_inicial and @dt_final
					    order by pf.dt_produto_fechamento desc ) +
          	( select top 1 IsNull(pf.qt_terc_prod_fechamento ,0)
        	from 
					      Produto_Fechamento pf 
        	    where
          	    pf.cd_produto = a.cd_produto and
            	  pf.cd_fase_produto = @cd_fase and
              	pf.dt_produto_fechamento between @dt_inicial and @dt_final
					    order by pf.dt_produto_fechamento desc ) ) ) and
        	( @ic_filtro_divergencia = 'D' ) )


    --Caso não for apenas para verificar divergências ele atualiza as tabelas de produto_custo, produto_saldo e Produto_fechamento
    if @ic_filtro_divergencia = 'N'
    begin
 
        -- ELIAS 28/04/2004 - Passa a armazenar o custo total do produto,
        -- da forma como estava anteriormente armazenava somente o último custo
        Select          
          #TEMP_PEPS.cd_produto,   
          isnull(sum(#TEMP_PEPS.unitario),0) as unitario,
          isnull((sum(#TEMP_PEPS.unitario * #TEMP_PEPS.qt_valorizacao_peps)),0) as total,
          isnull(sum(#TEMP_PEPS.qt_valorizacao_peps),0) as qt_valorizacao_peps
        into
          #TEMP_PEPS_Atualiza
        from
          #TEMP_PEPS
        group by
          #TEMP_PEPS.cd_produto
        order by 
          #TEMP_PEPS.cd_produto

--         Select 
--           #TEMP_PEPS.cd_produto,   
--           #TEMP_PEPS.unitario
--         into
--           #TEMP_PEPS_Atualiza
--         from
--           #TEMP_PEPS,
--           ( select cd_produto, MIN( dt_documento_entrada_peps ) as dt_documento_entrada_peps
--             from #TEMP_PEPS group by cd_produto ) as Peps_Min
--         where
--           #TEMP_PEPS.cd_produto = Peps_Min.cd_produto and
--           #TEMP_PEPS.dt_documento_entrada_peps = Peps_Min.dt_documento_entrada_peps

        if @cd_fase_produto_comercial = @cd_fase_produto
          --Atualiza a produto custo
          update 
            Produto_Custo
          set 
            Produto_Custo.vl_custo_contabil_produto = cast(peps.unitario as decimal(18,2))
          from  
            Produto_Custo, 
            #TEMP_PEPS_Atualiza peps
          where 
            Produto_Custo.cd_produto = peps.cd_produto

        -- Atualiza a produto fechamento
        -- Armazena também o campo de custo peps do fechamento (??? não sei por que dois campos e por
        -- não saber qual dos dois é realmente utilizado o melhor é atualizar os dois ??? - ELIAS
        update 
          Produto_Fechamento
        set 
          Produto_Fechamento.vl_custo_prod_fechamento = cast(peps.total as money),
          Produto_Fechamento.vl_custo_peps_fechamento = cast(peps.total as money),
          --Carlos 04.02.2005
          Produto_Fechamento.qt_peps_prod_fechamento  = peps.qt_valorizacao_peps
        from  
          Produto_Fechamento, 
          #TEMP_PEPS_Atualiza peps
        where 
          Produto_Fechamento.cd_produto = peps.cd_produto and
          Produto_Fechamento.cd_fase_produto = @cd_fase and  
          Produto_Fechamento.dt_produto_fechamento between @dt_inicial and @dt_final

        --Atualiza a produto saldo
        update 
          Produto_Saldo
        set 
          Produto_Saldo.vl_custo_contabil_produto = cast(peps.unitario as decimal(18,2))
        from  
          Produto_Saldo, 
          #TEMP_PEPS_Atualiza peps
        where 
          Produto_Saldo.cd_produto = peps.cd_produto and
          Produto_Saldo.cd_fase_produto = @cd_fase          

        drop table #TEMP_PEPS_Atualiza

    end


 
  drop table #TEMP_PEPS

  
end



