CREATE  FUNCTION fn_vl_liquido_venda
  (@ic_tipo_venda         char(1)       = '',       -- V - Pedido de Venda |F - Faturamento
   @vl_item               float         = 0.00,         -- Valor Venda
   @pc_icms               numeric(25,2) = 0.00,
   @pc_ipi                numeric(25,2) = 0.00,
   @cd_destinacao_produto int           = 2,
   @dt_inicial            datetime      = ''
--   @ic_pis                char(1)       = 'N',
--   @ic_cofins             char(1)       = 'N'
   )

RETURNS float

-------------------------------------------------------------------------------
--fn_vl_liquido_venda
-------------------------------------------------------------------------------
--GBS - Global Business Solution  LTDA                  	           2004
-------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Fabio Cesar
--Banco de Dados	: EGISSQL
--Objetivo		: Define o valor líquido para o item
--Data			: 11.11.2003
--Alteração             : 19.04.2004 - Correção da Formula do Cálculo do valor líquido
--                      : 23/04/2004 - Ajustes para Correto Cálculo quando Faturamento - ELIAS
--                      : 26.04.2004 - Inclusão da tabela de formacao_markup_periodo - Igor Gama
--                      : 08/06/2004 - Alterado pra retornar de valor Numérico para Float. 
--                                   - Daniel C. Neto.
--                      : 10/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
-- 19/01/2005 - Acerto para tirar o vl_ipi corretamente quando a empresa não utiliza Markup - Daniel C. Neto.
-- 04.01.2006 - Análise - Carlos Fernandes
-- 24.03.2008 - Cálculo de PIS/COFINS conforme a Natureza de Operação - Carlos Fernandes
-----------------------------------------------------------------------------------------------------------------
AS

begin

  --Seta a data inicial
  
  declare @cd_aplicacao_markup     int,
          @cd_tipo_markup          int,
      	  @ic_valor_flexivel       char(1),
      	  @ic_tipo_formacao_markup char(1),
      	  @pc_formacao_markup      numeric(8,2),
          @sg_tipo_markup          varchar(20),
          @ic_ipi_embutido         char(1),
          @vl_final                float, --Valor Final após calculos
          @vl_impostos             float,
          @ic_ipi_compoe_markup    char(1),
          @vl_retorno              numeric(25,2),
          @vl_icms                 numeric(25,2),  -- ELIAS 23/04/2004 - Acrescentado valor do IPI e ICMS para 
          @vl_ipi                  numeric(25,2),  -- cálculos diretos no faturamento
          @vl_base_calculo         numeric(25,2)   -- Base de Cálculo 

  Select top 1    
    @ic_ipi_embutido = IsNull(ic_ipi_base_icm_dest_prod,'N')
  from 
    Destinacao_Produto 
  where 
    cd_destinacao_produto = @cd_destinacao_produto

  --Define o valor base

  Select 
    @vl_final 		= isnull(@vl_item,0),
    @vl_impostos	= 0.00,
    @vl_base_calculo    = 0.00

  --select * from parametro_bi
  
  --Define a aplicação

  if @ic_tipo_venda = 'V'
    Select 
      @cd_aplicacao_markup = IsNull(cd_aplicacao_markup_venda,0) 
    from 
      Parametro_BI
    where 
      cd_empresa = dbo.fn_empresa()
  else
    Select   
      @cd_aplicacao_markup = IsNull(cd_aplicacao_markup_fat,0) 
    from 
      Parametro_BI 
    where 
      cd_empresa = dbo.fn_empresa()

  -- ELIAS 23/04/2004 - CASO SEJA FATURAMENTO ENTÃO RETIRAR O IPI
  -- QUE ESTÁ COMPOSTO NO VALOR TOTAL DA VENDA        

  IF @IC_TIPO_VENDA = 'F'
  BEGIN
    SET @VL_IPI   = @PC_IPI
    SET @VL_ICMS  = @PC_ICMS
    SET @VL_FINAL = @VL_FINAL - isnull(@VL_IPI,0)
  END

	
  if @cd_aplicacao_markup > 0
  begin	

    --define os tipos de markup's

    DECLARE Markup_Cursor CURSOR FOR 
    select distinct 
      fm.cd_tipo_markup,
      tm.sg_tipo_markup,
      IsNull(ic_base_valor_bruto,'N')                                                            as ic_base_valor_bruto,

      (case when @ic_tipo_venda = 'V' then
         IsNull(tm.ic_pedido_tipo_markup,'N')	
       else
         IsNull(tm.ic_nota_tipo_markup,'N')
       end)                                                                                      as ic_valor_flexivel,
      IsNull(IsNull(IsNull(fmp.pc_formacao_markup, fm.pc_formacao_markup), tm.pc_tipo_markup),0) as pc_formacao_markup,
      IsNull(fm.ic_tipo_formacao_markup,'A')                                                     as ic_tipo_formacao_markup
    from 
      Formacao_markup fm with (nolock) 
        left outer Join
      (Select top 1 pc_formacao_markup, cd_tipo_markup, cd_aplicacao_markup From Formacao_markup_periodo
       where (@dt_inicial = '') or 
             (
              @dt_inicial <> ''  and 
              @dt_inicial between dt_ini_formacao_markup and dt_fim_formacao_markup)
      ) fmp
        on fm.cd_tipo_markup      = fmp.cd_tipo_markup and
           fm.cd_aplicacao_markup = fmp.cd_aplicacao_markup
        inner join 
      tipo_markup tm
        on fm.cd_tipo_markup = tm.cd_tipo_markup
    where 
      fm.cd_aplicacao_markup = @cd_aplicacao_markup
    order by 
      ic_valor_flexivel desc, tm.sg_tipo_markup desc --Ordenação necessária para primeiro
                                                     --realizar os cálculos flexível e o

    --nos flexíveis primeiro o IPI e depois o ICMS

    OPEN Markup_Cursor
	
    FETCH NEXT FROM Markup_Cursor
    INTO @cd_tipo_markup,
         @sg_tipo_markup,
         @ic_ipi_compoe_markup,
         @ic_valor_flexivel, 
         @pc_formacao_markup, 
         @ic_tipo_formacao_markup

    WHILE @@FETCH_STATUS = 0
    BEGIN

      if @ic_tipo_formacao_markup = 'A'
      begin

        --Verifica se trata-se de um valor Fixo

	if ( @ic_valor_flexivel = 'N' )
        begin

          -- Caso Faturamento, Trabalhar diretamente com os valores dos
          -- Impostos, portanto não sendo necessário verificar se o IPI está 
          -- ou não na BC do ICMS - ELIAS 23/04/2004

          if @ic_tipo_venda = 'F'
          begin           
            set @vl_base_calculo = ( @vl_final * (isnull(@pc_formacao_markup,0)/100) )

