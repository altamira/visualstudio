CREATE TABLE [dbo].[Contrato_Manutencao] (
    [cd_contrato_manutencao]  INT          NOT NULL,
    [cd_ident_contrato_manut] VARCHAR (20) NOT NULL,
    [dt_contrato_manutencao]  DATETIME     NOT NULL,
    [cd_tipo_contrato]        INT          NOT NULL,
    [dt_ini_contrato_manut]   DATETIME     NOT NULL,
    [dt_fim_contrato_manut]   DATETIME     NOT NULL,
    [ds_contrato_manutencao]  TEXT         NOT NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    CONSTRAINT [PK_Contrato_Manutencao] PRIMARY KEY CLUSTERED ([cd_contrato_manutencao] ASC) WITH (FILLFACTOR = 90)
);

