CREATE TABLE [dbo].[Tipo_Prioridade] (
    [cd_tipo_prioridade] INT          NOT NULL,
    [nm_tipo_prioridade] VARCHAR (30) NULL,
    [sg_tipo_prioridade] CHAR (10)    NULL,
    [cd_imagem]          INT          NULL,
    [cd_usuario]         INT          NOT NULL,
    [dt_usuario]         DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Prioridade] PRIMARY KEY CLUSTERED ([cd_tipo_prioridade] ASC) WITH (FILLFACTOR = 90)
);

