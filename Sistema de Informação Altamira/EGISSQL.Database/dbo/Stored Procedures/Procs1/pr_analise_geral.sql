
CREATE PROCEDURE pr_analise_geral
  @dt_inicial datetime,
  @dt_final   datetime,
  @cd_rede   int,
  @cd_bandeira int,
  @cd_loja     int,
--@cd_estado int,
--@cd_cidade int,
  @cd_regiao int ,
  @cd_categoria_produto int,
--@nm_marca varchar(30),
  @cd_produto int 

AS

SELECT 
   r.nm_rede_loja                          as 'rede',
   b.nm_bandeira_loja                      as 'bandeira',
   l.nm_loja_coleta                        as 'loja',
   rc.nm_regiao_coleta                     as 'regiao',
   cp.nm_categoria_produto                 as 'categoria',
   p.nm_produto                            as 'produto',
   p.nm_marca_produto                      as 'marca',
   isnull(max(vl_item_coleta),0)           as 'preco max',
   isnull(min(vl_item_coleta),0)           as 'preco min',
   isnull(sum(ci.qt_frente_item_coleta),0) as 'frentes',
   isnull(sum(ci.qt_chstand_item_coleta),0) as 'checkstand'
into #frente 
from
   produto p,     
   categoria_produto cp,
   coleta c,
   coleta_item ci,
   rede_loja   r,
   bandeira_loja b,
   loja_coleta   l,
   regiao_coleta rc 
where 
  p.cd_agrupamento_produto=1                        and
  p.cd_categoria_produto = cp.cd_categoria_produto  and
  c.dt_coleta between @dt_inicial and @dt_final    and
  c.cd_loja_coleta = l.cd_loja_coleta            and
  l.cd_bandeira_loja = b.cd_bandeira_loja       and
  b.cd_rede_loja     = r.cd_rede_loja           and
  c.cd_coleta         = ci.cd_coleta              and
  p.cd_produto         = ci.cd_produto             and
  r.cd_rede_loja     =@cd_rede                    and
  b.cd_bandeira_loja =@cd_bandeira and
  l.cd_loja_coleta  =@cd_loja and
  rc.cd_regiao_coleta = @cd_regiao and
  cp.cd_categoria_produto = @cd_categoria_produto and
  p.cd_produto = @cd_produto

group by
   r.nm_rede_loja,
   b.nm_bandeira_loja,
   l.nm_loja_coleta,
   rc.nm_regiao_coleta,
   cp.nm_categoria_produto,
   p.nm_produto,
   p.nm_marca_produto


declare @vl_total_frente float
set @vl_total_frente = 0

declare @vl_total_stand float
set @vl_total_stand = 0

select @vl_total_frente =  @vl_total_frente + frentes,
       @vl_total_stand =  @vl_total_stand + checkstand
from #frente

select *,(frentes/@vl_total_frente)*100 as '%frente',
         (checkstand/@vl_total_stand)*100 as '%checkstand'
 
from #frente