--             --Verifica se Deduz o PIS/COFINS conforme parâmetro 
--             if @ic_pis = 'S' and @sg_tipo_markup = 'PIS'
--             begin
--               set @vl_base_calculo = 0.00
--             end
-- 
--             if @ic_cofins = 'S' and @sg_tipo_markup = 'COFINS'
--             begin
--               set @vl_base_calculo = 0.00
--             end

           set @vl_impostos = @vl_impostos + @vl_base_calculo

          end

          else
            set @vl_impostos = @vl_impostos + ((case @ic_ipi_compoe_markup when 'N' 
                                                then @vl_item
                                                else @vl_final
                                                end) * (IsNull(@pc_formacao_markup,0)/100))

        end
        else
        begin

          -- Quando Faturamento, utilizar diretamente o valor dos impostos
          -- devido a Redução de BC e outros - ELIAS 23/04/2004
          if (@ic_tipo_venda = 'F')         
          begin

            --Verifica qual o markup
            --IPI
            if ( @sg_tipo_markup = 'IPI' ) 
              set @vl_impostos = @vl_impostos + @vl_ipi

            --ICMS
            if ( @sg_tipo_markup = 'ICMS' )
              set @vl_impostos = @vl_impostos + @vl_icms

          end
          else
          begin


            --Verifica qual o markup
            --IPI
            if ( @sg_tipo_markup = 'IPI' ) and ( @ic_ipi_embutido = 'S' )
              Select @vl_impostos = @vl_impostos + ( @vl_final * (IsNull(@pc_ipi,0)/100)) ,
		     @vl_final    = @vl_final    + ( @vl_final * (IsNull(@pc_ipi,0)/100))           

            --ICMS
            if ( @sg_tipo_markup = 'ICMS' )
              Select @vl_impostos = @vl_impostos + ( @vl_final * (IsNull(@pc_icms,0)/100))

          end

        end

      end

      FETCH NEXT FROM Markup_Cursor
      INTO @cd_tipo_markup, @sg_tipo_markup, @ic_ipi_compoe_markup, @ic_valor_flexivel, @pc_formacao_markup, @ic_tipo_formacao_markup

    END

    CLOSE Markup_Cursor
    DEALLOCATE Markup_Cursor

    -- Acrescentar o IPI quando Faturamento - ELIAS 23/04/2004 

    if @ic_tipo_venda = 'F'
      set @vl_retorno = @vl_final - IsNull(@vl_impostos,0) --+ @vl_ipi
    else
      set @vl_retorno = @vl_final - IsNull(@vl_impostos,0)

  end
  else
    set @vl_retorno = @vl_final

  return @vl_retorno

end

