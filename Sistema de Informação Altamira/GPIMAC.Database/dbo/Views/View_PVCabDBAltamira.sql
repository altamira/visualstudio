




CREATE VIEW [dbo].[View_PVCabDBAltamira]
AS

SELECT     CAST(ISNULL(DBALTAMIRA.dbo.VE_Pedidos.vepe_Pedido, 0 )              AS INT      )   AS VwPVGes0Num, 
           ISNULL(DBALTAMIRA.dbo.VE_Pedidos.vepe_Projeto, '')                                  AS VwPVGes0Prj, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_Pedidos.vepe_Orcamento, 0 )           AS INT      )   AS VwPVGes0Orc, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_Pedidos.vepe_PedidoCliente, '' )      AS CHAR(10) )   AS VwPVGes0PC, 
           ISNULL(DBALTAMIRA.dbo.VE_Pedidos.vepe_TipoPedido, '' )                              AS VwPVGes0TipPed, 
           ISNULL(cast(DBALTAMIRA.dbo.VE_Pedidos.vepe_DataPedido  AS DATETIME ), '1753-01-01') AS VwPVGes0DatPed, 
           ISNULL(CAST(DBALTAMIRA.dbo.VE_Pedidos.vepe_DataEntrega AS DATETIME ), '1753-01-01') AS VwPVGes0DatEnt, 
           ISNULL(DBALTAMIRA.dbo.VE_ClientesNovo.vecl_Codigo,        '' )                      AS VwPVGes0CliCnpj, 
           ISNULL(DBALTAMIRA.dbo.VE_ClientesNovo.vecl_Inscricao,     '' )                      AS VwPVGes0CliIns, 
           ISNULL(DBALTAMIRA.dbo.VE_ClientesNovo.vecl_Abreviado,     '' )                      AS VwPVGes0CliFan, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_ClientesNovo.vecl_Nome,     '' )      AS CHAR(50 ))   AS VwPVGes0CliNom, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_ClientesNovo.vecl_Endereco, '' )      AS CHAR(50 ))   AS VwPVGes0CliEnd, 
           ISNULL(DBALTAMIRA.dbo.VE_ClientesNovo.vecl_Bairro, '' )                             AS VwPVGes0CliBai, 
           ISNULL(DBALTAMIRA.dbo.VE_ClientesNovo.vecl_Cidade, '' )                             AS VwPVGes0CliCid, 
           ISNULL(DBALTAMIRA.dbo.VE_ClientesNovo.vecl_Estado, '' )                             AS VwPVGes0CliUF, 
           ISNULL(DBALTAMIRA.dbo.VE_ClientesNovo.vecl_Cep,    '' )                             AS VwPVGes0CliCEP, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_ClientesNovo.vecl_Contato, '' )       AS CHAR(20 ))   AS VwPVGes0CliCnt, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_ClientesNovo.vecl_Departamento, '' )  AS CHAR(20 ))   AS VwPVGes0CliDep, 
           ISNULL(DBALTAMIRA.dbo.VE_ClientesNovo.vecl_DDD, '' )                                AS VwPVGes0CliTelDDD, 
           ISNULL(DBALTAMIRA.dbo.VE_ClientesNovo.vecl_Telefone, '' )                           AS VwPVGes0CliTelNum, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_ClientesNovo.vecl_Email, '' )         AS CHAR(40 ))   AS VwPVGes0CliEml, 
           ISNULL(DBALTAMIRA.dbo.VE_ClientesNovo.vecl_TipoPessoa, '' )                         AS VwPVGes0CliPes, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_ClientesNovo.vecl_CobEndereco, '' )   AS CHAR(50 ))   AS VwPVGes0CliEndCob, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_ClientesNovo.vecl_CobBairro, '' )     AS CHAR(25 ))   AS VwPVGes0CliBaiCob, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_ClientesNovo.vecl_CobCidade, '' )     AS CHAR(25 ))   AS VwPVGes0CliCidCob, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_ClientesNovo.vecl_CobEstado, '' )     AS CHAR(02 ))   AS VwPVGes0CliUFCob, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_ClientesNovo.vecl_CobCep, '' )        AS CHAR(09 ))   AS VwPVGes0CliCepCob, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_ClientesNovo.vecl_CobDDD, '' )        AS CHAR(04 ))   AS VwPVGes0CliTelDDDCob, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_ClientesNovo.vecl_CobTelefone, '' )   AS CHAR(10 ))   AS VwPVGes0CliTelNumCob, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_ClientesNovo.vecl_CobEmail, '' )      AS CHAR(40 ))   AS VwPVGes0CliEmlCob, 
           ISNULL(DBALTAMIRA.dbo.VE_Representantes.verp_Codigo, '' )                           AS VwPVGes0RepCod, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_Representantes.verp_RazaoSocial, '' ) AS CHAR(50 ))   AS VwPVGes0RepNom, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_Pedidos.vepe_Comissao, 0 )            AS SMALLMONEY ) AS VwPVGes0RepCom, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_Pedidos.vepe_EntEndereco, '' )        AS CHAR(50 ))   AS VwPVGes0CliEndEnt, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_Pedidos.vepe_EntBairro, '' )          AS CHAR(25 ))   AS VwPVGes0CliBaiEnt, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_Pedidos.vepe_EntCidade, '' )          AS CHAR(25 ))   AS VwPVGes0CliCidEnt, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_Pedidos.vepe_EntEstado, '' )          AS CHAR(02 ))   AS VwPVGes0CliUFEnt, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_Pedidos.vepe_EntCEP, '' )             AS CHAR(08 ))   AS VwPVGes0CliCepEnt, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_Pedidos.vepe_EntDDD, '' )             AS CHAR(04 ))   AS VwPVGes0CliTelDDDEnt, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_Pedidos.vepe_EntTelefone, '' )        AS CHAR(10 ))   AS VwPVGes0CliTelNumEnt, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_Pedidos.vepe_EntCGC, '' )             AS CHAR(14 ))   AS VwPVGes0CliCnpjEnt, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_Pedidos.vepe_EntInscricao, '' )       AS CHAR(14 ))   AS VwPVGes0CliInsEnt, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_Acabamento.veac_Descricao, '' )       AS CHAR(46 ))   AS VwPVGes0Aca, 
           ISNULL(DBALTAMIRA.dbo.VE_Montagem.vemo_Descricao, '' )                              AS VwPVGes0Mnt, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_Pedidos.vepe_TipoEmbalagem, '' )      AS CHAR(20 ))   AS VwPVGes0Emb, 
           ISNULL(DBALTAMIRA.dbo.VE_Transporte.vett_Descricao, '' )                            AS VwPVGes0TipTransp, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_Transportadoras.vetr_Nome, '' )       AS CHAR(50 ))   AS VwPVGes0Transp, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_Montador.vemo_Descricao, '' )         AS CHAR(40 ))   AS VwPVGes0Montador, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_Pedidos.vepe_Observacao, '' )         AS CHAR(250))   AS VwPVGes0Obs, 
           ISNULL(DBALTAMIRA.dbo.VE_Pedidos.vepe_AliqICMS, 0)                                  AS VwPVGes0Icms, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_Pedidos.vepe_ValorTabela, 0)          AS MONEY    )   AS VwPVGes0ValVen, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_Pedidos.vepe_ValorServico, 0)         AS MONEY    )  AS VwPVGes0ValSer, 
           CAST((SELECT SUM(VwPVGes1ValIpi) 
                 FROM dbo.View_PVIteDBAltamira 
                 WHERE VwPVGes0Num = DBALTAMIRA.dbo.VE_Pedidos.vepe_Pedido   ) AS MONEY )      AS VwPVGes0ValIPI,
           CAST(ISNULL(DBALTAMIRA.dbo.VE_Pedidos.vepe_Peso, 0 )                AS MONEY    )   AS VwPVGes0Pes, 
           CAST(ISNULL(DBALTAMIRA.dbo.VE_Pedidos.vepe_ValorTabela, 0)          AS MONEY    )   AS VwPVGes0ValTab, 
           CAST(DBALTAMIRA.dbo.VE_Pedidos.vepe_DataSaida                       AS DATETIME )   AS VwPVGes0DatSai, 
           ISNULL(CAST(DBALTAMIRA.dbo.VE_Pedidos.vepe_DataMontagem AS DATETIME ), '1753-01-01') AS VwPVGes0DatMnt
