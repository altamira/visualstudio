
----------------------------------------------------------------------------------
--pr_calculo_calculo_valoracao_estoque
----------------------------------------------------------------------------------
--Global Business Solution Ltda                                               2004
----------------------------------------------------------------------------------
--Stored Procedure     : SQL Server Microsoft 2000
--Autor (es)           : Carlos Cardoso Fernandes         
--Banco Dados          : EGISSQL
--Objetivo             : Cálculo do Estoque - Valoração do Estoque
--Data                 : 12.08.2005
--Atualizado           : 
--                     : 
---------------------------------------------------------------------------------------------
CREATE   procedure pr_calculo_valoracao_estoque
@ic_parametro_peps         int,         --Parâmetros
@dt_inicial                datetime,
@dt_final                  datetime,
@cd_produto                int,
@cd_grupo_produto_inicial  int,
@cd_grupo_produto_final    int,
@cd_fase_produto           int,
@ic_filtro_divergencia     char(1) = 'N',
@ic_resumo_grupo           char(1) = 'N',
@ic_resumo_fase            char(1) = 'N',
@cd_usuario                int     = 0
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
declare @cd_mascara_produto  varchar(20)
declare @ic_tipo_valoracao   char(1)
declare @qt_valoracao        float
declare @vl_custo_valoracao  float
declare @ic_peso_peps        char(1)
declare @ic_forma_ordenacao  char(1)

declare @cd_fase_produto_comercial int

set @ic_tipo_valoracao ='F' 
set @mm_calculo        = month( @dt_final )
set @aa_calculo        = year ( @dt_final )

--Define a forma de exibição
select @ic_forma_ordenacao = IsNull(ic_exibicao_padrao_prod,'F') from parametro_custo where cd_empresa = dbo.fn_empresa()

--Define fase comercial a ser atualizada no custo contabil do produto
select top 1 @cd_fase_produto_comercial = cd_fase_produto from Parametro_Comercial where cd_empresa = dbo.fn_empresa()

if ( IsNull(@ic_forma_ordenacao,'') = '' )
  set @ic_forma_ordenacao = 'F'

Create table #TEMP_CALCULO(
  cd_produto                int Null,
  qt_valoracao              float null,
  vl_custo_valoracao        float null,
  cd_usuario                int null,
  dt_usuario                datetime null,
  cd_fase_produto           int null,
  grupoProduto              varchar(40) null,
  codigo                    varchar(15) null,
  produto                   varchar(30) null,
  descricao                 varchar(60) null,
  unidade                   varchar(2)  null)

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

declare @pc_metodo_valoracao float
declare @qt_metodo_valoracao float

