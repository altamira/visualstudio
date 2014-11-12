
CREATE PROCEDURE pr_aquisicao_bem
----------------------------------------------------------------------
--pr_aquisicao_bem
----------------------------------------------------------------------
--GBS - Global Business Solution Ltda                             2004
----------------------------------------------------------------------
--Stored Procedure            : Microsoft SQL Server 2000
--Autor(es)                   : Alexandre Del Soldato
--Banco de Dados              : SQL 
--Objetivo                    : Aquisição do Bem (SAF)
--Data                        : 03/03/2004
--Atualizado                  : Acerto do Cabeçalho - Sérgio Cardoso
----------------------------------------------------------------------

  @dt_inicial 			datetime,
  @dt_final 			datetime,
  @cd_patrimonio                varchar(40) = '',
  @cd_bem                       int         = 0,
  @nm_bem                       varchar(40) = ''

as

begin

  SELECT
    case when (b.cd_patrimonio_bem is null)    then 'N' else 'S' end as 'SemIdentificacao',
    case when (b.cd_apolice_seguro is null)    then 'N' else 'S' end as 'Seguro',
    case when (b.dt_garantia_bem >= getdate()) then 'S' else 'N' end as 'Garantia',
    b.cd_patrimonio_bem      as 'CodigoPatrimonio',
    gb.nm_grupo_bem          as 'Grupo',
    b.cd_bem                 as 'CodigoBem',
    b.nm_bem                 as 'Descricao',
    b.dt_aquisicao_bem       as 'DataAquisicao',
    sb.nm_status_bem         as 'Status',
    d.nm_departamento        as 'Departamento',
    cc.nm_centro_custo       as 'CentroCusto',
    f.nm_fantasia_fornecedor as 'Fornecedor',
    nei.cd_nota_entrada      as 'Nota',
    nei.cd_serie_nota_fiscal as 'Item',
    b.dt_aquisicao_bem,
    b.dt_inicio_uso_bem,
    b.dt_garantia_bem,
    b.cd_fornecedor,
    f.nm_razao_social,
    b.cd_nota_entrada,
    b.cd_serie_nota_fiscal,
    b.cd_item_nota_entrada,
    b.qt_item_nota_entrada,
    b.cd_operacao_fiscal,
    b.qt_bem    
  FROM
    Bem b
    LEFT OUTER JOIN Centro_Custo cc       on b.cd_centro_custo = cc.cd_centro_custo
    LEFT OUTER JOIN Departamento d        on b.cd_departamento = d.cd_departamento
    LEFT OUTER JOIN Fornecedor f          on b.cd_fornecedor   = f.cd_fornecedor
    LEFT OUTER JOIN Status_Bem sb         on b.cd_status_bem   = sb.cd_status_bem
    LEFT OUTER JOIN Nota_Entrada_item nei on b.cd_nota_entrada = nei.cd_nota_entrada and
                                             b.cd_item_nota_entrada = nei.cd_item_nota_entrada
    LEFT OUTER JOIN Grupo_Bem gb          on b.cd_grupo_bem         = gb.cd_grupo_bem
  Where
    (( isnull(@nm_bem,'')= '') or ( RTrim(LTrim(b.nm_bem)) like RTrim(LTrim(@nm_bem))+'%' )) and
    (( isnull(@cd_patrimonio,'')='') or ( b.cd_patrimonio_bem like RTrim(LTrim(@cd_patrimonio))+'%' )) and
    (( isnull(@cd_bem,0)=0) or ( b.cd_bem = @cd_bem ))    
  Order by 
    b.dt_aquisicao_bem,
    b.cd_patrimonio_bem
end

