
create procedure pr_gera_fluxo_contas_pagar

@cd_conta integer,
@dt_inicial  datetime,
@dt_final    datetime

as

declare @dt_chave          datetime
declare @dt_chave_anterior datetime
declare @ic_util           char(1)
declare @ic_util_anterior  char(1)
declare @nm_linha          varchar(15)
declare @ic_deleta         char(1)
declare @soma              float
declare @vl_dia            float
declare @total						 float

set @nm_linha = ''

--Montagem da Tabela com o Período da Agenda
  select 
    dt_agenda	as 'DataFluxo',
    ic_util     as 'DiaUtil' 
  into
    #Periodo_Aux
  from 
    Agenda 
  where 
    dt_agenda between @dt_inicial and @dt_final
  order by
    dt_agenda 

--Montagem do Arquivo com os Valores por Dia

  select
    dr.dt_vencimento_documento           as 'DataVencto',
    isnull(sum(dr.vl_saldo_documento_pagar),0) as 'Valor'

  Into #Documento
  from
    Documento_Pagar dr
  where
    @cd_conta   = dr.cd_tipo_conta_pagar      and
    dr.dt_vencimento_documento between @dt_inicial and @dt_final and
    dr.dt_cancelamento_documento is null and
    dr.dt_devolucao_documento    is null
  group by 
     dr.dt_vencimento_documento 
  order by
    1

select p.DataFluxo,
       p.DiaUtil,
       d.Valor
into #Periodo
from  
  #Periodo_Aux p, #Documento d
where
  p.DataFluxo *= d.DataVencto 

  --Montagem do Fluxo do Contas a Receber
  create table #Tabela( dias varchar(15) NULL, valor float NULL, perc float NULL) 

  select 
    top 1
    @ic_util_anterior = DiaUtil
  from
    #Periodo
  order by
    DataFluxo

  while exists(select top 1 DataFluxo from #Periodo)
  begin

      select
        top 1
        @dt_chave = DataFluxo,
        @ic_util  = DiaUtil,
        @vl_dia   = isnull(Valor,0)
      from
        #Periodo
      order by
        DataFluxo

      set @ic_deleta = 'S'

      if (@nm_linha <> '')
        begin
          set @nm_linha = @nm_linha + '.' + cast( day(@dt_chave) as varchar(2) )
          set @soma     = @soma + @vl_dia
        end
      else
        begin
          set @nm_linha = cast(day(@dt_chave) as varchar(2))
          set @soma     = @vl_dia
        end

      if @ic_util <> @ic_util_anterior 
         begin

           insert into #Tabela values (@nm_linha,isnull(@soma,0),null)

           set @nm_linha = ''
           set @soma     = 0 
        end

      else
        begin
        
          if @ic_util = 'S' 
          begin

            insert into #Tabela values (cast(day(@dt_chave) as varchar(2)),isnull(@soma,0),null)

            set @ic_deleta         = 'N'
            set @dt_chave_anterior = @dt_chave
            set @ic_util_anterior  = @ic_util
            set @nm_linha          = ''
            set @soma              = 0

            --Verificar o Próximo

            delete from
              #Periodo
            where
              DataFluxo = @dt_chave

             select
               top 1
               @dt_chave = DataFluxo,
               @ic_util  = DiaUtil,
               @soma     = Valor
             from
               #Periodo
             order by
               DataFluxo

            if @ic_util='S' and @ic_util_anterior='S' 
            begin
               set @nm_linha = ''
            end

          end

        end            

      set @ic_util_anterior = @ic_util
     
      if @ic_deleta = 'S'
         delete from
           #Periodo
         where
           DataFluxo = @dt_chave

    end
          

                        
--select * from #Tabela

select @total = isnull(sum(valor),0) from #Tabela

select 
  dias,
  valor,
 (case when @total = 0 then 0 
  else ((valor * 100) / @total) end ) as perc
from 
  #Tabela

