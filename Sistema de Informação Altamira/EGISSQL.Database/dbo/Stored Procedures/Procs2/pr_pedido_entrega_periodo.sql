

/****** Object:  Stored Procedure dbo.pr_pedido_entrega_periodo    Script Date: 13/12/2002 15:08:38 ******/

CREATE PROCEDURE pr_pedido_entrega_periodo

  @dt_inicial datetime,
  @dt_final   datetime

AS

  SELECT
    ns.cd_nota_saida,
    ns.dt_nota_saida,
    ns.dt_saida_nota_saida,
    ns.hr_saida_nota_saida,
    ns.cd_pedido_cliente,
    c.nm_fantasia_cliente,
    ns.vl_total, 
    cast(ns.ds_obs_compl_nota_saida as varchar(8000)) as ds_obs_compl_nota_saida,
    v.nm_fantasia_vendedor AS nm_fantasia_vendedor_interno,
    (SELECT x.nm_fantasia_vendedor FROM Vendedor x WHERE x.cd_vendedor = c.cd_vendedor) AS nm_fantasia_vendedor_externo
  FROM
    Vendedor v RIGHT OUTER JOIN Cliente c
      ON v.cd_vendedor = c.cd_vendedor_interno
    RIGHT OUTER JOIN Nota_Saida ns 
      ON c.cd_cliente = ns.cd_cliente
  WHERE
    ns.dt_nota_saida between @dt_inicial and @dt_final and ns.dt_saida_nota_saida is not null
  ORDER BY
    c.nm_fantasia_cliente


