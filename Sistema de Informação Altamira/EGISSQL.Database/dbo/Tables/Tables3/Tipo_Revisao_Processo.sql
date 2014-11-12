CREATE TABLE [dbo].[Tipo_Revisao_Processo] (
    [cd_tipo_revisao_processo] INT          NOT NULL,
    [nm_tipo_revisao_processo] VARCHAR (40) NULL,
    [sg_tipo_revisao_processo] CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Revisao_Processo] PRIMARY KEY CLUSTERED ([cd_tipo_revisao_processo] ASC) WITH (FILLFACTOR = 90)
);

