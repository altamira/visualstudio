
CREATE  procedure pr_fatura_fonte_informacao
-----------------------------------------------------------------------------------
--GBS - Global Business Solution                                               2006
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  
--Autor       : Carlos Cardoso Fernandes
--Objetivo    : Consulta de Faturamento por Fonte de Informação
--Criado      : 02.05.2006
--Atualização :
--
-----------------------------------------------------------------------------------
@cd_fonte_informacao int = 0,
@dt_inicial          datetime,
@dt_final            datetime,
@cd_moeda            int = 1

as

declare @vl_moeda float

set @vl_moeda = ( case when dbo.fn_vl_moeda(@cd_moeda) = 0 then 1
                  else dbo.fn_vl_moeda(@cd_moeda) end )

  -- Geração da tabela auxiliar de Setores por grupo

  Select 
    c.cd_fonte_informacao     as 'fonte', 
    sum(b.qt_item_nota_saida) as 'Qtd',
    sum(b.qt_item_nota_saida * b.vl_unitario_item_nota / @vl_moeda) as 'Venda', 
    max(a.dt_nota_saida)      as 'UltimaVenda',
    count(*)                  as 'pedidos'  
  Into 
    #FaturaSetorCategAux
  From
     Nota_Saida a 
     inner join Nota_Saida_Item b on a.cd_nota_saida = b.cd_nota_saida
     inner join cliente c         on c.cd_cliente    = a.cd_cliente
  Where
    (c.cd_fonte_informacao = case when @cd_fonte_informacao = 0 then c.cd_fonte_informacao else @cd_fonte_informacao end ) and
    (a.dt_nota_saida between @dt_inicial and @dt_final ) and
     a.dt_cancel_nota_saida is null    and  
     isnull(a.vl_total,0) > 0          and
     a.cd_status_nota <> 7             and
     a.cd_nota_saida = b.cd_nota_saida and     
    (b.qt_item_nota_saida * b.vl_unitario_item_nota / @vl_moeda) > 0 and
     b.dt_cancel_item_nota_saida is null   
  Group by 
    c.cd_fonte_informacao
  order by  
    c.cd_fonte_informacao

-------------------------------------------------
-- calculando Quantos Clientes no Período.
-------------------------------------------------
select distinct a.cd_cliente
into #QtdCliente
from
    Nota_Saida a 
    inner join Nota_Saida_item b on b.cd_nota_saida = a.cd_nota_saida
where
    (a.dt_nota_saida between @dt_inicial and @dt_final ) and
     a.dt_cancel_nota_saida is null    and  
     isnull(a.vl_total,0) > 0          and
     a.cd_status_nota <> 7             and
     a.cd_nota_saida = b.cd_nota_saida and     
    (b.qt_item_nota_saida * b.vl_unitario_item_nota / @vl_moeda) > 0 and
     b.dt_cancel_item_nota_saida is null   

select 
  b.cd_fonte_informacao, 
  count(*) as Clientes
into 
  #ClienteInformacao
from
  #QtdCliente a, Cliente b
where 
  a.cd_cliente = b.cd_cliente

group by b.cd_fonte_informacao


  declare @qt_total_categ int
  declare @vl_total_categ float
  
  -- Total de Setores
  set @qt_total_categ = @@rowcount
  
  -- Total de Vendas Geral por Setor
  set @vl_total_categ = 0
  select 
    @vl_total_categ = @vl_total_categ + venda
  from
    #FaturaSetorCategAux
  
  --Cria a Tabela Final de Vendas por Setor

  select 
    IDENTITY(int, 1,1)                                   as 'Posicao', 
    b.nm_fonte_informacao, 
    a.qtd,
    a.venda, 
    cast((a.venda/@vl_total_categ)*100 as Decimal(25,2)) as 'Perc',
    a.UltimaVenda,
    a.pedidos, 
    d.Clientes as 'Clientes'  
  Into 
    #FaturaSetorCateg
  from 
    #FaturaSetorCategAux a, Fonte_Informacao b, #ClienteInformacao d

  Where
     a.fonte = b.cd_fonte_informacao and
     a.fonte = d.cd_fonte_informacao
    
  Order by 
    a.venda desc
  
  --Mostra tabela ao usuário  

  select * from #FaturaSetorCateg
  order by posicao 