-------------------------------------------------
if @ic_parametro_peps = 1 --Por Produto
-------------------------------------------------
begin

  while exists(select top 1 cd_fase_produto from #Fase_Temp) 
    begin

      set @cd_fase = (select top 1 cd_fase_produto from #Fase_Temp)

      select 
        @qt_saldo_produto    = isnull(pf.qt_atual_prod_fechamento,0)+isnull(pf.qt_terc_prod_fechamento,0),
        @pc_metodo_valoracao = isnull(mv.pc_metodo_valoracao,0),
        @qt_metodo_valoracao = case when isnull(mv.qt_metodo_valoracao,1)=0 then 1 else isnull(mv.qt_metodo_valoracao,1) end,
        @vl_custo_valoracao  = case when isnull(mv.pc_metodo_valoracao,0)<>0 then p.vl_produto else pc.vl_custo_produto end
      from 
        Produto_Fechamento pf 
        left outer join produto p                   on p.cd_produto           = pf.cd_produto 
        left outer join produto_custo pc            on pc.cd_produto          = p.cd_produto
        left outer join grupo_produto gp            on gp.cd_grupo_produto    = p.cd_grupo_produto
        left outer join grupo_produto_valoracao gpv on gpv.cd_grupo_produto   = gp.cd_grupo_produto and
                                                       gpv.cd_fase_produto    = @cd_fase
        left outer join metodo_valoracao        mv  on mv.cd_metodo_valoracao = gpv.cd_metodo_valoracao     
      where 
        pf.cd_produto      = @cd_produto  and 
        pf.cd_fase_produto = @cd_fase     and  
        pf.dt_produto_fechamento between @dt_inicial and @dt_final
 
      --select @qt_saldo_produto,@cd_fase,@vl_custo_valoracao,@pc_metodo_valoracao,@qt_metodo_valoracao
      --select * from produto_fechamento
      --select * from metodo_valoracao
      -- Apresentacao do Cálculo 

      select
        p.cd_produto,          
        @qt_saldo_produto     as qt_valoracao,
        ( @vl_custo_valoracao *( case when @pc_metodo_valoracao/100=0 then 1 else @pc_metodo_valoracao/100 end ) * @qt_metodo_valoracao ) 
                              as vl_custo_valoracao,
        @cd_usuario           as cd_usuario,
        getdate()             as dt_usuario,
        @cd_fase              as cd_fase_produto,
        gp.nm_grupo_produto   as grupoProduto,
        p.cd_mascara_produto  as codigo,   
        p.nm_fantasia_produto as produto,   
        p.nm_produto          as descricao,
        um.sg_unidade_medida  as unidade
      from
        Produto p
        left outer join grupo_produto gp  on gp.cd_grupo_produto  = p.cd_grupo_produto 
        left outer join unidade_medida um on um.cd_unidade_medida = p.cd_unidade_medida
      where
        p.cd_produto      = @cd_produto  
 
        
      delete from #Fase_Temp where cd_fase_produto=@cd_fase

    end
   
   -- select * from #Temp_CALCULO

end

-------------------------------------------------
if @ic_parametro_peps = 2 --Por Grupo de Produto
-------------------------------------------------
begin

  print ''

   while exists(select top 1 cd_fase_produto from #Fase_Temp) 
     begin
       set @cd_fase= (select top 1 cd_fase_produto from #Fase_Temp)
 
 	  if (isnull(@cd_grupo_produto_inicial,0)=0)
   		set @cd_grupo_produto_inicial = 0
 
  	  if (isnull(@cd_grupo_produto_final,0)=0)
     		set @cd_grupo_produto_final = 999999
    
 		  -- Utilizando CURSOR para melhorar a performance - ELIAS 20/10/2003
 		  declare cCalculo cursor for
 		  select distinct
 		    p.cd_mascara_produto,
     	            p.cd_produto,
 		    isnull(pf.qt_atual_prod_fechamento,0) + isnull(pf.qt_terc_prod_fechamento,0) as qt_saldo_produto
 		  from 
        		Produto p, 
 		    Produto_Fechamento pf
		  where 
 		    p.cd_grupo_produto between @cd_grupo_produto_inicial and @cd_grupo_produto_final and
     		p.cd_produto = pf.cd_produto and
 		    pf.cd_fase_produto = @cd_fase and
     		pf.dt_produto_fechamento between @dt_inicial and @dt_final and
 		    ((isnull(pf.qt_atual_prod_fechamento,0) + isnull(pf.qt_terc_prod_fechamento,0)) > 0) 
 		  order by
     		p.cd_mascara_produto
 
       end    

-- 
-- 
-- 				
-- 				if ( @ic_forma_ordenacao  = 'F' )
-- 			    insert into #TEMP_PEPS
-- 	  		  select
-- 		    	  mv.cd_movimento_estoque,
-- 		  	    a.cd_produto,
-- 			      a.cd_fornecedor,
-- 				    a.cd_documento_entrada_peps,
-- 	    		 	a.cd_item_documento_entrada,
-- 			     	a.qt_entrada_peps,
-- 	  		    a.vl_preco_entrada_peps,
-- 		  	   	a.vl_custo_total_peps,
-- 		  	 	  a.qt_valorizacao_peps,
-- 			      a.vl_custo_valorizacao_peps,
-- 	  		    a.vl_fob_entrada_peps,
-- 			      a.cd_usuario,
-- 	  		   	a.dt_usuario,
-- 		  	 	  a.dt_documento_entrada_peps,
-- 		  	    a.cd_fase_produto,
-- 			      a.cd_controle_nota_entrada,
-- 	  		    a.dt_controle_nota_entrada,
-- 			      (isnull(a.vl_custo_valorizacao_peps,0) / a.') as 'Unitario',
-- 	  		    isnull(b.nm_fantasia_fornecedor,'Ajuste')             as 'Fornecedor' ,
-- 		  	    gp.nm_grupo_produto                                   as 'GrupoProduto',
-- 		  	    dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto,c.cd_mascara_produto) as 'Codigo',
-- 			      c.nm_fantasia_produto                                 as 'Produto',
-- 	  		    c.nm_produto                                          as 'Descricao',
--                             isnull(um.sg_unidade_medida,'')                       as 'Unidade',
--                             a.qt_peso_entrada_peps
-- 	  		  from
-- 		  	    Nota_Entrada_Peps a left outer join Movimento_Estoque mv on
-- 		  	    a.cd_movimento_estoque = mv.cd_movimento_estoque and
-- 			      mv.cd_fase_produto = @cd_fase
-- 	  		    left outer join Fornecedor b on b.cd_fornecedor = a.cd_fornecedor
-- 			      left outer join Produto c on c.cd_produto = a.cd_produto
-- 	  		    left outer join Grupo_Produto gp on gp.cd_grupo_produto = c.cd_grupo_produto  
-- 		  	    left outer join Unidade_Medida um on um.cd_unidade_medida = c.cd_unidade_medida
-- 		  	  where
-- 			      a.cd_produto = @cd_produto and
--                               a.cd_fase_produto        = @cd_fase_produto and
-- 	  		      isnull(a.qt_valorizacao_peps,0 ) > 0 and
--                               a.dt_documento_entrada_peps <= @dt_final
-- 			    order by
-- 	  		    c.nm_fantasia_produto asc, a.dt_documento_entrada_peps desc
-- 				else
-- 			    insert into #TEMP_PEPS
-- 	  		  select
-- 		    	  mv.cd_movimento_estoque,
-- 		  	    a.cd_produto,
-- 			      a.cd_fornecedor,
-- 				    a.cd_documento_entrada_peps,
-- 	    		 	a.cd_item_documento_entrada,
-- 			     	a.qt_entrada_peps,
-- 	  		    a.vl_preco_entrada_peps,
-- 		  	   	a.vl_custo_total_peps,
-- 		  	 	  a.qt_valorizacao_peps,
-- 			      a.vl_custo_valorizacao_peps,
-- 	  		    a.vl_fob_entrada_peps,
-- 			      a.cd_usuario,
-- 	  		   	a.dt_usuario,
-- 		  	 	  a.dt_documento_entrada_peps,
-- 		  	    a.cd_fase_produto,
-- 			      a.cd_controle_nota_entrada,
-- 	  		    a.dt_controle_nota_entrada,
-- 			      (a.vl_custo_valorizacao_peps / a.qt_valorizacao_peps) as 'Unitario',
-- 	  		    isnull(b.nm_fantasia_fornecedor,'Ajuste')             as 'Fornecedor' ,
-- 		  	    gp.nm_grupo_produto                                   as 'GrupoProduto',
-- 		  	    dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto,c.cd_mascara_produto) as 'Codigo',
-- 			      c.nm_fantasia_produto                                 as 'Produto',
-- 	  		    c.nm_produto                                          as 'Descricao',
-- 			      isnull(um.sg_unidade_medida,'')                       as 'Unidade',
--                               a.qt_peso_entrada_peps           
-- 	  		  from
-- 		  	    Nota_Entrada_Peps a left outer join Movimento_Estoque mv on
-- 		  	    a.cd_movimento_estoque = mv.cd_movimento_estoque and
-- 			      mv.cd_fase_produto = @cd_fase
-- 	  		    left outer join Fornecedor b on b.cd_fornecedor = a.cd_fornecedor
-- 			      left outer join Produto c on c.cd_produto = a.cd_produto
-- 	  		    left outer join Grupo_Produto gp on gp.cd_grupo_produto = c.cd_grupo_produto  
-- 		  	    left outer join Unidade_Medida um on um.cd_unidade_medida = c.cd_unidade_medida
-- 		  	  where
-- 			      a.cd_produto = @cd_produto and
-- 	  		    isnull(a.qt_valorizacao_peps,0 ) > 0 and
--         a.dt_documento_entrada_peps <= @dt_final     
-- 			    order by
-- 	  		    dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto,c.cd_mascara_produto) asc, a.dt_documento_entrada_peps desc
-- 
-- 
--         fetch next from cCalculoPEPS into @cd_mascara_produto, @cd_produto, @qt_saldo_produto           
-- 	     end      
-- 
--       delete from #Fase_Temp where cd_fase_produto=@cd_fase
-- 
--     end
-- 
  
end



