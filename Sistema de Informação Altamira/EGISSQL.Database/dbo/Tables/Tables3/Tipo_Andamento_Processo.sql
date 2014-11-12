CREATE TABLE [dbo].[Tipo_Andamento_Processo] (
    [cd_tipo_andamento_processo] INT          NOT NULL,
    [nm_tipo_andamento_processo] VARCHAR (40) NULL,
    [sg_tipo_andamento_processo] CHAR (10)    NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Andamento_Processo] PRIMARY KEY CLUSTERED ([cd_tipo_andamento_processo] ASC) WITH (FILLFACTOR = 90)
);

