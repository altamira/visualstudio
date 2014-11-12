﻿

--pr_calculo_comissao
--------------------------------------------------------------------------------------
--Polimold Industrial S/A                                                             2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes 
--Processamento do Pagamento de Comissões aos Vendedores
--Vendedor + Categoria de Produtos
--Data         : 01.09.2000
--Atualizado   : 04.09.2000
--             : 02.10.2000 - Acerto para Cálculo 2 tipos (Vendedor/Representantes)
--             : 03.10.2000 - Separação do tipo de cálculo 
--             : 16.10.2000 - Resumo
--             : 07.11.2000 - Acerto da Rotina para Cálculo Over Price  
--             : 10.11.2000 - Inclusão de parâmetros : Seleção do tipo de vendedor a calcular
--------------------------------------------------------------------------------------

CREATE procedure pr_calculo_comissao_testes

@ic_parametro_calculo     int,      -- Tipo de Cálculo para chamada de procedimentos
@cd_vendedor_inicial      int,      -- Vendedor  Inicial
@cd_vendedor_final        int,      -- Vendedor  final
@dt_inicial               datetime, -- Data Inicial de Cálculo
@dt_final                 datetime, -- Data Final   de Cálculo
@dt_perc_smo              datetime, -- Data de Mudança da alíquota do cálculo ICMS-SMO
@ic_tipo_vendedor_inicial char(1),  -- Vendedor Externo(N), Representante(S) ou os dois(N->S)  
@ic_tipo_vendedor_final   char(1)   -- Vendedor Externo(N), Representante(S) ou os dois(N->S)

as

declare @vl_zero float
declare @ic_tipo_calculo_price int

set @vl_zero = 0
set @ic_tipo_calculo_price = 0   --default sem considerar over price

-- Verifica o Parâmetro de Cálculo do Preço Orçado (com ou sem Over Price)
-- 0 : Parâmetro de cálculo é com Over Price - Preço Lista Bruto
-- 1 : Parâmetro de cálculo é sem Over Price - Preço Líquido

select 
  @ic_tipo_calculo_price = ic_tipo_calculo
from 
  sapsql.dbo.parametro_comissao
where 
  dt_parametro_tipo_calculo = @dt_final

-- Cálculo da Comissão com dados dos itens da nota fiscal

select 
        a.codvend2                          as 'setor',        
        c.ncmapa                            as 'categoria',
        a.fan_cli                           as 'cliente',
        b.pedido                            as 'pedido', 
        b.item                              as 'item',
        d.dtped                             as 'emissao',
        b.qt                                as 'qtd', 
        -- Se houver valor no ICMSDESC (Percentual Venda Manaus), retira
        case when isnull(b.icmsdesc,0) = 0 then (b.qt*b.preco) else
           (b.qt*b.preco)-((b.qt*b.preco)*b.icmsdesc/100) end as 'venda',
        orcado =  
        case 
          when @ic_tipo_calculo_price=0 then
            case 
               when (d.fatsmo = 'S' and a.datanf < @dt_perc_smo) then 
                  (b.qt*c.precolist)-((b.qt*c.precolist)*11/100)
               when (d.fatsmo = 'S' and a.datanf >= @dt_perc_smo) then 
                  (b.qt*c.precolist)-((b.qt*c.precolist)*8.8/100)
               else
                  (b.qt*c.precolist) 
            end
          when @ic_tipo_calculo_price=1 then
            case 
               when (d.fatsmo = 'S' and a.datanf < @dt_perc_smo) then 
                  (b.qt*isnull(c.precover,c.precolist))-((b.qt*isnull(c.precover,c.precolist))*11/100)
               when (d.fatsmo = 'S' and a.datanf >= @dt_perc_smo) then 
                  (b.qt*isnull(c.precover,c.precolist))-((b.qt*isnull(c.precover,c.precolist))*8.8/100)
               else
                  (b.qt*isnull(c.precover,c.precolist)) 
            end
        end,
        b.nf                                as 'nota', 
        b.itemnf                            as 'itemnota', 
        b.datanf                            as 'datanota',
        descto =
        case
          when @ic_tipo_calculo_price=0 then
            case 
               when ( d.fatsmo = 'S' and a.datanf < @dt_perc_smo) then 
                  (100-(b.preco/(c.precolist-(c.precolist*11/100)))*100)
               when ( d.fatsmo = 'S' and a.datanf >= @dt_perc_smo) then 
                  (100-(b.preco/(c.precolist-(c.precolist*8.8/100)))*100)
               else 
                  (100-(b.preco/c.precolist)*100)
            end
          when @ic_tipo_calculo_price=1 then
            case 
               when ( d.fatsmo = 'S' and a.datanf < @dt_perc_smo) then 
                  (100-(b.preco/(isnull(c.precover,c.precolist)-(isnull(c.precover,c.precolist)*11/100)))*100)
               when ( d.fatsmo = 'S' and a.datanf >= @dt_perc_smo) then 
                  (100-(b.preco/(isnull(c.precover,c.precolist)-(isnull(c.precover,c.precolist)*8.8/100)))*100)
               else 
                  (100-(b.preco/isnull(c.precover,c.precolist))*100)
            end
        end, 
       (c.almoxit+c.codigoit)                as 'codprod',
        c.cod_ant                            as 'codant',
        c.descricao                          as 'descricao',
        c.dtentrpcp                          as 'dtentrpcp',   
        d.FATSMO                             as 'smo',
        b.tpstatus                           as 'status',
        b.dtcanc                             as 'datacanc',
        b.motivocan                          as 'devolucao',
        '1 - NOTAS FATURADAS            '    as 'devolvido',
        e.ic_tipo_calculo                    as 'tipocalculo',
        e.ic_representante                   as 'representante',
        e.pc_comissao                        as 'pcomissao',
        @vl_zero                             as 'devolucaomes',
        @vl_zero                             as 'devolucaomesant',
        @vl_zero                             as 'qtdevolucao'   

