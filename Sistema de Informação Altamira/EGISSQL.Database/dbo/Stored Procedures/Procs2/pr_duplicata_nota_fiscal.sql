
------------------------------------------------------------------------------------------
--pr_duplicata_nota_fiscal
------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Elias P. da Silva
--Banco de Dados: EGISSQL 
--Objetivo      : Listar as Informações das Duplicatas p/ a Nota Fiscal
--Data          : 06/07/2002
--Atualizado    : 14/04/2003 - Inclusão do Cabeçalho e comentado antiga stp (stp sobreposta) - ELIAS
--                Antiga stp foi renomeada para pr_duplicata_nota_fiscal_smc - ELIAS
--                14/04/2003 - Acerto na estrutura da listagem das duplicatas na Polimold,
--                Listar em 3 colunas e trez linhas até 9 parcelas, caso exista mais do
--                que 9 parcelas utilizar mais uma linha - ELIAS
--                09/06/2003 - Formatação de Datas p/ que a Data apareça no Formato dd/mm/yy - ELIAS
--                14/05/2004 - Incluindo a possibilidade de se exibir ate 12 parcelas
--                19/04/2005 - 
--                15.03.2006 - Acerto na Emissão das Parcela p/ TMBEVO - Carlos Fernandes
--                07.07.2006 - Acerto na Emissão das Parcela p/ TMBEVO - Márcio Rodrigues
--                08.11.2007 - Acerto da Observação - Carlos Fernandes
-----------------------------------------------------------------------------------------

CREATE  PROCEDURE pr_duplicata_nota_fiscal
@ic_parametro        int,
@nm_fantasia_empresa varchar(20),
@cd_nota_fiscal      int

as

declare @i          int
declare @qt_parcela int  -- ELIAS 14/04/2003

declare @cd_ident_parc_nota_saida varchar(30),
        @dt_parcela_nota_saida    datetime,
        @vl_parcela_nota_saida    float,
        @ic_parcela_quitada       char(1),
        @nm_obs_parcela           varchar(40)

-------------------------------------------------------------------------------
if @ic_parametro = 1   -- NOTA_FISCAL_SAIDA
-------------------------------------------------------------------------------
begin
-------------------------------------------------------------------------------
    if @nm_fantasia_empresa like '%POLIMOLD%'
