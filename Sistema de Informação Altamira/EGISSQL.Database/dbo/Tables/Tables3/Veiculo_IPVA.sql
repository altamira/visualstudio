CREATE TABLE [dbo].[Veiculo_IPVA] (
    [cd_veiculo]              INT        NOT NULL,
    [cd_veiculo_ipva]         INT        NOT NULL,
    [dt_vencto_veiculo_ipva]  DATETIME   NULL,
    [vl_veiculo_ipva]         FLOAT (53) NULL,
    [qt_parcela_veiculo_ipva] INT        NULL,
    [ic_seguro_veiculo_ipva]  CHAR (1)   NULL,
    [cd_usuario]              INT        NULL,
    [dt_usuario]              DATETIME   NULL,
    CONSTRAINT [PK_Veiculo_IPVA] PRIMARY KEY CLUSTERED ([cd_veiculo] ASC, [cd_veiculo_ipva] ASC) WITH (FILLFACTOR = 90)
);