into #Comissao
from
    CADNF a, CADINF b, CADIPED c, CADPED d, sapsql.dbo.Vendedor_Comissao e, FTOPER f

Where
  (a.codvend2 between @cd_vendedor_inicial and @cd_vendedor_final ) and
  (a.datanf   between @dt_inicial and @dt_final ) and
   a.codno     = f.codigo                         and
   f.comercial = 'S'                              and
   a.outroper < 2                                 and
   a.vlrtotnf > 0                                 and 
   a.nf = b.nf                                    and
   isnull(b.tpstatus,' ') <> 'C'                  and
   b.qt*b.preco > 0                               and
   a.codvend2 = e.cd_vendedor                     and
   b.pedido = d.pedido                            and
   d.dtped >= e.dt_base_pagamento                 and
 ((isnull(e.ic_calcula_data_final,'N') = 'N') or
  (e.ic_calcula_data_final = 'S' and 
   d.dtped <= e.dt_final_pagamento) )             and   
   d.pedido = c.pedidoit                          and
   b.item = c.item                                and 
   c.item < 80                                    and
   c.fatsmoit = 'N'                               and
   -- Cálculo da comissão
   c.precolist > 0                                -- comissão é feita pelo preço orçado

Order by a.codvend2,b.ncmapa,a.fan_cli

-- Devolução de notas fiscais que ocorreram no período selecionado
-- Mês Corrente

select 
        a.codvend2                          as 'setor',      
        c.ncmapa                            as 'categoria',
        a.fan_cli                           as 'cliente',
        b.pedido                            as 'pedido', 
        b.item                              as 'item',
        d.dtped                             as 'emissao',
        qtd =
          case 
             when b.qtdev > 0 then b.qtdev 
             else b.qt
          end,
        venda =
          case 
             when b.qtdev > 0 then (qtdev*b.preco)*-1 
             else                  (b.qt*b.preco) *-1
          end,
        orcado =
        case
          when @ic_tipo_calculo_price=0 then
            case
               when (b.qtdev>0 and d.fatsmo = 'S' and a.datanf < @dt_perc_smo) then 
                  (b.qtdev*c.precolist*-1)-((b.qtdev*c.precolist*-1)*11/100)
               when (b.qtdev>0 and d.fatsmo = 'S' and a.datanf >= @dt_perc_smo) then 
                  (b.qtdev*c.precolist*-1)-((b.qtdev*c.precolist*-1)*8.8/100)
               when (qtdev=0 and d.fatsmo = 'S' and a.datanf < @dt_perc_smo) then 
                  (b.qt*c.precolist*-1)-((b.qt*c.precolist*-1)*11/100)
               when (qtdev=0 and d.fatsmo = 'S' and a.datanf >= @dt_perc_smo) then 
                  (b.qt*c.precolist*-1)-((b.qt*c.precolist*-1)*8.8/100)
               when 
                  (b.qtdev > 0 ) then ( b.qtdev*c.precolist*-1) 
               else
                  (b.qt*c.precolist*-1) 
            end
          when @ic_tipo_calculo_price=1 then
            case
               when (b.qtdev>0 and d.fatsmo = 'S' and a.datanf < @dt_perc_smo) then 
                  (b.qtdev*isnull(c.precover,c.precolist)*-1)-((b.qtdev*isnull(c.precover,c.precolist)*-1)*11/100)
               when (b.qtdev>0 and d.fatsmo = 'S' and a.datanf >= @dt_perc_smo) then 
                  (b.qtdev*isnull(c.precover,c.precolist)*-1)-((b.qtdev*isnull(c.precover,c.precolist)*-1)*8.8/100)
               when (qtdev=0 and d.fatsmo = 'S' and a.datanf < @dt_perc_smo) then 
                  (b.qt*isnull(c.precover,c.precolist)*-1)-((b.qt*isnull(c.precover,c.precolist)*-1)*11/100)
               when (qtdev=0 and d.fatsmo = 'S' and a.datanf >= @dt_perc_smo) then 
                  (b.qt*isnull(c.precover,c.precolist)*-1)-((b.qt*isnull(c.precover,c.precolist)*-1)*8.8/100)
               when 
                  (b.qtdev > 0 ) then ( b.qtdev*isnull(c.precover,c.precolist)*-1) 
               else
                  (b.qt*isnull(c.precover,c.precolist)*-1) 
            end
        end,   
        b.nf                                as 'nota', 
        b.itemnf                            as 'itemnota', 
        b.datanf                            as 'datanota',
        descto =
        case          
          when @ic_tipo_calculo_price=0 then
            case
               when (d.fatsmo = 'S' and a.datanf < @dt_perc_smo)  then 
                (100-(b.preco/(c.precolist-(c.precolist*11/100)))*100)
               when (d.fatsmo = 'S' and a.datanf >= @dt_perc_smo) then 
                (100-(b.preco/(c.precolist-(c.precolist*8.8/100)))*100)
               else 
                (100-(b.preco/c.precolist)*100)
            end
          when @ic_tipo_calculo_price=1 then
            case
               when (d.fatsmo = 'S' and a.datanf < @dt_perc_smo)  then 
                (100-(b.preco/(isnull(c.precover,c.precolist)-(isnull(c.precover,c.precolist)*11/100)))*100)
               when (d.fatsmo = 'S' and a.datanf >= @dt_perc_smo) then 
                (100-(b.preco/(isnull(c.precover,c.precolist)-(isnull(c.precover,c.precolist)*8.8/100)))*100)
               else 
                (100-(b.preco/isnull(c.precover,c.precolist))*100)
            end
        end,
       (c.almoxit+c.codigoit)               as 'codprod',
        c.cod_ant                           as 'codant',
        c.descricao                         as 'descricao',
        c.dtentrpcp                         as 'dtentrpcp',   
        d.FATSMO                            as 'smo',
        b.tpstatus                          as 'status',
        b.dtcanc                            as 'datacanc',
        b.motivocan                         as 'devolucao',
        '2 - DEVOLUÇÕES MÊS ATUAL       '   as 'devolvido',
        e.ic_tipo_calculo                   as 'tipocalculo',
        e.ic_representante                  as 'representante',
        e.pc_comissao                       as 'pcomissao',
        devolucaomes =
          case 
             when b.qtdev > 0 then (qtdev*b.preco) 
             else                  (b.qt *b.preco) 
          end,
        @vl_zero                          as 'devolucaomesant',
        qtdevolucao =
          case 
             when b.qtdev > 0 then b.qtdev 
             else b.qt
          end
    
