CREATE TABLE [dbo].[Modalidade_Substituicao] (
    [cd_modalidade]               INT          NOT NULL,
    [nm_modalidade]               VARCHAR (60) NULL,
    [cd_identificacao_modalidade] CHAR (1)     NULL,
    [ds_modalidade]               TEXT         NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    CONSTRAINT [PK_Modalidade_Substituicao] PRIMARY KEY CLUSTERED ([cd_modalidade] ASC)
);

