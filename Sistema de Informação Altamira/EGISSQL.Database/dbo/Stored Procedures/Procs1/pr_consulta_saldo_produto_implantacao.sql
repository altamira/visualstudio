
CREATE PROCEDURE pr_consulta_saldo_produto_implantacao
   @dt_base datetime,
   @cd_grupo int,
   @cd_fase int
AS
   SELECT c.cd_fase_produto, b.nm_fase_produto, g.nm_fantasia_grupo_produto,
          a.cd_mascara_produto, a.nm_fantasia_produto,
          a.nm_produto, d.sg_unidade_medida,
          IsNull(c.qt_atual_prod_fechamento, 0) as qt_atual_prod_fechamento,
          IsNull(e.qt_saldo_reserva_produto, 0) as qt_saldo_reserva_produto,
          IsNull(e.qt_saldo_atual_produto, 0) as qt_saldo_atual_produto
   FROM produto a
      INNER JOIN grupo_produto g on
      a.cd_grupo_produto = g.cd_grupo_produto

      LEFT OUTER JOIN produto_fechamento c on
      a.cd_produto = c.cd_produto

      INNER JOIN fase_produto b on
      c.cd_fase_produto = b.cd_fase_produto

      LEFT OUTER JOIN produto_saldo e on
      c.cd_produto = e.cd_produto
      AND c.cd_fase_produto = e.cd_fase_produto

      LEFT OUTER JOIN unidade_medida d on
      a.cd_unidade_medida = d.cd_unidade_medida

   WHERE IsNull(c.dt_produto_fechamento, @dt_base) = @dt_base
         AND (a.cd_grupo_produto = 0 OR a.cd_grupo_produto = @cd_grupo)
         AND (c.cd_fase_produto = 0 OR c.cd_fase_produto = @cd_fase)

   ORDER BY a.cd_grupo_produto,
            a.cd_mascara_produto,
            b.cd_fase_produto


