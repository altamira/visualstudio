
CREATE PROCEDURE pr_consulta_gerador_manutencao
@ic_parametro          integer,
@cd_categoria_contrato integer,
@cd_contrato           integer,
@dt_categoria_contrato DateTime
AS

-------------------------------------------------------------------------------------------
IF @ic_parametro = 1 --Consulta Todos CATEGORIA
-------------------------------------------------------------------------------------------
BEGIN

--select * from tipo_contrato


SELECT 0 as cobrar, 
       (cast (cc.cd_contrato as varchar(10)) + '01' + replace(CONVERT(varchar(10),getdate(),103 ),'/','')) as documento, 
       ccont.sg_categoria_contrato, 
       case when isnull(cc.ic_manut_contr,'N') = 'S' then 'S' else '' end 'ic_manut_contr', 
       c.nm_fantasia_cliente, c.cd_cliente, cc.cd_contrato, 
       case when isnull(cc.ic_manut_contr,'N') = 'S'
            then 0 
           else (isnull(tc.vl_manut_tipo_contrato,ttc.vl_manut_tipo_contrato) * isnull(tc.qt_fator_tipo_contrato,ttc.qt_fator_tipo_contrato)) 
           end                    AS Valor,
       cc.ds_obs_contrato,
       @dt_categoria_contrato AS DataVencimento,tc.sg_tipo_contrato_manut,
       (select max(dt_vencimento) from cobranca_cemiterio where cd_contrato = cc.cd_contrato) as dt_ult_venc,
       cc.cd_tipo_contrato,
       cd_vendedor = ( select top 1 cd_vendedor from Produto_Contrato where cd_contrato = cc.cd_contrato )         
FROM Contrato_Concessao cc
    LEFT JOIN Categoria_Contrato ccont
      ON ccont.cd_categoria_contrato = cc.cd_categoria_contrato 
    LEFT JOIN Cliente c
      ON c.cd_cliente = cc.cd_cliente
    left JOIN Tipo_Contrato tcc            on tcc.cd_tipo_contrato       = cc.cd_tipo_contrato
    LEFT JOIN Tipo_Contrato_Manutencao tc  ON tc.cd_tipo_contrato_manut  = cc.cd_tipo_contrato_manut
    left join Tipo_Contrato_Manutencao ttc on ttc.cd_tipo_contrato_manut = tcc.cd_tipo_contrato_manut
END
--select * from produto_contrato

-------------------------------------------------------------------------------------------
ELSE IF @ic_parametro = 2 --Consulta Somente CATEGORIA informada
-------------------------------------------------------------------------------------------
BEGIN
SELECT 0 as cobrar, 
      (cast (cc.cd_contrato as varchar(10)) + '01' + replace(CONVERT(varchar(10),getdate(),103 ),'/',''))  as Documento, 
       ccont.sg_categoria_contrato, 
       case when isnull(cc.ic_manut_contr,'N') = 'S' then 'S' else '' end 'ic_manut_contr', 
       c.nm_fantasia_cliente, c.cd_cliente, cc.cd_contrato,
       case when isnull(cc.ic_manut_contr,'N') = 'S'
            then 0 
           else (isnull(tc.vl_manut_tipo_contrato,ttc.vl_manut_tipo_contrato) * isnull(tc.qt_fator_tipo_contrato,ttc.qt_fator_tipo_contrato)) 
           end                    AS Valor,
       cc.ds_obs_contrato,
       @dt_categoria_contrato AS DataVencimento,tc.sg_tipo_contrato_manut,
      (select max(dt_vencimento) from cobranca_cemiterio where cd_contrato = cc.cd_contrato) as dt_ult_venc,
       cd_vendedor = ( select top 1 cd_vendedor from Produto_Contrato where cd_contrato = cc.cd_contrato )         
 
FROM Contrato_Concessao cc
    LEFT JOIN Categoria_Contrato ccont
      ON ccont.cd_categoria_contrato = cc.cd_categoria_contrato 
    LEFT JOIN Cliente c
      ON c.cd_cliente = cc.cd_cliente
    left JOIN Tipo_Contrato tcc            on tcc.cd_tipo_contrato       = cc.cd_tipo_contrato
    LEFT JOIN Tipo_Contrato_Manutencao tc  ON tc.cd_tipo_contrato_manut  = cc.cd_tipo_contrato_manut
    left join Tipo_Contrato_Manutencao ttc on ttc.cd_tipo_contrato_manut = tcc.cd_tipo_contrato_manut
WHERE cc.cd_categoria_contrato = @cd_categoria_contrato
END

-------------------------------------------------------------------------------------------
ELSE IF @ic_parametro = 3 --Consulta Numero do Contrato
-------------------------------------------------------------------------------------------
Begin
SELECT 0 as cobrar, 
       (cast (cc.cd_contrato as varchar(10)) + '01' + replace(CONVERT(varchar(10),getdate(),103 ),'/',''))  as Documento,
       ccont.sg_categoria_contrato, 
       case when isnull(cc.ic_manut_contr,'N') = 'S' then 'S' else '' end 'ic_manut_contr',  
       c.nm_fantasia_cliente, c.cd_cliente, cc.cd_contrato, 
       case when isnull(cc.ic_manut_contr,'N') = 'S'
            then 0 
           else (isnull(tc.vl_manut_tipo_contrato,ttc.vl_manut_tipo_contrato) * isnull(tc.qt_fator_tipo_contrato,ttc.qt_fator_tipo_contrato)) 
           end                    AS Valor,
       cc.ds_obs_contrato,
       @dt_categoria_contrato     AS DataVencimento,
       tc.sg_tipo_contrato_manut,
       (select max(dt_vencimento) from cobranca_cemiterio where cd_contrato = cc.cd_contrato) as dt_ult_venc,
       cd_vendedor = ( select top 1 cd_vendedor from Produto_Contrato where cd_contrato = cc.cd_contrato )         

FROM Contrato_Concessao cc
    LEFT JOIN Categoria_Contrato ccont
      ON ccont.cd_categoria_contrato = cc.cd_categoria_contrato 
    LEFT JOIN Cliente c
      ON c.cd_cliente = cc.cd_cliente
    left JOIN Tipo_Contrato tcc            on tcc.cd_tipo_contrato       = cc.cd_tipo_contrato
    LEFT JOIN Tipo_Contrato_Manutencao tc  ON tc.cd_tipo_contrato_manut  = cc.cd_tipo_contrato_manut
    left join Tipo_Contrato_Manutencao ttc on ttc.cd_tipo_contrato_manut = tcc.cd_tipo_contrato_manut
WHERE cc.cd_contrato = @cd_contrato
End
