
CREATE   VIEW vw_exporta_produto
--vw_exporta_produto  
---------------------------------------------------------  
--GBS - Global Business Solution              2003  
--Stored Procedure : Microsoft SQL Server       2003  
--Autor(es)  : Alexandre Del Soldato  
--Banco de Dados : EGISSQL  
--Objetivo  : Exportação do Cadastro de Produtos para Arquivo Magnético  
--Data   : 10/12/2003  
--Histórico : 19/03/2004 - Retirada da ps.dt_usuario para não retornar a data de alteração - Alexandre  
--            22/03/2004 - Usar o nome fantasia ao invés do código do produto - Eduardo      
---------------------------------------------------  
as  
  
  select  
  
    isnull(dbo.fn_data_maior_atual( p.dt_exportacao_registro, p.dt_usuario, pf.dt_usuario, gp.dt_usuario, u.dt_usuario,  
           pc.dt_usuario, t.dt_usuario, ti.dt_usuario, pp.dt_usuario, cf.dt_usuario ), getdate()) as 'DT_ATUAL',      
  
--     p.dt_exportacao_registro as 'dtex',   
--     p.dt_usuario as 'dtp',   
--     pf.dt_usuario as 'dtpf',   
--     gp.dt_usuario as 'dtgp',   
--     u.dt_usuario as 'dtu',  
--     pc.dt_usuario as 'dtpc',   
--     t.dt_usuario as 'dtt',   
--     ti.dt_usuario as 'dtti',   
--     pp.dt_usuario as 'dtpp',   
--     cf.dt_usuario as 'dtcf',  
  
--    p.cd_produto   as 'CODIGO_PRODUTO',  
    p.nm_fantasia_produto as 'CODIGO_PRODUTO',  
  
    replace(replace(replace(p.nm_produto,'.',' '),',',' '), '"',' ') as 'NOME',  
    round(p.vl_produto,2) as 'PRECO',  
    u.sg_unidade_medida  as 'UNIDADE',  
    ISNULL(ps.qt_minimo_produto,0)  as 'ESTOQUE',  
    ISNULL(pc.qt_mes_compra_produto,0) as 'PONTO_REPOSICAO',  
    replace(replace(replace(cast(p.ds_produto as varchar),'.',' '),',',' '), '"',' ')   as 'DESCRICAO',  
    CAST(ISNULL(PP.CD_DIGITO_PROCEDENCIA,'') AS VARCHAR(2)) + CAST(ISNULL(TI.CD_DIGITO_TRIBUTACAO_ICMS,'') AS VARCHAR(3)) AS 'SITUACAO',  
    CF.PC_IPI_CLASSIFICACAO  as 'ALIQUOTA',  
    ''     as 'REDUCAO',  
    dbo.fn_limpa_mascara(CF.CD_MASCARA_CLASSIFICACAO) as 'CLASSIFICACAO_FISCAL',  
    '000'   as 'ESPECIE',  
  
-- Comentado em 10/02/2004  
--     Case  
--       When  ic_producao_produto   = 'S' then 'P'  
--       When  ic_importacao_produto = 'S' then 'I'  
--       When  ic_revenda_produto    = 'S' then 'R'  
--       When  ic_exportacao_produto = 'S' then 'E'  
--       else ''  
--     End as 'TIPO_PRODUTO',  
  
   'I' as 'TIPO_PRODUTO'  
  
-- Comentado em 10/02/2004  
--    p.nm_fantasia_produto as 'CLASSIFICACAO_PRODUTO'  
      
  from Produto p  
  
  left outer join produto_fiscal pf  
 on p.cd_produto = pf.cd_produto  
  
  left outer join Grupo_Produto gp on  
    gp.cd_grupo_produto=p.cd_grupo_produto  
  
  left outer join Unidade_Medida u  
    on u.cd_unidade_medida=p.cd_unidade_medida  
  
  left outer join Produto_Compra pc  
    on pc.cd_produto=p.cd_produto  
  
  left outer join  Produto_Saldo ps  
    on ( ps.cd_produto=p.cd_produto ) and  
       ( ps.cd_fase_produto = dbo.fn_fase_produto( p.cd_produto, 0 ))  
  
  left outer join tributacao t  
 on pf.cd_tributacao = t.cd_tributacao  
  
  left outer join tributacao_icms ti  
 on t.cd_tributacao_icms = ti.cd_tributacao_icms  
  
  left outer join procedencia_produto pp  
 on pf.cd_procedencia_produto = pp.cd_procedencia_produto  
  
  left outer join classificacao_fiscal cf  
        on pf.cd_classificacao_fiscal = cf.cd_classificacao_fiscal  
  
