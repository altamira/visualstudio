

--pr_mapa_faturamento_analitico
--------------------------------------------------------------------------------------
--Polimold Industrial S/A                                                             2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes 
--Mapa de Faturamento
--Data          : 06.09.2000
--Atualizado    : 06.09.2000
--              : 09.10.2000 - Mapa de Faturamento Analítico por Categoria
--              : 17.10.2000 - Devolução do Mês Anterior
--------------------------------------------------------------------------------------

CREATE procedure pr_mapa_faturamento_analitico
@cd_categoria_inicial  char(10),
@cd_categoria_final    char(10),
@dt_inicial            datetime,    --Data Inicial
@dt_final              datetime,    --Data Final
-- Se seleciona devoluções de meses anteriores
@ic_meses_anteriores   char(1)
as

declare @vl_zero float
set @vl_zero = 0

select
    c.ncmapa              as 'categoria',
    c.fatsmoit            as 'smo',
    b.datanf              as 'data',
    b.nf                  as 'nota',
    d.fan_cli             as 'cliente',
    d.vdext02             as 'vendedor',
    d.destin              as 'destinacao',
    d.dtped               as 'datapedido',
    c.pedidoit            as 'pedido',
    c.item                as 'item',
    c.descricao           as 'descricao',
    b.cod_item            as 'codprod',
    c.cod_ant             as 'codantprod',
    c.qt                  as 'qtd',
   (c.qt * c.preco)       as 'venda',
    -- Se houver valor no ICMSDESC (Percentual Venda Manaus), retira
    case when isnull(b.icmsdesc,0) = 0 then (b.qt*b.preco) else
       (b.qt*b.preco)-((b.qt*b.preco)*b.icmsdesc/100) end as 'faturado',
    b.vlrcont             as 'contabil',
    b.vipi                as 'ipi',
    b.vicm                as 'icms',
    b.vfrete              as 'frete',
    b.vdespac             as 'despacessoria',
    b.vseguro             as 'seguro',
    devolucao = @vl_zero,
    'F'                   as 'status'
 
into #MapaFatAnalitico    
from
    CADNF a, CADINF b, CADIPED c, CADPED d,FTOPER e
Where
  (a.datanf     between @dt_inicial   and @dt_final ) and
   a.codno     = e.codigo                             and
   e.comercial = 'S'                                  and
   a.outroper < 2                                     and
   a.vlrtotnf > 0                                     and 
   a.nf = b.nf                                        and
   isnull(b.tpstatus,' ') <> 'C'                      and
  ( b.dtcanc is null or b.dtcanc>@dt_final )          and
   b.qt*b.preco > 0                                   and
   b.pedido = d.pedido                                and
   d.pedido = c.pedidoit                              and
   b.item = c.item                                    and
  (c.ncmapa between @cd_categoria_inicial and 
                    @cd_categoria_final)              and 
   c.item < 80                                        and
   c.fatsmoit = 'N'                           

order by c.ncmapa,b.datanf,b.nf 

--Devoluções do Mês e Meses Anteriores

select
    c.ncmapa              as 'categoria',
    c.fatsmoit            as 'smo',
    b.datanf              as 'data',
    b.nf                  as 'nota',
    d.fan_cli             as 'cliente',
    d.vdext02             as 'vendedor',
    d.destin              as 'destinacao',
    d.dtped               as 'datapedido',
    c.pedidoit            as 'pedido',
    c.item                as 'item',
    c.descricao           as 'descricao',
    b.cod_item            as 'codprod',
    c.cod_ant             as 'codantprod',
    c.qt                  as 'qtd',
   (c.qt * c.preco)       as 'venda',
    b.qt * b.preco        as 'faturado',
    b.vlrcont             as 'contabil',
    b.vipi                as 'ipi',
    b.vicm                as 'icms',
    b.vfrete              as 'frete',
    b.vdespac             as 'despacessoria',
    b.vseguro             as 'seguro',
    devolucao =
      case when
             isnull(b.qtdev,0)>0 then b.qtdev * b.preco             
           when
             isnull(b.qtdev,0)=0 then b.qt * b.preco       
           else @vl_zero
      end,
    status =
      case when
           b.datanf < @dt_inicial then 'A' 
                                  else 'M'
      end
  
into #MapaDevMes
from
    CADNF a, CADINF b, CADIPED c, CADPED d,FTOPER e
Where
   a.codno = e.codigo                                 and
   e.comercial = 'S'                                  and
   a.outroper < 2                                     and
   a.vlrtotnf > 0                                     and 
   a.nf = b.nf                                        and
  (b.dtcanc     between @dt_inicial   and @dt_final ) and
   b.tpstatus='D'                                     and
   b.qt*b.preco > 0                                   and
   b.pedido = d.pedido                                and
   d.pedido = c.pedidoit                              and
   b.item = c.item                                    and
  (c.ncmapa between @cd_categoria_inicial             and 
                    @cd_categoria_final)              and 
   c.item < 80                                        and
   c.fatsmoit = 'N'

order by c.ncmapa,b.datanf,b.nf 

-- Junção das 2 tabelas

insert 
into #MapaFatAnalitico
select * 
from #MapaDevMes

if @ic_meses_anteriores = 'N'  
begin
   select * 
   from #MapaFatAnalitico 
   where status <> 'A' -- A de meses anteriores
   order by categoria,data,nota
end
else
begin
   select *
   from #MapaFatAnalitico a
   order by categoria,data,nota
end

SELECT * from #MapaFatAnalitico WHERE faturado between 42 and 43


