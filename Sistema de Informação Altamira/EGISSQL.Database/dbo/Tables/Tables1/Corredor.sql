CREATE TABLE [dbo].[Corredor] (
    [cd_corredor]               INT          NOT NULL,
    [nm_corredor]               VARCHAR (50) NULL,
    [cd_identificacao_corredor] VARCHAR (15) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Corredor] PRIMARY KEY CLUSTERED ([cd_corredor] ASC) WITH (FILLFACTOR = 90)
);

