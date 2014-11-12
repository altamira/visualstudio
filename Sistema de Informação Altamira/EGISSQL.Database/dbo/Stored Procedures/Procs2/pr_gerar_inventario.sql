
CREATE PROCEDURE pr_gerar_inventario
  @ic_parametro             int,
  @cd_fase_produto          int,
  @cd_grupo_produto         int,
  @ic_peps_produto          Varchar(1),
  @cd_usuario               int

AS

---------------------------------------------
if @ic_parametro = 1 -- Consulta O Inventário
----------------------------------------------
begin

SELECT     Produto.nm_fantasia_produto AS Produto, Fase_Produto.nm_fase_produto AS Fase, Produto_Saldo.qt_saldo_atual_produto AS Saldo, 
                      Produto_Saldo.dt_ultima_entrada_produto AS Ultima_Entrada, Produto_Saldo.dt_ultima_saida_produto AS Ultima_Saida, 
                      Produto_Custo.vl_custo_produto AS Custo, Grupo_Produto.nm_grupo_produto AS Grupo_Produto
FROM         Produto_Saldo left outer join
                      Produto ON Produto_Saldo.cd_produto = Produto.cd_produto INNER JOIN
                      Fase_Produto ON Produto_Saldo.cd_fase_produto = Fase_Produto.cd_fase_produto INNER JOIN
                      Produto_Custo ON Produto_Saldo.cd_produto = Produto_Custo.cd_produto INNER JOIN
                      Grupo_Produto ON Produto.cd_grupo_produto = Grupo_Produto.cd_grupo_produto	

WHERE     IsNull(Produto_Saldo.qt_saldo_atual_produto,0) > 0                                    and
          ( ( Produto_Saldo.cd_fase_produto = @cd_fase_produto )  or ( @cd_fase_produto = 0 ) ) and
	  ( ( Produto_Custo.ic_peps_produto = 'S' ) or ( @ic_peps_produto = 'N' ) )             and
	  ( ( Produto.cd_grupo_produto = @cd_grupo_produto ) or ( @cd_grupo_produto = 0 ) )
Order by
   Produto.nm_fantasia_produto, Fase_Produto.nm_fase_produto, Grupo_produto.nm_grupo_produto

end

--------------------------------------------------------
if @ic_parametro = 2 -- Gera Inventario e Composição do Mesmo.
--------------------------------------------------------
begin

declare @Chave Int
Declare @tabela varchar(100)
set @Tabela = DB_NAME()+'.dbo.Inventario'

exec EgisADMIN.dbo.sp_PegaCodigo @tabela, 'cd_inventario', @codigo = @Chave output
--sp_help Inventario_COmposicao
select IsNull(@Chave,1) as cd_inventario,
       IDENTITY(int, 1,1) as cd_item_inventario,
       0 as cd_controle_inventario,
       1 as 'cd_planta', -- Não foi definida a Planta!
       1 as 'cd_local_inventario', -- Não foi definido o Local de Inventario!
       ps.cd_produto,
       ps.cd_fase_produto,
       p.nm_produto as nm_produto_inventario,
       p.cd_unidade_medida,
       ps.qt_saldo_atual_produto,
       ps.qt_consig_produto as 'qt_consig_inventario',
       0 as 'qt_1cont_item_inventario',
       GetDate() as 'dt_usuario',
       @cd_usuario as 'cd_usuario',
       'N' as 'ic_etiq_item_inventario',
       'N' as 'ic_relat_item_inventario',
       0 as 'qt_3cont_item_inventario',
       0 as 'qt_2cont_item_inventario'

--       IsNull(Produto_Custo.vl_custo_produto,0) as 'vl_custo'
       

into #Inventario_Composicao 

FROM  Produto_Saldo ps left outer join
      Produto p ON ps.cd_produto = p.cd_produto INNER JOIN
      Fase_Produto ON ps.cd_fase_produto = Fase_Produto.cd_fase_produto INNER JOIN
      Produto_Custo ON ps.cd_produto = Produto_Custo.cd_produto INNER JOIN
      Grupo_Produto ON p.cd_grupo_produto = Grupo_Produto.cd_grupo_produto	

WHERE     IsNull(ps.qt_saldo_atual_produto,0) > 0                                    and
          ( ( ps.cd_fase_produto = @cd_fase_produto )  or ( @cd_fase_produto = 0 ) ) and
	  ( ( Produto_Custo.ic_peps_produto = 'S' ) or ( @ic_peps_produto = 'N' ) )             and
	  ( ( p.cd_grupo_produto = @cd_grupo_produto ) or ( @cd_grupo_produto = 0 ) )

select * from #Inventario_Composicao
declare @registros int, @vl_total float
set @registros = ( select count(*) from #Inventario_Composicao )
set @vl_total = ( select sum(Produto_Custo.vl_custo_produto) from 
                                                       Produto_Saldo ps left outer join
                                                       Produto p ON ps.cd_produto = p.cd_produto INNER JOIN
                                                       Fase_Produto ON ps.cd_fase_produto = Fase_Produto.cd_fase_produto INNER JOIN
                                                       Produto_Custo ON ps.cd_produto = Produto_Custo.cd_produto INNER JOIN
                                                       Grupo_Produto ON p.cd_grupo_produto = Grupo_Produto.cd_grupo_produto	
                                                  WHERE     
                                                       IsNull(ps.qt_saldo_atual_produto,0) > 0                                               and
                                                       ( ( ps.cd_fase_produto = @cd_fase_produto )  or ( @cd_fase_produto = 0 ) )            and
                                                       ( ( Produto_Custo.ic_peps_produto = 'S' ) or ( @ic_peps_produto = 'N' ) )             and
                                                       ( ( p.cd_grupo_produto = @cd_grupo_produto ) or ( @cd_grupo_produto = 0 ) ) )

print ( 'Chave: ' + cast( @Chave as varchar(20) ) )
  insert into Inventario
  select 
      @Chave,
      GetDate(),
      'Geração Automática!',
      1, -- Ainda não foi definido um Tipo!
      @registros,
      @vl_total,
      @cd_usuario,
      GetDate() 

 insert into Inventario_Composicao 
 select * 
 from #Inventario_Composicao

exec EgisADMIN.dbo.sp_LiberaCodigo @tabela, @Chave, 'D'

drop table #Inventario_Composicao

end



