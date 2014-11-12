
CREATE PROCEDURE pr_inventario_bem
----------------------------------------------------------------
--pr_inventario_bem
----------------------------------------------------------------
--GBS - Global Business Solution Ltda                       2004
----------------------------------------------------------------
--Stored Procedure     : Microsoft SQL Server 2000
--Autor(es)            : Alexandre Del Soldato
--Banco de Dados       : SQL 
--Objetivo             : Inventario de Bem do Ativo Fixo (SAF)
--Data                 : 26/02/2004
--Atualizado           : 30/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso 
--Atualizado           : 26/01/2007 - Correção da identação e adicao do nm_grupo_bem
---------------------------------------------------------------------------
@cd_departamento int

as
begin
  Select
    b.cd_bem,
    gb.nm_grupo_bem,
    b.nm_mascara_bem,
    b.cd_patrimonio_bem,
    b.nm_bem,
    b.nm_marca_bem,
    b.nm_modelo_bem,
    b.nm_serie_bem,
    sb.cd_status_bem,
    sb.nm_status_bem,
    b.dt_aquisicao_bem,
    vb.vl_original_bem,
    f.nm_fantasia_fornecedor,
    nei.cd_nota_entrada,
    nei.cd_serie_nota_fiscal,
    nei.cd_item_nota_entrada,
    lb.cd_localizacao_bem,
    lb.nm_localizacao_bem,
    cc.cd_centro_custo,
    cc.nm_centro_custo,
    d.cd_departamento,
    d.nm_departamento,
    vb.cd_moeda,
    vm.vl_moeda, 
    (vm.vl_moeda * vb.vl_original_bem) AS vl_total
  from
    Bem b 
    left outer join Valor_Bem vb          on b.cd_bem = vb.cd_bem
    left outer join Fornecedor f          on b.cd_fornecedor = f.cd_fornecedor
    left outer join Nota_Entrada_item nei on b.cd_nota_entrada = nei.cd_nota_entrada and
                                             b.cd_item_nota_entrada = nei.cd_item_nota_entrada
    left outer join Centro_Custo cc       on b.cd_centro_custo = cc.cd_centro_custo
    left outer join Departamento d        on b.cd_departamento = d.cd_departamento
    left outer join Localizacao_bem lb    on b.cd_localizacao_bem = lb.cd_localizacao_bem
    left outer join Status_Bem sb         on b.cd_status_bem = sb.cd_status_bem
    left outer join Apolice_Seguro aps    on b.cd_apolice_seguro = aps.cd_apolice_seguro
    left outer join Parametro_Ativo pa    on vb.cd_moeda = pa.cd_moeda
    left outer join Valor_Moeda vm        on pa.cd_moeda = vm.cd_moeda
    left outer join Grupo_Bem gb          on gb.cd_grupo_bem = b.cd_grupo_bem
  Where
    isnull(b.cd_departamento,0) = case when isnull(@cd_departamento,0)=0 then b.cd_departamento else isnull(@cd_departamento,0) end
  Order by 
    d.nm_departamento,
    b.nm_bem
end