into #ComissaoDevolucao
from
    CADNF a, CADINF b, CADIPED c, CADPED d, sapsql.dbo.Vendedor_Comissao e, FTOPER f 

Where
  (a.codvend2 between @cd_vendedor_inicial and @cd_vendedor_final ) and
  (a.datanf between @dt_inicial and @dt_final )   and
   a.codno     = f.codigo                         and
   f.comercial = 'S'                              and
   a.outroper < 2                                 and
   a.vlrtotnf > 0                                 and 
   a.nf = b.nf                                    and
   b.tpstatus = 'D'                               and
  (b.dtcanc between @dt_inicial and @dt_final )   and
   b.qt*b.preco > 0                               and
   a.codvend2 = e.cd_vendedor                     and
   b.pedido = d.pedido                            and
   d.dtped >= e.dt_base_pagamento                 and
 ((isnull(e.ic_calcula_data_final,'N') = 'N') or
  (e.ic_calcula_data_final = 'S' and 
   d.dtped <= e.dt_final_pagamento) )             and   
   d.pedido = c.pedidoit                          and
   b.item = c.item                                and
   c.item < 80                                    and
   c.fatsmoit = 'N'                               and
   c.precolist > 0

Order by a.codvend2,b.ncmapa,a.fan_cli

-- Devolução de notas fiscais que ocorreram no período selecionado
-- Meses Anteriores

