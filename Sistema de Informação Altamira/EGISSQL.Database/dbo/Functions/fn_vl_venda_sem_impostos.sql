
CREATE  FUNCTION fn_vl_venda_sem_impostos
	(@cd_aplicacao_markup int,
         @ic_tipo_venda       char(1), -- V - Pedido de Venda |F - Faturamento
         @vl_item             money, --Valor Venda
	 @pc_icms             numeric(8,2),
	 @pc_custo_fin        numeric(8,3)
   )
RETURNS money
---------------------------------------------------------------------------------------------------
--fn_vl_venda_sem_impostos
---------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	Ltda                                               2004
---------------------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Eduardo
--Banco de Dados	: EGISSQL
--Objetivo		: Define o valor líquido para o item descontando os percentuais baseando-se no Markup
--Data			: 20/01/2004
--                      : 17/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                      : 20.1.2006 - Revisão para retorno de valores - Carlos/Wilder 
---------------------------------------------------------------------------------------------------

AS
begin

  declare @cd_tipo_markup int,
          @nm_tipo_markup varchar(40),
					@ic_valor_flexivel char(1),
					@ic_tipo_formacao_markup char(1),
					@pc_formacao_markup numeric(8,3),
          @pc_percentual numeric(8,3),
          @pc numeric(8,3),
          @sg_tipo_markup varchar(15)

	set @pc_icms = isnull(@pc_icms,0)
	set @pc_custo_fin = isnull(@pc_custo_fin,0)

  if @cd_aplicacao_markup > 0
  begin

    set @pc_percentual = 0
	
		--define os tipos de markup's
		DECLARE Markup_Cursor CURSOR FOR 
		select 
			fm.cd_tipo_markup,
      tm.nm_tipo_markup,
	    (case 
				when @ic_tipo_venda = 'V' then
					IsNull(tm.ic_pedido_tipo_markup,'N')	
				else
					IsNull(tm.ic_nota_tipo_markup,'N')
			end) as ic_valor_flexivel,
			IsNull(fm.pc_formacao_markup,0) as pc_formacao_markup,
			IsNull(fm.ic_tipo_formacao_markup,'A') as ic_tipo_formacao_markup,
      tm.sg_tipo_markup
		from 
			Formacao_markup fm 
		  inner join tipo_markup tm
			on fm.cd_tipo_markup = tm.cd_tipo_markup
		where 
			cd_aplicacao_markup = @cd_aplicacao_markup
		order by 
			tm.cd_tipo_markup


		OPEN Markup_Cursor
	
		FETCH NEXT FROM Markup_Cursor
		INTO @cd_tipo_markup, @nm_tipo_markup, @ic_valor_flexivel, @pc_formacao_markup,
         @ic_tipo_formacao_markup, @sg_tipo_markup

--    print 'vl_item sem desconto'
--    print @vl_item

		WHILE @@FETCH_STATUS = 0
		BEGIN

			if @ic_tipo_formacao_markup = 'A'
			begin

				if @ic_valor_flexivel = 'N'
        begin
          -- Usar a Comissão definida no Markup
          set @pc = IsNull(@pc_formacao_markup,0)
        end
		    else
        begin
          -- Usar a Comissão definida na Nota/Pedido
          if upper(@sg_tipo_markup) = 'CUSTOFIN'
            set @pc = IsNull(@pc_custo_fin,0)
          else
            set @pc = IsNull(@pc_icms,0)
        end

        set @pc_percentual = @pc_percentual + @pc

--        print @nm_tipo_markup
--        print @pc

			end

			FETCH NEXT FROM Markup_Cursor
			INTO @cd_tipo_markup, @nm_tipo_markup, @ic_valor_flexivel, @pc_formacao_markup,
           @ic_tipo_formacao_markup, @sg_tipo_markup
	
		END
		CLOSE Markup_Cursor
		DEALLOCATE Markup_Cursor

    set @pc_percentual = 100 - @pc_percentual
--    print 'Percentual: ' + cast(@pc_percentual as varchar)

    set @vl_item = ( @vl_item * @pc_percentual ) / 100

  end
  
--  print 'vl_item descontado'
--  print @vl_item  

  return @vl_item

end

