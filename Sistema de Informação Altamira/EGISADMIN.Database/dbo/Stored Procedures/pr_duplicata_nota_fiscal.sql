
------------------------------------------------------------------------------------------
--pr_duplicata_nota_fiscal
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
------------------------------------------------------------------------------------

CREATE  PROCEDURE pr_duplicata_nota_fiscal
@ic_parametro int,
@nm_fantasia_empresa varchar(20),
@cd_nota_fiscal int

as

declare @i int
declare @qt_parcela int  -- ELIAS 14/04/2003

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
        select
          identity(int, 1, 1)		as 'LINHA',
          p.cd_ident_parc_nota_saida      as 'DUPLICATA',
          case when (p.dt_parcela_nota_saida < n.dt_nota_saida) then
            'QUITADO'
          else
            convert(varchar,p.dt_parcela_nota_saida,3)
          end				as 'VENCIMENTO',
          p.vl_parcela_nota_saida		as 'VLDUPLICATA',
          cast(null as varchar(25))	as 'DUPLICATA2',
          cast(null as datetime)	as 'VENCIMENTO2',
          cast(null as float)		as 'VLDUPLICATA2',
          cast(null as varchar(25))	as 'DUPLICATA3',
          cast(null as datetime)	as 'VENCIMENTO3',
          cast(null as float)		as 'VLDUPLICATA3'
        into
          #Nota_Saida_Parcela_TMBevo
        from
          Nota_Saida_Parcela p
        left outer join
          Nota_Saida n
        on
          n.cd_nota_saida = p.cd_nota_saida
        where
          p.cd_nota_saida = @cd_nota_fiscal and
          ((p.cd_parcela_nota_saida = 1) or 
           (p.cd_parcela_nota_saida = 4))
        order by
          p.cd_parcela_nota_saida

        if exists(select * from Nota_Saida_Parcela where
                  cd_nota_saida = @cd_nota_fiscal and cd_parcela_nota_saida > 1)
        begin

           update
              #Nota_Saida_Parcela_TMBevo
           set
              DUPLICATA2      = p.cd_ident_parc_nota_saida,
              VENCIMENTO2     = convert(varchar,p.dt_parcela_nota_saida,3),
              VLDUPLICATA2    = p.vl_parcela_nota_saida
           from
              Nota_Saida_Parcela p
           where
              case LINHA when 1 then 2
                         when 2 then 5 end = p.cd_parcela_nota_saida and
              p.cd_nota_saida = @cd_nota_fiscal 

         end --FIM DO IF DE PARCELAS MAIORES QUE 1

        if exists(select * from Nota_Saida_Parcela where
                  cd_nota_saida = @cd_nota_fiscal and cd_parcela_nota_saida > 3)
        begin

            update
              #Nota_Saida_Parcela_TMBevo
            set
              DUPLICATA3      = p.cd_ident_parc_nota_saida,
              VENCIMENTO3     = convert(varchar,p.dt_parcela_nota_saida,3),
              VLDUPLICATA3    = p.vl_parcela_nota_saida
            from
              Nota_Saida_Parcela p
            where
              case LINHA when 1 then 3
                         when 2 then 6 end = p.cd_parcela_nota_saida and
              p.cd_nota_saida = @cd_nota_fiscal 

        end --FIM DO IF QUE TRATA PARCELAS ACIMA DE 3

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
          #Nota_Saida_Parcela_TMBevo

  end --FIM DO IF PARA A EMPRESA TMBEVO
-------------------------------------------------------------------------------
  else --Layout Padrao
-------------------------------------------------------------------------------
  begin
        select
          p.cd_ident_parc_nota_saida as 'DUPLICATA',
          convert(varchar,p.dt_parcela_nota_saida,3) as 'VENCIMENTO',
          p.vl_parcela_nota_saida    as 'VLDUPLICATA',
          cast(null as varchar(25))  as 'DUPLICATA2',
          cast(null as datetime)     as 'VENCIMENTO2',
          cast(null as float)	     as 'VLDUPLICATA2',
          cast(null as varchar(25))  as 'DUPLICATA3',
          cast(null as datetime)     as 'VENCIMENTO3',
          cast(null as float)	     as 'VLDUPLICATA3',
          cast(null as varchar(25))  as 'DUPLICATA4',
          cast(null as datetime)     as 'VENCIMENTO4',
          cast(null as float)	     as 'VLDUPLICATA4',

          cast(null as varchar(25))  as 'DUPLICATA5',
          cast(null as datetime)     as 'VENCIMENTO5',
          cast(null as float)	     as 'VLDUPLICATA5',

          cast(null as varchar(25))  as 'DUPLICATA6',
          cast(null as datetime)     as 'VENCIMENTO6',
          cast(null as float)	     as 'VLDUPLICATA6',

          cast(null as varchar(25))  as 'DUPLICATA7',
          cast(null as datetime)     as 'VENCIMENTO7',
          cast(null as float)	     as 'VLDUPLICATA7',

          cast(null as varchar(25))  as 'DUPLICATA8',
          cast(null as datetime)     as 'VENCIMENTO8',
          cast(null as float)	     as 'VLDUPLICATA8',

          cast(null as varchar(25))  as 'DUPLICATA9',
          cast(null as datetime)     as 'VENCIMENTO9',
          cast(null as float)	     as 'VLDUPLICATA9',

          cast(null as varchar(25))  as 'DUPLICATA10',
          cast(null as datetime)     as 'VENCIMENTO10',
          cast(null as float)	     as 'VLDUPLICATA10',

          cast(null as varchar(25))  as 'DUPLICATA11',
          cast(null as datetime)     as 'VENCIMENTO11',
          cast(null as float)	     as 'VLDUPLICATA11',

          cast(null as varchar(25))  as 'DUPLICATA12',
          cast(null as datetime)     as 'VENCIMENTO12',
          cast(null as float)	     as 'VLDUPLICATA12'
        into
          #Nota_Saida_Parcela_Padrao
        from
          Nota_Saida_Parcela p left outer join
          Nota_Saida         n on n.cd_nota_saida = p.cd_nota_saida
        where
          p.cd_nota_saida         = @cd_nota_fiscal and
          p.cd_parcela_nota_saida = 1


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

        select
          DUPLICATA,
          VENCIMENTO,
          VLDUPLICATA,
          DUPLICATA2,
          VENCIMENTO2,
          VLDUPLICATA2
        from
          #Nota_Saida_Parcela_Padrao

    end --FIM DAS OUTRAS EMPRESAS - DEFAULT
end --FIM DO PARAMETRO 1