select 
        a.codvend2                          as 'setor',    
        c.ncmapa                            as 'categoria',
        a.fan_cli                           as 'cliente',
        b.pedido                            as 'pedido', 
        b.item                              as 'item',
        d.dtped                             as 'emissao',
        qtd =
          case 
             when b.qtdev > 0 then b.qtdev 
             else                  b.qt   
          end,
        venda =
          case 
             when b.qtdev > 0 then (qtdev*b.preco*-1) 
             else                  (b.qt *b.preco*-1)
          end,
        orcado =
        case
          when @ic_tipo_calculo_price=0 then
            case
               when (b.qtdev>0 and d.fatsmo = 'S' and a.datanf < @dt_perc_smo) then 
                  (b.qtdev*c.precolist*-1)-((b.qtdev*c.precolist*-1)*11/100)
               when (b.qtdev>0 and d.fatsmo = 'S' and a.datanf >= @dt_perc_smo) then 
                  (b.qtdev*c.precolist*-1)-((b.qtdev*c.precolist*-1)*8.8/100)
               when (qtdev=0 and d.fatsmo = 'S' and a.datanf < @dt_perc_smo) then 
                  (b.qt*c.precolist*-1)-((b.qt*c.precolist*-1)*11/100)
               when (qtdev=0 and d.fatsmo = 'S' and a.datanf >= @dt_perc_smo) then 
                  (b.qt*c.precolist*-1)-((b.qt*c.precolist*-1)*8.8/100)
               when 
                  (b.qtdev > 0 ) then ( b.qtdev*c.precolist*-1) 
               else
                  (b.qt*c.precolist*-1) 
            end
          when @ic_tipo_calculo_price=1 then
            case
               when (b.qtdev>0 and d.fatsmo = 'S' and a.datanf < @dt_perc_smo) then 
                  (b.qtdev*isnull(c.precover,c.precolist)*-1)-((b.qtdev*isnull(c.precover,c.precolist)*-1)*11/100)
               when (b.qtdev>0 and d.fatsmo = 'S' and a.datanf >= @dt_perc_smo) then 
                  (b.qtdev*isnull(c.precover,c.precolist)*-1)-((b.qtdev*isnull(c.precover,c.precolist)*-1)*8.8/100)
               when (qtdev=0 and d.fatsmo = 'S' and a.datanf < @dt_perc_smo) then 
                  (b.qt*isnull(c.precover,c.precolist)*-1)-((b.qt*isnull(c.precover,c.precolist)*-1)*11/100)
               when (qtdev=0 and d.fatsmo = 'S' and a.datanf >= @dt_perc_smo) then 
                  (b.qt*isnull(c.precover,c.precolist)*-1)-((b.qt*isnull(c.precover,c.precolist)*-1)*8.8/100)
               when 
                  (b.qtdev > 0 ) then ( b.qtdev*isnull(c.precover,c.precolist)*-1) 
               else
                  (b.qt*isnull(c.precover,c.precolist)*-1) 
            end
        end,
        b.nf                                as 'nota', 
        b.itemnf                            as 'itemnota', 
        b.datanf                            as 'datanota',
        descto =
        case
          when @ic_tipo_calculo_price=0 then
            case
               when (d.fatsmo = 'S' and a.datanf < @dt_perc_smo) then 
                  (100-(b.preco/(c.precolist-(c.precolist*11/100)))*100)
               when (d.fatsmo = 'S' and a.datanf >= @dt_perc_smo) then 
                  (100-(b.preco/(c.precolist-(c.precolist*8.8/100)))*100)
               else 
                  (100-(b.preco/c.precolist)*100)
            end
          when @ic_tipo_calculo_price=1 then
            case
               when (d.fatsmo = 'S' and a.datanf < @dt_perc_smo) then 
                  (100-(b.preco/(isnull(c.precover,c.precolist)-(isnull(c.precover,c.precolist)*11/100)))*100)
               when (d.fatsmo = 'S' and a.datanf >= @dt_perc_smo) then 
                  (100-(b.preco/(isnull(c.precover,c.precolist)-(isnull(c.precover,c.precolist)*8.8/100)))*100)
               else 
                  (100-(b.preco/isnull(c.precover,c.precolist))*100)
            end
        end,
       (c.almoxit+c.codigoit)               as 'codprod',
        c.cod_ant                           as 'codant',
        c.descricao                         as 'descricao',
        c.dtentrpcp                         as 'dtentrpcp',   
        d.FATSMO                            as 'smo',
        b.tpstatus                          as 'status',
        b.dtcanc                            as 'datacanc',
        b.motivocan                         as 'devolucao',
        '3 - DEVOLUÇÕES MESES ANTERIORES'   as 'devolvido',
        e.ic_tipo_calculo                   as 'tipocalculo',
        e.ic_representante                  as 'representante',
        e.pc_comissao                       as 'pcomissao',
        @vl_zero                            as 'devolucaomes',
        devolucaomesant =
          case 
             when b.qtdev > 0 then (b.qtdev*b.preco) 
             else                  (b.qt   *b.preco) 
          end,
        qtdevolucao =
          case 
             when b.qtdev > 0 then b.qtdev 
             else                  b.qt   
          end
        
into #ComissaoDevolucaoAnt
from
    CADNF a, CADINF b, CADIPED c, CADPED d, sapsql.dbo.Vendedor_Comissao e, FTOPER f

Where
  (a.codvend2 between @cd_vendedor_inicial and @cd_vendedor_final ) and
   a.codno     = f.codigo                         and
   f.comercial = 'S'                              and
   a.outroper < 2                                 and
   a.vlrtotnf > 0                                 and 
   a.nf = b.nf                                    and
  (b.dtcanc   between @dt_inicial and @dt_final ) and
  (b.datanf < @dt_inicial )                       and -- Mês Anterior
   b.tpstatus = 'D'                               and
   b.qt*b.preco > 0                               and
   a.codvend2 = e.cd_vendedor                     and
   b.pedido = d.pedido                            and
   d.dtped >= e.dt_base_pagamento                 and
 ((isnull(e.ic_calcula_data_final,'N') = 'N') or
  (e.ic_calcula_data_final = 'S' and 
   d.dtped <= e.dt_final_pagamento) )             and   
   d.pedido = c.pedidoit                          and
   b.item   = c.item                              and
   c.item < 80                                    and
   c.fatsmoit = 'N'                               and
   c.precolist > 0

Order by a.codvend2,b.ncmapa,a.fan_cli


-- ***********************************************
-- Juntar as três tabelas temporárias de devolução
-- ***********************************************


insert into #Comissao
select * 
from
  #ComissaoDevolucao 

insert into #Comissao
select * 
from
  #ComissaoDevolucaoAnt 

--Seleciona o (%) de Comissão sem Desconto

declare @pc_comissao_sdescto float

