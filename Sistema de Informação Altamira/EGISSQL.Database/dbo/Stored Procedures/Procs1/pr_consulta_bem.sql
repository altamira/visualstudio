
CREATE PROCEDURE pr_consulta_bem
----------------------------------------------------------------
--pr_consulta_bem
----------------------------------------------------------------
--GBS - Global Business Solution Ltda                       2004
----------------------------------------------------------------
--Stored Procedure     : Microsoft SQL Server 2000
--Autor(es)            : Alexandre Del Soldato
--Banco de Dados       : SQL 
--Objetivo             : Consulta de Bem do Ativo Fixo (SAF)
--Data                 : 26/02/2004
--Atualizado           : 30/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                       11/11/2006 - Correção na pesquisa que não puxava registros. Anderson
--                       24/01/2007 - Correção da pesquisa por patrimônio. Anderson
---------------------------------------------------------------------------
  @dt_inicial       datetime    = 0,
  @dt_final         datetime    = 0,
  @nm_mascara       varchar(40) = '',
  @cd_departamento  int         = 0,
  @cd_patrimonio    varchar(40) = '',
  @cd_centro_custo  int         = 0,
  @cd_seguradora    int         = 0,
  @cd_apolice       int         = 0,
  @cd_fornecedor    int         = 0,
  @cd_nota_fiscal   int         = 0,
  @cd_serie_nf      int         = 0,
  @nm_descricao     varchar(40) = '',
  @cd_grupo_bem     int         = 0,
  @cd_plano_conta   int         = 0
as

begin
  SELECT
    b.cd_bem,
    b.nm_mascara_bem,
    b.cd_patrimonio_bem,
    b.nm_bem,
    sb.cd_status_bem,
    sb.nm_status_bem,
    b.dt_aquisicao_bem,
    vb.vl_original_bem,
    f.nm_fantasia_fornecedor,
    nei.cd_nota_entrada,
    nei.cd_serie_nota_fiscal,
    nei.cd_item_nota_entrada,
    cc.cd_centro_custo,
    cc.nm_centro_custo,
    d.cd_departamento,
    d.nm_departamento,
    vb.cd_moeda,
    vm.vl_moeda, 
    (vb.vl_original_bem / vm.vl_moeda) AS vl_total,
    gb.cd_grupo_bem,
    gb.nm_grupo_bem
  FROM
    Bem b
    LEFT OUTER JOIN Valor_Bem vb          ON b.cd_bem               = vb.cd_bem 
    LEFT OUTER JOIN Fornecedor f          ON b.cd_fornecedor        = f.cd_fornecedor
    LEFT OUTER JOIN Nota_Entrada_item nei ON b.cd_nota_entrada      = nei.cd_nota_entrada and
                                             b.cd_item_nota_entrada = nei.cd_item_nota_entrada
    LEFT OUTER JOIN Centro_Custo cc       ON b.cd_centro_custo      = cc.cd_centro_custo
    LEFT OUTER JOIN Departamento d        ON b.cd_departamento      = d.cd_departamento
    LEFT OUTER JOIN Status_Bem sb         ON b.cd_status_bem        = sb.cd_status_bem
    LEFT OUTER JOIN Apolice_Seguro aps    ON b.cd_apolice_seguro    = aps.cd_apolice_seguro
    LEFT OUTER JOIN Parametro_Ativo pa    ON vb.cd_moeda            = pa.cd_moeda
    LEFT OUTER JOIN Valor_Moeda vm        ON pa.cd_moeda            = vm.cd_moeda
    LEFT OUTER JOIN Grupo_Bem gb          ON gb.cd_grupo_bem        = b.cd_grupo_bem
    LEFT OUTER JOIN Plano_Conta pc        ON pc.cd_conta            = b.cd_plano_conta
  Where
    ((isnull( @dt_inicial, 0 ) = 0) or (b.dt_aquisicao_bem between @dt_inicial and @dt_final)) and
    ((isnull(@nm_mascara,'')= '')   or (RTrim(LTrim(b.nm_mascara_bem)) = RTrim(LTrim(@nm_mascara)) )) and
    ((isnull(@nm_descricao,'')= '') or (RTrim(LTrim(b.nm_bem)) like RTrim(LTrim(@nm_descricao)) +'%' )) and
    ((@cd_departamento = 0)         or (b.cd_departamento = @cd_departamento)) and
    ((isnull(@cd_patrimonio,'')='') or (RTrim(LTrim(b.cd_patrimonio_bem)) like RTrim(LTrim(@cd_patrimonio)) +'%' )) and
    ((@cd_centro_custo = 0)         or (b.cd_centro_custo = @cd_centro_custo)) and
    ((@cd_seguradora = 0)           or (aps.cd_seguradora = @cd_seguradora)) and
    ((@cd_apolice = 0)              or (b.cd_apolice_seguro = @cd_apolice)) and
    ((@cd_fornecedor = 0)           or (b.cd_fornecedor = @cd_fornecedor)) and
    ((@cd_nota_fiscal = 0)          or (b.cd_nota_entrada = @cd_nota_fiscal)) and
    ((@cd_serie_nf = 0)             or (b.cd_item_nota_entrada = @cd_serie_nf)) and
    ((@cd_grupo_bem = 0)            or (b.cd_grupo_bem = @cd_grupo_bem)) and
    ((@cd_plano_conta = 0)          or (b.cd_plano_conta = @cd_plano_conta))
  Order by b.nm_bem
end


