
CREATE PROCEDURE pr_calculo_preco_venda_produto
-------------------------------------------------------------------------------------------------------------------
--pr_calculo_preco_venda_produto
-------------------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                     2004
-------------------------------------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Rodolpho
--Banco de Dados	: EGISSQL
--Objetivo		: Calcular Preço de Venda do Produto 
--Data			: 02/09/2004 
--                      : 14/09/04   - Modificado para Somar o Percentual Simples da Função de Markup - ELIAS
--Atualização           : 04/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--                      : 21/02/2005 - Acertos Diversos - Carlos Fernandes
--                      : 15.10.2005 - Moficação do Cálculo para Busca do Tipo de Lucro/Aplicação do Markup
--                                     da Categoria do produto, caso no Produto estiver zerado - Carlos Fernandes.
--                      : 07.01.2006 - Verificação da Busca do preço de Custo Reposição/Preço Mercado conforme
--                                     Configuração do parâmetro - Carlos Fernandes.
--                      : 28.02.2007 - Separação do Componentes do markup na Fórmula - Carlos Fernandes
-- 16.01.2008 - Cálculo do Preço de Venda - Através do ICMS da Classificação Fiscal  - Carlos Fernandes
-- 12.02.2008 - Arredondamento do Preço de Venda - Carlos Fernandes
-- 19.05.2008 - Categoria do Produto             - Carlos Fernandes
-- 20.08.2009 - Ajuste do Cálculo quando a Soma do Markup - Ultrapassa 100% ( somar 1 ) - Carlos Fernandes
-- 24.02.2010 - Filtro p/ Produto - Carlos Fernande
-------------------------------------------------------------------------------------------------------------------
@ic_parametro 		  int,
@nm_fantasia_produto  	  varchar(30) = '',
@cd_serie_produto 	  int,
@cd_fase_produto          int,
@nm_fantasia_destinatario varchar(30) = '',
@cd_fornecedor            int,
@cd_grupo_produto         int = 0,
@cd_mascara_produto	  varchar(30) = '',
@cd_status_produto        int = 0,
@cd_procedencia_produto   int = 0,
@ic_custo_zerado          varchar(1), 
@ic_comercial             varchar(1),
@ic_compra                varchar(1),
@ic_producao              varchar(1),
@ic_importacao            varchar(1),
@ic_exportacao            varchar(1),
@ic_beneficiamento        varchar(1),
@ic_amostra               varchar(1),
@ic_consignacao           varchar(1),
@ic_transferencia         varchar(1),
@ic_sob_encomenda         varchar(1),
@ic_revenda               varchar(1),
@ic_assistencia_tecnica   varchar(1),
@ic_almoxarifado          varchar(1),
@cd_tipo_destinatario     int = 1, -- Tipo de Destinatário padrão: Cliente
@cd_grupo_preco_produto   int = 0

AS

-------------------------------------------------------------------------------------------------------------------
--Tipos de Preços de Custo
-------------------------------------------------------------------------------------------------------------------
--Custo Contábil      = C
--Custo de mercado    = M
--Custo de Reposição  = R
--Custo Última Compra = U
-------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------
--REGRAS PARA BUSCA DA APLICACACAO DO MARKUP / TIPO DE LUCRO
-------------------------------------------------------------------------------------------------------------------
--1o. PRODUTO                  - Caso não estiver Vazio ( Tabela : Produto_Custo )
--2o. GRUPO PRODUTO            - Caso não estiver Vazio ( Tabela : Grupo_Produto_Custo )
--3o. CATEGORIA PRODUTO        - Caso não estiver Vazio ( Tabela : Categoria_Produto )
--4o. PARAMETRO FORMAÇÃO PREÇO - Caso todos acima estiver vazio ( Tabela : Parametro_Formacao_Preco )
--
--15.10.2005 - Carlos Fernandes 
-------------------------------------------------------------------------------------------------------------------
declare @cd_aplicacao_markup int
declare @cd_tipo_lucro       int 
declare @ic_tipo_preco_custo char(1)

--select * from parametro_formacao_preco

select
  @cd_aplicacao_markup = isnull(cd_aplicacao_markup,0),
  @cd_tipo_lucro       = isnull(cd_tipo_lucro,0),
  @ic_tipo_preco_custo = isnull(ic_tipo_preco_custo,'R')
from
  Parametro_Formacao_Preco with (nolock) 
where
  cd_empresa = dbo.fn_empresa()


declare @cSQL         as varchar(8000)
declare @cFinalidades as varchar(2000)