-- Pega apenas o 1o. registro
set rowcount 1

select @pc_comissao_sdescto = pc_comissao
from
  sapsql.dbo.PercentualComissao

-- Libera select para todas linhas da tabela
set rowcount 0

-- Cálculo do (%) de comissão dos vendedores / Representantes

   select b.sgmapa                      as 'Sigla',
          B.o1mapa,
          a.*, 
          --(%) de comissão
          percomissao =  
          case
             when (a.tipocalculo = 1 and a.cliente<>'INDEPLAST') then c.pc_comissao
             when (a.tipocalculo = 1 and a.cliente='INDEPLAST')  then 2
--           when (a.tipocalculo = 1 and a.cliente='MOREIRACO')  then 0
--           when (a.tipocalculo = 1 and a.cliente='INTERPOLI')  then 0
--           when (a.tipocalculo = 1 and a.cliente='M.ANDRIONI') then 0
--           when (a.tipocalculo = 1 and a.cliente='SULPOLI')    then 0
--           when (a.tipocalculo = 1 and a.cliente='POLIMINAS')  then 0
--           when (a.tipocalculo = 1 and a.cliente='VIGUIPOLI')  then 0
             else                        a.pcomissao
             end,

          --Valor da Comissão
          comissao =
          case
             when (a.tipocalculo = 1 and a.cliente<>'INDEPLAST') then (a.venda * (c.pc_comissao/100))
             when (a.tipocalculo = 1 and a.cliente='INDEPLAST')  then (a.venda * (2.0 / 100))
--           when (a.tipocalculo = 1 and a.cliente='MOREIRACO')  then 0
--           when (a.tipocalculo = 1 and a.cliente='INTERPOLI')  then 0
--           when (a.tipocalculo = 1 and a.cliente='M.ANDRIONI') then 0
--           when (a.tipocalculo = 1 and a.cliente='SULPOLI')    then 0
--           when (a.tipocalculo = 1 and a.cliente='POLIMINAS')  then 0
--           when (a.tipocalculo = 1 and a.cliente='VIGUIPOLI')  then 0
             else                        a.venda * (a.pcomissao/100) 
             end,

          --Valor da Comissão sem Desconto

          sdescto = 
          case
             when (a.tipocalculo = 1 and a.cliente<>'INDEPLAST') then a.orcado * (@pc_comissao_sdescto/100)
             when (a.tipocalculo = 1 and a.cliente='INDEPLAST') then a.orcado * (2.0 / 100)
--           when (a.tipocalculo = 1 and a.cliente='MOREIRACO')  then 0
--           when (a.tipocalculo = 1 and a.cliente='INTERPOLI')  then 0
--           when (a.tipocalculo = 1 and a.cliente='M.ANDRIONI') then 0
--           when (a.tipocalculo = 1 and a.cliente='SULPOLI')    then 0
--           when (a.tipocalculo = 1 and a.cliente='POLIMINAS')  then 0
--           when (a.tipocalculo = 1 and a.cliente='VIGUIPOLI')  then 0
             else                        a.orcado * (a.pcomissao/100) 
             end,

          b.o1mapa           as 'ordem'

   into #Calculo_Comissao
   from 
      #Comissao a, Cadmapa b, sapsql.dbo.PercentualComissao c
   where
      a.categoria = b.ncmapa      and                             -- sigla do mapa
      b.mvmapa = 'S'              and
     (round(a.descto,2)           between 
      c.qt_faixa_inicial_desconto and c.qt_faixa_final_desconto)  -- (%) descto. 

   Order by a.setor,b.o1mapa,a.devolvido,a.cliente,a.pedido,a.item
--Alteração de novas variaveis de desconto

-- Verifica o Tipo de Parâmetro para processamento 

if @ic_parametro_calculo = 0  --Cálculo da Comissão
   begin
     select * from #Calculo_Comissao 
     where Representante between @ic_tipo_vendedor_inicial and @ic_tipo_vendedor_final
     Order by setor,o1mapa,devolvido,cliente,pedido,item
   end

