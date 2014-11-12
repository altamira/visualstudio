
CREATE PROCEDURE pr_bem_seguradora
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Alexandre Del Soldato
--Banco de Dados: SQL 
--Objetivo      : Consulta de Bens por Seguradora (SAF2003)
--Data          : 10/03/2004
--Atualizado    : 
----------------------------------------------------------------------

  @cd_seguradora              int

as

begin

  SELECT
    sg.nm_seguradora            as 'Seguradora',
    aps.cd_apolice_seguro       as 'N_apolice',
    gb.nm_grupo_bem             as 'Grupo',
    b.cd_bem                    as 'Codigo',
    aps.cd_ident_apolice_seguro as 'Identificacao',
    b.nm_bem                    as 'Descricao', 
    b.nm_marca_bem              as 'Marca',
    b.nm_modelo_bem             as 'Modelo',
    b.dt_aquisicao_bem          as 'Aquisicao',
    aps.vl_apolice_seguro       as 'Valor',
    f.nm_fantasia_fornecedor    as 'Fornecedor',
    nei.cd_nota_entrada         as 'Nota',
    nei.cd_serie_nota_fiscal    as 'Serie',
    nei.cd_item_nota_entrada    as 'Item'
  FROM
    Seguradora sg
    LEFT OUTER JOIN
      Apolice_Seguro aps
      ON sg.cd_seguradora = aps.cd_seguradora
    LEFT OUTER JOIN
      Bem b
      ON aps.cd_apolice_seguro = b.cd_apolice_seguro
    LEFT OUTER JOIN
      Grupo_Bem gb
      ON b.cd_grupo_bem = gb.cd_grupo_bem 
    LEFT OUTER JOIN
      Fornecedor f
      ON b.cd_fornecedor = f.cd_fornecedor
    LEFT OUTER JOIN
      Nota_Entrada_item nei
      ON b.cd_nota_entrada = nei.cd_nota_entrada and
         b.cd_item_nota_entrada = nei.cd_item_nota_entrada
  Where
    ((@cd_seguradora = 0) or (sg.cd_seguradora = @cd_seguradora))

  Order by sg.nm_seguradora

end