if @ic_parametro = 1 
begin

--Carlos 16.09.2004
--Cálculo Anterior
--(custo.vl_custo_produto + (custo.vl_custo_produto * dbo.fn_indice_markup( custo.cd_aplicacao_markup, custo.cd_tipo_lucro)/100)) as PrecoVenda,

	set @cSQL =	
		'Select pro.cd_produto , '+
		'pro.cd_mascara_produto , '+
		'pro.nm_fantasia_produto , '+
		'cast(pro.nm_produto as varchar(50)) as ds_produto, '+
		'pro.cd_unidade_medida, '+
		'un.sg_unidade_medida, '+
		'un.nm_unidade_medida, '+

--Carlos 07.01.2006
--Tipo de Preço de Custo do produto
--
                case when @ic_tipo_preco_custo = 'M' 
                     then 'custo.vl_custo_previsto_produto '
                     else 'custo.vl_custo_produto ' end + ' as vl_custo_produto, '+

--		'dbo.fn_indice_markup( custo.cd_aplicacao_markup, custo.cd_tipo_lucro) as Markup, '+

--
--Markup Conforme Regra
--

'  case when isnull(custo.cd_aplicacao_markup,0)<>0 and isnull(custo.cd_tipo_lucro,0)<>0
       then
         dbo.fn_indice_markup( custo.cd_aplicacao_markup, custo.cd_tipo_lucro, custo.cd_produto) 
       else
         case when isnull(gpc.cd_aplicacao_markup,0)<>0 and isnull(gpc.cd_tipo_lucro,0)<>0
              then
                dbo.fn_indice_markup( gpc.cd_aplicacao_markup, gpc.cd_tipo_lucro, custo.cd_produto) 
              else
                 case when isnull(cp.cd_aplicacao_markup,0)<>0 and isnull(cp.cd_tipo_lucro,0)<>0
                      then
                        dbo.fn_indice_markup( cp.cd_aplicacao_markup, cp.cd_tipo_lucro, custo.cd_produto) 
                      else
                        dbo.fn_indice_markup( '+cast(@cd_aplicacao_markup as varchar)+','+ cast(@cd_tipo_lucro as varchar)+', custo.cd_produto) end
              end 
  end as Markup, '+

--                '( (custo.vl_custo_produto / (dbo.fn_indice_markup( custo.cd_aplicacao_markup, custo.cd_tipo_lucro))) ) * '+
--                '( 1 + (case when isnull(o.pc_overprice,0)>0 then (isnull(o.pc_overprice,0)/100) else 0 end) ) as PrecoVenda, '+

                  'round(( ((custo.vl_custo_produto * dbo.fn_indice_lucro(custo.cd_tipo_lucro) )/ ( '+