if @ic_parametro_calculo = 1  --Atualiza a tabela de cálculo do movimento de comissões
   begin

     -- Monta Tabela Agrupada por Vendedor
    
     select setor,
            sum(venda)    as 'TotalVendas',    --Total Comissionável
            sum(comissao) as 'TotalComissao',  --Total Comissão           
            sum(sdescto)  as 'TotalSDesconto', --Total sem Desconto 
           (100-(sum(venda)/sum(orcado))*100) as 'Desconto' -- % Aplicado 
     into #Resumo 
     from 
         #Calculo_Comissao

     Group by setor
     order by setor

     --Atualiza a tabela de movimento

     declare @cd_vendedor      int
     declare @vl_comissionavel float
     declare @vl_comissao      float
     declare @cd_vendedor_localizado int
     declare @vl_comissao_sem_desconto float
     declare @pc_desconto      float

     set @cd_vendedor      = 0
     set @vl_comissionavel = 0
     set @vl_comissao      = 0
     set @vl_comissao_sem_desconto = 0
     set @pc_desconto      = 0
           
     while exists ( select * from #Resumo )
     begin
       
       select @cd_vendedor      = setor,
              @vl_comissionavel = totalvendas,
              @vl_comissao      = totalcomissao,
              @vl_comissao_sem_desconto = TotalSDesconto,
              @pc_desconto = Desconto
       from #Resumo
   
       -- Verifica se o vendedor está cadastrado
   
       select @cd_vendedor_localizado = cd_vendedor
       from 
         sapsql.dbo.movimento_comissao 
       where 
          cd_vendedor = @cd_vendedor and 
          dt_base_comissao = @dt_final 

       -- Insere registro novo de cálculo

       if @@rowcount = 0 

          begin                                                        -- O segundo 1 é igual ao item do movimento comissão   
            insert sapsql.dbo.Movimento_comissao values ( @cd_vendedor,@dt_final,1,1,@vl_comissionavel,null,null)
            insert sapsql.dbo.Movimento_comissao values ( @cd_vendedor,@dt_final,2,1,@vl_comissao,null,null)
            insert sapsql.dbo.Resumo_Comissao_Vendedor values ( @cd_vendedor,@dt_final,@vl_comissao,@vl_comissao_sem_desconto,@pc_desconto,null,getdate())
          end   

       else

          begin
            -- Total Comissionavel
            update sapsql.dbo.Movimento_comissao
            set 
               vl_lancamento_comissao = @vl_comissionavel
            where
               @cd_vendedor = cd_vendedor      and
               @dt_final    = dt_base_comissao and
               cd_ocorrencia_comissao = 1

             -- Total Comissão no Arquivo de Lançamentos
             update sapsql.dbo.Movimento_comissao
             set 
               vl_lancamento_comissao = @vl_comissao
             where
               @cd_vendedor = cd_vendedor      and
               @dt_final    = dt_base_comissao and
               cd_ocorrencia_comissao = 2

             -- Total Comissão no Arquivo de Comissões
             update sapsql.dbo.Resumo_Comissao_Vendedor
             set 
               vl_comissao = @vl_comissao
             where
               @cd_vendedor = cd_vendedor      and
               @dt_final    = dt_base_comissao 

             -- Total Comissão sem Desconto no Arquivo de Comissões
             update sapsql.dbo.Resumo_Comissao_Vendedor
             set 
               vl_comissao_sem_desconto = @vl_comissao_sem_desconto
             where
               @cd_vendedor = cd_vendedor      and
               @dt_final    = dt_base_comissao 

             -- Total de Percentuais aplicados no cálculo no Arquivo de Comissões
             update sapsql.dbo.Resumo_Comissao_Vendedor
             set 
               pc_desconto = @pc_desconto
             where
               @cd_vendedor = cd_vendedor      and
               @dt_final    = dt_base_comissao 

             -- Data do Novo Cálculo no Arquivo de Comissões
             update sapsql.dbo.Resumo_Comissao_Vendedor
             set 
               dt_calculo = getdate()
             where
               @cd_vendedor = cd_vendedor      and
               @dt_final    = dt_base_comissao 
 
          end
             
          -- Deletar o registro atualizado

          delete #Resumo
          where
            setor = @cd_vendedor_localizado 
                   
     end

     -- Mostra resumo total por categoria

     select a.ordem,
            Max(a.Categoria)                           as 'Categoria',                                 
            Max(a.Sigla)                               as 'Sigla', 
            sum(a.qtd)-sum( 2*a.qtdevolucao)           as 'TotalQtd',  
            sum(a.venda)                               as 'Faturamento',  
            sum(a.devolucaomes)+sum(a.devolucaomesant) as 'TotalDevolucao',
            sum(a.orcado)                              as 'TotalOrcado',
            sum(a.qtdevolucao)                         as 'TotalQtdDev', 
            sum(a.comissao)                            as 'TotalComissao',
            sum(a.sdescto)                             as 'TotalSDescto',
           (100-(sum(venda)/sum(orcado))*100)          as 'Desconto' 
     into #Resumo1  
     from 
        #Calculo_Comissao a

     Group by a.ordem
     Order by a.ordem

     select * into #resumo2
     from #resumo1

     --Atualiza a tabela de movimento de comissões - Categoria

     declare @cd_categoria_produto     char(10)
     declare @cd_categoria_localizada  char(10)

     set @cd_categoria_produto     = ' '
     set @vl_comissionavel         = 0
     set @vl_comissao              = 0
     set @vl_comissao_sem_desconto = 0
     set @pc_desconto              = 0
           
     while exists ( select * from #Resumo1 )
     begin

       select @cd_categoria_produto     = Sigla,
              @vl_comissionavel         = Faturamento,
              @vl_comissao              = TotalComissao,
              @vl_comissao_sem_desconto = TotalSDescto,
              @pc_desconto              = Desconto
       from #Resumo1

       -- Verifica se a categoria e a data base da comissão estão cadastrados 
   
       select @cd_categoria_localizada = cd_categoria_produto
       from 
          sapsql.dbo.Resumo_Comissao_Categoria
       where 
          cd_categoria_produto = @cd_categoria_produto and 
          dt_base_comissao = @dt_final 

       -- Insere registro novo de cálculo

       if @@rowcount = 0 
          begin

             insert sapsql.dbo.Resumo_Comissao_Categoria values ( @cd_categoria_produto,@dt_final,@vl_comissao,@vl_comissao_sem_desconto,@pc_desconto,null,getdate())

          end

       else

          begin
             -- Total Comissão no Arquivo de Comissões
             update sapsql.dbo.Resumo_Comissao_Categoria
             set 
               vl_comissao = @vl_comissao
             where
               @cd_categoria_produto = cd_categoria_produto and
               @dt_final    = dt_base_comissao 

             -- Total Comissão sem Desconto no Arquivo de Comissões
             update sapsql.dbo.Resumo_Comissao_Categoria
             set 
               vl_comissao_sem_desconto = @vl_comissao_sem_desconto
             where
               @cd_categoria_produto = cd_categoria_produto and
               @dt_final    = dt_base_comissao 

             -- Total de Percentuais aplicados no cálculo no Arquivo de Comissões
             update sapsql.dbo.Resumo_Comissao_Categoria
             set 
               pc_desconto = @pc_desconto
             where
               @cd_categoria_produto = cd_categoria_produto and
               @dt_final    = dt_base_comissao 

             -- Data do Novo Cálculo no Arquivo de Comissões
             update sapsql.dbo.Resumo_Comissao_Categoria
             set 
               dt_calculo = getdate()
             where
               @cd_categoria_produto = cd_categoria_produto and
               @dt_final    = dt_base_comissao 
 
          end
             
          -- Deletar o registro atualizado

          delete #Resumo1
          where
            sigla = @cd_categoria_localizada 
                   
     end

     select * from #resumo2

   end

if @ic_parametro_calculo = 2  --Resumo das comissões por vendedor/setor
   begin
     select b.Fan_Ven                          as 'Setor',
            max(b.cod_ven)                     as 'Codigo',
            sum(a.orcado)                      as 'TotalOrcado',
            sum(a.qtd)-sum( 2*a.qtdevolucao)   as 'TotalQtd',  
            sum(a.devolucaomes)+sum(a.devolucaomesant) as 'TotalDevolucao',
            sum(a.venda)                       as 'Faturamento',  
            sum(a.comissao)                    as 'TotalComissao',
            sum(a.sdescto)                     as 'TotalSDescto'
     from 
        #Calculo_Comissao a, FtVend b
     where 
        a.representante between @ic_tipo_vendedor_inicial and @ic_tipo_vendedor_final and
        a.Setor = b.Cod_Ven 

     Group by b.Fan_Ven
     Order by b.Fan_Ven
   end

if @ic_parametro_calculo = 3 --Resumo das comissões por categoria (Agrupado por Setor e Categoria)
   begin
     select a.Setor,
            a.Ordem,
            Max(a.Categoria)                   as 'Categoria',                                 
            Max(a.Sigla)                       as 'Sigla', 
            sum(a.orcado)                      as 'TotalOrcado',
            sum(a.qtd)-sum( 2*a.qtdevolucao)   as 'TotalQtd',  
            sum(a.devolucaomes)+sum(a.devolucaomesant) as 'TotalDevolucao',
            sum(a.venda)                       as 'Faturamento',  
            sum(a.comissao)                    as 'TotalComissao',
            sum(a.sdescto)                     as 'TotalSDescto'
     from 
        #Calculo_Comissao a
     where
        a.representante between @ic_tipo_vendedor_inicial and @ic_tipo_vendedor_final

     Group by a.Setor, a.ordem
     Order by a.Setor, a.ordem

   end

if @ic_parametro_calculo = 4  --Cálculo da Comissão Analítica por Categoria
begin
   select * 
   from 
      #Calculo_Comissao 
   where
      representante between @ic_tipo_vendedor_inicial and @ic_tipo_vendedor_final
   order by 
      ordem,devolvido,datanota,nota
end

if @ic_parametro_calculo = 5 --Resumo das comissões por categoria (Agrupado pela Categoria)
   begin
     select a.Ordem,
            Max(a.Categoria)                   as 'Categoria',                                 
            Max(a.Sigla)                       as 'Sigla', 
            sum(a.orcado)                      as 'TotalOrcado',
            sum(a.qtd)-sum( 2*a.qtdevolucao)   as 'TotalQtd',  
            sum(a.devolucaomes)+sum(a.devolucaomesant) as 'TotalDevolucao',
            sum(a.venda)                       as 'Faturamento',  
            sum(a.comissao)                    as 'TotalComissao',
            sum(a.sdescto)                     as 'TotalSDescto'
     from 
        #Calculo_Comissao a
     where
        a.representante between @ic_tipo_vendedor_inicial and @ic_tipo_vendedor_final
     Group by a.ordem
     Order by a.ordem

   end

--
-- Somente Resumos Anuais de Categorias por Vendedor
--

if @ic_parametro_calculo = 6 -- Valor Bruto da Comissão
   begin
     select a.Categoria,
            month(a.datanota)                  as 'Mes',
            Max(a.sigla)                       as 'Sigla',
            sum(a.comissao)                    as 'TotalComissao',
            sum(a.sdescto)                     as 'TotalSDescto'
     into #CalculoBruto
     from 
        #Calculo_Comissao a

     Group by a.Categoria, month(a.datanota)
     Order by a.Categoria, month(a.datanota)

     select a.Categoria,
            Max(a.Sigla) as 'Sigla', 
            sum( case a.mes when 1  then a.totalcomissao else 0 end ) as 'Jan',
            sum( case a.mes when 2  then a.totalcomissao else 0 end ) as 'Fev',
            sum( case a.mes when 3  then a.totalcomissao else 0 end ) as 'Mar',
            sum( case a.mes when 4  then a.totalcomissao else 0 end ) as 'Abr',
            sum( case a.mes when 5  then a.totalcomissao else 0 end ) as 'Mai',
            sum( case a.mes when 6  then a.totalcomissao else 0 end ) as 'Jun',
            sum( case a.mes when 7  then a.totalcomissao else 0 end ) as 'Jul',
            sum( case a.mes when 8  then a.totalcomissao else 0 end ) as 'Ago',
            sum( case a.mes when 9  then a.totalcomissao else 0 end ) as 'Set',
            sum( case a.mes when 10 then a.totalcomissao else 0 end ) as 'Out',
            sum( case a.mes when 11 then a.totalcomissao else 0 end ) as 'Nov',
            sum( case a.mes when 12 then a.totalcomissao else 0 end ) as 'Dez',
            sum(a.totalcomissao) as 'TotalGeral'
     from #CalculoBruto a
     group by a.Categoria
     order by a.Categoria

   end
/*
if @ic_parametro_calculo = 7 -- Valor Sem Desconto da Comissão
   begin
     select a.cd_categoria_produto             as 'Sigla',
            month(a.dt_base_comissao)          as 'Mes',        
            sum(a.vl_comissao_sem_desconto)    as 'TotalComissao' 
     into #Calculo_Comissao4
     from 
        Resumo_Comissao_Categoria a
     where 
        Year(a.dt_base_comissao) = @ano 

     Group by a.cd_categoria_produto, month(a.dt_base_comissao)
     Order by a.cd_categoria_produto, month(a.dt_base_comissao)

     select a.Sigla,
            @Setor as 'Setor',
            sum( case a.mes when 1  then a.totalcomissao else 0 end ) as 'Jan',
            sum( case a.mes when 2  then a.totalcomissao else 0 end ) as 'Fev',
            sum( case a.mes when 3  then a.totalcomissao else 0 end ) as 'Mar',
            sum( case a.mes when 4  then a.totalcomissao else 0 end ) as 'Abr',
            sum( case a.mes when 5  then a.totalcomissao else 0 end ) as 'Mai',
            sum( case a.mes when 6  then a.totalcomissao else 0 end ) as 'Jun',
            sum( case a.mes when 7  then a.totalcomissao else 0 end ) as 'Jul',
            sum( case a.mes when 8  then a.totalcomissao else 0 end ) as 'Ago',
            sum( case a.mes when 9  then a.totalcomissao else 0 end ) as 'Set',
            sum( case a.mes when 10 then a.totalcomissao else 0 end ) as 'Out',
            sum( case a.mes when 11 then a.totalcomissao else 0 end ) as 'Nov',
            sum( case a.mes when 12 then a.totalcomissao else 0 end ) as 'Dez',
            sum(a.totalcomissao) as 'TotalGeral'
     from #Calculo_Comissao4 a
     group by a.sigla
     order by a.Sigla

   end

if @ic_parametro_calculo = 8 -- Percentuais de Desconto da Comissão
   begin
     select a.cd_categoria_produto             as 'Sigla',
            month(a.dt_base_comissao)          as 'Mes',        
            avg(a.pc_desconto)                 as 'PercDesconto'
     into #Calculo_Comissao5
     from 
        Resumo_Comissao_Categoria a
     where 
        Year(a.dt_base_comissao) = @ano 

     Group by a.cd_categoria_produto, month(a.dt_base_comissao)
     Order by a.cd_categoria_produto, month(a.dt_base_comissao)

     select a.Sigla,
            @Setor as 'Setor',
            avg( case a.mes when 1  then a.PercDesconto else 0 end ) as 'Jan',
            avg( case a.mes when 2  then a.PercDesconto else 0 end ) as 'Fev',
            avg( case a.mes when 3  then a.PercDesconto else 0 end ) as 'Mar',
            avg( case a.mes when 4  then a.PercDesconto else 0 end ) as 'Abr',
            avg( case a.mes when 5  then a.PercDesconto else 0 end ) as 'Mai',
            avg( case a.mes when 6  then a.PercDesconto else 0 end ) as 'Jun',
            avg( case a.mes when 7  then a.PercDesconto else 0 end ) as 'Jul',
            avg( case a.mes when 8  then a.PercDesconto else 0 end ) as 'Ago',
            avg( case a.mes when 9  then a.PercDesconto else 0 end ) as 'Set',
            avg( case a.mes when 10 then a.PercDesconto else 0 end ) as 'Out',
            avg( case a.mes when 11 then a.PercDesconto else 0 end ) as 'Nov',
            avg( case a.mes when 12 then a.PercDesconto else 0 end ) as 'Dez',
            avg( a.PercDesconto ) as 'TotalGeral'
     from #Calculo_Comissao5 a
     group by a.sigla
     order by a.Sigla

   end
end
*/


