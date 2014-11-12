CREATE TABLE [dbo].[SPED_Fiscal_Versao] (
    [cd_versao]        INT          NOT NULL,
    [nm_versao]        VARCHAR (40) NULL,
    [cd_layout_versao] VARCHAR (15) NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_SPED_Fiscal_Versao] PRIMARY KEY CLUSTERED ([cd_versao] ASC) WITH (FILLFACTOR = 90)
);