' case when isnull(custo.cd_aplicacao_markup,0)<>0 and isnull(custo.cd_tipo_lucro,0)<>0
       then
         dbo.fn_indice_markup( custo.cd_aplicacao_markup, custo.cd_tipo_lucro, custo.cd_produto) 
       else
         case when isnull(gpc.cd_aplicacao_markup,0)<>0 and isnull(gpc.cd_tipo_lucro,0)<>0
              then
                dbo.fn_indice_markup( gpc.cd_aplicacao_markup, gpc.cd_tipo_lucro, custo.cd_produto) 
              else
                 case when isnull(cp.cd_aplicacao_markup,0)<>0 and isnull(cp.cd_tipo_lucro,0)<>0
                      then
                        dbo.fn_indice_markup( cp.cd_aplicacao_markup, cp.cd_tipo_lucro, custo.cd_produto) 
                      else
                        dbo.fn_indice_markup( '+cast(@cd_aplicacao_markup as varchar)+','+ cast(@cd_tipo_lucro as varchar)+', custo.cd_produto ) end
              end 
  end )) ) * '+
             '( 1 + (case when isnull(o.pc_overprice,0)>0 then (isnull(o.pc_overprice,0)/100) else 0 end) ) '+
             '* (dbo.fn_indice_markup_final( custo.cd_aplicacao_markup )),4) as PrecoVenda, '+

		'pro.cd_grupo_produto, '+
		'grupo.nm_grupo_produto, '+

                'pro.vl_produto as PrecoVendaAnterior, '+

                '(pro.vl_produto / ( ( (custo.vl_custo_produto*dbo.fn_indice_lucro(custo.cd_tipo_lucro)) / (dbo.fn_indice_markup( custo.cd_aplicacao_markup, custo.cd_tipo_lucro, custo.cd_produto)))))*100 as Variacao, '+
                'isnull(o.pc_overprice,0) as Overprice, '+
      'dbo.fn_indice_markup_final( cp.cd_aplicacao_markup ) as AcrescimoTipo, am.nm_aplicacao_markup, cp.cd_mascara_categoria, cp.nm_categoria_produto, gpp.nm_grupo_preco_produto, '+
      ' tl.nm_tipo_lucro, tl.pc_tipo_lucro ' +

	'From '+
		'Produto pro '+
		'left outer join Unidade_medida un    on un.cd_unidade_medida    = pro.cd_unidade_medida '+
		'left outer join Grupo_Produto grupo  on grupo.cd_grupo_produto  = pro.cd_grupo_produto '+
                'left outer join Grupo_Produto_Custo gpc on gpc.cd_grupo_produto = pro.cd_grupo_produto '+
		'left outer join Produto_custo custo  on custo.cd_produto        = pro.cd_produto '+
                'left outer join Overprice o          on o.cd_overprice          = custo.cd_overprice '+
                'left outer join Categoria_produto cp on cp.cd_categoria_produto = pro.cd_categoria_produto '+
                'left outer join Aplicacao_Markup  am on am.cd_aplicacao_markup  = custo.cd_aplicacao_markup '+
                'left outer join Grupo_Preco_Produto gpp on gpp.cd_grupo_preco_produto = custo.cd_grupo_preco_produto ' +
                'left outer join Tipo_Lucro tl on tl.cd_tipo_lucro = custo.cd_tipo_lucro ' +
	'Where ( 1 = 1 ) '

		if ( @cd_serie_produto <> 0  )
		  set @cSQL = @cSQL + ' and ( pro.cd_serie_produto = '+ cast(@cd_serie_produto as varchar)+  ')'