-------------------------------------------------------------------------------
    begin

        -- buscando a quantidade de parcelas - 14/04/2003
        set @qt_parcela = (select 
                             count(*) 
                           from
                             Nota_Saida_Parcela
                           where
                             cd_nota_saida = @cd_nota_fiscal)


        -- Montagem das Parcelas quando a quantidade for inferior ou igual a 9
        if (@qt_parcela <= 9)
        begin
			select top 3
              identity(int, 1, 1)	as 'LINHA',
              substring(cd_ident_parc_nota_saida, patindex('%-%',
                        cd_ident_parc_nota_saida)+1, 2)
      					as 'DUPLICATA',
              convert(varchar, dt_parcela_nota_saida, 3)	as 'VENCIMENTO',
              vl_parcela_nota_saida	as 'VLDUPLICATA',
              cast(null as varchar(25))	as 'DUPLICATA2',
              cast(null as varchar(10))	as 'VENCIMENTO2',
              cast(null as float)	as 'VLDUPLICATA2',
              cast(null as varchar(25))	as 'DUPLICATA3',
              cast(null as varchar(10))	as 'VENCIMENTO3',
              cast(null as float)	as 'VLDUPLICATA3'
            into
              #Nota_Saida_Parcela_Polimold_A
            from
              Nota_Saida_Parcela
            where
              cd_nota_saida = @cd_nota_fiscal
            order by
              cd_parcela_nota_saida

            set @i = 3

            while exists(select * from Nota_Saida_Parcela where
                         cd_nota_saida = @cd_nota_fiscal and cd_parcela_nota_saida = @i)
            begin

               	update
                  #Nota_Saida_Parcela_Polimold_A
                set
                  DUPLICATA2      = substring(p.cd_ident_parc_nota_saida,
                                    patindex('%-%', p.cd_ident_parc_nota_saida)+1, 2),
                  VENCIMENTO2     = convert(varchar, p.dt_parcela_nota_saida, 3),
                  VLDUPLICATA2    = p.vl_parcela_nota_saida
                from
                  Nota_Saida_Parcela p
                where
                  LINHA           = (@i-3) and
                  p.cd_nota_saida = @cd_nota_fiscal and
                  p.cd_parcela_nota_saida = @i

               set @i = @i + 1

             end --FIM DO WHILE

            set @i = 7

            while exists(select * from Nota_Saida_Parcela where
                         cd_nota_saida = @cd_nota_fiscal and cd_parcela_nota_saida = @i)
            begin

                update
                  #Nota_Saida_Parcela_Polimold_A
                set
                  DUPLICATA3      = substring(p.cd_ident_parc_nota_saida,
                                    patindex('%-%', p.cd_ident_parc_nota_saida)+1, 2),
                  VENCIMENTO3     = convert(varchar, p.dt_parcela_nota_saida, 3),
                  VLDUPLICATA3    = p.vl_parcela_nota_saida
                from
                  Nota_Saida_Parcela p
                where
                  LINHA           = (@i-6) and
                  p.cd_nota_saida = @cd_nota_fiscal and
                  p.cd_parcela_nota_saida = @i

                set @i = @i + 1

            end --FIM DO WHILTE

            select
              LINHA,
              DUPLICATA,
              VENCIMENTO,
              VLDUPLICATA,
              DUPLICATA2,
              VENCIMENTO2,
              VLDUPLICATA2,
              DUPLICATA3,
              VENCIMENTO3,
              VLDUPLICATA3
            from
              #Nota_Saida_Parcela_Polimold_A

        end --FIM DAS NOTAS COM MENOS DE 9 PARCELAS
        -- Montagem das Parcelas quando a quantidade for superior a 9
        else if (@qt_parcela > 9)
        begin

            select
              top 4
              identity(int, 1, 1)	as 'LINHA',
              substring(cd_ident_parc_nota_saida, patindex('%-%',
                        cd_ident_parc_nota_saida)+1, 2)
      					as 'DUPLICATA',
              convert(varchar, dt_parcela_nota_saida, 3)	as 'VENCIMENTO',
              vl_parcela_nota_saida	as 'VLDUPLICATA',
              cast(null as varchar(25))	as 'DUPLICATA2',
              cast(null as datetime)	as 'VENCIMENTO2',
              cast(null as float)	as 'VLDUPLICATA2',
              cast(null as varchar(25))	as 'DUPLICATA3',
              cast(null as datetime)	as 'VENCIMENTO3',
              cast(null as float)	as 'VLDUPLICATA3'
            into
              #Nota_Saida_Parcela_Polimold_B
            from
              Nota_Saida_Parcela
            where
              cd_nota_saida = @cd_nota_fiscal
            order by
              cd_parcela_nota_saida

            set @i = 5

            while exists(select * from Nota_Saida_Parcela where
                         cd_nota_saida = @cd_nota_fiscal and cd_parcela_nota_saida = @i)
            begin

                update
                  #Nota_Saida_Parcela_Polimold_B
                set
                  DUPLICATA2      = substring(p.cd_ident_parc_nota_saida,
                                    patindex('%-%', p.cd_ident_parc_nota_saida)+1, 2),
                  VENCIMENTO2     = convert(varchar, p.dt_parcela_nota_saida, 3),
                  VLDUPLICATA2    = p.vl_parcela_nota_saida
                from
                  Nota_Saida_Parcela p
                where
                  LINHA           = (@i-4) and
                  p.cd_nota_saida = @cd_nota_fiscal and
                  p.cd_parcela_nota_saida = @i

               set @i = @i + 1

            end --FIM DO WHILE

            set @i = 8

            while exists(select * from Nota_Saida_Parcela where
                         cd_nota_saida = @cd_nota_fiscal and cd_parcela_nota_saida = @i)
            begin

                update
                  #Nota_Saida_Parcela_Polimold_B
                set
                  DUPLICATA3      = substring(p.cd_ident_parc_nota_saida,
                                    patindex('%-%', p.cd_ident_parc_nota_saida)+1, 2),
                  VENCIMENTO3     = convert(varchar, p.dt_parcela_nota_saida, 3),
                  VLDUPLICATA3    = p.vl_parcela_nota_saida
                from
                  Nota_Saida_Parcela p
                where
                  LINHA           = (@i-8) and
                  p.cd_nota_saida = @cd_nota_fiscal and
                  p.cd_parcela_nota_saida = @i

                set @i = @i + 1

            end --FIM DO WHILE

            select
              LINHA,
              DUPLICATA,
              VENCIMENTO,
              VLDUPLICATA,
              DUPLICATA2,
              VENCIMENTO2,
              VLDUPLICATA2,
              DUPLICATA3,
              VENCIMENTO3,
              VLDUPLICATA3
            from
              #Nota_Saida_Parcela_Polimold_B

        end --FIM DAS NOTAS COM MAIS DE 9 PARCELAS
    end --FIM DO TRATAMENTO ESPECÍFICO DA POLIMOLD
