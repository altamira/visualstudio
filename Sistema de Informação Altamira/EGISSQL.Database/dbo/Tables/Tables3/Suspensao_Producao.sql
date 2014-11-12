CREATE TABLE [dbo].[Suspensao_Producao] (
    [cd_suspensao_producao] INT          NOT NULL,
    [nm_suspensao_producao] VARCHAR (40) NULL,
    [sg_suspensao_producao] CHAR (10)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Suspensao_Producao] PRIMARY KEY CLUSTERED ([cd_suspensao_producao] ASC) WITH (FILLFACTOR = 90)
);