-- 		if ( @cd_fase_produto <> 0 )
-- 		  set @cSQL = @cSQL + ' and ( pro.cd_fase_produto = '+ cast(@cd_fase_produto as varchar) +  ')'

		if ( @cd_Status_produto <> 0 )
		  set @cSQL = @cSQL + ' and ( pro.cd_status_produto = '+ cast(@cd_Status_produto as varchar) +  ')'

		if ( @cd_procedencia_produto <> 0 )
		  set @cSQL = @cSQL + ' and ( pro.cd_procedencia_produto = '+ cast(@cd_procedencia_produto as varchar)+  ')'

		if( @ic_custo_zerado = 'S' ) 
		  set @cSQL = @cSQL + ' and ( isNull(custo.vl_custo_produto,0) = 0 ) '

		if( @cd_grupo_produto <> 0 ) 
		  set @cSQL = @cSQL + ' and ( pro.cd_grupo_produto = '+ cast(@cd_grupo_produto as varchar)+  ')'

		if( @cd_grupo_preco_produto <> 0 ) 
		  set @cSQL = @cSQL + ' and ( gpp.cd_grupo_preco_produto = '+ cast(@cd_grupo_preco_produto as varchar)+  ')'

		-- Nome Fantasia

		if ( @nm_fantasia_produto <> '' )
		  set @cSQL = @cSQL + ' and ( pro.nm_fantasia_produto like ''' + @nm_fantasia_produto + '%'' ) '

		-- Código do Produto

		if ( @cd_mascara_produto <> '' )
		  set @cSQL = @cSQL + ' and ( pro.cd_mascara_produto like ''' + @cd_mascara_produto + '%'' ) '


      set @cFinalidades = ''

			--Comercial
      	if ( @ic_comercial = 'S' )
      	begin
		    set @cFinalidades = @cFinalidades + ' ( isnull(pro.ic_comercial_produto,''N'') = ''S'' ) '
      	end

			--Compra
	if ( @ic_compra = 'S' )
      	begin
        	if @cFinalidades <> '' set @cFinalidades = @cFinalidades + ' or '
        	set @cFinalidades = @cFinalidades + ' ( isnull(pro.ic_compra_produto,''N'') = ''S'' ) '
      	end

			--Produção
	if ( @ic_producao = 'S' )
      	begin
        	if @cFinalidades <> '' set @cFinalidades = @cFinalidades + ' or '
        	set @cFinalidades = @cFinalidades + ' ( isnull(pro.ic_producao_produto,''N'') = ''S'' ) '
	end

			--Importação
	if ( @ic_importacao = 'S' )
      	begin
        	if @cFinalidades <> '' set @cFinalidades = @cFinalidades + ' or '
        	set @cFinalidades = @cFinalidades + ' ( isnull(pro.ic_importacao_produto,''N'') = ''S'' ) '
      	end

			--Exportação
	if ( @ic_exportacao = 'S' )
      	begin
        	if @cFinalidades <> '' set @cFinalidades = @cFinalidades + ' or '
        	set @cFinalidades = @cFinalidades + ' ( isnull(pro.ic_exportacao_produto,''N'') = ''S'' ) '
      	end

			--Beneficiamento
	if ( @ic_beneficiamento = 'S' )
      	begin
        	if @cFinalidades <> '' set @cFinalidades = @cFinalidades + ' or '
        	set @cFinalidades = @cFinalidades + ' ( isnull(pro.ic_beneficiamento_produto,''N'') = ''S'' ) '
      	end

			--Amostra
	if ( @ic_amostra = 'S' )
      	begin
        	if @cFinalidades <> '' set @cFinalidades = @cFinalidades + ' or '
        	set @cFinalidades = @cFinalidades + ' ( isnull(pro.ic_amostra_produto,''N'') = ''S'' ) '
      	end

			--Consignação
	if ( @ic_consignacao = 'S' )
      	begin
        	if @cFinalidades <> '' set @cFinalidades = @cFinalidades + ' or '
        	set @cFinalidades = @cFinalidades + ' ( isnull(pro.ic_consignacao_produto,''N'') = ''S'' ) '
      	end

			--Transferencia
	if ( @ic_transferencia = 'S' )
      	begin
        	if @cFinalidades <> '' set @cFinalidades = @cFinalidades + ' or '
        	set @cFinalidades = @cFinalidades + ' ( isnull(pro.ic_transferencia_produto,''N'') = ''S'' ) '
      	end

			--Sob Encomenda
	if ( @ic_sob_encomenda = 'S' )
      	begin
        	if @cFinalidades <> '' set @cFinalidades = @cFinalidades + ' or '
        	set @cFinalidades = @cFinalidades + ' ( isnull(pro.ic_sob_encomenda_produto,''N'') = ''S'' ) '
      	end

			--Transferencia
	if ( @ic_revenda = 'S' )
      	begin
        	if @cFinalidades <> '' set @cFinalidades = @cFinalidades + ' or '
        	set @cFinalidades = @cFinalidades + ' ( isnull(pro.ic_revenda_produto,''N'') = ''S'' ) '
      	end

			--Assistencia Técnica
	if ( @ic_assistencia_tecnica = 'S' )
      	begin
        	if @cFinalidades <> '' set @cFinalidades = @cFinalidades + ' or '
        	set @cFinalidades = @cFinalidades + ' ( isnull(pro.ic_tecnica_produto,''N'') = ''S'' ) '
      	end

			--Almoxarifado
	if ( @ic_almoxarifado = 'S' )
      	begin
        	if @cFinalidades <> '' set @cFinalidades = @cFinalidades + ' or '
        	set @cFinalidades = @cFinalidades + ' ( isnull(pro.ic_almox_produto,''N'') = ''S'' ) '
      	end

  if (isnull(@cFinalidades,'') <> '')
    set @cSQL = @cSQL + ' and ( ' + @cFinalidades + ' ) '

--  print @cSQL


end



if @ic_parametro = 2
begin

--Carlos 16/09/2004
--Cálculo Anterior
--(custo.vl_custo_produto + (custo.vl_custo_produto * dbo.fn_indice_markup( custo.cd_aplicacao_markup, custo.cd_tipo_lucro)/100)) as PrecoVenda,

	set @cSQL =	
		'Select  '+
		'pro.cd_produto , '+
		'pro.cd_mascara_produto , '+
		'pro.nm_fantasia_produto , '+
		'cast(pro.nm_produto as varchar(50)) as ds_produto, '+
		'pro.cd_unidade_medida, '+
		'un.sg_unidade_medida, '+
		'un.nm_unidade_medida, '+
		'custo.vl_custo_produto , '+