FROM            DBALTAMIRA.dbo.VE_Pedidos 
INNER JOIN      DBALTAMIRA.dbo.VE_ClientesNovo 
ON DBALTAMIRA.dbo.VE_Pedidos.vepe_Cliente        = DBALTAMIRA.dbo.VE_ClientesNovo.vecl_Codigo 
INNER JOIN      DBALTAMIRA.dbo.VE_Representantes 
ON DBALTAMIRA.dbo.VE_Pedidos.vepe_Representante  = DBALTAMIRA.dbo.VE_Representantes.verp_Codigo 
LEFT OUTER JOIN DBALTAMIRA.dbo.VE_Montagem 
ON DBALTAMIRA.dbo.VE_Pedidos.vepe_TipoMontagem   = DBALTAMIRA.dbo.VE_Montagem.vemo_Codigo 
LEFT OUTER JOIN DBALTAMIRA.dbo.VE_Transportadoras 
ON DBALTAMIRA.dbo.VE_Pedidos.vepe_Transportadora = DBALTAMIRA.dbo.VE_Transportadoras.vetr_Codigo 
LEFT OUTER JOIN DBALTAMIRA.dbo.VE_Acabamento 
ON DBALTAMIRA.dbo.VE_Pedidos.vepe_TipoAcabamento = DBALTAMIRA.dbo.VE_Acabamento.veac_Codigo 
LEFT OUTER JOIN DBALTAMIRA.dbo.VE_Transporte 
ON DBALTAMIRA.dbo.VE_Pedidos.vepe_TipoTransporte = DBALTAMIRA.dbo.VE_Transporte.vett_Codigo 
LEFT OUTER JOIN DBALTAMIRA.dbo.VE_Montador 
ON DBALTAMIRA.dbo.VE_Pedidos.vepe_Montador       = DBALTAMIRA.dbo.VE_Montador.vemo_Codigo


GO
GRANT SELECT
    ON OBJECT::[dbo].[View_PVCabDBAltamira] TO [interclick]
    AS [dbo];

