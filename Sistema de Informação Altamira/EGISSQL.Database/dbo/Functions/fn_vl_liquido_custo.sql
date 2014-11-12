
CREATE  FUNCTION fn_vl_liquido_custo
  (@ic_tipo_venda         char(1),       -- V - Pedido de Venda |F - Faturamento
   @vl_item               float,         -- Valor Venda / Faturamento
   @pc_icms               numeric(25,2), --(%) do icms que deve ser deduzido do valor do icms
   @pc_ipi                numeric(25,2), --(%) do ipi  que deve ser deduzido do valor do ipi
   @cd_destinacao_produto int,           --Destinação do produto  
   @dt_inicial            datetime,      --data para indicar o período do markup da consulta.
   @ic_icms               char(1) = 'N', --Cálculo do ICMS quando for necessário
   @ic_ipi                char(1) = 'N'  --Cálculo do IPI  quando for necessário
   )
RETURNS float

-------------------------------------------------------------------------------
--fn_vl_liquido_custo
-------------------------------------------------------------------------------
--GBS - Global Business Solution  LTDA                  	           2006
-------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Define o valor líquido para o item
--Data			: 07.05.2006
--Alteração             : 08.11.2010 - Ajustes Diversos - Carlos Fernandes
--                      : 
-- 08.12.2010 - Ajustes Diversos - Carlos Fernandes
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
          @vl_icms                 numeric(25,2),  -- ELIAS 23/04/2004 - Acrescentado valor do IPI e ICMS para cálculos diretos no faturamento
          @vl_ipi                  numeric(25,2)   -- 

  Select top 1    
    @ic_ipi_embutido = IsNull(ic_ipi_base_icm_dest_prod,'N')
  from 
    Destinacao_Produto with (nolock) 
  where 
    cd_destinacao_produto = @cd_destinacao_produto

  --Define o valor base

  Select 
    @vl_final 		= @vl_item,
    @vl_impostos	= 0

  --select * from parametro_bi
  
  --Define a aplicação

  if @ic_tipo_venda = 'V'
    Select 
      @cd_aplicacao_markup = IsNull(cd_aplicacao_markup_venda,0) 
    from 
      Parametro_BI with (nolock) 
    where 
      cd_empresa = dbo.fn_empresa()
  else
    Select   
      @cd_aplicacao_markup = IsNull(cd_aplicacao_markup_fat,0) 
    from 
      Parametro_BI with (nolock) 
    where 
      cd_empresa = dbo.fn_empresa()

  -- ELIAS 23/04/2004 - CASO SEJA FATURAMENTO ENTÃO RETIRAR O IPI
  -- QUE ESTÁ COMPOSTO NO VALOR TOTAL DA VENDA        

  IF @IC_TIPO_VENDA = 'F'
  BEGIN
    SET @VL_IPI   = case when @ic_ipi  = 'S' then @vl_item * (@pc_ipi/100)  else 0.00 end --@pc_ipi  end
    SET @VL_ICMS  = case when @ic_icms = 'S' then @vl_item * (@pc_icms/100) else 0.00 end --@pc_icms end
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
      (Select top 1 pc_formacao_markup, cd_tipo_markup, cd_aplicacao_markup From Formacao_markup_periodo with (nolock) 
       where (@dt_inicial = '') or 
             (
              @dt_inicial <> ''  and 
              @dt_inicial between dt_ini_formacao_markup and dt_fim_formacao_markup)
      ) fmp
        on fm.cd_tipo_markup      = fmp.cd_tipo_markup and
           fm.cd_aplicacao_markup = fmp.cd_aplicacao_markup
        inner join  tipo_markup tm with (nolock) on fm.cd_tipo_markup = tm.cd_tipo_markup
    where 
      fm.cd_aplicacao_markup = @cd_aplicacao_markup

    order by 
      ic_valor_flexivel desc, tm.sg_tipo_markup desc --Ordenação necessária para primeiro
                                                     --realizar os cálculos flexível e o

    --nos flexíveis primeiro o IPI e depois o ICMS
    OPEN Markup_Cursor
	
    FETCH NEXT FROM Markup_Cursor
    INTO @cd_tipo_markup, @sg_tipo_markup, @ic_ipi_compoe_markup, @ic_valor_flexivel, @pc_formacao_markup, @ic_tipo_formacao_markup

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
            set @vl_impostos = @vl_impostos + @vl_final * (isnull(@pc_formacao_markup,0)/100)
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
		     @vl_final = @vl_final + ( @vl_final * (IsNull(@pc_ipi,0)/100))           

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

  return isnull(@vl_retorno,0.00)

end