-------------------------------------------------------------------------------
    else if @nm_fantasia_empresa like '%TMBEVO%'   -- TMBevo
-------------------------------------------------------------------------------
    begin

      --select * from nota_saida_parcela

	--gera a estrutura da tabela
	set nocount on

	select          
    top 1
    identity(int, 1, 1)		                as 'LINHA',
    cd_ident_parc_nota_saida                    as 'DUPLICATA',

   (case when isnull(nm_obs_parcela_nota_saida,'')<>'' then 
				  nm_obs_parcela_nota_saida
         else
           convert(varchar(10), dt_parcela_nota_saida, 103)
	 end)  as 'VENCIMENTO',
    vl_parcela_nota_saida			as 'VLDUPLICATA',
    cast(null as varchar(40))                   as 'OBS',
    cast(null as varchar(25))	                as 'DUPLICATA2',
    cast(null as varchar(10))		        as 'VENCIMENTO2',
    cast(null as float)  			as 'VLDUPLICATA2',
    cast(null as varchar(40))                   as 'OBS2',
    cast(null as varchar(25))                   as 'DUPLICATA3',
    cast(null as varchar(10))		        as 'VENCIMENTO3',
    cast(null as float)		                as 'VLDUPLICATA3',
    cast(null as varchar(40))                   as 'OBS3',
    cast(null as varchar(25))	                as 'DUPLICATA4',
    cast(null as varchar(10))	                as 'VENCIMENTO4',
    cast(null as float) 			as 'VLDUPLICATA4',
    cast(null as varchar(40))                   as 'OBS4',
    cast(null as varchar(25))           	as 'DUPLICATA5',
    cast(null as varchar(10))           	as 'VENCIMENTO5',
    cast(null as float)	                        as 'VLDUPLICATA5',
    cast(null as varchar(40))                   as 'OBS5',
    cast(null as varchar(25))                   as 'DUPLICATA6',
    cast(null as varchar(10))                   as 'VENCIMENTO6',
    cast(null as float)     	                as 'VLDUPLICATA6',
    cast(null as varchar(40))                   as 'OBS6',
    cast(null as varchar(25))	                as 'DUPLICATA7',
    cast(null as varchar(10))	                as 'VENCIMENTO7',
    cast(null as float)		                as 'VLDUPLICATA7',
    cast(null as varchar(40))                   as 'OBS7',
    cast(null as varchar(25))	                as 'DUPLICATA8',
    cast(null as varchar(10)) 	                as 'VENCIMENTO8',
    cast(null as float)		                as 'VLDUPLICATA8',
    cast(null as varchar(40))                   as 'OBS8',
    cast(null as varchar(25))	                as 'DUPLICATA9',
    cast(null as varchar(10))	                as 'VENCIMENTO9',
    cast(null as float)		                as 'VLDUPLICATA9',
    cast(null as varchar(40))                   as 'OBS9',
    cast(null as varchar(25))	                as 'DUPLICATA10',
    cast(null as varchar(10))	                as 'VENCIMENTO10',
    cast(null as float)	                        as 'VLDUPLICATA10',
    cast(null as varchar(40))                   as 'OBS10'
  into
    #nota_saida_parcela
  from
    nota_saida_parcela
	where
    cd_nota_saida = @cd_nota_fiscal
  order by
    cd_parcela_nota_saida

	declare duplicata cursor for
	select    
          top 9
	  cd_ident_parc_nota_saida,
	  dt_parcela_nota_saida,
	  vl_parcela_nota_saida,
          ic_parcela_quitada,
          nm_obs_parcela_nota_saida
  from
    nota_saida_parcela
  where
    cd_nota_saida = @cd_nota_fiscal and 
    cd_ident_parc_nota_saida <> (select top 1 duplicata from #nota_saida_parcela)
  order by
    cd_parcela_nota_saida

	--define que será gravada a primeira parcela	
	set @i = 1
	open duplicata
	fetch next from duplicata into @cd_ident_parc_nota_saida, 
                                 @dt_parcela_nota_saida, 
                                 @vl_parcela_nota_saida, 
                                 @ic_parcela_quitada,
                                 @nm_obs_parcela

	--percorre os dados para atualizar
	while @@fetch_status = 0
	begin

	   if @i = 1
	   update
       #nota_saida_parcela
     set
       duplicata2      = @cd_ident_parc_nota_saida,
       vencimento2     = case when @ic_parcela_quitada = 'S' then
                           'Quitado'
                         else 
                           case when isnull(@nm_obs_parcela,'')<>'' then
                                @nm_obs_parcela
                           else
                              convert(varchar(10),@dt_parcela_nota_saida,103) end
                         end,
                vlduplicata2    = @vl_parcela_nota_saida
	   if @i = 2
	     update
                #nota_saida_parcela
             set
                duplicata3   = @cd_ident_parc_nota_saida,
                vencimento3  = case when @ic_parcela_quitada = 'S' then
                                    'Quitado'
                               else
                                  case when isnull(@nm_obs_parcela,'')<>'' then
                                       @nm_obs_parcela
                                  else
                                    convert(varchar(10),@dt_parcela_nota_saida,103) end
                               end,
                vlduplicata3    = @vl_parcela_nota_saida
	   if @i = 3
	     update
                #nota_saida_parcela
             set
                duplicata4      = @cd_ident_parc_nota_saida,
                vencimento4     = case when @ic_parcela_quitada = 'S' then
                                    'quitado'
                               else
                                  case when isnull(@nm_obs_parcela,'')<>'' then
                                       @nm_obs_parcela
                                  else
                                    convert(varchar(10),@dt_parcela_nota_saida,103) end
                               end,
                vlduplicata4    = @vl_parcela_nota_saida
	   if @i = 4
	     update
                #nota_saida_parcela
             set
                duplicata5      = @cd_ident_parc_nota_saida,
                vencimento5     = case when @ic_parcela_quitada = 'S' then
                                    'quitado'
                               else
                                  case when isnull(@nm_obs_parcela,'')<>'' then
                                       @nm_obs_parcela
                                  else
                                    convert(varchar(10),@dt_parcela_nota_saida,103) end
                               end,
                vlduplicata5    = @vl_parcela_nota_saida
	   if @i = 5
	     update
                #nota_saida_parcela
             set
                duplicata6      = @cd_ident_parc_nota_saida,
                vencimento6     = case when @ic_parcela_quitada = 'S' then
                                    'quitado'
                               else
                                  case when isnull(@nm_obs_parcela,'')<>'' then
                                       @nm_obs_parcela
                                  else
                                    convert(varchar(10),@dt_parcela_nota_saida,103) end
                               end,
                vlduplicata6    = @vl_parcela_nota_saida
	   if @i = 6
	     update
                #nota_saida_parcela
             set
                duplicata7      = @cd_ident_parc_nota_saida,
                vencimento7     = case when @ic_parcela_quitada = 'S' then
                                    'quitado'
                                  else
                                    case when isnull(@nm_obs_parcela,'')<>'' then
                                         @nm_obs_parcela
                                    else
                                      convert(varchar(10),@dt_parcela_nota_saida,103) end
                               end,
                vlduplicata7    = @vl_parcela_nota_saida
	   if @i = 7
	     update
                #nota_saida_parcela
             set
                duplicata8      = @cd_ident_parc_nota_saida,
                vencimento8     = case when @ic_parcela_quitada = 'S' then
                                    'quitado'
                               else
                                  case when isnull(@nm_obs_parcela,'')<>'' then
                                       @nm_obs_parcela
                                  else
                                    convert(varchar(10),@dt_parcela_nota_saida,103) end
                               end,
                vlduplicata8    = @vl_parcela_nota_saida
	   if @i = 8
	     update
                #nota_saida_parcela
             set
                duplicata9      = @cd_ident_parc_nota_saida,
                vencimento9     = case when @ic_parcela_quitada = 'S' then
                                    'quitado'
                               else
                                  case when isnull(@nm_obs_parcela,'')<>'' then
                                       @nm_obs_parcela
                                  else
                                    convert(varchar(10),@dt_parcela_nota_saida,103) end
                               end,
                vlduplicata9    = @vl_parcela_nota_saida
	   if @i = 9
	     update
                #nota_saida_parcela
             set
                duplicata10      = @cd_ident_parc_nota_saida,
                vencimento10     = case when @ic_parcela_quitada = 'S' then
                                    'quitado'
                               else
                                  case when isnull(@nm_obs_parcela,'')<>'' then
                                       @nm_obs_parcela
                                  else
                                    convert(varchar(10),@dt_parcela_nota_saida,103) end
                               end,
                vlduplicata10    = @vl_parcela_nota_saida

	   set @i = @i + 1	   
	   fetch next from duplicata into @cd_ident_parc_nota_saida, @dt_parcela_nota_saida, @vl_parcela_nota_saida, @ic_parcela_quitada, @nm_obs_parcela
	end
	--fecha o cursor
	close duplicata
	deallocate duplicata	

	set nocount off

        --Mostra os dados da parcela para impressão.

        select 
          linha,
          duplicata,
          vencimento,
          vlduplicata,
          duplicata2,
          vencimento2,
          vlduplicata2,
          duplicata3,
          vencimento3,
          vlduplicata3,
          duplicata4,
          vencimento4,
          vlduplicata4,
          duplicata5,
          vencimento5,
          vlduplicata5,
          duplicata6,
          vencimento6,
          vlduplicata6,
          duplicata7,
          vencimento7,
          vlduplicata7,
          duplicata8,
          vencimento8,
          vlduplicata8,
          duplicata9,
          vencimento9,
          vlduplicata9,
          duplicata10,
          vencimento10,
          vlduplicata10
        from
          #nota_saida_parcela

  end
-------------------------------------------------------------------------------
  else --Layout Padrao
-------------------------------------------------------------------------------
  begin
        select
          p.cd_ident_parc_nota_saida                 as 'DUPLICATA',
          convert(varchar,p.dt_parcela_nota_saida,3) as 'VENCIMENTO',
          p.vl_parcela_nota_saida                    as 'VLDUPLICATA',
          
          cast(null as varchar(25))     as 'DUPLICATA2',
          cast(null as varchar(10))     as 'VENCIMENTO2',
          cast(null as float)	        as 'VLDUPLICATA2',
          
          cast(null as varchar(25))     as 'DUPLICATA3',
          cast(null as varchar(10))     as 'VENCIMENTO3',
          cast(null as float)	        as 'VLDUPLICATA3',
          
          cast(null as varchar(25))     as 'DUPLICATA4',
          cast(null as varchar(10))     as 'VENCIMENTO4',
          cast(null as float)	        as 'VLDUPLICATA4',

          cast(null as varchar(25))     as 'DUPLICATA5',
          cast(null as varchar(10))     as 'VENCIMENTO5',
          cast(null as float)	        as 'VLDUPLICATA5',

          cast(null as varchar(25))     as 'DUPLICATA6',
          cast(null as varchar(10))     as 'VENCIMENTO6',
          cast(null as float)	        as 'VLDUPLICATA6',

          cast(null as varchar(25))     as 'DUPLICATA7',
          cast(null as varchar(10))     as 'VENCIMENTO7',
          cast(null as float)	        as 'VLDUPLICATA7',

          cast(null as varchar(25))     as 'DUPLICATA8',
          cast(null as varchar(10))     as 'VENCIMENTO8',
          cast(null as float)	        as 'VLDUPLICATA8',

          cast(null as varchar(25))     as 'DUPLICATA9',
          cast(null as varchar(10))     as 'VENCIMENTO9',
          cast(null as float)	        as 'VLDUPLICATA9',

          cast(null as varchar(25))     as 'DUPLICATA10',
          cast(null as varchar(10))     as 'VENCIMENTO10',
          cast(null as float)	        as 'VLDUPLICATA10',

          cast(null as varchar(25))     as 'DUPLICATA11',
          cast(null as varchar(10))     as 'VENCIMENTO11',
          cast(null as float)	        as 'VLDUPLICATA11',

          cast(null as varchar(25))     as 'DUPLICATA12',
          cast(null as varchar(10))     as 'VENCIMENTO12',
          cast(null as float)	        as 'VLDUPLICATA12'

        into
          #Nota_Saida_Parcela_Padrao
        from
          Nota_Saida_Parcela p left outer join
          Nota_Saida         n on n.cd_nota_saida = p.cd_nota_saida
        where
          p.cd_nota_saida         = @cd_nota_fiscal and
          p.cd_parcela_nota_saida = 1

---------------------------------------------------------------------------------------------------------
-- PARCELA 2
---------------------------------------------------------------------------------------------------------
        if exists(select * from Nota_Saida_Parcela where
                  cd_nota_saida = @cd_nota_fiscal and cd_parcela_nota_saida > 1)
        begin

            update
              #Nota_Saida_Parcela_Padrao
            set
              DUPLICATA2      = p.cd_ident_parc_nota_saida,
              VENCIMENTO2     = convert(varchar,p.dt_parcela_nota_saida,3),
              VLDUPLICATA2    = p.vl_parcela_nota_saida
            from
              Nota_Saida_Parcela p
            where
              p.cd_parcela_nota_saida = 2 and
              p.cd_nota_saida         = @cd_nota_fiscal 

        end

---------------------------------------------------------------------------------------------------------
-- PARCELA 3
---------------------------------------------------------------------------------------------------------        
       if exists(select * from Nota_Saida_Parcela where
                  cd_nota_saida = @cd_nota_fiscal and cd_parcela_nota_saida > 2)
        begin

            update
              #Nota_Saida_Parcela_Padrao
            set
              DUPLICATA3      = p.cd_ident_parc_nota_saida,
              VENCIMENTO3     = convert(varchar,p.dt_parcela_nota_saida,3),
              VLDUPLICATA3    = p.vl_parcela_nota_saida
            from
              Nota_Saida_Parcela p
            where
              p.cd_parcela_nota_saida = 3 and
              p.cd_nota_saida         = @cd_nota_fiscal 

        end

---------------------------------------------------------------------------------------------------------
-- PARCELA 4
---------------------------------------------------------------------------------------------------------

        if exists(select * from Nota_Saida_Parcela where
                  cd_nota_saida = @cd_nota_fiscal and cd_parcela_nota_saida > 3)
        begin

            update
              #Nota_Saida_Parcela_Padrao
            set
              DUPLICATA4      = p.cd_ident_parc_nota_saida,
              VENCIMENTO4     = convert(varchar,p.dt_parcela_nota_saida,3),
              VLDUPLICATA4    = p.vl_parcela_nota_saida
            from
              Nota_Saida_Parcela p
            where
              p.cd_parcela_nota_saida = 4 and
              p.cd_nota_saida         = @cd_nota_fiscal 

        end

---------------------------------------------------------------------------------------------------------
-- PARCELA 5
---------------------------------------------------------------------------------------------------------

        if exists(select * from Nota_Saida_Parcela where
                  cd_nota_saida = @cd_nota_fiscal and cd_parcela_nota_saida > 4)
        begin

            update
              #Nota_Saida_Parcela_Padrao
            set
              DUPLICATA5      = p.cd_ident_parc_nota_saida,
              VENCIMENTO5     = convert(varchar,p.dt_parcela_nota_saida,3),
              VLDUPLICATA5    = p.vl_parcela_nota_saida
            from
              Nota_Saida_Parcela p
            where
              p.cd_parcela_nota_saida = 5 and
              p.cd_nota_saida         = @cd_nota_fiscal 

        end

---------------------------------------------------------------------------------------------------------
-- PARCELA 6
---------------------------------------------------------------------------------------------------------

        if exists(select * from Nota_Saida_Parcela where
                  cd_nota_saida = @cd_nota_fiscal and cd_parcela_nota_saida > 5)
        begin

            update
              #Nota_Saida_Parcela_Padrao
            set
              DUPLICATA6      = p.cd_ident_parc_nota_saida,
              VENCIMENTO6     = convert(varchar,p.dt_parcela_nota_saida,3),
              VLDUPLICATA6    = p.vl_parcela_nota_saida
            from
              Nota_Saida_Parcela p
            where
              p.cd_parcela_nota_saida = 6 and
              p.cd_nota_saida         = @cd_nota_fiscal 

        end

---------------------------------------------------------------------------------------------------------
-- PARCELA 7
---------------------------------------------------------------------------------------------------------

        if exists(select * from Nota_Saida_Parcela where
                  cd_nota_saida = @cd_nota_fiscal and cd_parcela_nota_saida > 6)
        begin

            update
              #Nota_Saida_Parcela_Padrao
            set
              DUPLICATA7      = p.cd_ident_parc_nota_saida,
              VENCIMENTO7     = convert(varchar,p.dt_parcela_nota_saida,3),
              VLDUPLICATA7    = p.vl_parcela_nota_saida
            from
              Nota_Saida_Parcela p
            where
              p.cd_parcela_nota_saida = 7 and
              p.cd_nota_saida         = @cd_nota_fiscal 

        end

---------------------------------------------------------------------------------------------------------
-- PARCELA 8
---------------------------------------------------------------------------------------------------------

        if exists(select * from Nota_Saida_Parcela where
                  cd_nota_saida = @cd_nota_fiscal and cd_parcela_nota_saida > 7)
        begin

            update
              #Nota_Saida_Parcela_Padrao
            set
              DUPLICATA8      = p.cd_ident_parc_nota_saida,
              VENCIMENTO8     = convert(varchar,p.dt_parcela_nota_saida,3),
              VLDUPLICATA8    = p.vl_parcela_nota_saida
            from
              Nota_Saida_Parcela p
            where
              p.cd_parcela_nota_saida = 8 and
              p.cd_nota_saida         = @cd_nota_fiscal 

        end

---------------------------------------------------------------------------------------------------------
-- PARCELA 9
---------------------------------------------------------------------------------------------------------

        if exists(select * from Nota_Saida_Parcela where
                  cd_nota_saida = @cd_nota_fiscal and cd_parcela_nota_saida > 8)
        begin

            update
              #Nota_Saida_Parcela_Padrao
            set
              DUPLICATA9      = p.cd_ident_parc_nota_saida,
              VENCIMENTO9     = convert(varchar,p.dt_parcela_nota_saida,3),
              VLDUPLICATA9    = p.vl_parcela_nota_saida
            from
              Nota_Saida_Parcela p
            where
              p.cd_parcela_nota_saida = 9 and
              p.cd_nota_saida         = @cd_nota_fiscal 

        end

---------------------------------------------------------------------------------------------------------
-- PARCELA 10
---------------------------------------------------------------------------------------------------------

        if exists(select * from Nota_Saida_Parcela where
                  cd_nota_saida = @cd_nota_fiscal and cd_parcela_nota_saida > 9)
        begin

            update
              #Nota_Saida_Parcela_Padrao
            set
              DUPLICATA10      = p.cd_ident_parc_nota_saida,
              VENCIMENTO10     = convert(varchar,p.dt_parcela_nota_saida,3),
              VLDUPLICATA10    = p.vl_parcela_nota_saida
            from
              Nota_Saida_Parcela p
            where
              p.cd_parcela_nota_saida = 10 and
              p.cd_nota_saida         = @cd_nota_fiscal 

        end

---------------------------------------------------------------------------------------------------------
-- PARCELA 11
---------------------------------------------------------------------------------------------------------

        if exists(select * from Nota_Saida_Parcela where
                  cd_nota_saida = @cd_nota_fiscal and cd_parcela_nota_saida > 10)
        begin

            update
              #Nota_Saida_Parcela_Padrao
            set
              DUPLICATA11      = p.cd_ident_parc_nota_saida,
              VENCIMENTO11     = convert(varchar,p.dt_parcela_nota_saida,3),
              VLDUPLICATA11    = p.vl_parcela_nota_saida
            from
              Nota_Saida_Parcela p
            where
              p.cd_parcela_nota_saida = 11 and
              p.cd_nota_saida         = @cd_nota_fiscal 

        end

---------------------------------------------------------------------------------------------------------
-- PARCELA 12
---------------------------------------------------------------------------------------------------------

        if exists(select * from Nota_Saida_Parcela where
                  cd_nota_saida = @cd_nota_fiscal and cd_parcela_nota_saida > 11)
        begin

            update
              #Nota_Saida_Parcela_Padrao
            set
              DUPLICATA12      = p.cd_ident_parc_nota_saida,
              VENCIMENTO12     = convert(varchar,p.dt_parcela_nota_saida,3),
              VLDUPLICATA12    = p.vl_parcela_nota_saida
            from
              Nota_Saida_Parcela p
            where
              p.cd_parcela_nota_saida = 12 and
              p.cd_nota_saida         = @cd_nota_fiscal 

        end


-------------------------------------------------------------------------------------------------------
--Mostra os Dados do Desdobramento das parcelas
-------------------------------------------------------------------------------------------------------

        select
          DUPLICATA,
          VENCIMENTO,
          VLDUPLICATA,

          DUPLICATA2,
          VENCIMENTO2,
          VLDUPLICATA2,

          DUPLICATA3,
          VENCIMENTO3,
          VLDUPLICATA3,

          DUPLICATA4,
          VENCIMENTO4,
          VLDUPLICATA4,

          DUPLICATA4,
          VENCIMENTO4,
          VLDUPLICATA4,

          DUPLICATA5,
          VENCIMENTO5,
          VLDUPLICATA5,

          DUPLICATA6,
          VENCIMENTO6,
          VLDUPLICATA6,

          DUPLICATA7,
          VENCIMENTO7,
          VLDUPLICATA7,

          DUPLICATA8,
          VENCIMENTO8,
          VLDUPLICATA8,

          DUPLICATA9,
          VENCIMENTO9,
          VLDUPLICATA9,

          DUPLICATA10,
          VENCIMENTO10,
          VLDUPLICATA10,

          DUPLICATA11,
          VENCIMENTO11,
          VLDUPLICATA11,

          DUPLICATA12,
          VENCIMENTO12,
          VLDUPLICATA12
        from
          #Nota_Saida_Parcela_Padrao

    end --FIM DAS OUTRAS EMPRESAS - DEFAULT
end --FIM DO PARAMETRO 1