--		'dbo.fn_indice_markup( custo.cd_aplicacao_markup, custo.cd_tipo_lucro) as Markup, '+
--
--Markup Conforme Regra
--
'  case when isnull(custo.cd_aplicacao_markup,0)<>0 and isnull(custo.cd_tipo_lucro,0)<>0
       then
         dbo.fn_indice_markup( custo.cd_aplicacao_markup, custo.cd_tipo_lucro, custo.cd_produto) 
       else
         case when isnull(gpc.cd_aplicacao_markup,0)<>0 and isnull(gpc.cd_tipo_lucro,0)<>0
              then
                dbo.fn_indice_markup( gpc.cd_aplicacao_markup, gpc.cd_tipo_lucro, custo.cd_produto) 
              else
                 case when isnull(cp.cd_aplicacao_markup,0)<>0 and isnull(cp.cd_tipo_lucro,0)<>0
                      then
                        dbo.fn_indice_markup( cp.cd_aplicacao_markup, cp.cd_tipo_lucro, custo.cd_produto) 
                      else
                        dbo.fn_indice_markup( '+cast(@cd_aplicacao_markup as varchar)+','+ cast(@cd_tipo_lucro as varchar)+') end
              end 
  end as Markup, '+

--                '((custo.vl_custo_produto / (dbo.fn_indice_markup( custo.cd_aplicacao_markup, custo.cd_tipo_lucro))) ) * '+
--                '( 1 + (case when isnull(o.pc_overprice,0)>0 then (isnull(o.pc_overprice,0)/100) else 0 end) ) as PrecoVenda, '+

                  '( ((custo.vl_custo_produto*dbo.fn_indice_lucro(custo.cd_tipo_lucro)) / ( '+
' case when isnull(custo.cd_aplicacao_markup,0)<>0 and isnull(custo.cd_tipo_lucro,0)<>0
       then
         dbo.fn_indice_markup( custo.cd_aplicacao_markup, custo.cd_tipo_lucro) 
       else
         case when isnull(gpc.cd_aplicacao_markup,0)<>0 and isnull(gpc.cd_tipo_lucro,0)<>0
              then
                dbo.fn_indice_markup( gpc.cd_aplicacao_markup, gpc.cd_tipo_lucro) 
              else
                 case when isnull(cp.cd_aplicacao_markup,0)<>0 and isnull(cp.cd_tipo_lucro,0)<>0
                      then
                        dbo.fn_indice_markup( cp.cd_aplicacao_markup, cp.cd_tipo_lucro) 
                      else
                        dbo.fn_indice_markup( '+cast(@cd_aplicacao_markup as varchar)+','+ cast(@cd_tipo_lucro as varchar)+', custo.cd_produto) end
              end 
  end )) ) * '+
             '( 1 + (case when isnull(o.pc_overprice,0)>0 then (isnull(o.pc_overprice,0)/100) else 0 end) '+
             '* (dbo.fn_indice_markup_final( custo.cd_aplicacao_markup )) as PrecoVenda, '+

		'pro.cd_grupo_produto, '+
		'grupo.nm_grupo_produto, '+
                'pro.vl_produto as PrecoVendaAnterior, '+
               '(pro.vl_produto / ( ((custo.vl_custo_produto*dbo.fn_indice_lucro(custo.cd_tipo_lucro)) / (dbo.fn_indice_markup( custo.cd_aplicacao_markup, custo.cd_tipo_lucro, custo.cd_produto)))))*100 as Variacao, '+
               'isnull(o.pc_overprice,0) as Overprice, '+
      'dbo.fn_indice_markup_final( cp.cd_aplicacao_markup ) as AcrescimoTipo, am.nm_aplicacao_markup, cp.cd_mascara_categoria, cp.nm_categoria_produto, '+
      'tl.nm_tipo_lucro, tl.pc_tipo_lucro ' +


	'From  '+
		'Produto pro with (nolock) '+
		'left outer join Unidade_medida un    on un.cd_unidade_medida = pro.cd_unidade_medida '+
		'left outer join Grupo_Produto grupo  on grupo.cd_grupo_produto = pro.cd_grupo_produto '+
                'left outer join Grupo_Produto_Custo gpc on gpc.cd_grupo_produto = pro.cd_grupo_produto '+
		'left outer join Produto_custo custo  on custo.cd_produto = pro.cd_produto '+
                'left outer join Categoria_Produto cp on cp.cd_categoria_produto = pro.cd_categoria_produto '+
                'left outer join Overprice o          on o.cd_overprice = custo.cd_overprice'+
                'left outer join Aplicacao_Markup  am on am.cd_aplicacao_markup  = custo.cd_aplicacao_markup ' +
                'left outer join Grupo_Preco_Produto gpp on gpp.cd_grupo_preco_produto = custo.cd_grupo_preco_produto '+
                'left outer join Tipo_Lucro tl on tl.cd_tipo_lucro = custo.cd_tipo_lucro ' 

end 

	--print @cSQL

	exec( @cSQL )


